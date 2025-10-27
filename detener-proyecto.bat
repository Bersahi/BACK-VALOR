@echo off
cls

echo.
echo ============================================================
echo           DETENIENDO SISTEMA - VALOREXPRESS
echo ============================================================
echo.

echo Deteniendo contenedores de Docker...
docker-compose down

if errorlevel 1 (
    echo.
    echo ERROR al detener los contenedores.
    echo Verifica que Docker Desktop este corriendo.
) else (
    echo.
    echo Sistema detenido correctamente.
    echo.
    echo Los datos se mantienen en volumenes de Docker.
    echo Para eliminar TODO (incluyendo datos):
    echo    docker-compose down -v
)

echo.
pause
