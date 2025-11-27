# 🔧 Git Commands - Step by Step

## 1️⃣ Initial Git Configuration

```bash
# Navigate to project directory
cd c:\Users\omgho\OneDrive\Desktop\crud-dd-task-mean-app\crud-dd-task-mean-app

# Configure git with your details
git config user.email "your-email@example.com"
git config user.name "Your Full Name"

# Verify configuration
git config --list
```

## 2️⃣ Initialize Repository & Stage Files

```bash
# Check if git is already initialized (it is)
cd c:\Users\omgho\OneDrive\Desktop\crud-dd-task-mean-app\crud-dd-task-mean-app
git status

# If not initialized, run: git init
# (Skip this - already done)

# Add all files to staging area
git add .

# Verify files are staged
git status
```

## 3️⃣ Create Initial Commit

```bash
# Create initial commit with descriptive message
git commit -m "Initial commit: Full-stack MEAN application with Docker, Docker Compose, and CI/CD pipeline

- Backend: Node.js/Express REST API
- Frontend: Angular 15 SPA
- Database: MongoDB with Docker
- Containerization: Docker & Docker Compose
- CI/CD: GitHub Actions workflow
- Infrastructure: Nginx reverse proxy
- Automation: VM setup and deployment scripts
- Documentation: Comprehensive 50+ page guides"
```

## 4️⃣ Connect to GitHub Repository

```bash
# Add remote repository
# Replace 'yourusername' with your GitHub username
git remote add origin https://github.com/yourusername/crud-dd-task-mean-app.git

# Verify remote was added
git remote -v
# Should show:
# origin  https://github.com/yourusername/crud-dd-task-mean-app.git (fetch)
# origin  https://github.com/yourusername/crud-dd-task-mean-app.git (push)
```

## 5️⃣ Rename Branch to Main (if needed)

```bash
# Check current branch name
git branch

# Rename to main if it's called master
git branch -M main

# Verify
git branch
```

## 6️⃣ Push to GitHub

```bash
# Push to remote main branch
git push -u origin main

# This sets 'main' as the upstream branch
# Future pushes can use just 'git push'
```

---

## 📝 Full Command Sequence (Copy & Paste)

```bash
# All commands in one block:

cd c:\Users\omgho\OneDrive\Desktop\crud-dd-task-mean-app\crud-dd-task-mean-app

git config user.email "your-email@example.com"
git config user.name "Your Full Name"

git status

git add .

git commit -m "Initial commit: Full-stack MEAN application with Docker, Docker Compose, and CI/CD pipeline"

git remote add origin https://github.com/yourusername/crud-dd-task-mean-app.git

git remote -v

git branch -M main

git push -u origin main
```

---

## ✅ Verification After Push

### 1. Verify in GitHub
```
Visit: https://github.com/yourusername/crud-dd-task-mean-app
You should see:
- All files listed
- Branch: main
- Recent commit message
```

### 2. Check Git Status
```bash
cd c:\Users\omgho\OneDrive\Desktop\crud-dd-task-mean-app\crud-dd-task-mean-app
git status

# Should show:
# On branch main
# Your branch is up to date with 'origin/main'.
# nothing to commit, working tree clean
```

### 3. View Remote
```bash
git remote -v
# Should show both fetch and push URLs
```

---

## 🔄 Subsequent Commits

After the initial setup, for future changes:

```bash
# Make your changes...

# Stage the changes
git add .

# Commit with message
git commit -m "Description of changes"

# Push to GitHub
git push origin main

# Or just 'git push' since main is now tracked
git push
```

---

## 🆘 Troubleshooting Git

### Q: "fatal: not a git repository"
```bash
# Solution: Initialize git
cd c:\Users\omgho\OneDrive\Desktop\crud-dd-task-mean-app\crud-dd-task-mean-app
git init
```

### Q: "fatal: 'origin' does not appear to be a 'git' repository"
```bash
# Solution: Add the remote
git remote add origin https://github.com/yourusername/crud-dd-task-mean-app.git
```

### Q: "Permission denied (publickey)"
```bash
# Solution: Set up SSH keys or use HTTPS with personal access token
# See GitHub docs: https://docs.github.com/en/authentication
```

### Q: "Your branch is ahead of 'origin/main' by X commits"
```bash
# Solution: Push your commits
git push origin main
```

### Q: "Please tell me who you are" when committing
```bash
# Solution: Configure git user
git config user.email "your-email@example.com"
git config user.name "Your Name"
```

### Q: "Updates were rejected because the remote contains work"
```bash
# Solution: Pull latest before pushing
git pull origin main
# Or force push if needed (careful!)
git push --force origin main
```

---

## 📋 Pre-Push Checklist

- [ ] Git configured with your email and name
- [ ] Working directory clean: `git status`
- [ ] All changes staged: `git add .`
- [ ] Commit message is descriptive
- [ ] Remote repository exists on GitHub
- [ ] Remote is properly configured: `git remote -v`
- [ ] Branch is renamed to main
- [ ] Ready to push: `git push -u origin main`

---

## 🔐 Using GitHub Personal Access Token (if needed)

If SSH doesn't work, use HTTPS with a personal access token:

```bash
# 1. Create token on GitHub:
#    Settings → Developer settings → Personal access tokens → Tokens (classic)
#    Select: repo, workflow
#    Copy the token

# 2. Use when pushing:
git push https://your_username:your_personal_access_token@github.com/yourusername/crud-dd-task-mean-app.git main

# 3. Or store credentials locally (Windows):
git config --global credential.helper wincred
# Then enter credentials when prompted
```

---

## 📚 Useful Git Commands Reference

```bash
# View commit history
git log

# View recent commits (one line each)
git log --oneline -5

# View branch information
git branch -v

# Check what's different from remote
git fetch origin
git diff main origin/main

# Undo last commit (but keep changes)
git reset --soft HEAD~1

# View file changes before committing
git diff

# View staged changes
git diff --staged
```

---

## 🔄 Workflow After Initial Push

```bash
# 1. Make changes to files
#    (e.g., update README, add new feature)

# 2. Check what changed
git status
git diff

# 3. Stage changes
git add .

# 4. Commit
git commit -m "Description of changes"

# 5. Push to GitHub
git push

# 6. GitHub Actions will automatically:
#    - Build Docker images
#    - Push to Docker Hub
#    - Deploy to your VM
```

---

## 🎯 Next Steps After Pushing Code

1. **Go to GitHub repository** → Check files uploaded
2. **Go to GitHub Actions tab** → Watch workflow execute
3. **Check Docker Hub** → Verify images pushed
4. **Check VM** → Verify containers running
5. **Access application** → http://<vm-ip>

---

## ⚠️ Important Notes

- Replace `yourusername` with your actual GitHub username
- Replace `your-email@example.com` with your GitHub email
- Replace `Your Full Name` with your name
- All commands are for Windows PowerShell
- SSH alternative available if you have SSH keys configured

---

**Ready to push?** Follow the "Full Command Sequence" section above! 🚀
