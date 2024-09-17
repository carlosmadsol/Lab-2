#!/bin/bash

# Verificamos que se haya agregado bien el argumento, aqui nos aseguramos que no se pasen menos de 2 argumentos usando la variable -lt
if [ $# -lt 2 ]; then
    echo "Uso: $0 <nombre_proceso> <comando_para_ejecutar>"
    exit 1
fi

nombre_proceso=$1
comando_ejecutar=$2

# Usando el comando while, nos aseguramos de que se monitoree en el proceso de manera continua e infinita
while true; do

    # Monitoreamos el proceso, usando pgrep que busca si algun proceso en ejecucion coincide con el nombre asignado en nombre_proceso 
    pgrep $nombre_proceso > /dev/null

    # Si el codigo de salida obtenido y guardado en la variable $? es diferente de 0 entonces se corre el $2 que esta definido en comando_ejecutar y se corre en segundo plano para no interferir con el script
    if [ $? -ne 0 ]; then
        echo "El proceso $nombre_proceso no está corriendo. Reiniciando..."
        $comando_ejecutar &
    fi
    # Esperar 30  segundos antes de revisar de nuevo y asi no sea muy pesado con la cpu
    sleep 30
done

