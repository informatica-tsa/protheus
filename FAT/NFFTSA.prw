#Include "rwmake.ch"      

/*
+-----------------+------------------------+----------------------+
|Programa: NFFTSA | Autor: Leonardo Alves  |Data: 13/03/2006      |
+-----------+-----------------------------------------------------+
|Descri��o: |Nota Fiscal Fatura da TSA.                           |
+-----------+-----------------------------------------------------+
|Uso:       |Especifico da TSA.                                   |
+-----------------------------------------------------------------+
|*************** ALTERA��ES APOS O DESENVOLVIMENTO ***************|  
+-----------------------------------------------------------------+
|Data     |Desenvovedor  |Motivo da Altera��o                     |
+---------+--------------+----------------------------------------+
|         |              |                                        |
+---------+--------------+----------------------------------------+
*/

User Function NFFTSA()       

/***********************************************************************
 * Declaracao de variaveis utilizadas no programa atraves da funcao    *
 * SetPrvt, que criara somente as variaveis definidas pelo usuario,    *
 * identificando as variaveis publicas do sistema utilizadas no codigo *
 ***********************************************************************/

SetPrvt("CBTXT,CBCONT,NORDEM,ALFA,Z,M")
SetPrvt("TAMANHO,LIMITE,TITULO,CDESC1,CDESC2,CDESC3")
SetPrvt("CNATUREZA,ARETURN,NOMEPROG,CPERG,NLASTKEY,LCONTINUA")
SetPrvt("NLIN,WNREL,NVALIRRF,NVALFATU,NTAMNF,CSTRING")
SetPrvt("CNOTAINIC,CNOTAFINA,NLININI,XNUM_NF,XSERIE,XEMISSAO")
SetPrvt("XTOT_FAT,XBASEISS,XALIQISS,XVALISS,XLOJA,XFRETE")
SetPrvt("XSEGURO,XDESPESA,XBASE_ICMS,XBASE_IPI,XVALOR_ICMS,XICMS_RET")
SetPrvt("XVALOR_IPI,XVALOR_MERC,XNUM_DUPLIC,XCOND_PAG,XPBRUTO,XPLIQUI")
SetPrvt("XTIPO,XESPECIE,XVOLUME,XPED_VEND,XITEM_PED,XNUM_NFDV")
SetPrvt("XPREF_DV,XICMS,XCOD_PRO,XQTD_PRO,XPRE_UNI,XPRE_TAB")
SetPrvt("XIPI,XVAL_IPI,XDESC,XVAL_DESC,XVAL_DESC1,XVAL_MERC")
SetPrvt("XTES,XCF,XICMSOL,XICM_PROD,CPEDATU,CITEMATU")
SetPrvt("XPESO_PRO,XPESO_UNIT,XDESCRICAO,XUNID_PRO,XCOD_TRIB,XMEN_TRIB")
SetPrvt("XCOD_FIS,XCLAS_FIS,XMEN_POS,XISS,XTIPO_PRO,XLUCRO")
SetPrvt("XCLFISCAL,XPESO_LIQ,I,NPERCISS,XPESO_LIQUID,XPED")
SetPrvt("XPESO_BRUTO,XP_LIQ_PED,XCLIENTE,XCONTRATO,XIMPDET,XTIPO_CLI")
SetPrvt("XCOD_MENS,XCOD_MEN2,XREFER,XMENSAGEM,XMENSAGEM2,XMENSAGEM3,XMENSAGEM4,XMENSAGEM5,XTPFRETE")
SetPrvt("XCONDPAG,XCOD_VEND,XDESC_NF,XDESC_PAG,XPED_CLI,XDESC_PRO")
SetPrvt("XDESC_COM,J,XNOMCTR,XCONTA,XNOMCONTA,XCONTCLI")
SetPrvt("XCOD_CLI,XNOME_CLI,XEND_CLI,XBAIRRO,XCEP_CLI,XCOB_CLI")
SetPrvt("XREC_CLI,XMUN_CLI,XPRC_CLI,XEST_CLI2,XEST_CLI,XCGC_CLI")
SetPrvt("XINSC_CLI,XTRAN_CLI,XTEL_CLI,XFAX_CLI,XSUFRAMA,XCALCSUF")
SetPrvt("XBANCO,XIMPTOT,ZFRANCA,XVENDEDOR,XBSICMRET,XNOME_TRANSP")
SetPrvt("XEND_TRANSP,XMUN_TRANSP,XEST_TRANSP,XVIA_TRANSP,XCGC_TRANSP,XTEL_TRANSP")
SetPrvt("XPARC_DUP,XVENC_DUP,XVALOR_DUP,XNOMEBCO,XENDBCO,XAGEBCO")
SetPrvt("XCONBCO,XNATUREZA,NOPC,CCOR,NTAMEXTE,NLINAUX")
SetPrvt("APERGUNTAS,NXZ,NXY,NTAMDET,")


CbTxt     := ""
CbCont    := ""
nOrdem    := 0
Alfa      := 0
Z         := 0
M         := 0
Tamanho   := "P"
limite    := 80
titulo    := "Nota Fiscal Fatura - NFFTSA"
cDesc1    := PADC("Este programa ira emitir a Nota Fiscal Fatura",74)
cDesc2    := ""
cDesc3    := PADC("Referente a empresa TSA.",74)
cNatureza := ""
aReturn   := { "Especial", 1,"Administracao", 1, 2, 1,"",1 }
NomeProg  := "NFFTSA"
cPerg     := "NFFTSA"
nLastKey  := 0
lContinua := .T.
nLin      := 0
wnrel     := "NFFTSA"                         
xCbanco   := ""
xAgbanco  := ""

nValIRRF := 0
nValFatu := 0

nTamNf    := 70      



Pergunte(cPerg,.F.)                

cString := "SF2"


wnrel := SetPrint(cString,wnrel,cPerg,Titulo,cDesc1,cDesc2,cDesc3,.F.,,.F.,Tamanho)

If nLastKey == 27
   Return
Endif

SetDefault(aReturn,cString)

If nLastKey == 27
   Return
Endif

cNotaInic := mv_par01
cNotaFina := mv_par02

VerImp()

RptStatus({|| RptDetail()})

Return



Static Function RptDetail()
/*****************************************************************************
*
*
*******/

Local nI2 := 0
Local I := 1

SetRegua(Val(cNotaFina)-Val(cNotaInic))

dbSelectArea("SF2")
dbSetOrder(1)
Set Softseek On
dbSeek(xFilial("SF2")+cNotaInic)
Set Softseek Off

While (! Eof()) .And. (SF2->F2_Filial == xFilial("SF2")) .And. (SF2->F2_Doc <= cNotaFina)

    If !(ALLTRIM(SF2->F2_Serie) $ "U/SF")
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

    xNUM_NF     := SF2->F2_DOC              // Numero
    xSERIE      := SF2->F2_SERIE            // Serie
    xEMISSAO    := SF2->F2_EMISSAO          // Data de Emissao
    xTOT_FAT    := SF2->F2_VALFAT           // Valor Total da Fatura
    xBASEISS    := SF2->F2_BASEISS          // Valor Base do ISS
    xALIQISS    := (SF2->F2_VALISS/SF2->F2_BASEISS)*100
    xVALISS     := SF2->F2_VALISS           // Valor do Iss

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

    dbSelectArea("SD2")                    
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
         Aadd(xQTD_PRO   ,SD2->D2_QUANT)      
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

         dbSelectArea("SB1")                      
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
            xIMPDET     := SC5->C5_DESC
            xTIPO_CLI   := SC5->C5_TIPOCLI              // Tipo de Cliente
            xCOD_MENS   := SC5->C5_MENPAD               // Codigo da Mensagem Padrao
            xREFER      := SC5->C5_REFER                // Referencia do contrato
            xMENSAGEM   := SC5->C5_MENNOTA              // Mensagem para a Nota Fiscal
            xMENSAGEM2  := SC5->C5_MENNOT4
            xMENSAGEM3  := SC5->C5_MENNOT5
            xMENSAGEM4  := SC5->C5_MENNOT6
            xMENSAGEM5  := SC5->C5_MENNOT7
            
            xTPFRETE    := SC5->C5_TPFRETE              // Tipo de Entrega
            xCONDPAG    := SC5->C5_CONDPAG              // Condicao de Pagamento
            xTXTVCTO    := SC5->C5_TXTVCTO              //Texto para condicao de pagamento //CRISLEI - 07/11/06 - TRATAMENTO DE NF CONTRA APRESENTACAO
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
         dbSelectArea("SC6")                    
         dbSetOrder(1)
         dbSeek(xFilial("SC6")+xPED_VEND[I]+xITEM_PED[I])

         AADD(xPED_CLI , SC6->C6_PEDCLI)
         AADD(xUNID_PRO, SC6->C6_UM)
         AADD(xDESC_PRO, SC6->C6_DESCRI)
         AADD(xVAL_DESC, SC6->C6_VALDESC)
    Next

    DbSelectArea("SZ1")
    DbSetOrder(1)
    If DbSeek(xFilial("SZ1")+xCONTRATO)
       xNOMCTR:=Z1_NOME
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

         dbSelectArea("SA1")                 
         dbSetOrder(1)
         dbSeek(xFilial("SA1")+xCLIENTE+xLOJA)

         xCOD_CLI  := SA1->A1_COD               // Codigo do Cliente
         xNOME_CLI := SA1->A1_NOME              // Nome
         xEND_CLI  := SA1->A1_END               // Endereco
         xBAIRRO   := SA1->A1_BAIRRO            // Bairro
         xCEP_CLI  := SA1->A1_CEP               // CEP
         xCOB_CLI  := SA1->A1_ENDCOB            // Endereco de Cobranca
         xREC_CLI  := SA1->A1_ENDENT            // Endereco de Entrega
//         xMUN_CLI  := Tabela("89",SA1->A1_MUN)  // Municipio
         xMUN_CLI  := Tabela("89",SA1->A1_MUNISS)  // Municipio
         xPRC_CLI  := SA1->A1_PRPAGTO           // Praca Pagto
         xEST_CLI2 := SA1->A1_UFPGTO            // Estado da Praca de Pagto
         xEST_CLI  := SA1->A1_EST               // Estado
         xCGC_CLI  := SA1->A1_CGC               // CGC
         xINSC_CLI := SA1->A1_INSCR             // Inscricao estadual
         xTRAN_CLI := SA1->A1_TRANSP            // Transportadora
         xTEL_CLI  := SA1->A1_TEL               // Telefone
         xFAX_CLI  := SA1->A1_FAX               // Fax
         xSUFRAMA  := SA1->A1_SUFRAMA           // Codigo Suframa
         xCALCSUF  := SA1->A1_CALCSUF           // Calcula Suframa
         xBANCO    := SA1->A1_BCO1              // Banco de Movimento do Cliente
         xIMPTOT   := IIf(SA1->A1_TOTNF=="S",.T.,.F.)           // Imprime totalizacao na NF
         xCBANCO   := SA1->A1_CBANCO
         XAGBANCO  := SA1->A1_AGBANCO
         
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

         dbSelectArea("SA2")                 
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
         xPRC_CLI  := SA2->A2_MUN
         xEST_CLI  := SA2->A2_EST             // Estado
         xEST_CLI2 := SA2->A2_EST             // Estado da Praca de Pagto
         xCGC_CLI  := SA2->A2_CGC             // CGC
         xINSC_CLI := SA2->A2_INSCR           // Inscricao estadual
         xTRAN_CLI := SA2->A2_TRANSP          // Transportadora
         xTEL_CLI  := SA2->A2_TEL             // Telefone
         xFAX_CLI  := SA2->A2_FAX             // Fax
    Endif

    xVENDEDOR:= {}                           // Nome do Vendedor
    I        := 1
    J        := Len(xCOD_VEND)

    For I := 1 to J
       dbSelectArea("SA3")                    
       dbSetOrder(1)
       dbSeek(xFilial("SA3")+xCOD_VEND[I])
       Aadd(xVENDEDOR,SA3->A3_NREDUZ)
    Next

    If (xICMS_RET >0)                            // Apenas se ICMS Retido > 0
          dbSelectArea("SF3")                    
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

    dbSelectArea("SA4")                  
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
       xCONBCO := (AllTrim(SA6->A6_NUMCON)+"-"+SA6->A6_DIGCC)
    EndIf

    dbSelectArea("SE1")                   
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

    dbSelectArea("SF4")           //Tipos de Entrada e Saida
    DbSetOrder(1)
    dbSeek(xFilial("SF4")+xTES[1])

    xNATUREZA := SF4->F4_TEXTO  //Natureza da Operacao

    ImpriC()

    IncRegua()                    

    nLin:=0
    dbSelectArea("SF2")
    nValFatu := 0
    dbSkip()                      
EndDo

dbSelectArea("SF2")
Retindex("SF2")
dbSelectArea("SF1")
Retindex("SF1")
dbSelectArea("SD2")
Retindex("SD2")
dbSelectArea("SD1")
Retindex("SD1")

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



Static Function ImpriC()
/*********************************************
*
*
******/

//@ 01,00 PSAY Chr(27) + "@" //Boot na Impressora

//@ 00,50 PSAY Chr(18)

//@ 05,08 PSAY xNUM_NF

@ 01, 130 PSAY xEMISSAO

If (Len(xVALOR_DUP) > 0)
   nValFatu := nValFatu + (xValor_Merc) 
   @ 08,26  PSAY xNUM_DUPLIC
   @ 08,55  PSAY nValFatu Picture "@E 999,999,999.99"
   @ 08,83  PSAY xNUM_DUPLIC + " " + xPARC_DUP[1]
   @ 08,110 PSAY nValFatu Picture "@E 999,999,999.99"
   //@ 08,140 PSAY xVENC_DUP[1]
   If AllTrim(xTXTVCTO) == ""
      @ 08,140 PSAY xVENC_DUP[1]
   Else
      @ 08,140 PSAY xTXTVCTO
   EndIf
EndIf

//@ 11,140 PSAY xNUM_NF

If ! Empty( nValIrrf)
   @ 12,38 PSAY TransForm(nValIrrf,"@E 999,999.99") + " REF. A IRRF"
EndIf                                                           

@ 15,36  PSAY xNOME_CLI
@ 16,36  PSAY Left(xEND_CLI,50)
@ 17,36  PSAY xMUN_CLI
@ 17,127 PSAY xEST_CLI

@ 18,36  PSAY xPRC_CLI
@ 18,127 PSAY xEST_CLI2

@ 19,36  PSAY xCGC_CLI Picture  "@R 99.999.999/9999-99"
@ 19,105 PSAY xINSC_CLI

nTamExte := Len(Extenso(nValFatu))

@ 21,35 PSAY AllTrim(SubStr(Extenso(nValFatu),1,120))

@ 22,35 PSAY AllTrim(SubStr(Extenso(nValFatu),121,120))

@ 23,35 PSAY AllTrim(SubStr(Extenso(nValFatu),241,120))

@ 32,17  PSAY xCONTRATO + " - " + xCONTCLI
@ 32,105 PSAY "CL: " + xCLIENTE + "/" + xLOJA

@ 33,17 PSAY xCONTA + " - " + xNOMCONTA

nLinAux := 34

If ! Empty(SubStr(xREFER,1,135))
   @ nLinAux,17 PSAY SubStr(xREFER,1,135)
   nLinAux++
   If ! Empty(SubStr(xREFER,136,135))
      @ nLinAux,17 PSAY SubStr(xREFER,136,135)
      nLinAux++
      If ! Empty(SubStr(xREFER,271,135))
         @ nLinAux,17 PSAY SubStr(xREFER,271,135)
         nLinAux++
         If ! Empty(SubStr(xREFER,406,135))
            @ nLinAux,17 PSAY SubStr(xREFER,406,135)
            nLinAux++
         EndIf
      EndIF
   EndIf
EndIf                   

If xIMPDET == "S"
   ImpDet()
EndIf

nLinAux++

If ! Empty(xNOMEBCO)
   @ nLinAux,17 PSAY xNOMEBCO
   nLinAux ++
   @ nLinAux,17 PSAY xENDBCO
   nLinAux++
   @ nLinAux,17 PSAY "Agencia: " + xAGEBCO
   nLinAux++
   @ nLinAux,17 PSAY "CONTA CORRENTE - " + xCONBCO
Else
   @ nLinAux,17 PSAY xMENSAGEM
   nLinAux++
EndIF
nLinAux++
nLinAux++
 
If ! Empty(SubStr(xMensagem2,1,120))
   @ nLinAux,17 PSAY SubStr(xMensagem2,1,120)
   nLinAux++
EndIf

If ! Empty(SubStr(xMensagem3,1,120))
   @ nLinAux,17 PSAY SubStr(xMensagem3,1,120)
   nLinAux++
Endif

If ! Empty(SubStr(xMensagem4,1,120))
   @ nLinAux,17 PSAY SubStr(xMensagem4,1,120)
   nLinAux++
Endif

If ! Empty(SubStr(xMensagem5,1,120))
   @ nLinAux,17 PSAY SubStr(xMensagem5,1,120)
   nLinAux++
Endif

If xIMPTOT
   @ nLinAux,17 PSAY "VALOR BRUTO.........................." + TransForm(nValFatu,"@E 9,999,999.99")
   nLinAux++
   @ nLinAux,17 PSAY "IRRF................................." + TransForm(nValIrrf,"@E 9,999,999.99")
   nLinAux++
   @ nLinAux,17 PSAY "                                      ------------"
   nLinAux++
   @ nLinAux,17 PSAY "TOTAL................................" + TransForm(nValFatu-nValIrrf,"@E 9,999,999.99")
   nLinAux++
EndIf
@ 55,12  PSAY xNUM_NF
@ 55,45  PSAY TransForm(nValFatu,"@E 9,999,999.99")
@ 55,78  PSAY TransForm(xVALISS,"@E 9,999,999.99")
@ 55,100 PSAY TransForm(Round(xAliqISS,0),"@E 999")+"%"
@ 55,138 PSAY TransForm(nValFatu,"@E 9,999,999.99")

@ 59,08 PSAY AllTrim(xNUM_NF)

@ 66,00 PSAY " "

SETPRC(0,0)

nValIrrf:=0

Return .T.



Static Function IMPDET()
/***********************************************
* Impressao de Linhas de Detalhe da Nota Fiscal
*
*****/

Local I := 1
Local J := 1

nTamDet := 60 - nLinAux /*Tamanho da Area de Detalhe*/

For I := 1 to nTamDet
	If I <= Len(xCOD_PRO)
   	@ nLinAux,15 PSAY Alltrim(xDESCRICAO[I])
      @ nLinAux,58 PSAY TransForm(xVAL_MERC[I],"@E 999,999.99")
   Endif
   nLinAux := nLinAux + 1
Next

Return



Static Function TestaSX1()
/************************************************************
*
*
***********/

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