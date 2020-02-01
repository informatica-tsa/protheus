#include "rwmake.ch"        // incluido pelo assistente de conversao do AP5 IDE em 25/06/01

User Function INPCOXFO()        // incluido pelo assistente de conversao do AP5 IDE em 25/06/01

Local nxI := 0

//зддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
//Ё Declaracao de variaveis utilizadas no programa atraves da funcao    Ё
//Ё SetPrvt, que criara somente as variaveis definidas pelo usuario,    Ё
//Ё identificando as variaveis publicas do sistema utilizadas no codigo Ё
//Ё Incluido pelo assistente de conversao do AP5 IDE                    Ё
//юддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды

SetPrvt("NOPCX,CCONTRATO,CTIPOCONT,CCENTCUST,LEDIT,NUSADO")
SetPrvt("AHEADER,NPOSVAL,ACOLS,NXI,CTITULO,AC")
SetPrvt("AR,ACGD,CLINHAOK,CTUDOOK,LRETMOD2,NPOSFOR")
SetPrvt("NPOSLOJ,CCHAVE,NXJ,NPOSOR,")

DO CASE
   CASE (PARAMIXB $"I/A")
        nOpcx:=3   // 3 = PODE EDITAR O DADO
   CASE (PARAMIXB $"V/E")
        nOpcx:=2   // 2 = PODE VISUALIZUR O DADO
ENDCASE

If PARAMIXB == "I"
   cContrato := space(05)
   cTipoCont := space(01)
*???   cCentCust := space(11)
Else
   cContrato := SZC->ZC_CONTRAT
   cTipoCont := SZC->ZC_TIPOCON
*???   cCentCust := SZC->ZC_CCUSTO
EndIf
IF PARAMIXB == "A"
   lEdit := .F.
Else
   lEdit := .T.
EndIf

//здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
//Ё Montando aHeader                                             Ё
//юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды

dbSelectArea("SX3")
dbSetOrder(1)
dbSeek("SZC")
nUsado:=0
aHeader:={}
While !Eof() .And. (x3_arquivo == "SZC")

   IF X3USO(x3_usado)                         .And. ;
      cNivel >= x3_nivel                      .And. ;
      Alltrim(SX3->X3_CAMPO) <> "ZC_CONTRAT"  .And. ;
      Alltrim(SX3->X3_CAMPO) <> "ZC_TIPOCON"  .And. ;
      Alltrim(SX3->X3_CAMPO) <> "ZC_CCUSTO"
       nUsado := nUsado + 1
       Aadd(aHeader,{ TRIM(x3_titulo), x3_campo, x3_picture, x3_tamanho, ;
            x3_decimal, ,  x3_usado, x3_tipo, x3_arquivo, x3_context } )
    Endif
    dbSkip()
End

nPosVal := aScan(aHeader,{|aAux| Upper(Alltrim(aAux[2])) == "ZC_FORNECE"})

If PARAMIXB == "I"
   aCols:=Array(1,nUsado+1)
   dbSelectArea("SX3")
   dbSeek("SZC")
   nUsado:=0
   While !Eof() .And. (X3_ARQUIVO == "SZC")
      IF X3USO(X3_USADO)                         .And. ;
         cNivel >= x3_nivel                      .And. ;
         Alltrim(SX3->X3_CAMPO) <> "ZC_CONTRAT"  .And. ;
         Alltrim(SX3->X3_CAMPO) <> "ZC_TIPOCON"  .And. ;
         Alltrim(SX3->X3_CAMPO) <> "ZC_CCUSTO"
         nUsado := nUsado + 1
         IF nOpcx == 3
            IF X3_TIPO == "C"
               aCols[1][nUsado] := SPACE(x3_tamanho)
            Elseif X3_TIPO == "N"
               aCols[1][nUsado] := 0
            Elseif X3_TIPO == "D"
               aCols[1][nUsado] := dDataBase
            Elseif X3_TIPO == "M"
               aCols[1][nUsado] := ""
            Else
               aCols[1][nUsado] := .F.
            Endif
         Endif
      Endif
      dbSkip()
   EndDo
   aCols[1][nUsado+1] := .F.
Else
   dbSelectArea("SZC")
   dbSetOrder(1)
   dbSeek(xFilial("SZC")+cContrato+cTipoCont)
//   dbSeek(xFilial("SZC")+cContrato+cTipoCont+cCentCust)

   aCols := {}
   While (! eof())                            .And. ;
         (xFilial("SZC")  == SZC->ZC_Filial)  .And. ;
         (SZC->ZC_CONTRAT == cContrato)       .And. ;
         (SZC->ZC_TIPOCON == cTipoCont)

//         (SZC->ZC_CCUSTO  == cCentCust)

      Aadd(aCols,Array(Len(aHeader)+1))
      For nxI := 1 to Len(aHeader)
         aCols[Len(aCols),nxI] := FieldGet(FieldPos(aHeader[nxI,2]))
      Next
      aCols[Len(aCols),Len(aHeader)+1] := .F.
      dbSelectArea("SZC")
      dbSkip()
   EndDo
EndIf

//здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
//Ё Variaveis do Cabecalho do Modelo 2                           Ё
//юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
//здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
//Ё Titulo da Janela                                             Ё
//юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
cTitulo:="Cadastro do Contrato X Fornecedor"
//здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
//Ё Array com descricao dos campos do Cabecalho do Modelo 2      Ё
//юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
aC:={}
// aC[n,1] = Nome da Variavel Ex.:"cCliente"
// aC[n,2] = Array com coordenadas do Get [x,y], em Windows estao em PIXEL
// aC[n,3] = Titulo do Campo
// aC[n,4] = Picture
// aC[n,5] = Validacao
// aC[n,6] = F3
// aC[n,7] = Se campo e' editavel .t. se nao .f.

#IFDEF WINDOWS
   AADD(aC,{"cContrato",{15,10},"Contrato","@!","ExecBlock('ValContr',.F.,.F.)","SZ1",lEdit})
   AADD(aC,{"cTipoCont",{15,120},"Tipo Contrato","@!","NaoVazio()",,.F.})
*???   AADD(aC,{"cCentCust",{15,180},"Centro Custo","@!","ExecBlock('ValCentC',.F.,.F.)","SI3",.T.})
#ELSE
   AADD(aC,{"cContrato",{6,5}  ,"Contrato","@!","ExecBlock('ValContr',.F.,.F.)","SZ1",lEdit})
   AADD(aC,{"cTippCont",{6,22}  ,"Tipo Contrato","@!","NaoVazio()",,.F.})
*???   AADD(aC,{"cCentCust",{6,45}  ,"Centro de Custo","@!","ExecBlock('ValCentC',.F.,.F.)","SI3",.T.})
#ENDIF
//здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
//Ё Array com descricao dos campos do Rodape do Modelo 2         Ё
//юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
aR:={}
// aR[n,1] = Nome da Variavel Ex.:"cCliente"
// aR[n,2] = Array com coordenadas do Get [x,y], em Windows estao em PIXEL
// aR[n,3] = Titulo do Campo
// aR[n,4] = Picture
// aR[n,5] = Validacao
// aR[n,6] = F3
// aR[n,7] = Se campo e' editavel .t. se nao .f.
//здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
//Ё Array com coordenadas da GetDados no modelo2                 Ё
//юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
#IFDEF WINDOWS
   aCGD:={29,5,118,315}
#ELSE
   aCGD:={08,04,15,73}
#ENDIF
//здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
//Ё Validacoes na GetDados da Modelo 2                           Ё
//юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
cLinhaOk := "AllWaysTrue()"
cTudoOk  := "AllWaysTrue()"

//здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
//Ё Chamada da Modelo2                                           Ё
//юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
// lRetMod2 = .t. se confirmou
// lRetMod2 = .f. se cancelou
lRetMod2 := Modelo2(cTitulo,aC,aR,aCGD,nOpcx,cLinhaOk,cTudoOk)
// No Windows existe a funcao de apoio CallMOd2Obj() que retorna o
// objeto Getdados Corrente

If lRetMod2 .And. nOpcx <> 2
   Processa()
ElseIf lRetMod2 .And. PARAMIXB == "E"
   FDelete()
Endif

Return



// Substituido pelo assistente de conversao do AP5 IDE em 25/06/01 ==> Function Processa
Static Function Processa()
******************************************************************************
*Grava os dados nos arqvuivos.
*
****

Local nxJ := 0
Local nxI := 0

nPosFor := aScan(aHeader,{|aAux1| Upper(Alltrim(aAux1[2])) == "ZC_FORNECE"})
nPosLoj := aScan(aHeader,{|aAux2| Upper(Alltrim(aAux2[2])) == "ZC_LOJA"})

dbSelectArea("SZC")
dbSetOrder(1)

For nxI := 1 To Len(aCols)
    If ! Empty(aCols[nxI,nPosFor])
       cChave := cContrato+cTipoCont+aCols[nxI,nPosFor]+aCols[nxI,nPosLoj]
//       cChave := cContrato+cTipoCont+cCentCust+aCols[nxI,nPosFor]+aCols[nxI,nPosLoj]
       dbSeek(xFilial("SZC")+cChave)
       RecLoCk("SZC",Eof())
       If ! aCols[nxI,Len(aHeader)+1]
          For nxJ := 1 To Len(aHeader)
              nPosOr := FieldPos(aHeader[nxJ,2])
              FieldPut(nPosOr,aCols[nxI,nxJ])
          Next
          Replace ZC_FILIAL  With xFilial()
          Replace ZC_CONTRAT With cContrato
          Replace ZC_TIPOCON With cTipoCont
//          Replace ZC_CCUSTO  With cCentCust
       Else
          If ! Eof()
             RecLock("SZC",.F.)
             dbDelete()
          EndIf
       EndIf
       MsUnLock()
    EndIf
Next

Return



// Substituido pelo assistente de conversao do AP5 IDE em 25/06/01 ==> Function FDelete
Static Function FDelete()
*****************************************************************************
* Deleta registros dos arquivos SZS e SZT
*
********

dbSelectArea("SZC")
dbSetOrder(1)
*???dbSeek((xFilial("SZC"))+cContrato+cTipoCont+cCentCust)
dbSeek((xFilial("SZC"))+cContrato+cTipoCont)

While (! Eof())                      .And. ;
      (SZC->ZC_CONTRAT == cContrato) .And. ;
      (SZC->ZC_TIPOCON == cTipoCont)

*???      (SZC->ZC_CCUSTO  == cCentCust)

   RecLock("SZC",.F.)
   dbDelete()
   MsUnLock()
   dbSkip()
EndDo

MsUnLock()

Return

