#!/bin/bash
exec 2>/dev/null

while true; do
        opcion=$(zenity --list --title="👤 Menú principal" \
        --column="Opción" --column="Descripción" \
        1 "👥 Administracion de usuarios" \
        2 "🖥 Funcionalidades de red"  \
        3 "🔥 Firewall" \
        4 "❌ Salir" \
        --width=500 --height=300)

    case $opcion in
        1) ./Administracion_usuarios.sh ;;
        2) ./menu_red.sh ;;
        3) ./Firewall.sh ;;
        *) exit 0 ;;
    esac
done
