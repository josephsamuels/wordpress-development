#!/bin/bash

# Wait for wordpress-cli to do its job...
while [ ! -f "/usr/local/bin/wp" -a ! -f "wp" ]; do sleep 1; done; sleep 1;

# Verify and move wp to bin.
test -f "wp" && mv /var/www/html/wp /usr/local/bin/

# If wordpress is not installed...
if ! $(wp --allow-root core is-installed); then
  wp --allow-root core install --path="/var/www/html" --url="http://localhost:8080" --title="wpdev" --admin_user=wordpress --admin_password=wordpress --admin_email=admin@test.com

  wp --allow-root config set WP_DEBUG true --raw
  wp --allow-root config set SCRIPT_DEBUG true --raw
fi

# Clear out default plugins.
rm -rf wp-content/plugins/akismet
rm -rf wp-content/plugins/hello.php

# Clear existing symlinks.
find /var/www/html/wp-content/plugins -type l -delete
find /var/www/html/wp-content/themes -type l -delete

# Symlink plugins.
for file in /wp-dev/plugins/*; do
  ln -s "$file" /var/www/html/wp-content/plugins
done

# Symlink themes.
for file in /wp-dev/themes/*; do
  ln -s "$file" /var/www/html/wp-content/themes
done

# Fix permissions for uploading.
chown -R www-data:www-data /var/www/html/wp-content/uploads
chown www-data:www-data /var/www/html/wp-content /var/www/html/wp-content/plugins /var/www/html/wp-content/themes /var/www/html/wp-content/upgrade

# Setup apache's envvars.
source /etc/apache2/envvars

# Start Apache.
apache2 -D FOREGROUND
