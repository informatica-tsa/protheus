#include "rwmake.ch"        // incluido pelo assistente de conversao do AP5 IDE em 29/06/01

User Function GRAVCTR1()        // incluido pelo assistente de conversao do AP5 IDE em 29/06/01

//旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴�
//� Declaracao de variaveis utilizadas no programa atraves da funcao    �
//� SetPrvt, que criara somente as variaveis definidas pelo usuario,    �
//� identificando as variaveis publicas do sistema utilizadas no codigo �
//� Incluido pelo assistente de conversao do AP5 IDE                    �
//읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴�

SetPrvt("AARQ1,AARQ2,AARQ3,AARQ4,CCONTRATO,CPEDIDO")

/*/
複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複�
굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇�
굇旼컴컴컴컴컫컴컴컴컴컴쩡컴컴컴쩡컴컴컴컴컴컴컴컴컴컴컴쩡컴컴컫컴컴컴컴컴엽�
굇쿛rograma  �  GravCt  � Autor � Eduardo Carraro       � Data � 29/12/99 낢�
굇쳐컴컴컴컴컵컴컴컴컴컴좔컴컴컴좔컴컴컴컴컴컴컴컴컴컴컴좔컴컴컨컴컴컴컴컴눙�
굇쿏escri뇚o � Rotina de Gravacao do numero do Contrato e da data de      낢�
굇�          � referencia nos arquivos SE1 e SE2                          낢�
굇쳐컴컴컴컴컵컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴눙�
굇쿢so       � Especifico para EPC                                        낢�
굇�          � Usado sobre o parametro MV_1DUPNAT e MV_2DUPNAT            낢�
굇읕컴컴컴컴컨컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴袂�
굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇�
賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽�
/*/

aArq1     := { Alias() , IndexOrd() , Recno() }
aArq2     := { SD2->(Alias()) , SD2->(IndexOrd()) , SD2->(Recno()) }
aArq3     := { SC5->(Alias()) , SC5->(IndexOrd()) , SC5->(Recno()) }
aArq4     := { SE1->(Alias()) , SE1->(IndexOrd()) , SE1->(Recno()) }
cContrato := ""

DbSelectArea("SD2")
DbSetOrder(3) //documento+serie+cliente+loja
DbSeek(xFilial("SD2")+SF2->F2_DOC+SF2->F2_SERIE+SF2->F2_CLIENTE+SF2->F2_LOJA)
cPedido:=SD2->D2_PEDIDO

DbSelectArea("SC5")
DbSetOrder(1) //PEDIDO
DbSeek(xFilial("SC5")+cPedido)

dbSelectArea("SE1")
dbSetOrder(1)
//dbSeek(xFilial("SE1")+SF2->F2_PREFIXO+SF2->F2_Dupl)
dbSeek(xFilial("SE1")+SF2->F2_SERIE+SF2->F2_DOC)
While (! Eof())  .And. (SE1->E1_Filial  == xFilial("SE1")) .And. ;
      (SE1->E1_Prefixo == SF2->F2_SERIE) .And. (SE1->E1_Num == SF2->F2_DOC)
//    (SE1->E1_Prefixo == SF2->F2_PREFIXO) .And. (SE1->E1_Num == SF2->F2_Dupl)
    If RecLock("SE1",.F.)
       Replace E1_CODCONT With SC5->C5_CONTRAT
       Replace E1_DATAREF With SC5->C5_DATAREF
       MsUnlock()
    EndIf
    dbSelectArea("SE1")
    dbSkip()
End

SD2->(DbSelectArea(aArq2[1]))
SD2->(DbSetOrder(aArq2[2]))
SD2->(DbGoTo(aArq2[3]))

SC5->(DbSelectArea(aArq3[1]))
SC5->(DbSetOrder(aArq3[2]))
SC5->(DbGoTo(aArq3[3]))

SE1->(DbSelectArea(aArq4[1]))
SE1->(DbSetOrder(aArq4[2]))
SE1->(DbGoTo(aArq4[3]))

DbSelectArea(aArq1[1])
DbSetOrder(aArq1[2])
DbGoTo(aArq1[3])

// Substituido pelo assistente de conversao do AP5 IDE em 29/06/01 ==> __Return(SA1->A1_NATUREZ)
Return(SA1->A1_NATUREZ)        // incluido pelo assistente de conversao do AP5 IDE em 29/06/01
