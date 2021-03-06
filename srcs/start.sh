
#bash change_autoindex.sh

service php7.3-fpm start

service mysql start

echo "CREATE DATABASE IF NOT EXISTS wordpress;" | mysql -u root --skip-password
echo "GRANT ALL PRIVILEGES ON wordpress.* TO 'root'@'localhost';" | mysql -u root --skip-password
echo "FLUSH PRIVILEGES;" | mysql -u root --skip-password
echo "update mysql.user set plugin = 'mysql_native_password' where user='root';" | mysql -u root

if [ "$AUTOINDEX" = "OFF" ]
then
echo "autoindex"
	chmod +w  /etc/nginx/sites-available/localhost
	sed -i 's/autoindex on;/autoindex off;/g' /etc/nginx/sites-available/localhost
fi

service nginx start
sleep infinity

