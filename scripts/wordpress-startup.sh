#!/bin/bash

find -L /var/www/html/wp-content/plugins -maxdepth 1 -type l -delete
find -L /var/www/html/wp-content/themes -maxdepth 1 -type l -delete

for d in "../plugins/"*
do
  ln -sf $d /var/www/html/wp-content/plugins
done;

for d in "../themes/"*
do
  ln -sf $d /var/www/html/wp-content/themes
done;
