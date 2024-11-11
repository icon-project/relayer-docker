#!/bin/bash

# Function to check if a command exists
function command_exists() {
    command -v "$1" >/dev/null 2>&1
}

# Check for required commands
REQUIRED_COMMANDS=("curl" "openssl" "docker")
MISSING_COMMANDS=()

for cmd in "${REQUIRED_COMMANDS[@]}"; do
    if ! command_exists "$cmd"; then
        MISSING_COMMANDS+=("$cmd")
    fi
done

# Check for docker-compose or docker compose
if command_exists "docker-compose"; then
    DOCKER_COMPOSE_COMMAND="docker-compose"
elif docker compose version >/dev/null 2>&1; then
    DOCKER_COMPOSE_COMMAND="docker compose"
else
    MISSING_COMMANDS+=("docker-compose or docker compose")
fi

if [ ${#MISSING_COMMANDS[@]} -ne 0 ]; then
    echo "The following required commands are missing:"
    for cmd in "${MISSING_COMMANDS[@]}"; do
        echo " - $cmd"
    done
    echo "Please install them before running this script."
    exit 1
fi

# Check if user is in the docker group
if ! groups $USER | grep &>/dev/null "\bdocker\b"; then
    read -p "User is not in the docker group. Add user to docker group? (yes/no) [no]: " ADD_DOCKER_GROUP
    ADD_DOCKER_GROUP=${ADD_DOCKER_GROUP:-no}
    if [[ "${ADD_DOCKER_GROUP}" == "yes" || "${ADD_DOCKER_GROUP}" == "y" ]]; then
        sudo usermod -aG docker $USER
        echo "User added to docker group. Please log out and log back in for the changes to take effect."
        exit 0
    fi
fi

# Set variables
REPO_URL="https://raw.githubusercontent.com/icon-project/relayer-docker/main"
CONFIG_DIR="${HOME}/relayer-docker-config"
DOCKER_COMPOSE_FILE="docker-compose.yaml"

# Create configuration directory
mkdir -p "${CONFIG_DIR}"

# Download docker-compose.yaml
curl -L "${REPO_URL}/${DOCKER_COMPOSE_FILE}" -o "${CONFIG_DIR}/${DOCKER_COMPOSE_FILE}"

# Prompt user for environment variables

## data directory
read -p "Enter Data Directory [$CONFIG_DIR/.data]: " DATA_DIR
CONFIG=${DATA_DIR:-${CONFIG_DIR}/.data}

# AWS Credentials
read -p "Enter AWS Access Key ID: " AWS_ACCESS_KEY_ID
read -p "Enter AWS Secret Access Key: " AWS_SECRET_ACCESS_KEY
read -p "Enter AWS Default Region [us-east-1]: " AWS_DEFAULT_REGION
AWS_DEFAULT_REGION=${AWS_DEFAULT_REGION:-us-east-1}

# Image Versions
read -p "Enter Relayer Image Version [latest]: " RELAYER_IMAGE_VERSION
RELAYER_IMAGE_VERSION=${RELAYER_IMAGE_VERSION:-latest}

read -p "Enter Dashboard Image Version [latest]: " DASHBOARD_IMAGE_VERSION
DASHBOARD_IMAGE_VERSION=${DASHBOARD_IMAGE_VERSION:-latest}

# Restart Policy
read -p "Enter Restart Policy [unless-stopped]: " RESTART_POLICY
RESTART_POLICY=${RESTART_POLICY:-unless-stopped}

# Admin Credentials
read -p "Enter Admin Email [admin@icon.community]: " DEFAULT_ADMIN_EMAIL
DEFAULT_ADMIN_EMAIL=${DEFAULT_ADMIN_EMAIL:-admin@icon.community}

read -p "Enter Admin Password [p@ssw0rd]: " DEFAULT_ADMIN_PASSWORD
DEFAULT_ADMIN_PASSWORD=${DEFAULT_ADMIN_PASSWORD:-p@ssw0rd}

# Generate NEXTAUTH_SECRET
NEXTAUTH_SECRET=$(openssl rand -hex 32)

# Let's Encrypt Configuration
read -p "Enable Let's Encrypt? (yes/no) [no]: " ENABLE_LETSENCRYPT
ENABLE_LETSENCRYPT=${ENABLE_LETSENCRYPT:-no}
if [[ "${ENABLE_LETSENCRYPT}" == "yes" || "${ENABLE_LETSENCRYPT}" == "y" ]]; then
    ENABLE_LETSENCRYPT=1
    read -p "Use Let's Encrypt Staging Environment? (yes/no) [no]: " LETSENCRYPT_USE_STAGING
    LETSENCRYPT_USE_STAGING=${LETSENCRYPT_USE_STAGING:-no}
    if [[ "${LETSENCRYPT_USE_STAGING}" == "yes" || "${LETSENCRYPT_USE_STAGING}" == "y" ]]; then
        LETSENCRYPT_USE_STAGING=1
    else
        LETSENCRYPT_USE_STAGING=0
    fi
    read -p "Enter Let's Encrypt Domain: " LETSENCRYPT_DOMAIN
    read -p "Enter Let's Encrypt Email: " LETSENCRYPT_EMAIL
    NEXTAUTH_URL="https://${LETSENCRYPT_DOMAIN}"

    # Check if domain DNS is configured correctly
    echo "Checking DNS configuration for ${LETSENCRYPT_DOMAIN}..."
    # Get the public IP address of the server
    PUBLIC_IP=$(curl -s https://ipinfo.io/ip)
    if [ -z "$PUBLIC_IP" ]; then
        echo "Error: Unable to determine public IP address."
        exit 1
    fi

    # Resolve the domain's A record
    DOMAIN_IP=$(dig +short A ${LETSENCRYPT_DOMAIN})
    if [ -z "$DOMAIN_IP" ]; then
        echo "Error: Unable to resolve domain ${LETSENCRYPT_DOMAIN}. Please ensure the domain is configured with an A record."
        exit 1
    fi

    # Compare the IP addresses
    if [[ "$DOMAIN_IP" != "$PUBLIC_IP" ]]; then
        echo "Error: The domain ${LETSENCRYPT_DOMAIN} is not pointing to this server's IP address (${PUBLIC_IP})."
        echo "Please configure your DNS settings to point the domain to ${PUBLIC_IP} and try again."
        exit 1
    else
        echo "Success: The domain ${LETSENCRYPT_DOMAIN} is correctly configured."
    fi
else
    ENABLE_LETSENCRYPT=0
    LETSENCRYPT_USE_STAGING=1
    LETSENCRYPT_DOMAIN=""
    LETSENCRYPT_EMAIL=""
    read -p "Enter NEXTAUTH_URL (e.g., http://your-ip-address): " NEXTAUTH_URL
fi

# RELAYER CONFIG_PATH
read -p "Enter relayer config (path to config.yaml) [$HOME/.centralized-relay/config.yaml]: " CONFIG_PATH
CONFIG_PATH=${CONFIG_PATH:-$HOME/.centralized-relay/config.yaml}

# Check if CONFIG_PATH exists
if [[ ! -f "${CONFIG_PATH}" ]]; then
    echo "Error: Configuration file '${CONFIG_PATH}' does not exist."
    exit 1
fi
echo "Copying ${CONFIG_PATH} to ${CONFIG_DIR}/config.yaml"
cp "${CONFIG_PATH}" "${CONFIG_DIR}/config.yaml"

if [[ -d "$HOME/.centralized-relay/keystore" ]]; then
    read -p "Copy keystore to ${CONFIG}/relayer/keystore? (yes/no) [no]: " COPY_KEYSTORE
    COPY_KEYSTORE=${COPY_KEYSTORE:-no}
    if [[ "${COPY_KEYSTORE}" == "yes" || "${COPY_KEYSTORE}" == "y" ]]; then
        mkdir -p "${CONFIG}/relayer/data"
        cp -R "$HOME/.centralized-relay/keystore" "${CONFIG}/relayer/data"
    fi
fi

# Create .env file
cat <<EOF > "${CONFIG_DIR}/.env"
CONFIG=${CONFIG}
AWS_ACCESS_KEY_ID=${AWS_ACCESS_KEY_ID}
AWS_SECRET_ACCESS_KEY=${AWS_SECRET_ACCESS_KEY}
AWS_DEFAULT_REGION=${AWS_DEFAULT_REGION}
RELAYER_IMAGE_VERSION=${RELAYER_IMAGE_VERSION}
DASHBOARD_IMAGE_VERSION=${DASHBOARD_IMAGE_VERSION}
RESTART_POLICY=${RESTART_POLICY}
DEFAULT_ADMIN_EMAIL=${DEFAULT_ADMIN_EMAIL}
DEFAULT_ADMIN_PASSWORD=${DEFAULT_ADMIN_PASSWORD}
NEXTAUTH_SECRET=${NEXTAUTH_SECRET}
ENABLE_LETSENCRYPT=${ENABLE_LETSENCRYPT}
LETSENCRYPT_USE_STAGING=${LETSENCRYPT_USE_STAGING}
LETSENCRYPT_DOMAIN=${LETSENCRYPT_DOMAIN}
LETSENCRYPT_EMAIL=${LETSENCRYPT_EMAIL}
CONFIG_PATH=${CONFIG_PATH}
NEXTAUTH_URL=${NEXTAUTH_URL}
EOF

# Navigate to configuration directory
cd "${CONFIG_DIR}"

# Run docker compose
${DOCKER_COMPOSE_COMMAND} up -d