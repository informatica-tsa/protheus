#include "rwmake.ch"        
#include "TopConn.ch"
#include "Ap5mail.ch"


User Function GSaude() 
****************************************************************************************************************
*
*
*****          

Local nVer458:=0
Local nVer747:=0
Local aVerb  :={} 
Local nExed  :=0 
Local cQuery1   :=""
Local i := 0

Alert('GSaude')
 
  
aPerg := {}
cPerg :="GSAUDE"
AADD(aPerg,{cPerg,"Calcular em Ordem de ?","N",1,0,"C","",""   ,"Matricula","Centro de Custo","","",""}) 
AADD(aPerg,{cPerg,"Filial De? ","C",02,0,"G","",""       ,"","","","",""}) 
AADD(aPerg,{cPerg,"Filial Até?","C",02,0,"G","",""       ,"","","","",""}) 
AADD(aPerg,{cPerg,"Centro de Custo De?","C",06,0,"G","",""   ,"","","","",""}) 
AADD(aPerg,{cPerg,"Centro de Custo Até?","C",06,0,"G","",""  ,"","","","",""}) 
AADD(aPerg,{cPerg,"Matricula De?","C",06,0,"G","",""   ,"","","","",""}) 
AADD(aPerg,{cPerg,"Matricula  Até?","C",06,0,"G","",""  ,"","","","",""})  
AADD(aPerg,{cPerg,"Semana?","C",02,0,"G","",""   ,"","","","",""})  
AADD(aPerg,{cPerg,"Data de Pagamento ?","D",08,0,"G","","","","","","",""})
AADD(aPerg,{cPerg,"Taref. Periodo De ?","D",08,0,"G","","","","","","",""})



Pergunte(cPerg,.T.)    

Private cOrdem  := MV_PAR01
Private cFiliAt := MV_PAR02
Private cFiliDe := MV_PAR03
Private cCCusDe := MV_PAR04 
Private cCCusAt := MV_PAR05
Private cMatrDe := MV_PAR06 
Private cMatrAt := MV_PAR07
Private cSemana := MV_PAR08
Private cPagame := MV_PAR09
Private cPeriod := MV_PAR10 

dbSelectArea("SRA") 
                                    

cQuery1:=" SELECT RA_FILIAL,RA_MAT,RA_NOME,RA_CC,RA_SALARIO,RA_CATFUNC,R_E_C_N_O_"
cQuery1+=" FROM "+RetSqlName("SRA")+" SRA "
//cQuery1+=" INNER JOIN "+RetSqlName("SA2")+" SA2 ON (A2_COD=ZW_CODFOR AND SA2.D_E_L_E_T_<>'*' ) "
//cQuery1+=" LEFT OUTER JOIN "+RetSqlName("SRA")+" SRARES ON (SRARES.RA_MAT=CTT_MATRES AND SRARES.D_E_L_E_T_<>'*') " 
cQuery1+=" WHERE SRA.D_E_L_E_T_<>'*'AND RA_DEMISSA='' AND RA_FILIAL <>'97'"  
cQuery1+=" AND RA_MAT BETWEEN   '"+cMatrDe+"'AND '"+cMatrAt+"'"
cQuery1+=" AND RA_CC BETWEEN    '"+cCCusDe+"'AND '"+cCCusAt+"'"
If cOrdem = 1
	cQuery1+=" Order By RA_MAT"  
	ELSE
	cQuery1+=" Order By RA_CC"		
Endif   	
	 
TCQUERY cQuery1 Alias QTMP1 New

dbSelectArea("QTMP1")
dbGotop() 
While !Eof()
    //Posiciona na tabela SZW
    dbSelectArea("SRA")
    dbGoto(QTMP1->R_E_C_N_O_)
    dbSelectArea("QTMP1")  
    
	If SRA->RA_SEGUROV = '01' .AND. SRA->RA_CATFUNC='M'

	//Gerar Verba Seguro de Vida
	If SRA->RA_SALARIO*30<=71.355
		AADD(aVerb,{'752',SRA->RA_SALARIO*30})        
	Else
		AADD(aVerb,{'752',71.355})        
	Endif
	//Gerar Verba de Desconto
	If (SRA->RA_SALARIO * 0.35978)/100 <= 8.57
		AADD(aVerb,{'458',SRA->RA_SALARIO * 0.35978/100})
	Else 	  		
		AADD(aVerb,{'458',8.57})			
	EndIf 
	//Gerar Verba Custo Empresa  
	    nVerb:=aVerb[2,2]
		nExed:=(SRA->RA_SALARIO * 0.53973)/100
	If nExed + aVerb[2,2] <= 21.41
		AADD(aVerb,{'747',nExed})
	Else 	  		
		AADD(aVerb,{'747',(21.41-8.57)})				
	EndIf	                                
	//Gerar Fatura
		AADD(aVerb,{'780',aVerb[2,2]+aVerb[3,2]})		
  //Gerar Verba 843 Seguro Metlyfe
		AADD(aVerb,{'843',((SRA->RA_SALARIO*20)*0.063725)/1000})  
   
   For i := 1 to 5
	  		dbSelectArea("SRC")    		
	  		RecLock('SRC',!dbSeek(SRA->RA_FILIAL+SRA->RA_MAT+aVerb[i,1]+SRA->RA_CC))
	  		Replace RC_FILIAL With SRA->RA_FILIAL 
	  		Replace RC_MAT    With SRA->RA_MAT
	  		Replace RC_CC     With SRA->RA_CC	  		
	  		Replace RC_tipo1  With 'V'
	  		Replace RC_tipo2  With 'C'
	  		Replace RC_DATA   With Date()	 
	  		Replace RC_PD     With aVerb[i,1]
			Replace RC_VALOR  With aVerb[i,2]			
	MsunLock()
	Next
EndIf

If SRA->RA_SEGUROV = '01' .AND. SRA->RA_CATFUNC='E'
	
		//Gerar Verba Seguro de Vida
	If SRA->RA_SALARIO*30<=71.355
		AADD(aVerb,{'752',SRA->RA_SALARIO*30})        
	Else
		AADD(aVerb,{'752',71.355})        
	Endif
	//Gerar Verba Custo Empresa
	If (SRA->RA_SALARIO* 0.53973)/100 <= 21.41
		AADD(aVerb,{'747',(SRA->RA_SALARIO * 0.53973)/100})
	Else 	  		
		AADD(aVerb,{'747',21.41})				
	EndIf	                                
	//Gerar Fatura
		AADD(aVerb,{'780',aVerb[2,2]})		
  //Gerar Verba 843 Seguro Metlyfe
		AADD(aVerb,{'843',((SRA->RA_SALARIO*20)*0.063725)/1000})  
   
   For i:=1 to 4
	  		dbSelectArea("SRC")    		
	  		RecLock('SRC',!dbSeek(SRA->RA_FILIAL+SRA->RA_MAT+aVerb[i,1]+SRA->RA_CC))
	  		Replace RC_FILIAL With SRA->RA_FILIAL                      
	  		Replace RC_MAT    With SRA->RA_MAT
	  		Replace RC_CC     With SRA->RA_CC	  		
	  		Replace RC_tipo1  With 'V' 
	  		Replace RC_tipo2  With 'C'
	  		Replace RC_DATA   With Date()
	  		Replace RC_PD     With aVerb[i,1]
			Replace RC_VALOR  With aVerb[i,2]			
	MsunLock()
	Next
EndIf			 
	dbSelectArea("QTMP1")
	dbSkip()
EndDo
dbCloseArea("QTMP1")
Return()
