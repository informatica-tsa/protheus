#Include 'RwMake.ch'
#Include 'Protheus.ch'
/*
+-----------------------------------------------------------------------+
¦Programa  ¦           ¦ Autor ¦ Hemerson Queiroz      ¦Data ¦28.02.2011¦
+----------+------------------------------------------------------------¦
¦Descricao ¦Cadastro de Grupo de Aprovadores                            ¦
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

User Function MT120APV()

************************************************************************
*
**
Local cRet        := ""
Local cQuery      := ""
Local cAliasTMP   := ""
Local cCodAprov   := ""
Local nValPed     := 0
Local nGrupoFree  := 0
Local lAltGrpApv  := .F.
Local nGrupoGeral := 0
Local aGrAprov    := {}
Local aAreaOld    := GetArea()
Local cNumPed     := SC7->C7_NUM
Local cOrigem     := SC7->C7_ORIGEM
Local aAreaSC7    := SC7->(GetArea())

dbSelectArea("CTD")
CTD->(dbSetOrder(1))

dbSelectArea("SB1")
SB1->(dbSetOrder(1))


dbSelectArea("SC7")
SC7->(dbSetOrder(1))
SC7->(dbSeek(xFilial("SC7")+SC7->C7_NUM))
While !SC7->(Eof()) .And. xFilial("SC7")+cNumPed == SC7->(C7_FILIAL+C7_NUM)
    SB1->(dbSeek(xFilial("SB1")+SC7->C7_PRODUTO))
    nGrupoGeral++

   If Alltrim(SB1->B1_GRUPO) $ GetNewPar("NM_GRPFREE","")
      nGrupoFree++
   Endif

   If Alltrim(SC7->C7_XOPER) $ GetNewPar("ZZ_GRUPO","") .And. Alltrim(SC7->C7_ITEMCTA) != '9301A'
      lAltGrpApv := .T.
   Endif

    nValPed += SC7->C7_TOTAL
    If !Empty(SC7->C7_ITEMCTA)
       CTD->(dbSeek(xFilial("CTD")+SC7->C7_ITEMCTA))
       If !CTD->(Eof())
          If !Empty(CTD->CTD_APROV)
             cCodAprov := CTD->CTD_APROV
             If aScan(aGrAprov,CTD->CTD_APROV) == 0
                Aadd(aGrAprov,CTD->CTD_APROV)
             EndIf   
          EndIf
       EndIf
    EndIf
    If AllTrim(FunName()) == "MATA160" .Or. AllTrim(FunName()) == "MATA161"
       If RecLock("SC7",.F.)
          Replace C7_DESTINA With SC8->C8_DESTINA,;
                  C7_CONDGER With MemoRead( "\custom_files\cond_gerais\Cond_gerais.txt"),;
                  C7_ICMSRET With SC8->C8_ICMSRET
                  
          SC7->(MsUnLock())
       EndIF
    EndIf   
    
    SC7->(dbSkip())
End

//Adicionado tratativa para que pedidos integrados pelo processo de viagem sejam criados liberados.
//Em caso de alteração, alçada de aprovação será acionada. 
//Thiago V. dos Santos 02/12/2021
If (nGrupoFree == nGrupoGeral .or. ( alltrim(cOrigem) == 'LIGAI' .and. inclui) ) // Nao pode bloquear este pedido.
   cRet := ""
   
   cQuery := "UPDATE "+RetSqlname("SC7")
   cQuery += " SET C7_APROV = '',C7_CONAPRO = 'L',C7_GRUPCOM = '',C7_USER = ''"
   cQuery += " WHERE C7_FILIAL='"+xFilial("SC7")+"' AND "
   cQuery += " C7_NUM='"+cNumPed+"'"
   cQuery += " AND D_E_L_E_T_=' ' "
   TcSqlExec(cQuery)
   TcRefresh("SC7")
   
Else

   If !Empty(cCodAprov)
      If Len(aGrAprov) > 1
         cCodAprov := SelGrup(aGrAprov)
      EndIf
      cAliasTMP := GetNextAlias() 
      If (lAltGrpApv)
         BeginSql Alias cAliasTMP //Inicio do Embedded SQL
            SELECT TOP 1 AL_COD,AL_VALOR,AL_VALORMX  FROM %table:SAL% SAL
            WHERE AL_FILIAL = %xFilial:SAL%
            AND SAL.%NotDel%
            AND AL_GERENTE = %Exp:cCodAprov%
            AND AL_VALOR <= %Exp:Alltrim(Str(nValPed))%
            AND AL_VALORMX >= %Exp:Alltrim(Str(nValPed))%
            AND AL_DESC LIKE '{INFO}%'
            ORDER BY AL_VALOR,AL_VALORMX
         EndSql
      else
         BeginSql Alias cAliasTMP //Inicio do Embedded SQL
            SELECT TOP 1 AL_COD,AL_VALOR,AL_VALORMX  FROM %table:SAL% SAL
            WHERE AL_FILIAL = %xFilial:SAL%
            AND SAL.%NotDel%
            AND AL_GERENTE = %Exp:cCodAprov%
            AND AL_VALOR <= %Exp:Alltrim(Str(nValPed))%
            AND AL_VALORMX >= %Exp:Alltrim(Str(nValPed))%
            AND AL_DESC NOT LIKE '{INFO}%'
            ORDER BY AL_VALOR,AL_VALORMX
         EndSql
      EndIf

	   dbSelectArea(cAliasTMP)
	   (cAliasTMP)->(dbGotop())
	   If !(cAliasTMP)->(Eof())
	      cRet := (cAliasTMP)->AL_COD
	   EndIf
	   dbSelectArea(cAliasTMP)
	   (cAliasTMP)->(dbCloseArea())
	            
	   cQuery := "UPDATE "+RetSqlname("SC7")
	   cQuery += " SET C7_APROV = '"+cRet+"'"
	   cQuery += " WHERE C7_FILIAL='"+xFilial("SC7")+"' AND "
	   cQuery += " C7_NUM='"+cNumPed+"'"
	   cQuery += " AND D_E_L_E_T_=' ' "
	   TcSqlExec(cQuery)
	   TcRefresh("SC7")
   EndIf
EndIf

RestArea(aAreaOld)
RestArea(aAreaSC7)

If AllTrim(FunName()) == "MATA160" .Or. AllTrim(FunName()) == "MATA161"
   If RecLock("SC7",.F.)
      Replace C7_CONTA    With SC8->C8_CONTA,;
              C7_CC       With SC8->C8_CC,;     
              C7_ITEMCTA  With SC8->C8_ITEMCTA,;
              C7_CODREF  With SC8->C8_CODREF,;
              C7_VLVERBA  With SC8->C8_VLVERBA
              
      SC7->(MsUnLock())
   EndIf
   MsgBox("O número do Pedido de Compra gerado é:  "+ cNumPed)
EndIf


Return(cRet)



Static Function SelGrup(aGrAprov)
************************************************************************
*
**
Local oDlgGrp
Local oSelGroup 
//Local nXi       := 0
Local cRet      := ""
Local aCabGrp   := {} 
Local aDadGrp   := {}
Local aAreaSAK  := SAK->(GetArea())
Local aAreaSAL  := SAL->(GetArea())
Local oOk       := LoadBitMap(GetResources(), "LBOK")
Local oNo       := LoadBitMap(GetResources(), "LBNO")


dbSelectArea("SAL")
SAL->(dbSetOrder(4))//AL_FILIAL+AL_GERENTE


dbSelectArea("SAK")
SAK->(dbSetOrder(1))//AK_FILIAL+AK_COD
SAK->(dbGoTop())
While !SAK->(Eof()) 
   SAL->(dbSeek(xFilial("SAL")+SAK->AK_COD))
   If !SAL->(Eof())
      Aadd(aDadGrp,{.F.,SAK->AK_COD,SAK->AK_NOME})
   EndIf
   SAK->(dbSkip())
End
RestArea(aAreaSAK)
RestArea(aAreaSAL)

Aadd(aCabGrp,"")              
Aadd(aCabGrp,OemToAnsi("Codigo"))
Aadd(aCabGrp,OemToAnsi("Descrição"))

If !Empty(aDadGrp)
   oDlgGrp := MSDialog():New(000,000,200,400,OemToAnsi('Grupo de Aprovadores'),,,,nor(DS_MODALFRAME,WS_POPUP,WS_CAPTION,WS_VISIBLE),,,,,.T.,,,)
   oDlgGrp:lESCClose := .F.

   oSelGroup := TWBrowse():New(005,005,190,090,,aCabGrp,,oDlgGrp,,,,,,,,,,,,.F.,,.T.,,.F.,,,)
   oSelGroup:SetArray(aDadGrp)
   oSelGroup:bLDblClick   := { || fSelUm(@oSelGroup,@aDadGrp,@oDlgGrp)}
   oSelGroup:bLine        := {|| {If(aDadGrp[oSelGroup:nAt,1],oOk,oNo),aDadGrp[oSelGroup:nAT][2],aDadGrp[oSelGroup:nAT][3]}}

   oDlgGrp:Activate(,,, .T.,{||  }, ,{||  /*EnchoiceBar(oDlgGrp,{|| nOpcX := 1 ,oDlgGrp:End()  },{|| oDlgGrp:End()})*/ })
   
   cRet := aDadGrp[aScan(aDadGrp,{|Ax| Ax[1] })][2] 

EndIf                     

Return(cRet)



Static Function fSelUm(oSel,aDados,oDlgGrp)
*************************************************************************
* Permite seleçao apenas uma opçao por vez.
****
Local nXi := 0
For nXi := 1 to Len(aDados)                
    aDados[nXi,1] := .F.
    oSel:DrawSelect()
Next nXi     


aDados[oSel:nAt,1] := !aDados[oSel:nAt,1]
oSel:DrawSelect()
      
oSel:Refresh()
oDlgGrp:End()

Return
