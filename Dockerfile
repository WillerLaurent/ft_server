# **************************************************************************** #
#                                                                              #
#                                                         :::      ::::::::    #
#    Dockerfile                                         :+:      :+:    :+:    #
#                                                     +:+ +:+         +:+      #
#    By: lwiller <lwiller@student.42.fr>            +#+  +:+       +#+         #
#                                                 +#+#+#+#+#+   +#+            #
#    Created: 2021/01/21 08:06:32 by lwiller           #+#    #+#              #
#    Updated: 2021/02/02 08:53:10 by lwiller          ###   ########lyon.fr    #
#                                                                              #
# **************************************************************************** #

FROM debian:buster

# UPDATE AND INSTALL PACKAGES
RUN apt-get update && apt-get install -y \
	vim \
	wget \
	mariadb-server \
    php7.3-fpm \
    php7.3-mysql \
    php7.3 \
	nginx \
	&& rm -rf /var/lib/apt/lists/*

# INSTALL NGINX
COPY ./srcs/index.html /var/www/html/
COPY ./srcs/nginx.conf /etc/nginx/sites-available/localhost
RUN  ln -s /etc/nginx/sites-available/localhost /etc/nginx/sites-enabled/localhost


#INSTALL PHP MYADMIN
RUN wget https://files.phpmyadmin.net/phpMyAdmin/5.0.4/phpMyAdmin-5.0.4-all-languages.tar.gz; \
    tar -xzvf phpMyAdmin-5.0.4-all-languages.tar.gz; \
    mv phpMyAdmin-5.0.4-all-languages/ /var/www/html/phpmyadmin; \
    rm -rf phpMyAdmin-5.0.4-all-languages.tar.gz; \
    sed -i 's/;   extension=mysqli/;  extension=mysqli/g' /etc/php/7.3/fpm/php.ini; \
	sed -i 's:;extension_dir = "./":extension_dir = "/usr/lib/php/20180731":g' /etc/php/7.3/fpm/php.ini
COPY srcs/config.inc.php /var/www/html/phpmyadmin
 
 
#INSTALL WORDPRESS
RUN wget https://wordpress.org/latest.tar.gz && \
    tar -xzvf latest.tar.gz && \
    mv wordpress /var/www/html/ && \
    rm -rf latest.tar.gz
COPY srcs/wp-config.php /var/www/html/wordpress

# SLL
RUN mkdir ~/mkcert && cd ~/mkcert && \
	wget https://github.com/FiloSottile/mkcert/releases/download/v1.4.1/mkcert-v1.4.1-linux-amd64 && \
	mv mkcert-v1.4.1-linux-amd64 mkcert && chmod +x mkcert && \
	./mkcert -install && ./mkcert localhost

# Giving nginx's user-group rights over page files
RUN	chown -R www-data:www-data /var/www/html/*

# Scripts: start.sh 
COPY srcs/start.sh ./

#open port 80 443
EXPOSE 80 443

CMD bash start.sh
