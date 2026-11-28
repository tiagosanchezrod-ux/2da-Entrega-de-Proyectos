# EcoTrace E-Waste – Proyecto del Segundo Parcial

**Alumno:** Sánchez Rodríguez Santiago  y Casasola Avalos Diana Valeria

---

## Parte 1. Proyecto Propio (EcoTrace E-Waste)

### Entregables y enlaces rápidos
* **Aplicación web :** Interfaz web (`frontend/`) conectada a backend/API (`backend/`) y base de datos PostgreSQL levantada mediante `docker-compose.yml`.
* **Esquema y scripts SQL:** Definición de tablas, restricciones y consultas en `sql/` (`practica_algebra_relacional.sql` y scripts de esquema/carga).
* **Evidencia de registro y base de datos:** Capturas y verificaciones en `docs/` (comprobación desde formulario web y consulta `SELECT` en pgAdmin).
* **Video de demostración:** [Ver video de demostración (`docs/Demostración.mp4`)](./docs/Demostración.mp4)
* **Normalización (1FN a 3FN y FNBC):** [normalizacion.md](normalizacion.md)
* **Álgebra relacional y SQL equivalente:** [algebra.md](algebra.md)
* **Grupo de datos para RelaX:** [relax/ecotrace_grupo.txt](relax/ecotrace_grupo.txt)

---

## Parte 2. Proyecto Asignado

### Enlaces del proyecto asignado
* **Repositorio original:** https://github.com/gabrielhuav/Data_Warehouse_static
* **Demostración estática original:** https://gabrielhuav.github.io/Data_Warehouse_static/
* **Versión extendida (área metropolitana y grafo):** https://github.com/gabrielhuav/Data_Warehouse_IJCOPI
* **Fork propio del repositorio:** https://github.com/val0444/Data_Warehouse_IJCOPI
* **Versión publicada (GitHub Pages):** https://val0444.github.io/Data_Warehouse_IJCOPI/ijcopi/mapa-zm.html?ind=m_litros

---

## Parte 3. Bibliografia y Propuestas de Mejora

### Referencia del artículo 
> Hurtado Avilés, G., Velázquez Arrieta, E. U., Pulido Morales, O. F., García López, E., Hernández Martínez, C. A., & Zagal Flores, R. E. (2026). *Territorial information retrieval from heterogeneous open data: Extending a water data warehouse from Mexico City to its metropolitan area* [Manuscrito no publicado / versión v3 con grafo]. Escuela Superior de Cómputo, Instituto Politécnico Nacional. https://github.com/gabrielhuav/Data_Warehouse_IJCOPI/blob/main/paper/ijcopi/dw_agua_IJCOPI_v3_grafo.docx

### Resumen
* **Problema:** Los datos abiertos de consumo de agua de SACMEX estan en formatos poco accesibles y sin herramientas de consulta aparte, el volumen facturado no es igual a la demanda física real ni al consumo per cápita, especialmente en zonas intermitentes, facturación promediada o baja cobertura de medición.
* **Datos y método:** Son mediante un proceso ETL en Python/SQL 71,102 registros de facturación de SACMEX 70,886 cargados tras descartar 216 sin etiqueta territorial y datos climáticos diarios de Open-Meteo del primer semestre de 2019 en un esquema estrella en PostgreSQL, proyectado declarativamente con R2RML hacia un grafo de RDF y desplegado en modalidad dinámica y estática.
* **Resultado principal:** Cuauhtémoc y Miguel Hidalgo lideran el volumen total facturado, pero al cruzar con el Censo 2020 el mayor consumo doméstico por habitante corresponde a Benito Juárez 126.5 L día, con un promedio de 47.3 L día en CDMX. Tambien se demuestra que el índice de atípicos original es estructuralmente ciego a caídas 2 % de *recall*, por lo que se separan rankings de exceso, déficit y consumo cero.
* **Avance respecto al primer parcial:** La versión extendida amplía el almacén a los 63 municipios de la Zona Metropolitana del Valle de México, incorpora el análisis per cápita contra el Censo 2020, evalúa la sensibilidad del detector de atípicos, aplica filtros de calidad municipal, integra 555,752 reportes ciudadanos y extiende el grafo territorial con polígonos oficiales y adyacencias entre municipios.

### Propuestas de mejora Santiago

#### Mejora 1: Carga progresiva por alcaldía/municipio en la versión estática
* **Limitación observada:** En la Sección 5.9 se dice que la demostración estática descarga de golpe un paquete de 3.9 MB y ejecuta las agregaciones en el navegador del cliente, lo que reduce el rendimiento en dispositivos móviles o conexiones lentas, puntuación de Lighthouse de 76 en móvil contra 89 en escritorio.
* **Qué cambiaría:** Particionar los archivos JSON/GeoJSON exportados desde PostgreSQL por alcaldía o municipio y modificar la lógica de carga en JavaScript para solicitar únicamente los datos del territorio seleccionado bajo demanda, manteniendo intacto el esquema dimensional base.
* **Cómo comprobaría que funciona:** Comparar en las herramientas de desarrollo del navegador, el tamaño de transferencia inicial, el tiempo hasta la primera renderización interactiva y el consumo de memoria antes y después de dividir los archivos por demarcación.

#### Mejora 2: Módulo de registro y validación cruzada con reportes ciudadanos de incidencias
* **Limitación observada:** Como dicen en las Secciones 3.6, 5.6 y 7.2, las desviaciones estadísticas en la facturación no comprueban por sí solas incidencias reales en campo, y el conjunto de reportes de 2019 solo registra escasez sin trazabilidad unificada de verificaciones posteriores.
* **Qué cambiaría:** Incorporar al modelo dimensional una tabla de hechos de incidencias `fact_reportes_incidencias`, vinculada mediante clave foránea a `dim_ubicacion` y `dim_tiempo`, con tipo de reporte y estado de verificación, junto con una consulta SQL analítica que cruce las zonas con consumo atípico o cercano a cero contra los reportes registrados en el mismo periodo.
* **Cómo comprobaría que funciona:** Poblar la tabla con un conjunto controlado de reportes de prueba asociados a ubicaciones existentes en `dim_ubicacion`, verificar el cumplimiento de las restricciones de integridad referencial y ejecutar la consulta de cruce en PostgreSQL para confirmar que distingue correctamente las alertas respaldadas por reportes ciudadanos de aquellas sin incidencia registrada.

### Presentación para la exposición
* **Archivo de la presentación:** https://canva.link/z01ez3rqsskw1dd
  
