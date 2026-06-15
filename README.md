*This project has been created as part of the 42 curriculum by mbauer.*

## Description

Inception is a system administration project that involves setting up a small infrastructure of Docker containers on a virtual machine. The project uses Docker Compose to orchestrate three services — NGINX, WordPress + PHP-FPM, and MariaDB — each running in its own container built from a custom Dockerfile. Data persistence is handled through Docker named volumes, and all communication between containers occurs over an internal Docker network.

## Instructions

### Prerequisites

- Docker and Docker Compose installed on a Linux virtual machine
- A domain name configured to point to `127.0.0.1` (e.g. `mbauer.42.fr`)

### Build and Run

```bash
make            # builds and starts the project
make build      # builds the images only
make up         # builds and starts the project
make down       # stops the containers
make clean      # stops containers and removes all data
make fclean     # full cleanup of Docker resources
make re         # rebuilds and restarts
```

The website is accessible at `https://mbauer.42.fr`.

## Resources

- Docker documentation: https://docs.docker.com/
- Docker Compose documentation: https://docs.docker.com/compose/
- NGINX official documentation: https://nginx.org/en/docs/
- MariaDB documentation: https://mariadb.com/kb/en/
- WordPress documentation: https://wordpress.org/documentation/
- PHP-FPM documentation: https://www.php.net/manual/en/install.fpm.php
- OpenSSL documentation: https://www.openssl.org/docs/
- 42 Inception subject (2025 version)
- AI was used for most of the research and finding documentation.

## Project Description

### Docker and the Sources

The project uses three custom Docker images built from Debian Bookworm. Each image is tailored to run exactly one service: NGINX handles HTTPS traffic with TLSv1.2/TLSv1.3, WordPress with PHP-FPM serves the dynamic website, and MariaDB stores the database. The `srcs/requirements/` directory contains a subdirectory per service, each holding a Dockerfile, configuration files, and an entrypoint script. Environment variables are stored in `srcs/.env`, and secrets are kept in `secrets/`.

### Virtual Machines vs Docker

Virtual machines run a full guest operating system with a hypervisor-managed kernel, consuming significant CPU, RAM, and disk resources. Each VM includes its own OS, libraries, and binaries. Docker containers share the host kernel and run as isolated processes, making them much lighter and faster to start. Containers package only the application and its dependencies, leading to smaller images and more efficient resource usage.

### Secrets vs Environment Variables

Environment variables stored in `.env` files are loaded into containers at runtime and can be easily inspected. Docker secrets are mounted as temporary files inside the container (e.g. `/run/secrets/db_password`) and are not exposed in process listings or logs. For sensitive data such as passwords, Docker secrets provide a more secure mechanism. In this project, non-sensitive configuration (domain name, database name, usernames) uses environment variables, while all passwords use Docker secrets.

### Docker Network vs Host Network

With `network: host`, a container shares the host's network stack and all ports are directly accessible, bypassing isolation. With a custom Docker network, each container gets its own IP address and can communicate with other containers on the same network through service names. This project uses a dedicated `inception` bridge network, ensuring that containers are isolated from the host network and from each other except for explicit connections through the NGINX entrypoint.

### Docker Volumes vs Bind Mounts

Bind mounts map a host directory directly into a container, making the container dependent on the host filesystem structure. Docker named volumes are managed by Docker and stored in `/var/lib/docker/volumes/` by default. They offer better portability and are the recommended approach for persistent data. This project uses named volumes (`wp-volume` and `db-volume`) with a device driver to store data at `/home/mbauer/data/wordpress` and `/home/mbauer/data/database` on the host.
