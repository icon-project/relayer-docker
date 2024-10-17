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

## Configuration

Dashboard configuration such as user authentication and relayers can be configured using the json configuration files.

### Relayers

The example of the inter-connected relayers configuration file is as follows:

```json
[{
  "id": "lydialabs",
  "name": "LydiaLabs",
  "host": "http://localhost:3000",
  "auth": {
    "email": "admin@venture23.io",
    "password": "password"
  }
}]
```

`id`: The unique identifier for the relayer.
`name`: The name of the relayer.
`host`: The host or the ip address of the relayer.
`auth`: The authentication credentials for the relayer.

### Users

The example of the users configuration file is as follows:

```json
[{
  "id": 1,
  "email": "admin@venture23.io",
  "avatar": "http://localhost:3000/assets/avatar1.png",
  "password": "password",
  "company": "Venture23 Inc.",
  "designation": "None"
}]
```

`id`: The unique identifier for the user.
`email`: The email of the user.
`avatar`: The avatar of the user.
