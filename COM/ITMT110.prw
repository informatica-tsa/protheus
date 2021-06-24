#INCLUDE "totvs.ch"
#INCLUDE "protheus.ch"
#INCLUDE "rwmake.ch"

//-------------------------------------------------------------------
/* {Protheus.doc} ITMT110
Ponto de Entrada Solicitacao de Compras 
Utilizado para validação saldo do projeto TSA 

@protected TSA
@author    Alex T. Souza
@since     12/09/2019

Alteracoes Realizadas desde a Estruturacao Inicial
Data       Programador     Motivo
/*/
//-------------------------------------------------------------------
User Function ITMT110()
Local aCab 		:= PARAMIXB[1]
Local aItens 	:= PARAMIXB[2]
Local aRateio 	:= PARAMIXB[3]
Local aPrj 		:= PARAMIXB[4]
Local aRet 		:= {}
Local nXi,nXj	:= 0
Local nPItem	:= 0
Local nPRat		:= 0
Local nPRatCC	:= 0
Local nPVlUn	:= 0
Local cItemSC1	:= ""
Local lAjstIt	:= .t.

If Type("_aFSPrj") == "U"
	Public _aFSPrj	:= aPrj
Else
	_aFSPrj	:= aPrj
Endif

For nXi := 1 to len(aItens)

	
	nPItem		:= aScan(aItens[nXi],{|x| AllTrim(x[1]) == "C1_ITEM"})
	nPRat		:= aScan(aItens[nXi],{|x| AllTrim(x[1]) == "C1_RATEIO"})
	nPVlUn		:= aScan(aItens[nXi],{|x| AllTrim(x[1]) == "C1_VUNIT"})
	nC1XCO		:= aScan(aItens[nXi],{|x| AllTrim(x[1]) == "C1_XCO"})
	lAjstIt		:= .t.
	
	cItemSC1 	:= aItens[nXi,nPItem,2]	

	For nXj := 1 to len(aRateio)
		If aRateio[nXj,1] == cItemSC1
			nPRatCC := aScan(aRateio[nXj,2,1],{|x| AllTrim(x[1]) == "CX_CC"})
			aItens[nXi,nPRat,2] := "2"
			If nPRatCC <> 0 .and. lAjstIt // lAjdIt - Garante que só sera incluida uma vez as colunas por item
				aadd(aItens[nXi],{"C1_CC",aRateio[nXj,2,1,nPRatCC,2],Nil})
				aadd(aItens[nXi],{"C1_ITEMCTA",aRateio[nXj,2,1,nPRatCC,2],Nil})
				lAjstIt := .f.
			Endif	
		Endif
	Next
	
	If nPVlUn <> 0
		aadd(aItens[nXi],{"C1_VLBERBA"	,aItens[nXi,nPVlUn,2],Nil})
		aadd(aItens[nXi],{"C1_XVUNIT"	,aItens[nXi,nPVlUn,2],Nil})
	Endif		

	nPCC		:= aScan(aItens[nXi],{|x| AllTrim(x[1]) == "C1_CC"})
	nPProd      := aScan(aItens[nXi],{|x| AllTrim(x[1]) == "C1_PRODUTO"})

	If nPCC > 0
		cCC    := aItens[nXi,nPCC,2]	
		cProd  := aItens[nXi,nPProd,2]

		cC1XCo := GatCOrc(cCC,cProd)

		aadd(aItens[nXi],{"C1_XPCO"		,"S",Nil})
		aadd(aItens[nXi],{"C1_XPCO1"	,"N",Nil})
		aadd(aItens[nXi],{"C1_XCO"		,cC1XCo,Nil})	

		cXoper := Posicione("CT1",1,xFilial("CT1")+cC1XCo,"CT1_GRUPO2")	
		aadd(aItens[nXi],{"C1_XOPER"	,cXoper,Nil})

	Else	
		aadd(aItens[nXi],{"C1_XPCO"		,"S",Nil})
		aadd(aItens[nXi],{"C1_XPCO1"	,"N",Nil})
		aadd(aItens[nXi],{"C1_XOPER"	,"",Nil})
	Endif
Next

aRateio := {}


//Customizações do cliente
aRet := {aCab,aItens,aRateio,aPrj}

Return aRet

//-------------------------------------------------------------------
/* {Protheus.doc} GatCOrc
Funcao Copia do fonte PCO001 
Necessario utilizar por não existir aHeader e aCols nesse momento 

@protected TSA
@author    Alex T. Souza
@since     14/06/2021

Alteracoes Realizadas desde a Estruturacao Inicial
Data       Programador     Motivo
/*/
//-------------------------------------------------------------------
Static Function GatCOrc(cCC,c1Produto)
Local cXco := ""    


	/******************************************************************************
	SE É FILIAL
	 *****************************************************************************/
	if (SM0->M0_CODFIL >= '01' .and. SM0->M0_CODFIL <= '19')
		cClassi := POSICIONE("CTT", 1, xFilial("CTT")+cCC, "CTT_CLASSI")
				
		DO CASE
			CASE cClassi == 'D'
				cXco := POSICIONE("SB1", 1, xFilial("SB1")+c1Produto, "B1_CTADESP")
			CASE cClassi == 'C'
				cXco := POSICIONE("SB1", 1, xFilial("SB1")+c1Produto, "B1_CTACONS")
			CASE cClassi == 'I'
				cXco := POSICIONE("SB1", 1, xFilial("SB1")+c1Produto, "B1_CTACONS")
		ENDCASE       
	else      
		/******************************************************************************
		SE É CEI
		//Exemplo: 
		//	cei => Conta	
		//	20  => 4163 01 0006
		//	21  => 4163 02 0006
		//	22  => 4163 03 0006
		//	23  => 4163 04 0006
		 *****************************************************************************/
		
		cTemp := POSICIONE("SB1", 1, xFilial("SB1")+c1Produto, "B1_CTACEI")
		cIni = SubStr( cTemp, 1, 4 )
		cFim = SubStr( cTemp, 7, 4 )
		cMeio = PADL(ALLTRIM(STR(VAL(cFilAnt) - 19)),2,"0")
 		cXco := cIni+cMeio+cFim
	Endif             

return cXco

