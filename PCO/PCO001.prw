#include "rwmake.ch" 
#Include "TopConn.ch"

/******************************************************************************
 * Descr	Gatilho  para  preenchimento  da  Conta Contabil  no  cadastro de 
 * 			produtos  com o valor  do campo  C1_CC eu preencho o campo C1_XCO       
 * Data		12/11/2013
 * Autor	Leandro P J Monteiro - CN Tecnologia 	
 *			leandro@cntecnologia.com.br
 *****************************************************************************/
User Function PCO001 (cCC)
   
	if Empty(cCC) 
		cCC := M->C1_CC
	endif
	               
	nPProduto 	:= aScan(aHeader,{|aAux|alltrim(aAux[2]) == "C1_PRODUTO"	})
	nPXCO		:= aScan(aHeader,{|aAux|alltrim(aAux[2]) == "C1_XCO"		})
	
	IF ALLTRIM(ACOLS[N,nPProduto])<>""		
		c1Produto := ACOLS[N,nPProduto ]
	endif

	cXco := ''

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
 		
	endif             
	                          
	ACOLS[N,nPXCO] := cXco

return cXco