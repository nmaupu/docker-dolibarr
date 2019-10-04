#!/bin/sh
set -e

chown -R www-data:www-data /var/www

# Allow using Kube's configmap (symlink makes apache crashing for obscure reasons)
[ -e /config/conf.php ] && cp /config/conf.php /var/www/html/conf/conf.php

exec "$@"
