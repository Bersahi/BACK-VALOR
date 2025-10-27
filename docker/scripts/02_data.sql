-- =============================================================================
-- Script de Datos Iniciales para ValorExpress (MySQL)
-- Inserta exactamente 5 registros en CADA tabla
-- =============================================================================

SET NAMES utf8mb4;

-- ===============================================================
-- MÓDULO 1: ROLES Y PERMISOS (5 registros cada uno)
-- ===============================================================

-- Insertar 5 Roles
INSERT INTO roles (nombre_rol, descripcion) VALUES ('admin', 'Administrador del sistema');
INSERT INTO roles (nombre_rol, descripcion) VALUES ('gerente', 'Gerente de sucursal');
INSERT INTO roles (nombre_rol, descripcion) VALUES ('empleado', 'Empleado general');
INSERT INTO roles (nombre_rol, descripcion) VALUES ('conductor', 'Conductor de vehículos');
INSERT INTO roles (nombre_rol, descripcion) VALUES ('cliente', 'Cliente del sistema');

-- Insertar 5 Permisos
INSERT INTO permisos (nombre_permiso, descripcion) VALUES ('crear_envio', 'Crear envíos');
INSERT INTO permisos (nombre_permiso, descripcion) VALUES ('ver_envios', 'Ver listado de envíos');
INSERT INTO permisos (nombre_permiso, descripcion) VALUES ('editar_envio', 'Editar envíos');
INSERT INTO permisos (nombre_permiso, descripcion) VALUES ('eliminar_envio', 'Eliminar envíos');
INSERT INTO permisos (nombre_permiso, descripcion) VALUES ('gestionar_usuarios', 'Gestionar usuarios');

-- Insertar 5 relaciones rol_permiso
INSERT INTO rol_permiso (rol_id, permiso_id) VALUES (1, 1);
INSERT INTO rol_permiso (rol_id, permiso_id) VALUES (1, 2);
INSERT INTO rol_permiso (rol_id, permiso_id) VALUES (2, 1);
INSERT INTO rol_permiso (rol_id, permiso_id) VALUES (2, 2);
INSERT INTO rol_permiso (rol_id, permiso_id) VALUES (3, 2);

-- Insertar 5 Usuarios
INSERT INTO usuarios (email, contrasena_hash, estado) VALUES ('admin@valorexpress.com', '$2a$10$hash1', 'activo');
INSERT INTO usuarios (email, contrasena_hash, estado) VALUES ('gerente@valorexpress.com', '$2a$10$hash2', 'activo');
INSERT INTO usuarios (email, contrasena_hash, estado) VALUES ('empleado@valorexpress.com', '$2a$10$hash3', 'activo');
INSERT INTO usuarios (email, contrasena_hash, estado) VALUES ('conductor@valorexpress.com', '$2a$10$hash4', 'activo');
INSERT INTO usuarios (email, contrasena_hash, estado) VALUES ('cliente@valorexpress.com', '$2a$10$hash5', 'activo');

-- Insertar 5 Sucursales (sin responsable por ahora)
INSERT INTO sucursales (nombre, codigo_sucursal, direccion, ciudad, telefono, activa)
VALUES ('Sucursal Central', 'SUC001', '5a Avenida 10-20, Zona 1', 'Guatemala', '2222-1111', 1);
INSERT INTO sucursales (nombre, codigo_sucursal, direccion, ciudad, telefono, activa)
VALUES ('Sucursal Norte', 'SUC002', 'Calzada Roosevelt 15-50, Zona 11', 'Guatemala', '2222-2222', 1);
INSERT INTO sucursales (nombre, codigo_sucursal, direccion, ciudad, telefono, activa)
VALUES ('Sucursal Sur', 'SUC003', 'Boulevard Liberación 20-30', 'Guatemala', '2222-3333', 1);
INSERT INTO sucursales (nombre, codigo_sucursal, direccion, ciudad, telefono, activa)
VALUES ('Sucursal Este', 'SUC004', 'Calzada Aguilar Batres 5-10', 'Guatemala', '2222-4444', 1);
INSERT INTO sucursales (nombre, codigo_sucursal, direccion, ciudad, telefono, activa)
VALUES ('Sucursal Oeste', 'SUC005', 'Avenida Petapa 8-15', 'Guatemala', '2222-5555', 1);

-- Insertar 5 Empleados
INSERT INTO empleados (usuario_id, sucursal_id, rol_id, nombre, documento_identidad, telefono)
VALUES (1, 1, 1, 'Carlos Admin', '1001', '5551-1111');
INSERT INTO empleados (usuario_id, sucursal_id, rol_id, nombre, documento_identidad, telefono)
VALUES (2, 2, 2, 'María Gerente', '1002', '5551-2222');
INSERT INTO empleados (usuario_id, sucursal_id, rol_id, nombre, documento_identidad, telefono)
VALUES (3, 3, 3, 'José Empleado', '1003', '5551-3333');
INSERT INTO empleados (usuario_id, sucursal_id, rol_id, nombre, documento_identidad, telefono)
VALUES (4, 4, 4, 'Pedro Conductor', '1004', '5551-4444');
INSERT INTO empleados (usuario_id, sucursal_id, rol_id, nombre, documento_identidad, telefono)
VALUES (5, 5, 3, 'Ana Empleada', '1005', '5551-5555');

-- Actualizar responsables de sucursales
UPDATE sucursales SET responsable_id = 1 WHERE id = 1;
UPDATE sucursales SET responsable_id = 2 WHERE id = 2;
UPDATE sucursales SET responsable_id = 3 WHERE id = 3;
UPDATE sucursales SET responsable_id = 4 WHERE id = 4;
UPDATE sucursales SET responsable_id = 5 WHERE id = 5;

-- Insertar 5 Clientes (reutilizando usuarios)
INSERT INTO clientes (usuario_id, nombre, telefono, tipo_documento, numero_documento)
VALUES (1, 'Carlos Cliente 1', '5552-1111', 'DPI', '2001');
INSERT INTO clientes (usuario_id, nombre, telefono, tipo_documento, numero_documento)
VALUES (2, 'María Cliente 2', '5552-2222', 'DPI', '2002');
INSERT INTO clientes (usuario_id, nombre, telefono, tipo_documento, numero_documento)
VALUES (3, 'José Cliente 3', '5552-3333', 'DPI', '2003');
INSERT INTO clientes (usuario_id, nombre, telefono, tipo_documento, numero_documento)
VALUES (4, 'Pedro Cliente 4', '5552-4444', 'DPI', '2004');
INSERT INTO clientes (usuario_id, nombre, telefono, tipo_documento, numero_documento)
VALUES (5, 'Ana Cliente 5', '5552-5555', 'DPI', '2005');

-- ===============================================================
-- MÓDULO 2: GEOGRAFÍA Y TARIFAS (5 registros cada uno)
-- ===============================================================

-- Insertar 5 Zonas
INSERT INTO zonas (nombre_zona, descripcion) VALUES ('Zona Centro', 'Zona central');
INSERT INTO zonas (nombre_zona, descripcion) VALUES ('Zona Norte', 'Zona norte');
INSERT INTO zonas (nombre_zona, descripcion) VALUES ('Zona Sur', 'Zona sur');
INSERT INTO zonas (nombre_zona, descripcion) VALUES ('Zona Este', 'Zona este');
INSERT INTO zonas (nombre_zona, descripcion) VALUES ('Zona Oeste', 'Zona oeste');

-- Insertar 5 Microzonas
INSERT INTO microzonas (zona_id, nombre_microzona, codigo_postal_asociado) VALUES (1, 'Centro 1', '01001');
INSERT INTO microzonas (zona_id, nombre_microzona, codigo_postal_asociado) VALUES (2, 'Norte 1', '01002');
INSERT INTO microzonas (zona_id, nombre_microzona, codigo_postal_asociado) VALUES (3, 'Sur 1', '01003');
INSERT INTO microzonas (zona_id, nombre_microzona, codigo_postal_asociado) VALUES (4, 'Este 1', '01004');
INSERT INTO microzonas (zona_id, nombre_microzona, codigo_postal_asociado) VALUES (5, 'Oeste 1', '01005');

-- Insertar 5 Matriz de Tarifas
INSERT INTO matriz_tarifas_zonas (origen_microzona_id, destino_microzona_id, costo_adicional) VALUES (1, 2, 10.00);
INSERT INTO matriz_tarifas_zonas (origen_microzona_id, destino_microzona_id, costo_adicional) VALUES (1, 3, 15.00);
INSERT INTO matriz_tarifas_zonas (origen_microzona_id, destino_microzona_id, costo_adicional) VALUES (2, 3, 12.00);
INSERT INTO matriz_tarifas_zonas (origen_microzona_id, destino_microzona_id, costo_adicional) VALUES (2, 4, 18.00);
INSERT INTO matriz_tarifas_zonas (origen_microzona_id, destino_microzona_id, costo_adicional) VALUES (3, 5, 20.00);

-- Insertar 5 Tarifas
INSERT INTO tarifas (tipo_envio, rango_peso_kg_min, rango_peso_kg_max, tarifa_base, tarifa_seguro_porc, activa)
VALUES ('terrestre', 0.00, 5.00, 50.00, 2.00, 1);
INSERT INTO tarifas (tipo_envio, rango_peso_kg_min, rango_peso_kg_max, tarifa_base, tarifa_seguro_porc, activa)
VALUES ('terrestre', 5.01, 10.00, 80.00, 2.50, 1);
INSERT INTO tarifas (tipo_envio, rango_peso_kg_min, rango_peso_kg_max, tarifa_base, tarifa_seguro_porc, activa)
VALUES ('aereo', 0.00, 5.00, 150.00, 3.00, 1);
INSERT INTO tarifas (tipo_envio, rango_peso_kg_min, rango_peso_kg_max, tarifa_base, tarifa_seguro_porc, activa)
VALUES ('aereo', 5.01, 10.00, 250.00, 3.50, 1);
INSERT INTO tarifas (tipo_envio, rango_peso_kg_min, rango_peso_kg_max, tarifa_base, tarifa_seguro_porc, activa)
VALUES ('maritimo', 0.00, 50.00, 300.00, 4.00, 1);

-- ===============================================================
-- MÓDULO 3: TIPOS DE PAQUETE Y DIRECCIONES (5 registros cada uno)
-- ===============================================================

-- Insertar 5 Tipos de Paquete
INSERT INTO tipos_paquete (nombre, descripcion, aplica_volumen) VALUES ('Sobre', 'Sobre para documentos', 0);
INSERT INTO tipos_paquete (nombre, descripcion, aplica_volumen) VALUES ('Caja Pequeña', 'Caja pequeña', 1);
INSERT INTO tipos_paquete (nombre, descripcion, aplica_volumen) VALUES ('Caja Mediana', 'Caja mediana', 1);
INSERT INTO tipos_paquete (nombre, descripcion, aplica_volumen) VALUES ('Caja Grande', 'Caja grande', 1);
INSERT INTO tipos_paquete (nombre, descripcion, aplica_volumen) VALUES ('Pallet', 'Pallet para carga pesada', 1);

-- Insertar 5 Direcciones
INSERT INTO direcciones (cliente_id, microzona_id, direccion_texto, ciudad, provincia, pais, codigo_postal, es_principal)
VALUES (1, 1, 'Dirección 1', 'Guatemala', 'Guatemala', 'Guatemala', '01001', 1);
INSERT INTO direcciones (cliente_id, microzona_id, direccion_texto, ciudad, provincia, pais, codigo_postal, es_principal)
VALUES (2, 2, 'Dirección 2', 'Guatemala', 'Guatemala', 'Guatemala', '01002', 1);
INSERT INTO direcciones (cliente_id, microzona_id, direccion_texto, ciudad, provincia, pais, codigo_postal, es_principal)
VALUES (3, 3, 'Dirección 3', 'Guatemala', 'Guatemala', 'Guatemala', '01003', 1);
INSERT INTO direcciones (cliente_id, microzona_id, direccion_texto, ciudad, provincia, pais, codigo_postal, es_principal)
VALUES (4, 4, 'Dirección 4', 'Guatemala', 'Guatemala', 'Guatemala', '01004', 1);
INSERT INTO direcciones (cliente_id, microzona_id, direccion_texto, ciudad, provincia, pais, codigo_postal, es_principal)
VALUES (5, 5, 'Dirección 5', 'Guatemala', 'Guatemala', 'Guatemala', '01005', 1);

-- ===============================================================
-- MÓDULO 4: ENVÍOS Y PAQUETES (5 registros cada uno)
-- ===============================================================

-- Insertar 5 Envíos
INSERT INTO envios (cliente_id, origen_id, destino_id, remitente_nombre, remitente_telefono, remitente_email, tracking_code, costo_total, metodo_envio, estado)
VALUES (1, 1, 2, 'Cliente 1', '5551-1111', 'cliente1@example.com', 'TRACK001', 100.00, 'terrestre', 'registrado');
INSERT INTO envios (cliente_id, origen_id, destino_id, remitente_nombre, remitente_telefono, remitente_email, tracking_code, costo_total, metodo_envio, estado)
VALUES (2, 2, 3, 'Cliente 2', '5551-2222', 'cliente2@example.com', 'TRACK002', 150.00, 'aereo', 'en_transito');
INSERT INTO envios (cliente_id, origen_id, destino_id, remitente_nombre, remitente_telefono, remitente_email, tracking_code, costo_total, metodo_envio, estado)
VALUES (3, 3, 4, 'Cliente 3', '5551-3333', 'cliente3@example.com', 'TRACK003', 200.00, 'terrestre', 'entregado');
INSERT INTO envios (cliente_id, origen_id, destino_id, remitente_nombre, remitente_telefono, remitente_email, tracking_code, costo_total, metodo_envio, estado)
VALUES (4, 4, 5, 'Cliente 4', '5551-4444', 'cliente4@example.com', 'TRACK004', 250.00, 'maritimo', 'en_almacen');
INSERT INTO envios (cliente_id, origen_id, destino_id, remitente_nombre, remitente_telefono, remitente_email, tracking_code, costo_total, metodo_envio, estado)
VALUES (5, 5, 1, 'Cliente 5', '5551-5555', 'cliente5@example.com', 'TRACK005', 300.00, 'aereo', 'en_reparto');

-- Insertar 5 Paquetes
INSERT INTO paquetes (envio_id, tipo_paquete_id, codigo_barras, descripcion, peso_kg, largo_cm, ancho_cm, alto_cm, valor_declarado, fragil, estado_actual)
VALUES (1, 1, 'BAR001', 'Documentos', 0.50, 25, 18, 2, 50.00, 0, 'registrado');
INSERT INTO paquetes (envio_id, tipo_paquete_id, codigo_barras, descripcion, peso_kg, largo_cm, ancho_cm, alto_cm, valor_declarado, fragil, estado_actual)
VALUES (2, 2, 'BAR002', 'Electrónicos', 3.00, 30, 25, 20, 500.00, 1, 'en_transito');
INSERT INTO paquetes (envio_id, tipo_paquete_id, codigo_barras, descripcion, peso_kg, largo_cm, ancho_cm, alto_cm, valor_declarado, fragil, estado_actual)
VALUES (3, 3, 'BAR003', 'Ropa', 5.00, 40, 30, 25, 200.00, 0, 'entregado');
INSERT INTO paquetes (envio_id, tipo_paquete_id, codigo_barras, descripcion, peso_kg, largo_cm, ancho_cm, alto_cm, valor_declarado, fragil, estado_actual)
VALUES (4, 4, 'BAR004', 'Muebles', 20.00, 80, 60, 50, 1000.00, 0, 'en_almacen');
INSERT INTO paquetes (envio_id, tipo_paquete_id, codigo_barras, descripcion, peso_kg, largo_cm, ancho_cm, alto_cm, valor_declarado, fragil, estado_actual)
VALUES (5, 5, 'BAR005', 'Carga pesada', 100.00, 120, 100, 80, 5000.00, 0, 'en_reparto');

-- ===============================================================
-- MÓDULO 5: UBICACIONES Y VEHÍCULOS (5 registros cada uno)
-- ===============================================================

-- Insertar 5 Ubicaciones
INSERT INTO ubicaciones (nombre, tipo, codigo, direccion, ciudad, provincia)
VALUES ('Almacén 1', 'almacen', 'ALM001', 'Dirección Almacén 1', 'Guatemala', 'Guatemala');
INSERT INTO ubicaciones (nombre, tipo, codigo, direccion, ciudad, provincia)
VALUES ('Hub 1', 'hub', 'HUB001', 'Dirección Hub 1', 'Guatemala', 'Guatemala');
INSERT INTO ubicaciones (nombre, tipo, codigo, direccion, ciudad, provincia)
VALUES ('Punto Entrega 1', 'punto_entrega', 'PE001', 'Dirección PE 1', 'Guatemala', 'Guatemala');
INSERT INTO ubicaciones (nombre, tipo, codigo, direccion, ciudad, provincia)
VALUES ('Sucursal 1', 'sucursal', 'SUC101', 'Dirección Sucursal 1', 'Guatemala', 'Guatemala');
INSERT INTO ubicaciones (nombre, tipo, codigo, direccion, ciudad, provincia)
VALUES ('Almacén 2', 'almacen', 'ALM002', 'Dirección Almacén 2', 'Guatemala', 'Guatemala');

-- Insertar 5 Vehículos
INSERT INTO vehiculos (placa, tipo, marca, modelo, ano, capacidad_kg, volumen_m3, estado)
VALUES ('P-001', 'Camión', 'Isuzu', 'NPR', 2022, 3000.00, 15.00, 'activo');
INSERT INTO vehiculos (placa, tipo, marca, modelo, ano, capacidad_kg, volumen_m3, estado)
VALUES ('P-002', 'Van', 'Hyundai', 'H-100', 2021, 1000.00, 8.00, 'activo');
INSERT INTO vehiculos (placa, tipo, marca, modelo, ano, capacidad_kg, volumen_m3, estado)
VALUES ('P-003', 'Pickup', 'Toyota', 'Hilux', 2023, 800.00, 5.00, 'activo');
INSERT INTO vehiculos (placa, tipo, marca, modelo, ano, capacidad_kg, volumen_m3, estado)
VALUES ('P-004', 'Camión', 'Freightliner', 'M2', 2020, 5000.00, 25.00, 'mantenimiento');
INSERT INTO vehiculos (placa, tipo, marca, modelo, ano, capacidad_kg, volumen_m3, estado)
VALUES ('P-005', 'Moto', 'Honda', 'CG150', 2022, 50.00, 0.5, 'activo');

-- Insertar 5 Conductores
INSERT INTO conductores (empleado_id, licencia_conducir, tipo_licencia, fecha_vencimiento_licencia, estado)
VALUES (4, 'LIC001', 'C', '2026-12-31', 'disponible');
INSERT INTO conductores (empleado_id, licencia_conducir, tipo_licencia, fecha_vencimiento_licencia, estado)
VALUES (1, 'LIC002', 'B', '2025-06-30', 'disponible');
INSERT INTO conductores (empleado_id, licencia_conducir, tipo_licencia, fecha_vencimiento_licencia, estado)
VALUES (2, 'LIC003', 'C', '2026-03-15', 'en_ruta');
INSERT INTO conductores (empleado_id, licencia_conducir, tipo_licencia, fecha_vencimiento_licencia, estado)
VALUES (3, 'LIC004', 'A', '2025-09-20', 'disponible');
INSERT INTO conductores (empleado_id, licencia_conducir, tipo_licencia, fecha_vencimiento_licencia, estado)
VALUES (5, 'LIC005', 'B', '2026-11-10', 'vacaciones');

-- ===============================================================
-- MÓDULO 6: MANIFIESTOS Y TRAZABILIDAD (5 registros cada uno)
-- ===============================================================

-- Insertar 5 Manifiestos de Transporte
INSERT INTO manifiesto_transporte (origen_ubicacion_id, destino_ubicacion_id, vehiculo_id, conductor_id, codigo_manifiesto, estado, fecha_salida_estimada)
VALUES (1, 2, 1, 1, 'MAN001', 'en_transito', DATE_ADD(NOW(), INTERVAL 2 HOUR));
INSERT INTO manifiesto_transporte (origen_ubicacion_id, destino_ubicacion_id, vehiculo_id, conductor_id, codigo_manifiesto, estado, fecha_salida_estimada)
VALUES (2, 3, 2, 2, 'MAN002', 'abierto', DATE_ADD(NOW(), INTERVAL 4 HOUR));
INSERT INTO manifiesto_transporte (origen_ubicacion_id, destino_ubicacion_id, vehiculo_id, conductor_id, codigo_manifiesto, estado, fecha_salida_estimada)
VALUES (3, 4, 3, 3, 'MAN003', 'cerrado', DATE_ADD(NOW(), INTERVAL 6 HOUR));
INSERT INTO manifiesto_transporte (origen_ubicacion_id, destino_ubicacion_id, vehiculo_id, conductor_id, codigo_manifiesto, estado, fecha_salida_estimada)
VALUES (4, 5, 4, 4, 'MAN004', 'en_transito', DATE_ADD(NOW(), INTERVAL 8 HOUR));
INSERT INTO manifiesto_transporte (origen_ubicacion_id, destino_ubicacion_id, vehiculo_id, conductor_id, codigo_manifiesto, estado, fecha_salida_estimada)
VALUES (5, 1, 5, 5, 'MAN005', 'auditado', DATE_ADD(NOW(), INTERVAL 10 HOUR));

-- Insertar 5 Paquetes en Manifiestos
INSERT INTO manifiesto_paquete (manifiesto_transporte_id, paquete_id) VALUES (1, 1);
INSERT INTO manifiesto_paquete (manifiesto_transporte_id, paquete_id) VALUES (2, 2);
INSERT INTO manifiesto_paquete (manifiesto_transporte_id, paquete_id) VALUES (3, 3);
INSERT INTO manifiesto_paquete (manifiesto_transporte_id, paquete_id) VALUES (4, 4);
INSERT INTO manifiesto_paquete (manifiesto_transporte_id, paquete_id) VALUES (5, 5);

-- Insertar 5 Historial de Paquetes
INSERT INTO historial_paquete (paquete_id, ubicacion_id, empleado_id, tipo_evento, comentario)
VALUES (1, 1, 1, 'Recepción', 'Paquete recibido');
INSERT INTO historial_paquete (paquete_id, ubicacion_id, empleado_id, tipo_evento, comentario)
VALUES (2, 2, 2, 'En tránsito', 'Paquete en camino');
INSERT INTO historial_paquete (paquete_id, ubicacion_id, empleado_id, tipo_evento, comentario)
VALUES (3, 3, 3, 'Entrega', 'Paquete entregado');
INSERT INTO historial_paquete (paquete_id, ubicacion_id, empleado_id, tipo_evento, comentario)
VALUES (4, 4, 4, 'Almacenado', 'Paquete en almacén');
INSERT INTO historial_paquete (paquete_id, ubicacion_id, empleado_id, tipo_evento, comentario)
VALUES (5, 5, 5, 'En reparto', 'Paquete en reparto');

-- ===============================================================
-- MÓDULO 7: PAGOS, NOTIFICACIONES, RUTAS Y ASIGNACIONES (5 cada uno)
-- ===============================================================

-- Insertar 5 Pagos
INSERT INTO pagos (envio_id, empleado_id, monto, metodo_pago, estado, transaccion_id)
VALUES (1, 1, 100.00, 'tarjeta', 'completado', 'TXN001');
INSERT INTO pagos (envio_id, empleado_id, monto, metodo_pago, estado, transaccion_id)
VALUES (2, 2, 150.00, 'efectivo', 'completado', 'TXN002');
INSERT INTO pagos (envio_id, empleado_id, monto, metodo_pago, estado, transaccion_id)
VALUES (3, 3, 200.00, 'transferencia', 'completado', 'TXN003');
INSERT INTO pagos (envio_id, empleado_id, monto, metodo_pago, estado, transaccion_id)
VALUES (4, 4, 250.00, 'tarjeta', 'pendiente', 'TXN004');
INSERT INTO pagos (envio_id, empleado_id, monto, metodo_pago, estado, transaccion_id)
VALUES (5, 5, 300.00, 'efectivo', 'fallido', 'TXN005');

-- Insertar 5 Notificaciones
INSERT INTO notificaciones (envio_id, cliente_id, tipo, mensaje, destinatario)
VALUES (1, 1, 'email', 'Envío registrado TRACK001', 'cliente1@example.com');
INSERT INTO notificaciones (envio_id, cliente_id, tipo, mensaje, destinatario)
VALUES (2, 2, 'sms', 'Envío en tránsito TRACK002', '5551-2222');
INSERT INTO notificaciones (envio_id, cliente_id, tipo, mensaje, destinatario)
VALUES (3, 3, 'email', 'Envío entregado TRACK003', 'cliente3@example.com');
INSERT INTO notificaciones (envio_id, cliente_id, tipo, mensaje, destinatario)
VALUES (4, 4, 'push', 'Envío en almacén TRACK004', 'cliente4@example.com');
INSERT INTO notificaciones (envio_id, cliente_id, tipo, mensaje, destinatario)
VALUES (5, 5, 'sms', 'Envío en reparto TRACK005', '5551-5555');

-- Insertar 5 Rutas
INSERT INTO rutas (origen_id, destino_id, tiempo_estimado_min, distancia_km) VALUES (1, 2, 30, 10.5);
INSERT INTO rutas (origen_id, destino_id, tiempo_estimado_min, distancia_km) VALUES (2, 3, 45, 15.2);
INSERT INTO rutas (origen_id, destino_id, tiempo_estimado_min, distancia_km) VALUES (3, 4, 60, 25.8);
INSERT INTO rutas (origen_id, destino_id, tiempo_estimado_min, distancia_km) VALUES (4, 5, 90, 35.4);
INSERT INTO rutas (origen_id, destino_id, tiempo_estimado_min, distancia_km) VALUES (5, 1, 120, 45.0);

-- Insertar 5 Asignaciones
INSERT INTO asignaciones (envio_id, conductor_id, vehiculo_id, ruta_id, estado)
VALUES (1, 1, 1, 1, 'en_curso');
INSERT INTO asignaciones (envio_id, conductor_id, vehiculo_id, ruta_id, estado)
VALUES (2, 2, 2, 2, 'en_curso');
INSERT INTO asignaciones (envio_id, conductor_id, vehiculo_id, ruta_id, estado)
VALUES (3, 3, 3, 3, 'finalizado');
INSERT INTO asignaciones (envio_id, conductor_id, vehiculo_id, ruta_id, estado)
VALUES (4, 4, 4, 4, 'pendiente');
INSERT INTO asignaciones (envio_id, conductor_id, vehiculo_id, ruta_id, estado)
VALUES (5, 5, 5, 5, 'en_curso');

-- ===============================================================
-- FIN DEL SCRIPT - TODAS LAS TABLAS CON 5 REGISTROS
-- ===============================================================
