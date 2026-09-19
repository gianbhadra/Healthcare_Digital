const express = require('express');
const { Pool } = require('pg');
const cors = require('cors');

const app = express();
app.use(express.json());
app.use(cors());

// Konfigurasi koneksi PostgreSQL Anda
const pool = new Pool({
  user: 'postgres',
  host: 'localhost',
  database: 'healthcare_db',
  password: 'k135ya77',
  port: 5432,
});

// --- API MEMBERS ---
// Get all members
app.get('/api/members', async (req, res) => {
  try {
    const result = await pool.query('SELECT * FROM members ORDER BY id DESC');
    res.json(result.rows);
  } catch (err) {
    res.status(500).send(err.message);
  }
});

// Insert member
app.post('/api/members', async (req, res) => {
  const { name, age, dob, gender, nik, blood, isElderly, avatarIcon } = req.body;
  try {
    const query = `INSERT INTO members
      (name, age, dob, gender, nik, blood, "isElderly", "avatarIcon")
      VALUES ($1, $2, $3, $4, $5, $6, $7, $8) RETURNING *`;
    const values = [name, age, dob, gender, nik, blood, isElderly, avatarIcon];
    const result = await pool.query(query, values);
    res.status(201).json(result.rows[0]);
  } catch (err) {
    res.status(500).send(err.message);
  }
});

// --- API HEALTH HISTORY ---
// Get all history
app.get('/api/history', async (req, res) => {
  try {
    const result = await pool.query('SELECT * FROM health_history ORDER BY id DESC');
    res.json(result.rows);
  } catch (err) {
    res.status(500).send(err.message);
  }
});

// Insert history
app.post('/api/history', async (req, res) => {
  const { title, date, location, category, note } = req.body;
  try {
    const query = `INSERT INTO health_history (title, date, location, category, note) VALUES ($1, $2, $3, $4, $5) RETURNING *`;
    const values = [title, date, location, category, note];
    const result = await pool.query(query, values);
    res.status(201).json(result.rows[0]);
  } catch (err) {
    res.status(500).send(err.message);
  }
});

app.listen(3000, () => {
  console.log('Server berjalan di port 3000');
});

// Update member
app.put('/api/members/:id', async (req, res) => {
  const { name, age, dob, gender, nik, blood, isElderly, avatarIcon } = req.body;
  try {
    const query = `UPDATE members
      SET name = $1, age = $2, dob = $3, gender = $4, nik = $5,
          blood = $6, "isElderly" = $7, "avatarIcon" = $8
      WHERE id = $9 RETURNING *`;
    const result = await pool.query(query, [
      name, age, dob, gender, nik, blood, isElderly, avatarIcon, req.params.id,
    ]);
    if (result.rowCount === 0) return res.status(404).json({ error: 'Member tidak ditemukan' });
    res.json(result.rows[0]);
  } catch (err) {
    res.status(500).send(err.message);
  }
});

// Delete member
app.delete('/api/members/:id', async (req, res) => {
  try {
    const result = await pool.query('DELETE FROM members WHERE id = $1', [req.params.id]);
    if (result.rowCount === 0) return res.status(404).json({ error: 'Member tidak ditemukan' });
    res.status(204).send();
  } catch (err) {
    res.status(500).send(err.message);
  }
});

// Update health history
app.put('/api/history/:id', async (req, res) => {
  const { title, date, location, category, note } = req.body;
  try {
    const query = `UPDATE health_history
      SET title = $1, date = $2, location = $3, category = $4, note = $5
      WHERE id = $6 RETURNING *`;
    const result = await pool.query(query, [
      title, date, location, category, note, req.params.id,
    ]);
    if (result.rowCount === 0) return res.status(404).json({ error: 'Riwayat tidak ditemukan' });
    res.json(result.rows[0]);
  } catch (err) {
    res.status(500).send(err.message);
  }
});

// Delete health history
app.delete('/api/history/:id', async (req, res) => {
  try {
    const result = await pool.query('DELETE FROM health_history WHERE id = $1', [req.params.id]);
    if (result.rowCount === 0) return res.status(404).json({ error: 'Riwayat tidak ditemukan' });
    res.status(204).send();
  } catch (err) {
    res.status(500).send(err.message);
  }
});