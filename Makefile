
COMPOSE_FILE := ./srcs/docker-compose.yml

DATA_DIR := /home/kecheong/data
WP_FILES_DIR := $(DATA_DIR)/wordpress-files
WP_DB_DIR := $(DATA_DIR)/mariadb-data
REDIS_ADMIN_DIR := $(DATA_DIR)/redis-admin-files
SHOWCASE_SITE_DIR := $(DATA_DIR)/showcase-site-files

all: up

up:
	mkdir -p $(WP_FILES_DIR) $(WP_DB_DIR) $(REDIS_ADMIN_DIR) $(SHOWCASE_SITE_DIR)
	docker compose -f $(COMPOSE_FILE) up

build:
	docker compose -f $(COMPOSE_FILE) build

build_no_cache:
	docker compose -f $(COMPOSE_FILE) build --no-cache

down:
	docker compose -f $(COMPOSE_FILE) down

down_now:
	docker compose -f $(COMPOSE_FILE) down --timeout=0

WORDPRESS_FILES_VOLUME := inception_wordpress-files
WORDPRESS_DB_VOLUME := inception_mariadb-data
REDIS_ADMIN_VOLUME := inception_redis-admin-files
SHOWCASE_SITE_VOLUME := inception_showcase-site-files

clean: down
	docker volume rm $(WORDPRESS_FILES_VOLUME) \
					 $(WORDPRESS_DB_VOLUME) \
					 $(REDIS_ADMIN_VOLUME) \
					 $(SHOWCASE_SITE_VOLUME)
	rm -rf $(WP_FILES_DIR) $(WP_DB_DIR) $(REDIS_ADMIN_DIR) $(SHOWCASE_SITE_DIR)

clean_now: down_now clean

.PHONY: up build down down_now clean
