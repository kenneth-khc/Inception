
COMPOSE_FILE := ./srcs/docker-compose.yml

up:
	docker compose -f $(COMPOSE_FILE) up

build:
	docker compose -f $(COMPOSE_FILE) build

down:
	docker compose -f $(COMPOSE_FILE) down

down_now:
	docker compose -f $(COMPOSE_FILE) down --timeout=0

WORDPRESS_FILES_VOLUME := inception_wordpress-files
WORDPRESS_DB_VOLUME := inception_db-data

clean: down
	docker volume rm $(WORDPRESS_FILES_VOLUME) $(WORDPRESS_DB_VOLUME)

.PHONY: up build down down_now clean
