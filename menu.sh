#!/bin/bash
exec 2>/dev/null

while true; do
        opcion=$(zenity --list --title="👤 Menú principal" \
        --column="Opción" --column="Descripción" \
        1 "👥 Administracion de usuarios" \
        2 "🖥 Funcionalidades de red"  \
        3 "🔥 Firewall" \
        4 "📧 Enviar Correo" \
        5 "❌ Salir" \
        --width=400 --height=400)

    case $opcion in
        1) ./gestion_usuarios.sh ;;
        2) ./menu_red.sh ;;
        3) ./firewall.sh ;;
        4) ./enviar_formulario_correo.sh ;;
        5) ./gestion_usuarios.sh ;;
        *) exit 0 ;;
    esac
done
