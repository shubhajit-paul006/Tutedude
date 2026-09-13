const express = require('express');
const axios = require('axios');
const path = require('path');

const app = express();
const PORT = process.env.PORT || 3000;
const BACKEND_URL = process.env.BACKEND_URL || 'http://backend:5000';


app.set('view engine', 'ejs');
app.set('views', path.join(__dirname, 'views'));

app.use(express.urlencoded({ extended: true }));
app.use(express.json());
app.use(express.static(path.join(__dirname, 'public')));


app.get('/', async (req, res) => {
  res.render('index', {
    error: null,
    success: null,
    formData: {},
    backendUrl: BACKEND_URL
  });
});


app.post('/submit', async (req, res) => {
  const { name, email, course, message } = req.body;
  const formData = { name, email, course, message };

  try {
    const targetUrl = BACKEND_URL + '/submit';
    const response = await axios.post(targetUrl, formData, {
      headers: { 'Content-Type': 'application/json' },
      timeout: 5000
    });

    if (response.status === 200 || response.status === 201) {
      return res.render('success', {
        message: response.data.message || 'Data submitted successfully',
        data: response.data.data || formData
      });
    } else {
      return res.render('index', {
        error: response.data.message || 'Failed to process submission.',
        success: null,
        formData,
        backendUrl: BACKEND_URL
      });
    }
  } catch (err) {
    const errorMsg = err.response && err.response.data && err.response.data.message
      ? err.response.data.message
      : 'Unable to connect to Flask backend at ' + BACKEND_URL + ' (' + err.message + ')';

    return res.render('index', {
      error: errorMsg,
      success: null,
      formData,
      backendUrl: BACKEND_URL
    });
  }
});


app.get('health', (req, res) => {
  res.json({ status: 'Frontend is running', port: PORT, backend: BACKEND_URL });
});

app.listen(PORT, () => {
  console.log('[Frontend] Server running on http://localhost:' + PORT);
  console.log('[Frontend] Connected to Flask backend at: ' + BACKEND_URL);
});
