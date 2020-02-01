#include "rwmake.ch"        // incluido pelo assistente de conversao do AP5 IDE em 25/06/01
#IFNDEF WINDOWS
    #DEFINE PSAY SAY
#ENDIF

User Function FATR901()        // incluido pelo assistente de conversao do AP5 IDE em 25/06/01

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Declaracao de variaveis utilizadas no programa atraves da funcao    ³
//³ SetPrvt, que criara somente as variaveis definidas pelo usuario,    ³
//³ identificando as variaveis publicas do sistema utilizadas no codigo ³
//³ Incluido pelo assistente de conversao do AP5 IDE                    ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

SetPrvt("CDESC1,CDESC2,CDESC3,LIMITE,CSTRING,TAMANHO")
SetPrvt("TITULO,CABEC1,CABEC2,ARETURN,NOMEPROG,NLASTKEY")
SetPrvt("CPERG,APERG,ALINHA,WNREL,CMESANOINI,CMESANOFIN")
SetPrvt("CNATURINIC,CNATURFINA,NIMPRQUIME,NIMPORPRAM,NMOEDA,NCONPC")
SetPrvt("NCONPV,NNIVQUEB,NCONDTBASE,DDATAINIC,DDATAFINA,CANOMESINIC")
SetPrvt("CANOMESFINA,>>>NNUMEDIAS,CTEXTO,CCABECALHO,CMSGREGUA,ATEMPSTRU")
SetPrvt("CARQTRAB1,CARQTRAB2,CARQTRAB3,AVALRFI,AAMBSE1,AAMBSE2")
SetPrvt("DDATATRAB,CMESANOTRAB,CANOMESTRAB,ACALC,NTOTEMPR,NTOTAPLI")
SetPrvt("CNATUREZ,NENTR,NSAID,NREALENTR,NREALSAID,LEND")
SetPrvt("NVALORPV,CNATURPV,AVENCPV,DDTINIPV,NI,NVALORPC")
SetPrvt("CNATURPC,AVENCPC,DDTINIPC,CANOF,CMESF,CANOI")
SetPrvt("CMESI,CCODANT,DDTREVENC,CCONTRATO,CSUBCONTA,CANO")
SetPrvt("CREV,CCCUSTO,CDESCRI,CMES,M_PAG,NCONTLINHA")
SetPrvt("CRODATXT,NCNTIMPR,NCANT,NCCANT,NNUMCOLU,LPRVCAB")
SetPrvt("LPRVDET,LPRVSUB,ACOLUNAS,ATO1NAT,ATO1NAT1,ATO1NAT2")
SetPrvt("ATO1NATP,ATO1NATO,ATO1NATT,ATO2NAT,ATO2NAT1,ATO2NAT2")
SetPrvt("ATO2NATP,ATO2NATO,ATO2NATT,AMESES,ANOMEMES,APOSCAB1")
SetPrvt("APOSCAB2,APOSDET1,APOSMES,APOSCOLUN,APOSCABEC,APOSDET")
SetPrvt("APOSSTOT,APOSTOTG,NCOLARR,NLEFDESC,NPOSMES,NCOLUN")
SetPrvt("CNATANT,CLINHACAB1,CLINHACAB2,CLINHADET1,CLINHADET2,NPOSIMES")
SetPrvt("NPM,NC,NPC,LPRVEZ,NCC,NCC2")
SetPrvt("NLINHA,NPOSIDET,NPD,NVALOR1,NVALOR2,NVALOTP")
SetPrvt("NVALOO,NVALOT,CCHAVTRBN,ND,NPOSISTOT,NPOSITOTG")

#IFNDEF WINDOWS
// Movido para o inicio do arquivo pelo assistente de conversao do AP5 IDE em 25/06/01 ==>     #DEFINE PSAY SAY
#ENDIF
/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³ FATR901  ³ Autor ³Ederson Dilney Colen M.³ Data ³28.01.2000³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³ Fluxo de Caixa Quinzenal / Orcado                          ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe e ³ FATR901                                                    ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Especifico EPC                                             ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
cDesc1   := "Emiss„o do Relat¢rio Quinzenal por Natureza. Ser  usado a"
cDesc2   := "a data-base do sistema como ponto de partida."
cDesc3   := ""
Limite   := 220
cString  := "SE1"
Tamanho  := "G"
Titulo   := "FLUXO DE CAIXA QUINZENAL / ORCADO"
Cabec1   := ""
Cabec2   := ""
aReturn  := { "Zebrado", 1,"Administracao", 1, 2, 1, "",1 }
Nomeprog := "FATR901"
nLastKey := 0
cPerg    := "FAT901"
aPerg    := {}
aLinha   := {}
nLastKey := 0

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Verifica as perguntas selecionadas                           ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

AADD(aPerg,{cPerg,"Do Mes e Ano       ?","C",06,0,"G","","","","","","",""})
AADD(aPerg,{cPerg,"Ate o Mes e Ano    ?","C",06,0,"G","","","","","","",""})
AADD(aPerg,{cPerg,"Da Natureza        ?","C",10,0,"G","","SED","","","","",""})
AADD(aPerg,{cPerg,"Ate a Natureza     ?","C",10,0,"G","","SED","","","","",""})
AADD(aPerg,{cPerg,"Impr. Quinz./Mensal?","N",01,0,"C","","","Quinzenal","Mensal","","",""})
AADD(aPerg,{cPerg,"Impr. Orc/Prev/Amb ?","N",01,0,"C","","","Orcado","Previsto","Ambos","",""})
AADD(aPerg,{cPerg,"Moeda              ?","N",01,0,"C","","","Moeda 1","Moeda 2","Moeda 3","Moeda 4","Moeda 5"})
AADD(aPerg,{cPerg,"Cons. Pedido Compra?","N",01,0,"C","","","Sim","Nao","","",""})
AADD(aPerg,{cPerg,"Consid.Pedido Venda?","N",01,0,"C","","","Sim","Nao","","",""})
AADD(aPerg,{cPerg,"Niveis de quebra   ?","N",01,0,"G","","","","","","",""})
AADD(aPerg,{cPerg,"Considera Data Base?","N",01,0,"C","","","Sim","Nao","","",""})

Pergunte(cPerg,.F.)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Envia controle para a funcao SETPRINT                        ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

wnrel := NomeProg            //Nome Default do relatorio em Disco
wnrel := SetPrint(cString,wnrel,cPerg,@titulo,cDesc1,cDesc2,cDesc3,.F.,"",,Tamanho,,.F.)

If nLastKey == 27
   Return
Endif

SetDefault(aReturn,cString)

If nLastKey == 27
   Return
Endif

cMesAnoIni  := mv_par01
cMesAnoFin  := mv_par02
cNaturInic  := mv_par03
cNaturFina  := mv_par04
nImprQuiMe  := mv_par05
nImpOrPrAm  := mv_par06
nMoeda      := mv_par07
nConPC      := mv_par08
nConPV      := mv_par09
nNivQueb    := mv_par10
nConDtBase  := mv_par11

dDataInic   := CtoD(Right(DtoS(dDataBase),2)+"/"+Left(cMesAnoIni,2)+"/"+SubStr(cMesAnoIni,3))
dDataFina   := CtoD(Right(DtoS(dDataBase),2)+"/"+Left(cMesAnoFin,2)+"/"+SubStr(cMesAnoFin,3))
cAnoMesInic := Right(cMesAnoIni,4)+Left(cMesAnoIni,2)
cAnoMesFina := Right(cMesAnoFin,4)+Left(cMesAnoFin,2)

*>>>AADD(aPerg,{cPerg,"Numero de Dias     ?","N",03,0,"G","","","","","","",""})
*>>>nNumeDias  := mv_par03  // N£mero de dias

cTexto  := " - " + GetMv("MV_MOEDA"+Str(nMoeda,1))
Titulo  := Titulo + cTexto

LCRIATRAB()

#IFDEF WINDOWS
   cCabecalho := "Gravacao do Arquivo de Trabalho"
   cMsgRegua  := "Processando "
   Processa( {|| GravTrab()} ,cCabecalho,cMsgRegua )// Substituido pelo assistente de conversao do AP5 IDE em 25/06/01 ==>    Processa( {|| Execute(GravTrab)} ,cCabecalho,cMsgRegua )
   RptStatus({|| Fat901Imp()},Titulo)// Substituido pelo assistente de conversao do AP5 IDE em 25/06/01 ==>    RptStatus({|| Execute(Fat901Imp)},Titulo)
#ELSE
   GravTrab()
   FaT901Imp()
#ENDIF

dbSelectArea("TRBN")
dbCloseArea()

dbSelectArea("TRBC")
dbCloseArea()

dbSelectArea("TRBR")
dbCloseArea()

FErase(cArqTrab1 + ".*")
FErase(cArqTrab2 + ".*")
FErase(cArqTrab3 + ".*")

Return


// Substituido pelo assistente de conversao do AP5 IDE em 25/06/01 ==> Function CriaTrab
Static Function LCRIATRAB()
****************************************************************************
* Cria os arquivos de trabalho
******

aTempStru := {}

Aadd(aTempStru,{"Naturez" ,"C",Len(SED->ED_CODIGO),0})
Aadd(aTempStru,{"AnoMesTi","C",06,0})
Aadd(aTempStru,{"MesAnoTi","C",06,0})
Aadd(aTempStru,{"DescNatu","C",30,0})
Aadd(aTempStru,{"TotlCoR1","N",17,2})
Aadd(aTempStru,{"TotlCoR2","N",17,2})
Aadd(aTempStru,{"TotlCoD1","N",17,2})
Aadd(aTempStru,{"TotlCoD2","N",17,2})
Aadd(aTempStru,{"TotlCoOR","N",17,2})
Aadd(aTempStru,{"TotlCoOD","N",17,2})

cArqTrab1 := CRIATRAB(aTempStru,.T.)

dbUseArea( .T.,, cArqTrab1, "TRBN",.F.,.F.)
IndRegua("TRBN",cArqTrab1,"Naturez+AnoMesTi",,,"Selecionando Registros...")

aTempStru := {}

Aadd(aTempStru,{"DtTitulo","D",08,0})
Aadd(aTempStru,{"TipoClFo","C",01,0})
Aadd(aTempStru,{"CodiClFo","C",06,0})
Aadd(aTempStru,{"LojaClFo","C",02,0})
Aadd(aTempStru,{"Contrato","C",06,0})
Aadd(aTempStru,{"SubConta","C",11,0})
Aadd(aTempStru,{"CodEmpre","C",10,0})

cArqTrab2 := CRIATRAB(aTempStru,.T.)

dbUseArea( .T.,, cArqTrab2, "TRBC",.F.,.F.)
IndRegua("TRBC",cArqTrab2,"DtoS(DtTitulo)+TipoClFo+Contrato+SubConta+CodiClFo+LojaClFo",,,"Selecionando Registros...")


aTempStru := {}

Aadd(aTempStru,{"MesAnoTi","C",06,0})
Aadd(aTempStru,{"AnoMesTi","C",06,0})
Aadd(aTempStru,{"TotlResg","N",17,2})
Aadd(aTempStru,{"TotlApli","N",17,2})
Aadd(aTempStru,{"TotlEmpr","N",17,2})

cArqTrab3 := CRIATRAB(aTempStru,.T.)

dbUseArea( .T.,, cArqTrab3, "TRBR",.F.,.F.)
IndRegua("TRBR",cArqTrab3,"AnoMesTi",,,"Selecionando Registros...")

Return



// Substituido pelo assistente de conversao do AP5 IDE em 25/06/01 ==> Function GravTrab
Static Function GravTrab()
*****************************************************************************
* Grava os dados no arquivo de trabalho
***

Local ni := 0 

// Estas variavis foram embutidas no arrey abaixo.
// aValrFi e a ordem dos valors (nBancos,nCaixas,nSaldoTit,nAplica,nEmprest).
// aAmbSE1 e a ordem dos valors (cIndSE1,cChaSE1,cFilSE1,nIndSE1)
// aAmbSE2 e a ordem dos valors (cIndSE2,cChaSE2,cFilSE2,nIndSE2)

aValrFi     := {0,0,0,0,0}
aAmbSE1     := {"","","",0}
aAmbSE2     := {"","","",0}
dDataTrab   := CtoD(Space(08))
cMesAnoTrab := Space(06)
cAnoMesTrab := Space(06)
aCalc       := {}

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Verifica se existe aplica‡„o a ser resgatada no dia           ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

dbSelectArea("SEG")
dbSetOrder(2)
dbSeek(xFilial("SEG")+Dtos(dDataBase),.T.)

ProcRegua(RecCount())
cMsgRegua := "Processando se existe aplicacoes a serem resgatadas no dia"

While ! Eof()                           .And. ;
      SEG->EG_DATARES <= dDataFina      .And. ;
      SEG->EG_FILIAL  == xFilial("SEG")

   IncProc(cMsgRegua)

   If SEG->EG_TIPO == "EMP"
      aValrFi[05] := aValrFi[05] + xMoeda(SEG->EG_VALOR,1,nMoeda)
      nTotEmpr := aValrFi[05]
   Else
      aValrFi[04] := aValrFi[04] + xMoeda(SEG->EG_VALOR,1,nMoeda)
      nTotApli := aValrFi[04]
   EndIf

   cAnoMesTrab := Left(Dtos(SEG->EG_DATARES),6)
   
   dbSelectArea("TRBR")
   dbSetOrder(1)
   If ! (dbSeek(cAnoMesTrab))
      RecLock("TRBR",.T.)
      Replace  MesAnoTi  With  SubStr(Dtos(SEG->EG_DATARES),5,2) + Left(Dtos(SEG->EG_DATARES),4)
      Replace  AnoMesTi  With  cAnoMesTrab
      Replace  TotlApli  With  nTotApli
      Replace  TotlEmpr  With  nTotEmpr
      MsUnlock()
   Else
      RecLock("TRBR",.F.)
      Replace  TotlApli  With TotlApli + nTotApli
      Replace  TotlEmpr  With TotlEmpr + nTotEmpr
      MsUnlock()
   EndIf

   nTotApli := 0
   nTotEmpr := 0

   dbSelectArea("SEG")
   dbSkip()
Enddo

dbSelectArea("SEG")
dbSetOrder(1)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Verifica se existe Operacao Financeira a ser resgatada no dia ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

dbSelectArea("SEH")
dbSetOrder(2)
dbSeek(xFilial("SEH")+"A",.T.)

ProcRegua(RecCount())
cMsgRegua := "Processando se existe operacoes Financeiras a serem resgatadas no dia"

While ! Eof()                          .And. ;
      SEH->EH_FILIAL == xFilial("SEH") .And. ;
      SEH->EH_STATUS == "A"

   IncProc(cMsgRegua)

   aCalc := Fa171Calc(dDataFina)

   If (SEH->EH_APLEMP == "EMP")
      aValrFi[05] := aValrFi[05] + xMoeda(aCalc[2,1],1,nMoeda)
      nTotEmpr := aValrFi[05]
   Else
      aValrFi[04] := aValrFi[04] + xMoeda(aCalc[1],1,nMoeda)
      nTotApli := aValrFi[04]
   EndIf

   cAnoMesTrab := Left(DtoS(SEH->EH_DATARES),6)

   dbSelectArea("TRBR")
   dbSetOrder(1)
   If ! (dbSeek(cAnoMesTrab))
      RecLock("TRBR",.T.)
      Replace  MesAnoTi  With  SubStr(Dtos(SEH->EH_DATARES),5,2) + Left(Dtos(SEH->EH_DATARES),4)
      Replace  AnoMesTi  With  cAnoMesTrab
      Replace  TotlApli  With  nTotApli
      Replace  TotlEmpr  With  nTotEmpr
      MsUnlock()
   Else
      RecLock("TRBR",.F.)
      Replace  TotlApli  With TotlApli + nTotApli
      Replace  TotlEmpr  With TotlEmpr + nTotEmpr
      MsUnlock()
   EndIf

   nTotApli := 0
   nTotEmpr := 0

   dbSelectArea("SEH")
   dbSkip()
EndDo

dbSelectArea("SEH")
dbSetOrder(1)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Verifica disponibilidade banc ria                            ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

dbSelectArea("SA6")
dbSeek(xFilial("SA6"))

ProcRegua(RecCount())
cMsgRegua := "Processando disponibilidade Bancaria"

While ! Eof()                         .And. ;
      SA6->A6_FILIAL == xFilial("SA6")

   IncProc(cMsgRegua)

   If SA6->A6_FLUXCAI == "N"
      dbSkip()
      Loop
   Endif

   If SubStr(SA6->A6_COD,1,2) == "CX"
      aValrFi[02] := aValrFi[02] + RecSalBco(SA6->A6_COD,SA6->A6_AGENCIA,SA6->A6_NUMCON,dDataBase)
   Else
      aValrFi[01] := aValrFi[01] + RecSalBco(SA6->A6_COD,SA6->A6_AGENCIA,SA6->A6_NUMCON,dDataBase)
   EndIf

   dbSelectArea("SA6")
   dbSkip()

Enddo

aValrFi[01] := xMoeda(aValrFi[01],1,nMoeda)
aValrFi[02] := xMoeda(aValrFi[02],1,nMoeda)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Varre o arquivo de naturezas localizando os titulos selecionados  ³
//³ pelo ¡ndice condicional.                                          ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

dbSelectArea("SED")
dbSetOrder(1)
dbSeek(xFilial("SED")+cNaturInic,.T.)

ProcRegua(RecCount())
cMsgRegua := "Processando as Naturezas"

While ! Eof()                          .And. ;
      SED->ED_FILIAL == xFilial("SED") .And. ;
      SED->ED_CODIGO <= cNaturFina

   IncProc(cMsgRegua)

   cAnoMesTrab := Left(Dtos(dDataBase),6)
   cNaturez    := Left(Alltrim(SED->ED_CODIGO),nNivQueb)+Space(10-Len(Left(Alltrim(SED->ED_CODIGO),nNivQueb)))

   dbSelectArea("TRBN")
   dbSetOrder(1)
   If ! (dbSeek(cNaturez+cAnoMesTrab))
      RecLock("TRBN",.T.)
      Replace  Naturez   With  Left(Alltrim(SED->ED_CODIGO),nNivQueb)
      Replace  DescNatu  With  SED->ED_DESCRIC
      Replace  MesAnoTi  With  SubStr(Dtos(dDataBase),5,2) + Left(Dtos(dDataBase),4)
      Replace  AnoMesTi  With  Left(Dtos(dDataBase),6)
      MsUnlock()
   EndIf

   dbSelectArea("SED")
   dbSkip()
Enddo


If nImpOrPrAm == 2 .Or. nImpOrPrAm == 3

   //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
   //³ Seleciona o arquivo SE1 - Contas a Receb, selecionando os registros ³
   //³ desejados. Veja a fun‡„o de filtragem.                              ³
   //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

   aAmbSE1[01] := CRIATRAB("",.F.)
   dbSelectArea("SE1")
   dbSetOrder(3) // Ordem por natureza
   aAmbSE1[02] := IndexKey()
   aAmbSE1[03] := ""
   aAmbSE1[03] := aAmbSE1[03] + 'E1_NATUREZ >= "' + cNaturInic + '" .And. '
   aAmbSE1[03] := aAmbSE1[03] + 'E1_NATUREZ <= "' + cNaturFina + '" .And. '
   aAmbSE1[03] := aAmbSE1[03] + 'Left(DtoS(E1_EMISSAO),6) >= "' + cAnoMesInic + '" .And. '
   aAmbSE1[03] := aAmbSE1[03] + 'Left(DtoS(E1_EMISSAO),6) <= "' + cAnoMesFina + '"'
   IndRegua("SE1",aAmbSE1[01],aAmbSE1[02],,aAmbSE1[03],"Selecionando Registros...")
   aAmbSE1[04] := RetIndex("SE1")

   dbSelectArea("SE1")
   dbSetOrder(aAmbSE1[04]+1)
   dbGoTop()

   //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
   //³ Seleciona o arquivo SE2 - Contas a pagar, selecionando os registros ³
   //³ desejados. Veja a fun‡„o de filtragem.                              ³
   //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

   aAmbSE2[01] := CRIATRAB("",.F.)
   dbSelectArea("SE2")
   dbSetOrder(2) // Ordem por natureza
   aAmbSE2[02] := IndexKey()
   aAmbSE2[03] := ""
   aAmbSE2[03] := aAmbSE2[03] + 'E2_NATUREZ >= "' + cNaturInic + '" .And. '
   aAmbSE2[03] := aAmbSE2[03] + 'E2_NATUREZ <= "' + cNaturFina + '" .And. '
   aAmbSE2[03] := aAmbSE2[03] + 'Left(DtoS(E2_EMISSAO),6) >= "' + cAnoMesInic + '" .And. '
   aAmbSE2[03] := aAmbSE2[03] + 'Left(DtoS(E2_EMISSAO),6) <= "' + cAnoMesFina + '"'
   IndRegua("SE2",aAmbSE2[01],aAmbSE2[02],,aAmbSE2[03],"Selecionando Registros...")
   aAmbSE2[04] := RetIndex("SE2")

   dbSelectArea("SE2")
   dbSetOrder(aAmbSE2[04]+1)
   dbGoTop()

   dbSelectArea("SED")
   dbSeek(xFilial("SED")+cNaturInic,.T.)

   ProcRegua(RecCount())  // Inicializa regua

   While ! Eof()                          .And. ;
         SED->ED_FILIAL == xFilial("SED") .And. ;
         SED->ED_CODIGO <= cNaturFina

      IncProc("Proc. Natureza " + Alltrim(SED->ED_CODIGO) + " - " + Left(SED->ED_DESCRIC,25))

      //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
      //³ Analiza as entradas daquela natureza ³
      //³ A Realizar !!!                       ³
      //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

      nEntr     := 0
      nSaid     := 0
      nRealEntr := 0
      nRealSaid := 0

      If SED->ED_CODIGO >= cNaturInic .And. SED->ED_CODIGO <= cNaturFina

         dbSelectArea("SE1")
         dbSeek(xFilial("SE1")+SED->ED_CODIGO)

         While ! Eof()                          .And. ;
               SE1->E1_FILIAL  == xFilial("SE1") .And. ;
               SE1->E1_NATUREZ == SED->ED_CODIGO

            #IFNDEF WINDOWS
               Inkey()
               If LastKey() == K_ALT_A
                  lEnd := .t.
               EndIf
            #ENDIF

            If SE1->E1_EMISSAO > dDataBase    .Or. ;
               Subs(SE1->E1_TIPO,3,1)  == "-" .Or. ;
               SE1->E1_SITUACA $ "27"
               dbSelectArea("SE1")
               dbSkip()
               Loop
            Endif

            If SE1->E1_FLUXO == "N"
               dbSelectArea("SE1")
               dbSkip()
               Loop
            EndIf

            If nConDtBase == 1
               aValrFi[03] := SaldoTit(SE1->E1_PREFIXO,SE1->E1_NUM,         ;
                                       SE1->E1_PARCELA,SE1->E1_TIPO,        ;
                                       SE1->E1_NATUREZA,"R",SE1->E1_CLIENTE,;
                                       1,,,SE1->E1_LOJA)
            Else
               aValrFi[03] := xMoeda(SE1->E1_SALDO,SE1->E1_MOEDA,nMoeda)
            Endif
               aValrFi[03] := aValrFi[03] - SomaAbat(SE1->E1_PREFIXO,SE1->E1_NUM, ;
                                                     SE1->E1_PARCELA,"R",1)
            If SE1->E1_VENCREA < dDataBase
               dDataTrab := dDataBase - 1
            Else
               dDataTrab := DataValida(SE1->E1_VENCREA,.T.)
            Endif

            If Abs(aValrFi[03]) > 0.0001

               cMesAnoTrab := SubStr(Dtos(dDataTrab),5,2) + Left(Dtos(dDataTrab),4)
               cAnoMesTrab := Left(Dtos(dDataTrab),6)
               cNaturez    := Left(Alltrim(SED->ED_CODIGO),nNivQueb)+Space(10-Len(Left(Alltrim(SED->ED_CODIGO),nNivQueb)))

               dbSelectArea("TRBN")
               If ! (dbSeek(cNaturez+cAnoMesTrab))
                  RecLock("TRBN",.T.)
                  Replace  Naturez   With  Left(Alltrim(SED->ED_CODIGO),nNivQueb)
                  Replace  DescNatu  With  SED->ED_DESCRIC
                  Replace  MesAnoTi  With  cMesAnoTrab
                  Replace  AnoMesTi  With  cAnoMesTrab
               Else
                  RecLock("TRBN",.F.)
               Endif

               If Substr(SE1->E1_TIPO,3,1) == "-" .Or. ;
                  SE1->E1_TIPO == "RA "           .Or. ;
                  SE1->E1_TIPO == "NCC"
                  If Right(DtoS(dDataTrab),2) < "15"
                     Replace  TotlCoR1  With  TRBN->TotlCoR1 - aValrFi[03]
                  Else
                     Replace  TotlCoR2  With  TRBN->TotlCoR2 - aValrFi[03]
                  EndIf
               Else
                  If Right(DtoS(dDataTrab),2) < "15"
                     Replace  TotlCoR1  With  TRBN->TotlCoR1 + aValrFi[03]
                  Else
                     Replace  TotlCoR2  With  TRBN->TotlCoR2 + aValrFi[03]
                  EndIf
               Endif

               MsUnlock()

            Endif

            dbSelectArea("SE1")
            dbSkip()
         Enddo

      Endif

      //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
      //³ Analiza as Saidas daquela natureza ³
      //³ A Realizar !!!                     ³
      //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

      If SED->ED_CODIGO >= cNaturInic .And. ;
         SED->ED_CODIGO <= cNaturFina

         dbSelectArea("SE2")
         dbSeek(xFilial("SE2")+SED->ED_CODIGO)

         While !Eof()                           .And. ;
               SE2->E2_FILIAL  == xFilial("SE2") .And. ;
               SE2->E2_NATUREZ == SED->ED_CODIGO

            #IFNDEF WINDOWS
               Inkey()
               If LastKey() == K_ALT_A
                  lEnd := .t.
               EndIf
            #ENDIF

            If SE2->E2_EMISSAO > dDataBase .Or. ;
               Subs(SE2->E2_TIPO,3,1) == "-"
               dbSelectArea("SE2")
               dbSkip()
               Loop
            Endif

            If SE2->E2_FLUXO == "N"
               dbSelectArea("SE2")
               dbSkip()
               Loop
            EndIf

            If nConDtBase == 1
               aValrFi[03] := SaldoTit(SE2->E2_PREFIXO,SE2->E2_NUM,          ;
                                       SE2->E2_PARCELA,SE2->E2_TIPO,         ;
                                       SE2->E2_NATUREZA,"P",SE2->E2_FORNECE, ;
                                       1,,,SE2->E2_LOJA)
            Else
               aValrFi[03] := xMoeda(SE2->E2_SALDO,SE2->E2_MOEDA,nMoeda)
            Endif

            aValrFi[03] := aValrFi[03] - CalcAbat(E2_PREFIXO,E2_NUM,E2_PARCELA,1,"P")

            If SE2->E2_VENCREA < dDataBase
               dDataTrab := dDataBase - 1
            Else
               dDataTrab := DataValida(SE2->E2_VENCREA,.T.)
            Endif

            If Abs(aValrFi[03]) > 0.0001

               dbSelectArea("SZ2")
               dbSetOrder(3)
               dbSeek(xFilial("SZ2")+SE2->E2_CC)

               cMesAnoTrab := SubStr(Dtos(dDataTrab),5,2) + Left(Dtos(dDataTrab),4)
               cAnoMesTrab := Left(Dtos(dDataTrab),6)
               cNaturez    := Left(Alltrim(SED->ED_CODIGO),nNivQueb)+Space(10-Len(Left(Alltrim(SED->ED_CODIGO),nNivQueb)))

               dbSelectArea("TRBN")
               If ! (dbSeek(cNaturez+cAnoMesTrab))
                  RecLock("TRBN",.T.)
                  Replace  Naturez   With  Left(Alltrim(SED->ED_CODIGO),nNivQueb)
                  Replace  DescNatu  With  SED->ED_DESCRIC
                  Replace  MesAnoTi  With  cMesAnoTrab
                  Replace  AnoMesTi  With  cAnoMesTrab
               Else
                  RecLock("TRBN",.F.)
               Endif

               If Substr(SE2->E2_TIPO,3,1) == "-" .Or. ;
                  SE2->E2_TIPO == "PA "           .Or. ;
                  SE2->E2_TIPO == "NDF"
                  If Right(DtoS(dDataTrab),2) < "15"
                     Replace  TotlCoD1  With  TRBN->TotlCoD1 - aValrFi[03]
                  Else
                     Replace  TotlCoD2  With  TRBN->TotlCoD2 - aValrFi[03]
                  EndIf
               Else
                  If Right(DtoS(dDataTrab),2) < "15"
                     Replace  TotlCoD1  With  TRBN->TotlCoD1 + aValrFi[03]
                  Else
                     Replace  TotlCoD2  With  TRBN->TotlCoD2 + aValrFi[03]
                  EndIf
               Endif

               MsUnlock()

            Endif

            dbSelectArea("SE2")
            dbSkip()
         Enddo

      Endif

      dbSelectArea("SED")
      dbSkip()
   Enddo
EndIf


If nConPV == 1

   nValorPV := 0
   cNaturPV := ""
   aVencPV  := {}
   dDtIniPV := CtoD(Space(08))

   dbSelectArea("SC6")
   dbSeek(xFilial("SC6"))

   ProcRegua(RecCount())
   cMsgRegua := "Processando os Pedidos de Venda"

   While ! Eof()                     .And. ;
         xFilial("SC6") == C6_FILIAL

      If C6_BLQ == "R"
         dbSelectArea("SC6")
         dbSkip()
         Loop
      Endif

      IncProc(cMsgRegua)

      nValorPV := C6_PRCVEN * (C6_QTDVEN-C6_QTDENT)

      dbSelectArea("SA1")
      dbSeek(xFilial("SA1")+SC6->C6_CLI)

      cNaturPV := Getmv("MV_1DUPNAT")
      cNaturPV := &cNaturPV

      dbSelectArea("SC5")
      dbSeek(xFilial("SC5")+SC6->C6_NUM)

      dbSelectArea("SED")
      dbSeek(xFilial("SED")+cNaturPV)

      IF nValorPV     >  0          .And. ;
         cNaturPV     >= cNaturInic .And. ;
         cNaturPV     <= cNaturFina .And. ;
         SC5->C5_TIPO == "N"

         dbSelectArea("SB1")
         dbSeek(xFilial("SB1")+SC6->C6_PRODUTO)

         nValorPV   := nValorPV * (1+SB1->B1_IPI/100)
         dDtIniPV   := Iif(SC6->C6_ENTREG < dDataBase,dDataBase,SC6->C6_ENTREG)
         aVencPV    := Condicao(nValorPV,SC5->C5_CONDPAG,dDtIniPV)
         nValorPV   := nValorPV/len(aVencPV)

         For ni := 1 to Len(aVencPV)

            If DataValida(aVencPV[ni][1],.T.) <= dDataFina

               dDataTrab   := DataValida(aVencPV[ni][1],.T.)
               cMesAnoTrab := SubStr(Dtos(dDataTrab),5,2) + Left(Dtos(dDataTrab),4)
               cAnoMesTrab := Left(Dtos(dDataTrab),6)
               cNaturez    := Left(Alltrim(SED->ED_CODIGO),nNivQueb)+Space(10-Len(Left(Alltrim(SED->ED_CODIGO),nNivQueb)))

               dbSelectArea("TRBN")
               If ! (dbSeek(cNaturez+cAnoMesTrab))
                  RecLock("TRBN",.T.)
                  Replace  Naturez   With  Left(Alltrim(cNaturPV),nNivQueb)
                  Replace  DescNatu  With  SED->ED_DESCRIC
                  Replace  MesAnoTi  With  cMesAnoTrab
                  Replace  AnoMesTi  With  cAnoMesTrab
               Else
                  RecLock("TRBN",.F.)
               Endif
               If Right(DtoS(dDataTrab),2) < "15"
                   Replace  TotlCoR1  With  TRBN->TotlCoR1 + nValorPV
               Else
                   Replace  TotlCoR2  With  TRBN->TotlCoR2 + nValorPV
               EndIf
               MsUnlock()
            Endif
         Next
      Endif

      dbSelectArea("SC6")
      dbSkip()
   Enddo

Endif


If nConPC == 1

   nValorPC := 0
   cNaturPC := ""
   aVencPC  := {}
   dDtIniPC := CtoD(Space(08))

   dbSelectArea("SC7")
   dbSeek(xFilial("SC7"))

   ProcRegua(RecCount())
   cMsgRegua := "Processando os Pedidos de Compra"

   While ! Eof()                         .And. ;
         xFilial("SC7") == SC7->C7_FILIAL

      If ! Empty(C7_RESIDUO)
         dbSelectArea("SC7")
         dbSkip()
         Loop
      Endif

      IncProc(cMsgRegua)

      nValorPC := C7_PRECO * (C7_QUANT-C7_QUJE) * (1+C7_IPI/100)

      dbSelectArea("SA2")
      dbSeek(xFilial("SA2")+SC7->C7_FORNECE)

      cNaturPC := Getmv("MV_2DUPNAT")
      cNaturPC := &cNaturPC

      dbSelectArea("SED")
      dbSeek(xFilial("SED")+cNaturPC)

      If nValorPC > 0           .And. ;
         cNaturPC >= cNaturInic .And. ;
         cNaturPC <= cNaturFina

         dDtIniPC := Iif(SC7->C7_DATPRF < dDataBase,dDataBase,SC7->C7_DATPRF)
         aVencPC  := Condicao(nValorPC,SC7->C7_COND,0,dDtIniPC)
         nValorPC := nValorPC / len(aVencPC)

         For ni := 1 to Len(aVencPC)

            If DataValida(aVencPC[ni][1],.T.) <= dDataFina

               dDataTrab   := DataValida(aVencPC[ni][1],.T.)
               cMesAnoTrab := SubStr(Dtos(dDataTrab),5,2) + Left(Dtos(dDataTrab),4)
               cAnoMesTrab := Left(Dtos(dDataTrab),6)
               cNaturez    := Left(Alltrim(SED->ED_CODIGO),nNivQueb)+Space(10-Len(Left(Alltrim(SED->ED_CODIGO),nNivQueb)))

               dbSelectArea("TRBN")
               If ! (dbSeek(cNaturez+cAnoMesTrab))
                  RecLock("TRBN",.T.)
                  Replace  Naturez   With  Left(Alltrim(SED->ED_CODIGO),nNivQueb)
                  Replace  DescNatu  With  SED->ED_DESCRIC
                  Replace  MesAnoTi  With  cMesAnoTrab
                  Replace  AnoMesTi  With  cAnoMesTrab
               Else
                  RecLock("TRBN",.F.)
               Endif
               If Right(DtoS(dDataTrab),2) < "15"
                  Replace  TotlCoD1  With  TRBN->TotlCoD1 + nValorPC
               Else
                  Replace  TotlCoD2  With  TRBN->TotlCoD2 + nValorPC
               EndIf
               MsUnlock()
            Endif
         Next
      Endif

      dbSelectArea("SC7")
      dbSkip()
   Enddo

Endif

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Restaura os arquivos de contas a receber / pagar para auxiliar ³
//³ an lise do se5 caso seja escolhido regime de caixa             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
RetIndex("SE1")
Set Filter To

RetIndex("SE2")
Set Filter To

If nImpOrPrAm == 1 .Or. nImpOrPrAm == 3
   // ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
   // ³Esta montado as Data de Vencimento dos Clientes ³
   // ³             (SZ1 - Contrato)                   ³
   // ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

   cAnoF := SubStr(cMesAnoFin,3)
   cMesF := Left(cMesAnoFin,2)

   dbSelectArea("SZ1")
   dbSetOrder(1)
   dbGoTop()

   ProcRegua(RecCount())
   cMsgRegua := "Processando os Contratos"

   While ! Eof()

      dbSelectArea("SZ1")
      cAnoI   := SubStr(cMesAnoIni,3)
      cMesI   := Left(cMesAnoIni,2)
      cCodAnt := SZ1->Z1_COD

      IncProc(cMsgRegua)

      While  ! Eof()                          .And. ;
             SZ1->Z1_Filial == xFilial("SZ1") .And. ;
             SZ1->Z1_COD    == cCodAnt        .And. ;
             (cAnoI+cMesI)  <= (cAnoF+cMesF)

         dDtReVenc := (StoD(cAnoI+cMesI+SubStr(DtoS(SZ1->Z1_DTVENC),7))+Val(SZ1->Z1_DIAFREN))

         If Empty(dDtReVenc)
            dbSelectArea("SZ1")
            dbSkip()
            Loop
         EndIf

         If dDtReVenc < dDataInic .And. ;
            dDtReVenc > dDataFina
            dbSelectArea("SZ1")
            dbSkip()
            Loop
         EndIf

         dbSelectArea("SZ2")
         dbSetOrder(1)
         dbSeek(xFilial("SZ2")+SZ1->Z1_COD)

         While (! Eof())                           .And.;
               (xFilial("SZ2")  == SZ2->Z2_FILIAL) .And.;
               (SZ2->Z2_COD     == SZ1->Z1_COD)

            cContrato := SZ1->Z1_COD+Space(6-Len(SZ1->Z1_COD))
            cSubConta := SZ2->Z2_SUBC+Space(11-Len(SZ2->Z2_SUBC))

            dbSelectArea("TRBC")
            dbSetOrder(1)
            dbSeek(DTOS(dDtReVenc)+"C"+cContrato+cSubConta)

            If Eof()
               RecLock("TRBC",.T.)
               Replace  DtTitulo  With  dDtReVenc
               Replace  TipoClFo  With  "C"
               Replace  CodiClFo  With  SZ1->Z1_CODCLI
               Replace  LojaClFo  With  SZ1->Z1_LOJA
               Replace  Contrato  With  SZ1->Z1_COD
               Replace  SubConta  With  SZ2->Z2_SUBC
               MsUnlock()
            Endif

            dbSelectArea("SZ2")
            dbSkip()
         EndDo

         cMesI := StrZero((Val(cMesI)+1),2)

         If cMesI > "12"
            cMesI := "01"
            cAnoI := StrZero((Val(cAnoI)+1),4)
         EndIf

      EndDo

      dbSelectArea("SZ1")
      dbSkip()
   EndDo

   // ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
   // ³Esta montado as Data de Vencimento dos Fornecedores ³
   // ³          (SZC - Contrato x Fornecedor)             ³
   // ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

   cAnoF := SubStr(cMesAnoFin,3)
   cMesF := Left(cMesAnoFin,2)

   dbSelectArea("SZC")
   dbSetOrder(1)
   dbGoTop()

   ProcRegua(RecCount())
   cMsgRegua := "Processando os Contratos x Fornecedores"

   While ! Eof()

      dbSelectArea("SZC")
      cAnoI   := SubStr(cMesAnoIni,3)
      cMesI   := Left(cMesAnoIni,2)
      cCodAnt := SZC->ZC_CONTRAT

      While  ! Eof()                           .And. ;
             SZC->ZC_FILIAL  == xFilial("SZC") .And. ;
             SZC->ZC_CONTRAT == cCodAnt        .And. ;
             (cAnoI+cMesI)   <= (cAnoF+cMesF)

         dDtReVenc := (StoD(cAnoI+cMesI+SZC->ZC_VENCFAT)+Val(SZC->ZC_DIAFREN))

         IncProc(cMsgRegua)

         If Empty(dDtReVenc)
            dbSelectArea("SZC")
            dbSkip()
            Loop
         EndIf

         If dDtReVenc < dDataInic .And. ;
            dDtReVenc > dDataFina
            dbSelectArea("SZC")
            dbSkip()
            Loop
         EndIf

         dbSelectArea("SZ2")
         dbSetOrder(1)
         dbSeek(xFilial("SZ2")+SZC->ZC_CONTRAT)

         While (! Eof())                            .And.;
               (xFilial("SZ2")  == SZ2->Z2_FILIAL)  .And.;
               (SZ2->Z2_COD     == SZC->ZC_CONTRAT)

            cContrato := SZC->ZC_CONTRAT+Space(6-Len(SZC->ZC_CONTRAT))
            cSubConta := SZ2->Z2_SUBC+Space(11-Len(SZ2->Z2_SUBC))
            dbSelectArea("TRBC")
            dbSetOrder(1)
            dbSeek(DTOS(dDtReVenc)+"F"+cContrato+cSubConta)

            If Eof()
               RecLock("TRBC",.T.)
               Replace  DtTitulo  With  dDtReVenc
               Replace  TipoClFo  With  "F"
               Replace  CodiClFo  With  SZC->ZC_FORNECE
               Replace  LojaClFo  With  SZC->ZC_LOJA
               Replace  Contrato  With  SZC->ZC_CONTRAT
               Replace  SubConta  With  SZ2->Z2_SUBC
               MsUnlock()
            Endif

            dbSelectArea("SZ2")
            dbSkip()
         EndDo

         cMesI := StrZero((Val(cMesI)+1),2)

         If cMesI > "12"
            cMesI := "01"
            cAnoI := StrZero((Val(cAnoI)+1),4)
         EndIf

      EndDo

      dbSelectArea("SZC")
      dbSkip()
   EndDo

   // ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
   // ³Esta montado as Data de Vencimento dos Diversos e Empregados ³
   // ³                     (SZB - Orcameto)                        ³
   // ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

   cAnoF := SubStr(cMesAnoFin,3)
   cMesF := Left(cMesAnoFin,2)

   dbSelectArea("SZB")
   dbSetOrder(1)
   dbGoTop()

   ProcRegua(RecCount())
   cMsgRegua := "Processando os Tipos Diversos e Empregados"

   While ! Eof()

      If ! SZB->ZB_TIPO $ "D_E"
         dbSelectArea("SZB")
         dbSkip()
         Loop
      EndIf

      dbSelectArea("SZB")
      cAnoI   := SubStr(cMesAnoIni,3)
      cMesI   := Left(cMesAnoIni,2)
      cCodAnt := SZB->ZB_CCUSTO

      While  ! Eof()                           .And. ;
             SZB->ZB_FILIAL  == xFilial("SZB") .And. ;
             SZB->ZB_CCUSTO == cCodAnt         .And. ;
             (cAnoI+cMesI)   <= (cAnoF+cMesF)

         IncProc(cMsgRegua)

         If SZB->ZB_TIPO == "D"
            dDtReVenc := (StoD(cAnoI+cMesI+"10"))

            If Empty(dDtReVenc)
               dbSelectArea("SZB")
               dbSkip()
               Loop
            EndIf

            If dDtReVenc < dDataInic .And. ;
               dDtReVenc > dDataFina
               dbSelectArea("SZB")
               dbSkip()
               Loop
            EndIf

            dbSelectArea("SZ2")
            dbSetOrder(3)
            dbSeek(xFilial("SZ2")+SZB->ZB_CCUSTO)

            cContrato := SZ2->Z2_COD+Space(6-Len(SZ2->Z2_COD))
            cSubConta := SZB->ZB_CCUSTO+Space(11-Len(SZB->ZB_CCUSTO))

            dbSelectArea("TRBC")
            dbSetOrder(1)
            dbSeek(DTOS(dDtReVenc)+"F"+cContrato+cSubConta)

            If Eof()
               RecLock("TRBC",.T.)
               Replace  DtTitulo  With  dDtReVenc
               Replace  TipoClFo  With  "F"
               Replace  CodiClFo  With  Left(SZB->ZB_DESCRI,6)
               Replace  LojaClFo  With  SubStr(SZB->ZB_DESCRI,7,2)
               Replace  Contrato  With  SZ2->Z2_COD
               Replace  SubConta  With  SZB->ZB_CCUSTO
               MsUnlock()
            Endif
         ElseIf SZB->ZB_TIPO == "E"
            dDtReVenc := (StoD(cAnoI+cMesI+"05"))

            If Empty(dDtReVenc)
               dbSelectArea("SZB")
               dbSkip()
               Loop
            EndIf

            If dDtReVenc < dDataInic .And. ;
               dDtReVenc > dDataFina
               dbSelectArea("SZB")
               dbSkip()
               Loop
            EndIf

            dbSelectArea("SZ2")
            dbSetOrder(3)
            dbSeek(xFilial("SZ2")+SZB->ZB_CCUSTO)

            cContrato := SZ2->Z2_COD+Space(6-Len(SZ2->Z2_COD))
            cSubConta := SZB->ZB_CCUSTO+Space(11-Len(SZB->ZB_CCUSTO))

            dbSelectArea("TRBC")
            dbSetOrder(1)
            dbSeek(DTOS(dDtReVenc)+"F"+cContrato+cSubConta)

            If Eof()
               RecLock("TRBC",.T.)
               Replace  DtTitulo  With  dDtReVenc
               Replace  TipoClFo  With  "F"
               Replace  CodiClFo  With  "000907"
               Replace  LojaClFo  With  "01"
               Replace  Contrato  With  SZ2->Z2_COD
               Replace  SubConta  With  SZB->ZB_CCUSTO
               Replace  CodEmpre  With  Iif(SZB->ZB_TIPO == "E",SZB->ZB_DESCRI,"")
               MsUnlock()
            Endif
         EndIf

         cMesI := StrZero((Val(cMesI)+1),2)

         If cMesI > "12"
            cMesI := "01"
            cAnoI := StrZero((Val(cAnoI)+1),4)
         EndIf

      EndDo

      dbSelectArea("SZB")
      dbSkip()
   EndDo

   dbSelectArea("TRBC")
   dbSetOrder(1)
   Set SoftSeek On
   dbSeek(DtoS(dDataInic))
   Set SoftSeek Off

   ProcRegua(RecCount())
   cMsgRegua := "Processando os Orcamentos"

   While ! Eof()                     .And. ;
         TRBC->DtTitulo <= dDataFina

      cAno    := SubStr(DtoS(TRBC->DtTitulo),1,4)
      cRev    := "000"
      cCCusto := (TRBC->SUBCONTA+Space(11-Len(TRBC->SUBCONTA)))

      If TRBC->CODICLFO == "000907" .And. ! Empty(TRBC->CODEMPRE)
         cDescri := (TRBC->CODEMPRE+Space(10-Len(TRBC->CODEMPRE)))
      Else
         cDescri := (TRBC->CODICLFO+TRBC->LOJACLFO+Space(10-Len(TRBC->CODICLFO+TRBC->LOJACLFO)))
      EndIf

      dbSelectArea("SZB")
      dbSetOrder(1)
      dbSeek(xFilial("SZB")+cCCusto+cAno)

      While (! Eof())                                            .And. ;
            (Alltrim(SZB->ZB_CCUSTO) == Alltrim(TRBC->SUBCONTA)) .And. ;
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

      IncProc(cMsgRegua)

      If ! Eof()

         If TRBC->DtTitulo < dDataBase
            dDataTrab := dDataBase - 1
         Else
            dDataTrab := DataValida(TRBC->DtTitulo,.T.)
         Endif

         dbSelectArea("SZA")
         dbSetOrder(1)
         dbSeek(xFilial("SZA")+SZB->ZB_GRUPGER)

         If ! Eof() .And. SZA->ZA_FLUXO == "S"

            dbSelectArea("SED")
            dbSeek(xFilial("SED")+SZA->ZA_NATUREZ)

            If TRBC->DtTitulo < dDataBase
               dDataTrab := dDataBase - 1
            Else
               dDataTrab := DataValida(TRBC->DtTitulo,.T.)
            Endif
            cMesAnoTrab := SubStr(Dtos(dDataTrab),5,2) + Left(Dtos(dDataTrab),4)
            cAnoMesTrab := Left(Dtos(dDataTrab),6)
            cMes        := Left(cMesAnoTrab,2)
            cNaturez    := Left(Alltrim(SED->ED_CODIGO),nNivQueb)+Space(10-Len(Left(Alltrim(SED->ED_CODIGO),nNivQueb)))

            dbSelectArea("TRBN")
            If ! (dbSeek(cNaturez+cAnoMesTrab))
               RecLock("TRBN",.T.)
               Replace  Naturez   With  Left(Alltrim(SZA->ZA_NATUREZ),nNivQueb)
               Replace  DescNatu  With  SED->ED_DESCRIC
               Replace  MesAnoTi  With  cMesAnoTrab
               Replace  AnoMesTi  With  cAnoMesTrab
            Else
               RecLock("TRBN",.F.)
            Endif
            Do Case
               Case cMes == "01"
                    If SZB->ZB_MES01 < SZB->ZB_SALD01
                       Replace ValrTitu With 0
                    Else
                       If TRBC->TipoClFo == "C"
                           Replace  TotlCoOR  With  TRBN->TotlCoOR + (SZB->ZB_MES01 - SZB->ZB_SALD01)
                       Else
                           Replace  TotlCoOD  With  TRBN->TotlCoOD + (SZB->ZB_MES01 - SZB->ZB_SALD01)
                       EndIf
                    EndIf
               Case cMes == "02"
                    If SZB->ZB_MES02 < SZB->ZB_SALD02
                       Replace ValrTitu With 0
                    Else
                       If TRBC->TipoClFo == "C"
                           Replace  TotlCoOR  With  TRBN->TotlCoOR + (SZB->ZB_MES02 - SZB->ZB_SALD02)
                       Else
                           Replace  TotlCoOD  With  TRBN->TotlCoOD + (SZB->ZB_MES02 - SZB->ZB_SALD02)
                       EndIf
                    EndIf
               Case cMes == "03"
                    If SZB->ZB_MES03 < SZB->ZB_SALD03
                       Replace ValrTitu With 0
                    Else
                       If TRBC->TipoClFo == "C"
                           Replace  TotlCoOR  With  TRBN->TotlCoOR + (SZB->ZB_MES03 - SZB->ZB_SALD03)
                       Else
                           Replace  TotlCoOD  With  TRBN->TotlCoOD + (SZB->ZB_MES03 - SZB->ZB_SALD03)
                       EndIf
                    EndIf
               Case cMes == "04"
                    If SZB->ZB_MES04 < SZB->ZB_SALD04
                       Replace ValrTitu With 0
                    Else
                       If TRBC->TipoClFo == "C"
                           Replace  TotlCoOR  With  TRBN->TotlCoOR + (SZB->ZB_MES04 - SZB->ZB_SALD04)
                       Else
                           Replace  TotlCoOD  With  TRBN->TotlCoOD + (SZB->ZB_MES04 - SZB->ZB_SALD04)
                       EndIf
                    EndIf
               Case cMes == "05"
                    If SZB->ZB_MES05 < SZB->ZB_SALD05
                       Replace ValrTitu With 0
                    Else
                       If TRBC->TipoClFo == "C"
                           Replace  TotlCoOR  With  TRBN->TotlCoOR + (SZB->ZB_MES05 - SZB->ZB_SALD05)
                       Else
                           Replace  TotlCoOD  With  TRBN->TotlCoOD + (SZB->ZB_MES05 - SZB->ZB_SALD05)
                       EndIf
                    EndIf
               Case cMes == "06"
                    If SZB->ZB_MES06 < SZB->ZB_SALD06
                       Replace ValrTitu With 0
                    Else
                       If TRBC->TipoClFo == "C"
                           Replace  TotlCoOR  With  TRBN->TotlCoOR + (SZB->ZB_MES06 - SZB->ZB_SALD06)
                       Else
                           Replace  TotlCoOD  With  TRBN->TotlCoOD + (SZB->ZB_MES06 - SZB->ZB_SALD06)
                       EndIf
                    EndIf
               Case cMes == "07"
                    If SZB->ZB_MES07 < SZB->ZB_SALD07
                       Replace ValrTitu With 0
                    Else
                       If TRBC->TipoClFo == "C"
                           Replace  TotlCoOR  With  TRBN->TotlCoOR + (SZB->ZB_MES07 - SZB->ZB_SALD07)
                       Else
                           Replace  TotlCoOD  With  TRBN->TotlCoOD + (SZB->ZB_MES07 - SZB->ZB_SALD07)
                       EndIf
                    EndIf
               Case cMes == "08"
                    If SZB->ZB_MES08 < SZB->ZB_SALD08
                       Replace ValrTitu With 0
                    Else
                       If TRBC->TipoClFo == "C"
                           Replace  TotlCoOR  With  TRBN->TotlCoOR + (SZB->ZB_MES08 - SZB->ZB_SALD08)
                       Else
                           Replace  TotlCoOD  With  TRBN->TotlCoOD + (SZB->ZB_MES08 - SZB->ZB_SALD08)
                       EndIf
                    EndIf
               Case cMes == "09"
                    If SZB->ZB_MES09 < SZB->ZB_SALD09
                       Replace ValrTitu With 0
                    Else
                       If TRBC->TipoClFo == "C"
                           Replace  TotlCoOR  With  TRBN->TotlCoOR + (SZB->ZB_MES09 - SZB->ZB_SALD09)
                       Else
                           Replace  TotlCoOD  With  TRBN->TotlCoOD + (SZB->ZB_MES09 - SZB->ZB_SALD09)
                       EndIf
                    EndIf
               Case cMes == "10"
                    If SZB->ZB_MES10 < SZB->ZB_SALD10
                       Replace ValrTitu With 0
                    Else
                       If TRBC->TipoClFo == "C"
                           Replace  TotlCoOR  With  TRBN->TotlCoOR + (SZB->ZB_MES10 - SZB->ZB_SALD10)
                       Else
                           Replace  TotlCoOD  With  TRBN->TotlCoOD + (SZB->ZB_MES10 - SZB->ZB_SALD10)
                       EndIf
                    EndIf
               Case cMes == "11"
                    If SZB->ZB_MES11 < SZB->ZB_SALD11
                       Replace ValrTitu With 0
                    Else
                       If TRBC->TipoClFo == "C"
                           Replace  TotlCoOR  With  TRBN->TotlCoOR + (SZB->ZB_MES11 - SZB->ZB_SALD11)
                       Else
                           Replace  TotlCoOD  With  TRBN->TotlCoOD + (SZB->ZB_MES11 - SZB->ZB_SALD11)
                       EndIf
                    EndIf
               Case cMes == "12"
                    If SZB->ZB_MES12 < SZB->ZB_SALD12
                       Replace ValrTitu With 0
                    Else
                       If TRBC->TipoClFo == "C"
                           Replace  TotlCoOR  With  TRBN->TotlCoOR + (SZB->ZB_MES12 - SZB->ZB_SALD12)
                       Else
                           Replace  TotlCoOD  With  TRBN->TotlCoOD + (SZB->ZB_MES12 - SZB->ZB_SALD12)
                       EndIf
                    EndIf
            EndCase
            MsUnlock()
         Endif
      Endif
      dbSelectArea("TRBC")
      dbSkip()
   EndDo

EndIf

Return



// Substituido pelo assistente de conversao do AP5 IDE em 25/06/01 ==> Function FaT901Imp
Static Function FaT901Imp()
*****************************************************************************
* Imprime as Informacoes do Arquivo de Trabalho TRBF
***

Local nColun := 0

m_pag      := 1
nContLinha := 80
cRodatxt   := ""
nCntImpr   := 0
nCAnt      := 0
nCCAnt     := 0
nNumColu   := 0
lPrVCab    := .T.
lPrVDet    := .T.
lPrVSub    := .T.
aColunas   := {}
*???aTo1Nat    := {}
aTo1Nat1   := {} // 1a Quinzena SubTotal
aTo1Nat2   := {} // 2a Quinzena SubTotal
aTo1NatP   := {} // Previsto    SubTotal
aTo1NatO   := {} // Orcado      SubTotal
aTo1NatT   := {} // Total       SubTotal
*???aTo2Nat    := {}
aTo2Nat1   := {} // 1a Quinzena Total
aTo2Nat2   := {} // 2a Quinzena Total
aTo2NatP   := {} // Previsto    Total
aTo2NatO   := {} // Orcado      Total
aTo2NatT   := {} // Total       Total
aMeses     := {}
aNomeMes   := {"JANEIRO", "FEVEREIRO", "MARCO",   ;
               "ABRIL",   "MAIO",      "JUNHO",   ;
               "JULHO",   "AGOSTO",    "SETEMBRO",;
               "OUTUBRO", "NOVEMBRO",  "DEZEMBRO"  }

If nImprQuiMe == 1
   aPosCab1 := {27,39,75,87,123,135,171,183,219}
   aPosCab2 := {27,29,41,54,67,77,89,102,115,125,136,151,163,173,185,198,211}
   aPosDet1 := {001,028,040,052,064,076,088,100,112,124,136,148,160,172,184,196,208}
Else
   aPosCab1 := {30,42,66,78,102,114,138,150,174,186,210}
   aPosCab2 := {30,33,45,58,69,81,94,105,117,130,141,153,166,177,189,202}
   aPosDet1 := {001,031,043,055,067,079,091,103,115,127,139,151,163,175,187,199}
EndIf

// Mes     -> nContMes, nNumMes, nNuMeAnt, nNumMes2, nNuMeAnt2, nNumeAntAux, nNumeAntAux2
aPosMes    := {0,0,0,0,0,0,0,0}
// Coluna  -> nNumColun, nNuCoAnt, nNumCol2, nNumColun2, nNuCoAnt2, nNumCol22, Aux1, Aux2, Aux3
aPosColun  := {0,0,0,0,0,0,0,0,0}
// Cabec   -> Nao foram definidas variaveis (foi criado caso fosse necessario utilizar)
aPosCabec  := {0,0,0,0,0,0,0}
// Det     -> nContDet, nNumDet, nNuDeAnt, nContDet2, nNumDet2, nNuDeAnt2
aPosDet    := {0,0,0,0,0,0,0,0,0,0}
// Stot     -> nContStot, nNumStot, nNuSTAnt, nContSTo2, nNumSTo2, nNuSTAnt2
aPosStot   := {0,0,0,0,0,0,0,0,0,0}
// TotG     -> nContTotG, nNumTotG, nNuTGAnt, nContToG2, nNumToG2, nNuTGAnt2
aPosTotG   := {0,0,0,0,0,0,0}


//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Definicao dos cabecalhos                                     ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Localiza e grava titulos a receber dentro dos parametros     ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

If nImprQuiMe == 1
   nColArr  := 4
   nLefDesc := 26
Else
   nColArr  := 3
   nLefDesc := 29
EndIf

dbSelectArea("TRBN")
dbSetorder(1)
dbGoTop()

While ! Eof()

   nPosMes := aScan(aMeses,TRBN->AnoMesTi)
   If nPosMes == 0
      Aadd(aMeses,TRBN->AnoMesTi)
      Aadd(aTo1Nat1,0)
      Aadd(aTo1Nat2,0)
      Aadd(aTo1NatP,0)
      Aadd(aTo1NatO,0)
      Aadd(aTo1NatT,0)
      Aadd(aTo2Nat1,0)
      Aadd(aTo2Nat2,0)
      Aadd(aTo2NatP,0)
      Aadd(aTo2NatO,0)
      Aadd(aTo2NatT,0)
      For nColun := 1 To nColArr
          Do Case
             Case nColun == 1
                   Aadd(aColunas,Iif(nImprQuiMe==1,"1a Quinz. |","Previsto |"))
              Case nColun == 2
                   Aadd(aColunas,Iif(nImprQuiMe==1,"2a Quinz. |","Orcado   |"))
              Case nColun == 3
                   Aadd(aColunas,Iif(nImprQuiMe==1,"Orcado   |","Total   |"))
              Case nColun == 4
                   Aadd(aColunas,Iif(nImprQuiMe==1,"Total   |",""))
           EndCase
       Next
   EndIf

   dbSelectArea("TRBN")
   dbSkip()

EndDo

aMeses := aSort(aMeses)

dbSelectArea("TRBN")
dbSetorder(1)
dbGoTop()

While aPosMes[01] <= Len(aMeses)

   AtuaInfo()
   MontLin()

   dbSelectArea("TRBN")
   dbSetorder(1)
   dbGotop()

   While ! Eof()

      cNatAnt := TRBN->Naturez

      ImprDeta()

      If Len(aMeses) > 4
         If lPrVDet
            aPosDet[04] := aPosDet[01]
            aPosDet[05] := aPosDet[02]
            aPosDet[06] := aPosDet[03]
            lPrVDet    := .F.
         EndIf
         aPosDet[01] := aPosDet[07]
         aPosDet[02] := aPosDet[08]
         aPosDet[03] := aPosDet[09]
         dbSelectArea("TRBN")
         dbSetorder(1)
         dbSeek(cNaturez+aMeses[Len(aMeses)])
         If Eof()
            dbSelectArea("TRBN")
            dbSetorder(1)
            Set SoftSeek On
            dbSeek(cNaturez+aMeses[Len(aMeses)])
            Set SoftSeek Off
         Else
            dbSelectArea("TRBN")
            dbSkip()
         EndIf
      Else
         aPosDet[01] := 0
         aPosDet[02] := 0
         aPosDet[03] := 0
         dbSelectArea("TRBN")
         dbSetorder(1)
         dbSeek(cChavTRBN)
         dbSelectArea("TRBN")
         dbSkip()
      EndIf

      If Left(cNatAnt,1) <> Left(TRBN->Naturez,1)
         SubTotal()
      EndIf

   EndDo

   aPosMes[02]   := aPosMes[04]
   aPosMes[03]   := aPosMes[05]
   aPosMes[06]   := aPosMes[04]
   aPosMes[07]   := aPosMes[05]
   aPosColun[01] := aPosColun[04]
   aPosColun[02] := aPosColun[05]
   aPosColun[03] := aPosColun[06]
   aPosColun[07] := aPosColun[04]
   aPosColun[08] := aPosColun[05]
   aPosColun[09] := aPosColun[06]
   lPrVCab       := .T.

   aPosDet[01]  := aPosDet[04]
   aPosDet[02]  := aPosDet[05]
   aPosDet[03]  := aPosDet[06]
   aPosDet[07]  := aPosDet[04]
   aPosDet[08]  := aPosDet[05]
   aPosDet[09]  := aPosDet[06]
   lPrVDet      := .T.

   aPosStot[01] := aPosStot[04]
   aPosStot[02] := aPosStot[05]
   aPosStot[03] := aPosStot[06]
   aPosStot[07] := aPosStot[04]
   aPosStot[08] := aPosStot[05]
   aPosStot[09] := aPosStot[06]
   lPrVSub      := .T.

   TotGer()

   aPosMes[01] := aPosMes[01] + (IIf(nImprQuiMe == 1,5,4))

EndDo

aPosMes[01] := 0

IF nContLinha != 80
   Roda(nCntImpr,cRodaTxt,Tamanho)
EndIF

Set Device To Screen

If aReturn[5] == 1
   Set Printer TO
   dbcommitAll()
   ourspool(wnrel)
Endif

MS_FLUSH()

Return



// Substituido pelo assistente de conversao do AP5 IDE em 25/06/01 ==> Function MontLin
Static Function MontLin()
*****************************************************************************
* Monta as Linhas...
***

If nImprQuiMe == 1

   cLinhaCab1	:= "|"+Replicate("-",26) + "+" + ;
                   Iif(Len(aMeses) > 4, ;
                       Replicate("-----------------------------------------------+",nNumColu) , ;
                       Replicate("-----------------------------------------------+",(Len(aMeses)-1))) +            ;
                       Replicate("-",47) + "|"

   cLinhaCab2   := "|    HISTORICO  /  MES     |" + Iif(Len(aMeses) > 4 , ;
                                                        Replicate("-----------+-----------+-----------+-----------+",nNumColu), ;
                                                        Replicate("-----------+-----------+-----------+-----------+",(Len(aMeses)-1))) +            ;
                                                         "-----------+-----------+-----------+-----------|"
   cLinhaDet1   := "|" + Replicate("-",26) + "+" + ;
                   Iif(Len(aMeses) > 4, ;
                       Replicate("-----------+-----------+-----------+-----------+",nNumColu), ;
                       Replicate("-----------+-----------+-----------+-----------+",(Len(aMeses)-1))) +           ;
                       "-----------+-----------+-----------+-----------|"
   cLinhaDet2   := "+" + Replicate("-",26) + "+" + ;
                   Iif(Len(aMeses) > 4, ;
                       Replicate("-----------+-----------+-----------+-----------+",nNumColu), ;
                       Replicate("-----------+-----------+-----------+-----------+",(Len(aMeses)-1))) + ;
                       "-----------+-----------+-----------+-----------|"
Else
   cLinhaCab1   := "|" + Replicate("-",29) + "+" + ;
                   Iif(Len(aMeses) > 5, ;
                       Replicate("-----------------------------------+",nNumColu), ;
                       Replicate("-----------------------------------+",(Len(aMeses)-1))) +          ;
                       Replicate("-",35) + "|"
   cLinhaCab2   := "|      HISTORICO  /  MES      +" + Iif(Len(aMeses) > 4, ;
                                                           Replicate("-----------+-----------+-----------+",nNumColu), ;
                                                           Replicate("-----------+-----------+-----------+",(Len(aMeses)-1))) +          ;
                                                           "-----------+-----------+-----------|"
   cLinhaDet1   := "|" + Replicate("-",29) + "+" + ;
                   Iif(Len(aMeses) > 5,;
                       Replicate("-----------+-----------+-----------+",nNumColu), ;
                       Replicate("-----------+-----------+-----------+",(Len(aMeses)-1))) +          ;
                       "-----------+-----------+-----------|"
   cLinhaDet2   := "|" + Replicate("-",29) + "+" + ;
                   Iif(Len(aMeses) > 5, ;
                       Replicate("-----------+-----------+-----------+",nNumColu), ;
                       Replicate("-----------+-----------+-----------+",(Len(aMeses)-1))) +          ;
                       "-----------+-----------+-----------|"
EndIf

Return



// Substituido pelo assistente de conversao do AP5 IDE em 25/06/01 ==> Function ImprCabe
Static Function ImprCabe()
*****************************************************************************
* Impressao do Relatorio (Cabecalho)
***

Local nC := 0
Local nCC2 := 0
Local nCC := 0 

nContLinha  := Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho) + 2

aPosMes[02] := Iif(nImprQuiMe == 1,                                               ;
                   Iif((Len(aMeses)-aPosMes[03]) > 4, 4, (Len(aMeses)-aPosMes[03])), ;
                   Iif((Len(aMeses)-aPosMes[03]) > 5, 5, (Len(aMeses)-aPosMes[03])))
nPosiMes := Iif(aPosMes[01] == 0, 1, aPosMes[01])
@ nContLinha,   000 PSAY cLinhaCab1
nContLinha := nContLinha + 1

nPM := 1

For nC := 1 To aPosMes[02]
    If nC == 1
       @ nContLinha, 000 PSAY "|"
       @ nContLinha, aPosCab1[nPM] PSAY "|"
       @ nContLinha, aPosCab1[nPM+1] PSAY aNomeMes[Val(Right(aMeses[nPosiMes],2))]
       @ nContLinha, aPosCab1[nPM+2] PSAY "|"
       nPM := nPM + 1
    Else
       @ nContLinha, aPosCab1[nPM] PSAY aNomeMes[Val(Right(aMeses[nPosiMes],2))]
       @ nContLinha, aPosCab1[nPM+1] PSAY "|"
    EndIf
    nPosiMes := nPosiMes + 1
    nPM := nPM + 2
Next

aPosMes[03] := aPosMes[03] + aPosMes[02]

nContLinha := nContLinha + 1
@ nContLinha, 000 PSAY cLinhaCab2
nContLinha := nContLinha + 1

aPosColun[01] := Iif(nImprQuiMe == 1,                                             ;
                     Iif((Len(aMeses)-aPosColun[02]) > 4, 4, (Len(aMeses)-aPosColun[02])),;
                     Iif((Len(aMeses)-aPosColun[02]) > 5, 5, (Len(aMeses)-aPosColun[02])))
aPosColun[03]  := Iif(nImprQuiMe == 1, 4, 3)
nPC       := 1
lPrVez    := .T.

For nCC := 1 To aPosColun[01]

    For nCC2 := 1 To aPosColun[03]
    
       If lPrVez
          @ nContLinha, 000 PSAY "|"
          @ nContLinha, aPosCab2[nPC] PSAY "|"
          @ nContLinha, aPosCab2[nPC+1] PSAY aColunas[nCC2]
          lPrVez := .F.
          nPC := nPC + 1
       Else
          @ nContLinha, aPosCab2[nPC] PSAY aColunas[nCC2]
       EndIf
       nPC := nPC + 1
   Next
Next

lPrVez        := .T.
aPosColun[02] := aPosColun[02] + aPosColun[01]

nContLinha := nContLinha + 1
@ nContLinha, 000 PSAY cLinhaDet1
nContLinha := nContLinha + 1

If Len(aMeses) > 4
   If lPrVCab
      aPosMes[04]   := aPosMes[02]
      aPosMes[05]   := aPosMes[03]
      aPosColun[04] := aPosColun[01]
      aPosColun[05] := aPosColun[02]
      aPosColun[06] := aPosColun[03]
      lPrVCab := .F.
   EndIf
   aPosMes[02]   := aPosMes[06]
   aPosMes[03]   := aPosMes[07]
   aPosColun[01] := aPosColun[07]
   aPosColun[02] := aPosColun[08]
   aPosColun[03] := aPosColun[09]
Else
   aPosMes[02]   := 0
   aPosMes[03]   := 0
   aPosColun[01] := 0
   aPosColun[02] := 0
   aPosColun[03] := 0
EndIf

Return



// Substituido pelo assistente de conversao do AP5 IDE em 25/06/01 ==> Function Imprdeta
Static Function Imprdeta()
*****************************************************************************
*  Imprime as Linhas de Detalhe
***

Local nD := 0

If (nContLinha > 59 )
   nLinha := 80
   AtuaInfo()
   ImprCabe()
EndIf

aPosDet[02] := Iif(nImprQuiMe == 1,                                             ;
                   Iif((Len(aMeses)-aPosDet[03]) > 4, 4, (Len(aMeses)-aPosDet[03])),;
                   Iif((Len(aMeses)-aPosDet[03]) > 5, 5, (Len(aMeses)-aPosDet[03])))

nPosiDet    := Iif(aPosDet[03] == 0, 1, aPosDet[03] + 1)

nPD         := 1
lPrVez      := .T.
nValoR1     := 0
nValoR2     := 0
nValoTP     := 0
nValoO      := 0
nValoT      := 0
cNaturez    := TRBN->Naturez
cChavTRBN   := ""

For nD := 1 To aPosDet[02]

    If nD == 1
       @ nContLinha, 000 PSAY "|"
       @ nContLinha, aPosDet1[01] PSAY Left(TRBN->DescNatu,nLefDesc) + "|"
       nPD := 2
    EndIf

    dbSelectArea("TRBN")
    dbSetorder(1)
    dbSeek(cNaturez+aMeses[nPosiDet])

    If ! Eof()
       cChavTRBN := cNaturez+aMeses[nPosiDet]
    EndIf

    nValoR1 := (TRBN->TotlCoR1 - TRBN->TotlCoD1)
    nValoR2 := (TRBN->TotlCoR2 - TRBN->TotlCoD2)
    nValoTP := nValoR1 + nValoR2
    nValoO  := (TRBN->TotlCoOR - TRBN->TotlCoOD)
    nValoT  :=  nValoT + nValoTP + nValoO

    aTo1Nat1[nPosiDet] := aTo1Nat1[nPosiDet] + nValoR1
    aTo1Nat2[nPosiDet] := aTo1Nat2[nPosiDet] + nValoR2
    aTo1NatP[nPosiDet] := aTo1NatP[nPosiDet] + nValoTP
    aTo1NatO[nPosiDet] := aTo1NatO[nPosiDet] + nValoO
    aTo1NatT[nPosiDet] := aTo1NatT[nPosiDet] + nValoT

    If nImprQuiMe == 1
       @ nContLinha, aPosDet1[nPD] PSAY TransForm(nValoR1,"@E 999,999,999")+"|"
       nPD := nPD + 1
       @ nContLinha, aPosDet1[nPD] PSAY TransForm(nValoR2,"@E 999,999,999")+"|"
       nPD := nPD + 1
       @ nContLinha, aPosDet1[nPD] PSAY TransForm(nValoO,"@E 999,999,999")+"|"
       nPD := nPD + 1
       @ nContLinha, aPosDet1[nPD] PSAY TransForm(nValoT,"@E 999,999,999")+"|"
       nPD := nPD + 1
    Else
       @ nContLinha, aPosDet1[nPD] PSAY TransForm(nValoTP,"@E 999,999,999")+"|"
       nPD := nPD + 1
       @ nContLinha, aPosDet1[nPD] PSAY TransForm(nValoO,"@E 999,999,999")+"|"
       nPD := nPD + 1
       @ nContLinha, aPosDet1[nPD] PSAY TransForm(nValoT,"@E 999,999,999")+"|"
       nPD := nPD + 1
    EndIf
    nValoR1 := 0
    nValoR2 := 0
    nValoO  := 0
    nValoTP := 0
    nValoT  := 0
    nPosiDet := nPosiDet + 1
Next

aPosDet[03]  := aPosDet[03] + aPosDet[02]

nContLinha := nContLinha + 1
@ nContLinha, 000 PSAY cLinhaDet1
nContLinha := nContLinha + 1

Return



// Substituido pelo assistente de conversao do AP5 IDE em 25/06/01 ==> Function SubTotal
Static Function SubTotal()
*****************************************************************************
*  Imprime as Linhas de SubTotais
***

Local nD := 0

If (nContLinha > 59 )
   nLinha := 80
   AtuaInfo()
   ImprCabe()
EndIf

aPosStot[02] := Iif(nImprQuiMe == 1,                                                 ;
                   Iif((Len(aMeses)-aPosStot[03]) > 4, 4, (Len(aMeses)-aPosStot[03])),;
                   Iif((Len(aMeses)-aPosStot[03]) > 5, 5, (Len(aMeses)-aPosStot[03])))

nPosiStot    := Iif(aPosStot[03] == 0, 1, aPosStot[03] + 1 )
nPD         := 1

For nD := 1 To aPosStot[02]

    aTo2Nat1[nPosiStot] := aTo2Nat1[nPosiStot] + aTo1Nat1[nPosiStot]
    aTo2Nat2[nPosiStot] := aTo2Nat2[nPosiStot] + aTo1Nat2[nPosiStot]
    aTo2NatP[nPosiStot] := aTo2NatP[nPosiStot] + aTo1NatP[nPosiStot]
    aTo2NatO[nPosiStot] := aTo2NatO[nPosiStot] + aTo1NatO[nPosiStot]
    aTo2NatT[nPosiStot] := aTo2NatT[nPosiStot] + aTo1NatT[nPosiStot]

    If nD == 1
       @ nContLinha, 000 PSAY "|"
       @ nContLinha, aPosDet1[01] PSAY Left("   S U B T O T A L           ",nLefDesc) + "|"
       nPD := 2
    EndIf

    If nImprQuiMe == 1
       @ nContLinha, aPosDet1[nPD] PSAY TransForm(aTo1Nat1[nPosiStot],"@E 999,999,999")+"|"
       nValoR1 := 0
       nPD := nPD + 1
       @ nContLinha, aPosDet1[nPD] PSAY TransForm(aTo1Nat2[nPosiStot],"@E 999,999,999")+"|"
       nValoR2 := 0
       nPD := nPD + 1
       @ nContLinha, aPosDet1[nPD] PSAY TransForm(aTo1NatO[nPosiStot],"@E 999,999,999")+"|"
       nValoO := 0
       nPD := nPD + 1
       @ nContLinha, aPosDet1[nPD] PSAY TransForm(aTo1NatT[nPosiStot],"@E 999,999,999")+"|"
       nValoT := 0
       nPD := nPD + 1
    Else
       @ nContLinha, aPosDet1[nPD] PSAY TransForm(aTo1NatP[nPosiStot],"@E 999,999,999")+"|"
       nValoTP := 0
       nPD := nPD + 1
       @ nContLinha, aPosDet1[nPD] PSAY TransForm(aTo1NatO[nPosiStot],"@E 999,999,999")+"|"
       nValoO := 0
       nPD := nPD + 1
       @ nContLinha, aPosDet1[nPD] PSAY TransForm(aTo1NatT[nPosiStot],"@E 999,999,999")+"|"
       nValoO := 0
       nPD := nPD + 1
    EndIf
    aTo1Nat1[nPosiStot] := 0
    aTo1Nat2[nPosiStot] := 0
    aTo1NatP[nPosiStot] := 0
    aTo1NatO[nPosiStot] := 0
    aTo1NatT[nPosiStot] := 0
    nPosiStot := nPosiStot + 1
Next

aPosStot[03]   := aPosStot[03] + aPosStot[02]

nContLinha := nContLinha + 1
@ nContLinha, 000 PSAY cLinhaDet1
nContLinha := nContLinha + 1

If Len(aMeses) > 4
   If lPrVSub
      aPosStot[04] := aPosStot[01]
      aPosStot[05] := aPosStot[02]
      aPosStot[06] := aPosStot[03]
      lPrVSub    := .F.
   EndIf
   aPosStot[01] := aPosStot[07]
   aPosStot[02] := aPosStot[08]
   aPosStot[03] := aPosStot[09]
Else
   aPosStot[01] := 0
   aPosStot[02] := 0
   aPosStot[03] := 0
EndIf

Return



// Substituido pelo assistente de conversao do AP5 IDE em 25/06/01 ==> Function TotGer
Static Function TotGer()
*****************************************************************************
*  Imprime as Linhas de SubTotais
***

Local nD := 0

If (nContLinha > 59 )
   nLinha := 80
   AtuaInfo()
   ImprCabe()
EndIf

aPosTotG[02] := Iif(nImprQuiMe == 1,                                                 ;
                   Iif((Len(aMeses)-aPosTotG[03]) > 4, 4, (Len(aMeses)-aPosTotG[03])),;
                   Iif((Len(aMeses)-aPosTotG[03]) > 5, 5, (Len(aMeses)-aPosTotG[03])))

nPosiTotG    := Iif(aPosTotG[03] == 0, 1, aPosTotG[03] + 1)

nPD         := 1

For nD := 1 To aPosTotG[02]

    If nD == 1
       @ nContLinha, 000 PSAY "|"
       @ nContLinha, aPosDet1[01] PSAY Left("  T O T A L   G E R A L          ",nLefDesc) + "|"
       nPD := 2
    EndIf

    If nImprQuiMe == 1
       @ nContLinha, aPosDet1[nPD] PSAY TransForm(aTo2Nat1[nPosiTotG],"@E 999,999,999")+"|"
       nPD := nPD + 1
       @ nContLinha, aPosDet1[nPD] PSAY TransForm(aTo2Nat2[nPosiTotG],"@E 999,999,999")+"|"
       nPD := nPD + 1
       @ nContLinha, aPosDet1[nPD] PSAY TransForm(aTo2NatO[nPosiTotG],"@E 999,999,999")+"|"
       nPD := nPD + 1
       @ nContLinha, aPosDet1[nPD] PSAY TransForm(aTo2NatT[nPosiTotG],"@E 999,999,999")+"|"
       nPD := nPD + 1
    Else
       @ nContLinha, aPosDet1[nPD] PSAY TransForm(aTo2NatP[nPosiTotG],"@E 999,999,999")+"|"
       nPD := nPD + 1
       @ nContLinha, aPosDet1[nPD] PSAY TransForm(aTo2NatO[nPosiTotG],"@E 999,999,999")+"|"
       nPD := nPD + 1
       @ nContLinha, aPosDet1[nPD] PSAY TransForm(aTo2NatT[nPosiTotG],"@E 999,999,999")+"|"
       nPD := nPD + 1
    EndIf
    aTo2Nat1[nPosiTotG] := 0
    aTo2Nat2[nPosiTotG] := 0
    aTo2NatP[nPosiTotG] := 0
    aTo2NatO[nPosiTotG] := 0
    aTo2NatT[nPosiTotG] := 0
    nPosiTotG := nPosiTotG + 1
Next

aPosTotG[03]   := aPosTotG[03] + aPosTotG[02]

nContLinha := nContLinha + 1
@ nContLinha, 000 PSAY cLinhaDet1
nContLinha := nContLinha + 1

If Len(aMeses) < 4
   aPosTotG[01] := 0
   aPosTotG[02] := 0
   aPosTotG[03] := 0
EndIf

nContLinha := 80

Return



// Substituido pelo assistente de conversao do AP5 IDE em 25/06/01 ==> Function AtuaInfo
Static Function AtuaInfo()
*****************************************************************************
*  Atualiza as Informacoes antes de Imprimir um Cabec
***

If nImprQuiMe == 1
   If aPosMes[01] == 0
      nNumColu := 3
   Else
      nNumColu := Len(aMeses) - aPosMes[01]
      If nNumColu > 3
         nNumColu := 3
      EndIf
   EndIf
Else
   If aPosMes[01] == 0
      nNumColu := 4
   Else
      nNumColu := Len(aMeses) - aPosMes[01]
      If nNumColu > 4
         nNumColu := 4
      EndIf
   EndIf
EndIf

Return




