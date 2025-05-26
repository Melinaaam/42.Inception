NAME=inception
COMPOSE=docker-compose -f srcs/docker-compose.yml --env-file srcs/.env

up:
	sudo mkdir -p /home/${USER}/data/wordpress
	sudo mkdir -p /home/${USER}/data/mariadb
	$(COMPOSE) up -d --build
down:
	$(COMPOSE) down

clean:
	$(COMPOSE) down --volumes

fclean: clean
	docker system prune -af
	docker volume prune -f
	docker network prune -f
	sudo rm -rf /home/${USER}/data/wordpress /home/${USER}/data/mariadb

re: fclean up

rebuild: fclean up

.PHONY: up down clean fclean re