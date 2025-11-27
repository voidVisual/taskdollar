# Full-Stack MEAN Application - Deployment Guide

This repository contains a complete containerized MEAN stack (MongoDB, Express, Angular, Node.js) application with CI/CD pipeline and infrastructure setup.

## Project Overview

- **Frontend**: Angular 15 application for CRUD operations on tutorials
- **Backend**: Node.js/Express REST API with MongoDB integration
- **Database**: MongoDB for data persistence
- **Proxy**: Nginx reverse proxy for routing
- **Deployment**: Docker & Docker Compose with GitHub Actions CI/CD

### Features

- ✅ Create, Read, Update, Delete (CRUD) operations for tutorials
- ✅ Search tutorials by title
- ✅ RESTful API endpoints
- ✅ MongoDB persistence
- ✅ Angular reactive UI
- ✅ Docker containerization
- ✅ Docker Compose orchestration
- ✅ GitHub Actions CI/CD pipeline
- ✅ Nginx reverse proxy with SSL-ready configuration
- ✅ Health checks and auto-restart policies

## Project Structure

```
crud-dd-task-mean-app/
├── backend/
│   ├── app/
│   │   ├── config/
│   │   │   └── db.config.js          # MongoDB configuration
│   │   ├── controllers/
│   │   │   └── tutorial.controller.js # REST API logic
│   │   ├── models/
│   │   │   ├── index.js
│   │   │   └── tutorial.model.js     # MongoDB schema
│   │   └── routes/
│   │       └── turorial.routes.js    # API routes
│   ├── package.json
│   ├── server.js                      # Express server entry point
│   └── Dockerfile                     # Backend container config
├── frontend/
│   ├── src/
│   │   ├── app/
│   │   │   ├── components/            # Angular components
│   │   │   ├── models/
│   │   │   ├── services/              # HTTP services
│   │   │   └── app.module.ts
│   │   └── index.html
│   ├── package.json
│   ├── Dockerfile                     # Frontend container config
│   └── nginx.conf                     # Frontend Nginx config
├── docker-compose.yml                 # Multi-container orchestration
├── nginx.conf                         # Main Nginx reverse proxy config
├── .github/
│   └── workflows/
│       └── docker-build-deploy.yml    # CI/CD pipeline
└── README.md
```

## Prerequisites

### For Local Development

- Node.js 18+ and npm
- Docker & Docker Compose
- Angular CLI
- MongoDB (or use Docker image)

### For Production Deployment

- Ubuntu VM (20.04 LTS or later)
- Docker & Docker Compose installed
- Docker Hub account with credentials
- GitHub repository with Actions enabled

## Local Development Setup

### 1. Clone the Repository

```bash
git clone https://github.com/yourusername/crud-dd-task-mean-app.git
cd crud-dd-task-mean-app
```

### 2. Backend Setup (Local)

```bash
cd backend
npm install
# Update app/config/db.config.js if using local MongoDB
node server.js
```

The backend API will be available at `http://localhost:8080`

### 3. Frontend Setup (Local)

```bash
cd ../frontend
npm install
ng serve --port 8081
```

Access the application at `http://localhost:8081`

### 4. MongoDB Setup (Local)

**Option A: Using Docker**

```bash
docker run -d \
  --name mongodb \
  -e MONGO_INITDB_ROOT_USERNAME=admin \
  -e MONGO_INITDB_ROOT_PASSWORD=password123 \
  -p 27017:27017 \
  mongo:6.0
```

**Option B: Local Installation**

Follow MongoDB's [official installation guide](https://docs.mongodb.com/manual/installation/)

## Docker Compose Setup (Recommended)

### 1. Prerequisites

- Docker (v20.10+)
- Docker Compose (v1.29+)
- At least 2GB free disk space

### 2. Build and Run

```bash
# Build all services
docker-compose build

# Start all services in background
docker-compose up -d

# Check service status
docker-compose ps

# View logs
docker-compose logs -f

# Stop all services
docker-compose down
```

### 3. Access the Application

- **Frontend (via Nginx)**: http://localhost:80
- **Frontend (direct)**: http://localhost:4200
- **Backend API**: http://localhost:8080
- **MongoDB**: mongodb://admin:password123@localhost:27017/dd_db

### 4. Services Configuration

| Service | Container | Port | Purpose |
|---------|-----------|------|---------|
| MongoDB | `mongodb` | 27017 | Database |
| Backend | `backend` | 8080 | REST API |
| Frontend | `frontend` | 4200 | Angular App |
| Nginx | `nginx` | 80 | Reverse Proxy |

### 5. Docker Compose Features

- **Health Checks**: MongoDB includes health checks before backend starts
- **Volume Mounting**: MongoDB data persisted in `mongodb_data` volume
- **Auto-restart**: All containers set to restart unless stopped
- **Network Isolation**: Services communicate via `mean-network` bridge network
- **Environment Variables**: Centralized configuration through docker-compose.yml

## CI/CD Pipeline Setup

### 1. GitHub Actions Configuration

The pipeline is defined in `.github/workflows/docker-build-deploy.yml`

#### Features:
- ✅ Automatic Docker image builds on push to main/master/develop
- ✅ Push to Docker Hub after successful build
- ✅ Automatic deployment to production VM
- ✅ Health checks and notifications

### 2. Required GitHub Secrets

Add these secrets to your GitHub repository (Settings > Secrets and variables > Actions):

```
DOCKER_USERNAME        # Docker Hub username
DOCKER_PASSWORD        # Docker Hub access token or password
VM_HOST                # Production VM IP address
VM_USERNAME            # SSH username for VM
VM_PRIVATE_KEY         # SSH private key for VM authentication
SLACK_WEBHOOK          # (Optional) Slack webhook for notifications
```

#### Setting Up Secrets:

1. Go to GitHub repository → Settings → Secrets and variables → Actions
2. Click "New repository secret"
3. Add each secret with the values above
4. For `VM_PRIVATE_KEY`, paste your SSH private key content

### 3. Trigger Pipeline

The pipeline automatically triggers on:
- Push to `main`, `master`, or `develop` branches
- Pull requests to `main` or `master`

Manual trigger from GitHub Actions tab (if enabled)

### 4. Docker Hub Setup

1. Create a Docker Hub account at https://hub.docker.com
2. Create access token: Settings → Security → New Access Token
3. Use token as `DOCKER_PASSWORD` in GitHub Secrets
4. Create two repositories:
   - `backend-api` - for backend image
   - `frontend-app` - for frontend image

## Production Deployment

### 1. Ubuntu VM Setup

```bash
# Update system packages
sudo apt update && sudo apt upgrade -y

# Install Docker
curl -fsSL https://get.docker.com -o get-docker.sh
sudo sh get-docker.sh

# Install Docker Compose
sudo curl -L "https://github.com/docker/compose/releases/latest/download/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
sudo chmod +x /usr/local/bin/docker-compose

# Verify installation
docker --version
docker-compose --version

# Add user to docker group (to run without sudo)
sudo usermod -aG docker $USER
newgrp docker
```

### 2. Project Setup on VM

```bash
# Clone repository
git clone https://github.com/yourusername/crud-dd-task-mean-app.git
cd crud-dd-task-mean-app

# Create .env file for sensitive data (optional)
cat > .env << EOF
MONGO_ROOT_USERNAME=admin
MONGO_ROOT_PASSWORD=password123
NODE_ENV=production
EOF

# Start services
docker-compose up -d

# Verify services
docker-compose ps
```

### 3. Post-Deployment Verification

```bash
# Check container logs
docker-compose logs backend
docker-compose logs frontend
docker-compose logs mongodb

# Test API endpoint
curl http://localhost:8080/

# Test via Nginx
curl http://localhost/

# Check MongoDB connection
docker-compose exec mongodb mongosh -u admin -p password123
```

### 4. Database Backup

```bash
# Create backup
docker-compose exec -T mongodb mongodump --out /tmp/backup --username admin --password password123 --authenticationDatabase admin

# Copy backup to host
docker cp mongodb:/tmp/backup ./backups

# Restore from backup
docker-compose exec -T mongodb mongorestore /path/to/backup --username admin --password password123 --authenticationDatabase admin
```

## Nginx Reverse Proxy Configuration

### Features

- **Port 80 Binding**: Single entry point for entire application
- **API Routing**: `/api/*` requests proxied to backend
- **Frontend Serving**: Static files served from Nginx
- **Caching**: Static assets cached for 1 day
- **Gzip Compression**: Enabled for all text-based responses
- **Rate Limiting**: 
  - General routes: 10 req/s
  - API routes: 30 req/s
- **Security Headers**: X-Forwarded headers for backend awareness

### Configuration Details

```
Port 80 (HTTP)
├── / → Frontend (Angular app via proxy)
├── /api/* → Backend (Node.js/Express)
└── Static assets → Cached for 1 day
```

### Testing Nginx Configuration

```bash
# Validate nginx config
docker-compose exec nginx nginx -t

# Check current configuration
docker-compose exec nginx cat /etc/nginx/nginx.conf

# View access logs
docker-compose logs -f nginx

# Reload nginx (without stopping)
docker-compose exec nginx nginx -s reload
```

## API Endpoints

### Base URL
- Local: `http://localhost:8080`
- Docker: `http://localhost:8080`
- Production: `http://<VM_IP>/api`

### Tutorial Endpoints

| Method | Endpoint | Description |
|--------|----------|-------------|
| GET | `/api/tutorials` | Get all tutorials |
| GET | `/api/tutorials/:id` | Get tutorial by ID |
| POST | `/api/tutorials` | Create new tutorial |
| PUT | `/api/tutorials/:id` | Update tutorial |
| DELETE | `/api/tutorials/:id` | Delete tutorial |
| GET | `/api/tutorials?title=search` | Search by title |

### Request/Response Example

**Create Tutorial:**
```bash
curl -X POST http://localhost:8080/api/tutorials \
  -H "Content-Type: application/json" \
  -d '{
    "title": "Angular Tutorial",
    "description": "Learn Angular basics",
    "published": false
  }'
```

**Response:**
```json
{
  "_id": "507f1f77bcf86cd799439011",
  "title": "Angular Tutorial",
  "description": "Learn Angular basics",
  "published": false,
  "createdAt": "2025-11-28T10:30:00Z",
  "updatedAt": "2025-11-28T10:30:00Z"
}
```

## Troubleshooting

### MongoDB Connection Issues

```bash
# Check MongoDB container status
docker-compose ps mongodb

# View MongoDB logs
docker-compose logs mongodb

# Test MongoDB connection
docker-compose exec mongodb mongosh -u admin -p password123 --authenticationDatabase admin

# Reset MongoDB
docker-compose down -v  # Remove volumes
docker-compose up mongodb
```

### Backend Connection Issues

```bash
# Check backend logs
docker-compose logs -f backend

# Restart backend service
docker-compose restart backend

# Check if port 8080 is in use
netstat -tlnp | grep 8080
```

### Frontend Build Issues

```bash
# Clear npm cache
npm cache clean --force

# Rebuild frontend image
docker-compose build --no-cache frontend

# Restart frontend
docker-compose restart frontend
```

### Nginx Proxy Issues

```bash
# Validate configuration
docker-compose exec nginx nginx -t

# View Nginx error log
docker-compose logs nginx

# Reload Nginx gracefully
docker-compose exec nginx nginx -s reload
```

## Performance Optimization

### Backend

- Alpine Node.js image for smaller size
- Health checks prevent traffic to unhealthy containers
- Connection pooling via Mongoose

### Frontend

- Multi-stage Docker build to reduce image size
- Production build optimization
- Nginx gzip compression
- Static asset caching

### Database

- Volume-based persistence for data durability
- Health checks ensure availability
- Connection pooling

## Security Recommendations

1. **Credentials Management**
   - Use environment variables for sensitive data
   - Never commit `.env` files to repository
   - Rotate Docker Hub access tokens regularly

2. **Network Security**
   - Use Docker networks (isolated from host)
   - Implement firewall rules on VM
   - Consider SSL/TLS setup (requires domain)

3. **Container Security**
   - Keep base images updated
   - Run containers as non-root users
   - Scan images for vulnerabilities

4. **Database Security**
   - Change default MongoDB credentials
   - Use strong passwords
   - Implement MongoDB authentication

## Monitoring and Logging

### View Logs

```bash
# All services
docker-compose logs

# Specific service
docker-compose logs backend

# Follow logs in real-time
docker-compose logs -f

# Last 100 lines
docker-compose logs --tail=100

# With timestamps
docker-compose logs --timestamps
```

### Container Resource Usage

```bash
# CPU and memory usage
docker stats

# Specific container
docker stats backend
```

### Health Check Status

```bash
# Inspect health of MongoDB
docker-compose exec mongodb mongosh -u admin -p password123 --eval "db.adminCommand('ping')" --authenticationDatabase admin
```

## Common Commands Reference

```bash
# Build and start services
docker-compose up -d --build

# Stop services
docker-compose stop

# Remove services
docker-compose down

# Remove services and volumes
docker-compose down -v

# Rebuild specific service
docker-compose build --no-cache backend

# Scale services (if applicable)
docker-compose up -d --scale backend=2

# Execute command in container
docker-compose exec backend npm list

# View configuration
docker-compose config

# Validate configuration
docker-compose config --quiet
```

## Deployment Screenshots

### 1. GitHub Actions CI/CD Pipeline

When code is pushed to the main branch:
- Pipeline automatically triggers
- Docker images are built for backend and frontend
- Images are pushed to Docker Hub
- SSH connection to production VM
- Latest images pulled and containers restarted

### 2. Docker Image Build Process

Both images include:
- **Backend**: Node.js app with all dependencies
- **Frontend**: Angular production build served by Nginx

### 3. Application Deployment

- All containers run with health checks
- MongoDB persists data in volumes
- Nginx reverse proxy accessible on port 80
- All services auto-restart on failure

### 4. Infrastructure Details

```
┌─────────────────────────────────────────────────┐
│          Internet (Port 80)                      │
└────────────────────┬────────────────────────────┘
                     │
┌────────────────────▼────────────────────────────┐
│     Nginx Reverse Proxy (Port 80)               │
│  - Routes /api/* to Backend                     │
│  - Serves Frontend static files                 │
│  - Handles SSL termination                      │
└────────────┬─────────────────────┬──────────────┘
             │                     │
┌────────────▼──────────┐ ┌────────▼──────────┐
│ Backend API           │ │ Frontend (Angular)│
│ - Port 8080           │ │ - Nginx serving   │
│ - Express REST API    │ │ - Port 80         │
│ - CORS enabled        │ │ - Routing enabled │
└────────────┬──────────┘ └───────────────────┘
             │
┌────────────▼──────────────────────────────────┐
│ MongoDB Database                               │
│ - Port 27017                                  │
│ - Authentication enabled                      │
│ - Data persisted in volumes                   │
└───────────────────────────────────────────────┘
```

## Useful Resources

- [Docker Documentation](https://docs.docker.com/)
- [Docker Compose Reference](https://docs.docker.com/compose/compose-file/)
- [Express.js Guide](https://expressjs.com/)
- [Angular Documentation](https://angular.io/docs)
- [MongoDB Manual](https://docs.mongodb.com/manual/)
- [Nginx Documentation](https://nginx.org/en/docs/)

## Support & Contributions

For issues, questions, or contributions:
1. Check existing GitHub Issues
2. Create a new issue with detailed description
3. Submit pull requests with improvements


