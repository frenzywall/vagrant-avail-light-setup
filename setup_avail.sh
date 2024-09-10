# #!/bin/bash

# sudo apt-get update --fix-missing
# sudo apt-get install -y git curl build-essential unzip tar wget ufw

# nohup curl -sL1 avail.sh | bash -s -- --network mainnet --http-server-port 9933 --port 9615 > avail-client.log 2>&1 &


# ps aux | grep avail-light-client

# sudo lsof -i -P -n | grep LISTEN

# sudo ufw allow 9933/tcp
# sudo ufw allow 9615/tcp

# sudo ufw status

# curl http://localhost:9933/api
# curl http://localhost:9615/metrics

# echo "Setup complete. Avail Light Client is running and accessible."




# #!/bin/bash

# echo "Updating package lists and installing required dependencies..."
# sudo apt-get update --fix-missing
# sudo apt-get install -y git curl build-essential unzip tar nginx cargo

# echo "Cloning Avail Light Client repository..."
# git clone https://github.com/availproject/avail-light.git
# cd avail-light

# echo "Building Avail Light Client..."
# cargo build --release

# echo "Moving Avail Light Client binary to /root/avail-light/target/release/avail-light..."
# sudo mkdir -p /root/avail-light/target/release
# sudo mv target/release/avail-light /root/avail-light/target/release/avail-light

# echo "Creating a systemd service for Avail Light Client..."
# sudo tee /etc/systemd/system/availightd.service > /dev/null <<EOF
# [Unit]
# Description=Avail Light Client
# After=network.target
# StartLimitIntervalSec=0

# [Service]
# User=root
# ExecStart=/root/avail-light/target/release/avail-light --network goldberg
# Restart=always
# RestartSec=120

# [Install]
# WantedBy=multi-user.target
# EOF

# echo "Registering and starting Avail Light Client service..."
# sudo systemctl daemon-reload
# sudo systemctl enable availightd
# sudo systemctl restart availightd

# echo "Checking if Avail Light Client service is running..."
# sleep 5
# sudo systemctl status availightd

# echo "Configuring Nginx as a reverse proxy..."
# sudo tee /etc/nginx/sites-available/avail-light-client <<EOF
# server {
#     listen 80;
#     server_name localhost;

#     location /api {
#         proxy_pass http://localhost:9933;
#         proxy_set_header Host \$host;
#         proxy_set_header X-Real-IP \$remote_addr;
#         proxy_set_header X-Forwarded-For \$proxy_add_x_forwarded_for;
#         proxy_set_header X-Forwarded-Proto \$scheme;
#     }

#     location /metrics {
#         proxy_pass http://localhost:9615;
#         proxy_set_header Host \$host;
#         proxy_set_header X-Real-IP \$remote_addr;
#         proxy_set_header X-Forwarded-For \$proxy_add_x_forwarded_for;
#         proxy_set_header X-Forwarded-Proto \$scheme;
#     }
# }
# EOF

# sudo ln -s /etc/nginx/sites-available/avail-light-client /etc/nginx/sites-enabled/
# sudo nginx -t
# sudo systemctl reload nginx

# echo "Setup complete. Avail Light Client is running, and Nginx is configured."

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
# !/bin/bash

# Update package lists and install required dependencies
# echo "Updating package lists and installing required dependencies..."
# sudo apt-get update --fix-missing
# sudo apt-get install -y git curl build-essential unzip tar nginx cargo

# # Clone the Avail Light Client repository and build it from source
# echo "Cloning Avail Light Client repository..."
# git clone https://github.com/availproject/avail-light.git
# cd avail-light

# echo "Building Avail Light Client..."
# cargo build --release

# # Move the resulting binary to /usr/local/bin
# echo "Moving Avail Light Client binary to /usr/local/bin..."
# sudo mv target/release/avail-light /usr/local/bin/avail-light-client

# # Set execute permissions on the binary
# echo "Setting execute permissions on the binary..."
# sudo chmod +x /usr/local/bin/avail-light-client

# # Create a directory for the client data
# echo "Creating directory for Avail Light Client data..."
# sudo mkdir -p /var/lib/avail-light-client
# sudo chown -R vagrant:vagrant /var/lib/avail-light-client

# # Create a systemd service for the Avail Light Client
# echo "Creating a systemd service for Avail Light Client..."
# sudo tee /etc/systemd/system/avail-light-client.service <<EOF
# [Unit]
# Description=Avail Light Client
# After=network.target

# [Service]
# ExecStart=/usr/local/bin/avail-light-client --network mainnet --http-server-port 9933 --port 9615
# Restart=always
# User=vagrant
# WorkingDirectory=/var/lib/avail-light-client

# [Install]
# WantedBy=multi-user.target
# EOF

# # Reload systemd and start the service
# echo "Starting and enabling Avail Light Client service..."
# sudo systemctl daemon-reload
# sudo systemctl start avail-light-client
# sudo systemctl enable avail-light-client

# # Verify the service is running
# echo "Checking if Avail Light Client is running..."
# sleep 5
# ps aux | grep avail-light-client

# # Configure Nginx as a reverse proxy
# echo "Configuring Nginx as a reverse proxy..."
# sudo tee /etc/nginx/sites-available/avail-light-client <<EOF
# server {
#     listen 80;
#     server_name localhost;

#     location /api {
#         proxy_pass http://localhost:9933;
#         proxy_set_header Host \$host;
#         proxy_set_header X-Real-IP \$remote_addr;
#         proxy_set_header X-Forwarded-For \$proxy_add_x_forwarded_for;
#         proxy_set_header X-Forwarded-Proto \$scheme;
#     }

#     location /metrics {
#         proxy_pass http://localhost:9615;
#         proxy_set_header Host \$host;
#         proxy_set_header X-Real-IP \$remote_addr;
#         proxy_set_header X-Forwarded-For \$proxy_add_x_forwarded_for;
#         proxy_set_header X-Forwarded-Proto \$scheme;
#     }
# }
# EOF

# # Enable and reload Nginx configuration
# sudo ln -s /etc/nginx/sites-available/avail-light-client /etc/nginx/sites-enabled/
# sudo nginx -t
# sudo systemctl reload nginx

# echo "Setup complete. Avail Light Client is running and Nginx is configured."
