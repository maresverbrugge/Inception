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

LIST_CONTAINERS := $(shell docker ps -a -q)
LIST_VOLUMES := $(shell docker volume ls -q)

all: debian up

up:
		mkdir -p $(HOME)/data/mariadb
		mkdir -p $(HOME)/data/wordpress
		sudo docker-compose -f srcs/docker-compose.yml up --build
		@echo "$(BOLD)$(G) Docker containers now set up!$(RESET)"

stop:
		docker-compose -f srcs/docker-compose.yml stop

kill:
		docker-compose -f srcs/docker-compose.yml kill

reset:
		docker compose -f ./srcs/docker-compose.yml down
		docker rm -f $(LIST_CONTAINERS)
		docker volume rm -f $(LIST_VOLUMES)
		rm -r $(HOME)/data
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