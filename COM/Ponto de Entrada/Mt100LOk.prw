#INCLUDE "totvs.ch"
#INCLUDE "protheus.ch"
#INCLUDE "rwmake.ch"

//-------------------------------------------------------------------
/* {Protheus.doc} MT100LOK
Ponto de Entrada Doc Entrada 
Utilizado para validação saldo do projeto TSA 

@protected TSA
@author    Alex T. Souza
@since     12/09/2019

Alteracoes Realizadas desde a Estruturacao Inicial
Data       Programador     Motivo
/*/
//-------------------------------------------------------------------
User Function MT100LOK()
Local aArea 		:= GetArea()
Local nPSD1DtEnt   	:= aScan(aHeader,{|x| AllTrim(x[2]) == "D1_ZDTENT"})
Local nPSD1Proj	 	:= aScan(aHeader,{|x| Alltrim(x[2]) == "D1_ZPRJ"})
Local nPSD1Taref 	:= aScan(aHeader,{|x| Alltrim(x[2]) == "D1_ZTARE"})
Local nPosQuant		:= aScan(aHeader,{|x| AllTrim(x[2]) == "D1_QUANT"})
Local nPosVUnit   	:= aScan(aHeader,{|x| AllTrim(x[2]) == "D1_VUNIT"})
Local nPosPc		:= aScan(aHeader,{|x| AllTrim(x[2]) == "D1_PEDIDO"})
Local nPosItem   	:= aScan(aHeader,{|x| AllTrim(x[2]) == "D1_ITEM"})
Local oSaldo
Local nAbatSC		:= 0
Local nAbatPC		:= 0
Local lRet			:= .t.

	// Chamada de fonte TSA 24/06/2021
	lRet := TSAFunc()

	If lRet .and. nPSD1DtEnt <> 0 .and. nPSD1Proj <> 0 .and. nPSD1Taref <> 0

		If !Empty(Alltrim(aCols[n,nPSD1Proj]))

			//Posiciona SC7 para retirar valor do pedido do saldo
			SC7->(DbSetOrder(1))
			If SC7->(DbSeek(xFilial("SC7")+aCols[n,nPosPc]+aCols[n,nPosItem])) 
				nAbatPC += (SC7->C7_QUANT-SC7->C7_QUJE)*SC7->C7_PRECO
				
				//Posiciona SC1 para retirar valor da SC do saldo
				SC1->(DbSetOrder(1))
				If SC1->(DbSeek(xFilial("SC1")+SC7->C7_NUMSC+SC7->C7_ITEMSC))
					nAbatSC += (SC1->C1_QUANT-SC1->C1_QUJE)*SC1->C1_XVUNIT	
				Endif	
			Endif
			
			oSaldo	:= Z_Saldo():New()
					
			// Valor da linha da NF (Quant)*Preco Unitario
			oSaldo:nValProc		:= aCols[n,nPosQuant]*aCols[n,nPosVUnit]    
			
			// Abate valor original do Pedido de Compras
			oSaldo:nAbatSC		:= nAbatSC 		    		    
			oSaldo:nAbatPC		:= nAbatPC
					
			oSaldo:cCodFil 		:= 	xFilial("SD1")
			oSaldo:cCodProj		:=  aCols[n,nPSD1Proj]
			oSaldo:cCodTarefa 	:=  aCols[n,nPSD1Taref]
			oSaldo:dDtEnt		:=  aCols[n,nPSD1DtEnt]
			oSaldo:cCodProc		:= "003"
			oSaldo:cProcesso	:= "Documento de Entrada"
		
		
			oSaldo:ConsSaldo() 
			oSaldo:Avalia()
							
			If !(oSaldo:lOk)                            
				If !IsBlind()	                            
					nDet := Aviso("Bloqueio de Saldo",oSaldo:cMensagem,{"Fechar"},3)
				Endif	
				lRet := oSaldo:lOk
			Endif
		Endif

	Endif	

	RestArea(aArea)

Return lRet

/*
+-----------------------------------------------------------------------+
¦Programa  ¦MT100LOK  ¦ Autor ¦ Crislei de A. Toledo  ¦ Data ¦23.03.2006¦
+----------+------------------------------------------------------------¦
¦Descriçào ¦ VALIDACAO DA LINHA DA NF DE ENTRADA                        ¦
+----------+------------------------------------------------------------¦
¦ Uso      ¦ ESPECIFICO PARA EPC                                        ¦
+-----------------------------------------------------------------------¦
¦           ATUALIZACOES SOFRIDAS DESDE A CONSTRUCAO INICIAL            ¦
+-----------------------------------------------------------------------¦
¦PROGRAMADOR ¦ DATA   ¦ MOTIVO DA ALTERACAO                             ¦
+------------+--------+-------------------------------------------------¦
¦            ¦        ¦                                                 ¦
+------------+--------+-------------------------------------------------+
Alex Teixeira de Souza
Fonte anterior TSA MT100LOK
Ajustado para funçaõ TSAFunc para compatibilização com projeto TOP 24/06/2021
*/
Static Function TSAFunc()
Local lRet      := .T.
Local nPosCC    :=  0 
Local nPosConta :=  0 
Local nPosRatei :=  0 
Local nPosref 	:=  0 
Local nPosPed 	:=  0 
Local aAreaOld  := GetArea()
Local aAreaSD2  := SD2->(GetArea())
Local aAreaSF1  := SF1->(GetArea())
Local aAreaSC6  := SC6->(GetArea())

nPosCC    := aScan(aHeader,{|aAux|alltrim(aAux[2]) == "D1_CC"})
nPosConta := aScan(aHeader,{|aAux|alltrim(aAux[2]) == "D1_CONTA"})
nPosRatei := aScan(aHeader,{|aAux|alltrim(aAux[2]) == "D1_RATEIO"})

nPosref   := aScan(aHeader,{|aAux|alltrim(aAux[2]) == "D1_DTREF"})
nPosPed   := aScan(aHeader,{|aAux|alltrim(aAux[2]) == "D1_PEDIDO"})

if !EMPTY(aCols[n,nPosPed])
	if (!U_zValidaDate(aCols[n,nPosref],0,.F.,.F.,.F.))
		MsgBox("Alterar data de entrega do pedido para o mês atual. Linha: "+cvaltochar(n)+" Data: "+cvaltochar(aCols[n,nPosref]),"Operação não permitida","STOP")		
		//lRet := .F.
		lRet := SenhaSkip()
	EndIf
EndIf

If !aCols[n,Len(aHeader)+1]
	If  !(aCols[n,nPosRatei] $ "1")
		If Empty(aCols[n,nPosCC])
			If CTIPO $ "B|D"
				dbSelectArea("SD2")
				SD2->(dbSetOrder(3)) //D2_FILIAL+D2_DOC+D2_SERIE+D2_CLIENTE+D2_LOJA+D2_COD+D2_ITEM
				SD2->(dbSeek(xFilial("SD2")+GdFieldGet("D1_NFORI",n)+GdFieldGet("D1_SERIORI",n)+CA100FOR+CLOJA+GdFieldGet("D1_COD",n)+GdFieldGet("D1_ITEMORI",n)))
				If !SD2->(Eof())
					dbSelectArea("SC6")
					SC6->(dbSetOrder(1)) //C6_FILIAL+C6_NUM+C6_ITEM+C6_PRODUTO				
					SC6->(dbSeek(xFilial("SC6")+SD2->(D2_PEDIDO+D2_ITEMPV)))
					If !SC6->(Eof())
						GdFieldPut("D1_CC",SC6->C6_SUBC,n)
					EndIf
				EndIf
			Else
				MsgBox("Informe o Centro de Custo!","Inconsistencia","STOP")
				If !Empty(cNfiscal)
					lRet := .F.
				EndIf
			EndIf
		EndIf
	Else
	   If !Empty(aCols[n,nPosCC])
			aCols[n,nPosCC] := ""
		EndIf
	EndIf
EndIf

// Faz a Validação de Alteração da Solicitação

nPosTES 	:= aScan(aHeader,{|x| Alltrim(x[2]) == "D1_TES"})

RestArea(aAreaOld)
RestArea(aAreaSD2)
RestArea(aAreaSF1)
RestArea(aAreaSC6)

Return(lRet)

//Somente para agilizar desenho da interface
/*User Function TSenhaSkip()

Return SenhaSkip()*/

Static Function SenhaSkip()

Local cSenha := Space(32)
Local bOk:={|| If(cSenha==GetMv("MV_ZSALTSC",,"372a53b60256781b1358db8d118e2a1b"),.T.,.F.) }
Local lOk := .F.

@ 000,000 TO 210,400 DIALOG oDlg TITLE "Senha de Liberação"
@ 005,005 TO 089,190 TITLE "Autorizar lançamentos fora do padrão de data na linha: "+cvaltochar(n)
//@ 005,005 TO 089,190 TITLE "Autorizar lançamentos fora do padrão de data"
@ 20,007 SAY "Senha de Liberação: "
@ 20,060 GET cSenha SIZE 100,300 Valid !Empty(cSenha) PASSWORD

@ 050,10 BMPBUTTON Type 01 ACTION  (If(Eval(bOk),(oDlg:End(),lOk:=.T.),(lOk:=.F.,Alert("Senha Incorreta"))))
@ 050,40 BMPBUTTON Type 02 ACTION  (lOk:=.F.,oDlg:End())

ACTIVATE DIALOG oDlg CENTERED

Return(lOk)

