-- Conectar como el usuario ADMIN
ALTER SESSION SET CURRENT_SCHEMA = ADMIN;

-- Insertar datos en la tabla ENVIOS
INSERT INTO ADMIN.ENVIOS (
    CLIENTE_ID,
    ORIGEN_ID,
    DESTINO_ID,
    REMITENTE_NOMBRE,
    REMITENTE_TELEFONO,
    REMITENTE_DOCUMENTO,
    REMITENTE_EMAIL,
    TRACKING_CODE,
    COSTO_TOTAL,
    METODO_ENVIO,
    ESTADO,
    FECHA_CREACION
) VALUES (
    1,  -- ejemplo de ID cliente
    100,  -- ejemplo de ID origen
    200,  -- ejemplo de ID destino
    'Juan Pérez',
    '1234567890',
    'DNI123456',
    'juan@ejemplo.com',
    'TRACK001',
    150.00,
    'TERRESTRE',
    'PENDIENTE',
    CURRENT_TIMESTAMP
);

-- Aquí puedes agregar más inserts siguiendo el mismo patrón

COMMIT;