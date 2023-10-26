#!/bin/bash

function1(){
    echo "Ingrese nombre del dueño"
    read nomOwner

    echo "Ingrese cedula sin puntos ni guiones"
    read ciOwner

    aux=0
    #while ! [[ "$ciOwner" =~ ^[1-6000000]+$ ]] || grep -q "$ciOwner" socios.txt
    while [ "$aux" -eq 0 ]
    do
        ciSocios=$(cut -d',' -f 2 socios.txt)
        if ! [[ "$ciOwner" =~ ^[1-6000000]+$ ]]
        then
            echo "Ingrese una cédula válida"
            echo "Ingrese cedula sin puntos ni guiones"
            read ciOwner
        elif grep -q -w "$ciOwner" "$ciSocios"

        then
            echo "Usuario ya fue ingresado"
            echo "Ingrese cedula sin puntos ni guiones"
            read ciOwner

        else
            aux=1
        fi
    done

    cantMascotas=0
    while ! [[ "$cantMascotas" =~ ^[0-9]+$ ]] || [ "$cantMascotas" -lt 1 ] || [ "$cantMascotas" -gt 4 ]
    do
        echo "Cantidad de mascotas a ingresar"
        read cantMascotas
        if ! [[ "$cantMascotas" =~ ^[0-9]+$ ]] || [ "$cantMascotas" -lt 1 ] || [ "$cantMascotas" -gt 4 ]
        then
            echo "La cantidad de mascotas debe ser un entero entre 1 y 4"
        fi
    done

    nombresMascotas=()
    edadesMascotas=()
    for ((i=0; i<$cantMascotas; i++))
    do  
        echo "Ingrese nombre de mascota"
        read nomMascotas
        echo "Ingrese edad de la mascota"
        read edadMascota

        nombresMascotas[$i]=$nomMascotas
        edadesMascotas[$i]=$edadMascota
    done

    echo "Ingrese opción de contacto"
    read contacto

    registro=$nomOwner","$ciOwner
    for ((i=0; i<4; i++))
    do  
        registro=$registro","${nombresMascotas[$i]}","${edadesMascotas[$i]}
    done
    registro=$registro","$contacto

    echo $registro >> socios.txt

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

