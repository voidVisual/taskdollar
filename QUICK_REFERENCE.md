# Quick Reference - Commands & Checklists

## 🚀 One-Liner Commands

### Local Testing with Docker Compose
```bash
docker-compose up -d && sleep 5 && docker-compose ps && curl http://localhost
```

### Rebuild Specific Service
```bash
docker-compose build backend && docker-compose up -d backend
```

### View All Logs
```bash
docker-compose logs -f --tail=50
```

### Clean Everything (Danger!)
```bash
docker-compose down -v && docker system prune -a
```

### Database Backup
```bash
mkdir -p backups && docker-compose exec -T mongodb mongodump --out /tmp/backup --username admin --password password123 --authenticationDatabase admin && docker cp mongodb:/tmp/backup ./backups/backup-$(date +%s)
```

## 📋 Pre-Deployment Checklist

### Local Verification
- [ ] Docker installed: `docker --version`
- [ ] Docker Compose installed: `docker-compose --version`
- [ ] Build images: `docker-compose build`
- [ ] Start services: `docker-compose up -d`
- [ ] All containers running: `docker-compose ps`
- [ ] Frontend loads: `curl http://localhost`
- [ ] API responds: `curl http://localhost:8080`
- [ ] MongoDB connection works: `docker-compose logs mongodb`

### GitHub Setup
- [ ] Repository created
- [ ] Code pushed to main branch
- [ ] GitHub Secrets configured:
  - [ ] DOCKER_USERNAME
  - [ ] DOCKER_PASSWORD
  - [ ] VM_HOST
  - [ ] VM_USERNAME
  - [ ] VM_PRIVATE_KEY

### Docker Hub Setup
- [ ] Account created
- [ ] Access token generated
- [ ] Two repositories created:
  - [ ] backend-api
  - [ ] frontend-app

### VM Preparation
- [ ] Ubuntu 20.04 LTS VM created
- [ ] SSH access configured
- [ ] SSH key added to authorized_keys
- [ ] Run setup-vm.sh or manual setup complete
- [ ] Docker running: `docker --version`
- [ ] Docker Compose running: `docker-compose --version`

### CI/CD Pipeline
- [ ] Workflow file at `.github/workflows/docker-build-deploy.yml`
- [ ] GitHub Actions enabled
- [ ] Secrets properly set
- [ ] Test run triggered manually

## 🔍 Verification Tests

### After Local Docker Compose Start
```bash
# Check services
docker-compose ps

# Test API
curl -X GET http://localhost:8080/api/tutorials

# Test Frontend
curl -X GET http://localhost/

# Test MongoDB
docker-compose exec mongodb mongosh -u admin -p password123 --authenticationDatabase admin

# View Nginx logs
docker-compose logs nginx

# Monitor in real-time
docker-compose stats
```

### After VM Deployment
```bash
# SSH into VM
ssh -i ~/.ssh/id_rsa username@vm-ip

# Check containers
docker-compose ps

# Check recent logs
docker-compose logs --tail=20

# Test API
curl http://localhost:8080/api/tutorials

# Test via Nginx
curl http://localhost/

# Verify MongoDB
docker-compose exec mongodb mongosh -u admin -p password123 --authenticationDatabase admin
```

## 🆘 Quick Troubleshooting

### Docker Image Won't Build
```bash
# Check Docker daemon
docker ps

# Clean up disk space
docker system prune -a

# Rebuild with verbose output
docker-compose build --no-cache --progress=plain backend
```

### Port Already in Use
```bash
# Find process using port
lsof -i :8080  # Linux
netstat -ano | findstr :8080  # Windows

# Kill process
kill -9 <PID>  # Linux
taskkill /PID <PID> /F  # Windows
```

### MongoDB Connection Failed
```bash
# Check MongoDB container
docker-compose logs mongodb

# Verify network
docker network ls

# Test connection
docker-compose exec mongodb mongosh -u admin -p password123 --authenticationDatabase admin
```

### GitHub Actions Failing
1. Check workflow logs in GitHub Actions tab
2. Verify secrets are set correctly
3. Check Docker Hub credentials
4. Verify VM SSH access
5. Review error message in logs

## 📊 File Structure to Verify

```
crud-dd-task-mean-app/
├── .github/workflows/docker-build-deploy.yml  ✅
├── backend/
│   ├── Dockerfile                              ✅
│   ├── .dockerignore                           ✅
│   ├── server.js                               ✅ (CORS enabled)
│   ├── app/config/db.config.js                 ✅ (MongoDB URI support)
│   └── package.json                            ✅
├── frontend/
│   ├── Dockerfile                              ✅
│   ├── .dockerignore                           ✅
│   ├── nginx.conf                              ✅
│   └── package.json                            ✅
├── scripts/
│   ├── setup-vm.sh                             ✅
│   └── deploy.sh                               ✅
├── docker-compose.yml                          ✅
├── nginx.conf                                  ✅
├── .gitignore                                  ✅
├── .env.example                                ✅
├── README.md                                   ✅
├── DEPLOYMENT_GUIDE.md                         ✅
├── GITHUB_SETUP.md                             ✅
└── DELIVERABLES.md                             ✅
```

## 🔐 Secrets Template

When setting GitHub secrets, use these values:

```
DOCKER_USERNAME=your-docker-username
DOCKER_PASSWORD=your-docker-access-token
VM_HOST=your-vm-ip-address
VM_USERNAME=ubuntu  (or ec2-user for Amazon Linux)
VM_PRIVATE_KEY=[paste entire content of ~/.ssh/id_rsa]
SLACK_WEBHOOK=[optional, paste webhook URL]
```

## 🌐 Access URLs Reference

### During Local Development
```
Frontend: http://localhost:8081
Backend:  http://localhost:8080
Nginx:    http://localhost:80
MongoDB:  mongodb://admin:password123@localhost:27017/dd_db
```

### After Docker Compose (Local)
```
Frontend: http://localhost:80 or http://localhost:4200
Backend:  http://localhost:8080
Nginx:    http://localhost:80
MongoDB:  mongodb://admin:password123@mongodb:27017/dd_db
```

### After Production Deployment
```
Frontend: http://YOUR-VM-IP:80
Backend:  http://YOUR-VM-IP:8080 (or /api via Nginx)
MongoDB:  Internal to containers
```

## 📱 Docker Compose Service Ports

| Service | Port | Host Port | Purpose |
|---------|------|-----------|---------|
| MongoDB | 27017 | 27017 | Database |
| Backend | 8080 | 8080 | REST API |
| Frontend | 80 | 4200 | Angular App |
| Nginx | 80 | 80 | Reverse Proxy |

## 🔄 Git Commands Quick Reference

```bash
# Initial setup
git config user.email "your-email@example.com"
git config user.name "Your Name"
git init
git add .
git commit -m "Initial commit: MEAN stack with Docker"
git remote add origin https://github.com/yourusername/crud-dd-task-mean-app.git
git branch -M main
git push -u origin main

# Subsequent commits
git add .
git commit -m "Your message"
git push origin main
```

## 📞 Documentation Quick Links

- 📘 **Full Setup**: Read DEPLOYMENT_GUIDE.md
- 🐙 **GitHub Setup**: Read GITHUB_SETUP.md  
- ✅ **What's Included**: Read DELIVERABLES.md
- 📖 **Project Info**: Read README.md

---

**Last Updated**: November 28, 2025
**Ready to Deploy**: ✅
