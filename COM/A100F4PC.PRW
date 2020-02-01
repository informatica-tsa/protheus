#include "rwmake.ch"        // incluido pelo assistente de conversao do AP5 IDE em 25/0]6/01
///#include "FIVEWIN.CH"

User Function A100F4PC()        // incluido pelo assistente de conversao do AP5 IDE em 25/06/01

Local nx := 1
Local nAuxCNT := 1
Local nxI := 1

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Declaracao de variaveis utilizadas no programa atraves da funcao    ³
//³ SetPrvt, que criara somente as variaveis definidas pelo usuario,    ³
//³ identificando as variaveis publicas do sistema utilizadas no codigo ³
//³ Incluido pelo assistente de conversao do AP5 IDE                    ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

SetPrvt("AALIAS,AALIASF4,CVAR1,CVARCHAMA,AHEADEROLD,NNOLD")
SetPrvt("ACOLSOLD,CVAR,BKEYF4,LALCADA,NX,CPROD")
SetPrvt("NPOSPRD,CLOCAL,CTES,NPOSPDD,NPOSITM,NPOSQTD")
SetPrvt("LCONTINUE,CSEEK,CCOND,AHEADER,ACOLS2,AARRSLDO")
SetPrvt("NFREEQT,NQUAL")
SetPrvt("NPERCIPI,NQUANT,NVALUNIT,NPERCICM,NVALTOTAL,")

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³ A100F4PC ³ Autor ³Eduardo Carraro        ³ Data ³ 02/10/00 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡ao ³ Rotina para mostrar pedidos no MATA100 customizados        ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Especifico para EPC/TSA                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
aAlias   := { Alias(), IndexOrd(), Recno() }
aAliasF4 := { SF4->(IndexOrd()), SF4->(Recno()) }
cVar1    := ""
cVarChama:= ReadVar() //Variavel atual na chamada da funcao
aHeaderOld:= aHeader
nNOld    := n
aColsOld  := aCols
cVar  := &(ReadVar())
bKeyF4  := SetKey( 115 )
lAlcada :=.F.
If Alltrim(cVarChama) == "CA100FOR"
   A100F4()
//   SetKey( 115,bKeyF4 )
   ObjectMethod(oGet,"ForceRefresh()")
   Return
EndIf
If ! Alltrim(cVarChama) $ "M->D1_COD/CA100FOR"
   MsgBox("Posicione Sobre o Produto ou Fornecedor, digite o Codigo do Mesmo e Tecle <F4> para Consultar os Pedidos Pendentes...","ATENCAO","INFO")
   Return
EndIf

If GetMV("MV_ALCADA") == "S"
   If ! File(cArqAlca)
      lAlcada := .F.
   Else
      lAlcada := .T.
   EndIf
EndIf

For nx := 1 to Len(aHeader)
	Do Case
       Case Trim(aHeader[nX][2]) == "D1_COD"
			cProd:=aCols[n][nx]
			nPosPRD := nX
       Case Trim(aHeader[nX][2]) == "D1_LOCAL"
			cLocal:=aCols[n][nx]
       Case Trim(aHeader[nX][2]) == "D1_TES"
			cTES  :=aCols[n][nx]
       Case Trim(aHeader[nX][2]) == "D1_PEDIDO"
			nPosPDD := nX
       Case Trim(aHeader[nX][2]) == "D1_ITEMPC"
			nPosITM := nX
       Case Trim(aHeader[nX][2]) == "D1_QUANT"
			nPosQTD := nX
	EndCase
Next

dbSelectArea("SF4")
dbSeek(xFilial("SF4")+cTes)

If (SF4->F4_PODER3=="D")
	lContinue := .T.
EndIf

If (cTipo=="D")
	lContinue := .T.
EndIf

If lRecebto .And. ! lContinue
   Return
Endif

dbSelectArea(aAlias[1])

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Verifica o arquivo a ser pesquisado                          ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
dbSelectArea("SC7")
dbSetOrder(6)     // Filial de Entrega
If lConsLoja
    cSeek:=cVar+SA2->A2_COD+SA2->A2_LOJA
    dbSeek(xFilial("SC7")+cSeek)
Else
    cSeek:=cVar+SA2->A2_COD
    dbSeek(xFilial("SC7")+cSeek)
EndIf
If Eof()
	HELP(" ",1,"A100F4")
	dbSetOrder(1)
    SetKey( 115,bKeyF4 )
	Return
Endif

If lConsLoja
    cCond := "C7_FILENT+C7_PRODUTO+C7_FORNECE+C7_LOJA"
Else
    cCond := "C7_FILENT+C7_PRODUTO+C7_FORNECE"
EndIf
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Criacao e alimentacao da Multiline  ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
aHeader:={}
aCols2:={}
aArrSldo:={}
DbSelectArea("SX3")
DbSetOrder(1)
DbSeek("SC7")
While !Eof() .and. SX3->X3_ARQUIVO == "SC7"
   If Alltrim(X3_CAMPO)=="C7_NUM"
      AADD(aHeader,{ALLTRIM(X3_TITULO),X3_CAMPO,X3_PICTURE,X3_TAMANHO,;
                    X3_DECIMAL,X3_VALID,X3_USADO,X3_TIPO,X3_ARQUIVO})
   EndIf
   dbSelectArea("SX3")
   DbSkip()
End

DbSelectArea("SX3")
DbSetOrder(1)
DbSeek("SC7")
While !Eof() .and. SX3->X3_ARQUIVO == "SC7"
   If Alltrim(X3_CAMPO)=="C7_CONTATO"
      AADD(aHeader,{ALLTRIM(X3_TITULO),X3_CAMPO,X3_PICTURE,X3_TAMANHO,;
                    X3_DECIMAL,X3_VALID,X3_USADO,X3_TIPO,X3_ARQUIVO})
   EndIf
   dbSelectArea("SX3")
   DbSkip()
End

DbSelectArea("SX3")
DbSetOrder(1)
DbSeek("SC7")
While !Eof() .and. SX3->X3_ARQUIVO == "SC7"
   If Alltrim(X3_CAMPO)=="C7_TOTAL"
      AADD(aHeader,{ALLTRIM(X3_TITULO),X3_CAMPO,X3_PICTURE,X3_TAMANHO,;
                    X3_DECIMAL,X3_VALID,X3_USADO,X3_TIPO,X3_ARQUIVO})
   EndIf
   dbSelectArea("SX3")
   DbSkip()
End

DbSelectArea("SX3")
DbSetOrder(1)
DbSeek("SC7")
While !Eof() .and. SX3->X3_ARQUIVO == "SC7"
   If Alltrim(X3_CAMPO)=="C7_CC"
      AADD(aHeader,{ALLTRIM(X3_TITULO),X3_CAMPO,X3_PICTURE,X3_TAMANHO,;
                    X3_DECIMAL,X3_VALID,X3_USADO,X3_TIPO,X3_ARQUIVO})
   EndIf
   dbSelectArea("SX3")
   DbSkip()
End

DbSelectArea("SX3")
DbSetOrder(1)
DbSeek("SC7")
While !Eof() .and. SX3->X3_ARQUIVO == "SC7"
   If Alltrim(X3_CAMPO)=="C7_DATPRF"
      AADD(aHeader,{ALLTRIM(X3_TITULO),X3_CAMPO,X3_PICTURE,X3_TAMANHO,;
                    X3_DECIMAL,X3_VALID,X3_USADO,X3_TIPO,X3_ARQUIVO})
   EndIf
   dbSelectArea("SX3")
   DbSkip()
End

DbSelectArea("SX3")
DbSetOrder(1)
DbSeek("SA2")
While !Eof() .and. SX3->X3_ARQUIVO == "SA2"
   If (X3USO (SX3->X3_USADO)) .And. (cNivel >= SX3->X3_NIVEL)
      If Alltrim(X3_CAMPO)=="A2_NOME"
         AADD(aHeader,{ALLTRIM(X3_TITULO),X3_CAMPO,X3_PICTURE,X3_TAMANHO,;
                       X3_DECIMAL,X3_VALID,X3_USADO,X3_TIPO,X3_ARQUIVO})
      EndIf
   EndIf
   dbSelectArea("SX3")
   DbSkip()
End

DbSelectArea("SX3")
DbSetOrder(1)
DbSeek("SC7")
While !Eof() .and. SX3->X3_ARQUIVO == "SC7"
   If (X3USO (SX3->X3_USADO)) .And. (cNivel >= SX3->X3_NIVEL)
      If Alltrim(X3_CAMPO)=="A2_NOME"
         AADD(aHeader,{ALLTRIM(X3_TITULO),X3_CAMPO,X3_PICTURE,X3_TAMANHO,;
                       X3_DECIMAL,X3_VALID,X3_USADO,X3_TIPO,X3_ARQUIVO})
      EndIf
   EndIf
   dbSelectArea("SX3")
   DbSkip()
End

DbSelectArea("SC7")
aCols:={}
While ! Eof() .And. xFilial("SC7")+cSeek == &(cCond)
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Filtra os Pedidos Bloqueados e Previstos.                ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If (GetMV("MV_RESTNFE") == "S" .And. C7_CONAPRO == "B") .Or. C7_TPOP == "P"
		dbSkip()
		Loop
	EndIf
    DbSelectArea("SA2")
    DbSetOrder(1)
    DbSeek(xFilial("SA2")+SC7->C7_FORNECE)
    DbSelectArea("SC7")
	If Empty(C7_RESIDUO)
		nFreeQT := 0
		For nAuxCNT := 1 To Len( aCols )
            If (nAuxCNT #n) .And. ;
               (aCols[ nAuxCNT,nPosPRD ] == C7_PRODUTO) .And. ;
               (aCols[ nAuxCNT,nPosPDD ] == C7_NUM)     .And. ;
               (aCols[ nAuxCNT,nPosITM ] == C7_ITEM)    .And. ;
               ! ATail( aCols[ nAuxCNT ] )
                nFreeQT := nFreeQt + aCols[ nAuxCNT,nPosQTD ]
			EndIf
		Next
		If ((nFreeQT := (C7_QUANT-C7_QUJE-C7_QTDACLA-nFreeQT)) > 0)
           AADD(aCols,Array(Len(aHeader)+1))
           FOR nxI := 1 to LEN(aHeader)
               If Alltrim(aHeader[nXi,2]) == "A2_NOME"
                  aCols[Len(aCols),nXi]:=SA2->A2_NOME
               Else
                  aCols[Len(aCols),nxI]:=FieldGet(FieldPos(aHeader[nxI,2]))
               EndIf
           NEXT
           aCols[Len(aCols),Len(aHeader)+1]:=.F.
           AAdd( aCols2,{nFreeQT,Recno()} )
		EndIf
	Endif
	dbSkip()
End

If ! Empty(aCols)
   @ 0,1 TO 140,420 DIALOG oDlg3 TITLE "Pedidos a Faturar"
   @ 6,5 TO 48,205 MULTILINE
   @ 50,140 BMPBUTTON TYPE 01 ACTION GravF4()// Substituido pelo assistente de conversao do AP5 IDE em 25/06/01 ==>    @ 50,140 BMPBUTTON TYPE 01 ACTION Execute(GravF4)
   @ 50,168 BMPBUTTON TYPE 02 ACTION CancF4()// Substituido pelo assistente de conversao do AP5 IDE em 25/06/01 ==>    @ 50,168 BMPBUTTON TYPE 02 ACTION Execute(CancF4)
   ACTIVATE Dialog oDlg3 CENTERED
Else
	HELP(" ",1,"A100F4")
Endif

Return

**********************************************************************
* Rotina para Cancelamento
****

// Substituido pelo assistente de conversao do AP5 IDE em 25/06/01 ==> Function CancF4
Static Function CancF4()

Close(oDlg3)
SetKey( 115,bKeyF4 )
aCols:=aColsOld
aHeader:=aHeaderOld
n := nNOld

Return


**********************************************************************
* Rotina para Gravacao
****

// Substituido pelo assistente de conversao do AP5 IDE em 25/06/01 ==> Function GravF4
Static Function GravF4()

Local nX := 1

nQual:=n
DbSelectArea("SC7")
dbGoto(aCols2[nQual][2])
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Verifica se Pedido ja esta Liberado.                     ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If lAlcada
   If Empty(C7_CODLIB)
      Help(" ",1,"A205NOLIB")
      SetKey( 115,bKeyF4 )
      Return
   EndIf
EndIf
SoftLock("SC7")
Aadd(aRegLock,{"SC7",Recno()})
aCols:=aColsOld
aHeader:=aHeaderOld
n := nNOld
For nX := 1 To Len(aHeader)
    Do Case
       Case Trim(aHeader[nX][2]) == "D1_DTREF"
            aCols[n][nX] := SC7->C7_DATPRF           
       Case Trim(aHeader[nX][2]) == "D1_PEDIDO"
            aCols[n][nX] := SC7->C7_NUM
       Case Trim(aHeader[nX][2]) == "D1_ITEMPC"
            aCols[n][nX] := SC7->C7_ITEM
       Case Trim(aHeader[nX][2]) == "D1_LOCAL"
            aCols[n][nX] := SC7->C7_LOCAL
       Case Trim(aHeader[nX][2]) == "D1_IPI"
            nPercIPI     := SC7->C7_IPI
            aCols[n][nX] := SC7->C7_IPI
       Case Trim(aHeader[nX][2]) == "D1_QUANT"
            nQuant   := aCols2[nQual][1]
            aCols[n][nX] := nQuant
       Case Trim(aHeader[nX][2]) == "D1_VUNIT"
            nValUnit := A100CReaj(SC7->C7_REAJUST,lReajuste)
            aCols[n][nX] := A100CReaj(SC7->C7_REAJUST,lReajuste)
       Case Trim(aHeader[nX][2]) == "D1_PICM"
            #IFNDEF SPANISH
               nPercICM := aliqicms(cTipo,cTipoNF)
               aCols[n][nX] := aliqicms(cTipo,cTipoNF)
            #ENDIF
       Case Trim(aHeader[nX][2]) == "D1_CC"
            aCols[n][nX] := SC7->C7_CC
       Case Trim(aHeader[nX][2]) == "D1_CONTA"
            aCols[n][nX] := Iif( Empty(SC7->C7_CONTA), SB1->B1_CONTA, SC7->C7_CONTA )
       Case Trim(aHeader[nX][2]) == "D1_VALDESC"
            aCols[n][nX] := IIF(SC7->C7_VLDESC==0,CalcDesc(SC7->C7_TOTAL,SC7->C7_DESC1,SC7->C7_DESC2,SC7->C7_DESC3),SC7->C7_VLDESC)
       Case Trim(aHeader[nX][2]) == "D1_DESC"
            aCols[n][nX] := IIF(SC7->C7_VLDESC==0,(CalcDesc(SC7->C7_TOTAL,SC7->C7_DESC1,SC7->C7_DESC2,SC7->C7_DESC3)/SC7->C7_TOTAL)*100,(SC7->C7_VLDESC/SC7->C7_TOTAL)*100)
    EndCase
Next nX
For nX := 1 To Len(aHeader)
    If Trim(aHeader[nX][2]) == "D1_TOTAL"
       nValTotal := NoRound(nQuant * nValUnit,2)
       aCols[n][nX] := NoRound(nQuant * nValUnit,2)
    Endif
Next nX
For nX := 1 To Len(aHeader)
    Do Case
       Case Trim(aHeader[nX][2]) == "D1_VALIPI"
            aCols[n][nX] := (nPercIPI * nValTotal)/100
       Case Trim(aHeader[nX][2]) == "D1_VALICM"
            aCols[n][nX] := (nPercICM * nValTotal)/100
    EndCase
Next nX

Close(oDlg3)
SetKey( 115,bKeyF4 )

Return
