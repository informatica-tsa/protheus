#INCLUDE "totvs.ch"
#INCLUDE "protheus.ch"
#INCLUDE "rwmake.ch"

//-------------------------------------------------------------------
/* {Protheus.doc} MTA131C8
Ponto de Entrada Gera��o de Cota��o - acrescenta informa��e Dta Entrega / Projeto e Tarefa
na Cota��o SC8

@protected TSA
@author    Alex T. Souza
@since     16/09/2019

Alteracoes Realizadas desde a Estruturacao Inicial
Data       Programador     Motivo
/*/
//-------------------------------------------------------------------
User Function MTA131C8()
Local oModFor := PARAMIXB[1]

oModFor:LoadValue("C8_ZDTENT"	,SC1->C1_ZDTENT)
oModFor:LoadValue("C8_ZPRJ"		,SC1->C1_ZPRJ)
oModFor:LoadValue("C8_ZTARE"	,SC1->C1_ZTARE)

Return 
