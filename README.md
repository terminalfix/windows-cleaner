# TerminalFix Windows Cleaner

Herramienta de mantenimiento para Windows desarrollada por **TerminalFix** mediante Batch.

El programa permite realizar diferentes tareas de limpieza y mantenimiento del sistema desde una interfaz sencilla en consola, sin necesidad de instalar software adicional.

## Versión

**v1.1.0**

Versión adaptada específicamente para **Windows 7**, incluyendo sistemas **x86** y equipos que no dispongan de Service Pack 1.

Esta versión reemplaza las funciones específicas de versiones modernas de Windows por herramientas disponibles de forma nativa en Windows 7.

## Características

El programa incluye las siguientes funciones:

* Limpieza del directorio TEMP del usuario.
* Limpieza del directorio TEMP de Windows.
* Limpieza de la caché de Windows Update.
* Vaciado de la papelera de reciclaje.
* Limpieza de la caché DNS.
* Limpieza de cachés temporales de navegadores.
* Limpieza mediante el Liberador de espacio en disco de Windows 7.
* Consulta del espacio disponible en la unidad del sistema.
* Medición del espacio libre antes y después de una limpieza completa.
* Detección automática de permisos de administrador.
* Elevación automática de privilegios mediante UAC.
* Detección de la versión de Windows.
* Verificación de que el programa se está ejecutando en Windows 7.
* Protección contra la ejecución del script desde la carpeta TEMP.
* Restauración del estado original de los servicios de Windows Update y BITS.
* Menú interactivo mediante consola.

## Compatibilidad

Esta edición está diseñada exclusivamente para:

* Windows 7.


El programa detecta la versión del sistema operativo antes de continuar.

Si el sistema no corresponde a Windows 7, el programa finaliza y muestra la versión detectada.

> Esta versión no está destinada a Windows 10 ni Windows 11.

## Requisitos

* Windows 7.
* PowerShell 2.0 o superior.
* Permisos de administrador.
* `cleanmgr.exe` disponible en el sistema.

No requiere conexión a Internet para las tareas de limpieza.

No requiere instalar software adicional.

## Windows 7 y PowerShell

Esta edición está diseñada teniendo en cuenta las características disponibles en Windows 7.

El script utiliza únicamente funciones compatibles con **PowerShell 2.0**, principalmente para:

* Solicitar elevación mediante UAC.
* Consultar el espacio disponible mediante `Get-PSDrive`.

No depende de cmdlets modernos de PowerShell.

## Limpieza completa

La opción **LIMPIEZA COMPLETA** ejecuta las principales tareas de mantenimiento en el siguiente orden:

1. Cierre de navegadores.
2. Limpieza del TEMP del usuario.
3. Limpieza del TEMP de Windows.
4. Limpieza de la caché de Windows Update.
5. Limpieza de cachés de navegadores.
6. Vaciado de la papelera.
7. Limpieza de la caché DNS.
8. Ejecución del Liberador de espacio de Windows.

Antes y después del proceso se mide el espacio libre de la unidad del sistema para mostrar una estimación del espacio liberado.

## Liberador de espacio de Windows

Windows 7 no dispone de:

```cmd
DISM /Online /Cleanup-Image /StartComponentCleanup
```

utilizado en versiones posteriores de Windows.

Por este motivo, esta edición utiliza el **Liberador de espacio en disco (`cleanmgr`)**.

El programa configura automáticamente determinadas categorías de limpieza mediante:

```text
HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\VolumeCaches
```

y posteriormente ejecuta:

```cmd
cleanmgr /sagerun:99
```

Entre las categorías contempladas se encuentran:

* Caché de miniaturas.
* Archivos antiguos de CHKDSK.
* Registros de instalación.
* Archivos temporales de instalación.
* Volcados de memoria de errores del sistema.
* Minivolcados de memoria.
* Informes de errores de Windows.

## Windows Update

La limpieza de Windows Update trabaja sobre:

```text
C:\Windows\SoftwareDistribution\Download
```

Antes de limpiar esta carpeta, el programa comprueba el estado de:

* `wuauserv`
* `BITS`

Los servicios se detienen temporalmente durante la limpieza.

Una vez finalizada la operación, se intenta restaurar cada servicio al estado que tenía antes de comenzar.

## Navegadores

La limpieza contempla navegadores basados en Chromium y Firefox.

### Chromium

Se contemplan:

* Google Chrome.
* Microsoft Edge.
* Brave.

Se eliminan las carpetas de caché:

```text
Cache
Code Cache
GPUCache
```

para los perfiles encontrados.

### Mozilla Firefox

Se eliminan las carpetas:

```text
cache2
```

de los perfiles disponibles del usuario actual.

### Internet Explorer

También se utiliza el mecanismo nativo de Windows para limpiar determinados datos temporales de Internet Explorer mediante:

```cmd
RunDll32.exe InetCpl.cpl,ClearMyTracksByProcess 8
```

## Papelera de reciclaje

La opción de papelera elimina la papelera correspondiente a la unidad del sistema:

```text
%SystemDrive%\$Recycle.Bin
```

La operación se realiza para los usuarios de dicha unidad.

**Los archivos eliminados de la papelera no pueden recuperarse mediante la papelera de reciclaje.**

El programa solicita confirmación antes de realizar esta operación desde el menú.

## Seguridad

El programa está diseñado para trabajar sobre archivos temporales, cachés y residuos del sistema.

No está diseñado para eliminar:

* Documentos personales.
* Imágenes.
* Videos.
* Música.
* Archivos personales de Descargas.
* Programas instalados.
* Controladores.

La limpieza de archivos puede omitir archivos que estén siendo utilizados por Windows u otras aplicaciones.

## Protección contra rutas peligrosas

El script utiliza una rutina interna para borrar únicamente el **contenido** de determinadas carpetas.

Antes de realizar la operación se comprueba que la ruta:

* No esté vacía.
* Exista.
* No corresponda a la raíz de la unidad del sistema.

Esto evita que la rutina de limpieza sea utilizada accidentalmente sobre la raíz de la unidad.

## Protección contra ejecución desde TEMP

El programa comprueba si el archivo `.bat` se está ejecutando desde la carpeta TEMP.

Esto evita situaciones en las que Windows ejecute directamente una copia temporal del archivo, por ejemplo al abrirlo desde determinados archivos comprimidos.

En ese caso, el programa solicita copiar el archivo a otra ubicación y volver a ejecutarlo.

## Menú

```text
[1] LIMPIEZA COMPLETA
[2] Limpiar TEMP del usuario
[3] Limpiar TEMP de Windows
[4] Limpiar Windows Update
[5] Vaciar papelera
[6] Limpiar cache DNS
[7] Limpiar cache de navegadores
[8] Liberador de espacio de Windows
[9] Ver espacio disponible
[0] Salir
```

## Uso

1. Descargar `Windows-Cleaner.bat`.
2. Guardar el archivo en una carpeta permanente.
3. Ejecutar el archivo.
4. Aceptar la solicitud de permisos de administrador.
5. Seleccionar la tarea deseada.

Para realizar el mantenimiento general del equipo:

```text
[1] LIMPIEZA COMPLETA
```

## Limitaciones

Esta versión está específicamente adaptada a Windows 7.

No utiliza funciones modernas de Windows 10/11 como:

```cmd
DISM /Online /Cleanup-Image /StartComponentCleanup
```

Por este motivo, la limpieza de componentes se realiza mediante las herramientas disponibles en Windows 7.

## Historial de versiones

### v1.1.0

* Adaptación específica para Windows 7.
* Compatibilidad con Windows 7 x86 y x64.
* Compatibilidad con Windows 7 sin Service Pack 1.
* Detección de versión de Windows.
* Protección contra ejecución desde TEMP.
* Reemplazo de DISM por el Liberador de espacio de Windows.
* Limpieza mediante `cleanmgr /sagerun`.
* Restauración del estado original de Windows Update y BITS.
* Mejoras en la limpieza de cachés de navegadores.
* Soporte para Chrome, Edge, Brave y Firefox.
* Inclusión de limpieza de Internet Explorer.
* Protección de rutas en la rutina de eliminación.
* Mejoras en la medición del espacio liberado.
* Mejoras generales del proceso de mantenimiento.

### v1.0.0

Primera versión estable de TerminalFix Windows Cleaner.

* Limpieza de archivos temporales.
* Limpieza de Windows Update.
* Limpieza de cachés de navegadores.
* Vaciado de papelera.
* Limpieza DNS.
* Limpieza de componentes mediante DISM.
* Medición del espacio disponible.
* Menú interactivo.

## Licencia

Este proyecto se distribuye bajo la licencia indicada en el archivo `LICENSE` del repositorio.

## Autor

**TerminalFix**

Herramientas y proyectos orientados al mantenimiento, administración y soporte técnico de sistemas informáticos.

---

**TerminalFix Windows Cleaner v1.1.0**
