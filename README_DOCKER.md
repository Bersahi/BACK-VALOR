# 🐳 Guía de Docker - Sistema de Envíos

Esta guía explica cómo usar Docker para levantar la base de datos Oracle con todos los datos pre-cargados.

## 📋 Requisitos Previos

- **Docker Desktop** instalado y corriendo
- **Windows** con PowerShell o CMD
- **Mínimo 4GB de RAM** disponible para Docker

## 🚀 Scripts Disponibles

### 1. `iniciar-proyecto.bat` 
**Uso completo del sistema**

Ejecuta este script para:
- ✅ Verificar que Docker esté corriendo
- ✅ Detener contenedores previos
- ✅ Levantar la base de datos Oracle
- ✅ Esperar a que la BD esté lista
- ✅ Verificar dependencias de Node
- ✅ Iniciar el backend NestJS en modo desarrollo

```bash
# Doble clic en el archivo o ejecutar desde CMD:
iniciar-proyecto.bat
```

### 2. `iniciar-solo-db.bat`
**Solo base de datos**

Ejecuta este script si solo necesitas la base de datos sin el backend:
- ✅ Levanta solo el contenedor de Oracle
- ✅ Espera a que la BD esté lista
- ✅ No inicia el backend

```bash
iniciar-solo-db.bat
```

### 3. `detener-proyecto.bat`
**Detener servicios**

Detiene todos los contenedores de Docker:

```bash
detener-proyecto.bat
```

### 4. `reiniciar-db.bat`
**Reiniciar desde cero**

⚠️ **ADVERTENCIA:** Este script eliminará todos los datos y recreará la base de datos.

Úsalo cuando necesites:
- Resetear la base de datos a su estado inicial
- Solucionar problemas de corrupción de datos
- Volver a cargar los datos de ejemplo

```bash
reiniciar-db.bat
```

## 📊 Estructura de la Base de Datos

### Usuario y Credenciales
- **Usuario:** ADMIN
- **Password:** admin123
- **Host:** localhost
- **Puerto:** 1521
- **Service Name:** paqueteria

### Tablas Creadas

#### ENVIOS
```sql
- ID (NUMBER) - Autoincremental
- CLIENTE_ID (NUMBER)
- ORIGEN_ID (NUMBER)
- DESTINO_ID (NUMBER)
- REMITENTE_NOMBRE (VARCHAR2)
- REMITENTE_TELEFONO (VARCHAR2)
- REMITENTE_DOCUMENTO (VARCHAR2)
- REMITENTE_EMAIL (VARCHAR2)
- TRACKING_CODE (VARCHAR2) - Único
- COSTO_TOTAL (NUMBER)
- METODO_ENVIO (VARCHAR2)
- ESTADO (VARCHAR2)
- FECHA_CREACION (TIMESTAMP)
```

### Datos Pre-cargados

El sistema incluye 5 registros de ejemplo:
1. Juan Pérez - TRACK001 - PENDIENTE
2. María García - TRACK002 - EN_TRANSITO
3. Carlos López - TRACK003 - ENTREGADO
4. Ana Martínez - TRACK004 - PENDIENTE
5. Pedro Sánchez - TRACK005 - EN_TRANSITO

## 🔧 Configuración

### Variables de Entorno (.env)

El archivo `.env` contiene la configuración de conexión:

```env
DB_HOST=localhost
DB_PORT=1521
DB_USERNAME=ADMIN
DB_PASSWORD=admin123
DB_NAME=paqueteria
DB_LOGGING=true
PORT=3000
NODE_ENV=development
```

### Docker Compose

El archivo `docker-compose.yml` configura:
- **Imagen:** Oracle Express Edition 21.3.0
- **Volúmenes persistentes:** oracle_data y oracle_backup
- **Health check:** Verifica la disponibilidad de la BD
- **Scripts de inicialización:** Se ejecutan automáticamente

## 🐛 Solución de Problemas

### Docker no se inicia
```bash
# Asegúrate de que Docker Desktop esté corriendo
# Reinicia Docker Desktop si es necesario
```

### La base de datos no responde
```bash
# Verifica los logs del contenedor
docker logs back-valor-oracle-1

# Reinicia la base de datos
.\reiniciar-db.bat
```

### Error de conexión desde NestJS
```bash
# Verifica que la BD esté corriendo
docker ps

# Verifica las credenciales en .env
# Asegúrate de que coincidan con docker-compose.yml
```

### Problemas de permisos
```bash
# Ejecuta CMD o PowerShell como Administrador
```

## 📝 Comandos Docker Útiles

```bash
# Ver contenedores corriendo
docker ps

# Ver logs del contenedor
docker logs back-valor-oracle

# Ver logs en tiempo real
docker logs -f back-valor-oracle

# Entrar al contenedor
docker exec -it back-valor-oracle bash

# Conectar a SQL*Plus dentro del contenedor
docker exec -it back-valor-oracle sqlplus ADMIN/admin123@//localhost:1521/paqueteria

# Ver volúmenes
docker volume ls

# Eliminar todo (contenedores, volúmenes, redes)
docker-compose down -v
```

## 🎯 Flujo de Trabajo Recomendado

### Desarrollo Diario
1. Ejecutar `iniciar-proyecto.bat`
2. Trabajar en el código
3. El backend se reinicia automáticamente (hot-reload)
4. Al terminar, ejecutar `detener-proyecto.bat`

### Solo Base de Datos
1. Ejecutar `iniciar-solo-db.bat`
2. Usar herramientas externas (SQL Developer, DBeaver, etc.)
3. Conectar usando las credenciales mencionadas

### Reset Completo
1. Ejecutar `reiniciar-db.bat`
2. Confirmar la operación
3. Esperar a que se recree todo

## 📦 Archivos Importantes

```
back-valor/
├── docker-compose.yml          # Configuración de Docker
├── .env                        # Variables de entorno
├── iniciar-proyecto.bat        # Script principal
├── iniciar-solo-db.bat        # Solo base de datos
├── detener-proyecto.bat       # Detener servicios
├── reiniciar-db.bat           # Reiniciar desde cero
└── docker/
    ├── Dockerfile             # Configuración de la imagen
    └── scripts/
        ├── 01_init.sql        # Creación de tablas
        └── 02_data.sql        # Datos iniciales
```

## 🆘 Soporte

Si encuentras problemas:
1. Revisa los logs: `docker logs back-valor-oracle`
2. Verifica que Docker Desktop tenga suficiente memoria
3. Asegúrate de que el puerto 1521 no esté en uso
4. Prueba reiniciar: `.\reiniciar-db.bat`

---

✅ **¡Listo para desarrollar!** Ejecuta `iniciar-proyecto.bat` y comienza a trabajar.

