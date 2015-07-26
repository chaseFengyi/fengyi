CODE    SEGMENT
    ASSUME  CS:CODE
START:   MOV DX,63H
         MOV AL,90H
         OUT DX,AL                     ;8255A��ʼ��
INPUT:   MOV DX,60H
         IN AL,DX                      ;8255A�˿�A����
         MOV AH,07H
         INT 21H                         ;�ӿ��������ź�
         CMP  AL,00000001B
JZ  K1
	        CMP  AL,00000010B
JZ  K2
	        CMP  AL,00000100B
JZ  K3
	        CMP  AL,00001000B
JZ  K4
	        CMP  AL,00010000B
	        JZ  K5
	        CMP  AL,00100000B
	        JZ  K6
	        CMP  AL,01000000B
	        JZ  K7
	        CMP  AL,10000000B          ;�жϴ��ĸ��������벢��
JZ  K8                        ;ת����Ӧ8253��ʼ��
        MOV DL,0FFH
        MOV AH,6
        INT 21H                   
        MOV AH,4CH                     ;���������������˳���
        INT 21H                          ;�򣬷���DOS
K1:     MOV AL,0B6H
        OUT 43H,AL
        MOV AX,0
        JMP SING
K2:     MOV AL,0B6H
        OUT 43H,AL
        MOV AX,2420
        JMP SING
K3:     MOV AL,0B6H
        OUT 43H,AL
        MOV AX,2712
        JMP SING
K4:     MOV AL,0B6H
        OUT 43H,AL
        MOV AX,3044
        JMP SING
K5:     MOV AL,0B6H
        OUT 43H,AL
        MOV AX,3419
        JMP SING
K6:     MOV AL,0B6H
        OUT 43H,AL
        MOV AX,3627
        JMP SING
K7:     MOV AL,0B6H
        OUT 43H,AL
        MOV AX,4072
        JMP SING
K8:     MOV AL,0B6H
        OUT 43H,AL                       ;��8253��ʼ��        
MOV AX,4572                      ;����AX��
        JMP SING                          ;ֵ
SING:   OUT 42H,AL
        MOV AL,AH
        OUT 42H,AL                     ;�����ͼ���ֵ��8253
        IN AL,61H
        OR AL,03H
        OUT 61H,AL                    ;��������
        IN AL,61H
        AND AL,0FCH
        OUT 61H,AL                    ;�ر�������
        JMP INPUT                       ;��ת��INPUT
CODE    ENDS 
END     START

