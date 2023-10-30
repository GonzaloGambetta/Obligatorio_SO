#!/bin/bash

nombresMascotas=()
edadesMascotas=()
numSocio=0

registroSocio(){
    echo "Ingrese nombre del dueño"
    read nomOwner

    echo "Ingrese cedula sin puntos ni guiones"
    read ciOwner

    aux=0
    while [ "$aux" -eq 0 ]
    do
        ciSocios=$(cut -d',' -f 2 socios.txt)
        grep -q -w "$ciOwner" <<< "$(printf "%s\n" "${ciSocios[@]}")"
        existe=$?
        if ! [[ "$ciOwner" =~ ^[1-6000000]+$ ]]
        then
            echo "Ingrese una cédula válida"
            echo "Ingrese cedula sin puntos ni guiones"
            read ciOwner
        elif [ "$existe" -eq 0 ]
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

    for ((i=0; i<$cantMascotas; i++))
    do  
        echo "Ingrese nombre de mascota"
        read nomMascota
        while [ -z "${nomMascota}" ] || [[ "$nomMascota" =~ [^a-zA-Z] ]]
        do
            echo "Ingrese un nombre válido"
            read nomMascota
        done

        echo "Ingrese edad de la mascota"
        read edadMascota
        while ! [[ "$edadMascota" =~ ^[0-9]+$ ]] || [ "$edadMascota" -lt 0 ] || [ "$edadMascota" -gt 100 ]
        do
            echo "Ingrese una edad de mascota válida (entre 0 y 100)"
            read edadMascota
        done

        if [ $i -eq 0 ]
        then
            nombresMascotas[numSocio]=$nomMascota
            edadesMascotas[numSocio]=$edadMascota
        else
            nombresMascotas[numSocio]=${nombresMascotas[numSocio]}","$nomMascota
            edadesMascotas[numSocio]=${edadesMascotas[numSocio]}","$edadMascota
        fi
    done

    echo "Ingrese opción de contacto"
    read contacto

    registro=$nomOwner","$ciOwner","${nombresMascotas[numSocio]}","${edadesMascotas[numSocio]}","$contacto
    echo $registro >> socios.txt

    numSocio=$numSocio+1
}

agendarCita(){
    echo "Ingrese cedula sin puntos ni guiones"
    read ciOwner
    aux=0
    while [ "$aux" -eq 0 ]
    do
        ciSocios=$(cut -d',' -f 2 socios.txt)
        grep -q -w "$ciOwner" <<< "$(printf "%s\n" "${ciSocios[@]}")"
        existe=$?
        if ! [[ "$ciOwner" =~ ^[1-6000000]+$ ]]
        then
            echo "Ingrese una cédula válida"
            echo "Ingrese cedula sin puntos ni guiones"
            read ciOwner
        elif ! [ "$existe" -eq 0 ]
        then
            echo "Usuario no existe"
            echo "Ingrese cedula sin puntos ni guiones"
            read ciOwner

        else
            aux=1
        fi
    done

    echo "Ingrese nombre de mascota"
    read nomMascota
    aux=0
    while [ "$aux" -eq 0 ]
    do
        if [ -z "${nomMascota}" ] || [[ "$nomMascota" =~ [^a-zA-Z] ]]
        then
            echo "Ingrese un nombre válido"
            read nomMascota
        elif ! grep -qw "$ciOwner.*$nomMascota" socios.txt 
        then
            echo "El usuario ingresado no es duena de la mascota"
            read nomMascota
        else
            aux=1
        fi
    done

    exit3=0
    while [ $exit3 -ne -1 ]
    do
        echo "Seleccione el motivo de la cita"
        echo "1. Revisión general"
        echo "2. Vacunación"
        read opcion3

        case $opcion3 in
            1) 
                motivo="revision,1200"
                exit3=-1
                ;;
            2)
                motivo="vacunacion,2000"
                exit3=-1
                ;;
            *)
                echo "Seleccione una de las opciones presentadas"
                ;;
        esac
    done

    echo "Ingrese fecha y hora de la cita en el formato ISO 8601 (YYYY-MM-DDTHH:MM)"
    read fechaHora
     aux=0
    while [ "$aux" -eq 0 ]
    do
        if ! [[ $fechaHora =~ ^[0-9]{4}-[0-9]{2}-[0-9]{2}T[0-9]{2}:[0-9]{2}$ ]]; 
        then
            echo "La fecha y hora de la cita no es válida. Por favor, ingrese la fecha y hora en el formato ISO 8601 (YYYY-MM-DDTHH:MM)"
            read fechaHora
        elif grep -qw "$ciOwner.*$fechaHora" citas.txt
        then
            echo "Ya tiene una cita agendada para ese horario, ingrese uno diferente"
            read fechaHora
        else
            aux=1
        fi
    done
    
    registro=$ciOwner","$nomMascota","$motivo","$fechaHora
    echo $registro >> citas.txt
}

consultarCitas(){
    echo "Ingrese cedula sin puntos ni guiones"
    read ciOwner
    aux=0
    while [ "$aux" -eq 0 ]
    do
        ciSocios=$(cut -d',' -f 2 socios.txt)
        grep -q -w "$ciOwner" <<< "$(printf "%s\n" "${ciSocios[@]}")"
        existe=$?
        if ! [[ "$ciOwner" =~ ^[1-6000000]+$ ]]
        then
            echo "Ingrese una cédula válida"
            echo "Ingrese cedula sin puntos ni guiones"
            read ciOwner
        elif ! [ "$existe" -eq 0 ]
        then
            echo "Usuario no existe"
            echo "Ingrese cedula sin puntos ni guiones"
            read ciOwner

        else
            aux=1
        fi
    done

    if grep -qw "$ciOwner" citas.txt
    then
        grep "$ciOwner" citas.txt
    else
        echo "El usuario no tiene citas pendientes"
    fi

}

eliminarCita(){
    echo "Ingrese cedula sin puntos ni guiones"
    read ciOwner
    aux=0
    while [ "$aux" -eq 0 ]
    do
        ciSocios=$(cut -d',' -f 2 socios.txt)
        grep -q -w "$ciOwner" <<< "$(printf "%s\n" "${ciSocios[@]}")"
        existe=$?
        if ! [[ "$ciOwner" =~ ^[1-6000000]+$ ]]
        then
            echo "Ingrese una cédula válida"
            echo "Ingrese cedula sin puntos ni guiones"
            read ciOwner
        elif ! [ "$existe" -eq 0 ]
        then
            echo "Usuario no existe"
            echo "Ingrese cedula sin puntos ni guiones"
            read ciOwner

        else
            aux=1
        fi
    done

    if grep -qw "$ciOwner" citas.txt
    then
        grep "$ciOwner" citas.txt
        echo "Ingrese horario de cita a eliminar"
    else
        echo "El usuario no tiene citas pendientes"
    fi
}

manejoCitas(){
    exit2=0
    while [ $exit2 -ne -1 ]
    do
        echo "Seleccione una opción"
        echo "1. Agendar una nueva cita"
        echo "2. Consultar citas pendientes"
        echo "3. Eliminar una cita programada"
        echo "4. Salir"
        read opcion2

        case $opcion2 in
            1) 
                echo "Agendar una nueva cita"
                agendarCita
                ;;
            2)
                echo "Consultar citas pendientes"
                consultarCitas
                ;;
            3)
                echo "Eliminar una cita programada"
                eliminarCita
                ;;
            4)
                echo "Salir"
                exit2=-1
                ;;
            *)
                echo "Seleccione una de las opciones presentadas"
                ;;
        esac
    done
}

exit=0
while [ $exit -ne -1 ] 
do
    echo "Seleccione una opción"
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
            registroSocio
            ;;
        2)
            echo "Manejo de citas"
            manejoCitas
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

