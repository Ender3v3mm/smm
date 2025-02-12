#include <AccelStepper.h>

// Definición de pines para cada motor (adaptados para Arduino UNO)
// Se evitan los pines 0 y 1 (Serial)
#define X_STEP_PIN 2
#define X_DIR_PIN 3
#define X_ENABLE_PIN 4

#define Y_STEP_PIN 5
#define Y_DIR_PIN 6
#define Y_ENABLE_PIN 7

#define Z_STEP_PIN 8
#define Z_DIR_PIN 9
#define Z_ENABLE_PIN 10

#define E_STEP_PIN 11
#define E_DIR_PIN 12
#define E_ENABLE_PIN 13

// Límites de posición (puedes ajustar estos valores según tus necesidades)
const float MAX_POSITION = 1000.0;
const float MIN_POSITION = -1000.0;

// Creación de objetos AccelStepper para cada motor usando el driver (STEP/DIR)
AccelStepper stepperX(AccelStepper::DRIVER, X_STEP_PIN, X_DIR_PIN);
AccelStepper stepperY(AccelStepper::DRIVER, Y_STEP_PIN, Y_DIR_PIN);
AccelStepper stepperZ(AccelStepper::DRIVER, Z_STEP_PIN, Z_DIR_PIN);
AccelStepper stepperE(AccelStepper::DRIVER, E_STEP_PIN, E_DIR_PIN);

void parseGCode(String command) {
    // --- Procesamiento del comando G92: Resetear la posición de los ejes especificados ---
    if (command.startsWith("G92")) {
        int index;
        
        // Resetear eje X, si se especifica en el comando
        index = command.indexOf('X');
        if (index != -1) {
            float newX = command.substring(index + 1).toFloat();
            stepperX.setCurrentPosition(newX * 110);
            Serial.print("G92 ejecutado: X=");
            Serial.println(newX);
        }
        
        // Resetear eje Y
        index = command.indexOf('Y');
        if (index != -1) {
            float newY = command.substring(index + 1).toFloat();
            stepperY.setCurrentPosition(newY * 110);
            Serial.print("G92 ejecutado: Y=");
            Serial.println(newY);
        }
        
        // Resetear eje Z
        index = command.indexOf('Z');
        if (index != -1) {
            float newZ = command.substring(index + 1).toFloat();
            stepperZ.setCurrentPosition(newZ * 110);
            Serial.print("G92 ejecutado: Z=");
            Serial.println(newZ);
        }
        
        // Resetear eje E
        index = command.indexOf('E');
        if (index != -1) {
            float newE = command.substring(index + 1).toFloat();
            stepperE.setCurrentPosition(newE * 110);
            Serial.print("G92 ejecutado: E=");
            Serial.println(newE);
        }
        return;
    }
    
    // --- Procesamiento del comando G1 (movimientos) ---
    if (command.startsWith("G1")) {
        float x = NAN, y = NAN, z = NAN, e = NAN, f = 6000;
    
        if (command.indexOf('X') != -1) {
            x = constrain(command.substring(command.indexOf('X') + 1).toFloat(), MIN_POSITION, MAX_POSITION);
        }
        if (command.indexOf('Y') != -1) {
            y = constrain(command.substring(command.indexOf('Y') + 1).toFloat(), MIN_POSITION, MAX_POSITION);
        }
        if (command.indexOf('Z') != -1) {
            z = constrain(command.substring(command.indexOf('Z') + 1).toFloat(), MIN_POSITION, MAX_POSITION);
        }
        if (command.indexOf('E') != -1) {
            e = constrain(command.substring(command.indexOf('E') + 1).toFloat(), MIN_POSITION, MAX_POSITION);
        }
        if (command.indexOf('F') != -1) {
            f = command.substring(command.indexOf('F') + 1).toFloat();
        }
    
        // Establecer la velocidad máxima para cada motor según el valor F
        stepperX.setMaxSpeed(f);
        stepperY.setMaxSpeed(f);
        stepperZ.setMaxSpeed(f);
        stepperE.setMaxSpeed(f);
    
        // Mover los motores a las posiciones especificadas (multiplicación por 110 para escalado)
        if (!isnan(x)) {
            digitalWrite(X_ENABLE_PIN, LOW); // Activar motor X
            stepperX.moveTo(x * 110);
        }
        if (!isnan(y)) {
            digitalWrite(Y_ENABLE_PIN, LOW); // Activar motor Y
            stepperY.moveTo(y * 110);
        }
        if (!isnan(z)) {
            digitalWrite(Z_ENABLE_PIN, LOW); // Activar motor Z
            stepperZ.moveTo(z * 110);
        }
        if (!isnan(e)) {
            digitalWrite(E_ENABLE_PIN, LOW); // Activar motor E
            stepperE.moveTo(e * 110);
        }
    }
}

void setup() {
    Serial.begin(115200);
    
    // Configurar los pines de habilitación de los motores como salidas
    pinMode(X_ENABLE_PIN, OUTPUT);
    pinMode(Y_ENABLE_PIN, OUTPUT);
    pinMode(Z_ENABLE_PIN, OUTPUT);
    pinMode(E_ENABLE_PIN, OUTPUT);
    
    // Inicialmente, desactivar (deshabilitar) los motores
    digitalWrite(X_ENABLE_PIN, HIGH);
    digitalWrite(Y_ENABLE_PIN, HIGH);
    digitalWrite(Z_ENABLE_PIN, HIGH);
    digitalWrite(E_ENABLE_PIN, HIGH);
    
    // Asociar los pines de habilitación a cada objeto AccelStepper
    stepperX.setEnablePin(X_ENABLE_PIN);
    stepperY.setEnablePin(Y_ENABLE_PIN);
    stepperZ.setEnablePin(Z_ENABLE_PIN);
    stepperE.setEnablePin(E_ENABLE_PIN);
    
    // Configurar velocidad máxima y aceleración para cada motor
    stepperX.setMaxSpeed(6000);
    stepperX.setAcceleration(6000);
    stepperY.setMaxSpeed(6000);
    stepperY.setAcceleration(6000);
    stepperZ.setMaxSpeed(6000);
    stepperZ.setAcceleration(6000);
    stepperE.setMaxSpeed(6000);
    stepperE.setAcceleration(6000);
}

void loop() {
    if (Serial.available()) {
        String command = Serial.readStringUntil('\n');
        parseGCode(command);
    }
    
    // Ejecutar movimientos para cada motor
    stepperX.run();
    stepperY.run();
    stepperZ.run();
    stepperE.run();
    
    // Desactivar (deshabilitar) motores cuando ya no se mueven
    if (stepperX.distanceToGo() == 0) digitalWrite(X_ENABLE_PIN, HIGH);
    if (stepperY.distanceToGo() == 0) digitalWrite(Y_ENABLE_PIN, HIGH);
    if (stepperZ.distanceToGo() == 0) digitalWrite(Z_ENABLE_PIN, HIGH);
    if (stepperE.distanceToGo() == 0) digitalWrite(E_ENABLE_PIN, HIGH);
}
