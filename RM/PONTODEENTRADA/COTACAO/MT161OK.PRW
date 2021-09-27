#INCLUDE "totvs.ch"
#INCLUDE "protheus.ch"
#INCLUDE "rwmake.ch"

//-------------------------------------------------------------------
/* {Protheus.doc} MT161OK
Ponto de Entrada Analise de cotação

@protected TSA
@author    Alex T. Souza
@since     12/09/2019

Alteracoes Realizadas desde a Estruturacao Inicial
Data       Programador     Motivo
/*/
//-------------------------------------------------------------------
User Function MT161OK()
Local aPropostas 	:= PARAMIXB[1] // Array contendo todos os dados da proposta da cotação
Local cTpDoc 		:= PARAMIXB[2] // Tipo do documento
Local lContinua 	:= .T.
Local aAux			:= A161SemPag(aPropostas) //Retira o array de paginas deixando as propostas sequenciais
Local nY,nZ
Local cCodPrj		:= ""
Local cCodTrf		:= ""
Local dDtEnt		:= ctod("")
Local oSaldo
Local nAbatSC		:= 0

	For nY:= 1 To Len(aAux)	 //Array aPropostas desconsiderando paginas
		For nZ:= 1 To Len(aAux[nY,2]) //Array de Itens das aPropostas
			If aAux[nY,2,nZ,1] .And. lContinua //Verifica se é o fornecedor vencedor posicionado
				SC8->(dbGoTo(aAux[nY,2,nZ,9])) //Posiciono no SC8
				
				If Val(SC8->C8_TPDOC)== 1 // Pedido de Compras
				
					//Reposiciona SC1
					SC1->(DbSetOrder(1))
					If SC1->(DbSeek(xFilial("SC1")+SC8->C8_NUMSC+SC8->C8_ITEMSC))
						nAbatSC := (SC1->C1_QUANT-SC1->C1_QUJE)*SC1->C1_VUNIT
					Endif	
					
					cCodPrj		:= SC8->C8_ZPRJ
					cCodTrf		:= SC8->C8_ZTARE
					dDtEnt		:= SC8->C8_ZDTENT	
							
					If !Empty(Alltrim(SC8->C8_ZPRJ))

						oSaldo	:= Z_Saldo():New()
								
						// Valor da linha da Cotacao Quant*Preco Unitario
						oSaldo:nValProc		:= SC8->C8_QUANT*SC8->C8_PRECO    							
									
						oSaldo:nAbatSC		:=  nAbatSC  // Abate valor original da SC vinculada a Cotação							
						oSaldo:cCodFil 		:= 	xFilial("SC8")
						oSaldo:cCodProj		:=  cCodPrj
						oSaldo:cCodTarefa 	:=  cCodTrf
						oSaldo:dDtEnt		:=  dDtEnt
						oSaldo:cCodProc		:= "002"
						oSaldo:cProcesso	:= "Pedido de Compras"	
						
						oSaldo:ConsSaldo() 
						oSaldo:Avalia()
						
						If !(oSaldo:lOk)                            
							If !IsBlind()	                            
								nDet := Aviso("Bloqueio de Saldo",oSaldo:cMensagem,{"Fechar"},3)
							Endif	
							lContinua := oSaldo:lOk
						Endif	
					Endif			
				Endif
			Endif
		Next
	Next	

Return lContinua
