# CRUD Tutorial Application - MEAN Stack (MongoDB, Express, Angular, Node.js)

A complete full-stack CRUD application using the MEAN stack with Docker containerization, Docker Compose orchestration, and GitHub Actions CI/CD pipeline for automated deployment.

## Project Overview

This is an enterprise-ready MEAN stack application that demonstrates:
- **MongoDB**: NoSQL database for tutorial data persistence
- **Express.js**: RESTful API server for CRUD operations
- **Angular 15**: Modern frontend SPA with reactive forms
- **Node.js**: JavaScript runtime for backend services
- **Docker & Compose**: Complete containerization and orchestration
- **GitHub Actions**: Automated CI/CD pipeline
- **Nginx**: Reverse proxy and static file serving

### Features

✅ Create, Read, Update, Delete (CRUD) operations for tutorials
✅ Search tutorials by title with real-time filtering
✅ Responsive Angular UI with Bootstrap styling
✅ RESTful API with proper error handling
✅ MongoDB with authentication and persistence
✅ Complete Docker containerization
✅ Docker Compose for multi-container orchestration
✅ Nginx reverse proxy with rate limiting and caching
✅ GitHub Actions CI/CD pipeline with automated deployment
✅ Health checks for all services
✅ Comprehensive documentation and troubleshooting guides

## Quick Start

### Option 1: Using Docker Compose (Recommended)

```bash
# Clone repository
git clone https://github.com/yourusername/crud-dd-task-mean-app.git
cd crud-dd-task-mean-app

# Start all services
docker-compose up -d

# Access application
# Frontend: http://localhost:80
# API: http://localhost:8080
# Verify: docker-compose ps
```

### Option 2: Local Development

#### Prerequisites
- Node.js 18+
- MongoDB 5+
- Angular CLI

#### Backend Setup
```bash
cd backend
npm install

# Update database config in app/config/db.config.js if needed
# Run MongoDB locally or in Docker

node server.js
```

#### Frontend Setup
```bash
cd frontend
npm install
ng serve --port 8081
```

Navigate to `http://localhost:8081`

## Project Structure

```
crud-dd-task-mean-app/
├── backend/                          # Node.js/Express API
│   ├── app/
│   │   ├── config/db.config.js      # MongoDB connection
│   │   ├── controllers/              # Business logic
│   │   ├── models/                   # MongoDB schemas
│   │   └── routes/                   # API endpoints
│   ├── package.json                  # Dependencies
│   ├── server.js                     # Entry point
│   ├── Dockerfile                    # Container config
│   └── .dockerignore
│
├── frontend/                         # Angular SPA
│   ├── src/
│   │   ├── app/
│   │   │   ├── components/           # Angular components
│   │   │   ├── models/               # TypeScript interfaces
│   │   │   ├── services/             # HTTP service
│   │   │   └── app.module.ts
│   │   └── index.html
│   ├── package.json
│   ├── Dockerfile                    # Multi-stage build
│   ├── nginx.conf                    # Frontend Nginx config
│   └── .dockerignore
│
├── docker-compose.yml                # Multi-container orchestration
├── nginx.conf                        # Main reverse proxy config
├── .github/
│   └── workflows/
│       └── docker-build-deploy.yml   # CI/CD pipeline
├── scripts/
│   ├── setup-vm.sh                   # VM setup automation
│   └── deploy.sh                     # Deployment script
├── DEPLOYMENT_GUIDE.md               # Detailed deployment guide
├── GITHUB_SETUP.md                   # GitHub setup instructions
└── README.md
```

## Deployment Guide

For complete deployment instructions, see:
- **[DEPLOYMENT_GUIDE.md](./DEPLOYMENT_GUIDE.md)** - Full deployment walkthrough
- **[GITHUB_SETUP.md](./GITHUB_SETUP.md)** - GitHub and CI/CD setup

### Quick Deployment Steps

1. **Set up GitHub repository** (see GITHUB_SETUP.md)
2. **Configure GitHub secrets** (Docker Hub credentials, VM details)
3. **Push to main branch** - Automatically triggers CI/CD
4. **Monitor GitHub Actions** - Watch pipeline execute
5. **Verify on VM** - Application accessible at `http://vm-ip`

## Docker Images

### Backend Image
- **Base**: node:18-alpine (lightweight)
- **Size**: ~150MB
- **Port**: 8080
- **Environment**: Production-ready with NODE_ENV=production

### Frontend Image
- **Build Stage**: node:18-alpine (compiles Angular)
- **Runtime Stage**: nginx:alpine (serves static files)
- **Size**: ~50MB
- **Port**: 80

### MongoDB Image
- **Base**: mongo:6.0 (official MongoDB image)
- **Authentication**: Enabled with admin credentials
- **Persistence**: Docker volume for data durability

## CI/CD Pipeline

The GitHub Actions workflow automatically:

1. **On Push to Main**:
   - ✅ Build Docker images for backend and frontend
   - ✅ Push images to Docker Hub
   - ✅ SSH into production VM
   - ✅ Pull latest images
   - ✅ Restart containers with new code

2. **On Pull Request**:
   - ✅ Build Docker images
   - ✅ Verify builds succeed
   - ✅ No push to Docker Hub
   - ✅ No deployment to VM

3. **Notifications** (Optional):
   - Send Slack notifications on success/failure

## API Endpoints

### Base URL
- Local: `http://localhost:8080`
- Docker: `http://localhost:8080`
- Production: `http://<vm-ip>/api`

### Endpoints

| Method | Endpoint | Description |
|--------|----------|-------------|
| GET | `/api/tutorials` | Get all tutorials |
| GET | `/api/tutorials/:id` | Get single tutorial |
| POST | `/api/tutorials` | Create new tutorial |
| PUT | `/api/tutorials/:id` | Update tutorial |
| DELETE | `/api/tutorials/:id` | Delete tutorial |
| GET | `/api/tutorials?title=search` | Search by title |

### Example Request

```bash
# Create tutorial
curl -X POST http://localhost:8080/api/tutorials \
  -H "Content-Type: application/json" \
  -d '{
    "title": "Angular Basics",
    "description": "Learn Angular fundamentals",
    "published": false
  }'

# Response
{
  "_id": "507f1f77bcf86cd799439011",
  "title": "Angular Basics",
  "description": "Learn Angular fundamentals",
  "published": false,
  "createdAt": "2025-11-28T10:30:00Z",
  "updatedAt": "2025-11-28T10:30:00Z"
}
```

## Technology Stack

| Component | Technology | Version |
|-----------|-----------|---------|
| Database | MongoDB | 6.0 |
| Backend | Node.js/Express | 18 LTS / 4.18 |
| Frontend | Angular | 15 |
| Containerization | Docker | 20.10+ |
| Orchestration | Docker Compose | 1.29+ |
| Web Server | Nginx | Alpine |
| CI/CD | GitHub Actions | Latest |

## Environment Variables

### Backend
```
PORT=8080
NODE_ENV=production
MONGODB_URI=mongodb://admin:password123@mongodb:27017/dd_db?authSource=admin
```

### MongoDB
```
MONGO_INITDB_ROOT_USERNAME=admin
MONGO_INITDB_ROOT_PASSWORD=password123
MONGO_INITDB_DATABASE=dd_db
```

## Security Features

- ✅ MongoDB authentication enabled
- ✅ CORS configured for secure cross-origin requests
- ✅ Environment-based secrets management
- ✅ Docker network isolation
- ✅ Nginx rate limiting (10 req/s general, 30 req/s API)
- ✅ Health checks for service reliability
- ✅ Non-root container execution

## Architecture Diagram

```
┌─────────────────────────────────────────────┐
│           Internet (Port 80)                │
└────────────────────┬────────────────────────┘
                     │
        ┌────────────▼────────────┐
        │   Nginx Reverse Proxy   │
        │   - Routes /api/* to    │
        │     Backend             │
        │   - Serves Frontend     │
        │   - Rate Limiting       │
        │   - Caching             │
        └──┬──────────────────┬───┘
           │                  │
    ┌──────▼────────┐  ┌─────▼──────────┐
    │  Backend API  │  │ Frontend (SPA) │
    │  - Express    │  │ - Angular      │
    │  - Port 8080  │  │ - Port 80      │
    └──────┬────────┘  └────────────────┘
           │
    ┌──────▼──────────────┐
    │  MongoDB Database   │
    │  - Port 27017       │
    │  - Authenticated    │
    │  - Volume Persisted │
    └─────────────────────┘
```

## Deployment URLs

After deployment:
- **Application**: `http://<your-vm-ip>`
- **API**: `http://<your-vm-ip>:8080` or `http://<your-vm-ip>/api`

## Documentation

- **[DEPLOYMENT_GUIDE.md](./DEPLOYMENT_GUIDE.md)** - Complete deployment guide with troubleshooting
- **[GITHUB_SETUP.md](./GITHUB_SETUP.md)** - GitHub and CI/CD configuration
- **[BACKEND SETUP]** - See `/backend/README.md` for backend-specific instructions
- **[FRONTEND SETUP]** - See `/frontend/README.md` for frontend-specific instructions

## Troubleshooting

### Application won't start
```bash
# Check container logs
docker-compose logs -f

# Verify all containers are running
docker-compose ps

# Check if ports are in use
netstat -tlnp | grep -E "8080|80|27017"
```

### MongoDB connection error
```bash
# Check MongoDB logs
docker-compose logs mongodb

# Test connection manually
docker-compose exec mongodb mongosh -u admin -p password123
```

### Frontend not loading
```bash
# Check Nginx logs
docker-compose logs nginx

# Verify frontend container
docker-compose exec frontend curl http://localhost
```

See [DEPLOYMENT_GUIDE.md](./DEPLOYMENT_GUIDE.md) for more troubleshooting steps.

## Contributing

1. Fork the repository
2. Create feature branch (`git checkout -b feature/AmazingFeature`)
3. Commit changes (`git commit -m 'Add some AmazingFeature'`)
4. Push to branch (`git push origin feature/AmazingFeature`)
5. Open Pull Request

## License

This project is open source and available under the MIT License - see LICENSE file for details.


## Support

For issues, questions, or suggestions:
- Check documentation first
- Search existing GitHub Issues
- Create new issue with detailed description
- Check troubleshooting section in DEPLOYMENT_GUIDE.md

## 🎉 Acknowledgments

- MEAN Stack community
- Docker and Docker Compose teams
- GitHub Actions documentation
- Nginx community

---

