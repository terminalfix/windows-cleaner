```bat
@echo off
setlocal EnableExtensions EnableDelayedExpansion
title TerminalFix Windows Cleaner v1.0
color 0A

:: ============================================================
:: TERMINALFIX WINDOWS CLEANER
:: Version 1.0
::
:: Herramienta de mantenimiento para Windows.
:: Diseñada para limpiar archivos temporales y residuos
:: sin eliminar documentos personales ni programas instalados.
:: ============================================================

:: ------------------------------------------------------------
:: DETECCION DE PRIVILEGIOS DE ADMINISTRADOR
:: ------------------------------------------------------------

net session >nul 2>&1

if %errorlevel% neq 0 (
    echo.
    echo ========================================================
    echo   TERMINALFIX WINDOWS CLEANER
    echo ========================================================
    echo.
    echo   Se requieren permisos de administrador.
    echo   Solicitando permisos...
    echo.

    powershell -NoProfile -ExecutionPolicy Bypass -Command ^
        "Start-Process -FilePath '%~f0' -Verb RunAs"

    exit /b
)

:: ------------------------------------------------------------
:: CONFIGURACION
:: ------------------------------------------------------------

set "VERSION=1.0"
set "TEMP_USER=%TEMP%"
set "TEMP_WINDOWS=C:\Windows\Temp"
set "WU_DOWNLOAD=C:\Windows\SoftwareDistribution\Download"

:: ------------------------------------------------------------
:: INICIO
:: ------------------------------------------------------------

:MENU

cls

echo.
echo ============================================================
echo              TERMINALFIX WINDOWS CLEANER
echo                         VERSION %VERSION%
echo ============================================================
echo.
echo   Herramienta de mantenimiento de Windows
echo.
echo   [1] LIMPIEZA COMPLETA
echo   [2] Limpiar TEMP del usuario
echo   [3] Limpiar TEMP de Windows
echo   [4] Limpiar Windows Update
echo   [5] Vaciar papelera
echo   [6] Limpiar cache DNS
echo   [7] Limpiar cache temporal de navegadores
echo   [8] Limpieza de componentes DISM
echo   [9] Ver espacio disponible
echo   [0] Salir
echo.
echo ============================================================
echo.

choice /c 1234567890 /n /m "Seleccione una opcion: "

if errorlevel 10 goto SALIR
if errorlevel 9 goto ESPACIO
if errorlevel 8 goto DISM
if errorlevel 7 goto NAVEGADORES
if errorlevel 6 goto DNS
if errorlevel 5 goto PAPELERA
if errorlevel 4 goto WINDOWS_UPDATE
if errorlevel 3 goto TEMP_WINDOWS
if errorlevel 2 goto TEMP_USUARIO
if errorlevel 1 goto LIMPIEZA_COMPLETA

goto MENU


:: ============================================================
:: LIMPIEZA COMPLETA
:: ============================================================

:LIMPIEZA_COMPLETA

cls

echo.
echo ============================================================
echo                  LIMPIEZA COMPLETA
echo ============================================================
echo.
echo   Esta opcion ejecutara todas las tareas principales
echo   de mantenimiento de TerminalFix.
echo.
echo   No se eliminaran:
echo.
echo     - Documentos personales
echo     - Imagenes
echo     - Videos
echo     - Descargas personales
echo     - Programas instalados
echo     - Controladores
echo.
echo   El proceso puede tardar varios minutos.
echo.
pause

call :ESPACIO_ANTES

echo.
echo ============================================================
echo [1/7] Cerrando navegadores
echo ============================================================
call :CERRAR_NAVEGADORES

echo.
echo ============================================================
echo [2/7] Limpiando TEMP del usuario
echo ============================================================
call :LIMPIAR_TEMP_USUARIO

echo.
echo ============================================================
echo [3/7] Limpiando TEMP de Windows
echo ============================================================
call :LIMPIAR_TEMP_WINDOWS

echo.
echo ============================================================
echo [4/7] Limpiando Windows Update
echo ============================================================
call :LIMPIAR_WINDOWS_UPDATE

echo.
echo ============================================================
echo [5/7] Limpiando cache de navegadores
echo ============================================================
call :LIMPIAR_NAVEGADORES

echo.
echo ============================================================
echo [6/7] Vaciando papelera
echo ============================================================
call :VACIAR_PAPELERA

echo.
echo ============================================================
echo [7/7] Limpiando cache DNS
echo ============================================================
call :LIMPIAR_DNS

echo.
echo ============================================================
echo          LIMPIEZA DE COMPONENTES DE WINDOWS
echo ============================================================
echo.
echo   Ejecutando DISM...
echo   Esto puede tardar varios minutos.
echo.

DISM /Online /Cleanup-Image /StartComponentCleanup

echo.
echo ============================================================
echo              LIMPIEZA COMPLETADA
echo ============================================================

call :ESPACIO_DESPUES

goto FIN


:: ============================================================
:: TEMP USUARIO
:: ============================================================

:TEMP_USUARIO

cls

echo.
echo ============================================================
echo             TEMP DEL USUARIO
echo ============================================================
echo.

call :LIMPIAR_TEMP_USUARIO

echo.
echo Proceso finalizado.
pause
goto MENU


:LIMPIAR_TEMP_USUARIO

echo.
echo Limpiando: %TEMP_USER%
echo.

del /f /s /q "%TEMP_USER%\*" >nul 2>&1

for /d %%D in ("%TEMP_USER%\*") do (
    rd /s /q "%%D" >nul 2>&1
)

echo   [OK] TEMP del usuario procesado.

exit /b


:: ============================================================
:: TEMP WINDOWS
:: ============================================================

:TEMP_WINDOWS

cls

echo.
echo ============================================================
echo             TEMP DE WINDOWS
echo ============================================================
echo.

call :LIMPIAR_TEMP_WINDOWS

echo.
echo Proceso finalizado.
pause
goto MENU


:LIMPIAR_TEMP_WINDOWS

echo.
echo Limpiando: %TEMP_WINDOWS%
echo.

del /f /s /q "%TEMP_WINDOWS%\*" >nul 2>&1

for /d %%D in ("%TEMP_WINDOWS%\*") do (
    rd /s /q "%%D" >nul 2>&1
)

echo   [OK] TEMP de Windows procesado.

exit /b


:: ============================================================
:: WINDOWS UPDATE
:: ============================================================

:WINDOWS_UPDATE

cls

echo.
echo ============================================================
echo             WINDOWS UPDATE
echo ============================================================
echo.

call :LIMPIAR_WINDOWS_UPDATE

echo.
echo Proceso finalizado.
pause
goto MENU


:LIMPIAR_WINDOWS_UPDATE

echo.
echo Deteniendo servicios de Windows Update...

net stop wuauserv >nul 2>&1
net stop bits >nul 2>&1

echo   [OK] Servicios detenidos.

echo.
echo Limpiando cache de descargas...

del /f /s /q "%WU_DOWNLOAD%\*" >nul 2>&1

for /d %%D in ("%WU_DOWNLOAD%\*") do (
    rd /s /q "%%D" >nul 2>&1
)

echo   [OK] Cache de Windows Update limpiada.

echo.
echo Iniciando servicios...

net start wuauserv >nul 2>&1
net start bits >nul 2>&1

echo   [OK] Servicios iniciados.

exit /b


:: ============================================================
:: PAPELERA
:: ============================================================

:PAPELERA

cls

echo.
echo ============================================================
echo                    PAPELERA
echo ============================================================
echo.

call :VACIAR_PAPELERA

echo.
echo Proceso finalizado.
pause
goto MENU


:VACIAR_PAPELERA

echo Vaciando papelera...

powershell -NoProfile -Command "Clear-RecycleBin -Force -ErrorAction SilentlyContinue"

echo   [OK] Papelera procesada.

exit /b


:: ============================================================
:: DNS
:: ============================================================

:DNS

cls

echo.
echo ============================================================
echo                   CACHE DNS
echo ============================================================
echo.

call :LIMPIAR_DNS

echo.
echo Proceso finalizado.
pause
goto MENU


:LIMPIAR_DNS

echo Limpiando cache DNS...

ipconfig /flushdns

echo.
echo   [OK] Cache DNS procesada.

exit /b


:: ============================================================
:: NAVEGADORES
:: ============================================================

:NAVEGADORES

cls

echo.
echo ============================================================
echo              CACHE DE NAVEGADORES
echo ============================================================
echo.

echo ATENCION:
echo Se recomienda cerrar los navegadores antes de continuar.
echo.
choice /c SN /n /m "Desea cerrar los navegadores automaticamente? [S/N]: "

if errorlevel 2 goto SOLO_CACHE

call :CERRAR_NAVEGADORES

:SOLO_CACHE

call :LIMPIAR_NAVEGADORES

echo.
echo Proceso finalizado.
pause
goto MENU


:CERRAR_NAVEGADORES

echo.
echo Cerrando navegadores...

taskkill /f /im chrome.exe >nul 2>&1
taskkill /f /im msedge.exe >nul 2>&1
taskkill /f /im firefox.exe >nul 2>&1
taskkill /f /im brave.exe >nul 2>&1

echo   [OK] Navegadores procesados.

exit /b


:LIMPIAR_NAVEGADORES

echo.
echo Limpiando caches temporales...

:: Google Chrome
if exist "%LOCALAPPDATA%\Google\Chrome\User Data" (
    del /f /s /q "%LOCALAPPDATA%\Google\Chrome\User Data\*\Cache\*" >nul 2>&1
    del /f /s /q "%LOCALAPPDATA%\Google\Chrome\User Data\*\Code Cache\*" >nul 2>&1
    del /f /s /q "%LOCALAPPDATA%\Google\Chrome\User Data\*\GPUCache\*" >nul 2>&1
)

:: Microsoft Edge
if exist "%LOCALAPPDATA%\Microsoft\Edge\User Data" (
    del /f /s /q "%LOCALAPPDATA%\Microsoft\Edge\User Data\*\Cache\*" >nul 2>&1
    del /f /s /q "%LOCALAPPDATA%\Microsoft\Edge\User Data\*\Code Cache\*" >nul 2>&1
    del /f /s /q "%LOCALAPPDATA%\Microsoft\Edge\User Data\*\GPUCache\*" >nul 2>&1
)

:: Firefox
if exist "%LOCALAPPDATA%\Mozilla\Firefox\Profiles" (
    for /d %%D in ("%LOCALAPPDATA%\Mozilla\Firefox\Profiles\*") do (
        del /f /s /q "%%D\cache2\*" >nul 2>&1
    )
)

:: Brave
if exist "%LOCALAPPDATA%\BraveSoftware\Brave-Browser\User Data" (
    del /f /s /q "%LOCALAPPDATA%\BraveSoftware\Brave-Browser\User Data\*\Cache\*" >nul 2>&1
    del /f /s /q "%LOCALAPPDATA%\BraveSoftware\Brave-Browser\User Data\*\Code Cache\*" >nul 2>&1
    del /f /s /q "%LOCALAPPDATA%\BraveSoftware\Brave-Browser\User Data\*\GPUCache\*" >nul 2>&1
)

echo   [OK] Caches de navegadores procesadas.

exit /b


:: ============================================================
:: DISM
:: ============================================================

:DISM

cls

echo.
echo ============================================================
echo             LIMPIEZA DE COMPONENTES
echo ============================================================
echo.
echo DISM eliminara componentes antiguos que Windows
echo ya no necesita.
echo.
echo Este proceso puede tardar varios minutos.
echo.

choice /c SN /n /m "Desea continuar? [S/N]: "

if errorlevel 2 goto MENU

echo.
echo Ejecutando DISM...
echo.

DISM /Online /Cleanup-Image /StartComponentCleanup

echo.
echo ============================================================
echo Proceso finalizado.
echo ============================================================
echo.

pause
goto MENU


:: ============================================================
:: ESPACIO
:: ============================================================

:ESPACIO

cls

echo.
echo ============================================================
echo               ESPACIO DISPONIBLE
echo ============================================================
echo.

call :MOSTRAR_ESPACIO

echo.
pause
goto MENU


:MOSTRAR_ESPACIO

powershell -NoProfile -Command ^
"$d=Get-CimInstance Win32_LogicalDisk -Filter 'DeviceID=''C:''' ; ^
$gb=[math]::Round($d.FreeSpace/1GB,2); ^
$total=[math]::Round($d.Size/1GB,2); ^
Write-Host ('Unidad C:  '+$gb+' GB libres de '+$total+' GB')"

exit /b


:: ============================================================
:: MEDICION ANTES
:: ============================================================

:ESPACIO_ANTES

for /f "delims=" %%A in ('powershell -NoProfile -Command ^
"$d=Get-CimInstance Win32_LogicalDisk -Filter 'DeviceID=''C:''' ; ^
[math]::Round($d.FreeSpace/1MB,0)"') do set "ESPACIO_ANTES=%%A"

exit /b


:: ============================================================
:: MEDICION DESPUES
:: ============================================================

:ESPACIO_DESPUES

for /f "delims=" %%A in ('powershell -NoProfile -Command ^
"$d=Get-CimInstance Win32_LogicalDisk -Filter 'DeviceID=''C:''' ; ^
[math]::Round($d.FreeSpace/1MB,0)"') do set "ESPACIO_DESPUES=%%A"

echo.
echo ============================================================
echo                  RESULTADO FINAL
echo ============================================================
echo.

powershell -NoProfile -Command ^
"$antes=%ESPACIO_ANTES%; ^
$despues=%ESPACIO_DESPUES%; ^
$liberado=$despues-$antes; ^
Write-Host ('Espacio libre antes : '+[math]::Round($antes/1024,2)+' GB'); ^
Write-Host ('Espacio libre despues: '+[math]::Round($despues/1024,2)+' GB'); ^
if($liberado -gt 0) { ^
Write-Host ('Espacio liberado    : '+[math]::Round($liberado/1024,2)+' GB') ^
} else { ^
Write-Host 'No se detecto espacio adicional liberado.' ^
}"

exit /b


:: ============================================================
:: FIN
:: ============================================================

:FIN

echo.
echo ============================================================
echo                 TERMINALFIX
echo             LIMPIEZA FINALIZADA
echo ============================================================
echo.
echo   El mantenimiento ha terminado correctamente.
echo.
echo   Puede reiniciar el equipo para completar cualquier
echo   operacion pendiente de Windows.
echo.
echo ============================================================
echo.

pause
goto MENU


:: ============================================================
:: SALIR
:: ============================================================

:SALIR

cls

echo.
echo ============================================================
echo              TERMINALFIX WINDOWS CLEANER
echo ============================================================
echo.
echo   Gracias por utilizar TerminalFix.
echo.
echo ============================================================
echo.

timeout /t 2 >nul
exit /b
```
