-- =============================================================================
-- Script de Creación de Esquema para ValorExpress (MySQL)
-- Ejecutable automáticamente al crear el contenedor Docker
-- =============================================================================

SET NAMES utf8mb4;
SET FOREIGN_KEY_CHECKS = 0;

-- ===============================================================
-- MÓDULO 1: USUARIOS, PERFILES Y PERMISOS (RBAC)
-- ===============================================================

CREATE TABLE usuarios (
    id INT AUTO_INCREMENT PRIMARY KEY,
    email VARCHAR(100) NOT NULL UNIQUE,
    contrasena_hash VARCHAR(100) NOT NULL,
    estado VARCHAR(30) DEFAULT 'pendiente_verificacion' NOT NULL,
    fecha_creacion DATETIME DEFAULT CURRENT_TIMESTAMP,
    ultimo_login DATETIME,
    deleted_at DATETIME,
    CONSTRAINT chk_usuarios_estado CHECK (estado IN ('activo', 'inactivo', 'pendiente_verificacion'))
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE roles (
    id INT AUTO_INCREMENT PRIMARY KEY,
    nombre_rol VARCHAR(50) NOT NULL UNIQUE,
    descripcion TEXT
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE permisos (
    id INT AUTO_INCREMENT PRIMARY KEY,
    nombre_permiso VARCHAR(50) NOT NULL UNIQUE,
    descripcion TEXT
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE rol_permiso (
    rol_id INT NOT NULL,
    permiso_id INT NOT NULL,
    PRIMARY KEY (rol_id, permiso_id),
    CONSTRAINT fk_rol_permiso_rol FOREIGN KEY (rol_id) REFERENCES roles(id),
    CONSTRAINT fk_rol_permiso_permiso FOREIGN KEY (permiso_id) REFERENCES permisos(id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE sucursales (
    id INT AUTO_INCREMENT PRIMARY KEY,
    responsable_id INT,
    nombre VARCHAR(100) NOT NULL,
    codigo_sucursal VARCHAR(10) NOT NULL UNIQUE,
    direccion TEXT NOT NULL,
    ciudad VARCHAR(50) NOT NULL,
    telefono VARCHAR(20),
    activa TINYINT(1) DEFAULT 1 NOT NULL,
    deleted_at DATETIME,
    CONSTRAINT chk_sucursales_activa CHECK (activa IN (0,1))
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE empleados (
    id INT AUTO_INCREMENT PRIMARY KEY,
    usuario_id INT NOT NULL UNIQUE,
    sucursal_id INT NOT NULL,
    rol_id INT NOT NULL,
    nombre VARCHAR(100) NOT NULL,
    documento_identidad VARCHAR(20) NOT NULL UNIQUE,
    telefono VARCHAR(20),
    deleted_at DATETIME,
    CONSTRAINT fk_empleados_usuario FOREIGN KEY (usuario_id) REFERENCES usuarios(id),
    CONSTRAINT fk_empleados_sucursal FOREIGN KEY (sucursal_id) REFERENCES sucursales(id),
    CONSTRAINT fk_empleados_rol FOREIGN KEY (rol_id) REFERENCES roles(id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Ahora que empleados existe, agregar la FK de responsable en sucursales
ALTER TABLE sucursales
  ADD CONSTRAINT fk_sucursales_responsable FOREIGN KEY (responsable_id) REFERENCES empleados(id);

CREATE TABLE clientes (
    id INT AUTO_INCREMENT PRIMARY KEY,
    usuario_id INT NOT NULL UNIQUE,
    nombre VARCHAR(100) NOT NULL,
    telefono VARCHAR(20),
    tipo_documento VARCHAR(10),
    numero_documento VARCHAR(20),
    deleted_at DATETIME,
    CONSTRAINT fk_clientes_usuario FOREIGN KEY (usuario_id) REFERENCES usuarios(id),
    CONSTRAINT uq_clientes_numero_documento UNIQUE (numero_documento)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ===============================================================
-- MÓDULO 2: GEOGRAFÍA Y TARIFAS
-- ===============================================================

CREATE TABLE zonas (
    id INT AUTO_INCREMENT PRIMARY KEY,
    nombre_zona VARCHAR(100) NOT NULL UNIQUE,
    descripcion TEXT
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE microzonas (
    id INT AUTO_INCREMENT PRIMARY KEY,
    zona_id INT NOT NULL,
    nombre_microzona VARCHAR(100) NOT NULL,
    codigo_postal_asociado VARCHAR(10),
    CONSTRAINT fk_microzonas_zona FOREIGN KEY (zona_id) REFERENCES zonas(id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE matriz_tarifas_zonas (
    origen_microzona_id INT NOT NULL,
    destino_microzona_id INT NOT NULL,
    costo_adicional DECIMAL(10,2) DEFAULT 0 NOT NULL,
    PRIMARY KEY (origen_microzona_id, destino_microzona_id),
    CONSTRAINT fk_matriz_origen FOREIGN KEY (origen_microzona_id) REFERENCES microzonas(id),
    CONSTRAINT fk_matriz_destino FOREIGN KEY (destino_microzona_id) REFERENCES microzonas(id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE tarifas (
    id INT AUTO_INCREMENT PRIMARY KEY,
    tipo_envio VARCHAR(20) NOT NULL,
    rango_peso_kg_min DECIMAL(6,2) NOT NULL,
    rango_peso_kg_max DECIMAL(6,2) NOT NULL,
    tarifa_base DECIMAL(8,2) NOT NULL,
    tarifa_seguro_porc DECIMAL(5,2) DEFAULT 0,
    activa TINYINT(1) DEFAULT 1 NOT NULL,
    CONSTRAINT chk_tarifas_tipo_envio CHECK (tipo_envio IN ('terrestre','aereo','maritimo')),
    CONSTRAINT chk_tarifas_activa CHECK (activa IN (0,1))
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ===============================================================
-- MÓDULO 3: ENVÍOS Y PAQUETES
-- ===============================================================

CREATE TABLE tipos_paquete (
    id INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(50) NOT NULL UNIQUE,
    descripcion TEXT,
    aplica_volumen TINYINT(1) DEFAULT 1 NOT NULL,
    CONSTRAINT chk_tipos_paquete_aplica_volumen CHECK (aplica_volumen IN (0,1))
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE direcciones (
    id INT AUTO_INCREMENT PRIMARY KEY,
    cliente_id INT,
    microzona_id INT NOT NULL,
    direccion_texto TEXT NOT NULL,
    ciudad VARCHAR(50) NOT NULL,
    provincia VARCHAR(50) NOT NULL,
    pais VARCHAR(50) DEFAULT 'Guatemala' NOT NULL,
    codigo_postal VARCHAR(10),
    referencia VARCHAR(255),
    es_principal TINYINT(1) DEFAULT 0 NOT NULL,
    deleted_at DATETIME,
    CONSTRAINT fk_direcciones_cliente FOREIGN KEY (cliente_id) REFERENCES clientes(id),
    CONSTRAINT fk_direcciones_microzona FOREIGN KEY (microzona_id) REFERENCES microzonas(id),
    CONSTRAINT chk_direcciones_es_principal CHECK (es_principal IN (0,1))
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE envios (
    id INT AUTO_INCREMENT PRIMARY KEY,
    cliente_id INT,
    origen_id INT NOT NULL,
    destino_id INT NOT NULL,
    remitente_nombre VARCHAR(100) NOT NULL,
    remitente_telefono VARCHAR(20),
    remitente_documento VARCHAR(20),
    remitente_email VARCHAR(100),
    tracking_code VARCHAR(20) NOT NULL UNIQUE,
    costo_total DECIMAL(10,2) NOT NULL,
    metodo_envio VARCHAR(20) DEFAULT 'terrestre' NOT NULL,
    estado VARCHAR(30) DEFAULT 'registrado' NOT NULL,
    fecha_creacion DATETIME DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_envios_cliente FOREIGN KEY (cliente_id) REFERENCES clientes(id),
    CONSTRAINT fk_envios_origen FOREIGN KEY (origen_id) REFERENCES direcciones(id),
    CONSTRAINT fk_envios_destino FOREIGN KEY (destino_id) REFERENCES direcciones(id),
    CONSTRAINT chk_envios_metodo_envio CHECK (metodo_envio IN ('terrestre','aereo','maritimo')),
    CONSTRAINT chk_envios_estado CHECK (estado IN ('registrado','en_almacen','en_transito','en_reparto','entregado','cancelado','devuelto'))
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE paquetes (
    id INT AUTO_INCREMENT PRIMARY KEY,
    envio_id INT NOT NULL,
    tipo_paquete_id INT NOT NULL,
    codigo_barras VARCHAR(50),
    descripcion TEXT,
    peso_kg DECIMAL(6,2) NOT NULL,
    largo_cm DECIMAL(6,2),
    ancho_cm DECIMAL(6,2),
    alto_cm DECIMAL(6,2),
    valor_declarado DECIMAL(10,2),
    fragil TINYINT(1) DEFAULT 0 NOT NULL,
    estado_actual VARCHAR(50),
    CONSTRAINT fk_paquetes_envio FOREIGN KEY (envio_id) REFERENCES envios(id) ON DELETE CASCADE,
    CONSTRAINT fk_paquetes_tipo FOREIGN KEY (tipo_paquete_id) REFERENCES tipos_paquete(id),
    CONSTRAINT chk_paquetes_fragil CHECK (fragil IN (0,1))
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ===============================================================
-- MÓDULO 4: LOGÍSTICA Y TRAZABILIDAD
-- ===============================================================

CREATE TABLE ubicaciones (
    id INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL,
    tipo VARCHAR(30) NOT NULL,
    codigo VARCHAR(20),
    direccion TEXT,
    ciudad VARCHAR(50),
    provincia VARCHAR(50),
    CONSTRAINT chk_ubicaciones_tipo CHECK (tipo IN ('sucursal','almacen','punto_entrega','hub')),
    CONSTRAINT uq_ubicaciones_codigo UNIQUE (codigo)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE vehiculos (
    id INT AUTO_INCREMENT PRIMARY KEY,
    placa VARCHAR(10) NOT NULL,
    tipo VARCHAR(20),
    marca VARCHAR(50),
    modelo VARCHAR(50),
    ano INT,
    capacidad_kg DECIMAL(8,2),
    volumen_m3 DECIMAL(6,2),
    estado VARCHAR(30) DEFAULT 'activo' NOT NULL,
    deleted_at DATETIME,
    CONSTRAINT uq_vehiculos_placa UNIQUE (placa),
    CONSTRAINT chk_vehiculos_estado CHECK (estado IN ('activo','mantenimiento','inactivo'))
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE conductores (
    id INT AUTO_INCREMENT PRIMARY KEY,
    empleado_id INT NOT NULL,
    licencia_conducir VARCHAR(20) NOT NULL,
    tipo_licencia VARCHAR(10),
    fecha_vencimiento_licencia DATE,
    estado VARCHAR(30) DEFAULT 'disponible' NOT NULL,
    deleted_at DATETIME,
    CONSTRAINT uq_conductores_empleado UNIQUE (empleado_id),
    CONSTRAINT uq_conductores_licencia UNIQUE (licencia_conducir),
    CONSTRAINT fk_conductores_empleado FOREIGN KEY (empleado_id) REFERENCES empleados(id),
    CONSTRAINT chk_conductores_estado CHECK (estado IN ('disponible','en_ruta','inactivo','vacaciones'))
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE manifiesto_transporte (
    id INT AUTO_INCREMENT PRIMARY KEY,
    origen_ubicacion_id INT NOT NULL,
    destino_ubicacion_id INT NOT NULL,
    vehiculo_id INT,
    conductor_id INT,
    codigo_manifiesto VARCHAR(25) NOT NULL,
    estado VARCHAR(30) DEFAULT 'abierto' NOT NULL,
    fecha_creacion DATETIME DEFAULT CURRENT_TIMESTAMP,
    fecha_salida_estimada DATETIME,
    fecha_llegada_real DATETIME,
    observaciones TEXT,
    deleted_at DATETIME,
    CONSTRAINT uq_manifiesto_codigo UNIQUE (codigo_manifiesto),
    CONSTRAINT fk_manifiesto_origen FOREIGN KEY (origen_ubicacion_id) REFERENCES ubicaciones(id),
    CONSTRAINT fk_manifiesto_destino FOREIGN KEY (destino_ubicacion_id) REFERENCES ubicaciones(id),
    CONSTRAINT fk_manifiesto_vehiculo FOREIGN KEY (vehiculo_id) REFERENCES vehiculos(id),
    CONSTRAINT fk_manifiesto_conductor FOREIGN KEY (conductor_id) REFERENCES conductores(id),
    CONSTRAINT chk_manifiesto_estado CHECK (estado IN ('abierto','en_transito','cerrado','auditado'))
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE manifiesto_paquete (
    manifiesto_transporte_id INT NOT NULL,
    paquete_id INT NOT NULL,
    fecha_escaneo_carga DATETIME DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (manifiesto_transporte_id, paquete_id),
    CONSTRAINT fk_mp_manifiesto FOREIGN KEY (manifiesto_transporte_id) REFERENCES manifiesto_transporte(id) ON DELETE CASCADE,
    CONSTRAINT fk_mp_paquete FOREIGN KEY (paquete_id) REFERENCES paquetes(id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE historial_paquete (
    id INT AUTO_INCREMENT PRIMARY KEY,
    paquete_id INT NOT NULL,
    ubicacion_id INT NOT NULL,
    empleado_id INT,
    manifiesto_transporte_id INT,
    tipo_evento VARCHAR(50) NOT NULL,
    comentario TEXT,
    fecha_hora DATETIME DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_historial_paquete_paquete FOREIGN KEY (paquete_id) REFERENCES paquetes(id) ON DELETE CASCADE,
    CONSTRAINT fk_historial_ubicacion FOREIGN KEY (ubicacion_id) REFERENCES ubicaciones(id),
    CONSTRAINT fk_historial_empleado FOREIGN KEY (empleado_id) REFERENCES empleados(id),
    CONSTRAINT fk_historial_manifiesto FOREIGN KEY (manifiesto_transporte_id) REFERENCES manifiesto_transporte(id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ===============================================================
-- MÓDULO 5: OTRAS TABLAS (PAGOS, NOTIFICACIONES, RUTAS, ASIGNACIONES)
-- ===============================================================

CREATE TABLE pagos (
    id INT AUTO_INCREMENT PRIMARY KEY,
    envio_id INT NOT NULL,
    empleado_id INT,
    monto DECIMAL(10,2) NOT NULL,
    metodo_pago VARCHAR(30) NOT NULL,
    estado VARCHAR(30) NOT NULL,
    transaccion_id VARCHAR(100),
    CONSTRAINT fk_pagos_envio FOREIGN KEY (envio_id) REFERENCES envios(id),
    CONSTRAINT fk_pagos_empleado FOREIGN KEY (empleado_id) REFERENCES empleados(id),
    CONSTRAINT chk_pagos_estado CHECK (estado IN ('completado','pendiente','fallido','reembolsado'))
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE notificaciones (
    id INT AUTO_INCREMENT PRIMARY KEY,
    envio_id INT NOT NULL,
    cliente_id INT,
    tipo VARCHAR(10) NOT NULL,
    mensaje TEXT NOT NULL,
    destinatario VARCHAR(100) NOT NULL,
    CONSTRAINT fk_notificaciones_envio FOREIGN KEY (envio_id) REFERENCES envios(id),
    CONSTRAINT fk_notificaciones_cliente FOREIGN KEY (cliente_id) REFERENCES clientes(id),
    CONSTRAINT chk_notificaciones_tipo CHECK (tipo IN ('email','sms','push'))
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE rutas (
    id INT AUTO_INCREMENT PRIMARY KEY,
    origen_id INT NOT NULL,
    destino_id INT NOT NULL,
    tiempo_estimado_min INT,
    distancia_km DECIMAL(8,2),
    CONSTRAINT fk_rutas_origen FOREIGN KEY (origen_id) REFERENCES ubicaciones(id),
    CONSTRAINT fk_rutas_destino FOREIGN KEY (destino_id) REFERENCES ubicaciones(id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE asignaciones (
    id INT AUTO_INCREMENT PRIMARY KEY,
    envio_id INT NOT NULL,
    conductor_id INT,
    vehiculo_id INT,
    ruta_id INT,
    estado VARCHAR(30) NOT NULL,
    CONSTRAINT fk_asignaciones_envio FOREIGN KEY (envio_id) REFERENCES envios(id),
    CONSTRAINT fk_asignaciones_conductor FOREIGN KEY (conductor_id) REFERENCES conductores(id),
    CONSTRAINT fk_asignaciones_vehiculo FOREIGN KEY (vehiculo_id) REFERENCES vehiculos(id),
    CONSTRAINT fk_asignaciones_ruta FOREIGN KEY (ruta_id) REFERENCES rutas(id),
    CONSTRAINT chk_asignaciones_estado CHECK (estado IN ('pendiente','en_curso','finalizado','cancelado'))
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ===============================================================
-- ÍNDICES PARA OPTIMIZACIÓN
-- ===============================================================

CREATE INDEX idx_usuarios_email ON usuarios(email);
CREATE INDEX idx_envios_tracking_code ON envios(tracking_code);
CREATE INDEX idx_envios_estado ON envios(estado);
CREATE INDEX idx_envios_fecha_creacion ON envios(fecha_creacion);
CREATE INDEX idx_paquetes_codigo_barras ON paquetes(codigo_barras);
CREATE INDEX idx_historial_paquete_fecha ON historial_paquete(fecha_hora);

SET FOREIGN_KEY_CHECKS = 1;

-- ===============================================================
-- FIN DEL SCRIPT DE INICIALIZACIÓN
-- ===============================================================
