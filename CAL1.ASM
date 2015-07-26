DATA SEGMENT
        INFOR1 DB 0AH,0DH,"Please Input the First Data(<65535):$"
        INFOR2 DB 0AH,0DH,"Please Input the Second Data(<65535):$"
        INFOR3 DB "The Result is:$"
        INFOR4 DB "The Result is: -$"
        INFOR5 DB 0AH,0DH,"The second number should not be zero $" 
        INFOR6 DB 0AH,0DH,"Please input a number $"  
        INFOR7 DB 0AH,0DH,"The number that you input is out of range $"    
        CHOOSE DB 0AH,0DH,"Please choose ([+][-][*][/]) :$"    
        INF0    DB 0AH,0DH,"-----MY CALCULATOR-----$"
        INF1    DB 0AH,0DH,"+ -----------------ADD$"
        INF2    DB 0AH,0DH,"- -----------------SUB$"
        INF3    DB 0AH,0DH,"* -----------------MUL$"
        INF4    DB 0AH,0DH,"/ -----------------DIV$"       
        INF5    DB 0AH,0DH,"Q(q) --------------EXIT$"
        INF6    DB 0AH,0DH,"C(c) --------------CONTINUE$"          
        INF7    DB 0AH,0DH,"Choose([Q(q)]=>EXIT,[C(c)=>CONTINUE]):$"
        INF8    DB 0AH,0DH,0AH,0DH,"Input a right word:$"
        IBUF1 DB 7,0,6 DUP(0)
        IBUF2 DB 7,0,6 DUP(0)
        OBUF DB 6 DUP(0)
DATA ENDS                                       
             
MENU MACRO INF
        LEA DX,INF
        MOV AH,09H
        INT 21H
ENDM 

STACK SEGMENT
        STL DW 100H DUP(?)
STACK ENDS
CODE SEGMENT
        ASSUME CS:CODE,DS:DATA
START:MOV AX,DATA
      MOV DS,AX
CLS:
    MOV AX,0600H
    MOV BH,07
    ;MOV CX,0000
    ;MOV DX,184FH
    MOV CX,1826H
    MOV DX,1726H
    INT 10H
      MENU INF0
      MENU INF1
      MENU INF2
      MENU INF3
      MENU INF4
      MENU INF5
      MENU INF6
CHOOSE1:  
      MENU INF7    
      MOV AH,01H
      INT 21H
      CMP AL,071H
      JE STOP
      CMP AL,051H
      JE STOP 
      CMP AL,043H
      JE CHOOSE2
      CMP AL,063H
      JE CHOOSE2
      JNE NOTICE
OUTPUT:
    MOV DX,OFFSET INFOR3
    MOV AH,09H
    INT 21H   
    POP BX 
    MOV DX,BX
    MOV AH,09H
    INT 21H
    MOV AH,01H
    INT 21H
    CMP AL,0DH
    JE CLS
STOP:     
    MOV AH,4CH
    INT 21H
NOTICE:
    MENU INF8
    JMP CLS

CHOOSE2:
      MOV DX,OFFSET INFOR1
      MOV AH,09H
      INT 21H         
      MOV DX,OFFSET IBUF1
      MOV AH,0AH
      INT 21H
      MOV BL,AL
      SUB BL,30H
      MOV CL,IBUF1+1
      MOV CH,0
      MOV SI,OFFSET IBUF1+2
      MOV AX,0 
AGAIN1: 
      MOV DX,10
      MUL DX
      AND BYTE PTR [SI],0FH
      ADD AL,[SI]
      ADC AH,0
      INC SI
      LOOP AGAIN1       
      PUSH AX
      MOV DX,OFFSET CHOOSE
      MOV AH,09H
      INT 21H
      MOV AH,01H
      INT 21H 
      MOV CL,AL
      XOR CH,CH
      PUSH CX          
SECOND:          
      MOV DX,OFFSET INFOR2
      MOV AH,09H
      INT 21H
      MOV DX,OFFSET IBUF2
      MOV AH,0AH
      INT 21H
      MOV AH,02H
      MOV DL,0AH
      INT 21H
      MOV CL,IBUF2+1
      MOV CH,0
      MOV SI,OFFSET IBUF2+2
      MOV AX,0 
AGAIN2: 
      MOV DX,10
      MUL DX
      AND BYTE PTR [SI],0FH
      ADD AL,[SI]
      ADC AH,0
      INC SI
      LOOP AGAIN2   
      MOV BX,AX
      PUSH BX 
      POP BX
      POP CX
      PUSH BX
      PUSH CX
      CMP CL,02BH
      JE PLUS
      CMP CL,02DH
      JE SUBTRACTION    
      CMP CL,02AH
      JE MULTIPLICATION 
      CMP CL,02FH
      JE DIVISION
      JMP SUBTRACTION
      JMP CLS         
PLUS: 
    POP CX
    POP BX
    POP AX
    PUSH AX 
    PUSH CX
    ADD AX,BX
    PUSH AX
    JMP BINARYTODECIMAL
SUBTRACTION:
    POP CX
    POP BX
    POP AX
    PUSH AX 
    PUSH CX
    CMP AX,BX
    JB SUB1
    SUB AX,BX
    PUSH AX
    JMP BINARYTODECIMAL
MULTIPLICATION:
    POP CX
    POP BX
    POP AX
    PUSH AX 
    PUSH CX
    MUL BX    
    PUSH AX
    JMP BINARYTODECIMAL
NOTICE1:
    MENU INFOR5
    JMP SECOND     
DIVISION:
    POP CX
    POP BX
    POP AX
    PUSH AX 
    PUSH CX
    CMP BX,0  
    JE NOTICE1
    DIV BX    
    PUSH AX
    JMP BINARYTODECIMAL
SUB1:
    MOV DX,AX
    MOV AX,BX
    MOV BX,DX
    SUB AX,BX
    PUSH AX
    POP AX 
    MOV BX,OFFSET OBUF+5
    MOV BYTE PTR[BX],'$'
    MOV CX,10   
LOOP2:
    MOV DX,0
    DIV CX
    ADD DL,30H
    DEC BX
    MOV [BX],DL
    OR AX,AX
    JNZ LOOP2
    PUSH BX   
    MOV DX,OFFSET INFOR4
    MOV AH,09H
    INT 21H
    POP BX 
    MOV DX,BX
    MOV AH,09H
    INT 21H
    MOV AH,01H
    INT 21H
    CMP AL,0DH 
    JMP CLS
BINARYTODECIMAL:
    POP AX 
    MOV BX,OFFSET OBUF+5
    MOV BYTE PTR[BX],'$'
    MOV CX,10   
LOOP1:
    MOV DX,0
    DIV CX
    ADD DL,30H
    DEC BX
    MOV [BX],DL
    OR AX,AX
    JNZ LOOP1
    PUSH BX  
    JMP OUTPUT             
  
    MOV AX,4CH
    INT 21H
      
CODE ENDS
        END START
