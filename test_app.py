import unittest
import json
import os
from app import app

class FlaskMongoAppTestCase(unittest.TestCase):
    def setUp(self):
        self.app = app.test_client()
        self.app.testing = True

    def test_home_page(self):
        response = self.app.get('/')
        self.assertEqual(response.status_code, 200)
        self.assertIn('Flask & MongoDB Atlas'.encode(), response.data)

    def test_json_api_route(self):
        response = self.app.get('/api')
        self.assertEqual(response.status_code, 200)
        self.assertEqual(response.content_type, 'application/json')
        data = json.loads(response.data)
        self.assertIsInstance(data, list)
        self.assertGreater(len(data), 0)
        self.assertIn('course', data[0])
        print('[PASS] /api returned JSON list successfully.')

    def test_form_validation_missing_name(self):
        response = self.app.post('/submit', data={'name': '', 'email': 'test@example.com', 'course': 'DevOps'})
        self.assertEqual(response.status_code, 400)
        self.assertIn('Name field is required.'.encode(), response.data)
        print('[PASS] Missing name validation verified.')

    def test_form_validation_invalid_email(self):
        response = self.app.post('/submit', data={'name': 'Shubhajit', 'email': 'bademail', 'course': 'DevOps'})
        self.assertEqual(response.status_code, 400)
        self.assertIn('Please enter a valid email address.'.encode(), response.data)
        print('[PASS] Invalid email validation verified.')

    def test_success_page(self):
        response = self.app.get('/success')
        self.assertEqual(response.status_code, 200)
        self.assertIn('Data submitted successfully'.encode(), response.data)
        print('[PASS] Success page verified.')

if __name__ == '__main__':
    unittest.main()
