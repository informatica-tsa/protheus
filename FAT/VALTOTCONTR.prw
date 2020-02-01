/*
+----------+-----------+----------+-------------------------+------+-----------+
|Programa  |VALTOTCONTR| Autor    | Daniel A. Moreira       |Data  |21.02.2006 |
+----------+-----------+----------+-------------------------+------+-----------+
|Descricao | Valida total do contrato com o total de eventos                   |
+----------+-------------------------------------------------------------------+
| USO      | Especifico TSA                                                    |
+----------+-------------------------------------------------------------------+
|                    ALTERACOES FEITAS DESDE A CRIACAO                         |
+----------+-----------+-------------------------------------------------------+
|Autor     | Data      | Descricao                                             |
+----------+-----------+-------------------------------------------------------+
|          |           |                                                       |
+----------+-----------+-------------------------------------------------------+
*/  

User Function VALTOTCONTR

Local nSoma := 0
Local nXi := 0

If !Empty(GdFieldGet("Z3_DTFATUR",n))
	MsgStop("Evento já faturado! Não é permito alteração de valor!")
	Return(.F.)
EndIf

For nXi := 1 To Len(aCols)
	If nXi<>n   
		nSoma += GdFieldGet("Z3_VALOR",nXi)
	Else
		nSoma += M->Z3_VALOR
	EndIf
	If nSoma > SZ1->Z1_VRPREV
		MsgStop("Valores dos Eventos maior que o valor do Contrato!")	
		Exit
	EndIf	
Next nXi


Return(.T.)


