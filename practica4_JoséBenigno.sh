#!/bin/bash

# Comprobación de se o usuario é root
if [ "$(id -u)" -ne 0 ]; then
    echo "Este script debe executarse polo usuario root."
    exit 1
fi

# Creación de arrays a partir do ficheiro
while IFS=: read -r paquete accion; do
  paquetes+=("$paquete")
  accions+=("$accion")
done < "paquetes.txt"

# Procesar cada paquete no array
  for i in ${!paquetes[@]}; do

# Comprobar se o paquete está instalado
    instalado=$(whereis ${paquetes[$i]} | grep bin | wc -l)

    case "${accions[$i]}" in
        "remove" | "r")
            if [ "$instalado" -eq 1 ]; then
                echo "Desinstalando ${paquetes[$i]}..."
                apt remove -y ${paquetes[$i]}
            else
                echo "${paquetes[$i]} non está instalado."
            fi
            ;;
        "add" | "a")
            if [ "$instalado" -eq 0 ]; then
                echo "Instalando ${paquetes[$i]}..."
                apt install -y ${paquetes[$i]}
            else
                echo "${paquetes[$i]} xa está instalado."
            fi
            ;;
        "status" | "s")
            if [ "$instalado" -eq 1 ]; then
                echo "${paquetes[$i]} está instalado."
            else
                echo "${paquetes[$i]} non está instalado."
            fi
            ;;
        *)
            echo "Acción non permitida."
            ;;
    esac
done
