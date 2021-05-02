#!/bin/bash

# Clear existing symlinks.
find /var/www/html/wp-content/plugins -type l -delete
find /var/www/html/wp-content/themes -type l -delete

# Symlink plugins.
for file in /wp-dev/plugins/*; do
  if [ -d $file ] || [ -f $file ]; then
    ln -s "$file" /var/www/html/wp-content/plugins
  fi
done

# Symlink themes.
for file in /wp-dev/themes/*; do
  if [ -d $file ] || [ -f $file ]; then
    ln -s "$file" /var/www/html/wp-content/themes
  fi
done
