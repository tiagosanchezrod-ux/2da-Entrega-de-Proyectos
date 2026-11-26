# Normalización del Esquema 

## 1. Decisión de diseño y normalización
En lugar de almacenar todos los datos de recepción en una única tabla plana (lo que provocaría redundancia y anomalías de actualización al repetir `tipo_donante` y `nombre_donante` cada vez que un mismo donante realiza una entrega), el esquema se descompuso en dos relaciones principales: **`donantes`** y **`recepciones`**.

## 2. Claves candidatas y dependencias funcionales (DF)

### Tabla `donantes`
* **Claves candidatas:** `{id_donante}` (clave primaria) y `{tipo_donante, nombre_donante}` (clave candidata natural).
* **Dependencias funcionales:**
  * `id_donante -> tipo_donante, nombre_donante`
  * `tipo_donante, nombre_donante -> id_donante`

### Tabla `recepciones`
* **Claves candidatas:** `{id_recepcion}` (clave primaria) y `{folio}` (clave candidata única).
* **Dependencias funcionales:**
  * `id_recepcion -> folio, fecha_recepcion, id_donante, tipo_aparato, peso_kg, responsable_almacen, estado`
  * `folio -> id_recepcion, fecha_recepcion, id_donante, tipo_aparato, peso_kg, responsable_almacen, estado`

## 3. Verificación hasta 3FN y FNBC

* **Primera Forma Normal (1FN):** Se cumple porque todos los atributos contienen valores atómicos e indivisibles.
* **Segunda Forma Normal (2FN):** Se cumple porque ambas tablas cuentan con claves primarias simples de un solo atributo (`id_donante` e `id_recepcion`), por lo que no existen dependencias funcionales parciales.
* **Tercera Forma Normal (3FN):** Se cumple porque ningún atributo no primo depende transitivamente de la clave primaria gracias a otro atributo no primo; los datos del donante viven exclusivamente en `donantes` y se referencian mediante la clave foránea `id_donante`.
* **Forma Normal de Boyce-Codd (FNBC):** Para toda dependencia funcional no trivial $X \to Y$ en `donantes` y `recepciones`, el determinante X es una superclave. Entonces el esquema satisface FNBC.