# TerminalFix Windows Cleaner

Herramienta de mantenimiento para Windows desarrollada por **TerminalFix** mediante Batch.

El programa permite realizar diferentes tareas de limpieza y mantenimiento del sistema desde una interfaz sencilla en consola, sin necesidad de instalar software adicional.

## Versión

**v1.0**

Primera versión del TerminalFix Windows Cleaner.

## Características

El programa incluye las siguientes funciones:

* Limpieza del directorio TEMP del usuario.
* Limpieza del directorio TEMP de Windows.
* Limpieza de la caché de Windows Update.
* Vaciado de la papelera de reciclaje.
* Limpieza de la caché DNS.
* Limpieza de cachés temporales de navegadores.
* Limpieza de componentes antiguos de Windows mediante DISM.
* Consulta del espacio disponible en la unidad C:.
* Medición del espacio libre antes y después de una limpieza completa.
* Detección automática de permisos de administrador.
* Elevación automática de privilegios mediante UAC.
* Menú interactivo mediante consola.

## Navegadores compatibles

La limpieza de caché contempla actualmente:

* Google Chrome
* Microsoft Edge
* Mozilla Firefox
* Brave

El programa puede cerrar automáticamente estos navegadores antes de realizar la limpieza.

## Limpieza completa

La opción **LIMPIEZA COMPLETA** ejecuta las principales tareas de mantenimiento en el siguiente orden:

1. Cierre de navegadores.
2. Limpieza del TEMP del usuario.
3. Limpieza del TEMP de Windows.
4. Limpieza de la caché de Windows Update.
5. Limpieza de cachés de navegadores.
6. Vaciado de la papelera.
7. Limpieza de la caché DNS.
8. Limpieza de componentes de Windows mediante DISM.

Además, se registra el espacio libre disponible antes y después del proceso para calcular aproximadamente cuánto espacio fue liberado.

## Seguridad

El programa está diseñado para eliminar archivos temporales y cachés del sistema.

No está destinado a eliminar:

* Documentos personales.
* Imágenes.
* Videos.
* Música.
* Archivos de Descargas personales.
* Programas instalados.
* Controladores.

Algunas operaciones requieren permisos de administrador.

### Windows Update

La limpieza de Windows Update detiene temporalmente los servicios:

* `wuauserv`
* `BITS`

Luego elimina el contenido descargado de:

```text
C:\Windows\SoftwareDistribution\Download
```

y posteriormente vuelve a iniciar los servicios.

### DISM

La limpieza de componentes utiliza:

```cmd
DISM /Online /Cleanup-Image /StartComponentCleanup
```

Esta operación puede tardar varios minutos dependiendo del equipo y del estado del sistema.

## Requisitos

* Windows con soporte para los comandos utilizados por el programa.
* Permisos de administrador.
* PowerShell disponible.
* Conexión a Internet no requerida para las tareas de limpieza.

## Uso

1. Descargar `Windows-Cleaner.bat`.
2. Ejecutar el archivo.
3. Aceptar la solicitud de permisos de administrador.
4. Seleccionar una opción del menú.

Para realizar el mantenimiento general del equipo, seleccionar:

```text
[1] LIMPIEZA COMPLETA
```

## Menú

```text
[1] LIMPIEZA COMPLETA
[2] Limpiar TEMP del usuario
[3] Limpiar TEMP de Windows
[4] Limpiar Windows Update
[5] Vaciar papelera
[6] Limpiar cache DNS
[7] Limpiar cache temporal de navegadores
[8] Limpieza de componentes DISM
[9] Ver espacio disponible
[0] Salir
```

## Licencia

Este proyecto se distribuye bajo la licencia indicada en el archivo `LICENSE` del repositorio.

## Autor

**TerminalFix**

Herramientas y proyectos orientados al mantenimiento, administración y soporte técnico de sistemas informáticos.

---

**TerminalFix Windows Cleaner v1.0**
