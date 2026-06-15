# User Documentation

## Services Provided

The Inception stack provides three services:

- **NGINX** — acts as the sole entry point to the infrastructure. It handles HTTPS connections using TLSv1.2/TLSv1.3 and serves the WordPress site on port 443.
- **WordPress + PHP-FPM** — runs the WordPress CMS with PHP-FPM. It processes PHP requests and generates the dynamic web pages.
- **MariaDB** — stores the WordPress database, including posts, users, comments, and site settings.

## Start and Stop the Project

From the project root:

```bash
make        # build and start everything
make down   # stop all containers
make clean  # stop containers and delete all data
```

## Access the Website and Administration Panel

- **Website**: https://mbauer.42.fr
- **Administration panel**: https://mbauer.42.fr/wp-admin

## Credentials

Credentials are stored in the `secrets/` directory and are read-only inside containers via Docker secrets mounted at `/run/secrets/`.

| Role          | Username     | Password location                   |
|---------------|--------------|-------------------------------------|
| WordPress admin | mbauer     | `secrets/wp_admin_password.txt`     |
| WordPress user  | user42     | `secrets/wp_user_password.txt`      |
| Database user   | wpuser     | `secrets/db_password.txt`           |
| Database root   | root       | `secrets/db_root_password.txt`      |

## Check That Services Are Running

```bash
docker compose -f srcs/docker-compose.yml ps
```

Expected output shows all three containers with status `Up`:

```
NAME        IMAGE          STATUS          PORTS
nginx       nginx:1.0      Up ...          0.0.0.0:443->443/tcp
wordpress   wordpress:1.0  Up ...          9000/tcp
mariadb     mariadb:1.0    Up ...          3306/tcp
```
