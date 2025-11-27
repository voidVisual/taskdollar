#!/bin/bash

# MEAN Stack Deployment Setup Script for Ubuntu VM
# This script automates the setup of Docker, Docker Compose, and project deployment

set -e

echo "================================================"
echo "MEAN Stack Application - VM Setup Script"
echo "================================================"

# Color codes for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Function to print colored output
print_status() {
    echo -e "${GREEN}[INFO]${NC} $1"
}

print_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

# Check if running as root
if [ "$EUID" -eq 0 ]; then
   print_error "Please do not run this script as root"
   exit 1
fi

# Update system packages
print_status "Updating system packages..."
sudo apt update && sudo apt upgrade -y

# Install curl and git if not present
print_status "Installing prerequisites..."
sudo apt install -y curl git wget

# Install Docker
print_status "Installing Docker..."
if ! command -v docker &> /dev/null; then
    curl -fsSL https://get.docker.com -o get-docker.sh
    sudo sh get-docker.sh
    rm get-docker.sh
    print_status "Docker installed successfully"
else
    print_status "Docker already installed"
fi

# Install Docker Compose
print_status "Installing Docker Compose..."
if ! command -v docker-compose &> /dev/null; then
    COMPOSE_VERSION=$(curl -s https://api.github.com/repos/docker/compose/releases/latest | grep 'tag_name' | cut -d'"' -f4)
    sudo curl -L "https://github.com/docker/compose/releases/download/${COMPOSE_VERSION}/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
    sudo chmod +x /usr/local/bin/docker-compose
    print_status "Docker Compose installed successfully"
else
    print_status "Docker Compose already installed"
fi

# Add current user to docker group
print_status "Adding user to docker group..."
sudo usermod -aG docker $USER
print_warning "Please log out and log back in for docker group permissions to take effect"

# Verify installations
print_status "Verifying installations..."
docker --version
docker-compose --version

# Clone repository if not already present
if [ ! -d "crud-dd-task-mean-app" ]; then
    print_status "Cloning repository..."
    read -p "Enter your GitHub repository URL: " REPO_URL
    git clone "$REPO_URL" crud-dd-task-mean-app
else
    print_status "Repository already exists, skipping clone"
fi

cd crud-dd-task-mean-app

# Create .env file if it doesn't exist
if [ ! -f ".env" ]; then
    print_status "Creating .env file..."
    cat > .env << EOF
# MongoDB Configuration
MONGO_ROOT_USERNAME=admin
MONGO_ROOT_PASSWORD=password123
MONGO_INITDB_DATABASE=dd_db

# Application Environment
NODE_ENV=production
BACKEND_PORT=8080
FRONTEND_PORT=4200

# Database Connection
MONGODB_URI=mongodb://admin:password123@mongodb:27017/dd_db?authSource=admin
EOF
    print_status ".env file created. Please update with your values if needed."
fi

# Create necessary directories
print_status "Creating necessary directories..."
mkdir -p backups logs

# Build Docker images
print_status "Building Docker images..."
docker-compose build

# Start services
print_status "Starting services..."
docker-compose up -d

# Wait for services to be ready
print_status "Waiting for services to be ready..."
sleep 10

# Verify services
print_status "Verifying services..."
docker-compose ps

echo ""
print_status "Setup completed successfully!"
echo ""
echo "================================================"
echo "Service URLs:"
echo "  - Application: http://$(hostname -I | awk '{print $1}'):80"
echo "  - API (direct): http://$(hostname -I | awk '{print $1}'):8080"
echo "  - Backend health check: http://$(hostname -I | awk '{print $1}'):8080/"
echo "================================================"
echo ""
echo "Useful commands:"
echo "  - View logs: docker-compose logs -f"
echo "  - Stop services: docker-compose stop"
echo "  - Start services: docker-compose start"
echo "  - Restart services: docker-compose restart"
echo "  - Pull latest images: docker-compose pull"
echo "  - Update and restart: docker-compose pull && docker-compose up -d"
echo ""
print_status "Setup complete!"
