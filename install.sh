mysql root -p -e 'CREATE USER "pterodactyl"@"127.0.0.1" IDENTIFIED BY "willow"'
mysql root -p -e 'CREATE DATABASE panel'
mysql root -p -e 'GRANT ALL PRIVLAGES ON panel.* TO "pterodactyl"@"127.0.0.1" WITH GRANT OPTION'

cp .env.panel .env
composer install --no-dev --optimize-autoloader

php artisan key:generate --force

sudo snap install core
sudo snap refresh core

sudo snap install --classic certbot
sudo ln -s /snap/bin/certbot /usr/bin/certbot
sudo certbot certonly --nginx
sudo certbot renew --dry-run

curl -sSL https://get.docker.com/ | CHANNEL=stable bash

mkdir -p /etc/pterodactyl
curl -L -o /usr/local/bin/wings "https://github.com/pterodactyl/wings/releases/latest/download/wings_linux_$([[ "$(uname -m)" == "x86_64" ]] && echo "amd64" || echo "arm64")"
chmod u+x /usr/local/bin/wings