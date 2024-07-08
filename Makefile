# **************************************************************************** #
#                                                                              #
#                                                         :::      ::::::::    #
#    Makefile                                           :+:      :+:    :+:    #
#                                                     +:+ +:+         +:+      #
#    By: mverbrug <mverbrug@student.42.fr>          +#+  +:+       +#+         #
#                                                 +#+#+#+#+#+   +#+            #
#    Created: 2024/07/01 12:22:35 by mverbrug          #+#    #+#              #
#    Updated: 2024/07/01 15:53:44 by mverbrug         ###   ########.fr        #
#                                                                              #
# **************************************************************************** #

WP_DATA = /home/mverbrug/data/wordpress # define the path to the wordpress data
DB_DATA = /home/mverbrug/data/mariadb # define the path to the mariadb data

LIST_CONTAINERS := $(shell docker ps -qa)
LIST_IMAGES := $(shell docker images -qa)
LIST_VOLUMES := $(shell docker volume ls -q)
LIST_NETWORK := $(shell docker network ls -q)

# default target
all: up

# build the containers
build:
	docker-compose -f srcs/docker-compose.yml build

# build the containers
# create the wordpress and mariadb data directories
# start the containers in the background and leave them running
up: build
	@mkdir -p $(WP_DATA)
	@mkdir -p $(DB_DATA)
	docker-compose -f srcs/docker-compose.yml up -d
	@echo "$(BOLD)$(G)Docker containers now set up!$(RESET)"

# start the containers
start:
	docker-compose -f srcs/docker-compose.yml start

# stop the containers
stop:
	docker-compose -f srcs/docker-compose.yml stop

# remove the containers and network
down:
	docker-compose -f srcs/docker-compose.yml down

# kill the containers
kill:
	docker-compose -f srcs/docker-compose.yml kill

# clean and start the containers
re: clean up

# clean the containers
# stop all running containers and remove them.
# remove all images, volumes and networks.
# remove the wordpress and mariadb data directories.
# the (|| true) is used to ignore the error 
# if there are no containers running to prevent the make command from stopping.
clean: 
	@docker stop $(LIST_CONTAINERS) || true
	@docker rm $(LIST_CONTAINERS) || true
	@docker rmi -f $(LIST_IMAGES) || true
	@docker volume rm -f $(LIST_VOLUMES) || true
	@docker network rm -f $(LIST_NETWORK) || true
	@rm -rf $(WP_DATA) || true
	@rm -rf $(DB_DATA) || true
	@echo "$(BOLD)$(R)Docker containers and volumes deleted!$(RESET)"

# prune the containers:
# execute the clean target and remove all 
# containers, images, volumes and networks from the system.
prune: clean
	docker system prune -a --volumes -f

#========================================#
#=============== COLOURS ================#
#========================================#

BOLD      := \033[1m
RESET     := \033[0m
C         := \033[36m
P         := \033[35m
B         := \033[34m
Y         := \033[33m
G         := \033[32m
R         := \033[31m
W         := \033[0m
