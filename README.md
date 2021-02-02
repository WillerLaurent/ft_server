# ft_server

## Description

ft_server is a project that asks you to run a server on Debian Buster through Docker with a Wordpress, Phpmyadmin and Mysql runnning.

## Usage

```shell
# Build image
docker build -t ft_server .

# Run image
docker run -tid -p 80:80 -p 443:443 ft_server
```
* SSL auto-certificate is created
* MySQL is automatically created
* Wordpress is automatically setup

## Disable autoindex
```shell
docker run -tid -e AUTOINDEX=OFF -p 80:80 -p 443:443
```

test : localhost/phpmyadmin/templates must display a 403 error


