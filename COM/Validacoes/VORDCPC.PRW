#Include "Rwmake.ch"
/*
+-----------+------------+----------------+------------------+--------+------------+
| Programa  | VORDCPC    | Desenvolvedor  | Davis Magalhaes  | Data   | 30/05/2003 |
+-----------+------------+----------------+------------------+--------+------------+
| Descricao | Valida��o da Digita��o do Para Carregar N� O.C. no Acols do P.Compra |
+-----------+----------------------------------------------------------------------+
| Uso       | Especifico EPC/TSA                                                   |
+-----------+----------------------------------------------------------------------+
|                   Modificacoes Apos Desenvolvimento Inicial                      |
+-------------+---------+----------------------------------------------------------+
| Humano      | Data    | Motivo                                                   |
+-------------+---------+----------------------------------------------------------+
+-------------+---------+----------------------------------------------------------+
*/

User Function VORDCPC()
****************************************************************************************************************************************
*
*
****
Local nPosORDC      := aScan(aHeader,{|x| Alltrim(x[2]) == "C7_ORDCOM" })
Local nPosPROD      := aScan(aHeader,{|x| Alltrim(x[2]) == "C7_PRODUTO" })
Local nContAux      := 0

// Ajuste realizado Totvs 11/11/2019 
// Na integra��o com TOP nao existe essa variavel
If Type("cOrdCom") == "U"
	cOrdCom := Space(6)
Endif	

//CNTA130-> Gera��o do pedido pelo modulo de gest�o de contratos.
If Funname()$'CNTA120/CNTA130' .OR. cOrdCom==Nil
	cOrdCom := Space(6)
Endif

If Empty(cOrdCom)
	Return(cOrdCom)
EndiF


For nContAux = 1 To Len(aCols)
	If Empty(aCols[ nContAux,nPosPROD ])
		Exit
	Endif
	
	If aCols[nContAux ,Len(aHeader)+1] == .F.
		
		aCols[ nContAux,nPosORDC ] := cOrdCom
	EndIf
	
Next nContAux


Return(cOrdCom)
