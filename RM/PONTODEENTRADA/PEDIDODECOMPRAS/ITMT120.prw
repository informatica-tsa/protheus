#INCLUDE "totvs.ch"
#INCLUDE "protheus.ch"
#INCLUDE "rwmake.ch"

//-------------------------------------------------------------------
/* {Protheus.doc} ITMT120
Ponto de Entrada Solicitacao de Compras 
Utilizado para validação saldo do projeto TSA 

@protected TSA
@author    Alex T. Souza
@since     12/09/2019

Alteracoes Realizadas desde a Estruturacao Inicial
Data       Programador     Motivo
/*/
//-------------------------------------------------------------------
User Function ITMT120()
Local aCab 		:= PARAMIXB[1]
Local aItens 	:= PARAMIXB[2]
Local aRateio 	:= PARAMIXB[3]
Local aPrj 		:= PARAMIXB[4]
Local aRet 		:= {}
Local nXi,nXj	:= 0

If Type("_aFSPrj") == "U"
	Public _aFSRat	:= aRateio
Else
	_aFSRat	:= aRateio
Endif	

/*
For nXi := 1 to len(aItens)

	nPItem		:= aScan(aItens[nXi],{|x| AllTrim(x[1]) == "C7_ITEM"})
	nPRat		:= aScan(aItens[nXi],{|x| AllTrim(x[1]) == "C7_RATEIO"})
	lAjstIt		:= .t.
	cItemSC1 	:= aItens[nXi,nPItem,2]	

	For nXj := 1 to len(aRateio)
		If aRateio[nXj,1] == cItemSC1
			nPRatCC 	:= aScan(aRateio[nXj,2,1],{|x| AllTrim(x[1]) == "CH_CC"})
			nPRatCTA 	:= aScan(aRateio[nXj,2,1],{|x| AllTrim(x[1]) == "CH_ITEMCTA"})
			aItens[nXi,nPRat,2] := "2"
			If nPRatCC <> 0 .and. lAjstIt // lAjdIt - Garante que só sera incluida uma vez as colunas por item
				aadd(aItens[nXi],{"C7_CC",aRateio[nXj,2,1,nPRatCC,2],Nil})
				aadd(aItens[nXi],{"C7_ITEMCTA",aRateio[nXj,2,1,nPRatCTA,2],Nil})
				lAjstIt := .f.
			Endif	
		Endif
	Next

	aadd(aItens[nXi],{"C7_XPCO"		,"S",Nil})
	aadd(aItens[nXi],{"C7_XOPER"	,"",Nil})
	
Next
*/

If Type("_aFSPrj") == "U"
	Public _aFSPrj	:= aPrj
Else
	_aFSPrj	:= aPrj
Endif	

//Customizações do cliente

aRet := {aCab,aItens,aRateio,aPrj}

Return aRet


