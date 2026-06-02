COMPOSE_FILE = srcs/docker-compose.yml
DOCKER_COMPOSE = docker compose -f $(COMPOSE_FILE)

all: up

build:
	$(DOCKER_COMPOSE) build

up:
	$(DOCKER_COMPOSE) up -d

down:
	$(DOCKER_COMPOSE) down

clean:
	$(DOCKER_COMPOSE) down -v

fclean:
	$(DOCKER_COMPOSE) down -v
	docker system prune -af --volumes

re: fclean
	$(DOCKER_COMPOSE) up --build -d

.PHONY: all build up down clean fclean re
