#!/bin/bash

# Redirige stderr a /dev/null para ocultar los errores de MESA
exec 2>/dev/null
# Ruta en WSL de la carpeta que vamos a crear y respaldar
carpeta_origen="$HOME/Documentos/CopiaZenity"

# Crear la carpeta si no existe
if [ ! -d "$carpeta_origen" ]; then
    mkdir -p "$carpeta_origen"
    echo "Carpeta creada: $carpeta_origen"
    # Opcional: crear un archivo de ejemplo para demostrar
    echo "Archivo de ejemplo" > "$carpeta_origen/ejemplo.txt"
fi

# Mostrar mensaje con Zenity informando que la carpeta origen fue creada o ya existe
zenity --info --text="Se utilizará como origen: $carpeta_origen\nPuedes añadir archivos ahí antes de hacer la copia."

# Seleccionar carpeta de destino (con Zenity)
destino=$(zenity --file-selection --directory --title="Selecciona la carpeta donde guardar la copia")

if [ -z "$destino" ]; then
    zenity --error --text="No se seleccionó carpeta de destino"
    exit 1
fi

# Nombre del archivo de copia con fecha
fecha=$(date +%Y-%m-%d_%H-%M-%S)
nombre_respaldo="respaldo_$(basename "$carpeta_origen")_$fecha.tar.gz"

# Realizar la copia de seguridad
tar -czf "$destino/$nombre_respaldo" -C "$(dirname "$carpeta_origen")" "$(basename "$carpeta_origen")"

# Confirmación final
if [ $? -eq 0 ]; then
    zenity --info --text="Copia de seguridad creada con éxito:\n$destino/$nombre_respaldo"
else
    zenity --error --text="Ocurrió un error al crear la copia de seguridad"
fi
