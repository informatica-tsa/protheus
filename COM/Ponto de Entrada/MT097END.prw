#Include 'RwMake.ch'
/*
+-----------------------------------------------------------------------+
¦Programa  ¦MT097END   ¦ Autor ¦ Gilson Lucas          ¦Data ¦19.08.2011¦
+----------+------------------------------------------------------------¦
¦Descricao ¦Envia o E-mail para o proximo aprovador                     ¦
+----------+------------------------------------------------------------¦
¦ Uso      ¦ ESPECIFICO PARA A TSA                                      ¦
+-----------------------------------------------------------------------¦
¦           ATUALIZACOES SOFRIDAS DESDE A CONSTRUCAO INICIAL            ¦
+-----------------------------------------------------------------------¦
¦PROGRAMADOR ¦ DATA   ¦ MOTIVO DA ALTERACAO                             ¦
+------------+--------+-------------------------------------------------¦
¦            ¦        ¦                                                 ¦
+-----------------------------------------------------------------------+
*/
User Function MT097END()
*************************************************************************
*
**
Local aMailTo  := {}
Local cMailGer := ""
Local cMotblq1 := "" 
Local aRefer   := ParamIxb
Local cDocto   := aRefer[1]
Local cTipoSCR := aRefer[2]
Local nOpcX    := aRefer[3]
Local cCodUser := PswID()
Local aAreaOld := GetArea()

If ValType(aRefer) == "A"
   // Esta instrução é para forçar o posicionamento na tabela scr dbseek nao funciona de forma nenhuma.
   cAliasTMP := GetNextAlias()  
   BeginSql Alias cAliasTMP //Inicio do Embedded SQL
      SELECT R_E_C_N_O_ REGSRC FROM %table:SCR% SCR
      WHERE SCR.%NotDel%
            AND CR_FILIAL  = %xFilial:SCR%
            AND CR_TIPO    = %Exp:aRefer[2]%
            AND CR_NUM     = %Exp:aRefer[1]%
//AND CR_NIVEL   = %Exp:aRefer[4]%
            AND CR_USER    = %Exp:__CUSERID%
   EndSql
   dbSelectArea(cAliasTMP)
   (cAliasTMP)->(dbGotop())
   If !(cAliasTMP)->(Eof())
      dbSelectArea("SCR")
      SCR->(dbGoto((cAliasTMP)->REGSRC))
   EndIf
   dbSelectArea(cAliasTMP)
  (cAliasTMP)->(dbCloseArea())
EndIf
   
If nOpcX == 2
   cAliasTMP := GetNextAlias()  
   BeginSql Alias cAliasTMP //Inicio do Embedded SQL
      SELECT CR_USER ,R_E_C_N_O_ REGSRC FROM %table:SCR% SCR
      WHERE SCR.%NotDel%
            AND SCR.CR_FILIAL  = %xFilial:SCR%
            AND SCR.CR_NUM = %Exp:cDocto%
            AND SCR.CR_USER != %Exp:cCodUser%
            AND SCR.CR_STATUS = %Exp:'02'%
   EndSql

   dbSelectArea(cAliasTMP)
   (cAliasTMP)->(dbGotop())
   While !(cAliasTMP)->(Eof())
      PswOrder(1)
      If PswSeek((cAliasTMP)->CR_USER,.T.)
         aUser := PswRet() // Retorna vetor com informações do usuário
         If !Empty(aUser[1][14])
            Aadd(aMailTo,{Alltrim(aUser[1][14]),(cAliasTMP)->REGSRC,'_AVISO_LIB_PC.HTML'})
         EndIf
      EndIf
      (cAliasTMP)->(dbSkip())
   End
   dbSelectArea(cAliasTMP)
   (cAliasTMP)->(dbCloseArea())

   If !Empty(aMailTo)
      U_MailPed(xFilial("SC7"),cDocto,aMailTo,"")
   EndIf
   PswSeek(cCodUser,.T.)
   RestArea(aAreaOld)
   // e-mail para o comprador
   dbSelectArea("SC7")
   SC7->(dbsetOrder(1))
   SC7->(dbseek(xFilial("SC7")+Alltrim(cDocto)))
   If !SC7->(Eof()) 
      If Upper(SC7->C7_CONAPRO)=="L"
         PswOrder(1)
         If PswSeek(SC7->C7_USER,.T.)
            aUser := PswRet() // Retorna vetor com informações do usuário
            If !Empty(aUser[1][14])
               Aadd(aMailTo,{Alltrim(aUser[1][14]),0,'_AVISO_LIB_COM.HTML'})
            EndIf
         EndIf
         If !Empty(aMailTo)
            U_MailPed(xFilial("SC7"),cDocto,aMailTo,"")
         EndIf
         PswSeek(cCodUser,.T.)
         RestArea(aAreaOld)
      EndIf
   EndIf
   
   // E-mail para o gerente
   dbSelectArea("CTD")
   CTD->(dbSetOrder(1))

   dbSelectArea("SAK")
   SAK->(dbSetOrder(1))

   dbSelectArea("SC7")
   SC7->(dbsetOrder(1))
   SC7->(dbseek(xFilial("SC7")+Alltrim(cDocto)))
   If !SC7->(Eof())
      PswOrder(1)
      While !SC7->(Eof()) .And. SC7->(C7_FILIAL+C7_NUM) == xFilial("SC7")+Alltrim(cDocto)

         If Upper(SC7->C7_CONAPRO)=="L"
            CTD->(dbSeek(xFilial("CTD")+SC7->C7_ITEMCTA))
            If !CTD->(Eof())
               SAK->(dbSeek(xFilial("SAK")+CTD->CTD_APROV))
               If !SAK->(Eof())
                  If PswSeek(SAK->AK_USER,.T.)
                     aUser := PswRet() // Retorna vetor com informações do usuário
                     If !Empty(aUser[1][14])
                        If !(aUser[1][14] $ cMailGer )
                           cMailGer += aUser[1][14]+";"  
                        EndIf
                     EndIf   
                  EndIf
               EndIf
            EndIf
         EndIf

         SC7->(dbSkip())
      End
   EndIf
   SC7->(dbseek(xFilial("SC7")+Alltrim(cDocto)))
   If Upper(SC7->C7_CONAPRO)=="L"
      If !Empty(cMailGer)
         cMailGer := Left(cMailGer,Len(cMailGer)-1)
         Aadd(aMailTo,{Alltrim(cMailGer),0,'_AVISO_LIB_COM.HTML'})
         U_MailPed(xFilial("SC7"),cDocto,aMailTo,"")
      EndIf
   EndIf

   PswSeek(cCodUser,.T.)
   RestArea(aAreaOld)
ElseIf nOpcX == 3
   // e-mail para o comprador
   dbSelectArea("SC7")
   SC7->(dbsetOrder(1))
   SC7->(dbseek(xFilial("SC7")+Alltrim(cDocto)))

   PswOrder(1)
   If PswSeek(SC7->C7_USER,.T.)
      aUser := PswRet() // Retorna vetor com informações do usuário
      If !Empty(aUser[1][14])
         Aadd(aMailTo,{Alltrim(aUser[1][14]),0,'_AVISO_LIB_BLQ.HTML'})
      EndIf
   EndIf

   If !Empty(aMailTo)
      U_MailPed(xFilial("SC7"),cDocto,aMailTo,Alltrim(SCR->CR_OBS))
   EndIf
   PswSeek(cCodUser,.T.)
   RestArea(aAreaOld)

   aMailTo := {}
   // Envia e-mail para o gerente da conta
   cAliasTMP := GetNextAlias()  
   BeginSql Alias cAliasTMP //Inicio do Embedded SQL
      SELECT CR_USER ,CR_OBS,R_E_C_N_O_ REGSRC FROM %table:SCR% SCR
      WHERE SCR.%NotDel%
            AND SCR.CR_FILIAL  = %xFilial:SCR%
            AND SCR.CR_NUM = %Exp:cDocto%
            AND SCR.CR_NIVEL = %Exp:'02'%
   EndSql

   dbSelectArea(cAliasTMP)
   (cAliasTMP)->(dbGotop())
   While !(cAliasTMP)->(Eof())
      PswOrder(1)
      If PswSeek((cAliasTMP)->CR_USER,.T.)
         aUser := PswRet() // Retorna vetor com informações do usuário
         If !Empty(aUser[1][14])
            Aadd(aMailTo,{Alltrim(aUser[1][14]),0,'_AVISO_LIB_BLQ.HTML'})
         EndIf
      EndIf
      (cAliasTMP)->(dbSkip())
   End
   dbSelectArea(cAliasTMP)
   (cAliasTMP)->(dbCloseArea())

   If !Empty(aMailTo)
      U_MailPed(xFilial("SC7"),cDocto,aMailTo,Alltrim(SCR->CR_OBS))
   EndIf
   PswSeek(cCodUser,.T.)
   RestArea(aAreaOld)
EndIf

Return



User Function MailPed(cFilPed,cNumPed,aUser,cMotBlq)
*************************************************************************
*
**
Local oProcess
Local cMailto  := ""
Local lFirst   := .T.   
Local nTotPed  := 0 



For nXi := 1 To Len(aUser)
    cMailto += aUser[nXi,1]+";"
Next nXi
cMailto := Left(cMailto,Len(cMailto)-1)


dbSelectArea("SB1")
SB1->(dbSetOrder(1)) //Filial+Codigo

dbSelectArea("SA2")
SA2->(dbSetOrder(1)) //Filial+Codigo+Loja

cNumPed := Alltrim(cNumPed)
dbSelectArea("SC7")
SC7->(dbSetOrder(1)) //Filial+Codigo
SC7->(dbSeek(cFilPed+cNumPed))
While !SC7->(Eof()) .And.SC7->(C7_FILIAL+C7_NUM) == cFilPed+cNumPed
    SA2->(dbSeek(xFilial("SA2")+SC7->(C7_FORNECE+C7_LOJA)))
    If !SA2->(Eof())
       If lFirst
          oProcess:=TWFProcess():New("000001",OemToAnsi("Pedido de compra em atraso"))
          oProcess:NewTask("000001"     ,"\workflow\emp"+SM0->M0_CODIGO+"\html\"+aUser[1,3] )
          oProcess:oHtml:= TWFHTML():New("\workflow\emp"+SM0->M0_CODIGO+"\html\"+aUser[1,3] )
          oProcess:cSubject:=OemToAnsi("Liberação de Pedido de Compra - ")+cNumPed
          oProcess:cTo := cMailto
          oProcess:oHtml:ValByName("cNumPed",SC7->C7_NUM)
          oProcess:oHtml:ValByName("cCodFil",Alltrim(SM0->M0_CODFIL)+"-"+Alltrim(SM0->M0_FILIAL))
          oProcess:oHtml:ValByName("cNomFor",SA2->A2_NOME)
          If !Empty(cMotBlq)
             oProcess:oHtml:ValByName("cMotBlq",cMotBlq)
          EndIf
          lFirst := .F.
       EndIf
       
       nTotPed += SC7->C7_TOTAL
       AADD(oProcess:oHtml:ValByName("It.Sub")    ,SC7->C7_CC)
       AADD(oProcess:oHtml:ValByName("It.Item")    ,SC7->C7_ITEM)
       AADD(oProcess:oHtml:ValByName("It.Prod")    ,SC7->C7_PRODUTO)
       AADD(oProcess:oHtml:ValByName("It.Desc")    ,SC7->C7_DESCRI)
       AADD(oProcess:oHtml:ValByName("It.Qtd")     ,Transform(SC7->C7_QUANT,"@E 999,999.99"))
       AADD(oProcess:oHtml:ValByName("It.Vunit")    ,Transform(SC7->C7_PRECO,"@E 9,999,999.99"))
       AADD(oProcess:oHtml:ValByName("It.Vtotal")   ,Transform(SC7->C7_TOTAL,"@E 9,999,999.99"))
    EndIf
    SC7->(dbSkip())
End


If !Empty(nTotPed)
   oProcess:oHtml:ValByName("nTotPed",Transform(nTotPed,"@E 999,999,999.99"))
   oProcess:Start()    
   oProcess:Finish()
   If SCR->(FieldPos("CR_ENVMAIL"))>0
      dbSelectArea("SCR")
      For nXi := 1 To Len(aUser)
          If !Empty(aUser[nXi,2])
             SCR->(dbGoto(aUser[nXi,2]))
             If !SCR->(Eof())
                If RecLock("SCR",.F.)
                   Replace CR_ENVMAIL With 'S',;
                           CR_OBS     With 'E-Mail Env.:  '+dtoc(Date())+' - '+Left(Time(),5)
                   SCR->(MsUnLock())
                EndIf
             EndIf
          EndIf
      Next nXi
   EndIf
EndIf   

Return