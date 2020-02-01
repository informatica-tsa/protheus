#Include "Rwmake.ch"
#Include "vkey.ch"
/*
+-----------+------------+----------------+---------------+--------+------------+
| Programa  | A103F6     | Desenvolvedor  | Mr. Carraro   | Data   | 22/08/02   |
+-----------+------------+----------------+---------------+--------+------------+
| Descricao | Tela de Consultas de Pedidos de Compra em Aberto na Nota Fiscal   |
+-----------+-------------------------------------------------------------------+
| Uso       | Expecifico EPC/TSA                                                |
+-----------+-------------------------------------------------------------------+
|                   Modificacoes Apos Desenvolvimento Inicial                   |
+-------------+---------+-------------------------------------------------------+
| Humano      | Data    | Motivo                                                |
+-------------+---------+-------------------------------------------------------+
+-------------+---------+-------------------------------------------------------+
*/

User Function A103F4ItemPC(lUsaFiscal,aPedido)

Local cSeek
Local nOpca 		:= 0
Local aArea			:= GetArea()
Local aAreaSA2		:= SA2->(GetArea())
Local aAreaSC7		:= SC7->(GetArea())
Local aAreaSB1		:= SB1->(GetArea())
Local bSavSetKey	:= SetKey(VK_F4,Nil)
Local bSavKeyF5     := SetKey(VK_F5,Nil)
Local bSavKeyF6     := SetKey(VK_F6,Nil)
Local bSavKeyF7     := SetKey(VK_F7,Nil)
Local bSavKeyF8     := SetKey(VK_F8,Nil)
Local bSavKeyF9     := SetKey(VK_F9,Nil)
Local nFreeQt		:= 0
Local aArrSldo		:= {}
Local aArrayF4		:= {}
Local aButtons		:= { {'PESQUISA',{||A103VisuPC(aArrSldo[oQual:nAt][2])},"Visualiza Pedido de Compras"} }
Local nPosPRD		:= aScan(aHeader,{|x| Alltrim(x[2]) == "D1_COD" })
Local nPosPDD		:= aScan(aHeader,{|x| Alltrim(x[2]) == "D1_PEDIDO" })
Local nPosITM		:= aScan(aHeader,{|x| Alltrim(x[2]) == "D1_ITEMPC" })
Local nPosQTD		:= aScan(aHeader,{|x| Alltrim(x[2]) == "D1_QUANT" })
Local cVar			:= aCols[n][nPosPrd]
Local nSavQual
Local nPed			:= 0
Local aCab, aNew, nAuxNew
Local lContinua := .T.
Local oDlgPed
Local oQual
Local nAuxCNT := 0
  
#IFDEF SHELL
  	cVar := M->D1_COD
#ENDIF

If PCount() == 0
   lUsaFiscal	:= .T.
   aPedido		:= {}
EndIf

//Impede de executar a rotina quando a tecla F3 estiver ativa
If Type("InConPad") == "L"
   lContinua := !InConPad
EndIf

If lContinua
   If MaFisFound('NF') .Or. !lUsaFiscal
      If cTipo == 'N'
         If Empty(cVar)
			dbSelectArea("SC7")
			dbSetOrder(9)
			If lConsLoja
 			   cSeek := cA100For+cLoja
			   dbSeek(xFilEnt(xFilial("SC7"))+cSeek)
			Else
 			   cSeek := cA100For
			   dbSeek(xFilEnt(xFilial("SC7"))+cSeek)
            EndIf
		 Else
  	        dbSelectArea("SC7")
			dbSetOrder(6)
  		    If lConsLoja
 			   cSeek := cVar+cA100For+cLoja
               dbSeek(xFilEnt(xFilial("SC7"))+cSeek)
		    Else
 	           cSeek := cVar+cA100For
               dbSeek(xFilEnt(xFilial("SC7"))+cSeek)
		    EndIf
         EndIf
         If ! Eof()
 	        If Empty(cVar)
               If lConsLoja
 		          cCond := "C7_FILENT+C7_FORNECE+C7_LOJA"
		       Else
                  cCond := "C7_FILENT+C7_FORNECE"
               EndIf
            Else
               If lConsLoja
                  cCond := "C7_FILENT+C7_PRODUTO+C7_FORNECE+C7_LOJA"
               Else
                  cCond := "C7_FILENT+C7_PRODUTO+C7_FORNECE"
               EndIf
            EndIf
            While !Eof() .And. xFilEnt(cFilial)+cSeek == &(cCond)
                //Filtra os Pedidos Bloqueados e Previstos.
                If (GetMV("MV_RESTNFE") == "S" .And. C7_CONAPRO == "B") .Or. C7_TPOP == "P"
                   dbSkip()
                   Loop
                EndIf
                If Empty(C7_RESIDUO)
				   nFreeQT := 0
                   nPed := aScan(aPedido,{|x| x[1] = C7_NUM+C7_ITEM})
                   nFreeQT -= Iif(nPed>0,aPedido[nPed,2],0)
                   For nAuxCNT := 1 To Len( aCols )
                       If (nAuxCNT # n) .And. ;
                          (aCols[ nAuxCNT,nPosPRD ] == C7_PRODUTO) .And. ;
                          (aCols[ nAuxCNT,nPosPDD ] == C7_NUM) .And. ;
                          (aCols[ nAuxCNT,nPosITM ] == C7_ITEM) .And. ;
                          ! ATail( aCols[ nAuxCNT ] )
                          nFreeQT += aCols[ nAuxCNT,nPosQTD ]
                       EndIf
                   Next nAuxCnt
                   If ((nFreeQT := (C7_QUANT-C7_QUJE-C7_QTDACLA-nFreeQT)) > 0)
                      AAdd( aArrayF4,{ SC7->C7_NUM,;
                                       SC7->C7_PRODUTO,;
                                       SA2->A2_NOME,;                                          
                                       SC7->C7_CC,;
                                       DTOC(SC7->C7_DATPRF),;
                                       TransForm(nFreeQT,PesqPict("SC7","C7_TOTAL"))})                                          
                      AAdd( aArrSldo,{nFreeQT,RecNo()} )
                   Endif
                Endif
                dbSkip()
            End
            If ! Empty(aArrayF4)
               DEFINE MSDIALOG oDlgPed FROM 030,020 TO 265,521 TITLE "Pedido de Compras em Aberto" Of oMainWnd PIXEL
               aCab := {"Pedido","Produto","Fornecedor","C.Custos","Entrega","Total"}
               oQual := TWBrowse():New( 029,004,243,076,,aCab,{030,040,100,030,030,050},oDlgPed,,,,,,,,,,,,.F.,,.T.,,.F.,,,)
               oQual:SetArray(aArrayF4)
               oQual:bLine := { || aArrayF4[oQual:nAT] }
               If ! Empty(cVar)
                  @ 015,004 SAY "Produto" Size 47,09
                  @ 014,030 Get cVar Picture PesqPict('SB1','B1_COD') When .F. SIZE 80,09 
               Else
                  @ 015,004 SAY "Selecione o Pedido de Compra" 
               EndIf
               ACTIVATE MSDIALOG oDlgPed ON INIT EnchoiceBar(oDlgPed,{|| nSavQual:=oQual:nAT,nOpca:=1,oDlgPed:End()},{||oDlgPed:End()},,aButtons)
               If nOpca == 1
                  dbSelectArea("SC7")
                  dbGoto(aArrSldo[nSavQual][2])
                  TransfPCtoAcols(aArrSldo[nSavQual][2],n,aArrSldo[nSavQual][1])
               EndIf
               If lUsaFiscal 
                  Eval(bRefresh)       
               EndIf
            Else
               HELP(" ",1,"A103F4")
            EndIf
         Else
            HELP(" ",1,"A103F4")
         EndIf
      Else
         HELP('   ',1,'A103TIPON')
      EndIf
    Else
      HELP('   ',1,'A103CAB')
    EndIf	
Endif

SetKey(VK_F4,bSavSetKey)
SetKey(VK_F5,bSavKeyF5)
SetKey(VK_F6,bSavKeyF6)
SetKey(VK_F7,bSavKeyF7)
SetKey(VK_F8,bSavKeyF8)
SetKey(VK_F9,bSavKeyF9)

RestArea(aAreaSA2)
RestArea(aAreaSC7)
RestArea(aAreaSB1)
RestArea(aArea)


Return


Static Function TransfPCtoAcols(nRecSC7,nItem,nSalPed,cItem,lPreNota)
************************************************************************************************************
* Transfere o Conteudo da MSDIALOG para aCols
***
Local aArea		:= GetArea()
Local aAreaSC7	:= SC7->(GetArea())
Local aAreaSF4	:= SF4->(GetArea())
Local aAreaSB1	:= SB1->(GetArea())
Local ny := 0
Local nCntFor := 0

If Type("lPreNota") == Nil
   lPreNota := .F.
EndIf   

//Verifica a existencia do item
If nItem == Nil .Or. nItem > Len(aCols)
   //Faz a montagem de uma linha em branco no aCols.   
   aadd(aCols,Array(Len(aHeader)+1))
   For ny := 1 to Len(aHeader)
       If Trim(aHeader[ny][2]) == "D1_ITEM"
          aCols[Len(aCols)][ny] 	:= If(cItem!=Nil,cItem,"01")
       ElseIf ( aHeader[ny][10] != "V")
          aCols[Len(aCols)][ny] := CriaVar(aHeader[ny][2])
       EndIf
       aCols[Len(aCols)][Len(aHeader)+1] := .F.
   Next ny
   nItem := Len(aCols)
EndIf

dbSelectArea("SC7")
dbGoto(nRecSC7)

dbSelectArea("SB1")
dbSetOrder(1)
MsSeek(xFilial()+SC7->C7_PRODUTO)
  
dbSelectArea("SF4")
dbSetOrder(1)
MsSeek(xFilial()+SC7->C7_TES)
  
If SC7->(!Eof())
   cCondicao := SC7->C7_COND
   If MaFisFound()
      //Inicia a Carga do item nas funcoes MATXFIS
      MaFisIniLoad(nItem)
      dbSelectArea("SX3")
      dbSetOrder(1)
      dbSeek("SC7")
      While !EOF() .And. (X3_ARQUIVO == "SC7")
          cValid	:= AllTrim(UPPER(SX3->X3_VALID))
          If "MAFISREF"$cValid
             nPosRef := AT('MAFISREF("',cValid) + 10
             cRefCols:=Substr(cValid,nPosRef,AT('","MT120",',cValid)-nPosRef )
             //Carrega os valores direto do SC7.
             Do Case
                Case cRefCols == "IT_QUANT"
                     If ! lPreNota
                        MaFisLoad(cRefCols,nSalPed,nItem)
                     EndIf
                Case cRefCols == "IT_PRCUNI"
                     If ! lPreNota
                        MaFisLoad(cRefCols,LXA103CReaj(SC7->C7_REAJUST,lReajuste),nItem)
                     EndIf
                Case cRefCols == "IT_VALMERC"
                     If ! lPreNota
                        MaFisLoad(cRefCols,IIF(SC7->C7_QUANT==nSalPed,xMoeda(SC7->C7_TOTAL,SC7->C7_MOEDA,,M->dDEmissao,,SC7->C7_TXMOEDA,),NoRound(nSalPed*LXA103CReaj(SC7->C7_REAJUST,lReajuste),TamSX3('D1_TOTAL')[2])),nItem)
                     Endif
                Case cRefCols == "IT_DESCONTO"
                     If ! lPreNota
                        MaFisLoad(cRefCols,xMoeda(SC7->C7_VLDESC,SC7->C7_MOEDA,1,M->dDEmissao,,SC7->C7_TXMOEDA,),nItem)
                     EndIf
                Case cRefCols == "IT_VALEMB"
                     MaFisLoad(cRefCols,xMoeda(SC7->C7_VALEMB,SC7->C7_MOEDA,1,M->dDEmissao,,SC7->C7_TXMOEDA,),nItem)
                Case cRefCols == "IT_VALIPI"
                     MaFisLoad(cRefCols,xMoeda(SC7->C7_VALIPI,SC7->C7_MOEDA,1,M->dDEmissao,,SC7->C7_TXMOEDA,),nItem)
                Case cRefCols == "IT_VALICM"
                     MaFisLoad(cRefCols,xMoeda(SC7->C7_VALICM,SC7->C7_MOEDA,1,M->dDEmissao,,SC7->C7_TXMOEDA,),nItem)
                Case cRefCols == "IT_BASEICM"
                     MaFisLoad(cRefCols,xMoeda(SC7->C7_BASEICM,SC7->C7_MOEDA,1,M->dDEmissao,,SC7->C7_TXMOEDA,),nItem)
                Case cRefCols == "IT_BASEIPI"
                     MaFisLoad(cRefCols,xMoeda(SC7->C7_BASEIPI,SC7->C7_MOEDA,1,M->dDEmissao,,SC7->C7_TXMOEDA,),nItem)
                Case cRefCols == "IT_SEGURO"
                     MaFisLoad(cRefCols,xMoeda(SC7->C7_SEGURO,SC7->C7_MOEDA,1,M->dDEmissao,,SC7->C7_TXMOEDA,),nItem)
                Case cRefCols == "IT_DESPESA"
                     MaFisLoad(cRefCols,xMoeda(SC7->C7_DESPESA,SC7->C7_MOEDA,1,M->dDEmissao,,SC7->C7_TXMOEDA,),nItem)
                Case cRefCols == "IT_FRETE"
                     MaFisLoad(cRefCols,xMoeda(SC7->C7_VALFRE,SC7->C7_MOEDA,1,M->dDEmissao,,SC7->C7_TXMOEDA,),nItem)
                OtherWise
                     MaFisLoad(cRefCols,&("SC7->"+ SX3->X3_CAMPO),nItem)
             EndCase
          EndIf
          dbSelectArea("SX3")
          dbSkip()
      End
      //Carrega o CF direto do SF4
      If ! Empty(SC7->C7_TES)
         MaFisLoad("IT_CF",MaFisCFO(nItem,SF4->F4_CF),nItem)
      EndIf
      MaFisEndLoad(nItem)
   EndIf
   //Atualiza os demais campos do Pedido
   For nCntFor := 1 To Len(aHeader)
       Do Case
          Case Trim(aHeader[nCntFor,2]) == "D1_COD"
               aCols[nItem,nCntFor] := SC7->C7_PRODUTO
          Case Trim(aHeader[nCntFor,2]) == "D1_DESCRIC"
               aCols[nItem,nCntFor] := SC7->C7_DESCRI               
          Case Trim(aHeader[nCntFor,2]) == "D1_TOTAL"
               If ! lPreNota
                   aCols[nItem,nCntFor] := IIf(SC7->C7_QUANT==nSalPed,xMoeda(SC7->C7_TOTAL,SC7->C7_MOEDA,,M->dDEmissao,,SC7->C7_TXMOEDA,),NoRound(nSalPed*LXA103CReaj(SC7->C7_REAJUST,lReajuste),TamSX3('D1_TOTAL')[2]))
               EndIf
          Case Trim(aHeader[nCntFor,2]) == "D1_TES" .And. !Empty(SC7->C7_TES)
               aCols[nItem,nCntFor] := SC7->C7_TES
          Case Trim(aHeader[nCntFor,2]) == "D1_PEDIDO"
               aCols[nItem,nCntFor] := SC7->C7_NUM
          Case Trim(aHeader[nCntFor,2]) == "D1_QUANT"
               If ! lPreNota
                  aCols[nItem,nCntFor] := nSalPed
               EndIf
          Case Trim(aHeader[nCntFor,2]) == "D1_VUNIT"
               If ! lPreNota
                  aCols[nItem,nCntFor] := LXA103CReaj(SC7->C7_REAJUST,lReajuste)
               EndIf
          Case Trim(aHeader[nCntFor,2]) == "D1_ITEMPC"
               aCols[nItem,nCntFor] := SC7->C7_ITEM
          Case Trim(aHeader[nCntFor,2]) == "D1_LOCAL"
               aCols[nItem,nCntFor] := SC7->C7_LOCAL
          Case Trim(aHeader[nCntFor,2]) == "D1_CC"
               aCols[nItem,nCntFor] := SC7->C7_CC
          Case Trim(aHeader[nCntFor,2]) == "D1_DTREF"
               aCols[nItem,nCntFor] := SC7->C7_DATPRF
          Case Trim(aHeader[nCntFor,2]) == "D1_ITEMCTA"
               aCols[nItem,nCntFor] := SC7->C7_ITEMCTA
          Case Trim(aHeader[nCntFor,2]) == "D1_CONTA"
               aCols[nItem,nCntFor] := Iif( Empty(SC7->C7_CONTA), SB1->B1_CONTA, SC7->C7_CONTA )
          Case Trim(aHeader[nCntFor,2]) == "D1_UM"
               aCols[nItem,nCntFor] := SC7->C7_UM
          Case Trim(aHeader[nCntFor,2]) == "D1_SEGUM"
               aCols[nItem,nCntFor] := SC7->C7_SEGUM
          Case Trim(aHeader[nCntFor,2]) == "D1_QTSEGUM"
               If ! lPreNota
                  aCols[nItem,nCntFor] := SC7->C7_QTSEGUM
               EndIf
          Case Trim(aHeader[nCntFor,2]) == "D1_DESC"
               If ! lPreNota
                  aCols[nItem,nCntFor] := SC7->C7_DESC
               EndIf
          Case Trim(aHeader[nCntFor,2]) == "D1_VALDESC"
               If ! lPreNota
                  aCols[nItem,nCntFor] := SC7->C7_VLDESC
               EndIf
       EndCase
   Next nCntFor
EndIf

//Verifica se o Produto possui TE Padrao
If MaFisFound()
   If Empty(SC7->C7_TES) .And. !Empty(SB1->B1_TE)
      MaFisAlt("IT_TES",SB1->B1_TE,nItem)
   Else
      MaFisAlt("IT_TES",SC7->C7_TES,nItem)
   EndIf
   MaFisToCols(aHeader,aCols,,"MT100")	
EndIf

RestArea(aAreaSB1)
RestArea(aAreaSF4)
RestArea(aAreaSC7)
RestArea(aArea)

Return(.T.)