#Include "RWMAKE.CH"
#Include "TOPCONN.CH"     

User Function VALCUST()        
//SetPrvt("AARQ,LRET,NPOS5,NXK,")

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o    � ValCust   � Autor �Jane M. Duval         � Data � 18.11.99 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o �Validacao do campo de Matricula do Responsavel              ���
�������������������������������������������������������������������������Ĵ��
��� Uso      �                                                            ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/ 

Local   cQuery:=""
Local   lRet:=.t. 
Local   aArea   := GetArea() 
Private cMatricula  := M->CTT_MATRES 

 

cQuery:=" SELECT RA_FILIAL ,RA_MAT,RA_NOME "
cQuery+=" FROM "+RetSqlName("SRA")+" SRA "
cQuery+=" WHERE  SRA.RA_DEMISSA='' AND ( RA_MAT = '"+cMatricula+"' AND SRA.D_E_L_E_T_<>'*')"

TCQUERY cQuery Alias QTMP New
dbSelectArea("QTMP") 

dbGotop()  
If EOF()
    lRet:=.f.
  	MSGBOX("Matricula n�o existe")
else 
   M->CTT_RESPON:=QTMP->RA_NOME
EndIf  

dbCloseArea("QTMP")	
RestArea(aArea)


Return(lRet)   

