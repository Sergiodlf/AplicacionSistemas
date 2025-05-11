 #!/usr/bin/env python3

import smtplib
import sys
from email.mime.text import MIMEText
from email.mime.multipart import MIMEMultipart

# Requiere: destinatario, asunto, mensaje
if len(sys.argv) != 4:
    print("Uso: python3 sendmail.py destinatario asunto mensaje")
    sys.exit(1)

destinatario = sys.argv[1]
asunto = sys.argv[2]
cuerpo = sys.argv[3]

remitente = "configuraciondelsistema1@gmail.com"
contrasena = "gbzmuldfaczgxbek"  # ← Reemplázala por tu contraseña de aplicación de Gmail

mensaje = MIMEMultipart()
mensaje["From"] = remitente
mensaje["To"] = destinatario
mensaje["Subject"] = asunto
mensaje.attach(MIMEText(cuerpo, "plain"))

try:
    servidor = smtplib.SMTP("smtp.gmail.com", 587)
    servidor.starttls()
    servidor.login(remitente, contrasena)
    servidor.sendmail(remitente, destinatario, mensaje.as_string())
    servidor.quit()
    print("Correo enviado correctamente.")
except Exception as e:
    print(f"Error al enviar correo: {e}")
    sys.exit(1)
