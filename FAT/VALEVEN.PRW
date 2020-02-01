#include "rwmake.ch"        // incluido pelo assistente de conversao do AP5 IDE em 25/06/01

User Function VALEVEN()        // incluido pelo assistente de conversao do AP5 IDE em 25/06/01

Local nxk := 0

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Declaracao de variaveis utilizadas no programa atraves da funcao    ³
//³ SetPrvt, que criara somente as variaveis definidas pelo usuario,    ³
//³ identificando as variaveis publicas do sistema utilizadas no codigo ³
//³ Incluido pelo assistente de conversao do AP5 IDE                    ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

SetPrvt("AARQ,LRET,NPOS4,NVLRTOT,NXK,")

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ ValEven    ³ Autor ³Eduardo Carraro      ³ Data ³ 18.11.99 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³Validacao dos valores dos eventos digitados na multiline    ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Em conjunto com o InputCtr.prw - Exclusivo para EPC        ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
aArq := { Alias(), IndexOrd(), Recno() }
lRet :=.T.
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ verifica se os Valores Nao estao Abusivos sobre o Contrato ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If Empty(M->Z3_VALOR)
   MsgStop("Valor do Evento Deve Ser Informado !")
   lRet:=.F.
EndIf
nPos4 := aScan(aHeader,{|aAux|alltrim(aAux[2]) == "Z3_VALOR"})
nVlrTot:=0
For nxk := 1 To Len(aCols)
    If ! aCols[nXK,Len(aHeader)+1] .and. nXK #n
       nVlrTot:=nVlrTot+aCols[nxK,nPos3]
    EndIf
Next

Do Case
   Case ! Empty(SZ1->Z1_VRPREV3)
      If nVlrTot+M->Z3_VALOR > SZ1->Z1_VRPREV3
         lRet:=.f.
         MsgBox("Somatorio de Valores dos Eventos Ultrapassam Valor Previsto do Contrato!","Erro!!!","STOP")
      EndIf
   Case ! Empty(SZ1->Z1_VRPREV2)
      If nVlrTot+M->Z3_VALOR > SZ1->Z1_VRPREV2
         lRet:=.f.
         MsgBox("Somatorio de Valores dos Eventos Ultrapassam Valor Previsto do Contrato!","Erro!!!","STOP")
      EndIf
   Case ! Empty(SZ1->Z1_VRPREV1)
      If nVlrTot+M->Z3_VALOR > SZ1->Z1_VRPREV1
         lRet:=.f.
         MsgBox("Somatorio de Valores dos Eventos Ultrapassam Valor Previsto do Contrato!","Erro!!!","STOP")
      EndIf
   Case ! Empty(SZ1->Z1_VRPREV)
      If nVlrTot+M->Z3_VALOR > SZ1->Z1_VRPREV
         lRet:=.f.
         MsgBox("Somatorio de Valores dos Eventos Ultrapassam Valor Previsto do Contrato!","Erro!!!","STOP")
      EndIf
EndCase
DbSelectArea(aArq[1])
DbSetOrder(aArq[2])
DbGoTo(aArq[3])

// Substituido pelo assistente de conversao do AP5 IDE em 25/06/01 ==> __Return(lRet)
Return(lRet)        // incluido pelo assistente de conversao do AP5 IDE em 25/06/01
