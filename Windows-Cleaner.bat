@echo off
setlocal EnableExtensions
title TerminalFix Windows Cleaner - Windows 7
color 0A

rem ============================================================
rem TERMINALFIX WINDOWS CLEANER - EDICION WINDOWS 7
rem Version 1.1
rem
rem Pensado solo para Windows 7 (x86), incluso sin Service Pack 1.
rem - PowerShell 2.0: solo se usan Get-PSDrive y Start-Process.
rem - Sin DISM /StartComponentCleanup (no existe en Windows 7).
rem - Guardar como ANSI o ASCII, sin BOM. Solo caracteres ASCII.
rem ============================================================

rem ------------------------------------------------------------
rem PERMISOS DE ADMINISTRADOR
rem ------------------------------------------------------------

fltmc >nul 2>&1
if not errorlevel 1 goto ADMIN_OK

echo.
echo   Se requieren permisos de administrador.
echo   Solicitando permisos...
echo.

powershell -NoProfile -ExecutionPolicy Bypass -Command "Start-Process -FilePath '%~f0' -Verb RunAs"
if errorlevel 1 pause
exit /b

:ADMIN_OK

rem ------------------------------------------------------------
rem SOLO WINDOWS 7 (version 6.1)
rem ------------------------------------------------------------

set "WINVER="
set "WINBUILD="
for /f "tokens=2 delims=[]" %%A in ('ver') do for /f "tokens=2,3,4 delims=. " %%B in ("%%A") do (
    set "WINVER=%%B.%%C"
    set "WINBUILD=%%D"
)

if not "%WINVER%"=="6.1" goto NO_WIN7

rem ------------------------------------------------------------
rem NO EJECUTAR DESDE LA CARPETA TEMP (por ejemplo, desde un ZIP)
rem ------------------------------------------------------------

echo "%~f0" | find /i "%TEMP%" >nul
if not errorlevel 1 goto EN_TEMP

rem ------------------------------------------------------------
rem CONFIGURACION
rem ------------------------------------------------------------

set "VERSION=1.1"
set "DRV=%SystemDrive:~0,1%"
set "TEMP_WINDOWS=%SystemRoot%\Temp"
set "WU_DOWNLOAD=%SystemRoot%\SoftwareDistribution\Download"
set "VC=HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\VolumeCaches"

goto MENU


:NO_WIN7
cls
echo.
echo ============================================================
echo   Este script es SOLO para Windows 7.
echo   Version detectada: %WINVER%
echo   Para Windows 10 use la version correspondiente.
echo ============================================================
echo.
pause
exit /b


:EN_TEMP
cls
echo.
echo ============================================================
echo   Este script esta dentro de la carpeta TEMP.
echo   Puede ser que lo haya abierto directo desde un ZIP.
echo   Copielo a otra carpeta y ejecutelo de nuevo.
echo ============================================================
echo.
pause
exit /b


rem ============================================================
rem MENU
rem ============================================================

:MENU
cls
echo.
echo ============================================================
echo        TERMINALFIX WINDOWS CLEANER - WINDOWS 7
echo             Version %VERSION%  -  build %WINBUILD%
echo ============================================================
echo.
echo   [1] LIMPIEZA COMPLETA
echo   [2] Limpiar TEMP del usuario
echo   [3] Limpiar TEMP de Windows
echo   [4] Limpiar Windows Update
echo   [5] Vaciar papelera
echo   [6] Limpiar cache DNS
echo   [7] Limpiar cache de navegadores
echo   [8] Liberador de espacio de Windows
echo   [9] Ver espacio disponible
echo   [0] Salir
echo.
echo ============================================================
echo.

choice /c 1234567890 /n /m "Seleccione una opcion: "

if errorlevel 10 goto SALIR
if errorlevel 9 goto ESPACIO
if errorlevel 8 goto SISTEMA
if errorlevel 7 goto NAVEGADORES
if errorlevel 6 goto DNS
if errorlevel 5 goto PAPELERA
if errorlevel 4 goto WINDOWS_UPDATE
if errorlevel 3 goto TEMP_WIN
if errorlevel 2 goto TEMP_USUARIO
if errorlevel 1 goto LIMPIEZA_COMPLETA

goto MENU


rem ============================================================
rem LIMPIEZA COMPLETA
rem ============================================================

:LIMPIEZA_COMPLETA
cls
echo.
echo ============================================================
echo                  LIMPIEZA COMPLETA
echo ============================================================
echo.
echo   Se ejecutaran todas las tareas de mantenimiento.
echo.
echo   Tenga en cuenta:
echo.
echo     - Se CERRARAN los navegadores. Guarde su trabajo antes.
echo     - La papelera se VACIARA de forma permanente.
echo.
echo   No se eliminaran documentos, imagenes, videos, descargas,
echo   programas instalados ni controladores.
echo.
echo   El proceso puede tardar varios minutos.
echo.

choice /c SN /n /m "Desea continuar? [S/N]: "
if errorlevel 2 goto MENU

call :ESPACIO_ANTES

echo.
echo ============================================================
echo [1/8] Cerrando navegadores
echo ============================================================
call :CERRAR_NAVEGADORES

echo.
echo ============================================================
echo [2/8] Limpiando TEMP del usuario
echo ============================================================
call :LIMPIAR_TEMP_USUARIO

echo.
echo ============================================================
echo [3/8] Limpiando TEMP de Windows
echo ============================================================
call :LIMPIAR_TEMP_WIN

echo.
echo ============================================================
echo [4/8] Limpiando Windows Update
echo ============================================================
call :LIMPIAR_WINDOWS_UPDATE

echo.
echo ============================================================
echo [5/8] Limpiando cache de navegadores
echo ============================================================
call :LIMPIAR_NAVEGADORES

echo.
echo ============================================================
echo [6/8] Vaciando papelera
echo ============================================================
call :VACIAR_PAPELERA

echo.
echo ============================================================
echo [7/8] Limpiando cache DNS
echo ============================================================
call :LIMPIAR_DNS

echo.
echo ============================================================
echo [8/8] Liberador de espacio de Windows
echo ============================================================
call :LIMPIAR_SISTEMA

call :ESPACIO_DESPUES
goto FIN


rem ============================================================
rem TEMP USUARIO
rem ============================================================

:TEMP_USUARIO
cls
echo.
echo ============================================================
echo                  TEMP DEL USUARIO
echo ============================================================
call :LIMPIAR_TEMP_USUARIO
echo.
echo Proceso finalizado.
pause
goto MENU


:LIMPIAR_TEMP_USUARIO
echo.
echo Limpiando: %TEMP%
call :BORRAR_CONTENIDO "%TEMP%"
if errorlevel 1 goto TEMP_USR_ERROR
echo   [OK] TEMP del usuario procesado. Los archivos en uso se omiten.
exit /b
:TEMP_USR_ERROR
echo   [!] No se pudo procesar la carpeta TEMP del usuario.
exit /b


rem ============================================================
rem TEMP WINDOWS
rem ============================================================

:TEMP_WIN
cls
echo.
echo ============================================================
echo                  TEMP DE WINDOWS
echo ============================================================
call :LIMPIAR_TEMP_WIN
echo.
echo Proceso finalizado.
pause
goto MENU


:LIMPIAR_TEMP_WIN
echo.
echo Limpiando: %TEMP_WINDOWS%
call :BORRAR_CONTENIDO "%TEMP_WINDOWS%"
if errorlevel 1 goto TEMP_WIN_ERROR
echo   [OK] TEMP de Windows procesado. Los archivos en uso se omiten.
exit /b
:TEMP_WIN_ERROR
echo   [!] No se pudo procesar la carpeta TEMP de Windows.
exit /b


rem ============================================================
rem WINDOWS UPDATE
rem ============================================================

:WINDOWS_UPDATE
cls
echo.
echo ============================================================
echo                  WINDOWS UPDATE
echo ============================================================
call :LIMPIAR_WINDOWS_UPDATE
echo.
echo Proceso finalizado.
pause
goto MENU


:LIMPIAR_WINDOWS_UPDATE
set "WU_RUN=0"
set "BITS_RUN=0"
sc query wuauserv | find "RUNNING" >nul && set "WU_RUN=1"
sc query bits | find "RUNNING" >nul && set "BITS_RUN=1"

echo.
echo Deteniendo servicios de Windows Update...
net stop wuauserv >nul 2>&1
net stop bits >nul 2>&1

echo Limpiando cache de descargas...
call :BORRAR_CONTENIDO "%WU_DOWNLOAD%"
if errorlevel 1 goto WU_ERROR
echo   [OK] Cache de Windows Update procesada.
goto WU_SERVICIOS
:WU_ERROR
echo   [!] No se pudo procesar la carpeta de descargas.
:WU_SERVICIOS
if "%WU_RUN%"=="1" net start wuauserv >nul 2>&1
if "%BITS_RUN%"=="1" net start bits >nul 2>&1
echo   [OK] Servicios restaurados a su estado anterior.
exit /b


rem ============================================================
rem PAPELERA
rem ============================================================

:PAPELERA
cls
echo.
echo ============================================================
echo                     PAPELERA
echo ============================================================
echo.
echo   Se vaciara la papelera de la unidad %SystemDrive% de TODOS
echo   los usuarios. Los archivos se borran de forma permanente.
echo.
choice /c SN /n /m "Desea continuar? [S/N]: "
if errorlevel 2 goto MENU
call :VACIAR_PAPELERA
echo.
echo Proceso finalizado.
pause
goto MENU


:VACIAR_PAPELERA
echo.
echo Vaciando papelera de %SystemDrive% ...
if exist "%SystemDrive%\$Recycle.Bin\" rd /s /q "%SystemDrive%\$Recycle.Bin" >nul 2>&1
echo   [OK] Papelera procesada.
exit /b


rem ============================================================
rem DNS
rem ============================================================

:DNS
cls
echo.
echo ============================================================
echo                    CACHE DNS
echo ============================================================
call :LIMPIAR_DNS
echo.
echo Proceso finalizado.
pause
goto MENU


:LIMPIAR_DNS
echo.
echo Limpiando cache DNS...
ipconfig /flushdns
if errorlevel 1 goto DNS_ERROR
echo   [OK] Cache DNS procesada.
exit /b
:DNS_ERROR
echo   [!] No se pudo limpiar la cache DNS.
exit /b


rem ============================================================
rem NAVEGADORES
rem ============================================================

:NAVEGADORES
cls
echo.
echo ============================================================
echo               CACHE DE NAVEGADORES
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
taskkill /f /im iexplore.exe >nul 2>&1
echo   [OK] Navegadores cerrados.
exit /b


:LIMPIAR_NAVEGADORES
echo.
echo Limpiando caches temporales del usuario actual...

call :LIMPIAR_CHROMIUM "%LOCALAPPDATA%\Google\Chrome\User Data"
call :LIMPIAR_CHROMIUM "%LOCALAPPDATA%\Microsoft\Edge\User Data"
call :LIMPIAR_CHROMIUM "%LOCALAPPDATA%\BraveSoftware\Brave-Browser\User Data"

for /d %%P in ("%LOCALAPPDATA%\Mozilla\Firefox\Profiles\*") do if exist "%%~P\cache2\" rd /s /q "%%~P\cache2" >nul 2>&1

start /wait RunDll32.exe InetCpl.cpl,ClearMyTracksByProcess 8

echo   [OK] Caches de navegadores procesadas.
exit /b


:LIMPIAR_CHROMIUM
rem %~1 = carpeta "User Data" de un navegador basado en Chromium
if not exist "%~1\" exit /b 0
for /d %%P in ("%~1\*") do (
    for %%C in ("Cache" "Code Cache" "GPUCache") do (
        if exist "%%~P\%%~C\" rd /s /q "%%~P\%%~C" >nul 2>&1
    )
)
exit /b 0


rem ============================================================
rem LIBERADOR DE ESPACIO DE WINDOWS (reemplaza a DISM)
rem ============================================================

:SISTEMA
cls
echo.
echo ============================================================
echo            LIBERADOR DE ESPACIO DE WINDOWS
echo ============================================================
echo.
echo   Usa el Liberador de espacio en disco de Windows 7 para
echo   borrar miniaturas, restos de chkdsk, registros de
echo   instalacion, volcados de memoria e informes de errores.
echo.
echo   Tarda varios minutos y muestra una ventana de progreso.
echo.
choice /c SN /n /m "Desea continuar? [S/N]: "
if errorlevel 2 goto MENU
call :LIMPIAR_SISTEMA
echo.
echo Proceso finalizado.
pause
goto MENU


:LIMPIAR_SISTEMA
echo.
echo Configurando el Liberador de espacio en disco...
for %%H in ("Thumbnail Cache" "Old ChkDsk Files" "Setup Log Files" "Temporary Setup Files" "System error memory dump files" "System error minidump files" "Windows Error Reporting Archive Files" "Windows Error Reporting Queue Files" "Windows Error Reporting System Archive Files" "Windows Error Reporting System Queue Files") do (
    reg query "%VC%\%%~H" >nul 2>&1 && reg add "%VC%\%%~H" /v StateFlags0099 /t REG_DWORD /d 2 /f >nul 2>&1
)
echo Ejecutando. Esto puede tardar varios minutos...
start /wait cleanmgr /sagerun:99
echo   [OK] Liberador de espacio finalizado.
exit /b


rem ============================================================
rem ESPACIO
rem ============================================================

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
powershell -NoProfile -Command "$d=Get-PSDrive %DRV%; Write-Host ('Unidad %DRV%: {0} GB libres de {1} GB' -f [math]::Round($d.Free/1GB,2), [math]::Round(($d.Used+$d.Free)/1GB,2))"
exit /b


:ESPACIO_ANTES
set "ESPACIO_ANTES="
for /f %%A in ('powershell -NoProfile -Command "[int]((Get-PSDrive %DRV%).Free/1MB)"') do set "ESPACIO_ANTES=%%A"
exit /b


:ESPACIO_DESPUES
set "ESPACIO_DESPUES="
for /f %%A in ('powershell -NoProfile -Command "[int]((Get-PSDrive %DRV%).Free/1MB)"') do set "ESPACIO_DESPUES=%%A"

echo.
echo ============================================================
echo                  RESULTADO FINAL
echo ============================================================
echo.

if not defined ESPACIO_ANTES goto SIN_MEDICION
if not defined ESPACIO_DESPUES goto SIN_MEDICION

set /a LIBERADO=ESPACIO_DESPUES-ESPACIO_ANTES
set /a LIB_ENT=LIBERADO/1024
set /a LIB_DEC=(LIBERADO%%1024)*10/1024

echo   Espacio libre antes  : %ESPACIO_ANTES% MB
echo   Espacio libre despues: %ESPACIO_DESPUES% MB

if %LIBERADO% GTR 0 goto HUBO_ESPACIO
echo   No se detecto espacio adicional liberado.
exit /b
:HUBO_ESPACIO
echo   Espacio liberado     : %LIBERADO% MB, aprox. %LIB_ENT%.%LIB_DEC% GB
exit /b

:SIN_MEDICION
echo   No se pudo medir el espacio libre.
exit /b


rem ============================================================
rem BORRAR CONTENIDO DE UNA CARPETA (con protecciones)
rem ============================================================

:BORRAR_CONTENIDO
rem %~1 = carpeta cuyo CONTENIDO se borra, sin barra final.
rem Devuelve errorlevel 1 si la ruta es invalida o es la raiz.
if "%~1"=="" exit /b 1
if /i "%~1"=="%SystemDrive%" exit /b 1
if /i "%~1"=="%SystemDrive%\" exit /b 1
if not exist "%~1\" exit /b 1
del /f /s /q "%~1\*" >nul 2>&1
for /d %%D in ("%~1\*") do rd /s /q "%%D" >nul 2>&1
exit /b 0


rem ============================================================
rem FIN
rem ============================================================

:FIN
echo.
echo ============================================================
echo                     TERMINALFIX
echo                 LIMPIEZA FINALIZADA
echo ============================================================
echo.
echo   Puede reiniciar el equipo para completar cualquier
echo   operacion pendiente de Windows.
echo.
pause
goto MENU


rem ============================================================
rem SALIR
rem ============================================================

:SALIR
cls
echo.
echo ============================================================
echo            TERMINALFIX WINDOWS CLEANER
echo ============================================================
echo.
echo   Gracias por utilizar TerminalFix.
echo.
echo ============================================================
echo.
timeout /t 2 >nul
exit /b
