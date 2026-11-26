CREATE TABLE IF NOT EXISTS donantes (
    id_donante SERIAL PRIMARY KEY,
    tipo_donante VARCHAR(30) NOT NULL CHECK (
        tipo_donante IN ('DONANTE_EMPRESA', 'DONANTE_PARTICULAR')
    ),
    nombre_donante VARCHAR(150) NOT NULL CHECK (char_length(trim(nombre_donante)) > 0)
);

CREATE TABLE IF NOT EXISTS recepciones (
    id_recepcion SERIAL PRIMARY KEY,
    folio VARCHAR(30) NOT NULL UNIQUE,
    fecha_recepcion DATE NOT NULL DEFAULT CURRENT_DATE,
    id_donante INTEGER NOT NULL REFERENCES donantes(id_donante) ON DELETE RESTRICT ON UPDATE CASCADE,
    tipo_aparato VARCHAR(120) NOT NULL CHECK (char_length(trim(tipo_aparato)) > 0),
    peso_kg NUMERIC(10, 2) NOT NULL CHECK (peso_kg > 0),
    responsable_almacen VARCHAR(120) NOT NULL CHECK (char_length(trim(responsable_almacen)) > 0),
    estado VARCHAR(40) NOT NULL DEFAULT 'En Desensamble' CHECK (
        estado IN ('En Desensamble', 'Clasificado', 'Enviado')
    )
);