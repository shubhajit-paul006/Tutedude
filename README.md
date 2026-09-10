# Flask & MongoDB Atlas - DevOps Assignment

**Student Name**: Shubhajit Paul  
**Course**: DevOps Masterclass (TuteDude)  
**Assignment**: Git & GitHub DevOps Assignment
**GitHub Repository Link**: [https://github.com/shubhajit-paul006/Tutedude.git](https://github.com/shubhajit-paul006/Tutedude.git)

---

## Project Overview
This project fulfills all TuteDude DevOps Assignment requirements:
1. **Task 1: JSON API Route (/api)**: A Flask API route that reads stored data from a backend file (data/data.json) and returns it as a JSON response.
2. **Task 2: Frontend Form with MongoDB Atlas**: A frontend form that submits user data to MongoDB Atlas.
   - **On Success**: Redirects to /success displaying: *Data submitted successfully*.
   - **On Error**: Displays validation or database error messages on the same page without redirecting.

---

## Project Structure
- data/data.json: Backend JSON storage for Task 1 (/api)
- static/style.css: Custom modern UI styling
- 	emplates/index.html: Frontend submission form (handles errors in-place)
- 	emplates/success.html: Success redirect page (Data submitted successfully)
- pp.py: Main Flask application with routes & DB logic
- 	est_app.py: Automated unit test suite
- 
equirements.txt: Project dependencies (Flask, PyMongo, python-dotenv, dnspython)
- .env.example: Template environment configuration
- .env: Active environment configuration
- DOCUMENTATION.md: Submission documentation & screenshot guide
- README.md: Quickstart guide

---

## Installation & Running

### 1. Install Dependencies
pip install -r requirements.txt

### 2. Configure Environment (.env)
Update .env with your MongoDB Atlas connection string.

### 3. Run the Server
python app.py

Visit http://127.0.0.1:5000 in your web browser.

---

## Testing
Run automated unit tests:
python test_app.py

---

## Packaging
Compress the folder into Flask_and_MongoDB_ShubhajitPaul.zip
