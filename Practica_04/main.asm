.equ cExter = 100     ; El conteo del bucle exterior
.equ cMedio = 200     ; El conteo del bucle medio
.equ cInter = 199     ; El conteo del bucle interno

.def rExter = R16     ; Definiendo el registro para el bucle exterior
.def rMedio = R17     ; Definiendo el registro para el bucle medio
.def rInter = R18     ; Definiendo el registro para el bucle interno

.ORG 0x00             ; Dirección de inicio del programa en la memoria
rjmp INICIO           ; Salto a la etiqueta "INICIO"

INICIO:
    ldi r16,low(RAMEND)      ; Cargar la parte baja de RAMEND en el registro R16
    out SPL, r16             ; Guardar el valor de R16 en la pila baja
    ldi r16,high(RAMEND)     ; Cargar la parte alta de RAMEND en el registro R16
    out SPH, r16             ; Guardar el valor de R16 en la pila alta

    ldi r16,0xFF             ; Cargar el valor 0xFF (255 en decimal) en el registro R16
    out DDRB,r16             ; Configurar todo el puerto B como salida

    cbi DDRB,DDB3            ; Cambiar el bit 3 de DDRB (pin 11) a 0 para configurarlo como salida

    ldi r16,0b11100000       ; Cargar el valor 0b11100000 (224 en decimal) en el registro R16
    out DDRD,r16             ; Configurar el puerto D como salida

    ldi r21, 0              ; Cargar el valor 0 en el registro R21 para una comprobación de nulidad
    ldi r20, 100            ; Cargar el valor inicial para el retardo de 0.5 segundos

Home:
    cbi PortB, 1            ; Limpiar el bit 1 del registro PortB (pin 9) para apagar el LED conectado a ese pin
    sbi PortD, 5            ; Establecer el bit 5 del registro PortD (pin 5) para encender el LED conectado a ese pin
    rcall Retraso05         ; Llamar a la subrutina Retraso05

    cbi PortD, 5            ; Limpiar el bit 5 del registro PortD (pin 5) para apagar el LED conectado a ese pin
    sbi PortD, 6            ; Establecer el bit 6 del registro PortD (pin 6) para encender el LED conectado a ese pin
    rcall Retraso05         ; Llamar a la subrutina Retraso05

    cbi PortD, 6            ; Limpiar el bit 6 del registro PortD (pin 6) para apagar el LED conectado a ese pin
    sbi PortD, 7            ; Establecer el bit 7 del registro PortD (pin 7) para encender el LED conectado a ese pin
    rcall Retraso05         ; Llamar a la subrutina Retraso05

    in R16,PINB             ; Leer todo el puerto B (desde PB0-PB5) y colocarlo en R16
    sbis PINB,PINB3         ; Revisar si el PINB3 (pin 11) ha cambiado
    rjmp btnon              ; Saltar a la etiqueta "btnon" si se cumple la condición
    sbic PINB,PINB3         ; Revisar el estado del registro tres del PINB, si se cumple la condición (bajo o cero), saltar
    rjmp btnoff             ; Saltar a la etiqueta "btnoff" si se cumple la condición
    rjmp Next               ; Saltar a la etiqueta "Next" para continuar

btnon:
    rjmp Next               ; Saltar a la etiqueta "Next"

btnoff:
    sbi PortB, 2            ; Establecer el bit 2 del registro PortB (pin 10) para encender el zumbador
    rcall Retraso05         ; Llamar a la subrutina Retraso05
    cbi PortB, 2            ; Limpiar el bit 2 del registro PortB (pin 10) para apagar el zumbador
    dec r20                 ; Restar 1 al registro r20
    dec r20                 ; Restar 1 al registro r20
    cpse r20,r21            ; Comparar el registro r20 con el valor 0. Si son diferentes, saltar a la siguiente línea
    rjmp Next               ; Saltar a la etiqueta "Next" si r20 es distinto de 0
    ldi r20, 100            ; Cargar el valor 100 en el registro r20
    rjmp Next               ; Saltar a la etiqueta "Next"

Next:
    cbi PortD, 7            ; Limpiar el bit 7 del registro PortD (pin 7) para apagar el LED conectado a ese pin
    sbi PortB, 0            ; Establecer el bit 0 del registro PortB (pin 8) para encender el LED conectado a ese pin
    rcall Retraso05         ; Llamar a la subrutina Retraso05

    cbi PortB, 0            ; Limpiar el bit 0 del registro PortB (pin 8) para apagar el LED conectado a ese pin
    sbi PortB, 1            ; Establecer el bit 1 del registro PortB (pin 9) para encender el LED conectado a ese pin
    rcall Retraso05         ; Llamar a la subrutina Retraso05
    rjmp Home               ; Saltar a la etiqueta "Home" para continuar con la ejecución del programa

Retraso05:
    mov r15, r20
    LDI rExter,cExter     ; Establecer el registro rExter al valor de conteo cExter
LoopOuter:
    LDI rMedio,cMedio     ; Establecer el registro rMedio al valor de conteo cMedio
LoopMiddle:
    LDI rInter,cInter     ; Establecer el registro rInter al valor de conteo cInter
LoopInner:
    DEC rInter            ; Decrementar el contador del bucle interno
    BRNE LoopInner        ; Saltar de nuevo a la etiqueta LoopInner si no es cero
    DEC rMedio            ; Decrementar el contador del bucle medio
    BRNE LoopMiddle       ; Saltar de nuevo a la etiqueta LoopMiddle si no es cero
    DEC rexter            ; Decrementar el contador del bucle exterior
    DEC R15
    BRNE LoopOuter        ; Saltar de nuevo a la etiqueta LoopOuter si no es cero
    RET                   ; Retornar al llamador