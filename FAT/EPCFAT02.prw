/*
+--------------------------------------------------------------------------+-------+-----------+
¦Programa  ¦EPCFAT02  ¦ Autor ¦ Crislei de Almeida Toledo                  | Data  ¦ 08.05.2006¦
+----------+---------------------------------------------------------------+-------+-----------+
¦Descriçào ¦ Rotina inclusao de titulos provisorios de Receitas                                ¦ 
+----------+-----------------------------------------------------------------------------------+
¦ Uso      ¦ ESPECIFICO PARA EPC                                                               ¦
+----------+-----------------------------------------------------------------------------------+
¦           ATUALIZACOES SOFRIDAS DESDE A CONSTRUCAO INICIAL                                   ¦
+------------+--------+------------------------------------------------------------------------+
¦PROGRAMADOR ¦ DATA   ¦ MOTIVO DA ALTERACAO                                                    ¦
+------------+--------+------------------------------------------------------------------------+
¦            ¦        ¦                                                                        ¦
+------------+--------+------------------------------------------------------------------------+
*/

#include "protheus.ch"
#include "topconn.ch"
#include "colors.ch"
#include "rwmake.ch"

User Function EPCFAT02()
*****************************************************************************************************
* Monta tela solicitando o numero da revisão para inclusao dos titulos provisórios
*
****

Private cRevEst   := Space(TamSx3("ZB_REVISAO")[1])
Private cContInic := Space(05)
Private cContFina := Space(05)

Define MSDialog oDlgRev Title OemToAnsi("Inclusão Títulos Provisórios") From 005,010 TO 280,255 Of oMainWnd Pixel
oGroupRev := TGroup():New(007,008,070,120,OemToAnsi("Parâmetros:"),,CLR_HBLUE,,.T.)

@ 013,013 SAY oSay1 Var OemToAnsi("Contrato Inicial") Of oDlgRev Pixel 
@ 023,013 GET oContInic Var cContInic Of oDlgRev Pixel 
@ 013,070 SAY oSay2 Var OemToAnsi("Contrato Final") Of oDlgRev Pixel 
@ 023,080 GET oContFina Var cContFina Of oDlgRev Pixel 
@ 043,013 SAY oSay3 Var OemToAnsi("Revisão do Estimado") Of oDlgRev Pixel 
@ 053,013 GET oRevEst Var cRevEst Of oDlgRev SIZE 020, 07 Pixel 

oContInic:CF3 := "SZ1"
oContInic:CRETF3 := "Z1_COD"
oContFina:CF3 := "SZ1"
oContFina:CRETF3 := "Z1_COD"

Define SButton From 120,030 Type 1 Action (FOk() .And. oDlgRev:End()) Enable Of oDlgRev
Define SButton From 120,070 Type 2 Action (oDlgRev:End()) Enable Of oDlgRev

ACTIVATE MSDIALOG oDlgRev CENTERED

Return


Static Function FOk()
****************************************************************************************************
* Chamada da funcao para inclusao dos titulos provisorios a receber
*
****

cCabecalho := OemToAnsi("Inclusão de títulos provisórios de Receita")
cMsgRegua  := "Processando..."

Processa( {|| FIncTit()} ,cCabecalho,cMsgRegua )

Return(.T.)



Static Function FIncTit()
*****************************************************************************************************
* Inclusao automatica do titulo de provisao de acordo com a revisao do estimado informada pelo usuario 
*
****

Local cQuery  := ""
Local cVencto := ""
Local nxI := 0

cQuery := " SELECT Z2_COD, Z1_CODCLI, Z1_LOJA, Z1_CLIENTE, Z1_DIAFAT, Z1_PRAZORE, Z1_MESVENC, ZB_ANO, ZB_TIPO, ZB_BENEFIC, SUM(ZB_MES01) MES01, SUM(ZB_MES02) MES02, " 
cQuery += " SUM(ZB_MES03) MES03, SUM(ZB_MES04) MES04, SUM(ZB_MES05) MES05, SUM(ZB_MES06) MES06, SUM(ZB_MES07) MES07, SUM(ZB_MES08) "
cQuery += " MES08, SUM(ZB_MES09) MES09, SUM(ZB_MES10) MES10, SUM(ZB_MES11) MES11, SUM(ZB_MES12) MES12 "
cQuery += " FROM " + RetSqlName("SZ2") + " SZ2 INNER JOIN " + RetSqlName("SZB") + " SZB ON ZB_CCUSTO  = Z2_SUBC AND "
cQuery += " ZB_REVISAO = '" + cRevEst + "' AND SZB.D_E_L_E_T_ <> '*' "
cQuery += " INNER JOIN " + RetSqlName("SZ1") + " SZ1 ON Z2_COD = Z1_COD AND SZ1.D_E_L_E_T_ <> '*' "
cQuery += " WHERE Z2_COD BETWEEN '" + cContInic + "' AND '" + cContFina + "' AND "
cQuery += " ZB_GRUPGER = '001001' AND "
cQuery += " SZ2.D_E_L_E_T_ <> '*' "
cQuery += " GROUP BY Z2_COD, Z1_CODCLI, Z1_LOJA, Z1_CLIENTE, Z1_DIAFAT, Z1_PRAZORE, Z1_MESVENC, ZB_ANO, ZB_TIPO, ZB_BENEFIC "

TcQuery cQuery ALIAS "ESTIM" NEW

dbSelectArea("ESTIM")
dbGoTop()

While !Eof()
   For nxI := 1 To 12
      cVar := "ESTIM->MES"+StrZero(nxI,2)
      If &cVar <> 0
         dbSelectArea("SE1")
         dbSeek(xFilial("SE1")+"EST"+ESTIM->Z2_COD+" "+StrZero(nxI,3)+"PR ")
                  
         If ESTIM->Z1_MESVENC $ "1"
            If nxI <> 12             
               cVencto := ESTIM->Z1_DIAFAT+"/"+StrZero(nxI+1,2)+"/"+ESTIM->ZB_ANO
            Else
               cVencto := ESTIM->Z1_DIAFAT+"/01/"+StrZero(Val(ESTIM->ZB_ANO)+1,4)
            EndIf
         Else
            cVencto := ESTIM->Z1_DIAFAT+"/"+StrZero(nxI,2)+"/"+ESTIM->ZB_ANO            
         EndIf

                 
         If RecLock("SE1",Eof())
            Replace E1_FILIAL  With xFilial("SE1")
            Replace E1_PREFIXO With "EST"
            Replace E1_NUM     With ESTIM->Z2_COD
            Replace E1_CODCONT With ESTIM->Z2_COD
            Replace E1_TIPO    With "PR"
            Replace E1_PARCELA With StrZero(nxI,3)
            Replace E1_NATUREZ With "20001"
            Replace E1_DATAREF With CTOD("01/"+StrZero(nxI,2)+"/"+ESTIM->ZB_ANO)
            Replace E1_CLIENTE With ESTIM->Z1_CODCLI
            Replace E1_LOJA    With ESTIM->Z1_LOJA
            Replace E1_NOMCLI  With ESTIM->Z1_CLIENTE
            Replace E1_EMISSAO With dDataBase
            Replace E1_EMIS1   With dDataBase
            Replace E1_VENCTO  With CTOD(cVencto)+Val(ESTIM->Z1_PRAZORE)
            Replace E1_VENCORI With CTOD(cVencto)+Val(ESTIM->Z1_PRAZORE)
            Replace E1_VENCREA With DataValida(CTOD(cVencto)+Val(ESTIM->Z1_PRAZORE))
            Replace E1_VALOR   With &cVar
            Replace E1_VLCRUZ  With &cVar
            Replace E1_SALDO   With &cVar
            Replace E1_HIST    With ESTIM->Z2_COD + " - " + MesExtenso(nxI) + "/" + ESTIM->ZB_ANO
            Replace E1_MOEDA   With 1
            Replace E1_STATUS  With "A"
            Replace E1_ORIGEM  With "FINA040"
            Replace E1_SITUACA With "0"
            Replace E1_FILORIG With xFilial("SE1")
            MsUnlock()
         EndIf
      EndIf
   Next nxI
   dbSelectArea("ESTIM")
   dbSkip()
End

dbSelectArea("ESTIM")
dbCloseArea()

Return