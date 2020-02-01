#include "rwmake.ch"        
#include "TopConn.ch"        

User Function IMPSRA()        
************************************************************************************************************************
*
*
*****

aPerg:={}
AADD(aPerg,{"IMPSRA","INFORME O ALIAS DA TABELA","C",03,0,"C","","","","","","",""})


Pergunte("IMPSRA",.T.)

cQuery:="DELETE "+RetSqlName(MV_PAR01)
TcSqlExec(cQuery)
Processa( {|| XGRVSRA() },"Gravando "+MV_PAR01+"...","Aguarde..." )

Return()        



Static Function XGRVSRA()
***********************************************************************************************************************
* Rotina que gera oFluxo Economico Baseado nos lançamentos contábeis
*
*
******  

Local aArqs:={}
Local nCnt := 0
Local xCont := 0

AADD(aArqs,MV_PAR01)


For xCont := 1 To Len(aArqs)
	
	IncProc("Importando Arquivo:"+RetSqlName(aArqs[xCont]))                 
	
	cQuery:= " SELECT * FROM "+RetSqlName(aArqs[xCont])+"_ASM "
	TcQuery cQuery Alias QSRA New	
	cAlias:=(aArqs[xCont])
	dbSelectArea("QSRA")
	dbGotop()
	While !QSRA->(Eof())
	    
		//Cria as Variáveis
		aCmp:={}
		For nCnt := 1 To (cAlias)->(FCount())
			xPos:=QSRA->(FieldPos((cAlias)->(FieldName(nCnt))))
			If xPos > 0
				Aadd(aCmp,{(cAlias)->(FieldName(nCnt)),CriaVar((cAlias)->(FieldName(nCnt)),.T.)})
				xValCampo:=""
				Do Case
				 Case ValType(aCmp[LEN(aCmp),2])='C'
					Do Case
						Case ValType(QSRA->(FieldGet(xPos)))='D'
							xValCampo:=Dtos(QSRA->(FieldGet(xPos)))
						Case ValType(QSRA->(FieldGet(xPos)))='N'
							xValCampo:=Alltrim(Str(QSRA->(FieldGet(xPos)),12,2))
						OtherWise
							xValCampo:=QSRA->(FieldGet(xPos))
					EndCase	
					
				 Case ValType(aCmp[LEN(aCmp),2])='N'
					Do Case
						Case ValType(QSRA->(FieldGet(xPos)))='C'
							xValCampo:=Val(QSRA->(FieldGet(xPos)))
						Case ValType(QSRA->(FieldGet(xPos)))='D'
							xValCampo:=Val(Dtos(QSRA->(FieldGet(xPos))))
						OtherWise	
						xValCampo:=QSRA->(FieldGet(xPos))						
					EndCase				 
				 Case ValType(aCmp[LEN(aCmp),2])='D'
					Do Case
						Case ValType(QSRA->(FieldGet(xPos)))='C'
							xValCampo:=Stod(QSRA->(FieldGet(xPos)))
						Case ValType(QSRA->(FieldGet(xPos)))='N'
							xValCampo:=Stod(Strzero(Val(QSRA->(FieldGet(xPos))),4))
						OtherWise
							xValCampo:=QSRA->(FieldGet(xPos))	
					EndCase				 
					
				 OtherWise
					  ////	xValCampo:=QSRA->(FieldGet(xPos))			 	
				 EndCase
				aCmp[LEN(aCmp),2]:=xValCampo	
			Endif
			
		Next nCnt
		
		dbSelectarea(cAlias)
		Begin Transaction
			
			RecLock(cAlias,.T.)
			For nCnt:=1 to Len(aCmp)	
				
				cCmp:=cAlias+"->"+aCmp[nCnt,1]
				
				If ValType(&cCmp)==ValType(aCmp[nCnt,2])
			   	&cCmp:=aCmp[nCnt,2]
			   Endif
			Next nCnt	
			MsUnlock() 
			
		aCmp:={}
		End Transaction
	   dbSelectArea("QSRA")
	   dbSkip()
	EndDo
	dbSelectArea("QSRA")
	dbCloseArea()
	dbSelectArea("SRA")
	MsgBox("Arquivo..:"+aArqs[xCont])
Next xCont

Return()