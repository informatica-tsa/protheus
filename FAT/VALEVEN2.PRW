#include "rwmake.ch"        // incluido pelo assistente de conversao do AP5 IDE em 25/06/01

User Function VALEVEN2()        // incluido pelo assistente de conversao do AP5 IDE em 25/06/01

Local nxk := 0

//旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴�
//� Declaracao de variaveis utilizadas no programa atraves da funcao    �
//� SetPrvt, que criara somente as variaveis definidas pelo usuario,    �
//� identificando as variaveis publicas do sistema utilizadas no codigo �
//� Incluido pelo assistente de conversao do AP5 IDE                    �
//읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴�

SetPrvt("AARQ,LRET,NPOS5,NXK,")

/*/
複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複�
굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇�
굇旼컴컴컴컴컫컴컴컴컴컴컴쩡컴컴컴쩡컴컴컴컴컴컴컴컴컴컴쩡컴컴컫컴컴컴컴컴엽�
굇쿑un뇚o    � ValEven2   � Autor 쿐duardo Carraro      � Data � 18.11.99 낢�
굇쳐컴컴컴컴컵컴컴컴컴컴컴좔컴컴컴좔컴컴컴컴컴컴컴컴컴컴좔컴컴컨컴컴컴컴컴눙�
굇쿏escri뇚o 쿣alidacao dos eventos digitados na multiline                낢�
굇쳐컴컴컴컴컵컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴눙�
굇� Uso      � Em conjunto com o InputCtr.prw - Exclusivo para EPC        낢�
굇읕컴컴컴컴컨컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴袂�
굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇�
賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽�
/*/
aArq := { Alias(), IndexOrd(), Recno() }
lRet :=.T.
//旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴커
//� verifica se os Valores Nao estao Abusivos sobre o Contrato �
//읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴켸
If Empty(M->Z3_EVENTO)
   MsgStop("Codigo do Evento Deve Ser Informado !")
   lRet:=.F.
EndIf
nPos5 := aScan(aHeader,{|aAux|alltrim(aAux[2]) == "Z3_EVENTO"})

//IN�CIO: Valida豫o inclu�da por Daniel Moreira 03.04.06
//ALERT(SZ1->Z1_COD+StrZero(Val(M->Z3_EVENTO),3)+M->Z3_EVENTO)
dbSelectArea("SZ3")
dbSetOrder(1)
If dbSeek(xFilial("SZ3")+SZ1->Z1_COD+StrZero(Val(M->Z3_EVENTO),3)+M->Z3_EVENTO)
	If !Empty(SZ3->Z3_NOTA)
	   MsgStop("Evento j� faturado !")
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

