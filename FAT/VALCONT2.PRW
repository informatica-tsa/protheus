#include "rwmake.ch"        // incluido pelo assistente de conversao do AP5 IDE em 25/06/01

User Function VALCONT2()        // incluido pelo assistente de conversao do AP5 IDE em 25/06/01

Local nxk := 0

//旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴�
//� Declaracao de variaveis utilizadas no programa atraves da funcao    �
//� SetPrvt, que criara somente as variaveis definidas pelo usuario,    �
//� identificando as variaveis publicas do sistema utilizadas no codigo �
//� Incluido pelo assistente de conversao do AP5 IDE                    �
//읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴�

SetPrvt("AARQ,LRET,NPOSCT,NPOSLT,NPOSSB,NXK")
SetPrvt("ACOLS,")

/*/
複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複�
굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇�
굇旼컴컴컴컴컫컴컴컴컴컴컴쩡컴컴컴쩡컴컴컴컴컴컴컴컴컴컴쩡컴컴컫컴컴컴컴컴엽�
굇쿑un뇚o    � ValCont2   � Autor 쿐duardo Carraro      � Data � 19.11.99 낢�
굇쳐컴컴컴컴컵컴컴컴컴컴컴좔컴컴컴좔컴컴컴컴컴컴컴컴컴컴좔컴컴컨컴컴컴컴컴눙�
굇쿏escri뇚o 쿣alidacao do campo Conta no SZ2                             낢�
굇쳐컴컴컴컴컵컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴눙�
굇� Uso      � Em conjunto com o InputCtr.prw - Exclusivo para EPC        낢�
굇읕컴컴컴컴컨컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴袂�
굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇�
賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽�
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
