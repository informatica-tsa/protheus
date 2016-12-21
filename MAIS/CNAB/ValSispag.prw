#include "rwmake.ch"
/*
+-----------+------------+----------------+-------------------+-------+---------------+
| Programa  | VALSISPAG  |                                    | Data  | 19/03/2015    |
+-----------+------------+----------------+-------------------+-------+---------------+
| Descricao | Tratamentos necessarios ao CNAB - SISPAG                                |
+-----------+-------------------------------------------------------------------------+
| Modulos   |         SIGAFIN                                                         |
+-----------+-------------------------------------------------------------------------+
| Processos |                                                                         |
+-----------+-------------------------------------------------------------------------+
|                  Modificacoes desde a construcao inicial                            |
+----------+-------------+------------------------------------------------------------+
| DATA     | PROGRAMADOR | MOTIVO                                                     |
+----------+-------------+------------------------------------------------------------+
|          |             |                                                            |
+----------+-------------+------------------------------------------------------------+
*/

User Function VALSISPAG(nOpc,lMuda,lZera)                                               

If Type("nLoteSIS") == "U"
	Public nLoteSIS := 0
EndIf

If Type("nTotLote") == "U"
	Public nTotLote := 0
EndIf

Private cAgCont  := ""
Private nLoteAux := 0
Private cMensagem := ""

If nOpc == 1 //Monta campo de Agencia + Dig. Agencia + Conta + Dig. Conta
	cAgCont := StrZero(Val(SA2->A2_AGENCIA),5)
	cAgCont += StrZero(Val(SA2->A2_NUMCON),13)
	cAgCont += Space(1)+Alltrim(SA2->A2_DVCTA)
	
	If Len(Alltrim(SA2->A2_AGENCIA)) <= 1 .or. Len(Alltrim(SA2->A2_NUMCON)) <= 1
		cMensagem := "Dados Bancarios Invalidos"+Chr(13)+Chr(13)+"Fornecedor: "+SA2->A2_COD+"-"+SA2->A2_LOJA
		cMensagem += " - "+Alltrim(SA2->A2_NOME)+Chr(13)+Chr(13)
		cMensagem += "Banco: "+SA2->A2_BANCO+Chr(13)
		cMensagem += "Agencia: "+SA2->A2_AGENCIA+Chr(13)
		cMensagem += "Conta: "+SA2->A2_NUMCON+"-"+SA2->A2_DGCTA+Chr(13)+Chr(13)
		cMensagem += "Favor ajustar os dados no cadastro do Fornecedor."
		MsgStop(cMensagem)
	EndIf
	
	Return(cAgCont)
	
Endif

If nOpc == 2 //Numeração de Lote exclusiva para cada Segmento
	If lMuda
		nLoteSIS++
	EndIF
	nLoteAux := nLoteSIS
	If lZera
		nLoteSIS := 0
		nLoteAux := 9999
	EndIf
	Return(StrZero(nLoteAux,4))
EndIf

Return()