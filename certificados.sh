#!/bin/bash

# Lista de servidores a los que te conectarás
servers=("servidor1" "servidor2" "servidor3")

# Ruta local al archivo que deseas copiar
archivo_local="/ruta/local/archivo.pem"

# Ruta remota donde deseas copiar el archivo en los servidores
ruta_remota="/etc/ssl/private/pjs.pem"

# Bucle para recorrer la lista de servidores y copiar el archivo
for server in "${servers[@]}"; do
    echo "Conectándose a $server..."
    
    # Comando SCP para copiar el archivo al servidor
    scp "$archivo_local" "$server:$ruta_remota"
    
    if [ $? -eq 0 ]; then
        echo "Archivo copiado exitosamente en $server"
    else
        echo "Error al copiar el archivo en $server"
    fi
done
