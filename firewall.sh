#!/bin/bash

# Función para mostrar errores y también imprimirlos en la terminal
mostrar_error() {
    mensaje="$1"
    echo "ERROR: $mensaje"
    zenity --error --title="Error" --text="$mensaje"
    bash "$0"  # Volver al menú del firewall
    exit 1
}

# Verifica si ufw está instalado
if ! command -v ufw &> /dev/null; then
    zenity --question --title="Instalación requerida" --text="El firewall UFW no está instalado. ¿Deseas instalarlo?" --ok-label="Sí" --cancel-label="No"
    if [ $? -eq 0 ]; then
        (
            echo "10"; sleep 0.5
            echo "# Actualizando repositorios..."; sleep 0.5
            sudo apt-get update &>/dev/null
            echo "50"; sleep 0.5
            echo "# Instalando UFW..."; sleep 0.5
            sudo apt-get install ufw -y &>/dev/null
            echo "100"
        ) | zenity --progress --title="Instalando Firewall" --text="Procesando..." --percentage=0 --auto-close

        if [ $? -ne 0 ]; then
            mostrar_error "No se pudo instalar ufw. Verifica tu conexión o permisos."
        fi
    else
        ./menu.sh
        exit 0
    fi
fi

# Función para mostrar el menú del firewall
mostrar_menu_firewall() {
    while true; do
        opcion=$(zenity --list --title="Gestor de Firewall" --text="Selecciona una acción:" \
        --column="Acción" "Activar Firewall" "Desactivar Firewall" "Desinstalar Firewall" "Volver")

        case "$opcion" in
            "Activar Firewall")
                sudo ufw enable
                if [ $? -eq 0 ]; then
                    zenity --info --title="Firewall" --text="Firewall activado correctamente."
                else
                    mostrar_error "No se pudo activar el firewall."
                fi
                ;;
            "Desactivar Firewall")
                sudo ufw disable
                if [ $? -eq 0 ]; then
                    zenity --info --title="Firewall" --text="Firewall desactivado correctamente."
                else
                    mostrar_error "No se pudo desactivar el firewall."
                fi
                ;;
            "Desinstalar Firewall")
                zenity --question --title="Confirmar desinstalación" --text="¿Estás seguro de que deseas desinstalar el firewall (ufw)?" --ok-label="Sí" --cancel-label="No"
                if [ $? -eq 0 ]; then
                    (
                        echo "10"; sleep 0.5
                        echo "# Desinstalando UFW..."; sleep 0.5
                        sudo apt-get remove --purge ufw -y &>/dev/null
                        echo "100"
                    ) | zenity --progress --title="Desinstalando Firewall" --text="Procesando..." --percentage=0 --auto-close

                    if [ $? -ne 0 ]; then
                        mostrar_error "No se pudo desinstalar el firewall."
                    fi

                    zenity --info --title="Firewall" --text="Firewall desinstalado correctamente."
                    ./menu.sh
                    exit 0
                fi
                ;;
            "Volver")
                ./menu.sh
                exit 0
                ;;
            *)
                ./menu.sh
                exit 0
                ;;
        esac
    done
}

# Ejecuta el menú
mostrar_menu_firewall

