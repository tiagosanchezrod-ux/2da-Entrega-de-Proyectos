-- PRÁCTICA INTEGRADA: ÁLGEBRA RELACIONAL Y SQL EQUIVALENTE

-- 1. SELECCIÓN (σ) y PROYECCIÓN (π) recepciones con peso mayor a 20 kg mostrando folio, aparato y peso
SELECT folio, tipo_aparato, peso_kg
FROM recepciones
WHERE peso_kg > 20;

-- 2. REUNIÓN INTERNA / INNER JOIN (⋈) recepciones con el nombre y tipo de su donante
SELECT r.folio, d.nombre_donante, d.tipo_donante, r.tipo_aparato, r.peso_kg, r.estado
FROM recepciones r
INNER JOIN donantes d ON r.id_donante = d.id_donante;

-- 3. PRODUCTO CARTESIANO (×) todas las combinaciones posibles entre donantes y recepciones
SELECT d.id_donante, d.nombre_donante, r.folio, r.tipo_aparato
FROM donantes d
CROSS JOIN recepciones r;

-- 4. OPERACIONES DE CONJUNTOS (∪, ∩, −)
-- UNIÓN (∪): Donantes que entregaron más de 100 kg
SELECT d.id_donante, d.nombre_donante
FROM donantes d
JOIN recepciones r ON d.id_donante = r.id_donante
WHERE r.peso_kg > 100
UNION
SELECT d.id_donante, d.nombre_donante
FROM donantes d
JOIN recepciones r ON d.id_donante = r.id_donante
WHERE r.estado = 'Clasificado';

-- INTERSECCIÓN (∩): Donantes con peso > 10 kg
SELECT d.id_donante, d.nombre_donante
FROM donantes d
JOIN recepciones r ON d.id_donante = r.id_donante
WHERE r.peso_kg > 10
INTERSECT
SELECT d.id_donante, d.nombre_donante
FROM donantes d
JOIN recepciones r ON d.id_donante = r.id_donante
WHERE r.estado = 'En Desensamble';

-- DIFERENCIA (−): Todos los donantes registrados EXCEPTO los que tienen estado 'Clasificado'
SELECT id_donante, nombre_donante
FROM donantes
EXCEPT
SELECT d.id_donante, d.nombre_donante
FROM donantes d
JOIN recepciones r ON d.id_donante = r.id_donante
WHERE r.estado = 'Clasificado';

-- 5. AGRUPACIÓN Y FUNCIONES DE AGREGADO (γ) total de recepciones y suma de kilogramos recibidos
SELECT d.tipo_donante,
       COUNT(r.id_recepcion) AS total_recepciones,
       SUM(r.peso_kg) AS peso_total_kg
FROM donantes d
LEFT JOIN recepciones r ON d.id_donante = r.id_donante
GROUP BY d.tipo_donante;

-- 6. DIVISIÓN RELACIONAL (÷) donantes que tienen recepciones en TODOS los estados distintos
SELECT d.id_donante, d.nombre_donante
FROM donantes d
WHERE NOT EXISTS (
    SELECT DISTINCT r_estados.estado
    FROM recepciones r_estados
    EXCEPT
    SELECT r_donante.estado
    FROM recepciones r_donante
    WHERE r_donante.id_donante = d.id_donante
);