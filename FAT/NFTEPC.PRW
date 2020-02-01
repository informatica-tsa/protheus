#include "rwmake.ch"        // incluido pelo assistente de conversao do AP5 IDE em 25/06/01

User Function NFTEPC()        // incluido pelo assistente de conversao do AP5 IDE em 25/06/01


SetPrvt("CBTXT,CBCONT,NORDEM,ALFA,Z,M")
SetPrvt("TAMANHO,LIMITE,TITULO,CDESC1,CDESC2,CDESC3")
SetPrvt("CNATUREZA,ARETURN,NOMEPROG,CPERG,NLASTKEY,LCONTINUA")
SetPrvt("NLIN,WNREL,NVALIRRF,NVALFATU,NTAMNF,CSTRING")
SetPrvt("CNOTAINIC,CNOTAFINA,NLININI,XNUM_NF,XSERIE,XEMISSAO")
SetPrvt("XTOT_FAT,XBASEISS,XVALISS,XLOJA,XFRETE,XSEGURO")
SetPrvt("XDESPESA,XBASE_ICMS,XBASE_IPI,XVALOR_ICMS,XICMS_RET,XVALOR_IPI")
SetPrvt("XVALOR_MERC,XNUM_DUPLIC,XCOND_PAG,XPBRUTO,XPLIQUI,XTIPO")
SetPrvt("XESPECIE,XVOLUME,XPED_VEND,XITEM_PED,XNUM_NFDV,XPREF_DV")
SetPrvt("XICMS,XCOD_PRO,XQTD_PRO,XPRE_UNI,XPRE_TAB,XIPI")
SetPrvt("XVAL_IPI,XDESC,XVAL_DESC,XVAL_DESC1,XVAL_MERC,XTES")
SetPrvt("XCF,XICMSOL,XICM_PROD,CPEDATU,CITEMATU,XPESO_PRO")
SetPrvt("XPESO_UNIT,XDESCRICAO,XUNID_PRO,XCOD_TRIB,XMEN_TRIB,XCOD_FIS")
SetPrvt("XCLAS_FIS,XMEN_POS,XISS,XTIPO_PRO,XLUCRO,XCLFISCAL")
SetPrvt("XPESO_LIQ,I,NPERCISS,XPESO_LIQUID,XPED,XPESO_BRUTO")
SetPrvt("XP_LIQ_PED,XCLIENTE,XCONTRATO,XTIPO_CLI,XCOD_MENS,XCOD_MEN2")
SetPrvt("XREFER,XMENSAGEM,XMEM_USO,XTPFRETE,XCONDPAG,XCOD_VEND")
SetPrvt("XDESC_NF,XDESC_PAG,XPED_CLI,XDESC_PRO,XDESC_COM,J")
SetPrvt("XNOMCTR,XCONTA,XNOMCONTA,XCONTCLI,XCOD_CLI,XNOME_CLI")
SetPrvt("XEND_CLI,XBAIRRO,XCEP_CLI,XCOB_CLI,XREC_CLI,XMUN_CLI")
SetPrvt("XPRC_CLI,XEST_CLI,XEST_CLI2,XCGC_CLI,XINSC_CLI,XTRAN_CLI")
SetPrvt("XTEL_CLI,XFAX_CLI,XSUFRAMA,XCALCSUF,XBANCO,XAGEN,XCBANCO,ZFRANCA")
SetPrvt("XVENDEDOR,XBSICMRET,XNOME_TRANSP,XEND_TRANSP,XMUN_TRANSP,XEST_TRANSP")
SetPrvt("XVIA_TRANSP,XCGC_TRANSP,XTEL_TRANSP,XPARC_DUP,XVENC_DUP,XVALOR_DUP")
SetPrvt("XNOMEBCO,XENDBCO,XAGEBCO,XCONBCO,XNATUREZA,NOPC")
SetPrvt("CCOR,NTAMEXTE,APERGUNTAS,NXZ,NXY,")

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³  Nftepc  ³ Autor ³ Eduardo Carraro       ³ Data ³ 22/11/99 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Fatura da EPC                                              ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Especifico para EPC                                        ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

CbTxt     := ""
CbCont    := ""
nOrdem    := 0
Alfa      := 0
Z         := 0
M         := 0
Tamanho   := "P"
limite    := 80
titulo    := "Fatura - NFTEPC"
cDesc1    := PADC("Este programa ira emitir a Fatura",74)
cDesc2    := ""
cDesc3    := PadC("Referente a empresa EPC.",74)
cNatureza := ""
aReturn   := { "Especial", 1,"Administracao", 1, 2, 1,"",1 }
NomeProg  := "NFTEPC"
cPerg     := "NFTEPC"
nLastKey  := 0
lContinua := .T.
nLin      := 0
wnrel     := "NFTEPC"

nValIRRF := 0                                      
nValFatu := 0
xAGbanco := ""
xCbanco  := ""
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Tamanho do Formulario de Nota Fiscal (em Linhas)          ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

nTamNf    := 70     // Apenas Informativo

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Verifica as perguntas selecionadas, busca o padrao da Nfiscal           ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ



Pergunte(cPerg,.F.)               // Pergunta no SX1

cString := "SF2"

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Envia controle para a funcao SETPRINT                        ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

wnrel := SetPrint(cString,wnrel,cPerg,Titulo,cDesc1,cDesc2,cDesc3,.F.,,.F.)

If nLastKey == 27
   Return
Endif

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Verifica Posicao do Formulario na Impressora                 ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
SetDefault(aReturn,cString)

If nLastKey == 27
   Return
Endif

cNotaInic := mv_par01
cNotaFina := mv_par02

VerImp()

#IFDEF WINDOWS
   RptStatus({|| RptDetail()})// Substituido pelo assistente de conversao do AP5 IDE em 25/06/01 ==>    RptStatus({|| Execute(RptDetail)})
#ELSE
   RptDetail()
#ENDIF

Return


// Substituido pelo assistente de conversao do AP5 IDE em 25/06/01 ==> Function RptDetail
Static Function RptDetail()
*****************************************************************************
*
*
***

Local nI2 := 0 
Local I := 1

SetRegua(Val(cNotaFina)-Val(cNotaInic))

dbSelectArea("SF2")
dbSetOrder(1)
Set Softseek On
dbSeek(xFilial("SF2")+cNotaInic)
Set Softseek Off

While (! Eof()) .And. (SF2->F2_Filial == xFilial("SF2")) .And. (SF2->F2_Doc <= cNotaFina)

    If (SF2->F2_Serie <> "FAT")
       dbSelectArea("SF2")
       dbSkip()
       Loop
    Endif

    IF lAbortPrint
       @ 00,01 PSAY "** CANCELADO PELO OPERADOR **"
       lContinua := .F.
       Exit
    Endif

    nLinIni := nLin
    // * Cabecalho da Nota Fiscal

    xNUM_NF     := SF2->F2_DOC             // Numero
    xSERIE      := SF2->F2_SERIE           // Serie
    xEMISSAO    := SF2->F2_EMISSAO         // Data de Emissao
    xTOT_FAT    := SF2->F2_VALFAT          // Valor Total da Fatura
    xBASEISS    := SF2->F2_BASEISS         // Valor Base do ISS
    xVALISS     := SF2->F2_VALISS          // Valor do Iss

    xTOT_FAT    := SF2->F2_VALMERC+SF2->F2_VALIPI+SF2->F2_SEGURO+SF2->F2_FRETE

    xLOJA       := SF2->F2_LOJA            // Loja do Cliente
    xFRETE      := SF2->F2_FRETE           // Frete
    xSEGURO     := SF2->F2_SEGURO          // Seguro
    xDESPESA    := SF2->F2_DESPESA         // Outras Despesas
    xBASE_ICMS  := SF2->F2_BASEICM         // Base   do ICMS
    xBASE_IPI   := SF2->F2_BASEIPI         // Base   do IPI
    xVALOR_ICMS := SF2->F2_VALICM          // Valor  do ICMS
    xICMS_RET   := SF2->F2_ICMSRET         // Valor  do ICMS Retido
    xVALOR_IPI  := SF2->F2_VALIPI          // Valor  do IPI
    xVALOR_MERC := SF2->F2_VALMERC         // Valor  da Mercadoria
    xNUM_DUPLIC := SF2->F2_DUPL            // Numero da Duplicata
    xCOND_PAG   := SF2->F2_COND            // Condicao de Pagamento
    xPBRUTO     := SF2->F2_PBRUTO          // Peso Bruto
    xPLIQUI     := SF2->F2_PLIQUI          // Peso Liquido
    xTIPO       := SF2->F2_TIPO            // Tipo do Cliente
    xESPECIE    := SF2->F2_ESPECI1         // Especie 1 no Pedido
    xVOLUME     := SF2->F2_VOLUME1         // Volume 1 no Pedido

    xPED_VEND  := {}                         // Numero do Pedido de Venda
    xITEM_PED  := {}                         // Numero do Item do Pedido de Venda
    xNUM_NFDV  := {}                         // nUMERO QUANDO HOUVER DEVOLUCAO
    xPREF_DV   := {}                         // Serie  quando houver devolucao
    xICMS      := {}                         // Porcentagem do ICMS
    xCOD_PRO   := {}                         // Codigo  do Produto
    xQTD_PRO   := {}                         // Peso/Quantidade do Produto
    xPRE_UNI   := {}                         // Preco Unitario de Venda
    xPRE_TAB   := {}                         // Preco Unitario de Tabela
    xIPI       := {}                         // Porcentagem do IPI
    xVAL_IPI   := {}                         // Valor do IPI
    xDESC      := {}                         // Desconto por Item
    xVAL_DESC  := {}                         // Valor do Desconto
    xVAL_DESC1 := {}                         // Valor do Desconto USADO NESTE PRG
    xVAL_MERC  := {}                         // Valor da Mercadoria
    xTES       := {}                         // TES
    xCF        := {}                         // Classificacao quanto natureza da Operacao
    xICMSOL    := {}                         // Base do ICMS Solidario
    xICM_PROD  := {}                         // ICMS do Produto

    dbSelectArea("SD2")                   // * Itens de Venda da N.F.
    dbSetOrder(3)
    dbSeek(xFilial("SD2")+xNUM_NF+xSERIE)

    cPedAtu   := SD2->D2_PEDIDO
    cItemAtu  := SD2->D2_ITEMPV

    While (! Eof()) .And. (SD2->D2_FIlial == xFilial("SD2")) .And. (SD2->D2_Doc    == xNUM_NF) .And. (SD2->D2_Serie  == xSERIE)

         Aadd(xPED_VEND  ,SD2->D2_PEDIDO)
         Aadd(xITEM_PED  ,SD2->D2_ITEMPV)
         Aadd(xNUM_NFDV  ,IIF(Empty(SD2->D2_NFORI),"",SD2->D2_NFORI))
         Aadd(xPREF_DV   ,SD2->D2_SERIORI)
         Aadd(xICMS      ,IIf(Empty(SD2->D2_PICM),0,SD2->D2_PICM))
         Aadd(xCOD_PRO   ,SD2->D2_COD)
         Aadd(xQTD_PRO   ,SD2->D2_QUANT)     // Guarda as quant. da NF
         Aadd(xPRE_UNI   ,SD2->D2_PRCVEN)
         Aadd(xPRE_TAB   ,SD2->D2_PRUNIT)
         Aadd(xIPI       ,IIF(Empty(SD2->D2_IPI),0,SD2->D2_IPI))
         Aadd(xVAL_IPI   ,SD2->D2_VALIPI)
         Aadd(xDESC      ,SD2->D2_DESC)
         Aadd(xVAL_DESC1 ,SD2->D2_DESCON)
         Aadd(xVAL_MERC  ,SD2->D2_TOTAL)
         Aadd(xTES       ,SD2->D2_TES)
         Aadd(xCF        ,SD2->D2_CF)
         Aadd(xICM_PROD  ,IIf(Empty(SD2->D2_PICM),0,SD2->D2_PICM))

         dbSelectArea("SD2")
         dbskip()
    End

    xPESO_PRO  := {}                           // Peso Liquido
    xPESO_UNIT := {}                           // Peso Unitario do Produto
    xDESCRICAO := {}                           // Descricao do Produto
    xUNID_PRO  := {}                           // Unidade do Produto
    xCOD_TRIB  := {}                           // Codigo de Tributacao
    xMEN_TRIB  := {}                           // Mensagens de Tributacao
    xCOD_FIS   := {}                           // Cogigo Fiscal
    xCLAS_FIS  := {}                           // Classificacao Fiscal
    xMEN_POS   := {}                           // Mensagem da Posicao IPI
    xISS       := {}                           // Aliquota de ISS
    xTIPO_PRO  := {}                           // Tipo do Produto
    xLUCRO     := {}                           // Margem de Lucro p/ ICMS Solidario
    xCLFISCAL  := {}
    xPESO_LIQ  := 0
    nPercISS   := 0

    For I := 1 to Len(xCOD_PRO)

         dbSelectArea("SB1")                     // * Desc. Generica do Produto
         dbSetOrder(1)
         dbSeek(xFilial("SB1")+xCOD_PRO[I])

         Aadd(xPESO_PRO  ,SB1->B1_PESO * xQTD_PRO[I])

         xPESO_LIQ  := xPESO_LIQ + xPESO_PRO[I]

         Aadd(xPESO_UNIT ,SB1->B1_PESO)
         Aadd(xUNID_PRO  ,SB1->B1_UM)
         Aadd(xDESCRICAO ,SB1->B1_DESC)
         Aadd(xCOD_TRIB  ,SB1->B1_ORIGEM)

         If (Ascan(xMEN_TRIB, SB1->B1_ORIGEM) == 0)
            Aadd(xMEN_TRIB ,SB1->B1_ORIGEM)
         Endif

         Aadd(xCLAS_FIS  ,SB1->B1_POSIPI)
         Aadd(xCLFISCAL,SB1->B1_CLASFIS)

         If (SB1->B1_ALIQISS > 0)
            Aadd(xISS ,SB1->B1_ALIQISS)
            nPercISS := SB1->B1_ALIQISS
         Else
            Aadd(xISS ,0)
         EndIf

         AADD(xTIPO_PRO ,SB1->B1_TIPO)
         AADD(xLUCRO    ,SB1->B1_PICMRET)

         xPESO_LIQUID := 0

         For nI2 := 1 to Len(xPESO_PRO)
            xPESO_LIQUID := xPESO_LIQUID+xPESO_PRO[nI2]
         Next nI2
    Next I

    xPED        := {}
    xPESO_BRUTO := 0
    xP_LIQ_PED  := 0

    For I := 1 to Len(xPED_VEND)

         If (AScan(xPED,xPED_VEND[I]) == 0)

            dbSelectArea("SC5")
            dbSetOrder(1)
            dbSeek(xFilial("SC5")+xPED_VEND[I])

            xCLIENTE    := SC5->C5_CLIENTE              // Codigo do Cliente
            xCONTRATO   := SC5->C5_CONTRATO             // Codigo do Contrato
            xTIPO_CLI   := SC5->C5_TIPOCLI              // Tipo de Cliente
            xCOD_MENS   := SC5->C5_MENPAD               // Codigo da Mensagem Padrao
            xREFER      := SC5->C5_REFER                // Referencia do contrato
            xMENSAGEM   := SC5->C5_MENNOTA              // Mensagem para a Nota Fiscal
*            xMEM_USO    := SC5->C5_MEMUSO               // mens. tipo pagto
            xTPFRETE    := SC5->C5_TPFRETE              // Tipo de Entrega
            xCONDPAG    := SC5->C5_CONDPAG              // Condicao de Pagamento
            xPESO_BRUTO := SC5->C5_PBRUTO               // Peso Bruto
            xP_LIQ_PED  := xP_LIQ_PED + SC5->C5_PESOL   // Peso Liquido
            xCOD_VEND   := {SC5->C5_VEND1,;             // Codigo do Vendedor 1
                            SC5->C5_VEND2,;             // Codigo do Vendedor 2
                            SC5->C5_VEND3,;             // Codigo do Vendedor 3
                            SC5->C5_VEND4,;             // Codigo do Vendedor 4
                            SC5->C5_VEND5}              // Codigo do Vendedor 5
            xDESC_NF    := {SC5->C5_DESC1,;             // Desconto Global 1
                            SC5->C5_DESC2,;             // Desconto Global 2
                            SC5->C5_DESC3,;             // Desconto Global 3
                            SC5->C5_DESC4}              // Desconto Global 4
            Endif

           If (xP_LIQ_PED > 0)
              xPESO_LIQ := xP_LIQ_PED
           Endif
    Next

    //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
    //³ Pesquisa da Condicao de Pagto               ³
    //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

    dbSelectArea("SE4")                    // Condicao de Pagamento
    dbSetOrder(1)
    dbSeek(xFilial("SE4")+xCONDPAG)

    xDESC_PAG := SE4->E4_DESCRI

    xPED_CLI  := {}                          // Numero de Pedido
    xUNID_PRO := {}
    xDESC_PRO := {}                          // Descricao aux do produto
    xDESC_COM := {}                          // Descricao do
                                               // Mes de Competencia / Complementar
    J := Len(xPED_VEND)

    For I := 1 to J
         dbSelectArea("SC6")                    // * Itens de Pedido de Venda
         dbSetOrder(1)
         dbSeek(xFilial("SC6")+xPED_VEND[I]+xITEM_PED[I])

         AADD(xPED_CLI , SC6->C6_PEDCLI)
         AADD(xUNID_PRO, SC6->C6_UM)
         AADD(xDESC_PRO, SC6->C6_DESCRI)
//         AADD(xDESC_COM, SC6->C6_MESCOMP)
         AADD(xVAL_DESC, SC6->C6_VALDESC)
    Next

    DbSelectArea("SZ1")
    DbSetOrder(1)
    If DbSeek(xFilial("SZ1")+xCONTRATO)
       xNOMCTR     :=Z1_NOME
       xCONTA      := Z1_CONTA                // Conta do Contrato
       xNOMCONTA   := Z1_NOMCONTA             // Nome da Conta do Contrato
       If Empty(Z1_NOME)
          xCONTCLI:="SEM NUMERO"
       Else
          xCONTCLI:=Z1_NOME
       EndIf
    Else
       xNOMCTR:="SEM NOME"
       xCONTCLI:="SEM NUMERO"
       xCONTA  := "SEM NUMERO"                 // Conta do Contrato
       xNOMCONTA := "SEM NOME"                // Nome da Conta do Contrato
    EndIf

    If (xTIPO $ "N/C/P/I/S/T/O")

         dbSelectArea("SA1")                // * Cadastro de Clientes
         dbSetOrder(1)
         dbSeek(xFilial("SA1")+xCLIENTE+xLOJA)

         xCOD_CLI  := SA1->A1_COD             // Codigo do Cliente
         xNOME_CLI := SA1->A1_NOME            // Nome
         xEND_CLI  := SA1->A1_END             // Endereco
         xBAIRRO   := SA1->A1_BAIRRO          // Bairro
         xCEP_CLI  := SA1->A1_CEP             // CEP
         xCOB_CLI  := SA1->A1_ENDCOB          // Endereco de Cobranca
         xREC_CLI  := SA1->A1_ENDENT          // Endereco de Entrega
//         xMUN_CLI  := Tabela("89",SA1->A1_MUN)  // Municipio
         xMUN_CLI  := Tabela("89",SA1->A1_MUNISS)  // Municipio
         xPRC_CLI  := SA1->A1_PRPAGTO         // Praca Pagto
         xEST_CLI  := SA1->A1_EST             // Estado
         xEST_CLI2 := SA1->A1_UFPGTO          // Estado da Praca de Pagto
         xCGC_CLI  := SA1->A1_CGC             // CGC
         xINSC_CLI := SA1->A1_INSCR           // Inscricao estadual
         xTRAN_CLI := SA1->A1_TRANSP          // Transportadora
         xTEL_CLI  := SA1->A1_TEL             // Telefone
         xFAX_CLI  := SA1->A1_FAX             // Fax
         xSUFRAMA  := SA1->A1_SUFRAMA         // Codigo Suframa
         xCALCSUF  := SA1->A1_CALCSUF         // Calcula Suframa
         xBANCO    := SA1->A1_BCO1            // Banco de Movimento do Cliente
         xAGBANCO  := SA1->A1_AGBANCO
         xCBANCO   := SA1->A1_CBANCO
                  
         // Alteracao p/ Calculo de Suframa
         If (! Empty(xSUFRAMA)) .And. ;
            (xCALCSUF == "S")

            If (XTIPO $ "D/B")
               zFranca := .F.
            Else
               zFranca := .T.
            EndIf
         Else
            zfranca := .F.
         EndIf

    Else
         zFranca := .F.

         dbSelectArea("SA2")                // * Cadastro de Fornecedores
         dbSetOrder(1)
         dbSeek(xFilial("SA2")+xCLIENTE+xLOJA)

         xCOD_CLI  := SA2->A2_COD             // Codigo do Fornecedor
         xNOME_CLI := SA2->A2_NOME            // Nome Fornecedor
         xEND_CLI  := SA2->A2_END             // Endereco
         xBAIRRO   := SA2->A2_BAIRRO          // Bairro
         xCEP_CLI  := SA2->A2_CEP             // CEP
         xCOB_CLI  := ""                      // Endereco de Cobranca
         xREC_CLI  := ""                      // Endereco de Entrega
         xMUN_CLI  := SA2->A2_MUN             // Municipio
         xPRC_CLI  := SA2->A2_MUN            // Praca Pagto
         xEST_CLI  := SA2->A2_EST             // Estado
         xEST_CLI2 := SA2->A2_EST             // Estado da Praca de Pagto
         xCGC_CLI  := SA2->A2_CGC             // CGC
         xINSC_CLI := SA2->A2_INSCR           // Inscricao estadual
         xTRAN_CLI := SA2->A2_TRANSP          // Transportadora
         xTEL_CLI  := SA2->A2_TEL             // Telefone
         xFAX_CLI  := SA2->A2_FAX             // Fax
    Endif

    xVENDEDOR:= {}                         // Nome do Vendedor
    I        := 1
    J        := Len(xCOD_VEND)

    For I := 1 to J
          dbSelectArea("SA3")                   // * Cadastro de Vendedores
          dbSetOrder(1)
          dbSeek(xFilial("SA3")+xCOD_VEND[I])
          Aadd(xVENDEDOR,SA3->A3_NREDUZ)
    Next

    If (xICMS_RET >0)                        // Apenas se ICMS Retido > 0
          dbSelectArea("SF3")                   // * Cadastro de Livros Fiscais
          dbSetOrder(4)
          dbSeek(xFilial("SF3")+SA1->A1_COD+SA1->A1_LOJA+SF2->F2_DOC+SF2->F2_SERIE)

          If (! Eof())
             xBSICMRET := F3_VALOBSE
          Else
             xBSICMRET := 0
          EndIf
    Else
          xBSICMRET := 0
    EndIf

    dbSelectArea("SA4")                   // * Transportadoras
    dbSetOrder(1)
    dbSeek(xFilial("SA4")+SF2->F2_TRANSP)

    xNOME_TRANSP := SA4->A4_NOME           // Nome Transportadora
    xEND_TRANSP  := SA4->A4_END            // Endereco
    xMUN_TRANSP  := SA4->A4_MUN            // Municipio
    xEST_TRANSP  := SA4->A4_EST            // Estado
    xVIA_TRANSP  := SA4->A4_VIA            // Via de Transporte
    xCGC_TRANSP  := SA4->A4_CGC            // CGC
    xTEL_TRANSP  := SA4->A4_TEL            // Fone

    xPARC_DUP  := {}                       // Parcela
    xVENC_DUP  := {}                       // Vencimento
    xVALOR_DUP := {}                       // Valor
    DbSelectArea("SA6")
    DbSetOrder(1)
    If DbSeek(xFilial("SA6")+xBANCO+xAGBANCO+xCBANCO)
       xNOMEBCO:=SA6->A6_NOME
       xENDBCO :=SA6->A6_END
       xAGEBCO := (AllTrim(SA6->A6_AGENCIA)+"-"+SA6->A6_DIGAGEN)       
// ALTERADO POR CRISLEI EM 03/08/07 - A CONTA CADASTRADA NO SA6 (BANCO REAL) JA ESTA COM O DIG. VERIFICADOR
//       xCONBCO := (AllTrim(SA6->A6_NUMCON)+"-"+SA6->A6_DIGCC)
       xCONBCO := (AllTrim(SA6->A6_NUMCON))//+"-"+SA6->A6_DIGCC)
    EndIf

    dbSelectArea("SE1")                   // * Contas a Receber
    dbSetOrder(1)
    dbSeek(xFilial("SE1")+xSERIE+xNUM_DUPLIC)

    While (! Eof()) .And. (SE1->E1_Filial  == xFilial("SE1")) .And. ;
            (SE1->E1_Prefixo == xSERIE) .And. (SE1->E1_Num     == xNUM_DUPLIC)

         If (SE1->E1_TIPO <> "NF ")

            If (SE1->E1_TIPO == "IR-")
               nValIRRF := SE1->E1_VALOR
            EndIf

            dbSelectArea("SE1")
            dbSkip()
            Loop
         Endif

         AADD(xPARC_DUP ,SE1->E1_PARCELA)
         AADD(xVENC_DUP ,SE1->E1_VENCTO)
         AADD(xVALOR_DUP,SE1->E1_VALOR)

         dbSelectArea("SE1")
         dbSkip()
    EndDo

    dbSelectArea("SF4")                   // * Tipos de Entrada e Saida
    DbSetOrder(1)
    dbSeek(xFilial("SF4")+xTES[1])

    xNATUREZA := SF4->F4_TEXTO              // Natureza da Operacao

    ImpriC()

    //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
    //³ Termino da Impressao da Nota Fiscal                          ³
    //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

    IncRegua()                    // Termometro de Impressao

    nLin:=0
    nValFatu := 0
    dbSelectArea("SF2")
    dbSkip()                      // passa para a proxima Nota Fiscal
EndDo

dbSelectArea("SF2")
Retindex("SF2")
dbSelectArea("SF1")
Retindex("SF1")
dbSelectArea("SD2")
Retindex("SD2")
dbSelectArea("SD1")
Retindex("SD1")
SetPgEject(.f.)
Set Device To Screen

If aReturn[5] == 1
   Set Printer TO
   dbcommitAll()
   ourspool(wnrel)
Endif

MS_FLUSH()

Return

// Substituido pelo assistente de conversao do AP5 IDE em 25/06/01 ==> Function VerImp
Static Function VerImp()

nLin    := 0                // Contador de Linhas
nLinIni := 0

If (aReturn[5] == 2)
   nOpc := 1

   #IFNDEF WINDOWS
      cCor := "B/BG"
   #ENDIF

   While .T.

      SetPrc(0,0)
      dbCommitAll()

      IF MsgYesNo("Fomulario esta posicionado ? ")
         nOpc := 1
      ElseIF MsgYesNo("Tenta Novamente ? ")
         nOpc := 2
      Else
         nOpc := 3
      Endif

      Do Case
         Case (nOpc == 1)
              lContinua:=.T.
              Exit
         Case (nOpc == 2)
              Loop
         Case (nOpc == 3)
              lContinua:=.F.
              Return
      EndCase
   End
EndIf

Return


// Substituido pelo assistente de conversao do AP5 IDE em 25/06/01 ==> Function ImpriC
Static Function ImpriC()

//Uso destes comandos para conf. a Impressora
@ 00,05 PSAY Chr(27)+ "@" 
//@ 01,00 PSAY Chr(27) + "5"
//@ 02,00 PSAY Chr(27) + "F"
//@ 02,50 PSAY Chr(27) + "C" + Chr(70)

@ Prow(),70 PSAY Chr(18)

@ Prow()+1,10 PSAY xCONTRATO + " - " + xCONTCLI
@ Prow(),67 PSAY "CL: " + xCLIENTE + "/" + xLOJA

@ Prow()+1,10 PSAY xCONTA + " - " + xNOMCONTA

@ Prow()+1,10 PSAY SubStr(xREFER,1,65)
@ Prow()+1,10 PSAY SubStr(xREFER,66,65)
@ Prow()+1,10 PSAY SubStr(xREFER,131,65)

If ! Empty(xNOMEBCO)
   @ Prow()+1,10 PSAY xNOMEBCO
   @ Prow()+1,10 PSAY xENDBCO
   @ Prow()+1,10 PSAY "Agencia: " + xAGEBCO
   @ Prow()+1,10 PSAY "CONTA CORRENTE - " + xCONBCO
Else
   @ Prow()+1,10 PSAY xMENSAGEM
EndIF
If (Len(xVALOR_DUP) > 0)
   nValFatu := nValFatu + (xValor_Merc)
EndIf
@ Prow()+1,20 PSAY TransForm(nValFatu,"@E 9,999,999.99")

nTamExte := Len(Extenso(nValFatu))

@ Prow(),32 PSAY "("
@ Prow(),34 PSAY SubStr(Extenso(nValFatu),1,40)
@ Prow()+1,04 PSAY SubStr(Extenso(nValFatu),41,65) + ")"

If (Len(xVALOR_DUP) > 0)
   @ Prow()+12,10 PSAY xNUM_DUPLIC
   @ Prow(),20 PSAY nValFatu Picture "@E 999,999,999.99"
   @ Prow(),35 PSAY xNUM_DUPLIC + " " + xPARC_DUP[1]
   @ Prow(),46 PSAY nValFatu Picture "@E 999,999,999.99"
   @ Prow(),62 PSAY xEmissao
   @ Prow(),71 PSAY xVENC_DUP[1]
EndIf

If ! Empty(nValIrrf)
   @ Prow()+2,27 PSAY TransForm(nValIrrf,"@E 999,999.99") + " REF. A IRRF"
EndIf
nValIrrf:=0

@ Prow()+3,30 PSAY xNOME_CLI

@ Prow()+1,30 PSAY Left(xEND_CLI,50)

//@ 33,30 PSAY "Bairro : " + Left(xBAIRRO,15) + " / Telefone : " + xTEL_CLI

@ Prow()+2,30 PSAY xMUN_CLI
@ Prow(),66 PSAY xEST_CLI

@ Prow()+2,30 PSAY xPRC_CLI
@ Prow(),66 PSAY xEST_CLI2

@ Prow()+2,30 PSAY xCGC_CLI Picture  "@R 99.999.999/9999-99"
@ Prow(),57 PSAY xINSC_CLI

@ Prow()+2,30 PSAY SubStr(Extenso(nValFatu),1,45)

@ Prow()+1,30 PSAY SubStr(Extenso(nValFatu),46,50)

@ Prow()+1,30 PSAY SubStr(Extenso(nValFatu),97,50)

@ 65,00 PSAY "  "
SETPRC(0,0)

Return .T.


Static Function TestaSX1()

Local nxY := 0
Local nxZ := 0

aPerguntas := {}

AADD(aPerguntas,{cPerg,"Da Nota Fiscal     ?","C",06,0,"G","","","","","","",""})
AADD(aPerguntas,{cPerg,"Ate a Nota Fiscal  ?","C",06,0,"G","","","","","","",""})

For nxZ := 1 To Len(aPerguntas)
    dbSelectArea("SX1")
    RecLock("SX1",!dbSeek(cPerg+StrZero(nxZ,2)))
    Replace  X1_Grupo   With  cPerg
    Replace  X1_Ordem   With  StrZero(nxZ,2)
    Replace  X1_Pergunt With  aPerguntas[nxZ,2]
    Replace  X1_Variavl With  "Mv_Ch"+IIf(nxZ <=9,AllTrim(Str(nxZ)),Chr(nxZ + 55))
    Replace  X1_Tipo    With  aPerguntas[nxZ,3]
    Replace  X1_Tamanho With  aPerguntas[nxZ,4]
    Replace  X1_Decimal With  aPerguntas[nxZ,5]
    Replace  X1_GSC     With  aPerguntas[nxZ,6]
    Replace  X1_F3      With  aPerguntas[nxZ,8]
    Replace  X1_Var01   With  "Mv_Par"+StrZero(nxZ,2)
    If (aPerguntas[nxZ,6] == "C")
       For nxY := 9 To 13
           If (aPerguntas[nxZ,nxY] == "")
              Exit
           Else
              Do Case
                 Case ((nxY - 8) == 1)
                      Replace X1_Def01 With aPerguntas[nxZ,nxY]
                 Case ((nxY - 8) == 2)
                      Replace X1_Def02 With aPerguntas[nxZ,nxY]
                 Case ((nxY - 8) == 3)
                      Replace X1_Def03 With aPerguntas[nxZ,nxY]
                 Case ((nxY - 8) == 4)
                      Replace X1_Def04 With aPerguntas[nxZ,nxY]
                 Case ((nxY - 8) == 5)
                      Replace X1_Def05 With aPerguntas[nxZ,nxY]
              EndCase
           EndIf
        Next
    EndIf
Next

Return
