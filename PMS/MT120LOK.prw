#INCLUDE "totvs.ch"
#INCLUDE "protheus.ch"
#INCLUDE "rwmake.ch"

//-------------------------------------------------------------------
/* {Protheus.doc} MT120LOK
Ponto de Entrada Doc Entrada 
Utilizado para validação saldo do projeto TSA 

@protected TSA
@author    Alex T. Souza
@since     12/09/2019

Alteracoes Realizadas desde a Estruturacao Inicial
Data       Programador     Motivo
/*/
//-------------------------------------------------------------------
User Function MT120LOK()
Local aArea 		:= GetArea()
Local nPosItem		:= aScan(aHeader,{|x| AllTrim(x[2]) == "C7_ITEM"})
Local nPSC7DtPrf   	:= aScan(aHeader,{|x| AllTrim(x[2]) == "C7_DATPRF"})
Local nPosQtd 		:= aScan(aHeader,{|x| AllTrim(x[2]) == "C7_QUANT"})
Local nPosPrc 		:= aScan(aHeader,{|x| AllTrim(x[2]) == "C7_PRECO"})
Local nPSC7DtEnt   	:= aScan(aHeader,{|x| AllTrim(x[2]) == "C7_ZDTENT"})
Local nPSC7Proj	 	:= aScan(aHeader,{|x| Alltrim(x[2]) == "C7_ZPRJ"})
Local nPSC7Taref 	:= aScan(aHeader,{|x| Alltrim(x[2]) == "C7_ZTARE"})
Local nPNumSC		:= aScan(aHeader,{|x| Alltrim(x[2]) == "C7_NUMSC"})
Local nPIteSC		:= aScan(aHeader,{|x| Alltrim(x[2]) == "C7_ITEMSC"})
Local nPItemCTA		:= aScan(aHeader,{|x| Alltrim(x[2]) == "C7_ITEMCTA"})
Local nPAJ7Item		:= 0
Local nPAJ7Proj		:= 0
Local nPAJ7Taref	:= 0
Local lRet			:= .t.
Local oSaldo
Local nAbatSC		:= 0
Local nAbatPC		:= 0
Local cLog			:= ""
Local cTarefa		:= ""
Local nXi

	//Posiciona SC7 para retirar valor do pedido do saldo
	SC7->(DbSetOrder(1))
	If SC7->(DbSeek(xFilial("SC7")+cA120Num+aCols[n][nPosItem])) 
		nAbatPC += (SC7->C7_QUANT)*SC7->C7_PRECO
	Endif
			
	//Posiciona SC1 para retirar valor da SC do saldo
	SC1->(DbSetOrder(1))
	If SC1->(DBSeek(xFilial('SC1')+aCols[n][nPNumSC]+aCols[n][nPIteSC]))
		 nAbatSC += (SC1->C1_QUANT-SC1->C1_QUJE)*SC1->C1_VUNIT	
	Endif
	
		
	//Verifica se a projeto foi informada
	If Type("_aFSPrj") != "U"
		If Len(_aFSPrj) > 0
			For nXi := 1 to len(_aFSPrj)
				nPAJ7Item		:= aScan(_aFSPrj[nXi],{|x| AllTrim(x[1]) == "AJ7_ITEMPC"})
				nPAJ7Proj		:= aScan(_aFSPrj[nXi],{|x| Alltrim(x[1]) == "AJ7_PROJET"})
				nPAJ7Taref		:= aScan(_aFSPrj[nXi],{|x| Alltrim(x[1]) == "AJ7_TAREFA"})
				
				If nPAJ7Item > 0 .and. nPAJ7Taref > 0
					If aCols[n,nPosItem] == _aFSPrj[nXi,nPAJ7Item,2]
	
						aCols[n,nPSC7Proj] 		:= _aFSPrj[nXi,nPAJ7Proj,2]								
						aCols[n,nPSC7DtEnt] 	:= aCols[n,nPSC7DtPrf]
							
						If !Empty(cTarefa)
							cTarefa += ";"+Alltrim(_aFSPrj[nXi,nPAJ7Taref,2])
						Else
							cTarefa += Alltrim(_aFSPrj[nXi,nPAJ7Taref,2])
						Endif
					Endif		
				Endif
			Next
				
			If  nPAJ7Taref > 0
				aCols[n,nPSC7Taref] 	:= cTarefa
			Endif
		Endif
	Endif			
		
	oSaldo	:= Z_Saldo():New()
			    
	// Valor da linha do PC	 (Quant)*Preco Unitario
		
	If !Empty(Alltrim(aCols[n,nPSC7Proj]))
		
		oSaldo:nValProc		:= aCols[n,nPosQtd]*aCols[n,nPosPrc]    
		
		// Abate valor original do Pedido de Compras
		oSaldo:nAbatSC		:=  nAbatSC 		    		    
		oSaldo:nAbatPC		:=  nAbatPC
			    
		oSaldo:cCodFil 		:= 	xFilial("SC7")
		oSaldo:cCodProj		:=  aCols[n,nPSC7Proj]
		oSaldo:cCodTarefa 	:=  aCols[n,nPSC7Taref]
		oSaldo:dDtEnt		:=  aCols[n,nPSC7DtEnt]
		oSaldo:cCodProc		:= "002"
		oSaldo:cProcesso	:= "Pedido de Compras"
	
		oSaldo:ConsSaldo() 
		oSaldo:Avalia()
						
		If !(oSaldo:lOk)                            
	        If !IsBlind()	                            
	        	nDet := Aviso("Bloqueio de Saldo",oSaldo:cMensagem,{"Fechar"},3)
	        Else
	        	lMsErroAuto := .T.
	        	cLog 		:= "Bloqueio de Saldo"+ CRLF
	        	cLog		+= oSaldo:cMensagem
	        	AutoGRLog(cLog)        	
			Endif	
			lRet := oSaldo:lOk
		Endif	
	Endif
 

	/*
	Comentado 24/06/2021
	Totvs Alex Teixeira de Souza
	If FunName() <> "MATA122"
   		Return(.T.)
	EndIf

	SZO->(dbSetOrder(1))
	SZO->(dbSeek(xFilial("SZO")+GDFieldGet("C7_NUMSC")+GDFieldGet("C7_ITEMSC")+"P"))
    If !SZO->(EOF())
        MsgBox(OemToAnsi("O Contrato selecionado é do tipo PONTUAL. Não"+ chr(13) +"é permitido fazer AE para este tipo de contrato."),OemToAnsi("Atenção"),"INFO")
	    lRet := .F.
    EndIf 
	*/

Return(lRet)

	RestArea(aArea)

Return lRet
