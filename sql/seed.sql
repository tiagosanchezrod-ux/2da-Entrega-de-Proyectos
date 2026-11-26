INSERT INTO donantes (tipo_donante, nombre_donante) VALUES
    ('DONANTE_EMPRESA', 'Servicios Digitales S.A.'),
    ('DONANTE_PARTICULAR', 'Juanito Pérez Gómez');

INSERT INTO recepciones (folio, fecha_recepcion, id_donante, tipo_aparato, peso_kg, responsable_almacen, estado) VALUES
    ('REC-2026-089', '2026-10-11', 1, 'Servidores de Rack', 320.00, 'Carlos Mendoza', 'En Desensamble'),
    ('REC-2026-088', '2026-10-10', 2, 'Laptops viejas y Celulares', 15.50, 'Ana Ramírez', 'Clasificado');