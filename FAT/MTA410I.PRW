#include "rwmake.ch"        // incluido pelo assistente de conversao do AP5 IDE em 25/06/01

User Function MTA410I()        // incluido pelo assistente de conversao do AP5 IDE em 25/06/01

//旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴�
//� Declaracao de variaveis utilizadas no programa atraves da funcao    �
//� SetPrvt, que criara somente as variaveis definidas pelo usuario,    �
//� identificando as variaveis publicas do sistema utilizadas no codigo �
//� Incluido pelo assistente de conversao do AP5 IDE                    �
//읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴�

SetPrvt("AARQ,CCONTRATO,CCLIENTE,CSUBCTA,NVALFAT,")

/*
複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複�
굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇�
굇旼컴컴컴컴컫컴컴컴컴컴쩡컴컴컴쩡컴컴컴컴컴컴컴컴컴컴컴쩡컴컴컫컴컴컴컴컴엽�
굇쿛rograma  � MTA410I  � Autor 쿐duardo Carraro        � Data � 14/12/99 낢�
굇쳐컴컴컴컴컵컴컴컴컴컴좔컴컴컴좔컴컴컴컴컴컴컴컴컴컴컴좔컴컴컨컴컴컴컴컴눙�
굇쿏escri놹o � Ponto de Entrada para acerto das sub-contas no contrato de 낢�
굇�          � acordo com as sub-contas informadas nos itens e tambem atu-낢�
굇�          � aliza o valor faturado do contrato                         낢�
굇쳐컴컴컴컴컵컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴눙�
굇쿚bservacao� O arquivo SC6 ja esta gravado e posicionado.               낢�
굇쳐컴컴컴컴컵컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴눙�
굇쿢so       � Especifico para EPC/TSA                                    낢�
굇읕컴컴컴컴컨컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴袂�
굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇�
賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽�
*/
aArq      := { Alias(), IndexOrd(), Recno() }
cContrato := SC5->C5_CONTRATO
cCliente  := SC5->C5_CLIENTE
cItemLm   := SC6->C6_ITEMLM
cSubCta   := SC6->C6_SUBC
nValFat   := SC6->C6_VALOR



DbSelectArea("SZ1") //Contrato
DbSetOrder(1) //Filial+Contrato+Cliente
If DbSeek(xFilial("SZ1")+cContrato+cCliente)
   If RecLock("SZ1",.F.)
      Do Case
         Case ! Empty(Z1_VRADIT3)
              Replace Z1_VRFAT With Z1_VRFAT+nValFat   //Valor ja faturado
              Replace Z1_VRSAL3 With Z1_VRSAL3-nValFat   //Valor do Saldo
         Case ! Empty(Z1_VRADIT2)
              Replace Z1_VRFAT With Z1_VRFAT+nValFat   //Valor ja faturado
              Replace Z1_VRSAL2 With Z1_VRSAL2-nValFat   //Valor do Saldo
         Case ! Empty(Z1_VRADIT1)
              Replace Z1_VRFAT With Z1_VRFAT+nValFat   //Valor ja faturado
              Replace Z1_VRSAL1 With Z1_VRSAL1-nValFat   //Valor do Saldo
         OtherWise  //Nao houver Aditivos
              Replace Z1_VRFAT With Z1_VRFAT+nValFat   //Valor ja faturado
              Replace Z1_VRSAL With Z1_VRSAL-nValFat   //Valor do Saldo
      EndCase
   EndIf
EndIf

dbSelectArea("SC9")
dbSetOrder(2)
If dbSeek(xFilial("SC9")+SC6->(C6_CLI+C6_LOJA+C6_NUM+C6_ITEM))
   If RecLock("SC9",.F.)
      Replace C9_ITEMLM With cItemLm
      MsUnlock()
   EndIf
EndIf

DbSelectArea(aArq[1])
DbSetOrder(aArq[2])
DbGoTo(aArq[3])      

Return
