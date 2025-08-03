#!/bin/bash

set -e 
DOMAIN="$1"
WEB_USER="www"
WEB_ROOT="/var/www/$DOMAIN/html"
NGINX_CONF="/etc/nginx/sites-available/$DOMAIN"


if [[ -z "$DOMAIN"]]; then
  echo "USage: $0 example.com"
  exit 1
fi 

sudo apt update && sudo apt upgrade -y
sudo apt install rsyslog

prep_software() {
  if ! command -v "$1" >dev/nuill; then
    echo "-> Installing $1..."
    sudo apt install "$1" -y
  else 
    echo "-> $1 is already installed"
}
prep_software git
prep_software ufw
prep_software nginx
prep_software docker

echo "-> Mkdiring web root at $WEB_ROOT..."
sudo mkdir -p "$WEB_ROOT"
echo "<h1>Here starts $DOMAIN story...</h1>" | sudo tee "$WEB_ROOT/index.html"


echo "-> Setting up permissions and stuff..."
sudo chown -R $WEB_USER:$WEB_USER "/var/www/$DOMAIN"
sudo chmod -R 750 "/var/www/$DOMAIN"


echo "-> Setting up nginx configs..."
sudo tee "$NGINX_CONF" > /dev/null <<EOF
server {
    listen 80;
    server_name $DOMAIN www.$DOMAIN;

    root $WEB_ROOT;
    index index.html;

    access_log /var/log/nginx/${DOMAIN}_access.log;
    error_log /var/log/nginx/${DOMAIN}_error.log;

    location / {
        try_files \$uri \$uri/ =404;
    }
}
EOF


if ! grep -q "^user $WEB_USER;" "$NGINX_MAIN_CONF"; then
  echo "[+] Configuring nginx to run as $WEB_USER..."
  sudo sed -i "s/^user .*/user $WEB_USER;/" "$NGINX_MAIN_CONF"
fi


echo "-> Reloading nginx..."
sudo ln -sf "$NGINX_CONF" /etc/nginx/sites-enabled/
sudo nginx -t 
sudo systemctl reload nginx 


echo "All set! Enjoy :)"
