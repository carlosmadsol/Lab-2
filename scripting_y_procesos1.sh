#!/bin/bash

# Verificar si se ingresó el PID usando -z para verificar que no sea un espacio vacioy el <PID> le confirma a la terminal que ocupamos un PID
if [ -z "$1" ]; then
    echo "Uso: $0 <PID>"
    exit 1
fi

PID=$1

# Obtenemos la informacion de cada una de las partes del proceso, usamos el comando ps (que da info sobre los procesos en ejecucion) con el -o que especifica lo que se muestra del ps

nombre=$(ps -p $PID -o comm=)
usuario=$(ps -p $PID -o user=)
cpu=$(ps -p $PID -o %cpu=)
memoria=$(ps -p $PID -o %mem=)
estado=$(ps -p $PID -o stat=)
ppid=$(ps -p $PID -o ppid=)

#readlink -f nos da el path COMPLETO de un link simbolico y usamos el siguiente link simbolico "/proc/$PID/exe" para obtener la informacion del proceso gracias el /proc/ 

path=$(readlink -f /proc/$PID/exe)

# Mostrar la información
echo "Nombre del proceso: $nombre"
echo "ID del proceso: $PID"
echo "Parent Process ID: $ppid"
echo "Usuario propietario: $usuario"
echo "Porcentaje de uso de CPU: $cpu%"
echo "Consumo de memoria: $memoria%"
echo "Estado: $estado"
echo "Path del ejecutable: $path"
