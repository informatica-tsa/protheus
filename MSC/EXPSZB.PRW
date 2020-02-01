#include "rwmake.ch"        // incluido pelo assistente de conversao do AP5 IDE em 25/06/01

User Function EXPSZB()        // incluido pelo assistente de conversao do AP5 IDE em 25/06/01

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Declaracao de variaveis utilizadas no programa atraves da funcao    ³
//³ SetPrvt, que criara somente as variaveis definidas pelo usuario,    ³
//³ identificando as variaveis publicas do sistema utilizadas no codigo ³
//³ Incluido pelo assistente de conversao do AP5 IDE                    ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

SetPrvt("AARQ,CCTRINI,CCTRFIM,NLASTKEY,NVALFAT,CINDEX")
SetPrvt("NINDEX,")

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³ ACERSAL  ³ Autor ³Eduardo Carraro        ³ Data ³ 31/08/00 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡ao ³ Rotina para Acerto do valor Faturado e Saldos dos Contratos³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Especifico para EPC/TSA                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß

*/


Processa( {|| Acerta() },"Recalculo dos Valores dos Contratos","Recalculando Registro ..." )// Substituido pelo assistente de conversao do AP5 IDE em 25/06/01 ==> Processa( {|| Execute(Acerta) },"Recalculo dos Valores dos Contratos","Recalculando Registro ..." )


*****************************************************************************
* Rotina de Recalculo
********************


Return(nil)        // incluido pelo assistente de conversao do AP5 IDE em 25/06/01

// Substituido pelo assistente de conversao do AP5 IDE em 25/06/01 ==> Function Acerta
Static Function Acerta()

Local xNewReg := 0 

aArq    := { Alias(), IndexOrd(), Recno() }
nImp    :=0
naImp   :=0
nLastKey:= 0
nValFat := 0

dbSelectArea('SZI')
cIndex:= CriaTrab(NIL,.F.)
IndRegua("SZI",cIndex,"ZI_FILIAL+ZI_CCUSTO+ZI_MESANO+ZI_REVISAO+ZI_ITEMORC+ZI_DESCRI",,,"Selecionando Registros ...")

DbSelectArea("SZB") //Contrato
DbGotop()

ProcRegua(Reccount())
While !Eof()
//   iF SZB->ZB_DESCRI='08059'
	   IncProc("Recalculando Registro: "+SZB->ZB_CCUSTO+'-'+SZB->ZB_DESCRI)
	   For xNewReg := 1 to 12
			cMes:='SZB->ZB_MES'+StrZero(xNewReg,2)
			cHRMES:= 'SZB->ZB_HRMES'+StrZero(xNewReg,2)
			cMesAno:=StrZero(xNewReg,2)+'/'+SZB->ZB_ANO
			If &cMes>0
				dbSelectArea('SZI')
				dbSeek(xfilial('SZI')+SZB->ZB_CCUSTO+cMesAno+SZB->ZB_REVISAO+SZB->ZB_ITEMORC+SZB->ZB_DESCRI,.F.)
			    IF EOF()
	    		    If  RecLock("SZI",.t.)
	    		    	///Grava os Dados na Tabela SZI 
	    		    	Replace ZI_FILIAL With xFilial('SZI'),;
	    		    	        ZI_CCUSTO With SZB->ZB_CCUSTO,;  
			    		    	ZI_MESANO With cMesAno ,;  
			    		    	ZI_ANO     With SZB->ZB_ANO ,;  
			    		    	ZI_REVISAO With SZB->ZB_REVISAO ,;  
			    		    	ZI_ITEMORC With SZB->ZB_ITEMORC,;  
			    		    	ZI_DESCRI  With SZB->ZB_DESCRI,;  
			    		    	ZI_DESC2   With SZB->ZB_DESC2,;  
			    		    	ZI_RENDI   With SZB->ZB_RENDI,;  
			    		    	ZI_HORAMES With &cHRMES,;  
			    		    	ZI_VALRMES With &cMES,;  
			    		    	ZI_GRUPGER With SZB->ZB_GRUPGER  
	    		    	MsUnlock()
	    		    	naImp++
	    		    	
	    		    Endif
	    		Else    
	   		    	nImp++
			    Endif
			Endif
 	   Next xNewReg
// 	Endif   
    nLastKey := LastKey()
	If (nLastKey == 27)
		Return
	EndIf
   DbSelectArea("SZB")
   DbSkip()
Enddo

//Restaurando Ambiente
DbSelectArea(aArq[1])
DbSetOrder(aArq[2])
DbGoTo(aArq[3])
RetIndex("SF2")
MsgBox("Registros Importados:"+strZero(nImp,5)+'--'+strZero(naImp,5),"Termino","INFO")

Return
