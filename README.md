TRABAJANDO EN LA PURGA, DE MOMENTO TIENE LA PURGA EN UN LATERAL, EJECUTANDO UNOS MOVIMIENTOS PARA QUE NO DAÑE LA IMPRESION, LA INTENCION ES AÑADIR UN SERVO, QUE RECOJA EL DESECHO Y LO MUEVA.


MATERIALES NECESARIOS.
x1 PLACA CONTROLADORA IMPRESORA 3D QUE ADMITA KLIPPER (AQUI HE USADO RAMPS)
x4 MOTORES NEMA 171
x1 FUENTE DE ALIMENTACION 12V 3A
x4 KIT EXTRUSOR MK8
3 METROS TUBO PTFE
x4 CONECTORES PC4-M6
x5 CONECTORES PC4-M10
x1 VIA 4 A 1 GUIA DE FILAMENTO



TENEMOS DOS VERSIONES
CON FIRMWARE KLIPPER (KLIPPERRAMPS.CFG)
CON ARDUINO (LOS DEMAS ARCHIVOS)



*OPCION KLIPPER
Descargar klipperramps.cfg.
¡¡EN CASO DE SER NECESARIO!! CAMBIAMOS LOS PUERTOS DE LOS MANUAL_STEPPER POR LOS DEFINIDOS EN NUESTRA PLACA PARA KLIPPER.
Subirlo a la impresora desde mainsail o fluidd.
Añadir [include klipperramps.cfg] en printer.cfg.
Verificar la distancia que necesita para descargar, en caso de necesitar cambio, modificamos en _DESCARGA_FILAMENTO
 -300 por la distancia necesaria.
 Guardamos y reiniciamos.
 Para poder pobras sin estar en una impresion, calentamos hotend a 220º y hacemos homing.
 
 ¡¡¡RECOMENDACION!!!

 HAZ LAS PRIMERAS PRUEBAS SIN FILAMENTO, PARA VER QUE LOS MOTORES DE CARGA Y DESCARGA SE MUEVE, QUE EJECUTA QUIT Y LOAD MATERIAL CUANDO CORRESPONDE.
 

*OPCION ARDUINO

Tienes que tener activo el gcode shell desde helper script.

git clone --depth 1 https://github.com/Ender3v3mm/smm/ /usr/data/printer_data/config

chmod +x /usr/data/printer_data/config/cambiar_1.sh

Reset a la impresora

En mainsail ya deberian aparecer las macros de T0 T1 T2 T3 (asi es como el slicer llama al cambio de filamento)

Se habran descargado tambien dos archivos .ino, descargalos de la impresora y eliminalos, utiliza el correspondiente (el de uno no esta problado)

Desde mainsail, ejecuta G28, pon la temperatura en 210º y ya puedes empezar a probar los motores sin filamento, ver que los movimiento de quit_material, descarga_filamento, carga_filamento y load_material,
se ejecutan correctamente y en el orden correspondiente, en el caso de no ser asi, se deben de ajustar los tiempos de sleep en el archivo cambiar_1.sh despues de la secuencia de quit_material

La torre de purga del slicer debe estar desactivada.

La opcion de multimaterial, tiene que ser de multimaterial con un extrusor y añadir los 4 filamentos en su apartado correspondiente, con eso es suficiente en el slicer

Sigo trabajando en la torre de purga, se admiten ideas!


