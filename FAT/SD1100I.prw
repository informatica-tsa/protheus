#include "rwmake.ch"        // incluido pelo assistente de conversao do AP5 IDE em 25/06/01

User Function SD1100I()        // incluido pelo assistente de conversao do AP5 IDE em 25/06/01

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Declaracao de variaveis utilizadas no programa atraves da funcao    ³
//³ SetPrvt, que criara somente as variaveis definidas pelo usuario,    ³
//³ identificando as variaveis publicas do sistema utilizadas no codigo ³
//³ Incluido pelo assistente de conversao do AP5 IDE                    ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

SetPrvt("AARQSD,CANO,CMES,CREV,CCCUSTO,CDESCRI")
SetPrvt("LTITUOK,")

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³ SD1100I  ³ Autor ³Ederson Dilney Colen M.³ Data ³14/01/2000³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Rotina de Gravacao do Saldo na inclusao da Nota Fiscal de  ³±±
±±³          ³ Entrada no Estoque.                                        ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Especifico para EPC                                        ³±±
±±³          ³ Usado sobre o ponto de entrada.                            ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

aArqSD  := { Alias() , IndexOrd() , Recno() }
cAno	:= SubStr(DtoS(SD1->D1_DTREF),1,4)
cMes	:= SubStr(DtoS(SD1->D1_DTREF),5,2)
cRev	:= "000"
cCCusto := SD1->D1_CC+Space(11-Len(SD1->D1_CC))
cDescri := SD1->D1_FORNECE+SD1->D1_LOJA+Space(10-Len(SD1->D1_FORNECE+SD1->D1_LOJA))
lTituOK := .T.

dbSelectArea("SZB")
dbSetOrder(1)
dbSeek(xFilial("SZB")+cCCusto+cAno)

While (! Eof()) 				       .And. ;
      (SZB->ZB_FILIAL          == xFilial("SZB"))      .And. ;
      (Alltrim(SZB->ZB_CCUSTO) == Alltrim(SD1->D1_CC)) .And. ;
      (SZB->ZB_ANO             == cAno)

  If Val(cRev) < Val(SZB->ZB_Revisao)
     cRev := SZB->ZB_Revisao
  EndIf

  dbSelectArea("SZB")
  dbSkip()

EndDo

dbSelectArea("SZB")
dbSetOrder(2)
dbSeek(xFilial("SZB")+cCCusto+cAno+cRev+cDescri)

While (!Eof())                                                 .And. ;
      (SZB->ZB_FILIAL          == xFilial("SZB"))              .And. ;
      (Alltrim(SZB->ZB_CCUSTO) == Alltrim(SD1->D1_CC))       .And. ;
      (SZB->ZB_Ano             == cAno)                        .And. ;
      (SZB->ZB_Revisao         == cRev)                        .And. ;
      (Alltrim(SZB->ZB_Descri) == SD1->D1_FORNECE+SD1->D1_LOJA)

   If SZB->ZB_TIPO <> "D"
      dbSelectArea("SZ2")
      dbSetOrder(3)
      dbSeek(xFilial("SZ2")+cCCusto)

      dbSelectArea("SZC")
      dbSetOrder(2)
      dbSeek(xFilial("SZC")+SZ2->Z2_COD+SD1->D1_FORNECE+SD1->D1_LOJA)

      If Eof()
         MSGSTOP("Para este titulo nao existe um Contrato x Fornecedor.")
         dbSelectArea("SZB")
         dbSkip()
         Loop
      EndIf
   EndIf

   dbSelectArea("SZB")
   RecLoCk("SZB",.F.)
   Do Case
      Case cMes == "01"
           If SZB->ZB_MES01 < SD1->D1_TOTAL
              lTituOK := .F.
           EndIf
           Replace ZB_SALD01 With SZB->ZB_SALD01 + SD1->D1_TOTAL
      Case cMes == "02"
           If SZB->ZB_MES02 < SD1->D1_TOTAL
              lTituOK := .F.
           EndIf
           Replace ZB_SALD02 With SZB->ZB_SALD02 + SD1->D1_TOTAL
      Case cMes == "03"
           If SZB->ZB_MES03 < SD1->D1_TOTAL
              lTituOK := .F.
           EndIf
           Replace ZB_SALD03 With SZB->ZB_SALD03 + SD1->D1_TOTAL
      Case cMes == "04"
           If SZB->ZB_MES04 < SD1->D1_TOTAL
              lTituOK := .F.
           EndIf
           Replace ZB_SALD04 With SZB->ZB_SALD04 + SD1->D1_TOTAL
      Case cMes == "05"
           If SZB->ZB_MES05 < SD1->D1_TOTAL
              lTituOK := .F.
           EndIf
           Replace ZB_SALD05 With SZB->ZB_SALD05 + SD1->D1_TOTAL
      Case cMes == "06"
           If SZB->ZB_MES06 < SD1->D1_TOTAL
              lTituOK := .F.
           EndIf
           Replace ZB_SALD06 With SZB->ZB_SALD06 + SD1->D1_TOTAL
      Case cMes == "07"
           If SZB->ZB_MES07 < SD1->D1_TOTAL
              lTituOK := .F.
           EndIf
           Replace ZB_SALD07 With SZB->ZB_SALD07 + SD1->D1_TOTAL
      Case cMes == "08"
           If SZB->ZB_MES08 < SD1->D1_TOTAL
              lTituOK := .F.
           EndIf
           Replace ZB_SALD08 With SZB->ZB_SALD08 + SD1->D1_TOTAL
      Case cMes == "09"
           If SZB->ZB_MES09 < SD1->D1_TOTAL
              lTituOK := .F.
           EndIf
           Replace ZB_SALD09 With SZB->ZB_SALD09 + SD1->D1_TOTAL
      Case cMes == "10"
           If SZB->ZB_MES10 < SD1->D1_TOTAL
              lTituOK := .F.
           EndIf
           Replace ZB_SALD10 With SZB->ZB_SALD10 + SD1->D1_TOTAL
      Case cMes == "11"
           If SZB->ZB_MES11 < SD1->D1_TOTAL
              lTituOK := .F.
           EndIf
           Replace ZB_SALD11 With SZB->ZB_SALD11 + SD1->D1_TOTAL
      Case cMes == "12"
           If SZB->ZB_MES12 < SD1->D1_TOTAL
              lTituOK := .F.
           EndIf
           Replace ZB_SALD12 With SZB->ZB_SALD12 + SD1->D1_TOTAL
      EndCase

   MsUnLock()

   dbSelectArea("SZB") 
   dbSkip()
   
EndDo

If ! lTituOK
   dbSelectArea("SD1")
   RecLoCk("SD1",.F.)
   Replace D1_TITUOK With "N"
   MsUnLock()
EndIf

/*
//TROCA DATA DE DIGITAÇÃO PARA CONTABILIZAR COM A DATA DE EMISSÃO
dbSelectArea("SD1")
If RecLoCk("SD1",.F.)
   Replace D1_DTENT   With SD1->D1_DTDIGIT
   If SD1->D1_EMISSAO > GetMv("MV_ULMES")
      Replace D1_DTDIGIT With SD1->D1_EMISSAO
   EndIf
   MsUnLock()
EndIf*/

DbSelectArea(aArqSD[1])
DbSetOrder(aArqSD[2])
DbGoTo(aArqSD[3])

// Substituido pelo assistente de conversao do AP5 IDE em 25/06/01 ==> __Return()
Return()        // incluido pelo assistente de conversao do AP5 IDE em 25/06/01
