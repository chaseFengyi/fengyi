        DISP  MACRO     Y,X,STRS,LENS,COLOR
              MOV       AX,1301H
              MOV       BH,0
              MOV       BL,COLOR
              MOV       CX,LENS
              MOV       DH,Y
              MOV       DL,X
              MOV       BP,OFFSET STRS
              INT       10H
              ENDM

        DATA  SEGMENT
        STR0  DB        '         M E N U'
        STR1  DB        '         CHOOSE ONE      ?'
        STR2  DB        '?1.Mary Had a Little Lamb?'
        STR3  DB        '?2.Happy Birthday To You!?' 
        STR4  DB        '?3.      Return DOS      ?'
        STR5  DB        '?~~~~~~~~~~~~~~~~~~~~~~~~?'        

        ; YF1  DW        371,330,495,416,416,371,330,312,330,278,416,278,278,330,371,330,556,441,441,416,441,278,312,330,371,65535,416,441,495,495,495,556,330,65535,495,312,371,65535,371,416,278,441,416,441,441,495,371,0
        ; TM1  DB        2,2,2,4,2,2,2,2,2,2,4,2,4,2,2,2,2,2,2,2,2,2,2,2,12,2,2,2,2,2,2,2,8,2,2,2,2,2,2,2,4,4,2,2,2,2,2,12     
        YF1  DW        330,294,262,294,330,330,330,294,294,294,330,392,392,330,294,262,294,330,330,330,330,292,292,330,294,262,0
        TM1  DB        4,4,4,4,4,4,8,4,4,8,4,4,8,4,4,4,4,4,4,4,4,4,4,4,4,16
        ; YF2  DW        371,330,495,416,416,371,330,312,330,278,416,278,278,330,371,330,556,441,441,416,441,278,312,330,371,65535,416,441,495,495,495,556,330,65535,495,312,371,65535,371,416,278,441,416,441,441,495,371,0
        ; TM2  DB        2,2,2,4,2,2,2,2,2,2,4,2,4,2,2,2,2,2,2,2,2,2,2,2,12,2,2,2,2,2,2,2,8,2,2,2,2,2,2,2,4,4,2,2,2,2,2,12
        YF2  DW        262,262,294,262,349,330,262,262,294,262,392,349,262,262,523,440,349,330,294,466,466,440,349,392,349,0
        TM2  DB        2,2,4,4,4,8,2,2,4,4,4,8,2,2,4,4,4,4,6,2,2,4,4,4,8
        ATM1  EQU       1000
        ATM2  EQU       145
          YF  DW        ?
          TM  DW        ?
        DATA  ENDS
;设置光标宏指令CURSOR
CURSOR  MACRO   ROW,CLM
        MOV     AH,02H
        MOV     BH,00H
        MOV     DH,ROW
        MOV     DL,CLM
        INT     10H
ENDM
MENU MACRO INF,ROW
        CURSOR ROW,43
        LEA DX,INF
        MOV AH,09H
        INT 21H
ENDM
        CODE  SEGMENT
              ASSUME    CS:CODE,DS:DATA,ES:DATA
      START:  MOV       AX,DATA
              MOV       DS,AX
              MOV       ES,AX

       SHOW:  MOV       AH,0
              MOV       AL,1
              INT       10H   ;在当前光标位置写字符

              DISP      1,14,STR0,27,30H
              DISP      2,14,STR1,27,38H
              DISP      3,14,STR2,27,38H
              DISP      4,14,STR3,27,38H
              DISP      5,14,STR4,27,38H
              DISP      6,14,STR5,27,38H
              
              MOV       AH,02H   ;显示字符  
              MOV       BH,0
              MOV       DH,16       ;光标的高度
              MOV       DL,17       ;光标的x坐标
              INT       10H         ;设置光标位置

     CHOOSE:  MOV       AH,08H ;从键盘读一字符但不回显
              INT       21H
              CMP       AL,'1'
              JZ        M1
              CMP       AL,'2'
              JZ        M2
              CMP       AL,'3'
              JZ        OVER
              JMP       CHOOSE

         M1:  LEA       SI,YF1
              MOV       YF,SI
              LEA       SI,TM1
              MOV       TM,SI
              JMP       BEG

         M2:  LEA       SI,YF2
              MOV       YF,SI
              LEA       SI,TM2
              MOV       TM,SI

        BEG:  MOV       AL,10110110B   ;初始化定时器
              OUT       43H,AL     ;发送控制字节到控制寄存器
              CALL      OPEN

        RTN:  MOV       SI,YF
              MOV       DI,TM

        ACT:  MOV       DX,12H
              MOV       AX, 34DEH
              DIV       WORD PTR[SI]
              OUT       42H,AL
              MOV       AL,AH
              OUT       42H,AL
              CALL      DELAY

              ADD       SI,2
              CMP       WORD PTR[SI],0
              JZ        RTN
              INC       DI

              MOV       AH,1
              INT       16H
              JZ        ACT
              CALL      CLOSE
              JMP       SHOW

       OVER:  MOV       AH,4CH
              INT       21H

        OPEN  PROC
              IN        AL,61H        ;获得端口B的当前设置
              OR        AL,00000011B   ;使PB0=1，PB1=1
              OUT       61H,AL         ;打开扬声器
              RET
        OPEN  ENDP

       CLOSE  PROC
              IN        AL,61H
              AND       AL,11111100B
              OUT       61H,AL
              RET
       CLOSE  ENDP

       DELAY  PROC
              MOV       AX,ATM1
              MOV       DH,0
              MOV       DL,[DI]
              MUL       DX
              MOV       DX,ATM2
              MUL       DX
              MOV       CX,DX
              MOV       DX,AX
              MOV       AH,86H
              INT       15H
              RET
       DELAY  ENDP

        CODE  ENDS
              END       START
