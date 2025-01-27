# NGINX Dockerfile

# pull the base image
FROM debian:bullseye

# update and upgrade the system
RUN apt-get update && apt-get upgrade -y

# install the required packages
RUN apt-get install -y nginx openssl

# create the ssl directory
RUN mkdir -p /etc/nginx/ssl

# generate the ssl certificate
RUN openssl req -x509 -nodes -out /etc/nginx/ssl/inception.crt -keyout /etc/nginx/ssl/inception.key -subj "/C=NL/ST=NH/L=AMS/O=CODAM/OU=CODAM/CN=mverbrug.42.fr/UID=mverbrug"

# copy the nginx configuration file
COPY ./conf/nginx.conf /etc/nginx/nginx.conf

# create the wordpress directory
RUN mkdir -p /var/www/wordpress

# change the owner of the wordpress directory to www-data = default for webservers: nginx
RUN chown -R www-data:www-data /var/www/wordpress

# make nginx run in foreground to keep container alive
ENTRYPOINT ["nginx"]
CMD ["-g", "daemon off;"]
