In this DevOps task, you need to build and deploy a full-stack CRUD application using the MEAN stack (MongoDB, Express, Angular 15, and Node.js). The backend will be developed with Node.js and Express to provide REST APIs, connecting to a MongoDB database. The frontend will be an Angular application utilizing HTTPClient for communication.  

The application will manage a collection of tutorials, where each tutorial includes an ID, title, description, and published status. Users will be able to create, retrieve, update, and delete tutorials. Additionally, a search box will allow users to find tutorials by title.

## Project setup

### Node.js Server

cd backend

npm install

You can update the MongoDB credentials by modifying the `db.config.js` file located in `app/config/`.

Run `node server.js`

### Angular Client

cd frontend

npm install

Run `ng serve --port 8081`

You can modify the `src/app/services/tutorial.service.ts` file to adjust how the frontend interacts with the backend.

Navigate to `http://localhost:8081/`


Full-stack MEAN (MongoDB, Express, Angular, Node.js) application with complete CI/CD pipeline.

# MEAN Stack Application - Complete DevOps Pipeline

## 📋 Project Overview
Full-stack MEAN (MongoDB, Express, Angular, Node.js) application with complete CI/CD pipeline, containerization, and cloud deployment.

## 🏗️ Architecture
```
GitHub → GitHub Actions → Docker Hub → AWS EC2 → Nginx → Application
```

---

## 🚀 Step-by-Step Deployment Guide

### Step 1: Repository Setup

```bash
# 1. Create new GitHub repository
# Go to GitHub.com → New Repository → "mean-stack-app"

# 2. Initialize and push code
git init
git add .
git commit -m "Initial commit: MEAN stack application"
git branch -M main
git remote add origin https://github.com/YOUR_USERNAME/mean-stack-app.git
git push -u origin main
```

### Step 2: Docker Configuration

#### Backend Dockerfile
```dockerfile
FROM node:18-alpine
WORKDIR /app
COPY package*.json ./
RUN npm install
COPY . .
EXPOSE 3000
CMD ["node", "server.js"]
```

#### Frontend Dockerfile
```dockerfile
FROM node:18-alpine as build
WORKDIR /app
COPY package*.json ./
RUN npm install
COPY . .
RUN npm run build --prod

FROM nginx:alpine
COPY --from=build /app/dist/angular-15-crud /usr/share/nginx/html
COPY nginx.conf /etc/nginx/conf.d/default.conf
EXPOSE 80
```

#### Docker Compose Configuration
```yaml
services:
  mongodb:
    image: mongo:7.0
    environment:
      MONGO_INITDB_ROOT_USERNAME: admin
      MONGO_INITDB_ROOT_PASSWORD: admin123
      MONGO_INITDB_DATABASE: meandb
    volumes:
      - mongodb_data:/data/db
    networks:
      - app-network

  backend:
    image: YOUR_USERNAME/tutorial-backend:latest
    environment:
      MONGODB_URI: mongodb://admin:admin123@mongodb:27017/meandb?authSource=admin
      PORT: 3000
    depends_on:
      - mongodb
    networks:
      - app-network

  frontend:
    image: YOUR_USERNAME/tutorial-frontend:latest
    depends_on:
      - backend
    networks:
      - app-network

  nginx:
    image: nginx:alpine
    ports:
      - "80:80"
    volumes:
      - ./nginx.conf:/etc/nginx/nginx.conf
    depends_on:
      - frontend
      - backend
    networks:
      - app-network

volumes:
  mongodb_data:

networks:
  app-network:
```

### Step 3: Build and Push Docker Images

```bash
# 1. Login to Docker Hub
docker login

# 2. Build images
docker build -t YOUR_USERNAME/tutorial-backend:latest ./backend
docker build -t YOUR_USERNAME/tutorial-frontend:latest ./frontend

# 3. Push to Docker Hub
docker push YOUR_USERNAME/tutorial-backend:latest
docker push YOUR_USERNAME/tutorial-frontend:latest
```

### Step 4: AWS EC2 Setup

```bash
# 1. Launch EC2 Instance
aws ec2 run-instances \
  --image-id ami-0c02fb55956c7d316 \
  --count 1 \
  --instance-type t3.medium \
  --key-name your-key-pair \
  --security-groups mean-app-sg

# 2. Security Group Rules
aws ec2 authorize-security-group-ingress \
  --group-name mean-app-sg \
  --protocol tcp \
  --port 22 \
  --cidr 0.0.0.0/0

aws ec2 authorize-security-group-ingress \
  --group-name mean-app-sg \
  --protocol tcp \
  --port 80 \
  --cidr 0.0.0.0/0

# 3. SSH to EC2
ssh -i your-key.pem ec2-user@YOUR_EC2_IP
```

### Step 5: EC2 Environment Setup

```bash
# On EC2 instance:

# 1. Update system
sudo yum update -y

# 2. Install Docker
sudo yum install -y docker
sudo systemctl start docker
sudo systemctl enable docker
sudo usermod -a -G docker ec2-user

# 3. Install Docker Compose
sudo curl -L "https://github.com/docker/compose/releases/latest/download/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
sudo chmod +x /usr/local/bin/docker-compose

# 4. Logout and login again
exit
ssh -i your-key.pem ec2-user@YOUR_EC2_IP
```

### Step 6: Nginx Configuration

Create `nginx.conf`:
```nginx
events {
    worker_connections 1024;
}

http {
    upstream backend {
        server backend:3000;
    }

    upstream frontend {
        server frontend:80;
    }

    server {
        listen 80;
        server_name _;

        location / {
            proxy_pass http://frontend;
            proxy_set_header Host $host;
            proxy_set_header X-Real-IP $remote_addr;
        }

        location /api/ {
            proxy_pass http://backend;
            proxy_set_header Host $host;
            proxy_set_header X-Real-IP $remote_addr;
        }
    }
}
```

### Step 7: Deploy Application

```bash
# On EC2:

# 1. Clone repository
git clone https://github.com/YOUR_USERNAME/mean-stack-app.git
cd mean-stack-app

# 2. Deploy with Docker Compose
docker-compose up -d

# 3. Check status
docker-compose ps
docker-compose logs -f
```

### Step 8: GitHub Actions CI/CD Pipeline

Create `.github/workflows/deploy.yml`:
```yaml
name: CI/CD Pipeline

on:
  push:
    branches: [ main ]

jobs:
  build-and-deploy:
    runs-on: ubuntu-latest
    
    steps:
    - uses: actions/checkout@v3
    
    - name: Login to Docker Hub
      uses: docker/login-action@v2
      with:
        username: ${{ secrets.DOCKER_USERNAME }}
        password: ${{ secrets.DOCKER_PASSWORD }}
    
    - name: Build and push backend
      uses: docker/build-push-action@v4
      with:
        context: ./backend
        push: true
        tags: ${{ secrets.DOCKER_USERNAME }}/tutorial-backend:latest
    
    - name: Build and push frontend
      uses: docker/build-push-action@v4
      with:
        context: ./frontend
        push: true
        tags: ${{ secrets.DOCKER_USERNAME }}/tutorial-frontend:latest
    
    - name: Deploy to EC2
      uses: appleboy/ssh-action@v0.1.5
      with:
        host: ${{ secrets.EC2_HOST }}
        username: ec2-user
        key: ${{ secrets.EC2_SSH_KEY }}
        script: |
          cd mean-stack-app
          git pull origin main
          docker-compose pull
          docker-compose up -d
```

### Step 9: GitHub Secrets Configuration

Add these secrets in GitHub repository settings:
```
DOCKER_USERNAME: your-dockerhub-username
DOCKER_PASSWORD: your-dockerhub-password
EC2_HOST: your-ec2-public-ip
EC2_SSH_KEY: your-private-key-content
```

---

## 🔧 Commands Reference

### Local Development
```bash
# Start application locally
./start.sh

# Stop application
docker-compose down

# View logs
docker-compose logs -f

# Check MongoDB data
docker-compose exec mongodb mongosh --username admin --password admin123 --authenticationDatabase admin meandb --eval "db.tutorials.find().pretty()"
```

### Production Management
```bash
# Update application
git pull origin main
docker-compose pull
docker-compose up -d

# Check status
docker-compose ps
docker system df

# Backup MongoDB
docker-compose exec mongodb mongodump --username admin --password admin123 --authenticationDatabase admin --db meandb --out /backup
```

---

## 📊 Monitoring & Troubleshooting

### Health Checks
```bash
# Check application health
curl http://YOUR_EC2_IP/api/tutorials
curl http://YOUR_EC2_IP

# Check container status
docker-compose ps
docker-compose logs backend
docker-compose logs frontend
docker-compose logs mongodb
```

## 📸 Screenshots

### AWS UI
![AWS UI](../images/Awsui.png)

### CI/CD Pipeline
![CD Pipeline](../images/CDPipeline.png)

### Docker Hub
![Docker Hub](../images/DockerHub.png)

### GitHub Actions Secrets
![GitHub Actions Secrets](../images/githubaction_secrets.png)

### Local Application with Data
![Local + Data](../images/local+database.png)



### Common Issues
```bash
# Port conflicts
sudo netstat -tulpn | grep :80

# Container restart
docker-compose restart backend
docker-compose restart frontend

# Clean rebuild
docker-compose down
docker-compose build --no-cache
docker-compose up -d
```

---

## 🌐 Access Points

- **Application**: http://YOUR_EC2_IP
- **API**: http://YOUR_EC2_IP/api/tutorials
- **Docker Hub**: https://hub.docker.com/u/YOUR_USERNAME

---

## 📈 Performance & Security

### Optimization
- Use multi-stage Docker builds
- Implement health checks
- Add resource limits
- Enable gzip compression

### Security
- Use environment variables for secrets
- Implement HTTPS with Let's Encrypt
- Regular security updates
- Network isolation

---

## 💰 Cost Estimation

- **EC2 t3.medium**: ~$30/month
- **EBS Storage**: ~$8/month
- **Data Transfer**: ~$5/month
- **Total**: ~$43/month

---

## 🎯 Success Criteria

✅ Application accessible via port 80  
✅ CI/CD pipeline working  
✅ Docker images on Docker Hub  
✅ MongoDB data persistence  
✅ Nginx reverse proxy configured  
✅ Auto-deployment on code changes  

---

## 📝 Notes

- Replace `YOUR_USERNAME` with actual Docker Hub username
- Replace `YOUR_EC2_IP` with actual EC2 public IP
- Ensure security groups allow HTTP traffic
- Monitor resource usage and costs
