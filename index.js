const express = require('express');
const { Pool } = require('pg');
const cors = require('cors');

const app = express();
app.use(express.json());
app.use(cors());

function getDefaultMembers() {
  return [
    {
      id: 1,
      name: 'Gian Bhadra Q.K.',
      age: '23 th',
      dob: '2002-05-14',
      gender: 'Laki-laki',
      nik: '3201011405020001',
      blood: 'A+',
      isElderly: false,
      avatarIcon: 0xE7FD,
    },
    {
      id: 2,
      name: 'Sipian Eka Nugraha',
      age: '27 th',
      dob: '1999-08-09',
      gender: 'Laki-laki',
      nik: '3201010908990002',
      blood: 'O+',
      isElderly: false,
      avatarIcon: 0xE7FD,
    },
    {
      id: 3,
      name: 'Rifqy Rahmad L.H.',
      age: '25 th',
      dob: '2001-03-22',
      gender: 'Laki-laki',
      nik: '3201012203010003',
      blood: 'B+',
      isElderly: false,
      avatarIcon: 0xE7FD,
    },
    {
      id: 4,
      name: 'Ilhamsyah Adi K.',
      age: '29 th',
      dob: '1997-11-18',
      gender: 'Laki-laki',
      nik: '3201011811970004',
      blood: 'AB+',
      isElderly: false,
      avatarIcon: 0xE7FD,
    },
  ];
}

async function seedDefaultMembers() {
  try {
    const check = await pool.query('SELECT COUNT(*) AS total FROM members');
    if (Number(check.rows[0].total) > 0) return;

    const members = getDefaultMembers();
    for (const member of members) {
      await pool.query(
        `INSERT INTO members (name, age, dob, gender, nik, blood, "isElderly", "avatarIcon")
         VALUES ($1, $2, $3, $4, $5, $6, $7, $8)`,
        [
          member.name,
          member.age,
          member.dob,
          member.gender,
          member.nik,
          member.blood,
          member.isElderly,
          member.avatarIcon,
        ],
      );
    }
    console.log('Default members seeded successfully.');
  } catch (err) {
    console.error('Seed default members skipped:', err.message);
  }
}

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
    res.json(result.rows.length ? result.rows : getDefaultMembers());
  } catch (err) {
    console.error('Falling back to default members:', err.message);
    res.json(getDefaultMembers());
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