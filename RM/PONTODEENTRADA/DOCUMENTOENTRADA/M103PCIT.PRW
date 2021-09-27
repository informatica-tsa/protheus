#INCLUDE "totvs.ch"
#INCLUDE "protheus.ch"
#INCLUDE "rwmake.ch"

//-------------------------------------------------------------------
/* {Protheus.doc} M103PCIT
Ponto de Entrada Doc. Entrada - Manipulacao aCol apos vinculo com pedido

@protected TSA
@author    Alex T. Souza
@since     16/09/2019

Alteracoes Realizadas desde a Estruturacao Inicial
Data       Programador     Motivo
/*/
//-------------------------------------------------------------------
User Function M103PCIT()
Local nPosPc		:= aScan(aHeader,{|x| AllTrim(x[2])=="D1_PEDIDO"})
Local nPosItem   	:= aScan(aHeader,{|x| AllTrim(x[2])=="D1_ITEM"})
Local nPosDtEnt		:= aScan(aHeader,{|x| AllTrim(x[2])=="D1_ZDTENT"})
Local nPosPrj		:= aScan(aHeader,{|x| AllTrim(x[2])=="D1_ZPRJ"})
Local nPosTare		:= aScan(aHeader,{|x| AllTrim(x[2])=="D1_ZTARE"})
Local nPosItPc		:= 0
 	
 	If nPosPrj <> 0 .and. nPosTare <> 0
		If (nPosItPc := ascan(aCols,{|x|  Alltrim(x[nPosPc]) == AllTrim(SC7->C7_NUM) .and. allTrim(x[nPosItem]) == AllTrim(SC7->C7_ITEM) })) > 0
	 		aCols[nPosItPc,nPosDtEnt] 	:= SC7->C7_ZDTENT
	 		aCols[nPosItPc,nPosPrj] 	:= SC7->C7_ZPRJ
	 		aCols[nPosItPc,nPosTare] 	:= SC7->C7_ZTARE
	 	Endif
 	Endif 									 

Return 
