#!/bin/bash
# Archivo: master_filamento.sh
# Descripción: Realiza el cambio de filamento sin depender de macros de Klipper,
# replicando la secuencia original (QUIT_MATERIAL, DESCARGA_FILAMENT, CARGA_FILAMENT, LOAD_MATERIAL)
# con los mismos tiempos y comandos (temperaturas, movimientos, etc.).
# Recibe como parámetro TARGET_TOOL (T0, T1, T2 o T3).


# Desacoplar el proceso si no se ha invocado en modo --child
if [ "$1" != "--child" ]; then
    nohup "$0" --child "$@" >/dev/null 2>&1 &
    exit 0
fi
shift
# El resto de tu script sigue aquí...


########################################
# Funciones para enviar comandos vía serie
########################################
# Función para mover motor (envía un comando G1 al puerto serie)
mover_motor() {
    PORT="/dev/serial/by-id/usb-1a86_USB_Serial-if00-port0"
    if [ "$#" -lt 2 ]; then
        echo "Uso: mover_motor <EJE> <DISTANCIA>"
        exit 1
    fi
    EJE="$1"
    DISTANCIA="$2"
    # Configurar el puerto serie
    stty -F "$PORT" 115200 raw -echo
    echo -e "G1 ${EJE}${DISTANCIA} F6000\n" > "$PORT"
    echo "Comando enviado: G1 ${EJE}${DISTANCIA} F6000"
}

# Función para reiniciar la posición (envía un comando G92 al puerto serie)
reset_all() {
    PORT="/dev/serial/by-id/usb-1a86_USB_Serial-if00-port0"
    if [ "$#" -lt 2 ]; then
        echo "Uso: reset_all <EJE> <VALOR>"
        exit 1
    fi
    EJE="$1"
    VALOR="$2"
    stty -F "$PORT" 115200 raw -echo
    echo -e "G92 ${EJE}${VALOR}\n" > "$PORT"
    echo "Comando enviado: G92 ${EJE}${VALOR}"
}

########################################
# Configuración y lectura de estado
########################################
STATE_FILE="/usr/data/printer_data/config/active_motor.txt"
DEFAULT_TOOL="T0"

TARGET_TOOL="$1"
if [ -z "$TARGET_TOOL" ]; then
    echo "No se proporcionó TARGET_TOOL (T0, T1, T2 o T3)"
    exit 1
fi

if [ ! -f "$STATE_FILE" ]; then
    echo "$DEFAULT_TOOL" > "$STATE_FILE"
fi

CURRENT_TOOL=$(cat "$STATE_FILE")
echo "Motor activo actual: $CURRENT_TOOL. Nuevo motor solicitado: $TARGET_TOOL."

if [ "$CURRENT_TOOL" = "$TARGET_TOOL" ]; then
    echo "El motor activo es el mismo que el solicitado. No se requiere cambio."
    exit 0
fi

# Mapeo de herramientas a identificadores de motor
declare -A TOOL_TO_MOTOR
TOOL_TO_MOTOR["T0"]="X"
TOOL_TO_MOTOR["T1"]="Y"
TOOL_TO_MOTOR["T2"]="Z"
TOOL_TO_MOTOR["T3"]="E"

MOTOR_DESCARGA=${TOOL_TO_MOTOR["$CURRENT_TOOL"]}
MOTOR_CARGA=${TOOL_TO_MOTOR["$TARGET_TOOL"]}

########################################
# Paso 1: QUIT_MATERIAL (adaptado)
########################################
echo "Ejecutando QUIT_MATERIAL..."
# Enviar comandos QUIT_MATERIAL directamente al puerto (se envían a /tmp/printer)
echo "G1 Y220 F6000" > /tmp/printer
echo "M104 S200" > /tmp/printer    # Baja la temperatura a 210°C para iniciar la retracción
echo "M83" > /tmp/printer

if [ "$CURRENT_TOOL" = "T0" ]; then
    echo "G1 X160 Y220 F6000" > /tmp/printer
    echo "G1 X220 E15 F500" > /tmp/printer
    echo "G1 Y219 F3000" > /tmp/printer
    echo "G1 X160 E15 F500" > /tmp/printer
    echo "G1 X160 Y218 F6000" > /tmp/printer
    echo "G1 X220 E15 F500" > /tmp/printer
elif [ "$CURRENT_TOOL" = "T1" ]; then
    echo "G1 X160 Y217 F6000" > /tmp/printer
    echo "G1 X220 E15 F500" > /tmp/printer
    echo "G1 Y216 F3000" > /tmp/printer
    echo "G1 X160 E15 F500" > /tmp/printer
    echo "G1 Y215 F3000" > /tmp/printer
    echo "G1 X220 E15 F500" > /tmp/printer
elif [ "$CURRENT_TOOL" = "T2" ]; then
    echo "G1 X160 Y214 F6000" > /tmp/printer
    echo "G1 X220 E15 F500" > /tmp/printer
    echo "G1 Y213 F3000" > /tmp/printer
    echo "G1 X160 E15 F500" > /tmp/printer
    echo "G1 Y212 F3000" > /tmp/printer
    echo "G1 X220 E15 F500" > /tmp/printer
elif [ "$CURRENT_TOOL" = "T3" ]; then
    echo "G1 X160 Y211 F6000" > /tmp/printer
    echo "G1 X220 E15 F500" > /tmp/printer
    echo "G1 Y210 F6000" > /tmp/printer
    echo "G1 X160 E15 F500" > /tmp/printer
    echo "G1 Y209 F6000" > /tmp/printer
    echo "G1 X220 E15 F500" > /tmp/printer
else
    echo "G1 Y220 F6000" > /tmp/printer
fi



# Comandos de retracción y ajustes finales de QUIT_MATERIAL
echo "G1 E-15 F1000" > /tmp/printer
echo "G1 E-22 F1000" > /tmp/printer
echo "G1 E-6.3 F1200" > /tmp/printer
echo "G1 E-3.3 F720" > /tmp/printer
echo "M104 S180" > /tmp/printer    # Baja temperatura a 190°C para evitar hilos
echo "G4 P2000" > /tmp/printer     # Espera 2s para estabilizar
echo "G1 E5.0 F356" > /tmp/printer
echo "G1 E-5.0 F384" > /tmp/printer
echo "G1 E5.0 F412" > /tmp/printer
echo "G1 E-5.0 F440" > /tmp/printer
echo "G1 E5.0 F467" > /tmp/printer
echo "G1 E-5.0 F495" > /tmp/printer
echo "G1 E5.0 F523" > /tmp/printer
echo "G1 E-5.0 F3000" > /tmp/printer
echo "G1 E-40 F3000" > /tmp/printer
echo "M104 S210" > /tmp/printer
echo "SET_E_MIN_CURRENT" > /tmp/printer
echo "M117 Restaurando altura de impresión" > /tmp/printer
echo "RESTORE_E_CURRENT" > /tmp/printer
echo -e "G4 P30000\n" > /tmp/printer

# Pausa para asegurar que QUIT_MATERIAL se ejecute
sleep 40

PORT="/dev/serial/by-id/usb-1a86_USB_Serial-if00-port0"

# Configura el puerto serie a 115200, modo raw y sin eco
stty -F "$PORT" 115200 raw -echo

# Enviar comandos para MOTOR_DESCARGA si existe
if [ -n "$MOTOR_DESCARGA" ]; then
    # Enviar comando G1
    echo -e "G1 ${MOTOR_DESCARGA} 40\n" > /dev/serial/by-id/usb-1a86_USB_Serial-if00-port0
    sleep 5  # espera 5 segundos para que se procese
    # Enviar comando de espera
    
    sleep 3
    # Enviar comando G92 para reiniciar la posición
    echo -e "G92 ${MOTOR_DESCARGA} 50\n" > /dev/serial/by-id/usb-1a86_USB_Serial-if00-port0
        # Otra espera
    
    sleep 0.5
fi

# Enviar comando para MOTOR_CARGA si existe
if [ -n "$MOTOR_CARGA" ]; then
    echo -e "G1 ${MOTOR_CARGA} -150\n" > /dev/serial/by-id/usb-1a86_USB_Serial-if00-port0
    sleep 0.5
fi

########################################
# Paso 4: LOAD_MATERIAL
########################################
echo "Ejecutando LOAD_MATERIAL..."
echo "RESTORE_E_CURRENT" > /tmp/printer
echo "LOAD_MATERIAL_CLOSE_FAN2" > /tmp/printer

if [ "$TARGET_TOOL" = "T0" ]; then
    echo "G1 Y220 F6000" > /tmp/printer
    echo "G1 X100 E30 F500" > /tmp/printer
    echo "G1 Y219 F3000" > /tmp/printer
    echo "G1 X160 E30 F500" > /tmp/printer
    echo "G1 Y218 F3000" > /tmp/printer
    echo "G1 X100 E30 F500" > /tmp/printer
    echo "G1 Y217 F3000" > /tmp/printer
    echo "G1 X160 E10 F500" > /tmp/printer
elif [ "$TARGET_TOOL" = "T1" ]; then
    echo "G1 Y216 F6000" > /tmp/printer
    echo "G1 X100 E30 F500" > /tmp/printer
    echo "G1 Y215 F3000" > /tmp/printer
    echo "G1 X160 E30 F500" > /tmp/printer
    echo "G1 Y214 F3000" > /tmp/printer
    echo "G1 X100 E30 F500" > /tmp/printer
    echo "G1 Y213 F3000" > /tmp/printer
    echo "G1 X160 E10 F500" > /tmp/printer
elif [ "$TARGET_TOOL" = "T2" ]; then
    echo "G1 Y212 F6000" > /tmp/printer
    echo "G1 X100 E30 F500" > /tmp/printer
    echo "G1 Y211 F3000" > /tmp/printer
    echo "G1 X160 E30 F500" > /tmp/printer
    echo "G1 Y210 F3000" > /tmp/printer
    echo "G1 X100 E30 F500" > /tmp/printer
    echo "G1 Y209 F3000" > /tmp/printer
    echo "G1 X160 E10 F500" > /tmp/printer
elif [ "$TARGET_TOOL" = "T3" ]; then
    echo "G1 Y208 F6000" > /tmp/printer
    echo "G1 X100 E30 F500" > /tmp/printer
    echo "G1 Y207 F3000" > /tmp/printer
    echo "G1 X160 E30 F500" > /tmp/printer
    echo "G1 Y206 F3000" > /tmp/printer
    echo "G1 X100 E30 F500" > /tmp/printer
    echo "G1 Y205 F6000" > /tmp/printer
    echo "G1 X160 E10 F500" > /tmp/printer
else
    echo "G1 Y220 F6000" > /tmp/printer
fi

echo "LOAD_MATERIAL_RESTORE_FAN2" > /tmp/printer
echo "RESTORE_E_CURRENT" > /tmp/printer
echo "SET_E_MIN_CURRENT" > /tmp/printer
echo "M117 Restaurando altura de impresión" > /tmp/printer
echo "RESTORE_E_CURRENT" > /tmp/printer

# Actualizar el estado
echo "$TARGET_TOOL" > "$STATE_FILE"
echo "Cambio completado. Motor activo ahora: $TARGET_TOOL."

exit 0
