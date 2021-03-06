#include "rwmake.ch"        // incluido pelo assistente de conversao do AP5 IDE em 25/06/01

User Function GRAVCTR()        // incluido pelo assistente de conversao do AP5 IDE em 25/06/01

//旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴�
//� Declaracao de variaveis utilizadas no programa atraves da funcao    �
//� SetPrvt, que criara somente as variaveis definidas pelo usuario,    �
//� identificando as variaveis publicas do sistema utilizadas no codigo �
//� Incluido pelo assistente de conversao do AP5 IDE                    �
//읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴�

SetPrvt("AARQ,CROT,CCONTRATO,CRETURN,DDATAREF,")

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
aArq:= { Alias() , IndexOrd() , Recno() }
cRot := UPPER(AllTrim(ProcName()))
*???MSGSTOP(cRot)
cContrato:=""
cReturn := ""

If cRot == "MATA100"     //Compras

   dbSelectArea("SD1")
   dbSetOrder(8) //Serie+Doc+Fornecedor+Loja+Item
   dbSeek(xFilial("SD1")+SF1->F1_SERIE+SF1->F1_DOC+SF1->F1_SERIE+SF1->F1_FORNECE+SF1->F1_LOJA)

   DbSelectArea("SC7")
   DbSetOrder(1) //Numero + Item + Sequencia
   DbSeek(xFilial("SC7")+SD1->D1_PEDIDO+SD1->D1_ITEMPC)
   cContrato:=SD1->D1_CONTRAT
   dDataRef :=SD1->D1_DATAREF

   dbSelectArea("SE2")
   dbSetOrder(6) //FILIAL + FORNECEDOR + LOJA + PREFIXO + NUMERO + ...
   dbSeek(xFilial("SE2")+SF1->F1_FORNECE+SF1->F1_LOJA+SF1->F1_PREFIXO+SF1->F1_Dupl)

   While (! Eof())  .And. (SE2->E2_Filial  == xFilial("SE2")) 	.And.;
         (SE2->E2_Prefixo == SF1->F1_PREFIXO) 					.And.;
         (SE2->E2_Num == SF1->F1_Dupl) 							.And.;
         (SE2->E2_Fornece == SF1->F1_Fornece)
       If RecLock("SE2",.F.)
          Replace E2_CODCONT With cContrato
          Replace E2_DTREF   With dDataRef
          MsUnlock()
       EndIf
       dbSelectArea("SE2")
       dbSkip()
   End
   dbSelectArea(aArq[1])
   dbSetOrder(aArq[2])
   dbGoTo(aArq[3])
*???   Return(SA2->A2_NATUREZ)
   cReturn := SA2->A2_NATUREZ

ElseIf cRot == "MATA460A" //Faturamento

   dbSelectArea("SC5")
   dbSetOrder(5) //Nota+Serie
   dbSeek(xFilial("SC5")+SF2->F2_DOC+SF2->F2_SERIE)

   dbSelectArea("SE1")
   dbSetOrder(1)
   dbSeek(xFilial("SE1")+SF2->F2_PREFIXO+SF2->F1_Dupl)

   While (! Eof())  .And. (SE1->E1_Filial  == xFilial("SE1")) .And. ;
         (SE1->E1_Prefixo == SF2->F2_PREFIXO) .And. (SE1->E1_Num == SF2->F2_Dupl)
       If RecLock("SE1",.F.)
          Replace E1_CODCONT With SC5->C5_CONTRAT
          Replace E1_DATAREF With SC5->C5_DATAREF
          MsUnlock()
       EndIf
       dbSelectArea("SE1")
       dbSkip()
   End
   DbSelectArea(aArq[1])
   DbSetOrder(aArq[2])
   DbGoTo(aArq[3])
*???   Return(SA1->A1_NATUREZ)
   cReturn := SA1->A1_NATUREZ

EndIf

// Substituido pelo assistente de conversao do AP5 IDE em 25/06/01 ==> __Return(cReturn)
Return(cReturn)        // incluido pelo assistente de conversao do AP5 IDE em 25/06/01