#!/bin/bash

# Directorio a monitorear
dir="/home/charlie/Lab-2"

# Monitorear cambios en el directorio usando inotifywait que es una herramienta de inotify-tool que monitorea el sistema de ardhivos. -m es modo monitoreo y -r es para que sea en bucle. -e create,delete,modify indica los tipos de eventos que monitorea
inotifywait -m -r -e create,delete,modify $dir | while read evento; do
    echo "$(date +"%Y-%m-%d %H:%M:%S") - $evento" >> /home/charlie/Lab-2/monitoreo_directorio.log
done
# El pipe hace que el while read evento se ejcute justo despues del inotifywait, este lo que hace es leer cada salida del inotifywait. El echo crea una linea dentro del 
