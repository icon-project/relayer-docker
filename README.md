# Relayer Docker Infrastructure

This repository provides a Docker-based setup for the relayer infrastructure, including the relayer service and the admin dashboard.

## Services

- **Relayer**: Handles the core relay functionality.
- **Admin Dashboard**: Provides a web interface for managing and monitoring the relayer.

## Semver Versioning

The relayer and dashboard services are versioned using [Semantic Versioning](https://semver.org/).

The versioning scheme follows the format `vX.Y.Z`, where:

- `X` is the major version.
- `Y` is the minor version.
- `Z` is the patch version.

### Docker Images

The Docker images are tagged with the version number, e.g., `iconcommunity/centralized-relay:v1.9.6`.

- Relayer: `iconcommunity/centralized-relay`
- Dashboard: `iconcommunity/relayer-admin-dashboard`

The `stable` tag is used for the latest stable release, and the `unstable` tag is used for the latest development version.

## Installation and Usage

The relayer infrastructure can be set up using the provided install script or manually using Docker Compose.

### Prerequisites

If you're migrating relayer from previous systemctl based deployment, you can continue from the steps below.

  Otherwise, if you're setting up for the first time, please follow the [KMS](https://github.com/icon-project/centralized-relay/wiki/KMS#aws-kms) for setting up the KMS first and then follow the below steps.

#### Required Software

- **Docker**: [Get Docker](https://docs.docker.com/engine/install/)
- **Docker Compose**: Included with Docker setup or [install separately](https://docs.docker.com/compose/install/)
- **curl** (pre-installed on most systems)
- **openssl** (pre-installed on most systems)

#### Ports Required

Following ports are required to be open on the server:

- **HTTP**: `80`
- **HTTPS**: `443`

#### Is a Domain Required?

  If you plan to use Let's Encrypt for SSL certificates, you must have a registered domain name with DNS records correctly pointing to your server's IP address. This is necessary for Let's Encrypt to verify your domain and issue SSL certificates.

  If you do not have a domain, self-signed certificates will be automatically generated and used for SSL.

  While using Let's Encrypt is not strictly necessary, it is recommended for production environments to secure communication between the client and the server with valid SSL certificates.

### Quick Start with Install Script

You can quickly set up the relayer infrastructure using the provided install script.

#### Steps

1. **Run the Install Script**

   Execute the following command to download and run the install script:

   ```bash
   curl -L https://raw.githubusercontent.com/icon-project/relayer-docker/main/install.sh -o /tmp/install.sh && bash /tmp/install.sh
   ```

2. Provide Configuration Inputs

    The script will prompt you for the necessary configuration parameters:

    - AWS Credentials:
      - AWS Access Key ID [ optional ]
      - AWS Secret Access Key [ optional ]
      - AWS Default Region (default: `us-east-1`)

    - Image Versions:
      - Relayer Image Version (default: `latest`)
      - Dashboard Image Version (default: `latest`)

    - Restart Policy (default: `unless-stopped`)

    - Admin Credentials:

      - Admin Email (default: <`admin@icon.community`>)
      - Admin Password (default: `p@ssw0rd`)

    - Let's Encrypt Configuration:
      - Enable Let's Encrypt? (`yes` or `no`, default: `no`)

        If enabled:
        - Use Let's Encrypt Staging
          - Environment? (`yes` or `no`, default: `no`)
        - Let's Encrypt Domain
        - Let's Encrypt Email

    - Configuration File Path:
      - Path to `config.yaml` for the relayer service.

3. Wait for Deployment

    The script will:

    - Check for required commands.
    - Download the `docker-compose.yaml` file.
    - Generate a secure `NEXTAUTH_SECRET`.
    - Create a `.env` file with your configuration.
    - Start the Docker services using Docker Compose.

4. Access the Admin Dashboard

    - If Let's Encrypt is enabled and configured:

      - Access the dashboard at `https://your-domain`

    - If Let's Encrypt is not enabled:
      - Access the dashboard at <https://localhost> or your server's IP address.

### Managing the Services

The `crly` script is a command-line utility that simplifies managing the relayer and admin dashboard services.

It provides commands to `start`, `stop`, `upgrade`, `restart`, `logs` and `verify` the services.

#### Installation of `crly`

1. Download the `crly` script:

   ```bash
   curl -L https://raw.githubusercontent.com/icon-project/relayer-docker/main/crly -o crly && chmod +x crly
   ```

2. Move the script to a directory in your PATH:

  ```bash
  sudo mv crly /usr/local/bin
  ```

3. Verify the installation:

  ```bash
  crly --version
  ```

#### Usage

- **Help**:

  ```bash
  crly --help
  ```

#### Commands

- [action]: `start`, `stop`, `upgrade`, `verify`, `restart` `logs`
- [service]: `relayer`, `dashboard`

When no action is provided, the script will execute arbitrary commands on
the relayer service container.

When no service is provided, the script will execute the action on both the
relayer and dashboard services.

- **Perform an Action**:

  ```bash
  crly [action] [service] [version]
  ```

- Execute a arbitrary command on the relayer service:

  ```bash
  crly db messages list
  ```

- Verify the services:

  ```bash
  crly verify relayer v1.9.6
  ```
