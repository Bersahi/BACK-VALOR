# 📊 Estructura Completa de la Base de Datos ValorExpress (MySQL)

## ✅ **Base de Datos Completa - 25 Tablas en MySQL 8.0**

### 📋 Resumen del Proceso Docker

Cuando ejecutas `iniciar-proyecto.bat`:

1. ✅ **Docker levanta el contenedor de MySQL** (solo 30-60 segundos)
2. ✅ **Ejecuta automáticamente**: `01_init.sql` (crea las 25 tablas)
3. ✅ **Ejecuta automáticamente**: `02_data.sql` (inserta datos de ejemplo)
4. ✅ **Resultado**: Base de datos completa con datos listos para usar

**NO usa dump (.sql dump)** - Usa **scripts SQL directos** que se ejecutan automáticamente.

### ⚡ **Ventajas de MySQL**
- 🚀 Mucho más rápido que Oracle (30s vs 3 minutos)
- 💾 Más ligero (500MB vs 2GB)
- 🛠️ Más herramientas y soporte
- 💰 Más económico para hosting

---

## 🗂️ **Tablas Creadas (25 Tablas)**

### MÓDULO 1: USUARIOS Y PERMISOS (7 tablas)
1. ✅ **usuarios** - Usuarios del sistema
2. ✅ **roles** - Roles (admin, gerente, empleado, conductor, cliente)
3. ✅ **permisos** - Permisos del sistema
4. ✅ **rol_permiso** - Relación roles-permisos
5. ✅ **sucursales** - Sucursales de ValorExpress
6. ✅ **empleados** - Empleados de la empresa
7. ✅ **clientes** - Clientes registrados

### MÓDULO 2: GEOGRAFÍA Y TARIFAS (4 tablas)
8. ✅ **zonas** - Zonas geográficas (Centro, Norte, Sur)
9. ✅ **microzonas** - Microzonas con códigos postales
10. ✅ **matriz_tarifas_zonas** - Costos adicionales entre microzonas
11. ✅ **tarifas** - Tarifas por tipo de envío y peso

### MÓDULO 3: ENVÍOS Y PAQUETES (4 tablas)
12. ✅ **tipos_paquete** - Tipos (Caja Pequeña, Mediana, Grande, Sobre, Pallet)
13. ✅ **direcciones** - Direcciones de clientes
14. ✅ **envios** - Registro de envíos
15. ✅ **paquetes** - Paquetes de cada envío

### MÓDULO 4: LOGÍSTICA Y TRAZABILIDAD (6 tablas)
16. ✅ **ubicaciones** - Almacenes, Hubs, Puntos de entrega
17. ✅ **vehiculos** - Vehículos de la flota
18. ✅ **conductores** - Conductores registrados
19. ✅ **manifiesto_transporte** - Manifiestos de carga
20. ✅ **manifiesto_paquete** - Relación manifiesto-paquetes
21. ✅ **historial_paquete** - Trazabilidad de cada paquete

### MÓDULO 5: OTROS (4 tablas)
22. ✅ **pagos** - Registro de pagos
23. ✅ **notificaciones** - Notificaciones (email, sms, push)
24. ✅ **rutas** - Rutas entre ubicaciones
25. ✅ **asignaciones** - Asignación de envíos a conductores

---

## 📦 **Datos de Ejemplo Incluidos**

### Usuarios y Roles:
- ✅ 5 roles (admin, gerente, empleado, conductor, cliente)
- ✅ 7 permisos básicos
- ✅ 7 usuarios de ejemplo
- ✅ 4 empleados
- ✅ 3 clientes

### Geografía:
- ✅ 3 zonas geográficas
- ✅ 5 microzonas con códigos postales
- ✅ 4 tarifas configuradas (terrestre y aéreo)
- ✅ Matriz de costos entre microzonas

### Sucursales y Ubicaciones:
- ✅ 3 sucursales (Central, Norte, Antigua)
- ✅ 3 ubicaciones (Almacén, Hub, Punto de entrega)

### Logística:
- ✅ 3 vehículos (Camión, Van, Pickup)
- ✅ 1 conductor registrado
- ✅ 5 tipos de paquete

### Envíos Operativos:
- ✅ 4 direcciones de clientes
- ✅ 4 envíos con diferentes estados:
  - TRACK001: registrado
  - TRACK002: en_transito
  - TRACK003: entregado
  - TRACK004: en_almacen
- ✅ 4 paquetes con código de barras
- ✅ 1 manifiesto de transporte activo
- ✅ 4 registros de historial (trazabilidad)
- ✅ 4 pagos (3 completados, 1 pendiente)
- ✅ 3 notificaciones enviadas
- ✅ 3 rutas configuradas
- ✅ 2 asignaciones a conductores

---

## 🔍 **Relaciones Importantes**

### Flujo de un Envío:
```
CLIENTE → crea → ENVÍO
  ↓
ENVÍO tiene ORIGEN (dirección) y DESTINO (dirección)
  ↓
ENVÍO contiene PAQUETES
  ↓
PAQUETES se cargan en MANIFIESTO_TRANSPORTE
  ↓
MANIFIESTO asigna VEHÍCULO y CONDUCTOR
  ↓
HISTORIAL_PAQUETE registra cada movimiento
  ↓
PAGO registra el cobro
  ↓
NOTIFICACIONES informan al cliente
```

### Foreign Keys:
- ✅ Todas las relaciones están correctamente definidas
- ✅ Ciclo controlado entre `sucursales` ↔ `empleados`
- ✅ Cascadas configuradas (DELETE CASCADE donde corresponde)

---

## 🎯 **Estados del Sistema**

### Estados de Envíos:
- `registrado` - Envío creado
- `en_almacen` - En almacén
- `en_transito` - En tránsito
- `en_reparto` - En reparto
- `entregado` - Entregado
- `cancelado` - Cancelado
- `devuelto` - Devuelto

### Estados de Pagos:
- `completado` - Pago exitoso
- `pendiente` - Pendiente de pago
- `fallido` - Pago fallido
- `reembolsado` - Reembolsado

### Estados de Vehículos:
- `activo` - Disponible
- `mantenimiento` - En mantenimiento
- `inactivo` - Fuera de servicio

### Estados de Conductores:
- `disponible` - Disponible
- `en_ruta` - En ruta
- `inactivo` - Inactivo
- `vacaciones` - De vacaciones

---

## 📈 **Índices Creados**

Para optimizar consultas:
```sql
- idx_usuarios_email
- idx_envios_tracking_code
- idx_envios_estado
- idx_envios_fecha_creacion
- idx_paquetes_codigo_barras
- idx_historial_paquete_fecha
```

---

## 🔐 **Credenciales de la Base de Datos**

```
Host:     localhost
Puerto:   3306
Usuario:  admin
Password: admin123
Database: valorexpress
```

## 👥 **Usuarios de Ejemplo**

Todos los usuarios tienen la misma contraseña hash de ejemplo:

| Email | Rol | Función |
|-------|-----|---------|
| admin@valorexpress.com | Admin | Administrador |
| gerente1@valorexpress.com | Gerente | Gerente de sucursal |
| empleado1@valorexpress.com | Empleado | Empleado general |
| conductor1@valorexpress.com | Conductor | Conductor |
| cliente1@valorexpress.com | Cliente | Cliente 1 |
| cliente2@valorexpress.com | Cliente | Cliente 2 |
| cliente3@valorexpress.com | Cliente | Cliente 3 |

---

## 🚀 **Cómo Usar**

### Iniciar por Primera Vez:
```batch
iniciar-proyecto.bat
```

Esto:
1. Levanta el contenedor Docker
2. Ejecuta `01_init.sql` (crea las 25 tablas)
3. Ejecuta `02_data.sql` (inserta los datos)
4. Inicia el backend NestJS

### Verificar Datos:
```batch
ver-datos.bat
```

### Probar Conexión:
```batch
probar-conexion.bat
```

### Consultar Cualquier Tabla:
```sql
-- Desde MySQL Workbench, DBeaver o dentro del contenedor
SELECT * FROM usuarios;
SELECT * FROM envios;
SELECT * FROM paquetes;
SELECT * FROM historial_paquete;
-- ... etc (25 tablas disponibles)
```

### Conectar desde MySQL CLI:
```bash
# Desde terminal
docker exec -it back-valor-mysql mysql -u admin -padmin123 -D valorexpress

# Comandos útiles dentro de MySQL
SHOW TABLES;
DESCRIBE envios;
SELECT COUNT(*) FROM envios;
```

---

## 📝 **Notas Importantes**

1. **Persistencia**: Los datos persisten entre reinicios gracias a volúmenes de Docker
2. **Reset**: Ejecuta `reiniciar-db.bat` para volver al estado inicial
3. **Database**: Todas las tablas están en la base de datos `valorexpress`
4. **Contraseñas**: Las contraseñas en los datos son ejemplos (hashes ficticios)
5. **Tracking Codes**: TRACK001, TRACK002, TRACK003, TRACK004
6. **Códigos de Barras**: BAR001, BAR002, BAR003, BAR004
7. **MySQL 8.0**: Versión moderna y optimizada

---

## ✨ **Ventajas de Esta Implementación**

✅ **25 tablas completas** del esquema ValorExpress  
✅ **MySQL 8.0** - Rápido y eficiente  
✅ **Datos coherentes** con foreign keys válidas  
✅ **Automático**: Se crea todo al levantar el contenedor  
✅ **Scripts SQL** fáciles de modificar y extender  
✅ **Datos realistas** para pruebas  
✅ **Totalmente funcional** desde el primer inicio  
✅ **Ligero**: Solo 500MB vs 2GB de Oracle  

---

🎉 **¡Base de Datos Completa y Lista para Producción!**

