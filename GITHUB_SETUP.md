# GitHub Setup Instructions

Follow these steps to create a GitHub repository and push your MEAN stack application code.

## Step 1: Create Repository on GitHub

1. Go to [GitHub.com](https://github.com) and log in to your account
2. Click the **+** icon in the top right corner
3. Select **New repository**
4. Fill in the repository details:
   - **Repository name**: `crud-dd-task-mean-app`
   - **Description**: `Full-stack MEAN application with Docker containerization and CI/CD pipeline`
   - **Visibility**: Select **Public** (or Private if preferred)
   - **Initialize repository**: Leave unchecked (we'll push existing code)
5. Click **Create repository**

## Step 2: Push Code to GitHub

```bash
# Navigate to the project directory
cd c:\Users\omgho\OneDrive\Desktop\crud-dd-task-mean-app\crud-dd-task-mean-app

# Configure git with your details
git config user.email "your-email@example.com"
git config user.name "Your Name"

# Add all files
git add .

# Create initial commit
git commit -m "Initial commit: MEAN stack application with Docker and CI/CD setup"

# Add remote repository (replace with your repository URL)
git remote add origin https://github.com/yourusername/crud-dd-task-mean-app.git

# Rename branch to main if needed
git branch -M main

# Push to GitHub
git push -u origin main
```

## Step 3: Configure GitHub Secrets for CI/CD

The GitHub Actions workflow requires several secrets for authentication with Docker Hub and VM deployment.

### 3.1 Get Docker Hub Credentials

1. Go to [Docker Hub](https://hub.docker.com)
2. Create a new Personal Access Token:
   - Click your profile icon → Account Settings
   - Go to **Security** → **New Access Token**
   - Copy the token (you'll need it as `DOCKER_PASSWORD`)
3. Your Docker Hub username is `DOCKER_USERNAME`

### 3.2 Get VM SSH Credentials

For VM deployment, you need:
- **VM_HOST**: Your Ubuntu VM's IP address (e.g., 192.168.1.100)
- **VM_USERNAME**: SSH username (e.g., ubuntu, ec2-user)
- **VM_PRIVATE_KEY**: Your SSH private key content

To generate SSH keys (if you don't have them):

```bash
# On your local machine
ssh-keygen -t rsa -b 4096 -f ~/.ssh/id_rsa -N ""

# View private key (copy this to GitHub secret)
cat ~/.ssh/id_rsa

# View public key (add to VM's ~/.ssh/authorized_keys)
cat ~/.ssh/id_rsa.pub
```

### 3.3 Add Secrets to GitHub

1. Go to your repository on GitHub
2. Click **Settings** → **Secrets and variables** → **Actions**
3. Click **New repository secret** for each:

| Secret Name | Value | Notes |
|-----------|-------|-------|
| DOCKER_USERNAME | Your Docker Hub username | |
| DOCKER_PASSWORD | Docker Hub access token | Create from Account Settings |
| VM_HOST | Your VM's public IP | e.g., 54.123.45.67 |
| VM_USERNAME | SSH username for VM | Usually 'ubuntu' or 'ec2-user' |
| VM_PRIVATE_KEY | Contents of ~/.ssh/id_rsa | Copy entire private key |
| SLACK_WEBHOOK | (Optional) Slack webhook URL | For deployment notifications |

**To add a secret:**
1. Click **New repository secret**
2. Name: Enter the secret name (e.g., DOCKER_USERNAME)
3. Secret: Enter the value
4. Click **Add secret**

## Step 4: Configure SSH Access to VM

Before the CI/CD pipeline can deploy to your VM, you need to set up SSH access:

### On Your Ubuntu VM:

```bash
# Create .ssh directory if it doesn't exist
mkdir -p ~/.ssh

# Add your public key to authorized_keys
echo "your-public-key-content" >> ~/.ssh/authorized_keys

# Set proper permissions
chmod 700 ~/.ssh
chmod 600 ~/.ssh/authorized_keys

# Install docker and docker-compose if not already installed
curl -fsSL https://get.docker.com -o get-docker.sh
sudo sh get-docker.sh

# Clone the repository
git clone https://github.com/yourusername/crud-dd-task-mean-app.git
cd crud-dd-task-mean-app

# Add user to docker group
sudo usermod -aG docker $USER
newgrp docker

# Test docker access
docker ps
```

## Step 5: Create Docker Hub Repositories

1. Go to [Docker Hub](https://hub.docker.com)
2. Click **Create Repository**
3. Create two repositories:
   - **backend-api**
     - Visibility: Public
     - Description: Backend API for MEAN stack application
   - **frontend-app**
     - Visibility: Public
     - Description: Frontend Angular application

These repositories will receive the Docker images built by the CI/CD pipeline.

## Step 6: Test CI/CD Pipeline

1. Make a small change to a file (e.g., add a comment to README.md)
2. Commit and push to main branch:
   ```bash
   git add .
   git commit -m "Test CI/CD pipeline"
   git push origin main
   ```
3. Go to GitHub repository → **Actions** tab
4. Watch the workflow execute:
   - Build backend Docker image
   - Build frontend Docker image
   - Push to Docker Hub
   - Deploy to VM

## Step 7: Verify Deployment

Once the pipeline completes successfully, verify your application is running:

```bash
# SSH into your VM
ssh -i ~/.ssh/id_rsa username@your-vm-ip

# Check running containers
docker-compose ps

# Check logs
docker-compose logs -f

# Test application
curl http://localhost/
```

## Troubleshooting

### GitHub Actions Fails to Build Docker Image

**Problem**: Build step fails in GitHub Actions
**Solution**: 
- Check the error message in the Actions logs
- Verify Dockerfile syntax is correct
- Ensure all necessary files are in the correct directories

### Docker Push Fails

**Problem**: Authentication error when pushing to Docker Hub
**Solution**:
- Verify DOCKER_USERNAME and DOCKER_PASSWORD are correct
- Check Docker Hub access token hasn't expired
- Recreate access token and update GitHub secret

### VM Deployment Fails

**Problem**: SSH connection fails or deployment commands fail
**Solution**:
- Verify VM_HOST is correct IP address
- Check VM_USERNAME and VM_PRIVATE_KEY are correct
- Ensure VM has Docker and Docker Compose installed
- Check VM firewall allows SSH (port 22)
- Verify user has permission to run Docker commands

### Application Not Accessible

**Problem**: http://vm-ip/ returns connection refused
**Solution**:
- Check containers are running: `docker-compose ps`
- Check port 80 is open on VM firewall
- Verify Nginx container is healthy
- Check Nginx logs: `docker-compose logs nginx`

## Next Steps

1. **Monitor the Pipeline**: Go to Actions tab to watch builds
2. **Set Up Monitoring**: Consider adding uptime monitoring for your application
3. **Configure SSL/TLS**: Add domain and SSL certificate for HTTPS
4. **Set Up Alerts**: Configure Slack notifications for deployment status
5. **Document Architecture**: Keep deployment guide updated

## Additional Resources

- [GitHub Actions Documentation](https://docs.github.com/en/actions)
- [Docker Hub Documentation](https://docs.docker.com/docker-hub/)
- [SSH Key Setup Guide](https://docs.github.com/en/authentication/connecting-to-github-with-ssh)
- [GitHub Secrets Guide](https://docs.github.com/en/actions/security-guides/encrypted-secrets)

---

**Last Updated**: November 28, 2025
