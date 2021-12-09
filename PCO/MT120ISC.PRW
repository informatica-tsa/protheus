#INCLUDE "totvs.ch"
#INCLUDE "protheus.ch"
#INCLUDE "rwmake.ch"

//-------------------------------------------------------------------
/* {Protheus.doc} MT120ISC
Ponto de Entrada F4 Pedido de Compras 
Manipulacao aCol apos vinculo com solicitacao de compras

@protected TSA
@author    Alex T. Souza
@since     16/09/2019

Alteracoes Realizadas desde a Estruturacao Inicial
Data       Programador     Motivo
/*/
//-------------------------------------------------------------------
User Function MT120ISC()
Local nPosDTEnt  := aScan(aHeader,{|x| AllTrim(x[2]) == "C7_ZDTENT"})
Local nPosPrj 	 := aScan(aHeader,{|x| AllTrim(x[2]) == "C7_ZPRJ"})
Local nPosTare	 := aScan(aHeader,{|x| AllTrim(x[2]) == "C7_ZTARE"})
Local aArea 	 := GetArea()

	If nPosDTEnt <> 0 .and. nTipoPed !=	2
		aCols[n][nPosDTEnt] := SC1->C1_ZDTENT
	Endif

	If nPosPrj <> 0 .and. nTipoPed !=	2
		aCols[n][nPosPrj] := SC1->C1_ZPRJ
	Endif

	If nPosTare <> 0 .and. nTipoPed !=	2
		aCols[n][nPosTare] := SC1->C1_ZTARE
	Endif

	// Chamada de fonte TSA 24/06/2021
	TSAFunc()

	RestArea(aArea)

Return 

//-------------------------------------------------------------------
/* {Protheus.doc} MT120ISC
Ponto de Entrada F4 Pedido de Compras 
Manipulacao aCol apos vinculo com solicitacao de compras

@protected TSA
@author    Alex T. Souza
@since     16/09/2019

Alteracoes Realizadas desde a Estruturacao Inicial
Data       Programador     Motivo
//-------------------------------------------------------------------
Alex Teixeira de Souza
Fonte anterior TSA MT100LOK
Ajustado para funçaõ TSAFunc para compatibilização com projeto TOP 24/06/2021
//-------------------------------------------------------------------
*/

Static Function TSAFunc()
Local n
//LOCAL ctes  

dBSelectArea('SB1')
dbSetOrder(1)
dbSeek(xFilial("SB1")+SC1->C1_PRODUTO)
//ctes    := SB1->B1_TE 

nPos1 := aScan(aHeader,{|aAux|alltrim(aAux[2]) == "C7_XORCAME"})
nPos2 := aScan(aHeader,{|aAux|alltrim(aAux[2]) == "C7_XCO"})
nPos3 := aScan(aHeader,{|aAux|alltrim(aAux[2]) == "C7_XCLASSE"})
nPos4 := aScan(aHeader,{|aAux|alltrim(aAux[2]) == "C7_XOPER"})
nPos5 := aScan(aHeader,{|aAux|alltrim(aAux[2]) == "C7_DATPRF"})
nPos6 := aScan(aHeader,{|aAux|alltrim(aAux[2]) == "C7_XPCO"})
//nPos7 := aScan(aHeader,{|aAux|alltrim(aAux[2]) == "C7_NFROTA"}) 
nPos8 := aScan(aHeader,{|aAux|alltrim(aAux[2]) == "C7_XPCO1"})  

n:=len(aCols)
ACOLS[N,nPos1]:=SC1->C1_XORCAME  
ACOLS[N,nPos2]:=SC1->C1_XCO
ACOLS[N,nPos3]:=SC1->C1_XCLASSE
ACOLS[N,nPos4]:=SC1->C1_XOPER
ACOLS[N,nPos5]:=CTOD(" / / ")
ACOLS[N,nPos6]:=SC1->C1_XPCO 
//ACOLS[N,nPos7]:=SC1->C1_NFROTA
ACOLS[N,nPos8]:=SC1->C1_XPCO1	

       
Return
