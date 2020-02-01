#Include "protheus.ch"

User Function UserProj()
****************************************************************************************************
* Faz o Vinculo do usuário X Projeto
*
******
/*				   {"Visualizar" ,"AxVisual", 0, 2},; 
				   {"Incluir"	 ,"Axinclui", 0, 3},; 
                   {"Alterar"	 ,"AxAltera", 0, 4},; 
                   {"Excluir"	 ,"AxExclui", 0, 5},; */


Private aRotina :={{"Pesquisa"	 ,"AxPesq"  , 0, 1},; 
                   {"Adic.Padrão","U_SeleReg" , 0, 6}}
Private aCores  := PmsAF8Color()                     
dbSelectArea("AF8")
dbSetOrder(1)

mBrowse(06,08,22,71,"AF8") // variaveis aPos, cCadastro, aRotina utilizadas


Return()



User Function SeleReg()
****************************************************************************************************
* Selecao das Notas Fiscais digitadas no periodo definido pelo usuario
*
****

Local aCampos    := {}
Local aStru     := {}
Local cQuery     := ""
Local nFreeze    := 0
Local ni := 0

Private lInverte := .T.
Private cMarca   := GetMark()
Private aHeader  := {}


AADD(aStru,{"AE8_OK"    ,"C",02,00})       
Aadd(aStru,{"AE8_RECURS","C",06,00})
Aadd(aStru,{"AE8_DESCRI","C",40,00})
Aadd(aStru,{"AE8_ESTRUT","C",01,00})
Aadd(aStru,{"AE8_DOCUME","C",01,00})
Aadd(aStru,{"AE8_GERSC" ,"C",01,00})
Aadd(aStru,{"AE8_GERSA" ,"C",01,00})
Aadd(aStru,{"AE8_GEROP" ,"C",01,00})
Aadd(aStru,{"AE8_GERCP" ,"C",01,00})
Aadd(aStru,{"AE8_GEREMP","C",01,00})
Aadd(aStru,{"AE8_CONFIR","C",01,00})
Aadd(aStru,{"AE8_NFE"   ,"C",01,00})
Aadd(aStru,{"AE8_REQUIS","C",01,00})
Aadd(aStru,{"AE8_DESP"  ,"C",01,00})
Aadd(aStru,{"AE8_RECEI" ,"C",01,00})
Aadd(aStru,{"AE8_APTMRE","C",01,00})
Aadd(aStru,{"AE8_NFS"   ,"C",01,00})
Aadd(aStru,{"AE8_MOVBAN","C",01,00})

AADD(aCampos,{"AE8_OK"     ,,"OK"          ,"@!"})       
Aadd(aCampos,{"AE8_RECURS" ,,"Cod Usuário" ,PesqPict("AE8","AE8_RECURS")})
Aadd(aCampos,{"AE8_DESCRI" ,,"Nome Recurso",PesqPict("AE8","AE8_DESCRI")})            
Aadd(aCampos,{"AE8_ESTRUT" ,,"Estrutura"   ,PesqPict("AE8","AE8_ESTRUT")})
Aadd(aCampos,{"AE8_DOCUME" ,,"Doc"         ,PesqPict("AE8","AE8_DOCUME")})
Aadd(aCampos,{"AE8_GERSC"  ,,"SC"          ,PesqPict("AE8","AE8_GERSC")})
Aadd(aCampos,{"AE8_GERSA"  ,,"SA"          ,PesqPict("AE8","AE8_GERSA")})
Aadd(aCampos,{"AE8_GEROP"  ,,"OP"          ,PesqPict("AE8","AE8_GEROP")})
Aadd(aCampos,{"AE8_GERCP"  ,,"CP"          ,PesqPict("AE8","AE8_GERCP")})
Aadd(aCampos,{"AE8_GEREMP" ,,"EMP"         ,PesqPict("AE8","AE8_GEREMP")})
Aadd(aCampos,{"AE8_CONFIR" ,,"CONFIR"      ,PesqPict("AE8","AE8_CONFIR")})
Aadd(aCampos,{"AE8_NFE"    ,,"NFE"         ,PesqPict("AE8","AE8_NFE")})
Aadd(aCampos,{"AE8_REQUIS" ,,"REQ"         ,PesqPict("AE8","AE8_REQUIS")})
Aadd(aCampos,{"AE8_DESP"   ,,"DESP"        ,PesqPict("AE8","AE8_DESP")})
Aadd(aCampos,{"AE8_RECEI"  ,,"RECEITA"     ,PesqPict("AE8","AE8_RECEI")})
Aadd(aCampos,{"AE8_APTMRE" ,,"RE"          ,PesqPict("AE8","AE8_APTMRE")})
Aadd(aCampos,{"AE8_NFS"    ,,"NFS"         ,PesqPict("AE8","AE8_NFS")})
Aadd(aCampos,{"AE8_MOVBAN" ,,"MV.BAN"      ,PesqPict("AE8","AE8_MOVBAN")})

cFileMarc := CriaTrab(aStru ,.T.)

USE &cFileMarc ALIAS TRB EXCLUSIVE NEW
IndRegua("TRB",cFileMarc,"AE8_DESCRI",,,OemToAnsi("Selecionando Registros"))

cQuery:=" SELECT "
cQuery+=" '  ' AE8_OK, AE8_RECURS, AE8_DESCRI, AE8_ESTRUT, AE8_DOCUME, AE8_GERSC, AE8_GERSA, AE8_GEROP, AE8_GERCP, AE8_GEREMP, AE8_CONFIR, AE8_NFE, AE8_REQUIS, AE8_DESP, AE8_RECEI, AE8_APTMRE, AE8_NFS, AE8_MOVBAN "
cQuery+=" FROM "+RetSqlName("AE8")
cQuery+=" WHERE AE8_USRPAD='S' AND AE8_FILIAL='"+Xfilial("AE8")+"' AND D_E_L_E_T_<>'*' "

cQuery := ChangeQuery(cQuery)

dbUseArea(.T., "TOPCONN", TCGenQry(,,cQuery), 'QAE8', .F., .T.)

dbSelectArea("QAE8")
dbGoTop()

While !Eof()
   dbSelectArea("TRB")
   RecLock("TRB",.T.)
      For ni := 1 to QAE8->(FCount())
          TRB->(FieldPut(nI,QAE8->(FieldGet(ni))))
      Next
   MsUnLock()
   
   dbSelectArea("QAE8")
   dbSkip()
End
                                     
dbSelectArea("QAE8")
dbCloseArea()
              
dbSelectArea("TRB")
dbGoTop()
		
DEFINE MSDIALOG oDlg2 TITLE OemToAnsi("Usuários do Projeto") From 9,0 To 40,120 ///OF oMainWnd
@ 017,015 SAY oSayPrinc Var OemToAnsi("Selecione os usuários do Projeto:") Of oDlg2 Pixel COLOR CLR_HBLUE

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Passagem do parametro aCampos para emular tamb‚m a markbrowse para o ³
//³ arquivo de trabalho "TRB".                                           ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

oMark := MsSelect():New("TRB","AE8_OK"," ",aCampos,@lInverte,@cMarca,{35,1,200,460})
oMark:oBrowse:lHasMark    := .T.
oMark:oBrowse:lCanAllMark := .T.
oMark:oBrowse:cToolTip := "Clique em 'Ok' para marcar/desmarcar todos"

ACTIVATE MSDIALOG oDlg2  ON INIT EnchoiceBar(oDlg2,{|| nOpca := 1,FOk()},{|| nOpca := 3,FCancel()}) 
    
Return(.T.)



Static Function FOk()
***************************************************************************************************
* Chamada para gravação dos usuários
*
****

cCabecalho := OemToAnsi("Gravando os usuários do Projeto")
cMsgRegua  := "Processando..."

Processa( {|| GravUserProj()} ,cCabecalho,cMsgRegua )

//Fecha a Tabela e a Janela
FCancel()

Return(.T.)                


Static Function FCancel()
***************************************************************************************************
* Chamada para gravação dos usuários
*
****    
dbSelectArea("TRB")
dbCloseArea()
oDlg2:End()
Return()

Static Function GravUserProj()
***************************************************************************************************
* Chamada para gravação dos usuários
*
****    
dbSelectArea("TRB")
dbGotop()
While !eof()
	
	If TRB->AE8_OK<>cMarca
		dbSkip()
		loop
	Endif   
	dbSelectArea("AFX")
	Reclock("AFX",!dbSeek(Xfilial("AFX")+AF8->AF8_PROJET+TRB->AE8_RECURS))
	Replace AFX_ESTRUT With TRB->AE8_ESTRUT,;
			AFX_DOCUME With TRB->AE8_DOCUME,;
			AFX_GERSC With TRB->AE8_GERSC,;
			AFX_GERSA With TRB->AE8_GERSA,;
			AFX_GEROP With TRB->AE8_GEROP,;
			AFX_GERCP With TRB->AE8_GERCP,;
			AFX_GEREMP With TRB->AE8_GEREMP,;
			AFX_CONFIR With TRB->AE8_CONFIR,;
			AFX_NFE With TRB->AE8_NFE,;
			AFX_REQUIS With TRB->AE8_REQUIS,;
			AFX_DESP With TRB->AE8_DESP,;
			AFX_RECEI With TRB->AE8_RECEI,;
			AFX_RECURS With TRB->AE8_RECURS,;
			AFX_NFS With TRB->AE8_NFS,;
			AFX_MOVBAN With TRB->AE8_MOVBAN
		MsUnlock()	
	dbSelectArea("TRB")
	dbSkip()
EndDo
Return(.t.)

