# Docker & Docker Compose - DevOps Assignment

**Student Name**: Shubhajit Paul  
**Course**: DevOps Masterclass (TuteDude)  
**Assignment**: Docker Assignment (Full-Stack Containerization)  
**GitHub Repository Link**: [https://github.com/shubhajit-paul006/Tutedude.git](https://github.com/shubhajit-paul006/Tutedude.git)  
**Docker Hub Images**:  
- Frontend Image: shubhajitpaul006/devops-frontend:latest
- Backend Image: shubhajitpaul006/devops-backend:latest

---

## 📌 Project Architecture
This project containerizes a full-stack web application:
1. **Frontend**: Node.js with Express and EJS rendering the user submission form.
2. **Backend**: Python with Flask REST API handling data processing and validation.
3. **Orchestration**: docker-compose.yml linking both services in a custom bridge network (pp-network).

---

## 📂 Project Structure
`	ext
Docker_ShubhajitPaul/
├── frontend/
│   ├── public/
│   │   └── style.css            # Responsive modern UI stylesheet
│   ├── views/
│   │   ├── index.ejs            # User registration form (Node.js/Express)
│   │   └── success.ejs          # Success confirmation page
│   ├── server.js                # Express web server communicating with Flask
│   ├── package.json             # Express, EJS, Axios dependencies
│   ├── .dockerignore            # Ignores node_modules and temp files
│   └── Dockerfile               # Node.js alpine container build
│
├── backend/
│   ├── data/
│   │   └── data.json            # JSON dataset returned by /api
│   ├── app.py                   # Flask REST API handling submissions
│   ├── requirements.txt         # Flask, flask-cors, pymongo, python-dotenv
│   ├── .dockerignore            # Ignores __pycache__ and .env
│   └── Dockerfile               # Python 3.11-slim container build
│
├── docker-compose.yml           # Multi-service container orchestration
├── .gitignore                   # Ignores node_modules, .env, .vscode, archives
├── DOCUMENTATION.md             # Complete step-by-step submission documentation
└── README.md                    # Quickstart guide
`

---

## 🚀 How to Run with Docker Compose

### 1. Build and Run the Services
`ash
docker compose up -d --build
`

### 2. Access the Applications
- **Node.js Frontend Form**: http://localhost:3000
- **Flask Backend API**: http://localhost:5000
- **JSON API**: http://localhost:5000/api

### 3. Stop Containers
`ash
docker compose down
`

---

## 🐳 Docker Hub Commands

`ash
# 1. Login to Docker Hub
docker login

# 2. Build and Tag Images
docker build -t shubhajitpaul006/devops-frontend:latest ./frontend
docker build -t shubhajitpaul006/devops-backend:latest ./backend

# 3. Push to Docker Hub
docker push shubhajitpaul006/devops-frontend:latest
docker push shubhajitpaul006/devops-backend:latest
`
