



Tienes que tener activo el gcode shell desde helper script.

git clone --depth 1 https://github.com/Ender3v3mm/smm/ /usr/data/printer_data/config

chmod +x /usr/data/printer_data/config/cambiar_1.sh

Reset a la impresora

En mainsail ya deberian aparecer las macros de T0 T1 T2 T3 (asi es como el slicer llama al cambio de filamento)


Desde mainsail, ejecuta G28, pon la temperatura en 210º y ya puedes empezar a probar los motores sin filamento, ver que los movimiento de quit_material, descarga_filamento, carga_filamento y load_material,
se ejecutan correctamente y en el orden correspondiente, en el caso de no ser asi, se deben de ajustar los tiempos de sleep en el archivo cambiar_1.sh despues de la secuencia de quit_material

La torre de purga del slicer debe estar desactivada.

La opcion de multimaterial, tiene que ser de multimaterial con un extrusor y añadir los 4 filamentos en su apartado correspondiente, eliminar PAUSE del gcode de cambio de filamento y con eso es suficiente en el slicer

Sigo trabajando en la torre de purga, se admiten ideas!






https://github.com/user-attachments/assets/21bc9149-c990-490b-93e9-277dc5cbe5cd


![WhatsApp Image 2025-02-09 at 20 36 34](https://github.com/user-attachments/assets/619ca5a8-0afe-430f-b05d-ac9824a4ab4e)
![WhatsApp Image 2025-02-09 at 17 47 19](https://github.com/user-attachments/assets/1ffc2e85-d1c5-49d3-9a37-f226ac96fb64)


