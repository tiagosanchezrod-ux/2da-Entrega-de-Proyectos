const express = require('express');
const cors = require('cors');
const { Pool } = require('pg');
require('dotenv').config();

const app = express();
const PORT = process.env.PORT || 3000;

app.use(cors());
app.use(express.json());

const pool = new Pool({
  host: process.env.DB_HOST,
  port: Number(process.env.DB_PORT),
  database: process.env.DB_NAME,
  user: process.env.DB_USER,
  password: process.env.DB_PASSWORD,
});

app.get('/api/recepciones', async (req, res) => {
  try {
    const result = await pool.query(`
      SELECT
        r.id_recepcion,
        r.folio,
        r.fecha_recepcion,
        d.tipo_donante,
        d.nombre_donante,
        r.tipo_aparato,
        r.peso_kg,
        r.responsable_almacen,
        r.estado
      FROM recepciones r
      INNER JOIN donantes d ON r.id_donante = d.id_donante
      ORDER BY r.id_recepcion DESC
    `);
    res.json(result.rows);
  } catch (err) {
    console.error('Error en GET /api/recepciones:', err);
    res.status(500).json({ error: 'Error al consultar las recepciones.' });
  }
});

app.post('/api/recepciones', async (req, res) => {
  const { tipo_donante, nombre_donante, tipo_aparato, peso_kg, responsable_almacen } = req.body;

  if (!tipo_donante || !nombre_donante || !tipo_aparato || !peso_kg || !responsable_almacen) {
    return res.status(400).json({ error: 'Todos los campos son obligatorios.' });
  }

  const pesoNum = Number(peso_kg);
  if (Number.isNaN(pesoNum) || pesoNum <= 0) {
    return res.status(400).json({ error: 'El peso debe ser mayor a 0 kg.' });
  }

  const client = await pool.connect();
  try {
    await client.query('BEGIN');

    let donanteRes = await client.query(
      `SELECT id_donante FROM donantes WHERE tipo_donante = $1 AND nombre_donante = $2`,
      [tipo_donante.trim(), nombre_donante.trim()]
    );

    let idDonante;
    if (donanteRes.rows.length > 0) {
      idDonante = donanteRes.rows[0].id_donante;
    } else {
      const insertDonante = await client.query(
        `INSERT INTO donantes (tipo_donante, nombre_donante) VALUES ($1, $2) RETURNING id_donante`,
        [tipo_donante.trim(), nombre_donante.trim()]
      );
      idDonante = insertDonante.rows[0].id_donante;
    }

    const countRes = await client.query(`SELECT COUNT(*) AS total FROM recepciones`);
    const siguienteNum = 90 + Number(countRes.rows[0].total);
    const folio = `REC-2026-${String(siguienteNum).padStart(3, '0')}`;

    const insertRecepcion = await client.query(
      `INSERT INTO recepciones (folio, id_donante, tipo_aparato, peso_kg, responsable_almacen, estado)
       VALUES ($1, $2, $3, $4, $5, 'En Desensamble')
       RETURNING *`,
      [folio, idDonante, tipo_aparato.trim(), pesoNum, responsable_almacen.trim()]
    );

    await client.query('COMMIT');

    res.status(201).json({
      mensaje: 'Recepción registrada en PostgreSQL.',
      recepcion: {
        ...insertRecepcion.rows[0],
        tipo_donante: tipo_donante.trim(),
        nombre_donante: nombre_donante.trim(),
      },
    });
  } catch (err) {
    await client.query('ROLLBACK');
    console.error('Error en POST /api/recepciones:', err);
    res.status(500).json({ error: 'Error al guardar la recepción en la base de datos.' });
  } finally {
    client.release();
  }
});

app.listen(PORT, () => {
  console.log(`Servidor EcoTrace escuchando en http://localhost:${PORT}`);
});