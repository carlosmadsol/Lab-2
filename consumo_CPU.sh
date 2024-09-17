#!/bin/bash

# Verificar si se ingresó el ejecutable
if [ -z "$1" ]; then
    echo "Uso: $0 <ruta_al_ejecutable>"
    exit 1
fi

ejecutable=$1

# Logfile es el archivo donde guardaremos el consumo tanto de CPU como de Memoria, el touch es para crearlo si no existe
logfile="log_consumo.txt"
touch $logfile

# Ejecutamos el proceso
$ejecutable &

# Almacenamos el PID del prcoeso en pid
pid=$!

# Nos aseguramos con el while ps que el proceso se sigue ejecutando
while ps -p $pid > /dev/null; do

# Obtenemos los datos para el monitoreo, usamos el ps -p $pid para indicar que es informacion obtenida de la variable antes asignada como pid, ademas usamos -o %cpu= para indicar especificamente que queremos el %cpu y el = al final para eliminar la primera linea y obtener solo el numero de porcentaje. Copiamos igual para la memoria	
    cpu=$(ps -p $pid -o %cpu=)
    memoria=$(ps -p $pid -o %mem=)

# Creamos la variable tiempo a la que le asignamos el dia y hora exacta que se muestran de la siguiente forma: dia-mes-ano y despues hora-minuto-segundo
    tiempo=$(date +"%d-%m-%Y %H:%M:%S")

# Redirigimos usando >> el echo $tiempo CPU: $cpu% MEM: $memoria%, que se convertira en texto conteniendo el tiempo, en el archivo logfile que contiene log_consumo.txt
    echo "$tiempo CPU: $cpu% MEM: $memoria%" >> $logfile
    sleep 5
done

# Graficar los resultados, el -e en gnuplot hace que todo lo que este entre "" se ejecute como comandos de gnuplot
gnuplot -e "
    set terminal dumb;
    set title 'Consumo de CPU y Memoria';
    set xlabel 'Tiempo';
    set ylabel 'Porcentaje';
    set xdata time;
    set timefmt '%d-%m-%Y %H:%M:%S';
    set format x '%H:%M:%S';
    plot '$logfile' using 1:3 with lines title 'CPU', \
         '$logfile' using 1:5 with lines title 'Memoria';
"
# Primero usamos terminal dumb para que el grafico se genere en la terminal, despues nombramos cada parte del grafico con los demas sets como set ylabel que le da el nombre de Porcentaje a la variable y definimos el formato de salida del tiempo
# Plot es el que genera el grafico y especificamos que lo genere del logfile, 1:3 especifica que la columna 1 vaya en el eje x y la columna 3 en el y (tiempo y valores de CPU respectivamente), with lines especifica que con lineas en lugar de barras u otros formatos y de titulo CPU. Hacemos lo mismo con el grafico de memoria solo qu ahora toma la columna 5 en lugar de la 3 ya que es la que contiene la memoria 
