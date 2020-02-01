#include "rwmake.ch"        // incluido pelo assistente de conversao do AP5 IDE em 25/06/01

User Function VALCONT2()        // incluido pelo assistente de conversao do AP5 IDE em 25/06/01

Local nxk := 0

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Declaracao de variaveis utilizadas no programa atraves da funcao    ³
//³ SetPrvt, que criara somente as variaveis definidas pelo usuario,    ³
//³ identificando as variaveis publicas do sistema utilizadas no codigo ³
//³ Incluido pelo assistente de conversao do AP5 IDE                    ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

SetPrvt("AARQ,LRET,NPOSCT,NPOSLT,NPOSSB,NXK")
SetPrvt("ACOLS,")

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ ValCont2   ³ Autor ³Eduardo Carraro      ³ Data ³ 19.11.99 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³Validacao do campo Conta no SZ2                             ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Em conjunto com o InputCtr.prw - Exclusivo para EPC        ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
aArq := { Alias(), IndexOrd(), Recno() }
lRet :=.T.
nPosCt := aScan(aHeader,{|aAux|alltrim(aAux[2]) == "Z2_CONTA"})
nPosLt := aScan(aHeader,{|aAux|alltrim(aAux[2]) == "Z2_LETRA"})
nPosSB := aScan(aHeader,{|aAux|alltrim(aAux[2]) == "Z2_SUBC"})
For nxk := 1 To Len(aCols)
    If ! aCols[nXK,Len(aHeader)+1] .and. nXk #n .and. aCols[nXk,nPosCt] == aCols[n,nPosCt] .and. aCols[nXk,nPosLT] == M->Z2_LETRA
       MsgBox("Esta Conta/Letra ja' Foi Utilizada Neste Contrato!","ERRO!!!","STOP")
       lRet:=.f.
    EndIf
Next
If lRet
   DbSelectArea("SZ2")
   DbSetOrder(3)
   If DbSeek(xFilial("SZ2")+aCols[n,nPosCt]+M->Z2_LETRA)
      MsgBox("Esta Conta/Letra ja' Foi Utilizada Em Outro Contrato!","ERRO!!!","STOP")
      lRet:=.f.
   EndIf
EndIf
If lRet
   aCols[n,nPosSB] := aCols[n,nPosCt]+M->Z2_LETRA
EndIf
DbSelectArea(aArq[1])
DbSetOrder(aArq[2])
DbGoTo(aArq[3])

// Substituido pelo assistente de conversao do AP5 IDE em 25/06/01 ==> __Return(lRet)
Return(lRet)        // incluido pelo assistente de conversao do AP5 IDE em 25/06/01
