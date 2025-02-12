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


