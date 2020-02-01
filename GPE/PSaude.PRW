
#include "rwmake.ch"        
#include "TopConn.ch"
#include "Ap5mail.ch"


User Function PSaude() 
****************************************************************************************************************
*
*
*****
 
Local nVer458:=0
Local nVer747:=0
Local aVerb  :={} 
Local nExed  :=0  
Local nVerb  :=0
Local i := 0
	
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


Return()


