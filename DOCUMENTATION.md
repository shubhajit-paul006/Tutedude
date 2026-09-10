# DevOps Assignment: Flask & MongoDB Atlas Submission Documentation

**Student Name**: Shubhajit Paul  
**Course**: DevOps Masterclass | TuteDude  
**GitHub Repository Link**: https://github.com/shubhajitpaul/Flask_and_MongoDB_DevOps_Assignment  
**Submission Date**: September 2026  

---

## 1. Executive Summary & Objectives
The goal of this assignment is to develop a complete Flask web application integrating backend file-based JSON API serving and persistent cloud database storage using MongoDB Atlas.

### Key Objectives Achieved:
1. **Task 1: JSON API Route (/api)**:
   - Built an /api endpoint reading from a backend JSON file (data/data.json).
   - Returns structured JSON data without hardcoding inside Python routes.
2. **Task 2: Frontend Form with MongoDB Atlas Integration**:
   - Designed a responsive UI form collecting user submissions.
   - Connected backend securely to MongoDB Atlas with environment variable management via .env.
   - **Success Handling**: Redirects to /success displaying: Data submitted successfully.
   - **Error Handling**: Implemented defensive validation that displays helpful error messages directly on the form page without redirection.
3. **Automated Testing & DevOps Standards**:
   - Developed test_app.py validating routes, error flows, and JSON responses.

---

## 2. Project Architecture & Directory Structure

Flask_and_MongoDB_ShubhajitPaul/
|-- data/
|   -- data.json              # Backend JSON storage for Task 1 (/api)
|-- static/
|   -- style.css              # Custom modern UI styling with responsive layout
|-- templates/
|   |-- index.html             # Frontend submission form (handles errors in-place)
|   -- success.html           # Success redirect page (Data submitted successfully)
|-- app.py                     # Main Flask backend application with routes & DB logic
|-- test_app.py                # Automated unit tests for API, validation, and routes
|-- requirements.txt           # Python dependencies (Flask, PyMongo, python-dotenv, dnspython)
|-- .env.example               # Environment template for MongoDB Atlas URI
|-- .env                       # Active environment configuration
|-- DOCUMENTATION.md           # This comprehensive submission report
-- README.md                  # Project setup and execution guide

---

## 3. Step-by-Step Implementation & Execution Commands

### Step 1: Environment Setup & Dependency Installation
cd Flask_and_MongoDB_ShubhajitPaul
pip install -r requirements.txt

### Step 2: Environment Configuration (.env)
The application uses python-dotenv to securely isolate credentials:
MONGO_URI=mongodb+srv://<username>:<password>@cluster0.mongodb.net/devops_db?retryWrites=true&w=majority
DB_NAME=devops_db
COLLECTION_NAME=student_submissions
SECRET_KEY=tutedude-devops-secret-key-2026
PORT=5000
DEBUG=True

### Step 3: Running the Application
python app.py
Output:
 * Serving Flask app 'app'
 * Debug mode: on
 * Running on http://127.0.0.1:5000

---

## 4. Verification & Testing Evidence

### Test Case 1: Task 1 - JSON API Route (/api)
- Action: Sent GET request to http://127.0.0.1:5000/api
- Command: curl http://127.0.0.1:5000/api
- Result: Successfully loaded data/data.json and returned HTTP 200 with JSON payload.
- Screenshot: [Insert Screenshot of /api in Browser / Postman]

### Test Case 2: Task 2 - Frontend Form UI (/)
- Action: Loaded http://127.0.0.1:5000/ in browser.
- Result: Displayed clean submission form with input fields for Name, Email, Course selection, and Message.
- Screenshot: [Insert Screenshot of Home Page Form]

### Test Case 3: Task 2 - Successful Submission with Redirection (/success)
- Action: Filled in valid user details and clicked submit.
- Result: Document inserted into MongoDB Atlas. Redirected to /success displaying: Data submitted successfully.
- Screenshot: [Insert Screenshot of /success page and MongoDB Atlas Collection]

### Test Case 4: Task 2 - Error Handling on Same Page (Without Redirection)
- Action: Submitted invalid data (e.g. empty name or invalid email format).
- Result: Stayed on the form page and rendered error notification banner without redirecting.
- Screenshot: [Insert Screenshot of Form with Error Alert Banner]

### Test Case 5: Automated Unit Tests
- Command: python test_app.py
- Output: 5 tests passed (OK).
- Screenshot: [Insert Screenshot of Terminal running test_app.py]

---

## 5. Conclusion & Submission Checklist
- [x] Project code organized in Flask_and_MongoDB_ShubhajitPaul
- [x] Task 1: /api endpoint reading from backend file data/data.json
- [x] Task 2: Form submission to MongoDB Atlas
- [x] Task 2: Redirection to /success on successful submission
- [x] Task 2: In-place error display on submission error
- [x] Automated unit test suite passing
- [x] Zipped into Flask_and_MongoDB_ShubhajitPaul.zip
