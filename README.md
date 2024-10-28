# Relay docker

This is relay infrastructure on docker.

## Services

- relay: ./relayer
- admin dashboard: ./admin-dashboard

## How to use

  1. Prepare the environment file `.env` in the root directory. You can use the `.env.example` file as a template.
  2. Run the following command to start the relay infrastructure.

  ```bash
    docker-compose up -d
  ```

## Environment variables

- `CONFIG`: The path to the configuration and data directory. Default: `/.data`
- `NEXTAUTH_SECRET`: The secret key for NextAuth.js
- `ENABLE_LETSENCRYPT`: Enable Let's Encrypt. Default: `false`
- `LETSENCRYPT_DOMAIN`: The domain for Let's Encrypt
- `LETSENCRYPT_EMAIL`: The email for Let's Encrypt
- `NEXT_XCALLSCAN_BASE_URL`: Xcall scan api to use: default: `https://xcallscan.xyz/api`
- `AWS_ACCESS_KEY_ID`: AWS access key id [optional]
- `AWS_SECRET_ACCESS_KEY`: AWS secret access key [optional]
- `AWS_DEFAULT_REGION`: AWS region [ default: `us-east-1`]
