#!/bin/bash

# Verificar si el script se ejecuta como root
if [[ $EUID -ne 0 ]]; then
  zenity --error --center --text="Este script debe ejecutarse como root."
  exit 1
fi

function crear_usuario() {
  username=$(zenity --entry --center --title="Crear Usuario" --text="Nombre del nuevo usuario:")
  [[ -z "$username" ]] && return

  if id "$username" &>/dev/null; then
    zenity --error --center --text="El usuario ya existe."
    return
  fi

  password=$(zenity --password --center --title="Contraseña para $username")
  [[ -z "$password" ]] && return

  useradd -m "$username"
  echo "$username:$password" | chpasswd
  zenity --info --center --text="Usuario $username creado correctamente."
}

function eliminar_usuario() {
  username=$(zenity --entry --center --title="Eliminar Usuario" --text="Nombre del usuario a eliminar:")
  [[ -z "$username" ]] && return

  if id "$username" &>/dev/null; then
    zenity --question --center --title="Eliminar Home" --text="¿Eliminar también el directorio home del usuario?" --ok-label="Sí" --cancel-label="No"
    if [[ $? -eq 0 ]]; then
      userdel -r "$username"
    else
      userdel "$username"
    fi
    zenity --info --center --text="Usuario $username eliminado."
  else
    zenity --error --center --text="El usuario no existe."
  fi
}

function editar_usuario() {
  username=$(zenity --entry --center --title="Editar Usuario" --text="Nombre del usuario a editar:")
  [[ -z "$username" ]] && return

  if ! id "$username" &>/dev/null; then
    zenity --error --center --text="El usuario no existe."
    return
  fi

  opcion=$(zenity --list --center --title="Editar Usuario" --text="¿Qué deseas editar?" \
    --column="Opción" --column="Acción" \
    1 "Cambiar nombre de usuario" \
    2 "Cambiar contraseña" \
    --width=400 --height=200)

  case $opcion in
    1)
      nuevo_nombre=$(zenity --entry --center --title="Nuevo Nombre" --text="Introduce el nuevo nombre de usuario:")
      [[ -z "$nuevo_nombre" ]] && return
      usermod -l "$nuevo_nombre" "$username"
      usermod -d "/home/$nuevo_nombre" -m "$nuevo_nombre"
      zenity --info --center --text="Nombre de usuario cambiado a $nuevo_nombre."
      ;;
    2)
      nueva_pass=$(zenity --password --center --title="Nueva Contraseña")
      [[ -z "$nueva_pass" ]] && return
      echo "$username:$nueva_pass" | chpasswd
      zenity --info --center --text="Contraseña cambiada correctamente."
      ;;
    *)
      return
      ;;
  esac
}

function listar_usuarios() {
  usuarios=$(cut -d: -f1 /etc/passwd | sort)
  zenity --text-info --center --title="Lista de Usuarios" --width=400 --height=400 --filename=<(echo "$usuarios")
}

# Menú principal
while true; do
  opcion=$(zenity --list --center --title="Gestión de Usuarios" \
    --text="Seleccione una opción:" \
    --column="Acción" \
    "Crear Usuario" "Eliminar Usuario" "Editar Usuario" "Listar Usuarios" "Salir" \
    --width=400 --height=300)

  case $opcion in
    "Crear Usuario") crear_usuario ;;
    "Eliminar Usuario") eliminar_usuario ;;
    "Editar Usuario") editar_usuario ;;
    "Listar Usuarios") listar_usuarios ;;
    "Salir") exit 0 ;;
    *) exit 0 ;;
  esac
done
