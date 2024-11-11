# Relayer Docker Infrastructure

This repository provides a Docker-based setup for the relayer infrastructure, including the relayer service and the admin dashboard.

## Services

- **Relayer**: Handles the core relay functionality.
- **Admin Dashboard**: Provides a web interface for managing and monitoring the relayer.

## Installation and Usage

### Prerequisites

#### Required Software

- **Docker**: [Get Docker](https://docs.docker.com/engine/install/)
- **Docker Compose**: Included with Docker setup or [install separately](https://docs.docker.com/compose/install/)
- **curl** (pre-installed on most systems)
- **openssl** (pre-installed on most systems)

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
