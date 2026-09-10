import os
import json
import re
from datetime import datetime
from flask import Flask, render_template, request, jsonify, redirect, url_for
from dotenv import load_dotenv
from pymongo import MongoClient
from pymongo.errors import ConnectionFailure, PyMongoError, ServerSelectionTimeoutError

# Load environment variables from .env
load_dotenv()

app = Flask(__name__)
app.secret_key = os.getenv('SECRET_KEY', 'tutedude-devops-secret-key-2026')

# Environment & MongoDB Atlas Configuration
MONGO_URI = os.getenv('MONGO_URI', '')
DB_NAME = os.getenv('DB_NAME', 'devops_db')
COLLECTION_NAME = os.getenv('COLLECTION_NAME', 'student_submissions')

# Initialize MongoDB Atlas Client
mongo_client = None
db = None
collection = None

def get_db_collection():
    global mongo_client, db, collection
    if not MONGO_URI or '<username>' in MONGO_URI:
        raise ValueError('MongoDB URI is not configured. Please set a valid MONGO_URI in your .env file.')
    
    if mongo_client is None:
        mongo_client = MongoClient(MONGO_URI, serverSelectionTimeoutMS=5000)
        # Test connection
        mongo_client.admin.command('ping')
        db = mongo_client[DB_NAME]
        collection = db[COLLECTION_NAME]
    return collection

# -------------------------------------------------------------
# Route: Home / Form Submission Page
# -------------------------------------------------------------
@app.route('/', methods=['GET'])
def index():
    return render_template('index.html')

# -------------------------------------------------------------
# Task 1: JSON API Route
# When this route is accessed, it returns a JSON list read from a backend file.
# -------------------------------------------------------------
@app.route('/api', methods=['GET'])
def get_api_data():
    data_file_path = os.path.join(os.path.dirname(__file__), 'data', 'data.json')
    try:
        if not os.path.exists(data_file_path):
            return jsonify({'status': 'error', 'message': 'Backend data file not found'}), 404
        
        with open(data_file_path, 'r', encoding='utf-8') as f:
            data = json.load(f)
            
        return jsonify(data), 200
    except json.JSONDecodeError as jde:
        return jsonify({'status': 'error', 'message': f'Malformed JSON in backend data file: {str(jde)}'}), 500
    except Exception as e:
        return jsonify({'status': 'error', 'message': f'Server error reading data: {str(e)}'}), 500

# -------------------------------------------------------------
# Task 2: Form Submission to MongoDB Atlas
# - Inserts data into MongoDB Atlas
# - On success: Redirects to /success ('Data submitted successfully')
# - On error: Displays error message on the same page without redirection
# -------------------------------------------------------------
@app.route('/submit', methods=['POST'])
def submit_form():
    name = request.form.get('name', '').strip()
    email = request.form.get('email', '').strip()
    course = request.form.get('course', '').strip()
    message = request.form.get('message', '').strip()

    # Preserve form data in case of error
    form_data = {
        'name': name,
        'email': email,
        'course': course,
        'message': message
    }

    # Validation Checks
    if not name:
        return render_template('index.html', error='Name field is required.', form_data=form_data), 400
    
    if not email:
        return render_template('index.html', error='Email field is required.', form_data=form_data), 400
    
    # Email regex pattern validation
    email_pattern = r'^[a-zA-Z0-9_.+-]+@[a-zA-Z0-9-]+\.[a-zA-Z0-9-.]+$'
    if not re.match(email_pattern, email):
        return render_template('index.html', error='Please enter a valid email address.', form_data=form_data), 400

    if not course:
        return render_template('index.html', error='Please select a course.', form_data=form_data), 400

    # Prepare document for MongoDB
    document = {
        'name': name,
        'email': email,
        'course': course,
        'message': message,
        'submitted_at': datetime.utcnow()
    }

    try:
        col = get_db_collection()
        insert_result = col.insert_one(document)

        if insert_result.inserted_id:
            # On Success: Redirect to success page
            return redirect(url_for('success'))
        else:
            return render_template('index.html', error='Failed to insert document into database.', form_data=form_data), 500

    except ValueError as ve:
        # Configuration error (e.g. dummy/unconfigured URI)
        return render_template('index.html', error=f'Configuration Error: {str(ve)}', form_data=form_data), 400
    except (ConnectionFailure, ServerSelectionTimeoutError) as ce:
        # Database connection/network failure
        return render_template('index.html', error=f'MongoDB Atlas Connection Error: Unable to connect to database. {str(ce)}', form_data=form_data), 503
    except PyMongoError as pe:
        # General MongoDB driver error
        return render_template('index.html', error=f'Database Error: {str(pe)}', form_data=form_data), 500
    except Exception as ex:
        # Any unexpected server error
        return render_template('index.html', error=f'An unexpected error occurred: {str(ex)}', form_data=form_data), 500

# -------------------------------------------------------------
# Success Page Route
# -------------------------------------------------------------
@app.route('/success', methods=['GET'])
def success():
    return render_template('success.html')

if __name__ == '__main__':
    port = int(os.getenv('PORT', 5000))
    debug = os.getenv('DEBUG', 'True').lower() in ('true', '1', 'yes')
    app.run(host='0.0.0.0', port=port, debug=debug)
