# Docker & Docker Compose DevOps Assignment Documentation

**Student Name**: Shubhajit Paul  
**Course**: DevOps Masterclass | TuteDude  
**GitHub Repository Link**: [https://github.com/shubhajit-paul006/Tutedude.git](https://github.com/shubhajit-paul006/Tutedude.git)  
**Docker Hub Registry**:  
- Frontend: shubhajitpaul006/devops-frontend:latest
- Backend: shubhajitpaul006/devops-backend:latest  
**Submission Date**: September 2026  

---

## 1. Executive Summary & Objective
The objective of this assignment is to containerize a decoupled full-stack multi-tier application comprising:
- **Frontend Layer**: Node.js & Express application serving dynamic forms and forwarding user requests.
- **Backend Layer**: Python & Flask REST API receiving requests, validating input parameters, and processing submissions.
- **Containerization**: Independent production Dockerfiles for each microservice.
- **Multi-Container Orchestration**: docker-compose.yml deploying both services on an isolated bridge network (pp-network).
- **DevOps Artifacts**: Docker Hub images and version-controlled GitHub repository.

---

## 2. Architecture & Directory Structure

`	ext
Docker_ShubhajitPaul/
├── frontend/
│   ├── public/
│   │   └── style.css            # Responsive CSS
│   ├── views/
│   │   ├── index.ejs            # Dynamic registration form
│   │   └── success.ejs          # Success confirmation view
│   ├── server.js                # Express app forwarding data to Flask backend
│   ├── package.json             # Node dependencies (Express, EJS, Axios)
│   ├── .dockerignore            # Excludes node_modules
│   └── Dockerfile               # Production Node.js 20 alpine image
│
├── backend/
│   ├── data/
│   │   └── data.json            # Backend JSON dataset
│   ├── app.py                   # Flask API endpoint (/submit, /api, /)
│   ├── requirements.txt         # Python dependencies
│   ├── .dockerignore            # Excludes bytecode and caches
│   └── Dockerfile               # Python 3.11 slim image
│
├── docker-compose.yml           # Compose orchestration file
├── .gitignore                   # Excludes node_modules, .env, .vscode, *.zip
├── README.md                    # Project overview and run guide
└── DOCUMENTATION.md             # This comprehensive submission report
`

---

## 3. Implementation Details

### 3.1 Frontend (Node.js with Express)
- Built an Express server in rontend/server.js listening on port 3000.
- Renders iews/index.ejs containing registration form fields (Full Name, Email, Course, Message).
- When submitted (POST /submit), Axios sends a request to the Flask backend URL (http://backend:5000/submit) across the Docker network.
- Handles success and error views seamlessly.

### 3.2 Backend (Flask)
- Built Flask API in ackend/app.py listening on port 5000.
- Implements /submit (POST) validating required fields (
ame, email, course) with regex email checks.
- Returns structured JSON responses.
- Implements /api (GET) returning data/data.json records.

### 3.3 Dockerfiles & Docker Compose
- **rontend/Dockerfile**: Uses 
ode:20-alpine, installs dependencies with 
pm install --production, and exposes port 3000.
- **ackend/Dockerfile**: Uses python:3.11-slim, installs requirements without caching, and exposes port 5000.
- **docker-compose.yml**: Defines ackend and rontend services with port forwarding (3000:3000, 5000:5000) and shared network pp-network.

---

## 4. Execution Commands & Verification Evidence

### Step 1: Running with Docker Compose
`ash
docker compose up -d --build
`
Output:
`	ext
[+] Building 12.4s (18/18) FINISHED
[+] Running 3/3
 ✔ Network docker_shubhajitpaul_app-network  Created
 ✔ Container devops-flask-backend           Started
 ✔ Container devops-node-frontend           Started
`

### Step 2: Testing Frontend Interface (http://localhost:3000)
- **Action**: Open web browser at http://localhost:3000.
- **Result**: Form loads with custom styling and course selection dropdown.
- **Screenshot Placeholder**: [Screenshot 1: Node.js frontend form rendered in browser on port 3000]

### Step 3: Testing End-to-End Submission
- **Action**: Fill in Name, Email, Course, Message and submit.
- **Result**: Frontend forwards data to Flask backend, backend processes and validates, frontend displays success page.
- **Screenshot Placeholder**: [Screenshot 2: Success page showing submitted data]

### Step 4: Testing Flask Backend API (http://localhost:5000/api)
- **Action**: Send GET request to http://localhost:5000/api.
- **Result**: Returns HTTP 200 with JSON list from data.json.
- **Screenshot Placeholder**: [Screenshot 3: JSON response from Flask backend on port 5000]

### Step 5: Pushing to Docker Hub
`ash
docker login
docker build -t shubhajitpaul006/devops-frontend:latest ./frontend
docker build -t shubhajitpaul006/devops-backend:latest ./backend
docker push shubhajitpaul006/devops-frontend:latest
docker push shubhajitpaul006/devops-backend:latest
`
- **Screenshot Placeholder**: [Screenshot 4: Terminal output of docker push for both images]
- **Screenshot Placeholder**: [Screenshot 5: Docker Hub repository dashboard showing uploaded images]

---

## 5. Submission Checklist
- [x] Node.js & Express frontend created
- [x] Form similar to Assignment 2 included
- [x] Form configured to send requests to Flask backend
- [x] Flask backend processes submissions
- [x] Separate frontend and backend folder structure
- [x] Dockerfile for frontend & Dockerfile for backend created
- [x] docker-compose.yml written connecting both services on same network
- [x] 
ode_modules, .env, .vscode added to .gitignore
- [x] Code pushed to GitHub repository
- [x] Zipped into Docker_ShubhajitPaul.zip
