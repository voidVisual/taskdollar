#!/bin/bash

# Deployment Script for MEAN Stack Application
# Run this script to deploy the application on the Ubuntu VM

set -e

echo "================================================"
echo "MEAN Stack Application - Deployment Script"
echo "================================================"

# Color codes
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

print_status() {
    echo -e "${GREEN}[INFO]${NC} $1"
}

print_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

# Navigate to project directory
PROJECT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)/.."
cd "$PROJECT_DIR"

print_status "Deploying from: $PROJECT_DIR"

# Pull latest code
print_status "Pulling latest code from repository..."
git pull origin main || git pull origin master || print_warning "Could not pull from git"

# Pull latest Docker images
print_status "Pulling latest Docker images..."
docker-compose pull

# Stop running containers
print_status "Stopping running containers..."
docker-compose stop

# Remove old containers
print_status "Removing old containers..."
docker-compose rm -f

# Start new containers
print_status "Starting containers with latest images..."
docker-compose up -d

# Wait for services to be ready
print_status "Waiting for services to be ready..."
sleep 10

# Verify services
print_status "Verifying services..."
docker-compose ps

# Check health
print_status "Checking health..."
docker-compose logs --tail=20

echo ""
print_status "Deployment completed successfully!"
echo ""
echo "================================================"
echo "Service Status:"
docker-compose ps
echo "================================================"
echo ""

# Check if services are healthy
if docker-compose ps | grep -q "healthy"; then
    print_status "All services are running and healthy!"
else
    print_error "Some services may not be healthy. Check logs with: docker-compose logs"
fi

# Backup database before update (optional)
print_status "Creating database backup..."
BACKUP_DIR="backups/backup-$(date +%Y%m%d-%H%M%S)"
mkdir -p "$BACKUP_DIR"
docker-compose exec -T mongodb mongodump --out /tmp/backup --username admin --password password123 --authenticationDatabase admin 2>/dev/null || print_warning "Could not create backup"
docker cp mongodb:/tmp/backup "$BACKUP_DIR" 2>/dev/null || print_warning "Could not copy backup to host"

print_status "Deployment complete!"
