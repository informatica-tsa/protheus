#include "protheus.ch"
#Include "RwMake.ch"
#Include "Colors.ch"
#INCLUDE "topconn.ch"

user function zNumSA2()

Local cNum := NIL
Local aArea := getarea()
Local nIncre := 1
Local cQuery := "SELECT MAX(A2_COD) AS ULTIMO_COD FROM "+RetSqlName("SA2")+" WHERE D_E_L_E_T_ = '' AND LEN(A2_COD) = 6 AND ISNUMERIC(A2_COD) = 1"

		TCQUERY cQuery Alias "ZSA2" NEW 
				
		dbSelectArea("ZSA2")
		dbGotop()                                                
		
		if !Eof()
			//Transformar o conteudo de alfa para numerico e somar 1
			nNum := val(ZSA2->ULTIMO_COD)+nIncre
			//Retornar o contador para alfa, com zeros a esquerda
			cNum:=StrZero(nNum,6)
		Else
			cNum := 'ZZZZZZ'
		EndIf
		
		dbSelectArea("ZSA2")
		dbCloseArea()
		
		RestArea(aArea)

return cNum


/*
user function zValSA2(cCod)

Local lRet := .F.

	If(IsDigit( cCod ) .AND. LEN(ALLTRIM(cCod)) = 6 )
		lRet := .T.
	EndIf

return lRet*/