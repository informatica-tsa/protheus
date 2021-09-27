#INCLUDE "totvs.ch"
#INCLUDE "protheus.ch"
#INCLUDE "rwmake.ch"

//-------------------------------------------------------------------
/* {Protheus.doc} MT160GRPC
Ponto de Entrada a cada geração de item PC na analise de cotação

@protected TSA
@author    Alex T. Souza
@since     16/09/2019

Alteracoes Realizadas desde a Estruturacao Inicial
Data       Programador     Motivo
/*/
//-------------------------------------------------------------------
User Function MT160GRPC()
Local aAreaAnt	:= {SC1->(GetArea()),SC7->(GetArea()),GetArea()}

//Reposiciona SC1
SC1->(DbSetOrder(1))
If SC1->(DbSeek(xFilial("SC1")+SC7->C7_NUMSC+SC7->C7_ITEMSC))

	RecLock('SC7',.F.)
	SC7->C7_ZDTENT	:= SC1->C1_ZDTENT
	SC7->C7_ZPRJ  	:= SC1->C1_ZPRJ
	SC7->C7_ZTARE 	:= SC1->C1_ZTARE
	SC7->(MsUnlock())	
	
	RecLock('SC8',.F.)
	SC8->C8_ZDTENT	:= SC1->C1_ZDTENT
	SC8->C8_ZPRJ  	:= SC1->C1_ZPRJ
	SC8->C8_ZTARE 	:= SC1->C1_ZTARE
	SC8->(MsUnlock())		
	
EndIf

//Ajusta Area de Trabalho
aEval(aAreaAnt, {|aArea| RestArea(aArea)})

Return