FROM linuxconfig/nginx
MAINTAINER Lubos Rendek <web@linuxconfig.org>

ENV DEBIAN_FRONTEND noninteractive

# Main package installation
RUN apt-get update
RUN apt-get -y install supervisor mysql-server git-core

# Compile and Install PHP
RUN git clone https://github.com/linuxconfig/compile-php-debian.git
RUN cd compile-php-debian; ./install_php.sh 7.1.0

# Nginx configuration
ADD default /etc/nginx/sites-available/

# PHP FastCGI script
ADD php-fcgi /usr/local/sbin/
RUN chmod o+x /usr/local/sbin/php-fcgi

# Daemonize php-fpm
RUN sed -i '2 i\daemonize = no' /usr/local/php*/etc/php-fpm.conf

# Supervisor configuration files
ADD supervisord.conf /etc/supervisor/
ADD supervisor-lemp.conf /etc/supervisor/conf.d/

# Basic PHP website
ADD index.php /var/www/html/

# Create new MySQL admin user
RUN service mysql start; mysql -u root -e "CREATE USER 'admin'@'%' IDENTIFIED BY 'pass';";mysql -u root -e "GRANT ALL PRIVILEGES ON *.* TO 'admin'@'%' WITH GRANT OPTION;";

# MySQL configuration
RUN sed -i 's/bind-address/#bind-address/' /etc/mysql/my.cnf

EXPOSE 80 3306

CMD ["supervisord"]
