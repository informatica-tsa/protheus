/*
+--------------------------------------------------------------------------+-------+-----------+
¦Programa  ¦EPCPMS10  ¦ Autor ¦ Crislei de Almeida Toledo                  | Data  ¦ 29.05.2006¦
+----------+---------------------------------------------------------------+-------+-----------+
¦Descriçào ¦ Gatilho executado a partir do numero da OS para buscar dados do projeto de OS '00'¦ 
¦          ¦ TRATAMENTO DE PROJETOS GUARDA-CHUVA                                               | 
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

#include "rwmake.ch"
#include "protheus.ch"

User Function EPCPMS10()

Local   aArqAnt := {Alias(), IndexOrd(), Recno()}
Private cRet  := Space(10)


If M->AF8_X_OS $ "00" .Or. ;
   !(M->AF8_TIPOPJ $ "P")
   cRet := AllTrim(M->AF8_PROJET) + M->AF8_X_OS
   Return(cRet)
EndIf

FTela()

dbSelectArea(aArqAnt[01])
dbSetOrder(aArqAnt[02])
dbGoTo(aArqAnt[03])

Return(cRet)


Static Function FTela()
*****************************************************************************************************
* Chama tela para para usuario escolher o projeto que sera o guarda-chuva
*
****

Local aArqAF8   := {"AF8", AF8->(IndexOrd()), AF8->(Recno())}
Private cMainProj := Space(10)

Define MSDialog oDlgPrj Title OemToAnsi("Inclusão Projeto Guarda-Chuva") From 005,010 TO 160,255 Of oMainWnd Pixel
oGroupRev := TGroup():New(007,008,050,120,OemToAnsi("Selecione o Projeto Principal:"),,CLR_HBLUE,,.T.)

@ 013,013 SAY oSay1 Var OemToAnsi("Projeto") Of oDlgPrj Pixel 
@ 023,013 GET oMainProj Var cMainProj Of oDlgPrj Pixel 

oMainProj:CF3 := "EPCAF8"
oMainProj:CRETF3 := "AF8_PROJET"

Define SButton From 060,030 Type 1 Action (FOk() .And. oDlgPrj:End()) Enable Of oDlgPrj
Define SButton From 060,070 Type 2 Action (oDlgPrj:End()) Enable Of oDlgPrj

ACTIVATE MSDIALOG oDlgPrj CENTERED


dbSelectArea(aArqAF8[01])
dbSetOrder(aArqAF8[02])
dbGoTo(aArqAF8[03])

Return


Static Function FOk()
*************************************************************************************************
* Executa o gatilho e preenche os campos de acordo com os dados do projeto selecionado
*
****

Local cOsDigit := ""
Local nxi := 0 

cRet := SubStr(cMainProj,1,5) + M->AF8_X_OS

cOsDigit := M->AF8_X_OS

dbSelectArea("AF8")
dbSetOrder(1)
dbSeek(xFilial("AF8")+cMainProj)

For nxi := 1 to FCount()
	cCmp:="M->"+AF8->(FieldName(nXi))
	&cCmp:=AF8->(FieldGet(nXi))	
Next nxi

M->AF8_X_OS := cOsDigit


Return(.T.)