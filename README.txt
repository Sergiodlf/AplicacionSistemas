Aplicación de Gestión de Sistemas
Este proyecto ha sido desarrollado por David, Sergio e Iker como una herramienta para facilitar diversas tareas administrativas y de red en sistemas Linux.

🛠 Funcionalidades

La aplicación ofrece un conjunto de scripts que permiten realizar las siguientes tareas:
Gestión de usuarios: alta, baja y modificación de usuarios del sistema.
Configuración de red y firewall: incluye utilidades para ver y modificar parámetros de red y aplicar reglas de iptables.
Envío de formularios por correo: envía formularios usando un script en Bash junto a un cliente de correo en Python.
Menús interactivos: proporciona un sistema de navegación sencillo basado en menús para acceder a todas las funcionalidades.


🚀 Instrucciones de ejecución

Para ejecutar correctamente la aplicación, debes iniciar el script principal menu.sh desde el terminal de Linux:

bash
Copiar
Editar
./menu.sh
Asegúrate de que el script tenga permisos de ejecución. Si no los tiene, puedes asignarlos con:

bash
Copiar
Editar
chmod +x menu.sh


📁 Estructura del proyecto

menu.sh: Script principal que carga el menú general.
gestion_usuarios.sh: Manejo de usuarios del sistema.
firewall.sh: Gestión de reglas de firewall.
menu_red.sh: Opciones relacionadas con la configuración de red.
enviar_formulario_correo.sh: Envío de formularios por email.
sendmail.py: Cliente de correo en Python para uso desde Bash.
backup.sh: Permite crear una copia comprimida de una carpeta específica en tu sistema WSL.

📌 Requisitos
Bash
Python 3
Acceso con privilegios para ejecutar comandos de administración del sistema
Permisos de ejecución en los scripts


