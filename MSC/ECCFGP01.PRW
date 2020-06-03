#INCLUDE "PROTHEUS.CH"

/*
+------------+----------+--------------------------+--------+------------------+
| Programa   | ECCFGP01 | Ederson Colen            |  Data  | 28/02/2020       |
+------------+----------+--------------------------+--------+------------------+
| Descricao  | Atualiza campos de Cargo                                        |
+------------+-----------------------------------------------------------------+
| Uso        | Especifico                                                      |
+------------+-----------------------------------------------------------------+
|                    Modificacoes Apos Desenvolvimento Inicial                 |
+---------+-------------+------------------------------------------------------+
|  Data   | Responsavel | Motivo                                               |
|         |             |                                                      |
+---------+-------------+------------------------------------------------------+
*/

User Function ECCFGP01()

Local aTabCarg  := {}
Local nXX       := 0
Local cQuery    := ""
Local cEmpAux   := ""
Local aRetF     := {}
Local aEmpProc  := {}
Local nXT       := 0
Local nPosEmp   := 0
Local nXJ       := 0
Local nXX       := 0

AADD(aTabCarg,{"ABO","ABO_ZCARGO","ABO_CARGO"})
AADD(aTabCarg,{"ABQ","ABQ_ZCARGO","ABQ_CARGO"})
AADD(aTabCarg,{"AC8","AC8_ZCARGO","AC8_CARGO"})
AADD(aTabCarg,{"AO3","AO3_ZCARGO","AO3_CARGO"})
AADD(aTabCarg,{"MA8","MA8_ZCARGO","MA8_CARGO"})
AADD(aTabCarg,{"NQ3","NQ3_ZCUSER","NQ3_CUSER"})
AADD(aTabCarg,{"NT9","NT9_ZCRGDP","NT9_CCRGDP"})
AADD(aTabCarg,{"RA5","RA5_ZCARGO","RA5_CARGO"})
AADD(aTabCarg,{"RA8","RA8_ZCARGO","RA8_CARGO"})
AADD(aTabCarg,{"RB7","RB7_ZCARGO","RB7_CARGO"})
AADD(aTabCarg,{"RBH","RBH_ZCARGO","RBH_CARGO"})
AADD(aTabCarg,{"RBT","RBT_ZCARGO","RBT_CARGO"})
AADD(aTabCarg,{"RC6","RC6_ZCARGO","RC6_CARGO"})
AADD(aTabCarg,{"RI6","RI6_ZCARGO","RI6_CARGO"})
AADD(aTabCarg,{"RIE","RIE_ZCARGO","RIE_CARGO"})
AADD(aTabCarg,{"RS8","RS8_ZDCCAR","RS8_ADCCAR"})
AADD(aTabCarg,{"SA3","A3_ZCARGO","A3_CARGO"})
AADD(aTabCarg,{"SQ3","Q3_ZCARGO","Q3_CARGO"})
AADD(aTabCarg,{"SQ4","Q4_ZCARGO","Q4_CARGO"})
AADD(aTabCarg,{"SQ5","Q5_ZCARGO","Q5_CARGO"})
AADD(aTabCarg,{"SQA","QA_ZCARGO","QA_CARGO"})
AADD(aTabCarg,{"SQG","QG_ZCODFUN","QG_CODFUN"})
AADD(aTabCarg,{"SQQ","QQ_ZCARGO","QQ_CARGO"})
AADD(aTabCarg,{"SR7","R7_ZECARGO","R7_ECARGO"})
AADD(aTabCarg,{"SR7","R7_ZCARGO","R7_CARGO"})
AADD(aTabCarg,{"SRA","RA_ZCARGO","RA_CARGO"})
AADD(aTabCarg,{"SRJ","RJ_ZCARGO","RJ_CARGO"})
AADD(aTabCarg,{"SUM","UM_ZCARGO","UM_CARGO"})
AADD(aTabCarg,{"SV7","V7_ZCARG","V7_CARG"})
AADD(aTabCarg,{"TFF","TFF_ZCARGO","TFF_CARGO"})
AADD(aTabCarg,{"TWN","TWN_ZCARGO","TWN_CARGO"})

cEmpAux := cEmpAnt

aRetE := FWAllGrpCompany()

For nXJ := 1 To Len(aRetE)
		
    cEmpAnt := aRetE[nXJ]

    For nXX := 1 To Len(aTabCarg)

        If TCCanOpen(RetSqlName(aTabCarg[nXX,01]))
             cQuery := "UPDATE " + RetSqlName(aTabCarg[nXX,01])+" SET "+aTabCarg[nXX,02]+" = "+aTabCarg[nXX,03]
            TCSQLEXEC(cQuery)
        EndIf

    Next nXX

Next nXJ

cEmpAnt := cEmpAux

Return