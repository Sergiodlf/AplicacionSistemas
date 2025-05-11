#!/bin/bash

destino=$(zenity --entry --title="Correo destino" --text="Introduce el correo del destinatario:")
if [ -z "$destino" ]; then
    zenity --error --text="No ingresaste ningún correo."
    exit 1
fi

asunto=$(zenity --entry --title="Asunto" --text="Introduce el asunto del correo:")
if [ -z "$asunto" ]; then
    zenity --error --text="No ingresaste ningún asunto."
    exit 1
fi

mensaje=$(zenity --text-info --editable --title="Mensaje" --width=400 --height=300 --text="Escribe tu mensaje aquí.")
if [ -z "$mensaje" ]; then
    zenity --error --text="No ingresaste ningún mensaje."
    exit 1
fi

resultado=$(python3 sendmail.py "$destino" "$asunto" "$mensaje" 2>&1)

if [[ "$resultado" == *"Correo enviado correctamente."* ]]; then
    zenity --info --text="Correo enviado correctamente a $destino"
else
    zenity --error --text="Error al enviar el correo:\n$resultado"
fi




