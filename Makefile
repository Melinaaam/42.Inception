NAME=inception
COMPOSE=docker-compose -f srcs/docker-compose.yml

up:
	$(COMPOSE) up -d --build
down:
	$(COMPOSE) down

fclean: down
	docker system prune -af
	sudo rm -rf /home/${USER}/data/wordpress /home/${USER}/data/mariadb

rebuild: fclean up

#make up : build et lance ts les containeres
#make down:stop les containers
