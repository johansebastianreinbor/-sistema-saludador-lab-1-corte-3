# Sistema Saludador

Prototipo de aplicación de escritorio construido con Java y JavaFX.

## Requisitos y ejecución

En Windows, con el JDK instalado, puedes iniciar directamente desde PowerShell:

```powershell
powershell -ExecutionPolicy Bypass -File .\iniciar.ps1
```

El script utiliza Maven si está instalado; de lo contrario lo descarga en `%LOCALAPPDATA%\SistemaSaludador\tools`. La primera ejecución requiere conexión a Internet para descargar Maven y JavaFX.

Para ejecutar con Maven manualmente:

- JDK 17 o superior (con `JAVA_HOME` apuntando al JDK).
- Apache Maven 3.9 o superior, disponible como `mvn`.

Desde la carpeta del proyecto:

```powershell
mvn clean javafx:run
```

Maven descarga las dependencias de JavaFX automáticamente. Para compilar sin abrir la ventana:

```powershell
mvn clean package
```

## Caso de uso: Solicitar saludo

1. Pulsa **Solicitar saludo**.
2. En la misma ventana, ingresa nombre y edad; selecciona hora (1–12), minutos (0–59) y AM/PM.
3. Pulsa **Aceptar** para recibir el saludo con tu nombre y edad.

El nombre es obligatorio y la edad debe ser un número entero entre 0 y 120. Los errores se muestran en el formulario. Puedes modificar los datos y volver a aceptar.

Se interpreta la hora ingresada de esta manera: buenos días de 6:00 AM a 11:59 AM, buenas tardes de 12:00 PM a 5:59 PM y buenas noches de 6:00 PM a 5:59 AM. Las 12 AM corresponden a medianoche y las 12 PM a mediodía.

El prototipo no guarda los datos ni requiere una base de datos.

## Build de Windows (.exe)

```powershell
powershell -ExecutionPolicy Bypass -File .\build.ps1
```

Genera `dist/SistemaSaludador/SistemaSaludador.exe` y `dist/SistemaSaludador-Windows.zip`. Es una aplicación portable que incluye Java y JavaFX: el destinatario no necesita instalarlos. Para compartirla, envía el ZIP completo y pide extraerlo antes de abrir el ejecutable. El `.exe` necesita las carpetas `app` y `runtime` que lo acompañan.

Para generar otro build sin reemplazar el anterior, usa `-OutputDirectory dist-v2`. El script requiere un JDK con `jpackage` y descarga Maven si hace falta. No necesita WiX porque genera una aplicación portable, sin instalador.

## Diagramas

Abre `docs/SistemaSaludador.drawio` con draw.io o diagrams.net. Contiene dos páginas editables: **Caso de uso** y **Flujo Solicitar saludo**, incluyendo validación y saludo según la hora.
