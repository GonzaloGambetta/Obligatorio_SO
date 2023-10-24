#!/bin/bash

function1(){
    echo "Ingrese nombre del dueño"
    read nomOwner

    echo "Ingrese cedula"
    read ciOwner

    echo "Cantidad de mascotas a ingresar"
    read cantMascotas

    for ((i=0; i<$cantMascotas; i++))
    do  
        echo "Ingrese nombre de mascota"
        read nomMascotas
        echo "Ingrese edad de la mascota"
        read edadMascota

        nombresMascotas[$i]=nomMascotas
        edadesMascotas[$i]=edadMascota
        echo "${nombreMascotas[$i]}"
        echo "${edadesMascotas[$i]}"
    done

}



exit=0

while [ $exit -ne -1 ] 
do
    echo "Seleccione una opcion"
    echo "1. Registro de socio"
    echo "2. Manejo de citas"
    echo "3. Actualizar stock en tienda"
    echo "4. Venta de productos"
    echo "5. Informe mensual"
    echo "6. Salir"
    read opcion

    case $opcion in 
        1)
            echo "Registro de socio"
            function1
            ;;
        2)
            echo "Manejo de citas"
            ;;
        3) 
            echo "Actualizar stock en tienda"            
            ;;
        4)
            echo "Venta de productos"            
            ;;
        5) 
            echo "Informe sensual"           
            ;;
        6)
            echo "Salir"
            exit=-1
            ;;
        *)
            echo "Seleccione una de las opciones presentadas"
            ;;
    esac
done