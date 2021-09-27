#INCLUDE "PROTHEUS.CH"
#INCLUDE "FWMVCDEF.CH"

// -------------------------------------------------------------------------------------
/*/{Protheus.doc} M410AGRV
Ponto de Entrada - Final da Gravacao do Pedido de Vendas
@param: Nil
@author: Alex Teixeira de Souza
@since: 14/05/2021
@Uso: SIGAFAT
/*/ 
// -------------------------------------------------------------------------------------
User Function M410AGRV()
Local aArea 	    := GetArea()
Local nOpcx		    := ParamIXB[1]
Local aHeadSC6 	  	:= aClone(aHeader)
Local aColsSC6 	  	:= aClone(aCols)
Local nOrigN      	:= N 
Local nPRateio      := aScan(aHeader,{|x| AllTrim(x[2]) == "C6_RATEIO"} )
Local nPCC	        := aScan(aHeader,{|x| AllTrim(x[2]) == "C6_CC"} )
Local nPItemCta     := aScan(aHeader,{|x| AllTrim(x[2]) == "C6_ITEMCTA"} )
Local nPSubC	    := aScan(aHeader,{|x| AllTrim(x[2]) == "C6_SUBC"} )
Local nPConta	    := aScan(aHeader,{|x| AllTrim(x[2]) == "C6_CONTA"} )
Local nPXCO			:= aScan(aHeader,{|x| AllTrim(x[2]) == "C6_XCO"} )
Local nPXOper		:= aScan(aHeader,{|x| AllTrim(x[2]) == "C6_XOPER"} )
Local nPPRodut		:= aScan(aHeader,{|x| AllTrim(x[2]) == "C6_PRODUTO"} )
Local nXi			:= 0
Local cProduto      := ""
Local cXPCO			:= ""

If nPRateio > 0 .and. !Empty( aRatCTBPC ) .and. (nOpcx == 1)
	nPosPerc  		:= AScan(aRatCTBPC[1][2][1], { |x| Alltrim(x[1]) =="AGG_PERC"} )
	nPosCC			:= AScan(aRatCTBPC[1][2][1], { |x| Alltrim(x[1]) =="AGG_CC"  } )
	nPosConta		:= AScan(aRatCTBPC[1][2][1], { |x| Alltrim(x[1]) =="AGG_CONTA"  } )
	nPosItem		:= AScan(aRatCTBPC[1][2][1], { |x| Alltrim(x[1]) =="AGG_ITEMCT"  } )
	nPosClVl		:= AScan(aRatCTBPC[1][2][1], { |x| Alltrim(x[1]) =="AGG_CLVL"  } )

    For nXi := 1 to len(aColsSC6)   

        aColsSC6[nXi][nPRateio] := "2"

	    cCCusto := aRatCTBPC[nXi][2][1][nPosCC][2]
		cConta  := aRatCTBPC[nXi][2][1][nPosConta][2]
		cItem   := aRatCTBPC[nXi][2][1][nPosItem][2]
		cClVl   := aRatCTBPC[nXi][2][1][nPosClVl][2]

        //aColsSC6[nXi][nPCC] 		:= cCCusto
        //aColsSC6[nXi][nPItemCta] 	:= cCCusto

		cProduto                    := aColsSC6[nXi][nPPRodut]
		aColsSC6[nXi][nPSubC] 		:= cCCusto
		aColsSC6[nXi][nPConta] 		:= Posicione('SB1',1,xfilial('SB1')+cProduto, 'B1_CONTA')
		aColsSC6[nXi][nPXCO] 		:= Posicione('SB1',1,xfilial('SB1')+cProduto, 'B1_CONTA')
		cXPCO						:= aColsSC6[nXi][nPXCO]
		aColsSC6[nXi][nPXOper] 		:= Posicione('CT1',1,xfilial('CT1')+cXPCO, 'CT1_GRUPO2')

		M->C5_CONTRAT				:= Posicione('SZ2',3,xfilial('SZ2')+cCCusto, 'Z2_COD')

    Next

Endif
// Retaura aHeader e aCols original da entrada de NF
aHeader := aHeadSC6 	  
aCols	:= aColsSC6 
N		:= nOrigN  

RestArea(aArea)

Return .T.
