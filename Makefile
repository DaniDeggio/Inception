# **************************************************************************** #
#                                                                              #
#                                                         :::      ::::::::    #
#    Makefile                                           :+:      :+:    :+:    #
#                                                     +:+ +:+         +:+      #
#    By: dde-giov <dde-giov@student.42roma.it>      +#+  +:+       +#+         #
#                                                 +#+#+#+#+#+   +#+            #
#    Created: 2024/11/25 17:46:13 by dde-giov          #+#    #+#              #
#    Updated: 2024/11/25 18:26:58 by dde-giov         ###   ########.fr        #
#                                                                              #
# **************************************************************************** #

NAME	= Inception

# persistent data
WP_DIR = ~/data/wordpress 
DB_DIR = ~/data/mariadb

USER := $(shell whoami)

RM := sudo rm -f

# COLORS
CLR_RMV := \033[0m
RED := \033[1;31m
GREEN := \033[1;32m
YELLOW := \033[1;33m
BLUE := \033[1;34m
CYAN := \033[1;36m

DKCMP :=	docker compose -f
CMPYML :=	./srcs/docker-compose.yml

all: $(NAME)

$(NAME):
	@echo "$(GREEN)Starting building $(CLR_RMV)of $(YELLOW)$(NAME) $(CLR_RMV)..."
	$(DKCMP) $(CMPYML) build
	
	@echo "$(GREEN)Creating data directories: $(CLR_RMV) $(YELLOW)$(WP_DIR) and $(DB_DIR)$(CLR_RMV)"
	@mkdir -p $(WP_DIR)
	@mkdir -p $(DB_DIR)

	$(DKCMP) $(CMPYML) up -d
	@echo "$(GREEN)$(NAME) started [0m ✔️"

clean:
	@echo "$(RED)Stopping containers $(CLR_RMV)"
	@docker stop $$(docker ps -qa) || true
	
	@echo "$(RED)Removing containers $(CLR_RMV)"
	@docker rm $$(docker ps -qa) || true
	@docker rmi -f $$(docker images -qa) || true
	
	@echo "$(RED)Removing volumes $(CLR_RMV)"
	@docker volume rm $$(docker volume ls -q) || true

	@echo "$(RED)Removing networks $(CLR_RMV)"
	@docker network rm $$(docker network ls -q) || true

	@echo "$(RED)Removing data directories $(CLR_RMV)"
	@$(RM) $(WP_DIR) || true
	@$(RM) $(DB_DIR) || true

prune: clean # clean and remove unused containers, images, volumes and networks
	@docker system prune -a --volumes -f

down:
	@echo "$(RED)Stopping containers $(CLR_RMV)"
	$(DKCMP) $(CMPYML) down

re: clean all

fix-permissions:
	@echo "$(CYAN)Configuring Docker to run without sudo...$(CLR_RMV)"
	@if ! getent group docker > /dev/null; then \
		echo "$(YELLOW)Creating Docker group...$(CLR_RMV)"; \
		sudo groupadd docker; \
	else \
		echo "$(GREEN)Docker group already exists$(CLR_RMV)"; \
	fi
	@if ! groups $(USER) | grep -q docker; then \
		echo "$(YELLOW)Adding user $(USER) to Docker group...$(CLR_RMV)"; \
		sudo usermod -aG docker $(USER); \
		echo "$(YELLOW)Please log out and log back in for the group changes to take effect.$(CLR_RMV)"; \
	else \
		echo "$(GREEN)User $(USER) is already in the Docker group$(CLR_RMV)"; \
	fi

.PHONY: all clean prune down re fix-permissions
