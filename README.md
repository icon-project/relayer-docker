# Relayer Docker Infrastructure

This repository provides a Docker-based setup for the relayer infrastructure, including the relayer service and the admin dashboard.

## Services

- **Relayer**: Handles the core relay functionality.
- **Admin Dashboard**: Provides a web interface for managing and monitoring the relayer.

## Installation and Usage

### Prerequisites

Ensure that the following are installed on your system:

- **Docker**: [Get Docker](https://docs.docker.com/get-docker/)
- **Docker Compose**: Included with Docker Desktop or install separately for your platform.
- **curl**
- **openssl**

### Quick Start with Install Script

You can quickly set up the relayer infrastructure using the provided install script.

#### Steps

1. **Run the Install Script**

   Execute the following command to download and run the install script:

   ```bash
   curl -L https://raw.githubusercontent.com/icon-project/relayer-docker/main/install.sh | bash

2. Provide Configuration Inputs

    The script will prompt you for the necessary configuration parameters:

    - AWS Credentials:
      - AWS Access Key ID
      - AWS Secret Access Key
      - AWS Default Region (default: us-east-1)

    - Image Versions:
      - Relayer Image Version (default: latest)
      - Dashboard Image Version (default: latest)

    - Restart Policy (default: unless-stopped)

    - Admin Credentials:

      - Admin Email (default: <admin@icon.community>)
      - Admin Password (default: p@ssw0rd)

    - Let's Encrypt Configuration:
      - Enable Let's Encrypt? (yes or no, default: no)

        If enabled:
        - Use Let's Encrypt Staging
          - Environment? (yes or no, default: no)
        - Let's Encrypt Domain
        - Let's Encrypt Email

    - Configuration File Path:
      - Path to config.yaml for the relayer service.

3. Wait for Deployment

    The script will:

    - Check for required commands.
    - Download the docker-compose.yaml file.
    - Generate a secure NEXTAUTH_SECRET.
    - Create a .env file with your configuration.
    - Start the Docker services using Docker Compose.

4. Access the Admin Dashboard

    - If Let's Encrypt is enabled and configured:

      - Access the dashboard at <https://your-domain>

    - If Let's Encrypt is not enabled:
      - Access the dashboard at <http://localhost> or your server's IP address.

### Managing the Services

You can manage the services using Docker Compose commands.

- Check Service Status:

  ```bash
  docker-compose ps
  ```

- View Logs:

  ```bash
  docker-compose logs -f
  ```

- Stop Services:

  ```bash
  docker-compose down
  ```

- Start Services:

  ```bash
  docker-compose up -d
  ```

- Restart Services:

  ```bash
  docker-compose restart
  ```

- Upgrading Services:

  ```bash
  docker-compose pull
  docker-compose up -d
  ```
