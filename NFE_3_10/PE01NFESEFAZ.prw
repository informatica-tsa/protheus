#Include 'RwMake.ch'
#DEFINE MAXMENLIN  90
/*  
+-----------------------------------------------------------------------+
¦Programa  ¦EtiqPlas   ¦ Autor ¦ Gilson Lucas          ¦Data ¦05.11.2014¦
+----------+------------------------------------------------------------¦
¦Descricao ¦Customizacoes do Danfe                                      ¦
+----------+------------------------------------------------------------¦
¦ Uso      ¦ ESPECIFICO PARA A TSA                                      ¦
+-----------------------------------------------------------------------¦
¦           ATUALIZACOES SOFRIDAS DESDE A CONSTRUCAO INICIAL            ¦
+-----------------------------------------------------------------------¦
¦PROGRAMADOR ¦ DATA   ¦ MOTIVO DA ALTERACAO                             ¦
+------------+--------+-------------------------------------------------¦
¦THIAGOSANTOS|04/10/17|INCLUSÃO DE NOVAS VARIAVEIS NO RETORNO DO P.E    ¦
+-----------------------------------------------------------------------+
*/
User Function PE01NFESEFAZ
*************************************************************************
*
**
Local nXi        := 0 
Local lAddMsg    := .T.
Local aProd      := ParamIxb[01]
Local cMensCli   := ParamIxb[02]
Local cMensFis   := ParamIxb[03]
Local aDest      := ParamIxb[04]
Local aNota      := ParamIxb[05]
Local aInfoItem  := ParamIxb[06]
Local aDupl      := ParamIxb[07]
Local aTransp    := ParamIxb[08]
Local aEntrega   := ParamIxb[09]
Local aRetirada  := ParamIxb[10]
Local aVeiculo   := ParamIxb[11]
Local aReboque   := ParamIxb[12]

Local aNfVincRur := ParamIxb[13]
Local aEspVol    := ParamIxb[14]
Local aNfVinc    := ParamIxb[15]

Local aAreaOld   := GetArea()
Local aAreaSD2   := SD2->(GetArea())
Local aAreaSC6   := SC6->(GetArea())
Local aAreaSB1   := SB1->(GetArea())

If aNota[4] == '1'
   cMensCli   := ""
   cMensFis   := ""

   dbSelectarea("SC5")
   SC5->(dbSetOrder(1))
   SC5->(dbSeek(xFilial("SC5")+SC6->C6_NUM))
   If !SC5->(Eof())
      cMensCli += GetMsgNota('S',@lAddMsg)
   EndIf   
Else
   //MsgNota(@cMensCli,'E',SF1->F1_FILIAL,SF1->F1_DOC,SF1->F1_SERIE,SF1->F1_FORNECE,SF1->F1_LOJA,aProd)
EndIf   

RestArea(aAreaOld)
RestArea(aAreaSD2)
RestArea(aAreaSC6)
RestArea(aAreaSB1)


Return({aProd,cMensCli,cMensFis,aDest,aNota,aInfoItem,aDupl,aTransp,aEntrega,aRetirada,aVeiculo,aReboque,aNfVincRur,aEspVol,aNfVinc})



Static Function GetMsgNota(cTpNf,lAddMsg)
*********************************************************************************************
*
*****

Local cRet     := ''
Local cAuxi    := ''
Local nLinAuxi := 0
Local nXi := 0

If cTpNf == 'S' .and. lAddMsg // Nota de saida

   SZ1->(dbSetOrder(1))
   SZ1->(dbSeek(xFilial("SZ1")+SC5->C5_CONTRATO))
	
   SM4->(dbSetOrder(1))
   SM4->(dbSeek(xFilial("SM4")+SC5->C5_MENPAD))
   
   cRet := Padr("Contrato: "+SC5->C5_CONTRATO+"-"+SZ1->Z1_NOME, MAXMENLIN)
   cRet += Padr("Obra: "+SZ1->Z1_CONTA+"-"+SZ1->Z1_NOMCONTA, MAXMENLIN)
   cRet += Padr("Cliente: "+SC5->C5_CLIENTE+"/"+SC5->C5_LOJACLI, MAXMENLIN)
   If !SM4->(eof())
      cAuxi := Alltrim(SM4->M4_FORMULA) // quebrar esta msg em 62 digitos
      If !Empty(cAuxi)
         nLinAuxi := Iif((Len(cAuxi) / MAXMENLIN) -int(Len(cAuxi) / MAXMENLIN) == 0,Len(cAuxi) / MAXMENLIN,INT((Len(cAuxi) / MAXMENLIN))+1)
         For nXi := 1 To nLinAuxi
             cRet += Padr(SubStr(cAuxi,((nXi-1)*MAXMENLIN)+1,MAXMENLIN),MAXMENLIN)
         Next nXi
         
      EndIf
   EndIf
   If !Empty(Alltrim(SC5->C5_REFER))
      cAuxi := Alltrim(SC5->C5_REFER)
      nLinAuxi := Iif((Len(cAuxi) / MAXMENLIN) -int(Len(cAuxi) / MAXMENLIN) == 0,Len(cAuxi) / MAXMENLIN,INT((Len(cAuxi) / MAXMENLIN))+1)
      For nXi := 1 To nLinAuxi
          cRet += Padr(SubStr(cAuxi,((nXi-1)*MAXMENLIN)+1,MAXMENLIN),MAXMENLIN)
      Next nXi
   EndIf
   If !Empty(Alltrim(SC5->C5_MENNOT2))
      cAuxi := Alltrim(SC5->C5_MENNOT2)
      nLinAuxi := Iif((Len(cAuxi) / MAXMENLIN) -int(Len(cAuxi) / MAXMENLIN) == 0,Len(cAuxi) / MAXMENLIN,INT((Len(cAuxi) / MAXMENLIN))+1)
      For nXi := 1 To nLinAuxi
          cRet += Padr(SubStr(cAuxi,((nXi-1)*MAXMENLIN)+1,MAXMENLIN),MAXMENLIN)
      Next nXi
   EndIf
   If !Empty(Alltrim(SC5->C5_MENNOT3))
      cAuxi := Alltrim(SC5->C5_MENNOT3)
      nLinAuxi := Iif((Len(cAuxi) / MAXMENLIN) -int(Len(cAuxi) / MAXMENLIN) == 0,Len(cAuxi) / MAXMENLIN,INT((Len(cAuxi) / MAXMENLIN))+1)
      For nXi := 1 To nLinAuxi
          cRet += Padr(SubStr(cAuxi,((nXi-1)*MAXMENLIN)+1,MAXMENLIN),MAXMENLIN)
      Next nXi
   EndIf
   If !Empty(Alltrim(SC5->C5_MENNOT4))
      cAuxi := Alltrim(SC5->C5_MENNOT4)
      nLinAuxi := Iif((Len(cAuxi) / MAXMENLIN) -int(Len(cAuxi) / MAXMENLIN) == 0,Len(cAuxi) / MAXMENLIN,INT((Len(cAuxi) / MAXMENLIN))+1)
      For nXi := 1 To nLinAuxi
          cRet += Padr(SubStr(cAuxi,((nXi-1)*MAXMENLIN)+1,MAXMENLIN),MAXMENLIN)
      Next nXi
   EndIf
EndIf


If !Empty(cRet)
   lAddMsg := .f.
EndIf

Return(cRet)