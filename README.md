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



# MEAN Stack CRUD Application - DevOps Deployment

Full-stack MEAN (MongoDB, Express, Angular, Node.js) application with complete CI/CD pipeline.

## 🏗️ Architecture

- **Frontend**: Angular + Nginx
- **Backend**: Node.js + Express
- **Database**: MongoDB
- **Containerization**: Docker
- **Orchestration**: Docker Compose
- **CI/CD**: GitHub Actions
- **Reverse Proxy**: Nginx
- **Cloud**: AWS EC2 (Ubuntu 22.04)

## 📁 Project Structure
```
.
├── backend/
│   ├── Dockerfile
│   ├── package.json
│   └── src/
├── frontend/
│   ├── Dockerfile
│   ├── nginx.conf
│   └── src/
├── .github/
│   └── workflows/
│       └── ci-cd.yml
├── docker-compose.yml
├── docker-compose.prod.yml
└── README.md
```

## 🚀 Local Development

### Prerequisites
- Node.js 18+
- Docker & Docker Compose
- Git

### Setup
```bash
# Clone repository
git clone https://github.com/YOUR_USERNAME/mean-crud-app.git
cd mean-crud-app

# Start with Docker Compose
docker-compose up -d

# Access application
# Frontend: http://localhost:80
# Backend: http://localhost:3000
```

## 🐳 Docker Images

- Backend: `YOUR_USERNAME/mean-backend:latest`
- Frontend: `YOUR_USERNAME/mean-frontend:latest`

## ☁️ Production Deployment

### Infrastructure Setup

1. **EC2 Instance**
   - Ubuntu 22.04 LTS
   - t2.medium or higher
   - Security Groups: 22, 80, 443, 3000

2. **Installation Commands**
```bash
# Docker
curl -fsSL https://get.docker.com -o get-docker.sh
sudo sh get-docker.sh

# Docker Compose
sudo curl -L "https://github.com/docker/compose/releases/latest/download/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
sudo chmod +x /usr/local/bin/docker-compose

# Nginx
sudo apt install -y nginx
```

3. **Deploy Application**
```bash
git clone https://github.com/YOUR_USERNAME/mean-crud-app.git
cd mean-crud-app
docker-compose -f docker-compose.prod.yml up -d
```

## 🔄 CI/CD Pipeline

### GitHub Actions Workflow

Triggers on push to `main` branch:

1. **Build Stage**
   - Checkout code
   - Build Docker images
   - Push to Docker Hub

2. **Deploy Stage**
   - SSH to EC2
   - Pull latest images
   - Restart containers

### Required Secrets

Configure in GitHub Settings → Secrets:
- `DOCKERHUB_USERNAME`
- `DOCKERHUB_TOKEN`
- `EC2_HOST`
- `EC2_USERNAME`
- `EC2_SSH_KEY`

## 🌐 Nginx Configuration

Reverse proxy setup at `/etc/nginx/sites-available/mean-app`:
- Routes `/` to frontend (port 80)
- Routes `/api` to backend (port 3000)

## 📊 Monitoring
```bash
# Check container status
docker ps

# View logs
docker-compose logs -f

# Check Nginx status
sudo systemctl status nginx
```

## 🔧 Useful Commands
```bash
# Restart application
docker-compose restart

# Update application
git pull && docker-compose pull && docker-compose up -d

# Clean Docker
docker system prune -af

# Backup MongoDB
docker exec mean-mongodb mongodump --out /backup
```

## 📸 Screenshots

### 1. CI/CD Pipeline
![GitHub Actions](.docs/github-actions.png)

### 2. Docker Hub
![Docker Images](.docs/docker-hub.png)

### 3. Application UI
![App Running](.docs/app-ui.png)

### 4. Infrastructure
![AWS EC2](.docs/ec2-instance.png)

## 🐛 Troubleshooting

### Container not starting
```bash
docker-compose logs backend
docker-compose restart backend
```

### MongoDB connection issues
```bash
docker exec -it mean-mongodb mongo -u admin -p admin123
```

### Nginx issues
```bash
sudo nginx -t
sudo systemctl restart nginx
```

## 📝 Environment Variables

### Backend (.env)
```
PORT=3000
MONGODB_URI=mongodb://admin:admin123@mongodb:27017/meandb?authSource=admin
NODE_ENV=production
```

## 👥 Contributing

1. Fork the repository
2. Create feature branch
3. Commit changes
4. Push to branch
5. Create Pull Request

## 📄 License

MIT License

## 👤 Author

Your Name - [@yourusername](https://github.com/yourusername)

## 🔗 Links

- [Live Application](http://YOUR_EC2_PUBLIC_IP)
- [Docker Hub](https://hub.docker.com/u/YOUR_USERNAME)
- [GitHub Repository](https://github.com/YOUR_USERNAME/mean-crud-app)
