# Developer Documentation

## Environment Setup

### Prerequisites

- A Linux virtual machine with `docker` and `docker compose` installed
- The domain `mbauer.42.fr` must resolve to `127.0.0.1` (add to `/etc/hosts` if needed)
- Git repository cloned to the local machine

### Configuration Files

| File | Purpose |
|------|---------|
| `srcs/.env` | Non-sensitive environment variables (domain, database name, usernames) |
| `srcs/docker-compose.yml` | Service definitions, networks, volumes, and secrets |
| `secrets/*.txt` | Sensitive credentials (passwords) — must never be committed to git |

### Secrets Setup

Create the following files in `secrets/`:

```
secrets/db_password.txt
secrets/db_root_password.txt
secrets/wp_admin_password.txt
secrets/wp_user_password.txt
```

Each file must contain the corresponding password as a single line of text.

## Build and Launch

From the project root:

```bash
make build    # build all Docker images and create data directories
make up       # build (if needed) and start all containers
make          # equivalent to make up
```

The Makefile runs `docker compose` with sudo and passes the `--env-file srcs/.env` flag.

## Managing Containers and Volumes

### Containers

```bash
# List running containers
docker ps

# View logs of a service
docker compose -f srcs/docker-compose.yml logs nginx
docker compose -f srcs/docker-compose.yml logs wordpress
docker compose -f srcs/docker-compose.yml logs mariadb

# Restart a specific service
docker compose -f srcs/docker-compose.yml restart nginx

# Execute commands inside a running container
docker exec -it nginx bash
docker exec -it wordpress bash
docker exec -it mariadb bash
```

### Volumes

```bash
# List named volumes
docker volume ls

# Inspect volume mount point
docker volume inspect inception_wp-volume
docker volume inspect inception_db-volume
```

### Full Cleanup

```bash
make clean    # stops containers and removes all data
make fclean   # stops everything, prunes all Docker resources
```

## Data Persistence

WordPress files and the MariaDB database are stored on the host machine through Docker named volumes:

- **WordPress files**: `/home/mbauer/data/wordpress`
- **Database files**: `/home/mbauer/data/database`

These directories are created automatically by the Makefile via `srcs/requirements/wordpress/tools/make_dir.sh`. The volumes use a local bind-mount driver to write data directly to these host paths, ensuring persistence across container restarts.
