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

WP_DATA = /home/mverbrug/data/wordpress
DB_DATA = /home/mverbrug/data/mariadb

LIST_CONTAINERS := $(shell docker ps -a -q)
LIST_IMAGES := $(shell docker images -a -q)
LIST_VOLUMES := $(shell docker volume ls -q)
LIST_NETWORK := $(shell docker network ls -q)

all: debian up

up:		build
		mkdir -p $(WP_DATA)
		mkdir -p $(DB_DATA)
		docker-compose -f srcs/docker-compose.yml up
		@echo "$(BOLD)$(G) Docker containers now set up!$(RESET)"

build:
		docker-compose -f srcs/docker-compose.yml build

stop:
		docker-compose -f srcs/docker-compose.yml stop

kill:
		docker-compose -f srcs/docker-compose.yml kill

reset:
		docker compose -f ./srcs/docker-compose.yml down
		docker rm $(LIST_CONTAINERS) || true
		docker rmi -f $(LIST_IMAGES) || true
		docker volume rm -f $(LIST_VOLUMES) || true
		docker network rm -f $(LIST_NETWORK) || true
		rm -rf $(WP_DATA) || true
		rm -rf $(DB_DATA) || true
		@echo "$(BOLD)$(R) Docker containers and volumes deleted!$(RESET)"

debian: 
		docker pull debian:bullseye

re : reset up

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