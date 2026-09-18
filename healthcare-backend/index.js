require('dotenv').config();

const express = require('express');
const { Pool } = require('pg');
const cors = require('cors');

const app = express();
app.use(express.json());
app.use(cors());

function normalizeDate(value) {
  if (!value) return value;
  const text = String(value).trim();
  if (/^\d{4}-\d{2}-\d{2}$/.test(text)) return text;
  const months = {
    januari: '01', jan: '01', februari: '02', feb: '02',
    maret: '03', mar: '03', april: '04', apr: '04',
    mei: '05', may: '05', juni: '06', jun: '06',
    juli: '07', jul: '07', agustus: '08', agu: '08', aug: '08',
    september: '09', sep: '09', oktober: '10', okt: '10', oct: '10',
    november: '11', nov: '11', desember: '12', des: '12', dec: '12',
  };
  const match = text.match(/^(\d{1,2})\s+([A-Za-z]+)\s+(\d{4})$/);
  if (!match) return value;
  const month = months[match[2].toLowerCase()];
  return month ? `${match[3]}-${month}-${match[1].padStart(2, '0')}` : value;
}

// Konfigurasi koneksi PostgreSQL Anda
const pool = new Pool({
  user: process.env.PGUSER || 'postgres',
  host: process.env.PGHOST || 'localhost',
  database: process.env.PGDATABASE || 'healthcare_db',
  password: process.env.PGPASSWORD,
  port: Number(process.env.PGPORT || 5432),
});

pool.on('error', (err) => {
  console.error('PostgreSQL connection error:', err.message);
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
    const values = [name, age, normalizeDate(dob), gender, nik, blood, isElderly, avatarIcon];
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
    const values = [title, normalizeDate(date), location, category, note];
    const result = await pool.query(query, values);
    res.status(201).json(result.rows[0]);
  } catch (err) {
    res.status(500).send(err.message);
  }
});

const port = Number(process.env.PORT || 3000);
app.listen(port, async () => {
  try {
    await pool.query('SELECT 1');
    console.log(`Server berjalan di port ${port}; PostgreSQL terhubung`);
  } catch (err) {
    console.error('Server berjalan, tetapi PostgreSQL gagal terhubung:', err.message);
  }
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
      name, age, normalizeDate(dob), gender, nik, blood, isElderly, avatarIcon, req.params.id,
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
      title, normalizeDate(date), location, category, note, req.params.id,
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