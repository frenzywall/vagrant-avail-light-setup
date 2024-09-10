#!/bin/bash

echo "Updating package lists and installing required dependencies..."
sudo apt-get update --fix-missing
sudo apt-get install -y git curl build-essential unzip tar nginx

echo "Installing Rust..."
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y
source $HOME/.cargo/env

echo "Downloading and extracting Avail light-client..."
curl -L -o avail-light-client.tar.gz https://github.com/availproject/avail-light/releases/download/avail-light-client-v1.11.1/avail-light-linux-amd64.tar.gz
tar -xzf avail-light-client.tar.gz

echo "Moving Avail light-client to /usr/local/bin..."
sudo mv avail-light-linux-amd64 /usr/local/bin/

echo "Setting execute permissions on the binary..."
sudo chmod +x /usr/local/bin/avail-light-linux-amd64
sudo mkdir -p /var/lib/avail-light-client
sudo chown -R vagrant:vagrant /var/lib/avail-light-client

echo "Building and starting Avail light-client..."
/usr/local/bin/avail-light-linux-amd64 --network mainnet --http-server-port 9933 --port 9615 > avail-light-client.log 2>&1 &

echo "Checking if Avail light-client is running..."
sleep 5
ps aux | grep avail-light-linux-amd64

echo "Configuring Nginx as a reverse proxy..."
sudo tee /etc/nginx/sites-available/avail-light-client <<EOF
server {
    listen 80;
    server_name localhost;

    location /api {
        proxy_pass http://localhost:9933;
        proxy_set_header Host \$host;
        proxy_set_header X-Real-IP \$remote_addr;
        proxy_set_header X-Forwarded-For \$proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto \$scheme;
    }

    location /metrics {
        proxy_pass http://localhost:9615;
        proxy_set_header Host \$host;
        proxy_set_header X-Real-IP \$remote_addr;
        proxy_set_header X-Forwarded-For \$proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto \$scheme;
    }
}
EOF

sudo ln -s /etc/nginx/sites-available/avail-light-client /etc/nginx/sites-enabled/
sudo nginx -t
sudo systemctl reload nginx

echo "Setup complete. Avail Light Client is running and Nginx is configured."
