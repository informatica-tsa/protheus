#include "rwmake.ch"        // incluido pelo assistente de conversao do AP5 IDE em 25/06/01

//Alterado: 24/10/2001
//Desenvolvimento NF de Entrada NFEPCF

User Function NFEPCF()        // incluido pelo assistente de conversao do AP5 IDE em 25/06/01

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Declaracao de variaveis utilizadas no programa atraves da funcao    ³
//³ SetPrvt, que criara somente as variaveis definidas pelo usuario,    ³
//³ identificando as variaveis publicas do sistema utilizadas no codigo ³
//³ Incluido pelo assistente de conversao do AP5 IDE                    ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

SetPrvt("CPERG,APERG,TAMANHO,LIMITE,NOMEPROG,NLASTKEY")
SetPrvt("NCONTLINH,CSTRING,WNREL,TITULO,CDESC1,CDESC2")
SetPrvt("CDESC3,ARETURN,CNOTAINIC,CNOTAFINA,CSERINTFI,NTIPONTFI")
SetPrvt("NBASEICMS,NVALRFRET,NVALRSEGU,NVALRICMS,NVALRDESP,NVALRII")
SetPrvt("CCABECALHO,CMSGREGUA,ATEMPSTRU,CARQTRAB1,CARQTRAB2,CARQTRAB3")
SetPrvt("LFIRST,NPOSISTR,NPERCICMS,CCODIPEDI,CCODITES,CCODIFIOP")
SetPrvt("CSERIFATU,NCONTITEM,NTOTAITEM,CVALREXTEN,NCONTLIN,NVALORTRAN")
SetPrvt("NCONTPAG,CNOMECLFO,CCGCCLIFO,CTELECLFO,CENDECLFO,CBAIRCLFO")
SetPrvt("CCEPCLIFO,CMUNICLFO,CESTACLFO,CINSCCLFO,NTAMEXTE,CVLREXAUX1")
SetPrvt("CVLREXAUX2,NPOVAZ,NPOFIN,LTEST,NCONTLAUX,NCONT")
SetPrvt("LCONTITEM,NLINDESC,NCURLDES,CMENS1,CMENS2,NXT")
SetPrvt("NMENINIC,NIX,NPOS,NLINCLAS,NMENINI2,NXI,CNUMEPC,CITEMLM")


/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³  NFEPCF  ³ Autor ³Ederson Dilney Colen M.³ Data ³18/10/2000³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Nota Fiscal de Entrada/Saida                               ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Especifico para Clientes Microsiga                         ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Define Variaveis Ambientais                                  ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Variaveis utilizadas para parametros                         ³
//³ mv_par01             // Da Nota Fiscal                       ³
//³ mv_par02             // Ate a Nota Fiscal                    ³
//³ mv_par03             // Da Serie                             ³
//³ mv_par04             // Nota Fiscal de Entrada/Saida         ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
cPerg      := "NFEPCF"
aPerg      := {}
AADD(aPerg,{cPerg,"Da Nota Fiscal     ?","C",06,0,"G","","","","","","",""})
AADD(aPerg,{cPerg,"Ate a Nota Fiscal  ?","C",06,0,"G","","","","","","",""})
AADD(aPerg,{cPerg,"Da Serie           ?","C",03,0,"G","","","","","","",""})
AADD(aPerg,{cPerg,"Tipo de Movimento  ?","N",01,0,"C","","","NF.Entrada","NF.Saida","","",""})

Pergunte(cPerg,.F.)               // Pergunta no SX1

Tamanho    := "M"
Limite     := 132
NomeProg   := "NFEPCF"
nLastKey   := 0
nContLinh  := 0

cString    := "SF2"
wnrel      := "NFEPCF"
cPerg      := "NFEPCF"
Titulo     := PADC("Nota Fiscal - NFEPCF",74)
cDesc1     := PADC("Este programa ira emitir a Nota Fiscal de Entrada/Saida",74)
cDesc2     := ""
cDesc3     := PADC("da Nfiscal",74)
aReturn    := { "Especial", 1,"Administracao", 1, 2, 1,"",1 }
wnrel      := SetPrint(cString,wnrel,cPerg,Titulo,cDesc1,cDesc2,cDesc3,.T.)

If (nLastKey == 27)
  Return
Endif

SetDefault(aReturn,cString)

cNotaInic := Mv_Par01
cNotaFina := Mv_Par02
cSeriNtFi := Mv_Par03
nTipoNtFi := Mv_Par04

nBaseICMS  := 0
nValrFret  := 0
nValrSegu  := 0
nValrICMS  := 0
nValrDesp  := 0
nValrII    := 0

If (nLastKey == 27)
   Return
Endif

FCriaTrab()

cCabecalho := "Gravacao do Arquivo de Trabalho"
cMsgRegua  := "Processando "
Processa( {|| GravTrab()} ,cCabecalho,cMsgRegua )// Substituido pelo assistente de conversao do AP5 IDE em 25/06/01 ==> Processa( {|| Execute(GravTrab)} ,cCabecalho,cMsgRegua )

RptStatus({|| Imprime()})// Substituido pelo assistente de conversao do AP5 IDE em 25/06/01 ==>    RptStatus({|| Execute(Imprime)})

dbSelectArea("SF2")
Retindex("SF2")
dbSelectArea("SF1")
Retindex("SF1")
dbSelectArea("SD2")
Retindex("SD2")
dbSelectArea("SD1")
Retindex("SD1")

dbSelectArea("TRBI")
dbCloseArea()

dbSelectArea("TRBC")
dbCloseArea()

dbSelectArea("TRBF")
dbCloseArea()


FErase(cArqTrab1 + ".DBF")
FErase(cArqTrab1 + ".NTX")
FErase(cArqTrab2 + ".DBF")
FErase(cArqTrab2 + ".NTX")
FErase(cArqTrab3 + ".DBF")
FErase(cArqTrab3 + ".NTX")

SetPgEject(.f.)
Set Device To Screen

If aReturn[5] == 1
   Set Printer TO
   dbcommitAll()
   ourspool(wnrel)
Endif

MS_FLUSH()

Return



// Substituido pelo assistente de conversao do AP5 IDE em 25/06/01 ==> Function CriaTrab
Static Function FCriaTrab()
****************************************************************************
* Cria os arquivos de trabalho
*
******

aTempStru := {}

Aadd(aTempStru,{"NumeNtFi","C",06,0})
Aadd(aTempStru,{"SeriNtFi","C",03,0})
Aadd(aTempStru,{"CodiProd","C",15,0})
Aadd(aTempStru,{"DescProd","M",10,0})
Aadd(aTempStru,{"ClasFisc","C",02,0})
Aadd(aTempStru,{"SituTrib","C",03,0})
Aadd(aTempStru,{"CodiUnid","C",02,0})
Aadd(aTempStru,{"QtdeProd","N",9,3})
Aadd(aTempStru,{"ValrUnit","N",12,3})
Aadd(aTempStru,{"ValrTota","N",11,2})
Aadd(aTempStru,{"PercICMS","N",02,0})
Aadd(aTempStru,{"PercICMR","N",02,0})
Aadd(aTempStru,{"PercIPI" ,"N",02,0})
Aadd(aTempStru,{"ValrIPI" ,"N",11,2})
Aadd(aTempStru,{"CodiTes" ,"C",03,0})
Aadd(aTempStru,{"CodiFiOP","C",04,0})
Aadd(aTempStru,{"TotalPro","N",14,2})
Aadd(aTempStru,{"Tipo"    ,"C",02,0})
Aadd(aTempStru,{"ItemNF"  ,"C",02,0})
Aadd(aTempStru,{"ItemLM"  ,"C",04,0})  // Adicionado Davis - 02/06/03 - Para Imprimir Item LM

cArqTrab1 := CriaTrab(aTempStru,.T.)

dbUseArea( .T.,, cArqTrab1, "TRBI",.F.,.F.)
IndRegua("TRBI",cArqTrab1,"NumeNtFi+SeriNtFi+CodiProd+CodiFiOP",,,"Selecionando Registros...")


aTempStru := {}

Aadd(aTempStru,{"NumeNtFi","C",06,0})
Aadd(aTempStru,{"SeriNtFi","C",03,0})
Aadd(aTempStru,{"CodiTes" ,"C",03,0})
Aadd(aTempStru,{"CodiFiOP","C",04,0})
Aadd(aTempStru,{"DataEmis","D",08,0})
Aadd(aTempStru,{"ValrNota","N",11,2})
Aadd(aTempStru,{"TipoClFo","C",01,0})
Aadd(aTempStru,{"CodiClFo","C",06,0})
Aadd(aTempStru,{"LojaClFo","C",02,0})
Aadd(aTempStru,{"CodiPedi","C",06,0})
Aadd(aTempStru,{"CodiTran","C",06,0})
Aadd(aTempStru,{"ValrSegu","N",11,2})
Aadd(aTempStru,{"ValrDesp","N",11,2})
Aadd(aTempStru,{"ValrFret","N",11,2})
Aadd(aTempStru,{"ValrII  ","N",11,2})
Aadd(aTempStru,{"BCalICMS","N",11,2})
Aadd(aTempStru,{"BCalIPI" ,"N",11,2})
Aadd(aTempStru,{"ValrICMS","N",11,2})
Aadd(aTempStru,{"ValrICMR","N",11,2})
Aadd(aTempStru,{"ValrIPI" ,"N",11,2})
Aadd(aTempStru,{"ValrMerc","N",11,2})
Aadd(aTempStru,{"NumeDupl","C",06,0})
Aadd(aTempStru,{"CondPaga","C",03,0})
Aadd(aTempStru,{"PesoBrut","N",09,2})
Aadd(aTempStru,{"PesoLiqu","N",09,2})
Aadd(aTempStru,{"TipoClie","C",01,0})
Aadd(aTempStru,{"TipoEspe","C",10,0})
Aadd(aTempStru,{"QtdeVolu","N",05,0})
Aadd(aTempStru,{"Tipo"    ,"C",01,0})
Aadd(aTempStru,{"Especie" ,"C",05,0})
Aadd(aTempStru,{"NumEpc"  ,"C",04,0})

cArqTrab2 := CriaTrab(aTempStru,.T.)

dbUseArea( .T.,, cArqTrab2, "TRBC",.F.,.F.)
IndRegua("TRBC",cArqTrab2,"NumeNtFi+SeriNtFi",,,"Selecionando Registros...")

aTempStru := {}

Aadd(aTempStru,{"NumeNtFi","C",06,0})
Aadd(aTempStru,{"SeriNtFi","C",03,0})
Aadd(aTempStru,{"NumeDupl","C",06,0})
Aadd(aTempStru,{"NumeParc","C",01,0})
Aadd(aTempStru,{"DataVenc","D",08,0})
Aadd(aTempStru,{"ValrDupl","N",17,2})

cArqTrab3 := CriaTrab(aTempStru,.T.)

dbUseArea( .T.,, cArqTrab3, "TRBF",.F.,.F.)
IndRegua("TRBF",cArqTrab3,"NumeNtFi+SeriNtFi+NumeParc",,,"Selecionando Registros...")

Return



// Substituido pelo assistente de conversao do AP5 IDE em 25/06/01 ==> Function GravTrab
Static Function GravTrab()
*****************************************************************************
* Grava os dados no arquivo de trabalho
*
***

If (nTipoNtFi == 2)
   dbSelectArea("SF2")
   dbSetOrder(1)
   Set SoftSeek On
   dbSeek(xFilial("SF2")+cNotaInic)
   Set SoftSeek Off

   ProcRegua(RecCount())

   While (! Eof())                          .And. ;
         (SF2->F2_Filial == xFilial("SF2")) .And. ;
         (SF2->F2_Doc    <= cNotaFina)

      If (SF2->F2_Serie <> cSeriNtFi)
         dbSelectArea("SF2")
         dbSkip()
         Loop
      Endif

      lFirst    := .T.

      dbSelectArea("SA1")
      dbSeek(xFilial("SA1")+SF2->F2_Cliente+SF2->F2_Loja)

      nPosiStr  := AT(SA1->A1_Est,GetMV("MV_ESTICM"))
      nPercICMS := Val(SubStr(GetMV("MV_ESTICM"),nPosiStr+2,2))

      IncProc("Processando a Nota Fiscal " + SF2->F2_DOC)

      dbSelectArea("SD2")
      dbSetOrder(3)
      dbSeek(xFilial("SD2")+SF2->F2_Doc+SF2->F2_Serie)

      While (! Eof())                          .And. ;
            (SD2->D2_Filial == xFilial("SD2")) .And. ;
            (SD2->D2_Doc    == SF2->F2_Doc)    .And. ;
            (SD2->D2_Serie  == SF2->F2_Serie)
         // Adicionado Davis - Para Verificar Se Exite o Numero de Item da LM.
         dbSelectArea("SC6")
         dbSetOrder(1)
         If dbSeek(xFilial("SC6")+SD2->D2_Pedido+SD2->D2_ItemPV)
            cItemLm := SC6->C6_ITEMLM
         Else
            cItemLm := ""
         EndIf
     
         dbSelectArea("SF4")
         dbSetOrder(1)
         dbSeek(xFilial("SF4")+SD2->D2_TES)

         dbSelectArea("SB1")
         dbSetOrder(1)
         dbSeek(xFilial("SB1")+SD2->D2_Cod)

         dbSelectArea("TRBI")
         dbSetOrder(1)
         dbSeek(SF2->F2_Doc+SF2->F2_Serie+SD2->D2_Cod+SD2->D2_CF)

         If Eof()
            RecLock("TRBI",.T.)
            Replace  NumeNtFi  With  SD2->D2_Doc
            Replace  SeriNtFi  With  SD2->D2_Serie
            Replace  CodiProd  With  SD2->D2_Cod
//            Replace  DescProd  With  SB1->B1_DESCDET
	         If SD2->D2_TES =="569" 
            	Replace  DescProd  With  SB1->B1_DESC + SB1->B1_DESC2 + SB1->B1_DESC3 + SB1->B1_DESC4
            Else
               If SF2->F2_TIPO $ "B/D" //Se for do tipo "B" - NF Utiliza fornecedor
             	   Replace  DescProd  With  SC6->C6_DESCRI 
               Else
                   Replace  DescProd  With  Alltrim(SB1->B1_DESC)
               EndIf
            EndIf
            
            Replace  ClasFisc  With  SB1->B1_ClasFis
            Replace  SituTrib  With  SubStr(SB1->B1_ORIGEM,1,1)+SF4->F4_SITTRIB
            Replace  CodiUnid  With  SB1->B1_UM
            Replace  PercICMS  With  SD2->D2_PICM
            Replace  PercICMR  With  SB1->B1_PICMRet
            Replace  PercIPI   With  SD2->D2_IPI
            Replace  ValrIPI   With  SD2->D2_ValIPI
            Replace  CodiTes   With  SD2->D2_TES
            Replace  CodiFiOP  With  SD2->D2_CF
            Replace  Tipo      With  SB1->B1_Tipo
            Replace  QtdeProd  With  SD2->D2_Quant
            Replace  ValrUnit  With  Iif(SF2->F2_TIPO == "I",0,SD2->D2_PrcVen)
            Replace  ValrTota  With  Iif(SF2->F2_TIPO == "I",0,SD2->D2_Total)
            Replace  ItemLM    With  cItemLM  // Davis - Gravacao do Item da LM
         Else
            RecLock("TRBI",.F.)
            //Acrescentado o teste para verificar se a unidade de medida do produto é igual a VB (Verba)
            //se for, nao devera somar a quantidade do produto, mas deve somar o valor unitario e o valor total.
            Replace  QtdeProd  With  Iif(SF2->F2_TIPO == "I",0,Iif(!(SB1->B1_UM$"VB"),TRBI->QtdeProd + SD2->D2_Quant,TRBI->QtdeProd + 0))
            Replace  ValrUnit  With  Iif(!(SB1->B1_UM$"VB") ,TRBI->ValrUnit + 0, TRBI->ValrUnit + SD2->D2_PrcVen)                      
            Replace  ValrTota  With  Iif(SF2->F2_TIPO == "I",0,TRBI->ValrTota + SD2->D2_Total)
         EndIf

         MsUnlock()

         cCodiPedi :=  SD2->D2_Pedido

         If (lFirst)
            cCodiTes  :=  SD2->D2_TES
            cCodiFiOP :=  SD2->D2_CF
            lFirst    := .F.
         EndIf

         dbSelectArea("SD2")
         dbskip()
      EndDo

      cSeriFatu := SF2->F2_Serie

      dbSelectArea("SE1")
      dbSetOrder(1)
      dbSeek(xFilial("SE1")+cSeriFatu+SF2->F2_Dupl)

      While (! Eof())                           .And. ;
            (SE1->E1_Filial  == xFilial("SE1")) .And. ;
            (SE1->E1_Prefixo == cSeriFatu)      .And. ;
            (SE1->E1_Num     == SF2->F2_Dupl)

         If (! ("NF" $ SE1->E1_Tipo))
            dbSelectArea("SE1")
            dbSkip()
            Loop
         Endif

         dbSelectArea("TRBF")
         RecLock("TRBF",.T.)

         Replace  NumeNtFi  With  SF2->F2_Doc
         Replace  SeriNtFi  With  SF2->F2_Serie
         Replace  NumeDupl  With  SF2->F2_Dupl
         Replace  NumeParc  With  SE1->E1_Parcela
         Replace  DataVenc  With  SE1->E1_Vencto
//         Replace  ValrDupl  With  SE1->E1_Valor
         Replace  ValrDupl  With  SE1->E1_Saldo

         MsUnlock()

         dbSelectArea("SE1")
         dbSkip()
      EndDo


      dbSelectArea("TRBC")
      RecLock("TRBC",.T.)

      Replace  NumeNtFi  With   SF2->F2_Doc
      Replace  SeriNtFi  With   SF2->F2_Serie
      Replace  CodiTes   With   cCodiTes
      Replace  CodiFiOP  With   cCodiFiOP
      Replace  DataEmis  With   SF2->F2_Emissao
      Replace  ValrNota  With   Iif(SF2->F2_TIPO == "I",0, ;
                                    SF2->F2_ValMerc ;
                                  + SF2->F2_ValIPI  ;
                                  + SF2->F2_Seguro  ;
                                  + SF2->F2_Frete)
      Replace  CodiClFo  With   SF2->F2_Cliente
      Replace  LojaClFo  With   SF2->F2_Loja
      Replace  CodiTran  With   SF2->F2_Transp
      Replace  CodiPedi  With   cCodiPedi
      Replace  ValrFret  With   SF2->F2_Frete
      Replace  ValrSegu  With   SF2->F2_Seguro
      Replace  BCalICMS  With   SF2->F2_BaseICMS
      Replace  BCalIPI   With   SF2->F2_BaseIPI
      Replace  ValrICMS  With   SF2->F2_ValICM
      Replace  ValrICMR  With   SF2->F2_ICMSRet
      Replace  ValrIPI   With   SF2->F2_ValIPI
      Replace  ValrMerc  With   Iif(SF2->F2_TIPO == "I",0,SF2->F2_ValMerc)
      Replace  NumeDupl  With   SF2->F2_Dupl
      Replace  CondPaga  With   SF2->F2_Cond
      Replace  PesoBrut  With   SF2->F2_PBruto
      Replace  PesoLiqu  With   SF2->F2_PLiqui
      Replace  TipoEspe  With   SF2->F2_Especi1
      Replace  QtdeVolu  With   SF2->F2_Volume1

      If (SF2->F2_Tipo $ "N/C/P/I/S/T/O")
         Replace  TipoClFo  With  "C"
      Else
         Replace  TipoClFo  With  "F"
      EndIf

      MsUnlock()

      dbSelectArea("SF2")
      dbSkip()
   EndDo
Else
   dbSelectArea("SF1")
   dbSetOrder(1)
   Set SoftSeek On
   dbSeek(xFilial("SF1")+cNotaInic)
   Set SoftSeek Off

   ProcRegua(RecCount())

   While (! Eof())                          .And. ;
         (SF1->F1_Filial == xFilial("SF1")) .And. ;
         (SF1->F1_Doc    <= cNotaFina)

      If (SF1->F1_Serie <> cSeriNtfi)
         dbSelectArea("SF1")
         dbSkip()
         Loop
      Endif

      IncProc("Processando a Nota Fiscal " + SF1->F1_DOC)

      dbSelectArea("SD1")
      dbSetOrder(1)
      dbSeek(xFilial("SD1")+SF1->F1_Doc+SF1->F1_Serie+SF1->F1_Fornece+SF1->F1_Loja)

      While (! Eof())                            .And. ;
            (SD1->D1_Filial  == xFilial("SD1"))  .And. ;
            (SD1->D1_Doc     == SF1->F1_Doc)     .And. ;
            (SD1->D1_Serie   == SF1->F1_Serie)   .And. ;
            (SD1->D1_Fornece == SF1->F1_Fornece) .And. ;
            (SD1->D1_Loja    == SF1->F1_Loja)

			dbSelectArea("SF4")
         dbSetOrder(1)
         dbSeek(xFilial("SF4")+SD1->D1_TES)         
                 
         dbSelectArea("SB1")
         dbSetOrder(1)
         dbSeek(xFilial("SB1")+SD1->D1_Cod)

         dbSelectArea("TRBI")
         dbSetOrder(1)
         dbSeek(SF1->F1_Doc+SF1->F1_Serie+SD1->D1_Cod)

         If Eof()
            RecLock("TRBI",.T.)
            Replace  NumeNtFi  With  SD1->D1_Doc
            Replace  SeriNtFi  With  SD1->D1_Serie
            Replace  CodiProd  With  SD1->D1_Cod
//            Replace  DescProd  With  SB1->B1_DESCDET
//            Replace  DescProd  With  SB1->B1_DESC + SB1->B1_DESC2 + SB1->B1_DESC3 + SB1->B1_DESC4


* Alteração efetuada em 22/10/02 a pedido da Sra. Estela para imprimir as descrições 
* pegando no cadastro de produtos.
* Sebastião Oliveira
  
            IF (SUBSTR(SD1->D1_COD,1,2)="IM")
               Replace  DescProd  With AllTrim(SB1->B1_DESC) + AllTrim(SB1->B1_DESC2) + AllTrim(SB1->B1_DESC3) + AllTrim(SB1->B1_DESC4)
            ELSE
                Replace  DescProd  With  AllTrim(SD1->D1_DESCRIC)
            ENDIF
//            Replace  DescProd  With  SD1->D1_DESCRIC
            Replace  ClasFisc  With  SB1->B1_CLASFIS
            Replace  SituTrib  With  Substr(SB1->B1_ORIGEM,1,1)+SF4->F4_SITTRIB
            Replace  CodiUnid  With  SB1->B1_UM
            Replace  PercICMS  With  SD1->D1_PICM
            Replace  PercIPI   With  SD1->D1_IPI
            Replace  ValrIPI   With  SD1->D1_ValIPI
            Replace  CodiTes   With  SD1->D1_TES
            Replace  CodiFiOP  With  SD1->D1_CF
//            Replace  TotalPro  With  SD1->D1_TOTPRO
            Replace  QtdeProd  With  SD1->D1_Quant
            Replace  ValrUnit  With  SD1->D1_VUnit
            Replace  ValrTota  With  SD1->D1_Total
         Else
            RecLock("TRBI",.F.)
            Replace  QtdeProd  With  TRBI->QtdeProd + SD1->D1_Quant
            Replace  ValrTota  With  TRBI->ValrTota + SD1->D1_Total
         EndIf
         Replace  ItemNF    With   Iif(Empty(SD1->D1_ItemPC),SD1->D1_Item,SD1->D1_ItemPC)

         MsUnlock()

//         If SD1->D1_BasICM2 > 0.00
//             nBaseICMS := nBaseICMS + SD1->D1_BasICM2
//         Else
         nBaseICMS := nBaseICMS + SD1->D1_BaseICM
//         EndIf

         nValrICMS := nValrICMS + SD1->D1_ValICM
//       nValrFret := nValrFret + SD1->D1_Frete
//       nValrSegu := nValrSegu + SD1->D1_Seguro
//       nValrDesp := nValrDesp + SD1->D1_Despesa
//         nValrII   := nValrII   + SD1->D1_ValII

         cCodiPedi :=  SD1->D1_Pedido
         cCodiTes  :=  SD1->D1_TES
         cCodiFiOP :=  SD1->D1_CF

         dbSelectArea("SD1")
         dbskip()
      EndDo
/* Nao tem Financeiro segundo usuaria Lúcia.
      dbSelectArea("SE1")
      dbSetOrder(1)
      dbSeek(xFilial("SE1")+SF1->F1_Serie+SF1->F1_Dupl)

      While (! Eof()) .And. ;
            (SE1->E1_Filial  == xFilial("SE1")) .And. ;
            (SE1->E1_Prefixo == SF1->F1_Serie)  .And. ;
            (SE1->E1_Num     == SF1->F1_Dupl)

         If (! ("NF" $ SE1->E1_Tipo))

            dbSelectArea("SE1")
            dbSkip()
            Loop
         Endif

         dbSelectArea("TRBF")
         RecLock("TRBF",.T.)

         Replace  NumeNtFi  With  SF1->F1_Doc
         Replace  SeriNtFi  With  SF1->F1_Serie
         Replace  NumeDupl  With  SF1->F1_Dupl
         Replace  NumeParc  With  SE1->E1_Parcela
         Replace  DataVenc  With  SE1->E1_Vencto
         Replace  ValrDupl  With  SE1->E1_Valor

         MsUnlock()

         dbSelectArea("SE1")
         dbSkip()
      EndDo
*/
      dbSelectArea("TRBC")
      RecLock("TRBC",.T.)
      Replace  NumeNtFi  With   SF1->F1_Doc
      Replace  SeriNtFi  With   SF1->F1_Serie
      Replace  CodiTes   With   cCodiTes
      Replace  CodiFiOP  With   cCodiFiOP
      Replace  DataEmis  With   SF1->F1_Emissao
      Replace  ValrNota  With   Iif(SF1->F1_TIPO == "I",0,SF1->F1_ValBrut)
      Replace  CodiClFo  With   SF1->F1_Fornece
      Replace  LojaClFo  With   SF1->F1_Loja
      Replace  CodiTran  With   ""
      Replace  CodiPedi  With   cCodiPedi
      Replace  ValrSegu  With   nValrSegu
      Replace  ValrFret  With   nValrFret
      Replace  BCalICMS  With   nBaseICMS
      Replace  ValrICMS  With   nValrICMS
      Replace  ValrDesp  With   nValrDesp
      Replace  ValrII    With   nValrII
      Replace  ValrICMR  With   0
      Replace  BCalIPI   With   SF1->F1_BaseIPI
      Replace  ValrIPI   With   SF1->F1_ValIPI
      Replace  ValrMerc  With   Iif(SF1->F1_TIPO == "I",0,SF1->F1_ValMerc)
      Replace  NumeDupl  With   SF1->F1_Dupl
      Replace  CondPaga  With   SF1->F1_Cond
      Replace  Especie   With   SF1->F1_Especie
      Replace  PesoBrut  With   SF1->F1_PESBRUT
      Replace  PesoLiqu  With   SF1->F1_PESLIQU
      Replace  TipoEspe  With   ""
      Replace  QtdeVolu  With   SF1->F1_QTDEVOL
      
      If (SF1->F1_Tipo == "D")
         Replace  TipoClFo  With  "C"
      Else
         Replace  TipoClFo  With  "F"
      EndIf

      MsUnlock()

      nBaseICMS := 0
      nValrICMS := 0
      nValrFret := 0
      nValrSegu := 0
      nValrDesp := 0
      nValrII   := 0

      dbSelectArea("SF1")
      dbSkip()
   EndDo
Endif

Return



// Substituido pelo assistente de conversao do AP5 IDE em 25/06/01 ==> Function Imprime
Static Function Imprime()
*****************************************************************************
* Imprime a Nota Fiscal de Entrada e de Saida
*
***

Private lFirstItm := .T.

dbSelectArea("TRBC")
dbGoTop()

While (! Eof())

   nContItem  := 0   // Conta o Numero de Itens
   nTotaItem  := 25  // Numero maximo de itens
   cValrExten := ""  // Para quebra do valor por extenso.
   nContLin   := 0
   nValorTran := 0   // Valor para o Transporte de nota.
   nContPag   := 1
   lFirstItm := .T.

   ImprCabe()

   nContLinh := 23

   dbSelectArea("TRBI")
   dbSeek(TRBC->NumeNtFi+TRBC->SeriNtFi)

   While (! Eof())                          .And. ;
         (TRBI->NumeNtFi == TRBC->NumeNtFi) .And. ;
         (TRBI->SeriNtFi == TRBC->SeriNtFi)

      ImprItem()

      nContItem := nContItem + 1

      dbSelectArea("TRBI")
      dbSkip()
   End

   ImprRoda()

   nValorTran := 0
   nContPag   := 1

   dbSelectArea("TRBC")
   dbSkip()

EndDo

Return



// Substituido pelo assistente de conversao do AP5 IDE em 25/06/01 ==> Function ImprCabe
Static Function ImprCabe()
*****************************************************************************
* Imprime a Nota Fiscal de Entrada e de Saida (Cabecalho)
*
***

Local lFirst := .T.
//??? @ 00, 000 PSAY Chr(27) + "C" + Chr(88)

@ 01, 000 PSAY Chr(15)
@ 01, 130 PSAY TRBC->NumeNtFi

dbSelectArea("SF4")
dbSeek(xFilial("SF4")+TRBC->CodiTes)

dbSelectArea("SX5")
dbSeek(xFilial("SX5")+"13"+SF4->F4_CF)


If (nTipoNtFi == 1)
   @ 02, 100 PSAY "X"
Else
   @ 02, 093 PSAY "X"
Endif

@ 04, 110 PSAY "No.Pag: " + StrZero(nContPag,3)
nContPag := nContPag + 1

/* ALTERACAO FEITA POR POLYANA NO DIA 05/02/01 DEVIDO A SOLICITACAO DA ESTELA PARA
    IMPRIMIR A DESCRICAO DA TES E NAO A DO CFO
@ 009, 011 PSAY Left(SX5->X5_Descri,37)      */
@ 008, 001 PSAY Left(SF4->F4_Texto,37)

@ 008, 048 PSAY TRBC->CodiFiOP    Picture "@R 9.999"

If (TRBC->TipoClFo == "C")
   dbSelectArea("SA1")
   dbSeek(xFilial("SA1")+TRBC->CodiClFo+TRBC->LojaClFo)

   cNomeClfo := AllTrim(SA1->A1_Nome)
   cCGCCliFo := SA1->A1_CGC
   cTeleClFo := SA1->A1_Tel
   cEndeClFo := SA1->A1_End
   cBairClFo := Left(SA1->A1_Bairro,25)
   cCEPCliFo := SA1->A1_CEP
//   cMuniClFo := Alltrim(SA1->A1_Mun)+" - "+SA1->A1_DescMun
   cMuniClFo := Alltrim(SA1->A1_MUNISS)+" - "+SA1->A1_DescMun
   cEstaClFo := SA1->A1_Est
   cInscClFo := SA1->A1_InscR
Else
   dbSelectArea("SA2")
   dbSeek(xFilial("SA2")+TRBC->CodiClFo+TRBC->LojaClFo)

   cNomeClfo := AllTrim(SA2->A2_Nome)
   cCGCCliFo := SA2->A2_CGC
   cTeleClFo := SA2->A2_Tel
   cEndeClFo := SA2->A2_End

   cBairClFo := Left(SA2->A2_Bairro,25)
   cCEPCliFo := SA2->A2_CEP
   cMuniClFo := SA2->A2_Mun
   cEstaClFo := SA2->A2_Est
   cInscClFo := SA2->A2_InscR
EndIf

@ 11, 001 PSAY Left(cNomeClFo,80)
@ 11, 090 PSAY cCGCCliFo        Picture "@R 99.999.999/9999-99"
@ 11, 123 PSAY TRBC->DataEmis

@ 13, 001 PSAY cEndeClFo
@ 13, 075 PSAY cBairClFo
@ 13, 107 PSAY cCEPCliFo        Picture "@R 99999-999"
// @ 14, 131 PSAY TRBC->DataEmis  // Data da Saida

@ 15, 001 PSAY cMuniClFo
@ 15, 060 PSAY cTeleClFo
@ 15, 084 PSAY cEstaClFo
@ 15, 092 PSAY cInscClFo

If (nTipoNtFi == 2)
   dbSelectArea("TRBF")
   dbSeek(TRBC->NumeNtFi+TRBC->SeriNtFi)

	If ! Eof()

   	nTamExte   := Len(Extenso(TRBC->ValrNota))
	   cValrExten := Extenso(TRBC->ValrNota)
	   cVlrExAux1 := ""
	   cVlrExAux2 := ""

   	If (nTamExte > 65)
	      nPoVaz := 0
   	   nPoFin := 0
      	lTest := .T.
	      While nPoFin <= 64 .And. lTest
   	      nPoFin := nPoVaz + nPoFin
      	   nPoVaz := At(" ",SubStr(cValrExten,nPoFin))
	         If nPoVaz == 0
   	         lTest := .F.
      	   EndIf
	      EndDo
   	   cVlrExAux1 := SubStr(cValrExten,1,(nPoFin - 1))
      	cVlrExAux2 := SubStr(cValrExten,(nPoFin))  + " " + Replicate("*", 64 - (nTamExte - 64))
	   Else
   	   cVlrExAux1 := cValrExten + " " + Replicate("*", 64 - nTamExte)
      	cVlrExAux2 := Replicate("*",65)
	   EndIf

	   If Len(Alltrim(cVlrExAux1)) < 65
   	   cVlrExAux1 := AllTrim(cVlrExAux1) + " " + Replicate("*", 68 - Len(Alltrim(cVlrExAux1)))
	   EndIf

	   nContLAux := 18
      nCont := 1
              
       While ! Eof()                          .And. ;
   	         TRBC->NumeDupl == TRBF->NumeDupl .And. ;
             nCont < 4

          Do Case
             Case nCont == 1
                  @ nContLAux, 015 PSAY cVlrExAux1
	         Case nCont == 2
   	              @ nContLAux, 015 PSAY cVlrExAux2
          EndCase
      
          //CRISLEI TOLEDO - 10/05/06
          //TESTA COND. DE PAGAMENTO: SE FOR CONTRA APRESENTACAO, GERA TITULO NO FINANCEIRO COM VENCIMENTO A VISTA, POREM NÃO
          //IMPRIME DUPLICATAS NA NF. O CORPO DA NF CONTERA ORIENTACOES SOBRE O RECEBIMENTO DA NF.
          dbSelectArea("SC5")
	      dbSetOrder(1)
          dbSeek(xFilial("SC5")+TRBC->CodiPedi)

          If !(SC5->C5_CONDPAG $ GetMv("MV_IMPDUPL"))
             If SC5->C5_CONDPAG $ GetMv("MV_CONDESP")             
                @ nContLAux, 090 PSAY TRBF->NumeDupl+"/"+TRBF->NumeParc
                @ nContLAux, 106 PSAY AllTrim(SC5->C5_TXTVCTO)
                @ nContLAux, 120 PSAY TRBF->ValrDupl    Picture    "@RE 999,999,999.99"
             Else
                @ nContLAux, 090 PSAY TRBF->NumeDupl+"/"+TRBF->NumeParc
                @ nContLAux, 106 PSAY TRBF->DataVenc
                @ nContLAux, 120 PSAY TRBF->ValrDupl    Picture    "@RE 999,999,999.99"
             EndIf
          Else
             If lFirst
                @ nContLAux, 090 PSAY TRBF->NumeDupl+"/"+TRBF->NumeParc
                @ nContLAux, 106 PSAY TRBF->DataVenc
                @ nContLAux, 120 PSAY TRBF->ValrDupl    Picture    "@RE 999,999,999.99"
                lFirst := .F.                                                
             Else
                @ nContLAux, 090 PSAY TRBF->NumeDupl+"/"+TRBF->NumeParc
                @ nContLAux, 106 PSAY OemToAnsi(" * Evento")
                @ nContLAux, 120 PSAY TRBF->ValrDupl    Picture    "@RE 999,999,999.99"
             EndIf
          EndIf
   	
	      nContLAux := nContLAux + 1

	      nCont := nCont + 1

   	      dbSelectArea("TRBF")
	      dbSkip()
	   EndDo

	   If nCont <= 2
          @ nContLAux, 015 PSAY cVlrExAux2
   	   EndIf
	Else

		nTamExte   := Len(Extenso(TRBC->ValrNota))
		cValrExten := Extenso(TRBC->ValrNota)

		If (nTamExte > 65)
			nPoVaz := 0
			nPoFin := 0
			lTest := .T.
			While nPoFin <= 64 .And. lTest
				nPoFin := nPoVaz + nPoFin
				nPoVaz := At(" ",SubStr(cValrExten,nPoFin))
				If nPoVaz == 0
					lTest := .F.
				EndIf
			EndDo
			@ 18, 015 PSAY SubStr(cValrExten,1,(nPoFin - 1))
			@ 19, 015 PSAY SubStr(cValrExten,(nPoFin))  + " " + Replicate("*", 64 - (nTamExte - 64))
		Else
			@ 18, 015 PSAY cValrExten + " " + Replicate("*", 64 - nTamExte)
			@ 19, 015 PSAY Replicate("*",65)
		EndIf

	   @ 19, 120 PSAY TRBC->ValrNota    Picture    "@RE 999,999,999.99"

	EndIf
EndIf	

dbSelectArea("TRBC")

Return



// Substituido pelo assistente de conversao do AP5 IDE em 25/06/01 ==> Function ImprItem
Static Function ImprItem()
*****************************************************************************
* Imprime a Nota Fiscal de Entrada e de Saida (Itens)
*
***

Local nCurLDes := 0
 
lContItem := .T.

If (nContItem > nTotaItem)
   @ nContLinh, 025 PSAY "Valor a Transportar : " + TransForm(nValorTran,"@E 999,999,999.99")
   @ 74, 130 PSAY TRBC->NumeNtFi
   @ 78, 00 PSAY ""
   SetPrc(0,0)
   ImprCabe()
   nContLinh := 25
   nContItem := 0
   nTotaItem := 25
EndIf

If (nTipoNtFi == 2) //Apenas Saida imprime codigo produto
   //Crislei Toledo - para que a primeira linha seja impresso: Item LM e nas demais apenas o codigo
   If lFirstItm
//      @ nContLinh, 009 Psay "ITEM LM"
      @ nContLinh, 001 Psay "ITEM LM"
      lFirstItm := .F.
      nContLinh++
   EndIf
   
   If ! Empty(TRBI->ItemLM)       
       @ nContLinh, 001 Psay Alltrim(TRBI->ItemLM)
   Else
       @ nContLinh, 002 Psay Alltrim(TRBI->CodiProd)
   EndIf
//	@ nContLinh, 010 PSAY Iif(Empty(TRBI->ItemLM),Alltrim(TRBI->CodiProd),Alltrim(TRBI->ItemLm))  // Adicionado Davis - 02/06/03
   nLinDesc := MlCount(StrTran(AllTrim(TRBI->DescProd),chr(13),''),45)
   For nCurLDes := 1 To nLinDesc
       @ nContLinh,009 PSAY MemoLine(TRBI->DescProd,45,nCurLDes)
       If nLinDesc > 1 .And. nCurLDes <> nLinDesc
          nContLinh := nContLinh + 1
          nContItem := nContItem + 1
       EndIf
   Next

   @ nContLinh, 061 PSAY TRBI->ClasFisc
   @ nContLinh, 066 PSAY TRBI->SituTrib
   @ nContLinh, 075 PSAY TRBI->CodiUnid
   @ nContLinh, 077 PSAY TRBI->QtdeProd  Picture "@E 99999.999"
   @ nContLinh, 086 PSAY TRBI->ValrUnit  Picture "@E 99,999,999.999"
   @ nContLinh, 102 PSAY TRBI->ValrTota  Picture "@E 999,999,999.99"
   @ nContLinh, 119 PSAY TRBI->PercICMS  Picture "@E 99"
   @ nContLinh, 123 PSAY TRBI->PercIPI   Picture "@E 99"
   @ nContLinh, 127 PSAY TRBI->ValrIPI   Picture "@E 999,999.99"

   If lContItem
      nContItem := nContItem + 1
   EndIf

   nContLinh := nContLinh + 1

Else
	@ nContLinh, 001 PSAY TRBI->ITEMNF
	
   nLinDesc := MlCount(RTrim(TRBI->DescProd),45)

   For nCurLDes := 1 To nLinDesc
       @ nContLinh,001 PSAY MemoLine(TRBI->DescProd,45,nCurLDes)
       If nLinDesc > 1 .And. nCurLDes <> nLinDesc
          nContLinh := nContLinh + 1
          nContItem := nContItem + 1
       EndIf
   Next

   @ nContLinh, 052 PSAY TRBI->ClasFisc
   @ nContLinh, 064 PSAY TRBI->SituTrib
   @ nContLinh, 072 PSAY TRBI->CodiUnid
   @ nContLinh, 075 PSAY TRBI->QtdeProd  Picture "@E 99999.999"
   @ nContLinh, 086 PSAY TRBI->ValrUnit  Picture "@E 99,999,999.999"
   @ nContLinh, 102 PSAY TRBI->ValrTota  Picture "@E 999,999,999.99"
   @ nContLinh, 119 PSAY TRBI->PercICMS  Picture "@E 99"
   @ nContLinh, 122 PSAY TRBI->PercIPI   Picture "@E 99"
   @ nContLinh, 125 PSAY TRBI->ValrIPI   Picture "@E 999,999.99"

   nContLinh := nContLinh + 1

   If lContItem
      nContItem := nContItem + 1
   EndIf

EndIf

nValorTran := nValorTran + TRBI->ValrTota
nTotaItem  := nTotaItem - nContLin
nContLin   := 0

dbSelectArea("TRBI")

Return



// Substituido pelo assistente de conversao do AP5 IDE em 25/06/01 ==> Function ImprRoda
Static Function ImprRoda()
*****************************************************************************
* Imprime a Nota Fiscal de Entrada e de Saida (Rodape)
*
***

Local nIX := 0
Local nXi := 0
 
If (nTipoNtFi == 2)
	dbSelectArea("SC5")
	dbSetOrder(1)
	dbSeek(xFilial("SC5")+TRBC->CodiPedi)

	cMens1 := ""
	cMens2 := ""
	cMsgPg := "" 
	nXT    := 1

	If nContLinh >= 47 .Or. ;
	   nContLinh <= 50

   	   cMens1   := ""
	   nMenInic  := 001
	   nMsgPgIni := 1

	   //cMens1 := Alltrim(SC5->C5_MENNOTA) + " " + Alltrim(SC5->C5_MENNOT2)
	   cMens1  := Alltrim(SC5->C5_MENNOTA) 
	   cMsgPg  := Alltrim(SC5->C5_MENNOT2)

	   If nContLinh >= 47
   	   nContLinh := nContLinh + 1
	   Else
   	   nContLinh := 47
	   EndIf

	   Do Case
	      Case nContLinh == 47
   	        nXT := 4
	      Case nContLinh == 48
      	     nXT := 3
   	   Case nContLinh == 49
	           nXT := 2
      	Case nContLinh == 50
   	        nXT := 1
	   EndCase

	   For nIX := 1 To nXT
	      If AllTrim(SubStr(cMens1,nMenInic,80)) <> ""
   	         @ nContLinh, 009 PSAY SubStr(cMens1,nMenInic,80)
	         nMenInic := (((nMenInic - 1) + 80) + 1)
      	     nContLinh := nContLinh + 1
	      	 If AllTrim(SubStr(cMens1,nMenInic,80)) == ""      	   
      	        @ nContLinh, 009 PSAY SubStr(cMsgPg,nMsgPgIni,80)
      	        nMsgPgIni := (((nMsgPgIni - 1) + 80) + 1)
      	     EndIf
      	  EndIf
   	Next

	EndIf
Else        

   dbSelectArea("SF1")
   dbSetOrder(1)
   dbSeek(xFilial("SF1")+TRBC->NumeNtFi+TRBC->SeriNtFi+TRBC->CodiClFo+TRBC->LojaClFo)
/*   
	cMens1 := ""
	cMens2 := ""
	nXT    := 1

	If nContLinh >= 47 .Or. ;
	   nContLinh <= 50

   	cMens1   := ""
	   nMenInic := 001

	   cMens1 := Alltrim(SF1->F1_MENNOT1) + " " + Alltrim(SF1->F1_MENNOT2)

	   If nContLinh >= 47
   	   nContLinh := nContLinh + 1
	   Else
   	   nContLinh := 47
	   EndIf

	   Do Case
	      Case nContLinh == 47
   	        nXT := 4
	      Case nContLinh == 48
      	     nXT := 3
   	   Case nContLinh == 49
	           nXT := 2
      	Case nContLinh == 50
   	        nXT := 1
	   EndCase

	   For nIX := 1 To nXT
   	   @ nContLinh, 019 PSAY SubStr(cMens1,nMenInic,80)
	      nMenInic := (((nMenInic - 1) + 80) + 1)
      	nContLinh := nContLinh + 1
   	Next

	EndIf
*/	
EndIf

@ 52, 005  PSAY TRBC->BCalICMS  Picture "@E@Z 999,999,999.99"
@ 52, 035  PSAY TRBC->ValrICMS  Picture "@E@Z 999,999,999.99"
@ 52, 062  PSAY 0               Picture "@E@Z 999,999,999.99"
@ 52, 088  PSAY TRBC->ValrICMR  Picture "@E@Z 999,999,999.99"
@ 52, 118  PSAY TRBC->ValrMerc  Picture "@E@Z 999,999,999.99"

@ 54, 005  PSAY TRBC->ValrFret  Picture "@E@Z 999,999,999.99"
@ 54, 035  PSAY TRBC->ValrSegu  Picture "@E@Z 999,999,999.99"
@ 54, 062  PSAY TRBC->ValrDesp  Picture "@E@Z 999,999,999.99" 
@ 54, 088  PSAY TRBC->ValrIPI   Picture "@E@Z 999,999,999.99"
@ 54, 118  PSAY TRBC->ValrNota  Picture "@E@Z 999,999,999.99" 

If (nTipoNtFi == 2)
   dbSelectArea("SA4")
   dbSetOrder(1)
   dbSeek(xFilial("SA4")+SC5->C5_Transp)

	@ 57, 001  PSAY SA4->A4_Nome
//	If (SC5->C5_TPFRETE == "C")
//		@ 58, 091 PSAY "1"
//	Else
//		@ 58, 091 PSAY "2"
//	Endif

   @ 57, 101 PSAY SC5->C5_PLACA
   If ! Empty(SA4->A4_CGC)
      @ 57, 110 PSAY SA4->A4_CGC    Picture "@R 99.999.999/9999-99"
   EndIf
	
   @ 59, 001 PSAY left(SA4->A4_End,70)
   @ 59, 074 PSAY Left(SA4->A4_Mun,28)
   @ 59, 101 PSAY SA4->A4_Est
   @ 59, 110 PSAY SA4->A4_InsEst  
	
Else //Nota de Entrada
   dbSelectArea("SA4")
   dbSetOrder(1)
   dbSeek(xFilial("SA4")+SF1->F1_Transp)

   @ 57, 001  PSAY SA4->A4_Nome

   @ 57, 092 PSAY SF1->F1_PLACVEI
   @ 57, 103 PSAY SF1->F1_UFVEI

   If ! Empty(SA4->A4_CGC)
      @ 57, 110 PSAY SA4->A4_CGC    Picture "@R 99.999.999/9999-99"
   EndIf

   @ 59, 001 PSAY SA4->A4_End
   @ 59, 074 PSAY SA4->A4_Mun
   @ 59, 101 PSAY SA4->A4_Est
   @ 59, 110 PSAY SA4->A4_InsEst
EndIf

@ 61, 001 PSAY TRBC->QtdeVolu Picture "@E@Z 999,999"
@ 61, 024 PSAY TRBC->TipoEspe 

If (nTipoNtFi == 2)
   @ 61, 046 PSAY SC5->C5_MARCA
	@ 61, 072 PSAY "" //"123456789X"

	@ 61, 095 PSAY TRBC->PesoBrut   Picture"@E@Z 999,999.99"
	@ 61, 113 PSAY TRBC->PesoLiqu   Picture"@E@Z 999,999.99" 
Else 

	@ 61, 095 PSAY TRBC->PesoBrut Picture "@E 99,999.99"
	@ 61, 113 PSAY TRBC->PesoLiqu Picture "@E 99,999.99"
EndIf

If (nTipoNtFi == 2)
	nPos     := 2
	nLinClas := 70
	nCont    := 00

	nContLinh := 64
	nMenIni2  := 1
	nMsgPgI2  := 1
	cMens2    := ""
	cMsgPg2   := ""
	cMens2    := IIf(! Empty(Formula(SC5->C5_MenPad)),Formula(SC5->C5_MenPad),"")
	cMens2    := Alltrim(cMens2) + " " + IIf(! Empty(Formula(SC5->C5_MenPad2)),Formula(SC5->C5_MenPad2),"")

	If Empty(cMens2)
   	   If ! Empty(SC5->C5_MenNot3)
      	  cMens2 := Alltrim(SC5->C5_MenNot3)
	   EndIf
                     
	   If ! Empty(SC5->C5_REFER)
   	   cMens2 := Alltrim(cMens2) + " " + Alltrim(SC5->C5_REFER)
	   EndIf

	ElseIf Len(Alltrim(cMens2)) < 210 .And. ! Empty(SC5->C5_MenNot3)
   	   cMens2 := Alltrim(cMens2) + " " + Alltrim(SC5->C5_MenNot3)
	EndIf

	For nXi := 1 To 7
   	   If AllTrim(SubStr(cMens2,nMenIni2,60)) <> ""
   	      @ nContLinh, 001 PSAY SubStr(cMens2,nMenIni2,60)
	      nMenIni2 := (((nMenIni2 - 1) + 60) + 1)
   	      nContLinh := nContLinh + 1
   	      If AllTrim(SubStr(cMens2,nMenIni2,60)) == ""
	         @ nContLinh, 001 PSAY SubStr(cMsgPg2,nMsgPgI2,60)
	         nMsgPgI2 := (((nMsgPgI2 - 1) + 60) + 1)
   	      EndIf
   	      /*
   	      If nMenIni2 > Len(Alltrim(cMens2))
	         Exit
   	      EndIf
	      */
	   EndIf
	Next
Else 
	nPos     := 2
	nLinClas := 70
	nCont    := 00


	nContLinh := 64
	nMenIni2  := 1
	cMens2    := ""
   cMens2    := Alltrim(SF1->F1_MENNOT1) + " " + Alltrim(SF1->F1_MENNOT2) + "   "
	cMens2    += IIf(! Empty(Formula(SF1->F1_Mens1)),Formula(SF1->F1_Mens1),"  ") 
	cMens2    += IIf(! Empty(Formula(SF1->F1_Mens2)),Formula(SF1->F1_Mens2),"  ") 

	For nXi := 1 To 7
   	 @ nContLinh, 001 PSAY SubStr(cMens2,nMenIni2,60)
	    nMenIni2 := (((nMenIni2 - 1) + 60) + 1)
   	 If nMenIni2 > Len(Alltrim(cMens2))
	       Exit
   	 EndIf
	    nContLinh := nContLinh + 1
	Next
EndIf

@ 73, 120 PSAY TRBC->NumeNtFi
@ 78, 00 PSAY ""

SetPrc(0,0)

dbSelectArea("TRBC")

Return