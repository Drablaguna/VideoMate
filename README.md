# VideoMate ver 0.1

Herramienta de consola de comandos para descargar videos de cualquier red social de manera efectiva y rápida, ingresando los links a descargar en un archivo de texto.

## Próximas Actualizaciones
- Agregar traducción a Inglés
- Optimizar el manejo de dependencias en la version de Windows

## Instalación

### Windows

1. Copiar y pegar folder completo en una ubicación fija en la computadora
1. Descargar `ffmpeg` de https://www.ffmpeg.org/download.html y seguir sus instrucciones de instalación
1. Agregar el folder descargado de `ffmpeg` dentro del folder `.\VideoMate\WINDOWS\NO_TOCAR`
2. Agregar `ffmpeg\bin` a Path en variables de entorno
    - Windows > Editar las variables de entorno > Variables de entorno > Variables del sistema > Seleccionar Path > Editar > Nueva > Agregar la ruta completa de `ffmpeg\bin` por ejemplo: `C:\Users\Usuario\Escritorio\VideoMate\Windows\NO_TOCAR\ffmpeg\bin`
3.  Modificar propiedades del acceso directo de VideoMate > Atajo > Actualizar el valor de Start In o Comenzar en con la ruta en el sistema host por ejemplo: `C:\Users\Usuario\Desktop\VideoMate\WINDOWS`

### Mac

1. Copiar y pegar folder completo en una ubicación fija en la computadora
2. Instalar Homebrew (solo si aún no ha sido instalado) pegando y ejecutando el siguiente código en la consola `/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"`  y esperar a que se instale 
3. Instalar `ffmpeg` pegando y ejecutando el siguiente comando en la consola `brew install ffmpeg`
4. Instalar `yt-dlp` pegando y ejecutando el siguiente comando en la consola `brew install yt-dlp`

## Uso

### Windows

1. Abrir el archivo `links.txt` y pegar los links de los archivos a extraer separados línea por línea, guardar y cerrar el archivo
1. Hacer doble clic en el acceso directo configurado en la instalación para ejecutar VideoMate o ejecutar el archivo `VideoMateWindowsCore.ps1` en una terminal de PowerShell
1. Ingresar un nombre para los videos (a partir de el se generará un contador para nombrar todos los videos)
1. Una vez finalizada la ejecución, encontrarás los videos en el folder `/OUT`

### Mac

1. Abrir el archivo `links.txt` y pegar los links de los archivos a extraer separados línea por línea, guardar y cerrar el archivo
1. Abrir una terminal y dirigirse al folder de `/MAC`
1. Ingresar el siguiente comando: `sh VideoMateMac.sh`
    - Si el comando falla es porque la terminal no se encuentra donde reside el archivo
1. Ingresar un nombre para los videos (a partir de el se generará un contador para nombrar todos los videos)
1. Una vez finalizada la ejecución, encontrarás los videos en el folder `/OUT`