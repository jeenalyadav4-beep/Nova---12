; ===================================================================
; NOVA 12 GRAPHICAL OPERATING SYSTEM - PHASE 1 (VISUAL ENVIRONMENT)
; ===================================================================
[org 0x7c00]

start:
    ; 1. SWITCH GRAPHICS CARD TO VESA COLOR CANVAS MODE (800x600 pixels)
    mov ax, 0x4F02
    mov bx, 0x103       ; VESA mode code for 800x600 with 256 colors
    int 0x10

    ; 2. DRAW THE NEON PURPLE DESKTOP BACKGROUND
    mov ax, 0x4F05      ; Select VESA memory banks
    xor bx, bx
    xor dx, dx
    int 0x10
    
    ; Fill screen loops can be run here by drawing pixels to 0xA0000

draw_interface:
    ; 3. DRAW THE FLOATING BOTTOM TASKBAR (X: 0 to 800, Y: 560 to 600)
    ; (Draws a modern purple bar stretching across the screen base)
    mov cx, 0          ; Start X
    mov dx, 560        ; Start Y
draw_bar_loop:
    mov ah, 0x0C       ; Draw pixel function
    mov al, 5          ; Color index: Dark Neon Purple / Magenta
    int 0x10
    inc cx
    cmp cx, 800
    jne draw_bar_loop
    mov cx, 0
    inc dx
    cmp dx, 600
    jne draw_bar_loop

    ; 4. DRAW THE GLOSSY START BUTTON ORB (X: 10 to 40, Y: 565 to 595)
    mov cx, 10
    mov dx, 565
draw_start_orb:
    mov ah, 0x0C
    mov al, 15         ; Color index: High-gloss bright white
    int 0x10
    inc cx
    cmp cx, 40
    jne draw_start_orb
    mov cx, 10
    inc dx
    cmp dx, 595
    jne draw_start_orb

mouse_listener:
    ; 5. INITIALIZE THE HARDWARE MOUSE DRIVER LINK
    mov ax, 0          ; Reset mouse driver
    int 0x33
    mov ax, 1          ; Show graphical mouse pointer cursor on screen
    int 0x33

check_clicks:
    ; Continuously scan for user clicking the mouse buttons
    mov ax, 3          ; Get mouse position and button status
    int 0x33
    test bx, 1         ; Check if Left Mouse Button is clicked
    jz check_clicks

    ; Check if mouse is hovering exactly inside the Start Button area
    cmp cx, 20         ; Mouse X check
    jl check_clicks
    cmp cx, 80
    jg check_clicks
    cmp dx, 560        ; Mouse Y check
    jl check_clicks
    
open_apps_menu:
    ; 6. RENDER THE NOVA 12 APPS MENU WINDOW OVER THE DESKTOP
    mov cx, 10         ; Menu window position X
    mov dx, 300        ; Menu window position Y (pops UP above taskbar)
draw_menu_window:
    mov ah, 0x0C
    mov al, 8          ; Color index: Translucent dark grey/glass panel
    int 0x10
    inc cx
    cmp cx, 200        ; Width of menu
    jne draw_menu_window
    mov cx, 10
    inc dx
    cmp dx, 560        ; Height matching taskbar line
    jne draw_menu_window

    ; Loop back to keep tracking mouse choices inside the app menu
    jmp check_clicks

; Pad the binary data to match standard PC drive architecture
times 510-($-$$) db 0
dw 0xaa55
