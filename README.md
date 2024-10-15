# Relay docker

This is relay infrastructure on docker.

## Services

- admin dashboard
- relay: ./relayer
- web: ./web

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
- `RELAYERS_LIST_FILE_PATH`: List of relayers to connect to.
- `USERS_LIST_FILE_PATH`: List of users available for authentication.
