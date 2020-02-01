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
*/

#include "Protheus.ch"
#include "rwmake.ch"

User Function Mt100LOk()

Local lRet      := .T.
Local nPosCC    :=  0 
Local nPosConta :=  0 
Local nPosRatei :=  0 
Local aAreaOld  := GetArea()
Local aAreaSD2  := SD2->(GetArea())
Local aAreaSF1  := SF1->(GetArea())
Local aAreaSC6  := SC6->(GetArea())

nPosCC    := aScan(aHeader,{|aAux|alltrim(aAux[2]) == "D1_CC"})
nPosConta := aScan(aHeader,{|aAux|alltrim(aAux[2]) == "D1_CONTA"})
nPosRatei := aScan(aHeader,{|aAux|alltrim(aAux[2]) == "D1_RATEIO"})

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

//If Altera 
//  If Posicione("SF4",1,xFilial("SF4")+aCols[n,nPosTES],"F4_TRANFIL") <> "1" //Verifica se não é transferencia entre filiais 
//	lRet:=VldAltSC()
//  Endif
//Endif


RestArea(aAreaOld)
RestArea(aAreaSD2)
RestArea(aAreaSF1)
RestArea(aAreaSC6)

Return(lRet)



Static Function VldAltSC()
************************************************************************************************************************************************
* Valida se há Itens alterados
*
*****

Local lRet := .T.
Local aAreaSC := GetArea()
Local nXi2 := 0
Local nXi := 0
cLibAlt := GdFieldGet("C1_LIBALT",1)

If cLibAlt <> 'S'
	If !SC1->(dbSeek(Xfilial("SC1")+GdFieldget("C1_PRODUTO",1)+cA110Num+GdFieldget("C1_ITEM",1)))
		lRet := .f.
	Endif
	If dA110Data < Date()
		lRet := .f.
	Endif
	If DataValida(SC1->C1_EMISSAO) < Date() 
		For nXi := 1 To Len(Acols)
			// Valida se há novos Itens
			If !SC1->(dbSeek(Xfilial("SC1")+GdFieldget("C1_PRODUTO",nXI)+cA110Num+GdFieldget("C1_ITEM",nXI)))
				lRet := .F.	
			Endif  
			
			//Valida a Data de Emissão
			If lRet .And. dA110Data < Date()
				lRet := .f.
			Endif
			
			//Verifica  se a Linha foi excluida
			If lRet .And. Gddeleted(nXi)
				lRet := .f.                                    
			Endif
			//Valida se há campos alterados
		    If lRet
		    	For nXi2 := 1 To Len(aHeader)
		    		xCmp := "SC1->"+aHeader[nXi2,2]
		    		If lRet .And. GdFieldGet(aHeader[nXi2,2],nXi)<>&xCmp
		    			lRet := .F.
		    			Exit
		    		Endif
		    	Next nXi2
		    Endif
		    If !lRet
		    	Exit
		    Endif
		Next nXi
	Endif
	If !lRet
		If SenhaAlt()
			lRet := .T.
		Endif
	Endif
Endif	
RestArea(aAreaSC)

Return(lRet)



Static Function SenhaAlt()
*************************************************************************************************************************************************
*
*
****
Local cSenha := Space(6)
Local bOk:={|| If(cSenha==GetMv("MV_SALTSC",,"SENHA "),.t.,.F.) }
Local lok := .F.

DEFINE MSDIALOG oDlg TITLE "Senha de Liberação" FROM 0,0 TO 100,250 OF oMainWnd Pixel

@ 01,05 Say " Solicitação de Compras com mais de 2 Dias" PIXEL OF oDlg
@ 10,05 Say " Informe a Senha de Liberação:" PIXEL OF oDlg
@ 10,83 Get cSenha Valid !Empty(cSenha) PASSWORD PIXEL OF oDlg

DEFINE SBUTTON FROM 30, 10   TYPE 1 ENABLE OF oDlg ACTION (If(Eval(bOk),(oDlg:End(),AtuLin(),lOk:=.T.),(lOk:=.F.,Alert("Senha Incorreta"))))
DEFINE SBUTTON FROM 30, 40   TYPE 2 ENABLE OF oDlg ACTION (lOk:=.F.,oDlg:End())
ACTIVATE MSDIALOG oDlg CENTERED 

Return(lOk)


Static Function AtuLin()
************************************************************************************************************************************************
*
*
******

Local nXI := 0

For nXi:=1 to Len(ACols)
	GdFieldPut("C1_LIBALT",'S',nXi)
Next nXi
Return()