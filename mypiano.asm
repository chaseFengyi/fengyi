MY8255_A EQU  0640H 
MY8255_B EQU  0642H 
MY8255_C EQU  0644H                                   
MY8255_MODE EQU  0646H
MY8254_MODE EQU  0686H
MY8254_B EQU 0680H
;���к궨��
DATA   SEGMENT
    FREQ_LIST DW 441D,495D,556D,589D,661D,742D,833D,882D,262D,294D,330D,373D,402D,450D,494D,1D
DATA   ENDS
;�������ݶ�
CODE SEGMENT 
      ASSUME CS:CODE,DS:DATA 
START:
MOV AX,DATA                   
MOV DS,AX                            
;ʵ�ֶμĴ���DS�ĳ�ʼ�� 
    MOV DX,MY8255_MODE 
    MOV AL,82H 
OUT DX,AL                            

;д 8255оƬ�Ŀ����֣�ʵ�ֹ����ڷ�ʽ0A�˿ں�C�˿������B�˿�����
MOV DX,MY8254_MODE
MOV AL,36H 
OUT DX,AL
;ʹ 8254�����ڷ�ʽ3��A     �����룬���ü�����0�������Ʒ�ʽ
BEGIN: CALL CCSCAN
;ɨ��
JNZ INK1                             
;�м�����ʱ����INK1 
JMP BEGIN                            
;û������ʱѭ��ִ�м��׵��������10             BEGIN 

 

;======================================== 

;

;ȷ�����¼���λ��

 

;======================================== 

INK1:   CALL CCSCAN 

        JNZ INK2                            

;�м�����ʱ����INK2  

 JMP BEGIN 

 

;û������ʱѭ��ִ��BEGIN 
INK2:   
MOV CH,0FEH                         

;ȷ�����¼��ڵ�һ��

 MOV CL,00H                          

;�� CL����


COLUM:  MOV AL,CH 

        MOV DX,MY8255_A                    

;��8255��B�ڵ�ַ����DX 

 

 

 OUT DX,AL                          

;��CPU�е�ALֵ�͵�8255��B���У����͵�x1��x2��x3x4��
MOV DX,MY8255_B                    
;��8255��C�ڵ�ַ����DX  

 IN AL,DX                           

;��C�ڵ�ֵ�͵�AL��
L1:     
TEST AL,01H                        

;���鰴�¼��Ƿ���L1 

        JNZ L2                             

;����L1������L2 

        MOV AL,00H                         

;Ϊ�˺���������FREQ_LIST                            ���ݶ�������Ӧ
JMP KCODE                          

;ǿ����ת��KCODE 

 

L2:     TEST AL,02H                    

;���鰴�¼��Ƿ���L2  

        JNZ L3 
MOV AL,04H                     

;Ϊ�˺���������FREQ_LIST���ݶ�������Ӧ��
JMP KCODE                      

;ǿ����ת��KCODE 

L3:     TEST AL,04H                    

;���鰴�¼��Ƿ���L23 

        JNZ L4                         

;����L3������L4 

MOV AL,08H                     

;Ϊ�˺���������FREQ_LIST ���ݶ�������Ӧ��

 

JMP KCODE                      

;ǿ����ת��KCODE 

L4:     TEST AL,08H                    

;���鰴�¼��Ƿ���l4   

        JNZ NEXT                       

;����L4������NEXT 

MOV AL,0CH                     

;Ϊ�˺���������FREQ_LIST                                    ���ݶ�������Ӧ��
KCODE:  ADD AL,CL                      

;ʵ��AL��CL���޽�λ�ӷ�

 

        MOV DL,2D                       

        MUL DL                         

;��AL����2������浽AX��     

PLAY:   MOV SI,OFFSET FREQ_LIST        

;ʹSIָ�� FREQ_LIST���׵�ַ

        ADD SI,AX                      

;ͨ��SI��AX ʵ��ָ��SI���ƶ�
        MOV DX,0FH                      

        MOV AX,4240H                   

;������Ϊ0F4240H 
        DIV WORD PTR[SI]               

;����ΪSI��ָ������
        MOV DX,MY8254_B                

;����8254��A�ڵ�ַ����DX 
        OUT DX,AL                      

;����̵ĵ�4λ
        MOV AL,AH 

        OUT DX,AL                      

;����̵ĸ�4λ���׵��������12 

 MOV CX,8D                      

;�������ֵCX 

 NEXT3: CALL DALLY                     

;������ʱ�ӳ���DALLY 
        CALL DALLY 

CALL DALLY 

CALL DALLY 

CALL DALLY 

LOOP NEXT3                     

;CX��Ϊ0�ظ�ִ��NEXT3   

        MOV DX,0FH                      

        MOV AX,4240H                   

;������Ϊ0F4240H 

        MOV SI ,30D                     

        DIV WORD PTR[SI]               

;����ΪSI=30��ָ������

 

        MOV DX,MY8254_B                

;��8254��A�ڵ�ַ���� DX 

        OUT DX,AL                        

        MOV AL,AH                       

        OUT DX,AL                      

;ʵ�־���������һ�������ķ���
        JMP BEGIN                      

;��ת��BEGIN���ظ�ɨ��
NEXT:   INC CL                         

;ʹCL��1��Ϊ�˺���������FREQ_LIST���ݶ�������Ӧ
 MOV AL,CH                         

 

 

 TEST AL,08H                       

 

 

 JZ KERR                           

;�޼�����ʱ��ת��KERR 

 ROL AL,1D                         

;������λ
 MOV CH,AL 

 

 

 JMP COLUM                         

;ǿ����ת��COLUM

 

 

KERR:   JMP BEGIN                             
;����       BEGIN���¿�ʼɨ��

 

;======================================== 

;                ��ɨ���ӳ���

 

;========================================  


                        

;����L2������L3 
CCSCAN: MOV AL,00H 

        MOV DX,MY8255_A   

 

 

 OUT DX,AL                             

;ʹ8255оƬB�˿����Ϊ0����ʹx1��x2��x3��      X4Ϊ0         MOV DX,MY8255_B  
        IN  AL,DX                             

;����C�˿������y1��y2��y3��y4�͵�AL��
 NOT AL                                 

;��ALȡ��
        AND AL,0FH                            

;��ALǰ4λ����
 RET 

 

;======================================== 

;

;��ʱ�ӳ���

 

;======================================== 

DALLY:  PUSH CX                               

;��CXѹջ
        MOV CX,000FH                           

T1:     MOV AX,0009FH 

T2:     DEC AX                                

;ʹAX��1 
 JNZ T2                                 
;AX��Ϊ0�ظ�T2 
; LOOP T1                                
;CX��Ϊ0�ظ�T1 
 POP CX                                 

;��CX��ջ

 RET 

CODE  ENDS                                   

;����ζ������

END START                              

;�������