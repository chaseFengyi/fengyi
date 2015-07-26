MY8255_A EQU  0640H 
MY8255_B EQU  0642H 
MY8255_C EQU  0644H                                   
MY8255_MODE EQU  0646H
MY8254_MODE EQU  0686H
MY8254_B EQU 0680H
;进行宏定义
DATA   SEGMENT
    FREQ_LIST DW 441D,495D,556D,589D,661D,742D,833D,882D,262D,294D,330D,373D,402D,450D,494D,1D
DATA   ENDS
;建立数据段
CODE SEGMENT 
      ASSUME CS:CODE,DS:DATA 
START:
MOV AX,DATA                   
MOV DS,AX                            
;实现段寄存器DS的初始化 
    MOV DX,MY8255_MODE 
    MOV AL,82H 
OUT DX,AL                            

;写 8255芯片的控制字，实现工作在方式0A端口和C端口输出，B端口输入
MOV DX,MY8254_MODE
MOV AL,36H 
OUT DX,AL
;使 8254工作在方式3，A     口输入，运用计数器0，二进制方式
BEGIN: CALL CCSCAN
;扫描
JNZ INK1                             
;有键按下时跳到INK1 
JMP BEGIN                            
;没见按下时循环执行简易电子琴设计10             BEGIN 

 

;======================================== 

;

;确定按下键的位置

 

;======================================== 

INK1:   CALL CCSCAN 

        JNZ INK2                            

;有键按下时跳到INK2  

 JMP BEGIN 

 

;没见按下时循环执行BEGIN 
INK2:   
MOV CH,0FEH                         

;确定按下键在第一列

 MOV CL,00H                          

;将 CL清零


COLUM:  MOV AL,CH 

        MOV DX,MY8255_A                    

;将8255的B口地址赋给DX 

 

 

 OUT DX,AL                          

;将CPU中的AL值送到8255的B口中，即送到x1、x2、x3x4中
MOV DX,MY8255_B                    
;将8255的C口地址赋给DX  

 IN AL,DX                           

;将C口的值送到AL中
L1:     
TEST AL,01H                        

;检验按下键是否在L1 

        JNZ L2                             

;不是L1则跳到L2 

        MOV AL,00H                         

;为了后面用来与FREQ_LIST                            数据段中数对应
JMP KCODE                          

;强制跳转到KCODE 

 

L2:     TEST AL,02H                    

;检验按下键是否在L2  

        JNZ L3 
MOV AL,04H                     

;为了后面用来与FREQ_LIST数据段中数对应。
JMP KCODE                      

;强制跳转到KCODE 

L3:     TEST AL,04H                    

;检验按下键是否在L23 

        JNZ L4                         

;不是L3则跳到L4 

MOV AL,08H                     

;为了后面用来与FREQ_LIST 数据段中数对应。

 

JMP KCODE                      

;强制跳转到KCODE 

L4:     TEST AL,08H                    

;检验按下键是否在l4   

        JNZ NEXT                       

;不是L4则跳到NEXT 

MOV AL,0CH                     

;为了后面用来与FREQ_LIST                                    数据段中数对应。
KCODE:  ADD AL,CL                      

;实现AL与CL的无进位加法

 

        MOV DL,2D                       

        MUL DL                         

;将AL乘以2结果保存到AX中     

PLAY:   MOV SI,OFFSET FREQ_LIST        

;使SI指向 FREQ_LIST的首地址

        ADD SI,AX                      

;通过SI加AX 实现指针SI的移动
        MOV DX,0FH                      

        MOV AX,4240H                   

;被除数为0F4240H 
        DIV WORD PTR[SI]               

;除数为SI所指的数据
        MOV DX,MY8254_B                

;；将8254的A口地址赋给DX 
        OUT DX,AL                      

;输出商的低4位
        MOV AL,AH 

        OUT DX,AL                      

;输出商的高4位简易电子琴设计12 

 MOV CX,8D                      

;输入计数值CX 

 NEXT3: CALL DALLY                     

;调用延时子程序DALLY 
        CALL DALLY 

CALL DALLY 

CALL DALLY 

CALL DALLY 

LOOP NEXT3                     

;CX不为0重复执行NEXT3   

        MOV DX,0FH                      

        MOV AX,4240H                   

;被除数为0F4240H 

        MOV SI ,30D                     

        DIV WORD PTR[SI]               

;除数为SI=30所指的数据

 

        MOV DX,MY8254_B                

;将8254的A口地址赋给 DX 

        OUT DX,AL                        

        MOV AL,AH                       

        OUT DX,AL                      

;实现静音，结束一个音符的发音
        JMP BEGIN                      

;跳转到BEGIN，重复扫描
NEXT:   INC CL                         

;使CL加1，为了后面用来与FREQ_LIST数据段中数对应
 MOV AL,CH                         

 

 

 TEST AL,08H                       

 

 

 JZ KERR                           

;无键按下时跳转到KERR 

 ROL AL,1D                         

;向左移位
 MOV CH,AL 

 

 

 JMP COLUM                         

;强制跳转到COLUM

 

 

KERR:   JMP BEGIN                             
;跳到       BEGIN重新开始扫描

 

;======================================== 

;                盘扫描子程序

 

;========================================  


                        

;不是L2则跳到L3 
CCSCAN: MOV AL,00H 

        MOV DX,MY8255_A   

 

 

 OUT DX,AL                             

;使8255芯片B端口输出为0，既使x1、x2、x3、      X4为0         MOV DX,MY8255_B  
        IN  AL,DX                             

;将从C端口输入的y1、y2、y3、y4送到AL中
 NOT AL                                 

;将AL取反
        AND AL,0FH                            

;将AL前4位清零
 RET 

 

;======================================== 

;

;延时子程序

 

;======================================== 

DALLY:  PUSH CX                               

;将CX压栈
        MOV CX,000FH                           

T1:     MOV AX,0009FH 

T2:     DEC AX                                

;使AX减1 
 JNZ T2                                 
;AX不为0重复T2 
; LOOP T1                                
;CX不为0重复T1 
 POP CX                                 

;将CX出栈

 RET 

CODE  ENDS                                   

;代码段定义结束

END START                              

;程序结束