#include "rwmake.ch"        // incluido pelo assistente de conversao do AP5 IDE em 25/06/01

User Function ACRTSB1()        // incluido pelo assistente de conversao do AP5 IDE em 25/06/01

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Declaracao de variaveis utilizadas no programa atraves da funcao    ³
//³ SetPrvt, que criara somente as variaveis definidas pelo usuario,    ³
//³ identificando as variaveis publicas do sistema utilizadas no codigo ³
//³ Incluido pelo assistente de conversao do AP5 IDE                    ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

SetPrvt("CTEXAUX1,CTEXAUX2,CTEXAUX3,CTEXAUX4,CTEXAUX5,APOVAZ")
SetPrvt("CTEXTO,NPOFIN,NPOVAZ,LTEST,NX,NPOAUX")
SetPrvt("CTEXTAUX1,CTEXTAUX2,CTEXTAUX3,CTEXTAUX4,CTEXTAUX5,")

Processa( {|| AcertSB1() },"Acertando as Descricoes do SB1","Alterando Registro ..." )// Substituido pelo assistente de conversao do AP5 IDE em 25/06/01 ==> Processa( {|| Execute(AcertSB1) },"Acertando as Descricoes do SB1","Alterando Registro ..." )


Return(nil)        // incluido pelo assistente de conversao do AP5 IDE em 25/06/01

// Substituido pelo assistente de conversao do AP5 IDE em 25/06/01 ==> Function AcertSB1
Static Function AcertSB1()

Local nX := 0

cTexAux1 := ""
cTexAux2 := ""
cTexAux3 := ""
cTexAux4 := ""
cTexAux5 := ""

dbSelectArea("SB1")
dbSetOrder(1)
dbGoTop()
ProcRegua(RecCount())

While ! Eof()

//   IncProc("Alterando Produto : "+StrZero(Recno(),6))
   IncProc("Alterando Produto : "+Left(SB1->B1_DESC,20))

   If Len(AllTrim(SB1->B1_DESC)) < 60
      If Empty(SB1->B1_DESCDET)
         DbSelectArea("SB1")
         Reclock("SB1",.F.)
         Replace B1_DESCDET With SB1->B1_DESC
         MsUnlock()
      EndIf
      DbSkip()
      Loop
   EndIf

   aPoVaz := {}
   cTexto := SB1->B1_DESC
   nPoFin := 1
   nPoVaz := 0
   lTest  := .T.
   While nPoFin <= 60 .And. lTest
      nPoVaz := At(" ",SubStr(cTexto,nPoFin))
      Aadd(aPoVaz,nPoVaz)
      nPoFin := nPoVaz + nPoFin
      If nPoVaz == 0
         lTest := .F.
      EndIf
   EndDo

   nPoFin := 0

   For nX := 1 To Len(aPoVaz)

      If aPoVaz[nX] + nPoFin < 60
         nPoFin := nPoFin + aPoVaz[nX]
      EndIf

   Next

   cTexAux1 := SubStr(cTexto,1,(nPoFin - 1))
   cTexAux2 := SubStr(cTexto,nPoFin)

   If Len(AllTrim(cTexAux2)) > 48
      aPoVaz := {}
      cTexto := cTexAux2
      nPoFin := 1
      nPoVaz := 0
      lTest  := .T.
      While nPoFin <= 48 .And. lTest
         nPoVaz := At(" ",SubStr(cTexto,nPoFin))
         Aadd(aPoVaz,nPoVaz)
         nPoFin := nPoVaz + nPoFin
         If nPoVaz == 0
            lTest := .F.
         EndIf
      EndDo

      nPoFin := 0

      For nX := 1 To Len(aPoVaz)
         If aPoVaz[nX] + nPoFin < 48
            nPoFin := nPoFin + aPoVaz[nX]
         EndIf
      Next

      cTexAux2 := SubStr(cTexto,1,(nPoFin - 1))
      cTexAux3 := SubStr(cTexto,nPoFin)

      If Len(Alltrim(cTexAux3)) > 48
         aPoVaz := {}
         cTexto := cTexAux3
         nPoFin := 1
         nPoVaz := 0
         lTest  := .T.
         While nPoFin <= 48 .And. lTest
            nPoVaz := At(" ",SubStr(cTexto,nPoFin))
            Aadd(aPoVaz,nPoVaz)
            nPoFin := nPoVaz + nPoFin
            If nPoVaz == 0
               lTest := .F.
            EndIf
         EndDo

         nPoFin := 0

         For nX := 1 To Len(aPoVaz)
            If aPoVaz[nX] + nPoFin < 48
               nPoFin := nPoFin + aPoVaz[nX]
            EndIf
         Next

         cTexAux3 := SubStr(cTexto,1,(nPoFin - 1))
         cTexAux4 := SubStr(cTexto,nPoFin)

         If Len(AllTrim(cTexAux4)) > 48
            aPoVaz := {}
            cTexto := cTexAux4
            nPoFin := 1
            nPoVaz := 0
            lTest  := .T.
            While nPoFin <= 48 .And. lTest
               nPoVaz := At(" ",SubStr(cTexto,nPoFin))
               Aadd(aPoVaz,nPoVaz)
               nPoFin := nPoVaz + nPoFin
               If nPoVaz == 0
                  lTest := .F.
               EndIf
            EndDo

            nPoFin := 0

            For nX := 1 To Len(aPoVaz)
               If aPoVaz[nX] + nPoFin < 48
                  nPoFin := nPoFin + aPoVaz[nX]
               EndIf
            Next

            cTexAux4 := SubStr(cTexto,1,(nPoFin - 1))
            cTexAux5 := SubStr(cTexto,nPoFin)
         EndIf
      EndIf
   EndIf

   DbSelectArea("SB1")
   Reclock("SB1",.F.)
   If Empty(SB1->B1_DESCDET)
      Replace B1_DESCDET With SB1->B1_DESC
   EndIf
   Replace B1_DESC    With cTexAux1
   Replace B1_DESC2   With cTexAux2
   Replace B1_DESC3   With cTexAux3
   If ! Empty(cTexAux4)
      Replace B1_DESC4   With cTexAux4
   ElseIf ! Empty(cTexAux5)
      Replace B1_DESC4   With cTexAux5
   EndIf
   MsUnlock()

   cTexAux1 := ""
   cTexAux2 := ""
   cTexAux3 := ""
   cTexAux4 := ""
   cTexAux5 := ""

   DbSelectArea("SB1")
   DbSkip()

EndDo

Return


/*
   cTexto  := SB1->B1_DESC
   nPoFin := 1
   nPoVaz  := At(" ",SubStr(cTexto,nPoFin))
   nPoFin  := nPoVaz
   lTest   := .T.
   nPoAux  := 0
   While nPoFin <= 60 .And. lTest
      nPoAux := nPoVaz
      nPoVaz := At(" ",SubStr(cTexto,nPoFin))
      nPoFin := nPoVaz + nPoFin
      If nPoVaz == 0
         lTest := .F.
      EndIf
   EndDo

   If nPoFin > 60
      nPoFin := nPoFin - nPoAux
   EndIf

   cTextAux1 := SubStr(cTexto,1,(nPoFin - 1))
   cTextAux2 := SubStr(cTexto,nPoFin)

   If Len(AllTrim(cTextAux2)) > 48
      cTexto := cTextAux2
      nPoFin := 1
      nPoVaz := At(" ",SubStr(cTexto,nPoFin))
      nPoFin := nPoVaz
      lTest := .T.
      nPoAux  := 0
      While nPoFin <= 48 .And. lTest
         nPoAux := nPoVaz
         nPoVaz := At(" ",SubStr(cTexto,nPoFin))
         nPoFin := nPoVaz + nPoFin
         If nPoVaz == 0
            lTest := .F.
         EndIf
      EndDo

      If nPoFin > 60
         nPoFin := nPoFin - nPoAux
      EndIf

      cTextAux2 := SubStr(cTexto,1,(nPoFin - 1))
      cTextAux3 := SubStr(cTexto,nPoFin)

      If Len(AllTrim(cTextAux3)) > 48
         cTexto := cTextAux3
         nPoFin := 1
         nPoVaz := At(" ",SubStr(cTexto,nPoFin))
         nPoFin := nPoVaz
         lTest := .T.
         nPoAux  := 0
         While nPoFin <= 48 .And. lTest
            nPoAux := nPoVaz
            nPoVaz := At(" ",SubStr(cTexto,nPoFin))
            nPoFin := nPoVaz + nPoFin
            If nPoVaz == 0
               lTest := .F.
            EndIf
         EndDo

         If nPoFin > 60
            nPoFin := nPoFin - nPoAux
         EndIf

         cTextAux3 := SubStr(cTexto,1,(nPoFin - 1))
         cTextAux4 := SubStr(cTexto,nPoFin)

         If Len(AllTrim(cTextAux4)) > 48
            cTexto := cTextAux4
            nPoFin := 1
            nPoVaz := At(" ",SubStr(cTexto,nPoFin))
            nPoFin := nPoVaz
            lTest := .T.
            nPoAux  := 0
            While nPoFin <= 48 .And. lTest
               nPoAux := nPoVaz
               nPoVaz := At(" ",SubStr(cTexto,nPoFin))
               nPoFin := nPoVaz + nPoFin
               If nPoVaz == 0
                  lTest := .F.
               EndIf
            EndDo

            If nPoFin > 60
               nPoFin := nPoFin - nPoAux
            EndIf

            cTextAux4 := SubStr(cTexto,1,(nPoFin - 1))
            cTextAux5 := SubStr(cTexto,nPoFin)
         EndIf
      EndIf
   EndIf
*/
