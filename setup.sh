php artisan p:enviroment:setup
php artisan p:enviroment:DATABASE

php artisan migrate --seed --force

php artisan p:user:make

chown -R www-data:www-data /var/www/pterodactyl/*

sudo crontab -l | { cat; echo "* * * * * php /var/www/pterodactyl/artisan schedule:run >> /dev/null 2>&1"; } | sudo crontab -

cat <<FILE > /etc/systemd/system/pteroq.service
# Pterodactyl Queue Worker File
# ----------------------------------
[Unit]
Description=Pterodactyl Queue Worker
After=redis-server.service

[Service]
# On some systems the user and group might be different.
# Some systems use `apache` or `nginx` as the user and group.
User=www-data
Group=www-data
Restart=always
ExecStart=/usr/bin/php /var/www/pterodactyl/artisan queue:work --queue=high,standard,low --sleep=3 --tries=3
StartLimitInterval=180
StartLimitBurst=30
RestartSec=5s

[Install]
WantedBy=multi-user.target
FILE

sudo systemctl enable --now redis-server
sudo systemctl enable --now pteroq.service
systemctl enable --now docker

cat <<FILE > /etc/systemd/system/wings.service
[Unit]
Description=Pterodactyl Wings Daemon
After=docker.service
Requires=docker.service
PartOf=docker.service

[Service]
User=root
WorkingDirectory=/etc/pterodactyl
LimitNOFILE=4096
PIDFile=/var/run/wings/daemon.pid
ExecStart=/usr/local/bin/wings
Restart=on-failure
StartLimitInterval=180
StartLimitBurst=30
RestartSec=5s

[Install]
WantedBy=multi-user.target
FILE