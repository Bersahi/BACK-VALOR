# Usa la imagen oficial de Oracle Database Express Edition
FROM container-registry.oracle.com/database/express:21.3.0-xe

# Variables de entorno para la configuración inicial
ENV ORACLE_SID=paqueteria \
    ORACLE_PDB=paqueteriapdb \
    ORACLE_PWD=admin123 \
    ORACLE_CHARACTERSET=AL32UTF8

# Copia los scripts de inicialización
COPY scripts/01_init.sql /docker-entrypoint-initdb.d/
COPY scripts/02_data.sql /docker-entrypoint-initdb.d/

# El contenedor ejecutará automáticamente los scripts .sql en /docker-entrypoint-initdb.d/