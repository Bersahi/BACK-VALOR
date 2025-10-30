@echo off
cls

echo.
echo ============================================================
echo         SISTEMA DE ENVIOS - VALOREXPRESS
echo              Inicializando Base de Datos
echo ============================================================
echo.

REM Verificar si Docker esta corriendo
echo [1/4] Verificando Docker...
docker info >nul 2>&1
if errorlevel 1 (
    echo     ERROR: Docker no esta corriendo.
    echo     Por favor inicia Docker Desktop primero.
    pause
    exit /b 1
)
echo     OK - Docker esta corriendo.
echo.

REM Detener contenedores y ELIMINAR volumenes (reset completo)
echo [2/4] Limpiando todo (contenedores + volumenes)...
docker-compose -f docker\docker-compose.yml down -v >nul 2>&1
echo     OK - Todo limpio, empezando desde cero.
echo.

REM Levantar el contenedor de MySQL
echo [3/4] Levantando MySQL 8.0...
echo     (Esto ejecutara automaticamente los scripts SQL)
docker-compose -f docker\docker-compose.yml up -d
if errorlevel 1 (
    echo     ERROR: No se pudo iniciar el contenedor.
    pause
    exit /b 1
)
echo     OK - Contenedor iniciado.
echo.

REM Esperar a que la base de datos este lista
echo [4/4] Esperando a que MySQL este listo...
set /a intentos=0
:WAIT_LOOP
timeout /t 3 /nobreak >nul
docker exec back-valor-mysql mysqladmin ping -h localhost -u admin -padmin123 >nul 2>&1
if errorlevel 1 (
    set /a intentos+=1
    if %intentos% GTR 20 (
        echo     ERROR: MySQL tarda demasiado en iniciar.
        echo     Revisa los logs: docker logs back-valor-mysql
        pause
        exit /b 1
    )
    echo     Esperando... (%intentos%/20^)
    goto WAIT_LOOP
)
echo     OK - MySQL listo!
echo.

echo ============================================================
echo              BASE DE DATOS LISTA
echo ============================================================
echo.
echo MySQL corriendo en:
echo    Host:     localhost
echo    Puerto:   3308
echo    Usuario:  admin
echo    Password: admin123
echo    Database: valorexpress
echo.
echo Base de datos creada con:
echo    - 25 tablas (cada una con 5 registros)
echo    - 125 registros totales de ejemplo
echo    - Todas las relaciones y constraints
echo.
echo Comandos utiles:
echo    Ver tablas:  docker exec back-valor-mysql mysql -u admin -padmin123 -D valorexpress -e "SHOW TABLES;"
echo    Ver envios:  docker exec back-valor-mysql mysql -u admin -padmin123 -D valorexpress -e "SELECT * FROM envios;"
echo    Ver logs:    docker logs back-valor-mysql
echo    Detener:     detener.bat
echo.
echo NOTA: Este script siempre recrea la BD desde cero con datos frescos.
echo.
echo ============================================================
echo.
pause

