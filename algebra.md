# Álgebra Relacional

## 1. Consulta representativa

**Pregunta:** Obtener el folio, nombre y tipo del donante, tipo de aparato y peso en kilogramos de todas las recepciones cuyo peso supere los 5 kg.

### Expresión en Álgebra Relacional (RelaX)

```text
π folio, nombre_donante, tipo_donante, tipo_aparato, peso_kg (
  σ peso_kg > 5 (recepciones ⋈ recepciones.id_donante = donantes.id_donante donantes)
)

Consulta SQL equivalente (PostgreSQL)
SQL
SELECT
    r.folio,
    d.nombre_donante,
    d.tipo_donante,
    r.tipo_aparato,
    r.peso_kg
FROM recepciones r
INNER JOIN donantes d ON r.id_donante = d.id_donante
WHERE r.peso_kg > 5;
Comparación de resultados
La reunión (⋈) sobre id_donante equivale al INNER JOIN entre recepciones y donantes.

La selección (σ) con peso_kg > 5 equivale al filtro WHERE r.peso_kg > 5.

La proyección (π) equivale a las columnas elegidas en el SELECT.

Evidencia de ejecución
Ejecución en PostgreSQL (pgAdmin 4):

Árbol de operadores y resultados en RelaX:

2. Operaciones relacionales adicionales
Los ejercicios de selección, proyección, conjuntos, producto, reuniones, agrupación y división están en sql/practica_algebra_relacional.sql, y el grupo de RelaX en relax/ecotrace_grupo.txt.