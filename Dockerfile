# Base Image
FROM    debian:buster

# Package setting
RUN     apt-get -y update
RUN		apt-get -y upgrade
RUN		apt-get -y install		\
		nginx					\
		openssl					\
		php-fpm					\
		php-xml					\
		mariadb-server			\
		php-mysql				\
		php-mbstring			\
		vim						\
		wget					\
		zip

# Copy setting files
COPY	./srcs/run.sh			/
COPY 	./srcs/default			/tmp
COPY 	./srcs/wp-config.php	/tmp
COPY 	./srcs/config.inc.php	/tmp

# Port setting
EXPOSE	80 443

# Run shell
CMD		bash run.sh