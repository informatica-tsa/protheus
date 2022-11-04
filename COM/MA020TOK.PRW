#INCLUDE "totvs.ch"
#INCLUDE "protheus.ch"
#INCLUDE "rwmake.ch"

//-------------------------------------------------------------------
/* {Protheus.doc} MA020TOK,MA020ALT

Eventos
@protected TSA
@author    Thiago Santos
@since     01/08/2022

Alteracoes Realizadas desde a Estruturacao Inicial
Data       Programador     Motivo
/*/
//-------------------------------------------------------------------

User Function MA020TOK()
    Local lExecuta := ValidaCgc()
Return (lExecuta)

User Function MA020ALT()
    Local lExecuta := ValidaCgc()
Return (lExecuta)

static Function ValidaCgc
    Local lExecuta := .T.// Validações do usuário para exclusão do fornecedor

    if Alltrim(M->A2_EST) != "EX"
        if empty(M->A2_CGC) 
            lExecuta := .F.
            MsgAlert("CNPJ Obrigatorio para fornecedor nacional", "Campo não preenchido.")
        EndIf 
    EndIf 
Return (lExecuta)
