NAME = inception
DOCKER_COMPOSE = srcs/docker-compose.yml
DATA_PATH = /home/$(USER)/data

all: setup build up

setup:
	@sudo mkdir -p $(DATA_PATH)/wordpress
	@sudo mkdir -p $(DATA_PATH)/mariadb
	@if ! grep -q "127.0.0.1 $(USER).42.fr" /etc/hosts; then \
		echo "127.0.0.1 $(USER).42.fr" | sudo tee -a /etc/hosts; \
	fi

build:
	docker-compose -f $(DOCKER_COMPOSE) build

up:
	docker-compose -f $(DOCKER_COMPOSE) up -d

down:
	docker-compose -f $(DOCKER_COMPOSE) down

clean: down
	docker system prune -a

fclean: clean
	sudo rm -rf $(DATA_PATH)
	@if [ $$(docker volume ls -q | wc -l) -gt 0 ]; then \
		docker volume rm -f $$(docker volume ls -q); \
	else \
		echo "No volumes to remove"; \
	fi

re: fclean all

.PHONY: all setup build up down clean fclean re