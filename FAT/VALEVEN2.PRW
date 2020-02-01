#include "rwmake.ch"        // incluido pelo assistente de conversao do AP5 IDE em 25/06/01

User Function VALEVEN2()        // incluido pelo assistente de conversao do AP5 IDE em 25/06/01

Local nxk := 0

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Declaracao de variaveis utilizadas no programa atraves da funcao    ³
//³ SetPrvt, que criara somente as variaveis definidas pelo usuario,    ³
//³ identificando as variaveis publicas do sistema utilizadas no codigo ³
//³ Incluido pelo assistente de conversao do AP5 IDE                    ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

SetPrvt("AARQ,LRET,NPOS5,NXK,")

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ ValEven2   ³ Autor ³Eduardo Carraro      ³ Data ³ 18.11.99 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³Validacao dos eventos digitados na multiline                ³±±
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
If Empty(M->Z3_EVENTO)
   MsgStop("Codigo do Evento Deve Ser Informado !")
   lRet:=.F.
EndIf
nPos5 := aScan(aHeader,{|aAux|alltrim(aAux[2]) == "Z3_EVENTO"})

//INÍCIO: Validação incluída por Daniel Moreira 03.04.06
//ALERT(SZ1->Z1_COD+StrZero(Val(M->Z3_EVENTO),3)+M->Z3_EVENTO)
dbSelectArea("SZ3")
dbSetOrder(1)
If dbSeek(xFilial("SZ3")+SZ1->Z1_COD+StrZero(Val(M->Z3_EVENTO),3)+M->Z3_EVENTO)
	If !Empty(SZ3->Z3_NOTA)
	   MsgStop("Evento já faturado !")
	   lRet:=.F.
	EndIf
EndIf
//FIM

For nxk := 1 To Len(aCols)
    If lRet .and. ! aCols[nXK,Len(aHeader)+1] .and. nXK #n .and. aCols[nxK,nPos5] == M->Z3_EVENTO
         lRet:=.f.
         MsgBox("Este Evento Ja' Foi Utilizado Neste Contrato!","Erro!!!","STOP")
    EndIf
Next
DbSelectArea(aArq[1])
DbSetOrder(aArq[2])
DbGoTo(aArq[3])

// Substituido pelo assistente de conversao do AP5 IDE em 25/06/01 ==> __Return(lRet)
Return(lRet)        // incluido pelo assistente de conversao do AP5 IDE em 25/06/01

