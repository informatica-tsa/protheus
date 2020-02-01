/*
+--------------------------------------------------------------------------+-------+-----------+
¦Programa  ¦TSAFAT01  ¦ Autor ¦ Crislei de Almeida Toledo                  | Data  ¦ 26.10.2006¦
+----------+---------------------------------------------------------------+-------+-----------+
¦Descriçào ¦ Rotina exclusao\inclusao de titulos provisorios de Receitas                       ¦ 
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

User Function TSAFAT01()

Private cContInic := Space(05)
Private cContFina := Space(05)
Private dDataInic := CTOD("")
Private dDataFina := CTOD("")
Private nRadOpc   := 0
Private nOpcao    := 1
Private oRadOpc

//Monta tela solicitando ao usuario o periodo de digitacao das NF's
Define MSDialog oDlgParam Title OemToAnsi("Parâmetros da Rotina") From 005,010 TO 280,255 Of oMainWnd Pixel

oGroupConf := TGroup():New(007,008,070,120,OemToAnsi("Parâmetros:"),,CLR_HBLUE,,.T.)

@ 013,013 SAY oSay1 Var OemToAnsi("Contrato Inicial") Of oDlgParam Pixel 
@ 023,013 GET oContInic Var cContInic Of oDlgParam Pixel 
@ 013,070 SAY oSay2 Var OemToAnsi("Contrato Final") Of oDlgParam Pixel 
@ 023,080 GET oContFina Var cContFina Of oDlgParam Pixel 

@ 043,013 SAY oSay3 Var OemToAnsi("Data Inicial") Of oDlgParam Pixel 
@ 053,013 GET oDataInic Var dDataInic Of oDlgParam Pixel 
@ 043,070 SAY oSay4 Var OemToAnsi("Data Final") Of oDlgParam Pixel 
@ 053,080 GET oDataFina Var dDataFina Of oDlgParam Pixel 


oContInic:CF3 := "SZ1"
oContInic:CRETF3 := "Z1_COD"
oContFina:CF3 := "SZ1"
oContFina:CRETF3 := "Z1_COD"

Define SButton From 120,030 Type 1 Action (SelectReg() .And. oDlgParam:End()) Enable Of oDlgParam
Define SButton From 120,070 Type 2 Action (oDlgParam:End()) Enable Of oDlgParam

ACTIVATE MSDIALOG oDlgParam CENTERED


Return



Static Function SelectReg()
****************************************************************************************************
* Selecao das Notas Fiscais digitadas no periodo definido pelo usuario
*
****

Local aCampos    := {}
Local aStruct    := {}
Local cQuery     := ""
Local nFreeze    := 0

Local ni := 0

Private lInverte := .T.
Private cMarca   := GetMark()
Private aHeader  := {}
Private bteste

Private aRotina :={{"Pesq"	,"AxPesq", 0, 1},; 
                   {"Visu","AxVisual", 0, 2}}  // aRotina é uma variável que é chamada no MsGetDB e deve ser declarada senão da pau!

dbSelectArea("SE1")
dbSetOrder(1)

Aadd(aStruct,{"E1_CONFERE","C",02,0})
Aadd(aStruct,{"E1_FILIAL" ,"C",02,0})
Aadd(aStruct,{"E1_PREFIXO","C",03,0})
Aadd(aStruct,{"E1_NUM"    ,"C",06,0})
Aadd(aStruct,{"E1_PARCELA","C",03,0})
Aadd(aStruct,{"E1_CODCONT","C",05,0})
Aadd(aStruct,{"E1_CLIENTE","C",06,0})
Aadd(aStruct,{"E1_LOJA"   ,"C",02,0})
Aadd(aStruct,{"A1_NOME"   ,"C",40,0})
Aadd(aStruct,{"E1_EMISSAO","D",08,0})
Aadd(aStruct,{"E1_VALOR"  ,"N",14,2})
Aadd(aStruct,{"E1_DATAREF","D",08,0})
Aadd(aStruct,{"E1_VENCTO" ,"D",08,0})

AADD(aCampos,{"E1_CONFERE",,"Ok"         ,"@!"})       
Aadd(aCampos,{"E1_CODCONT",,"Contrato"   ,PesqPict("SE1","E1_CODCONT")})
Aadd(aCampos,{"E1_PREFIXO",,"Prefixo"    ,PesqPict("SE1","E1_PREFIXO")})
Aadd(aCampos,{"E1_NUM"    ,,"Numero"     ,PesqPict("SE1","E1_NUM")}) 
Aadd(aCampos,{"E1_PARCELA",,"Parcela"    ,PesqPict("SE1","E1_PARCELA")})
Aadd(aCampos,{"A1_NOME"   ,,"Nome"       ,PesqPict("SA1","A1_NOME")})
Aadd(aCampos,{"E1_VALOR"  ,,"Valor"      ,PesqPict("SE1","E1_VALOR")})
Aadd(aCampos,{"E1_DATAREF",,"Data Ref."  ,PesqPict("SE1","E1_DATAREF")})
Aadd(aCampos,{"E1_VENCTO" ,,"Vencimento" ,PesqPict("SE1","E1_VENCTO")})
Aadd(aCampos,{"E1_EMISSAO",,"Emissao"    ,PesqPict("SE1","E1_EMISSAO")})

cFileWork := CriaTrab(aStruct,.T.)

USE &cFileWork ALIAS TRB EXCLUSIVE NEW
IndRegua("TRB",cFileWork,"E1_FILIAL+E1_PREFIXO+E1_NUM+E1_PARCELA",,,OemToAnsi("Selecionando Registros"))
                          
cQuery := "SELECT '' E1_CONFERE, E1_FILIAL, E1_PREFIXO, E1_NUM, E1_PARCELA, E1_CODCONT,E1_CLIENTE, E1_LOJA, A1_NOME, "
cQuery += "E1_EMISSAO, E1_VALOR,   E1_DATAREF, E1_VENCTO "

cQuery += " FROM " + RetSqlName("SE1") + " SE1 INNER JOIN " + RetSqlName("SA1") + " SA1 ON "
cQuery += " E1_CLIENTE = A1_COD  AND "
cQuery += " E1_LOJA    = A1_LOJA AND "
cQuery += " SA1.D_E_L_E_T_ <> '*' "
cQuery += " WHERE E1_CODCONT BETWEEN '" + cContInic + "' AND '" + cContFina + "' AND "   
cQuery += " E1_TIPO = 'PR' AND "
cQuery += " E1_PREFIXO = 'EST' AND "
cQuery += " E1_VENCREA BETWEEN '" + DTOS(dDataInic) + "' AND '" + DTOS(dDataFina) + "' AND "
cQuery += " SE1.D_E_L_E_T_ <> '*' "
cQuery += " ORDER BY E1_CODCONT, E1_PARCELA "

cQuery := ChangeQuery(cQuery)

dbUseArea(.T., "TOPCONN", TCGenQry(,,cQuery), 'QSE1', .F., .T.)

For ni := 1 to Len(aStruct)
   If aStruct[ni,2] != 'C'
     TCSetField('QSE1', aStruct[ni,1], aStruct[ni,2], aStruct[ni,3], aStruct[ni,4])
   Endif
Next

dbSelectArea("QSE1")
dbGoTop()

While !Eof()
   dbSelectArea("TRB")
   RecLock("TRB",.T.)
      For ni := 1 to QSE1->(FCount())
          TRB->(FieldPut(nI,QSE1->(FieldGet(ni))))
      Next
   MsUnLock()
   
   dbSelectArea("QSE1")
   dbSkip()
End
                                     
dbSelectArea("QSE1")
dbCloseArea()
              
dbSelectArea("TRB")
dbGoTop()
		
DEFINE MSDIALOG oDlg2 TITLE OemToAnsi("Titulos Provisórios de Contratos") From 9,0 To 40,120 OF oMainWnd
@ 017,015 SAY oSayPrinc Var OemToAnsi("Selecione os Títulos Provisórios a serem excluídos:") Of oDlg2 Pixel COLOR CLR_HBLUE

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Passagem do parametro aCampos para emular tamb‚m a markbrowse para o ³
//³ arquivo de trabalho "TRB".                                           ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

//oMark := MsSelect():New("TRB","E1_CONFERE","",aCampos,@lInverte,@cMarca,{35,1,143,315})
oMark := MsSelect():New("TRB","E1_CONFERE","",aCampos,@lInverte,@cMarca,{35,1,200,460})
oMark:oBrowse:lHasMark    := .T.
oMark:oBrowse:lCanAllMark := .T.
oMark:oBrowse:cToolTip := "Clique em 'Ok' para marcar/desmarcar todos" 
//oMark:oBrowse:bAllMark := {||FMarkTitu()}
//oMark:oBrowse:lModified := .T.

ACTIVATE MSDIALOG oDlg2 ON INIT FCriateBar(oDlg2,{|| nOpca := 1,FOk()},{|| nOpca := 3,FCancel()}) 
    
Return(.T.)


Static Function FOk()
***************************************************************************************************
* Chamada para tela de exclusao de titulos provisorios
*
****

cCabecalho := OemToAnsi("Exclusão de títulos provisórios de Receita")
cMsgRegua  := "Processando..."

Processa( {|| FExclTit()} ,cCabecalho,cMsgRegua )

dbSelectArea("TRB")
dbCloseArea()

oDlg2:End()

Return(.T.)                



Static Function FExclTit()
*********************************************************************************************
*
*
****

dbSelectArea("TRB")
dbGoTop()

While !Eof()
   If lInverte
      If TRB->E1_CONFERE <> cMarca
         cQuery := "UPDATE " + RetSqlName("SE1") + " SET D_E_L_E_T_ = '*', R_E_C_D_E_L_ = R_E_C_N_O_ "
         cQuery += "WHERE "
         cQuery += "E1_CODCONT = '" + TRB->E1_CODCONT + "' AND " 
         cQuery += "E1_PREFIXO = 'EST' AND E1_NUM     = '" + TRB->E1_NUM     + "' AND "
         cQuery += "E1_CLIENTE = '" + TRB->E1_CLIENTE + "' AND E1_LOJA    = '" + TRB->E1_LOJA    + "' AND "      
         cQuery += "E1_TIPO    = 'PR' AND E1_DATAREF = '" + DTOS(TRB->E1_DATAREF) + "' AND "
         cQuery += "E1_FILIAL  = '" + TRB->E1_FILIAL  + "'" // AND D_E_L_E_T_ <> '*' " 
         TcSqlExec(cQuery)
      EndIf
   Else
      If TRB->E1_CONFERE == cMarca
         cQuery := "UPDATE " + RetSqlName("SE1") + " SET D_E_L_E_T_ = '*', R_E_C_D_E_L_ = R_E_C_N_O_ "
         cQuery += "WHERE "
         cQuery += "E1_CODCONT = '" + TRB->E1_CODCONT + "' AND " 
         cQuery += "E1_PREFIXO = 'EST' AND E1_NUM     = '" + TRB->E1_NUM     + "' AND "
         cQuery += "E1_CLIENTE = '" + TRB->E1_CLIENTE + "' AND E1_LOJA    = '" + TRB->E1_LOJA    + "' AND "      
         cQuery += "E1_TIPO    = 'PR' AND E1_DATAREF = '" + DTOS(TRB->E1_DATAREF) + "' AND "
         cQuery += "E1_FILIAL  = '" + TRB->E1_FILIAL  + "'" // AND D_E_L_E_T_ <> '*' " 
         TcSqlExec(cQuery)
      EndIf
   EndIf
   dbSelectArea("TRB")
   dbSkip()
End   

Return



Static Function FCancel()
*********************************************************************************************
*
*
****

dbSelectArea("TRB")
dbCloseArea()

oDlg2:End()

Return



Static Function FCriateBar(oDlg2,bOk,bCancel)
***************************************************************************************************
* Mostra tela com informações das NF's
*
****

Local oBar, bSet15, bSet24, lOk, oBtOk, oBtCan
Local lVolta :=.f.

DEFINE BUTTONBAR oBar SIZE 25,25 3D TOP OF oDlg2

DEFINE BUTTON RESOURCE "S4WB005N"		OF oBar 		   ACTION NaoDisp()		TOOLTIP "Recortar"
DEFINE BUTTON RESOURCE "S4WB006N"		OF oBar 		   ACTION NaoDisp()		TOOLTIP "Copiar"
DEFINE BUTTON RESOURCE "S4WB007N"		OF oBar 		   ACTION NaoDisp()		TOOLTIP "Colar"
DEFINE BUTTON RESOURCE "S4WB008N"		OF oBar GROUP      ACTION Calculadora()	TOOLTIP "Calculadora"
DEFINE BUTTON RESOURCE "S4WB009N"		OF oBar 		   ACTION Agenda()		TOOLTIP "Agenda"
DEFINE BUTTON RESOURCE "S4WB016N"		OF oBar GROUP 	   ACTION HelProg()		TOOLTIP "Help Prog."

oBar:nGroups += 50
DEFINE BUTTON RESOURCE "S4WB011N"  		OF oBar GROUP	ACTION FPesqTit()	TOOLTIP OemToAnsi("Pesquisar Título")

oBar:nGroups += 8
DEFINE BUTTON oBtOk RESOURCE "OK" OF oBar GROUP ACTION ( lLoop:=lVolta,lOk:=Eval(bOk)) TOOLTIP "Ok - <Ctrl-O>"
SetKEY(15,oBtOk:bAction)
DEFINE BUTTON oBtCan RESOURCE "CANCEL" OF oBar ACTION ( lLoop:=.f.,Eval(bCancel),ButtonOff(bSet15,bSet24,.T.)) TOOLTIP "Cancelar - <Ctrl-X>"

SetKEY(24,oBtCan:bAction)
oDlg2:bSet15 := oBtOk:bAction
oDlg2:bSet24 := oBtCan:bAction
oBar:bRClicked := {|| AllwaysTrue()}

Return



Static Function FPesqTit()
****************************************************************************************************
* Pesquisa de NF's no browse
*
****

Local oCbxPesq 
Local oDlgPesq
Local oTextPesq
Private cCbxPesq  := ""
Private cTextPesq := Space(60)
Private aItens    := {}

Aadd(aItens,"Numero"         +Space(100)+"01")
Aadd(aItens,"Nome Fornecedor"+Space(100)+"02")
Aadd(aItens,"Contrato"       +Space(100)+"03")

Define MSDialog oDlgPesq Title OemToAnsi("Pesquisar Título") From 005,010 TO 165,450 Of oMainWnd Pixel
oGroupPesq := TGroup():New(003,005,058,220,OemToAnsi("Pesquisar por:"),,CLR_HBLUE,,.T.)
@ 020,013 MSCOMBOBOX oCbxPesq VAR cCbxPesq ITEMS aItens SIZE 140, 15 OF oDlgPesq PIXEL 
@ 040,013 GET oTextPesq Var cTextPesq Of oDlgPesq SIZE 180, 07 Pixel 
Define SButton From 065,140 Type 1 Action (FPesquisar() .And. oDlgPesq:End()) Enable Of oDlgPesq
Define SButton From 065,180 Type 2 Action (oDlgPesq:End()) Enable Of oDlgPesq

Activate MSDialog oDlgPesq Centered

Return



Static Function FPesquisar()
*****************************************************************************************************
* Monta tela com historico salarial do funcionario
*
****

cOpcPesq := Right(cCbxPesq,2)

Do Case
   Case cOpcPesq $ "01" // Numero do Titulo
        dbSelectArea("TRB")
        IndRegua("TRB",cFileWork,"E1_NUM",,,OemToAnsi("Selecionando Registros"))
        dbSeek(AllTrim(cTextPesq))
   Case cOpcPesq $ "02" // Nome Fornecedor
        dbSelectArea("TRB")
        IndRegua("TRB",cFileWork,"A1_NOME",,,OemToAnsi("Selecionando Registros"))
        dbSeek(AllTrim(cTextPesq))
   Case cOpcPesq $ "03" // Contrato
        dbSelectArea("TRB")
        IndRegua("TRB",cFileWork,"E1_CODCONT",,,OemToAnsi("Selecionando Registros"))
        dbSeek(AllTrim(cTextPesq))
EndCase

Return(.T.)