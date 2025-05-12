#!/bin/bash

# Función para ejecutar comandos con sudo sin perder el entorno gráfico
sudo_exec() {
  sudo env "DISPLAY=$DISPLAY" "DBUS_SESSION_BUS_ADDRESS=$DBUS_SESSION_BUS_ADDRESS" "$@"
}

crear_usuario() {
  username=$(zenity --entry --title="Crear Usuario" --text="Nombre del nuevo usuario:")
  [[ -z "$username" ]] && return

  if id "$username" &>/dev/null; then
    zenity --error --text="El usuario ya existe."
    return
  fi

  password=$(zenity --password --title="Contraseña para $username")
  [[ -z "$password" ]] && return

  sudo_exec useradd -m "$username"
  echo "$username:$password" | sudo_exec chpasswd

  if [[ $? -eq 0 ]]; then
    zenity --info --text="Usuario $username creado correctamente."
  else
    zenity --error --text="Error al crear el usuario."
  fi
}

eliminar_usuario() {
  username=$(zenity --entry --title="Eliminar Usuario" --text="Nombre del usuario a eliminar:")
  [[ -z "$username" ]] && return

  if id "$username" &>/dev/null; then
    zenity --question --text="¿Eliminar también el directorio home?"
    if [[ $? -eq 0 ]]; then
      sudo_exec userdel -r "$username"
    else
      sudo_exec userdel "$username"
    fi
    zenity --info --text="Usuario $username eliminado."
  else
    zenity --error --text="El usuario no existe."
  fi
}

editar_usuario() {
  username=$(zenity --entry --title="Editar Usuario" --text="Nombre del usuario a editar:")
  [[ -z "$username" ]] && return

  if ! id "$username" &>/dev/null; then
    zenity --error --text="El usuario no existe."
    return
  fi

  opcion=$(zenity --list --title="Editar Usuario" --text="¿Qué deseas editar?" \
    --column="Opción" --column="Acción" \
    1 "Cambiar nombre de usuario" \
    2 "Cambiar contraseña" \
    --width=400 --height=200)

  case $opcion in
    1)
      nuevo_nombre=$(zenity --entry --title="Nuevo Nombre" --text="Introduce el nuevo nombre de usuario:")
      [[ -z "$nuevo_nombre" ]] && return
      sudo_exec usermod -l "$nuevo_nombre" "$username"
      sudo_exec usermod -d "/home/$nuevo_nombre" -m "$nuevo_nombre"
      zenity --info --text="Nombre de usuario cambiado a $nuevo_nombre."
      ;;
    2)
      nueva_pass=$(zenity --password --title="Nueva Contraseña")
      [[ -z "$nueva_pass" ]] && return
      echo "$username:$nueva_pass" | sudo_exec chpasswd
      zenity --info --text="Contraseña cambiada correctamente."
      ;;
    *)
      return
      ;;
  esac
}

listar_usuarios() {
  usuarios=$(cut -d: -f1 /etc/passwd | sort)
  zenity --text-info --title="Lista de Usuarios" --width=400 --height=400 --filename=<(echo "$usuarios")
}

# Menú principal
while true; do
  opcion=$(zenity --list --title="Gestión de Usuarios" \
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
