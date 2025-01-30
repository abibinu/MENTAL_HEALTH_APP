const express = require('express');
const bodyParser = require('body-parser');
const cors = require('cors');
const bcrypt = require('bcrypt'); // For password hashing
const pool = require('./db'); // Import PostgreSQL connection pool
const chatbotRouter = require('./chatbot');
const moodLogsRouter = require('./moodLogs');

const app = express();

app.use(cors());
app.use(bodyParser.json());
app.use(bodyParser.urlencoded({ extended: true }));

app.use('/api', chatbotRouter);
app.use('/api', moodLogsRouter);

// Default route
app.get('/', (req, res) => {
    res.send('API is working!');
});

// Register route
app.post('/register', async (req, res) => {
    const { name, email, password } = req.body;

    if (!name || !email || !password) {
        return res.status(400).json({ message: 'All fields are required.' });
    }

    try {
        // Check if email already exists
        const checkEmailQuery = 'SELECT * FROM users WHERE email = $1';
        const emailResult = await pool.query(checkEmailQuery, [email]);

        if (emailResult.rows.length > 0) {
            return res.status(409).json({ message: 'Email already exists.' });
        }

        // Hash the password
        const hashedPassword = await bcrypt.hash(password, 10);

        // Insert the new user
        const insertQuery = `
            INSERT INTO users (name, email, password_hash, created_at)
            VALUES ($1, $2, $3, NOW())
        `;
        await pool.query(insertQuery, [name, email, hashedPassword]);

        res.status(201).json({ message: 'User registered successfully!' });
    } catch (err) {
        console.error('Error during registration:', err);
        res.status(500).json({ message: 'Database error.' });
    }
});

// Login route
app.post('/login', async (req, res) => {
    const { email, password } = req.body;

    if (!email || !password) {
        return res.status(400).json({ message: 'All fields are required.' });
    }

    try {
        // Check if the user exists
        const sql = 'SELECT * FROM users WHERE email = $1';
        const userResult = await pool.query(sql, [email]);

        if (userResult.rows.length === 0) {
            return res.status(404).json({ message: 'User not found.' });
        }

        const user = userResult.rows[0];

        // Compare the hashed password
        const isMatch = await bcrypt.compare(password, user.password_hash);

        if (!isMatch) {
            return res.status(401).json({ message: 'Invalid password.' });
        }

        res.status(200).json({
            message: 'Login successful!',
            user_id: user.user_id,
            name: user.name,
        });
    } catch (err) {
        console.error('Error during login:', err);
        res.status(500).json({ message: 'Database error.' });
    }
});

// Start the server
const PORT = 5000;
app.listen(PORT, '0.0.0.0', () => {
    console.log(`Server is running on http://0.0.0.0:${PORT}`);
});
