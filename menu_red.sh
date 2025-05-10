#!/bin/bash

while true; do
        opcion=4;
        opcion=$(zenity --list --title="🖥 Menú de funcionalidades de red"  \
        --column="Opción" --column="Descripción" \
        1 "Mostrar dirección IP" \
        2 "Medir velocidad de red" \
        3 "Verificar conectividad a Internet" \
        4 "Salir" \
        --width=400 --height=400)

    case $opcion in
        1)
            ip_addr=$(hostname -I | awk '{print $1}')
            zenity --info --title="Dirección IP" --text="Tu dirección IP es: $ip_addr"
            ;;
        2)
            if ! command -v speedtest-cli &> /dev/null; then
                zenity --error --title="Error" --text="speedtest-cli no está instalado. Instálalo con:\nsudo apt install speedtest-cli"
            else
                speed_output=$(speedtest-cli --simple)
                zenity --info --title="Velocidad de red" --text="$speed_output"
            fi
            ;;
        3)
            if ping -c 1 8.8.8.8 &> /dev/null; then
                zenity --info --title="Conectividad" --text="¡Tienes conexión a Internet!"
            else
                zenity --error --title="Conectividad" --text="No hay conexión a Internet."
            fi
            ;;
        *)
            break
            ;;
    esac
done
