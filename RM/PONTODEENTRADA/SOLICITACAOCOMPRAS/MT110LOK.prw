#INCLUDE "totvs.ch"
#INCLUDE "protheus.ch"
#INCLUDE "rwmake.ch"

//-------------------------------------------------------------------
/* {Protheus.doc} MT110LOK
Ponto de Entrada Solicitacao de Compras 
Utilizado para validação saldo do projeto TSA 

@protected TSA
@author    Alex T. Souza
@since     12/09/2019

Alteracoes Realizadas desde a Estruturacao Inicial
Data       Programador     Motivo
/*/
//-------------------------------------------------------------------
User Function MT110LOK()
Local aArea 		:= GetArea()
Local nPSC1Num		:= aScan(aHeader,{|x| AllTrim(x[2]) == "C1_NUM"})
Local nPSC1Item		:= aScan(aHeader,{|x| AllTrim(x[2]) == "C1_ITEM"})
Local nPSC1DtPrf   	:= aScan(aHeader,{|x| AllTrim(x[2]) == "C1_DATPRF"})
Local nPSC1DtEnt   	:= aScan(aHeader,{|x| AllTrim(x[2]) == "C1_ZDTENT"})
Local nPSC1Proj	 	:= aScan(aHeader,{|x| Alltrim(x[2]) == "C1_ZPRJ"})
Local nPSC1Taref 	:= aScan(aHeader,{|x| Alltrim(x[2]) == "C1_ZTARE"})
Local nPSC1Total	:= aScan(aHeader,{|x| Alltrim(x[2]) == "C1_TOTAL"})
Local nPSC1Qtd		:= aScan(aHeader,{|x| Alltrim(x[2]) == "C1_QUANT"})
Local nPSC1QTDEn	:= aScan(aHeader,{|x| Alltrim(x[2]) == "C1_QUJE"})
Local nPSC1Val		:= aScan(aHeader,{|x| Alltrim(x[2]) == "C1_VUNIT"})	
Local nPAFGItem		:= 0
Local nPAFGProj		:= 0
Local nPAFGTaref	:= 0
Local nPosSC1		:= 0
Local oSaldo
Local nAbatSC		:= 0
Local lRet			:= .t.
Local cFilSC1		:= xFilial("SC1")
Local cLog			:= ""
Local cTarefa		:= ""
Local cIDTarefa		:= ""

Local cMarca		:= ""
Local cPrjVer			:= RTrim(PmsMsgUVer('PROJECT',			'PMSA200')) //Versão do Projeto
Local cTrfVer			:= RTrim(PmsMsgUVer('TASKPROJECT',		'PMSA203')) //Versão da Tarefa
Local nXi

	SC1->(dbSetOrder(1))
	If SC1->(dbSeek(cFilSC1+cA110Num+aCols[n,nPSC1Item]))		
		If SC1->C1_QUANT-SC1->C1_QUJE > 0
			nAbatSC := (SC1->C1_QUANT-SC1->C1_QUJE)*SC1->C1_VUNIT
		Endif	
	Endif	
	
	//Verifica se a projeto foi informada
	If Type("_aFSPrj") != "U"
		If Len(_aFSPrj) > 0
			For nXi := 1 to len(_aFSPrj)
				nPAFGItem		:= aScan(_aFSPrj[nXi],{|x| AllTrim(x[1]) == "AFG_ITEMSC"})
				nPAFGProj		:= aScan(_aFSPrj[nXi],{|x| Alltrim(x[1]) == "AFG_PROJET"})
				nPAFGTaref		:= aScan(_aFSPrj[nXi],{|x| Alltrim(x[1]) == "AFG_TAREFA"})
			
				If nPAFGItem > 0 .and. nPAFGTaref > 0
					If aCols[n,nPSC1Item] == _aFSPrj[nXi,nPAFGItem,2]

						aCols[n,nPSC1Proj] 		:= _aFSPrj[nXi,nPAFGProj,2]								
						aCols[n,nPSC1DtEnt] 	:= aCols[n,nPSC1DtPrf]
						
						If !Empty(cTarefa)
							cTarefa += ";"+Alltrim(_aFSPrj[nXi,nPAFGTaref,2])
						Else
							cTarefa += Alltrim(_aFSPrj[nXi,nPAFGTaref,2])
						Endif
					Endif		
				Endif
			Next
			
			If  nPAFGTaref > 0
				aCols[n,nPSC1Taref] 	:= cTarefa
			Endif
		Endif
	Endif		
	
	oSaldo	:= Z_Saldo():New()
		
	// Valor da linha da SC (Quant-Quan Entrega)*Preco Unitario
	// oSaldo:nValProc		:= (aCols[n,nPSC1Qtd]-aCols[n,nPSC1QTDEn])*aCols[n,nPSC1Val]
	If !Empty(aCols[n,nPSC1Proj])  
		oSaldo:nValProc		:= (aCols[n,nPSC1Qtd])*aCols[n,nPSC1Val]
		
		// Abate valor original do saldo da SC - Caso de alteração
		oSaldo:nAbatSC		:=  nAbatSC  
			    
		oSaldo:cCodFil 		:= 	xFilial("SC1")
		oSaldo:cCodProj		:=  aCols[n,nPSC1Proj]
		oSaldo:cCodTarefa 	:=  aCols[n,nPSC1Taref]
		If Substr(Alltrim(aCols[n,nPSC1Taref]),1,2) == "ID"
			oSaldo:cIDTarefa	:= 	aCols[n,nPSC1Taref]
		Else
			oSaldo:cIDTarefa	:= 	""	
		Endif
		oSaldo:dDtEnt		:=  aCols[n,nPSC1DtEnt]
		oSaldo:cCodProc		:= "001"
		oSaldo:cProcesso	:= "Solicitacao de Compras"
	
		oSaldo:ConsSaldo() 
		oSaldo:Avalia()

		IF !Empty(oSaldo:cIDTarefa)
			aCols[n,nPSC1Taref] := Alltrim(oSaldo:cIDTarefa)
		Endif

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
	
	RestArea(aArea)

Return lRet
