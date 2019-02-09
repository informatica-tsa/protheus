#Include 'Protheus.ch'
#Include 'FWMVCDef.ch'

//-------------------------------------------------------------------------------
/*/{Protheus.doc} FSCOMP01
Grava informacoes complementares na cotacao
        
@author 	Leandro de Faria
@since 		11/09/2017

@version 	P12.1.006
@Project	Migracao V12
/*/ 
//-------------------------------------------------------------------------------
User Function FSCOMP01()

Local aAreas   := {SC8->(GetArea(),GetArea())}
Local cNumCot  := SC8->C8_NUM
Local cNumSol  := SC8->C8_NUMSC
SC1->(dbSetOrder(1))
SC8->(dbSetOrder(4)) //INDICE 4 = C8_FILIAL+C8_NUM+C8_IDENT+C8_PRODUTO

If SC1->(dbSeek(xFilial("SC1")+cNumSol))  
	Do While SC1->( !Eof())
		if(SC1->C1_NUM != cNumSol )
			EXIT
		EndIf
		If SC8->(dbSeek(xFilial("SC8")+cNumCot+SC1->C1_ITEM+SC1->C1_PRODUTO))
		    SC8->(RecLock("SC8",.F.))
		        SC8->C8_XCO     :=  SC1->C1_XCO
		        SC8->C8_XCLASSE :=  SC1->C1_XCLASSE     
		        SC8->C8_XOPER   :=  SC1->C1_XOPER
		        SC8->C8_XORCAME :=  SC1->C1_XORCAME
		        SC8->C8_XPCO    :=  SC1->C1_XPCO 
		        SC8->C8_XPCO1   :=  SC1->C1_XPCO1
		    SC8->(MsUnlock())
		EndIf
		SC1->(dbSkip())
	End Do 
EndIf
AEval(aAreas, {|x| RestArea(x)})

Return Nil