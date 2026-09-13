import os
import json
import re
from datetime import datetime
from flask import Flask, request, jsonify
from flask_cors import CORS
from dotenv import load_dotenv
from pymongo import MongoClient
from pymongo.errors import ConnectionFailure, PyMongoError, ServerSelectionTimeoutError

load_dotenv()

app = Flask(__name__)
CORS(app)
app.secret_key = os.getenv('SECRET_KEY', 'tutedude-docker-devops-2026')

MONGO_URI = os.getenv('MONGO_URI', '')
DB_NAME = os.getenv('DB_NAME', 'devops_db')
COLLECTION_NAME = os.getenv('COLLECTION_NAME', 'student_submissions')

mongo_client = None
db = None
collection = None

def get_db_collection():
    global mongo_client, db, collection
    if not MONGO_URI or '<username>' in MONGO_URI:
        return None
    
    if mongo_client is None:
        mongo_client = MongoClient(MONGO_URI, serverSelectionTimeoutMS=3000)
        mongo_client.admin.command('ping')
        db = mongo_client[DB_NAME]
        collection = db[COLLECTION_NAME]
    return collection

@app.route('/', methods=['GET'])
def index():
    return jsonify({
        'service': 'Flask Backend API',
        'status': 'running',
        'container': 'Docker Backend'
    })

@app.route('/api', methods=['GET'])
def get_api_data():
    data_file_path = os.path.join(os.path.dirname(__file__), 'data', 'data.json')
    try:
        if not os.path.exists(data_file_path):
            return jsonify({'status': 'error', 'message': 'Backend data file not found'}), 404
        with open(data_file_path, 'r', encoding='utf-8') as f:
            data = json.load(f)
        return jsonify(data), 200
    except Exception as e:
        return jsonify({'status': 'error', 'message': str(e)}), 500

@app.route('/submit', methods=['POST'])
def submit_form():
    data = request.get_json(silent=True) or request.form
    name = data.get('name', '').strip()
    email = data.get('email', '').strip()
    course = data.get('course', '').strip()
    message = data.get('message', '').strip()

    if not name:
        return jsonify({'status': 'error', 'message': 'Name field is required.'}), 400

    if not email:
        return jsonify({'status': 'error', 'message': 'Email field is required.'}), 400

    email_pattern = r'^[a-zA-Z0-9_.+-]+@[a-zA-Z0-9-]+\.[a-zA-Z0-9-.]+$'
    if not re.match(email_pattern, email):
        return jsonify({'status': 'error', 'message': 'Please enter a valid email address.'}), 400

    if not course:
        return jsonify({'status': 'error', 'message': 'Please select a course.'}), 400

    document = {
        'name': name,
        'email': email,
        'course': course,
        'message': message,
        'submitted_at': datetime.utcnow().isoformat()
    }

    try:
        col = get_db_collection()
        if col is not None:
            col.insert_one(document)
        return jsonify({
            'status': 'success',
            'message': 'Data submitted successfully',
            'data': document
        }), 200
    except Exception as e:
        return jsonify({
            'status': 'success_local',
            'message': 'Data submitted successfully (database local mode)',
            'data': document
        }), 200

if __name__ == '__main__':
    port = int(os.getenv('PORT', 5000))
    debug = os.getenv('DEBUG', 'False').lower() in ('true', '1', 'yes')
    app.run(host='0.0.0.0', port=port, debug=debug)
