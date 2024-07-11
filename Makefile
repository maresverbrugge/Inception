# **************************************************************************** #
#                                                                              #
#                                                         :::      ::::::::    #
#    Makefile                                           :+:      :+:    :+:    #
#                                                     +:+ +:+         +:+      #
#    By: mverbrug <mverbrug@student.42.fr>          +#+  +:+       +#+         #
#                                                 +#+#+#+#+#+   +#+            #
#    Created: 2024/07/01 12:22:35 by mverbrug          #+#    #+#              #
#    Updated: 2024/07/11 12:48:42 by mverbrug         ###   ########.fr        #
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

# build or update the docker images reading from docker-compose.yml
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

# stop the running containers without removing them (sends SIGTERM)
# gracefully cleaning up
stop:
	docker-compose -f srcs/docker-compose.yml stop

# immediately and forcecfully kill the running containers and network (sends SIGKILL)
# without cleanup
kill:
	docker-compose -f srcs/docker-compose.yml kill

# stop and remove the containers, network, volumes and images created by up
down:
	docker-compose -f srcs/docker-compose.yml down

# clean and start the containers
re: clean up

# clean the containers
# stop all running containers and remove them.
# remove all images, volumes and networks.
# remove the wordpress and mariadb data directories.
# the (|| true) is used so the Makefile doesn't exit when there's an error:
# if there are no containers running to prevent the make command from stopping.
clean: 
	@docker stop $(LIST_CONTAINERS) || true
	@docker rm $(LIST_CONTAINERS) || true
	@docker rmi -f $(LIST_IMAGES) || true
	@docker volume rm $(LIST_VOLUMES) || true
	@docker network rm $(LIST_NETWORK) 2>/dev/null
	@rm -rf $(WP_DATA) || true
	@rm -rf $(DB_DATA) || true
	@echo "$(BOLD)$(R)Docker containers and volumes deleted!$(RESET)"

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
