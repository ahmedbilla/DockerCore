NAME	= inception

SRCS	= ./srcs/docker-compose.yml

DATA_DIR = /home/ahbilla/data


all: $(NAME)

$(NAME):
	@mkdir -p $(DATA_DIR)/mariadb $(DATA_DIR)/wordpress
	docker-compose -f $(SRCS) up -d --build

down:
	docker-compose -f $(SRCS) down

clean: down
	docker system prune -a

fclean:
	docker-compose -f $(SRCS) down -v --rmi all
	docker system prune --all --volumes --force
	@rm -rf $(DATA_DIR)/mariadb $(DATA_DIR)/wordpress

re: fclean all

.PHONY: all down clean fclean re
