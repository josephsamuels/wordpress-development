#!/bin/bash

# Setup apache's envvars.
source /etc/apache2/envvars

docker-entrypoint.sh apache2 -D FOREGROUND

# Wait for wordpress-cli to do its job...
while [ ! -f "/usr/local/bin/wp" -a ! -f "wp" ]; do sleep 1; done; sleep 1;

# Verify and move wp to bin.
test -f "wp" && mv /var/www/html/wp /usr/local/bin/

# If wordpress is not installed...
if ! $(wp --allow-root core is-installed); then
  wp --allow-root core install --path="/var/www/html" --url="http://localhost:8080" --title="wp-dev" --admin_user=wordpress --admin_password=wordpress --admin_email=admin@test.com

  wp --allow-root config set WP_DEBUG true --raw
  wp --allow-root config set SCRIPT_DEBUG true --raw
  wp --allow-root config set FS_METHOD direct

  wp --allow-root rewrite structure '/%postname%/' --hard
fi

# Clear out default plugins.
rm -rf wp-content/plugins/akismet
rm -rf wp-content/plugins/hello.php

# Symlink plugins and themes.
/wp-dev/scripts/wordpress-symlink.sh

# Fix permissions for uploading.
chown -R www-data:www-data /var/www/html/wp-content/uploads
chown www-data:www-data /var/www/html/wp-content /var/www/html/wp-content/plugins /var/www/html/wp-content/themes /var/www/html/wp-content/upgrade

# Start Apache.
# apache2 -D FOREGROUND
