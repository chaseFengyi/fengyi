;http://wenku.baidu.com/link?url=ohj0ANMNT2dC_BxA-GbeC8lx7U5eto0t4ju6fdm5xNAf-F_AX9PH8KPZpbvsnArHzvOmloyvrS0qP6I8788OFyqfJjOY-8vwOMsfeDq5W83
DATA SEGMENT
       DO_YF DB 241,0
       DO_TM DW 4572,0
       RE_YF DW 293,0
       RE_TM DW 4072,0
       MI_YF DW 329,0
       MI_TM DW 3627,0
       FA_YF DW 349,0
       FA_TM DW 3419,0
       SOL_YF DW 392,0
       SOL_TM DW 3044,0
       LA_YF DW 440,0
       LA_TM DW 2712,0
       SI_YF DW 493,0
       SI_TM DW 2420,0 
       ATM1  EQU       1000
       ATM2  EQU       145
       YF  DW        ?
       TM  DW        ?
DATA ENDS                                                      
CODE SEGMENT
    ASSUME DS:DATA,CS:CODE
START:
    MOV DX,DATA
    MOV DS,AX
    
 ;      SHOW:  MOV       AH,0
 ;             MOV       AL,1
 ;             INT       10H   ;在当前光标位置写字符    
 ;             MOV       AH,02H   ;显示字符  
 ;             MOV       BH,0
 ;             MOV       DH,16       ;光标的高度
 ;             MOV       DL,17       ;光标的x坐标
 ;             INT       10H         ;设置光标位置
    
INPUT:
    ;从键盘读入一个字符
    MOV AH,07H
    INT 21H
    CMP AL,'1'
    JZ  VOICE1
    CMP AL,'2'
    JZ VOICE2
    CMP AL,'3'
    JZ VOICE3 
    CMP AL,'4'
    JZ VOICE4 
    CMP AL,'5'
    JZ VOICE5
    CMP AL,'6'
    JZ VOICE6 
    CMP AL,'7'
    JZ VOICE7
    CMP AL,1BH    ;是ESC键吗？
    JE  OVER
    JMP INPUT 
    OVER: 
    MOV  AH,4CH
    INT  21H   
    VOICE1:
       LEA       SI,DO_YF
       MOV       YF,SI
       LEA       SI,DO_TM
       MOV       TM,SI
       JMP       BEG 
    VOICE2:
       LEA       SI,RE_YF
       MOV       YF,SI
       LEA       SI,RE_TM
       MOV       TM,SI
       JMP       BEG          
    VOICE3:
       LEA       SI,MI_YF
       MOV       YF,SI
       LEA       SI,MI_TM
       MOV       TM,SI
       JMP       BEG                           
    VOICE4:
       LEA       SI,FA_YF
       MOV       YF,SI
       LEA       SI,FA_TM
       MOV       TM,SI
       JMP       BEG 
                      
    VOICE5:
       LEA       SI,SOL_YF
       MOV       YF,SI
       LEA       SI,SOL_TM
       MOV       TM,SI
       JMP       BEG                        
    VOICE6:
       LEA       SI,LA_YF
       MOV       YF,SI
       LEA       SI,LA_TM
       MOV       TM,SI
       JMP       BEG                       
    VOICE7:
       LEA       SI,SI_YF
       MOV       YF,SI
       LEA       SI,SI_TM
       MOV       TM,SI                       
    BEG:  
        MOV       AL,10110110B   ;初始化定时器
        ;MOV AL,10010111B
        OUT       43H,AL     ;发送控制字节到控制寄存器
        CALL      OPEN    
   RTN:  
        MOV       SI,YF
              MOV       DI,TM
        ACT:  MOV       DX,12H
              MOV       AX, 34DEH
              DIV       WORD PTR[SI]
              ;MOV AL,DI
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
             ; JMP       SHOW

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
CODE ENDS
    END START