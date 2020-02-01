#Include "Rwmake.ch"
/*
+-----------------------------------------------------------------------------+
| Programa  | Cad0001  | Desenvolvedor | Gilson Lucas Jr  | Data | 16/09/2004 |
|-----------------------------------------------------------------------------|
| Descricao | Manutenção dos pre-Contratos de parceria                        |
|-----------------------------------------------------------------------------|
| Uso       | Especifico EPC Engenharia                                       |
|-----------------------------------------------------------------------------|
|                  Modificacoes desde a construcao inicial                    |
|-----------------------------------------------------------------------------|
| Responsavel  | Data      | Motivo                                           |
|-----------------------------------------------------------------------------|
|              |           |                                                  | 
+--------------+-----------+--------------------------------------------------+
*/

User Function Cad0001
/*******************************************************
* Função principal
*
*************************/

Local aCores := {{ "!Empty(ZO_RESIDUO)",'BR_AZUL' },;  								//Eliminado Residuo
                 { "Alltrim(ZO_STATUS)=='O' .AND. ZO_ENCER <>'E'",'BR_MARRON' },;	 // Orcamento simples
				 { "Alltrim(ZO_STATUS)=='C' .AND. ZO_ENCER <>'E'",'BR_CINZA' },;	 // Orcamento Compromissado                 
				 { "Alltrim(ZO_STATUS)=='T' .AND. ZO_ENCER <>'E' ",'ENABLE' },;		 // ct Tendencia                 				 
 				 { "Alltrim(ZO_STATUS)=='P'",'BR_PRETO' },;							 // ct Tendencia                 				 
 				 { "Alltrim(ZO_STATUS)=='A'",'BR_LARANJA'},;						 // Aditivo de contrato 
                 { "ZO_ENCER ='E'","DISABLE" }} 									// Totalmente Atendida
Local aFixe := {	{ "Numero"            ,"ZO_NUM" },;		//Campos que devem ser exibidos mo MsBrowse
 					{ "=="    	          ,"ZO_STATUS" },;		
 					{ "Emissao"           ,"ZO_EMISSAO" },;		
  					{ "Produto"           ,"ZO_PRODUTO" },;		
  					{ "Dt. Final Contrato","ZO_DATPRF"  },;		
  					{ "Fornecedor"        ,"ZO_FORNECE" },;		
  					{ "Qt. Entregue"      ,"ZO_QUJE" } }								

Private cCadastro := OemToAnsi("Controle de Orçamentos")
Private cRotina   := ""
Private aRotina := { {"&Pesquisar"   ,"AxPesqui"  ,0,1} ,;
					{"&Visualizar"   ,"U_Efetiva(2)" ,0,2} ,;
					{"Plane&jamento" ,"U_NovoOrc",0,3} ,;
					{"Pro&gramado"   ,"U_Efetiva(1)" ,0,4} ,;
					{"Ten&dencia"    ,"U_FAltera(1)" ,0,5} ,;
					{"P&ontual"      ,"U_FAltera(2)" ,0,6} ,;					
					{"&Alterar"      ,"U_FAltera(3)" ,0,7} ,;
					{"Adi&tivo"      ,"U_FAditivo" ,0,8} ,;
					{"E&xcluir"      ,"U_FAltera(4)" ,0,9} ,;					
					{"&Legenda"      ,"U_FLg0001" ,0,10} }
Private aCols     := {}
Private aHeader   := {}
Private aColsAnt  := {}
Private lRet      := .T.      
Private lInc      := .F.
dbSelectArea("SZO")
dbSetOrder(2)

mBrowse( 6,1,22,75,"SZO",aFixe,,,,,aCores)

Return



User Function FLg0001()
/*************************************************************************************
* Exibe a legenda de cores
*
*
*******************************************/

Local aLegenda := {}

Aadd(aLegenda, {"ENABLE"    ,"Tendencia"})
Aadd(aLegenda, {"DISABLE"   ,"Contrato Atendito"})
Aadd(aLegenda, {"BR_AZUL"   ,"Residuo Eliminado"})
Aadd(aLegenda, {"BR_MARRON","Orc. Planejado"})
Aadd(aLegenda, {"BR_CINZA" ,"Orc. Programado"})
Aadd(aLegenda, {"BR_PRETO","Pontual"})
Aadd(aLegenda, {"BR_LARANJA","Aditivo de Contrato"})

BrwLegenda(cCadastro, "Legenda", aLegenda)

Return(.T.)



User Function NovoOrc

/*************************************************************************************
* Funcao que faz a inclusao de um novo orcamento
*
*
*******************************************/

Local   aAreaOLD   := GetArea()
Local   nUsado     := 0
Local   dDate      := Date()      
Local   nOpcx      := 3
Local   aButtons   := {{'PROJETPMS',{||	U_DlgCPCust(3,cNum) },"PMS"}}   
Private oDlg,oChec,oNomFor,oCheckPont
Private cNomeFor   := Space(55)
Private cNum       := GetSx8Num("SZO","ZO_NUM")
Private cA125Forn  := Space(6) 
Private cA125Loj   := space(2)
Private cFilEnt    := SM0->M0_CODFIL
Private lCheck     := .F.
Private lCheckPont := .F.
Private cFornAnt  := "" 
Private cA125Loj  := "" 
Private cCondicao := space(3)
Private cContato  := Space(20)
Private nPosItem  := GDFieldPos("ZO_ITEM")
Private nPosProd  := GDFieldPos("ZO_PRODUTO")
Private nPosQuant := GDFieldPos("ZO_QUANT")
Private nPosPrec  := GDFieldPos("ZO_PRECO")
Private nPosTot   := GDFieldPos("ZO_TOTAL")
Private nPosDtIni := GDFieldPos("ZO_DATPRI")
Private nPosDtFim := GDFieldPos("ZO_DATPRF")
Private nPosIpi   := GDFieldPos("ZO_IPI")
Private nPosLocal := GDFieldPos("ZO_LOCAL")
Private nPosObs   := GDFieldPos("ZO_OBS")
Private lGravaOrc := .T.
lInc      := .T.
cRotina := "ORCAMENTO" 
aCols   := {}
aHeader := {}

dbSelectArea("SX3")
dbSeek("SZO")
nUsado:=0
While !EOF() .And. (x3_arquivo == "SZO")
   IF X3USO(x3_usado) .AND. cNivel >= x3_nivel 
      nUsado:=nUsado+1
      AADD(aHeader,{ TRIM(x3_titulo), x3_campo, x3_picture,;
      x3_tamanho, x3_decimal,"AllwaysTrue()",;
      x3_usado, x3_tipo, x3_arquivo, x3_context })
    Endif
    dbSkip()
End

aCols:=Array(1,nUsado+1)    
dbSelectArea("SX3")
dbSeek("SZO")
nUsado:=0
While !Eof() .And. (x3_arquivo == "SZO")
	IF X3USO(x3_usado) .AND. cNivel >= x3_nivel
		nUsado:=nUsado+1
		IF nOpcx == 3
			IF x3_tipo == "C"
				If AllTrim(x3_campo) = "ZO_ITEM"
				   aCols[1][nUsado] := "001"
				 Else  
				   aCols[1][nUsado] := SPACE(x3_tamanho)
				 EndIf
			Elseif x3_tipo == "N"
				aCols[1][nUsado] := 0
			Elseif x3_tipo == "D"
				aCols[1][nUsado] := dDataBase
			Elseif x3_tipo == "M"
				aCols[1][nUsado] := ""
			Else
				aCols[1][nUsado] := .F.
			Endif
		Endif
	Endif
	dbSkip()
End
aCols[1][nUsado+1] := .F. 

@ 000,000 To 305,630 Dialog oDlg Title OemToAnsi("Contratos")
@ 017,005 Say OemtoAnsi("Número")
@ 017,028 Get cNum Picture "@!"  Size 040,025 
@ 017,070 Say OemtoAnsi("Emissão")
@ 016,095 Get dDate Picture "@!"  Size 040,025
@ 017,140 Say OemtoAnsi("Fornecedor")
@ 016,170 Get  cA125Forn Picture "@!"  VALID A125Fornec(@cFornAnt) .And. CheckSX3("ZO_FORNECE") F3 "SA2" Size 065,025 
@ 016,238 Get  cA125Loj  Picture "@!"  When .F. Size 015,025
@ 017,258 Say OemtoAnsi("Cod.Pagto")
@ 016,288 Get  cCondicao F3 "SE4" Picture "@!"  Valid ExistCpo("SE4",cCondicao) Size 015,025 
@ 032,005 Say OemtoAnsi("Contato")
@ 031,028 Get cContato Picture "@!"  Size 120,025 
@ 032,155 Say OemtoAnsi("Filila p/Entrega")
@ 031,195 Get cFilEnt Picture "@!"  F3 CpoRetF3("ZO_FILENT","SM0") Valid A120FilEnt(cFilEnt) .And. CheckSX3("ZO_FILENT") Size 015,025 
@ 032,222 Checkbox OemToAnsi("Programado") Var lCheck  Object oChec 
@ 032,280 Checkbox OemToAnsi("Pontual") VAR lCheckPont Object oCheckPont

oGetBrw := MsGetDados():New(045,005,145,311,3,"U_FValidLinha","U_FValidLinha","+ZO_ITEM",.T.,,,,9999)
@ 145,005 Say OemtoAnsi("Fornecedor:")
@ 145,035 Say cNomeFor object oNomFor

oChec:bLClicked := {|| FValidCheck()}
oCheckPont:bLClicked := {|| Iif(lCheckPont,lCheck := .T.,lCheck := .F.),oCheckPont:Refresh(),oChec:Refresh(),FValidCheck(),Iif(lCheckPont,oChec:Disable(),oChec:Enable())}
Activate Dialog oDlg Center On Init EnchoiceBar(oDlg,{|| FGravaReg()},{||oDlg:End(),Iif(!oGetBrw:LMODIFIED,RollBackSX8("SZO"),"")},,aButtons)

RestArea(aAreaOLD)

Return



Static Function FValidCheck
/*************************************************************************************
* Valida o check box 
*
*
*******************************************/
If Empty(cA125Forn) 
   MsgBox("Selecione um fornecedor",OemToAnsi("Atenção"),"INFO")
   lCheck      := .F.
   oCheckPont  := .F. 
EndIf
If Alltrim(cA125Forn) = GetMv("MV_FORGENE") .And. lCheck
   MsgBox(OemToAnsi("Não é permitido criar orçamento compromissado "+ chr(13) +" para um fornecedor generico"),OemToAnsi("Atenção"),"INFO")
   lCheck      := .F.
   oCheckPont  := .F.
EndIf

oChec:Refresh()

Return



Static Function A125Fornec(cFornAnt)
/***********************************************************************
* Atualiza a loca e o nome do fornecedor
*
*
*******************************************/

If Empty(cA125Forn)
	Return .F.
Endif
cA125Loj := SA2->A2_LOJA
dbSelectArea("SA2")
dbSetOrder(1)   && forca o indice na ordem certa
If !Empty(cA125Loj)
	dbSeek( cFilial + cA125Forn + cA125Loj)
Else
	dbSeek( cFilial + cA125Forn)
EndIf
If Eof()
    Help("",1,"Cad0001",,OemToAnsi("Cod. fornecedor não existe"),1,30)
	Return .F.
Endif
If  cRotina != "EFETIVA"
    cA125Loj  := SA2->A2_LOJA
    cCondicao := SA2->A2_COND
    cContato  := SA2->A2_CONTATO
EndIf
oNomFor :CTITLE := SUBSTR(SA2->A2_NOME,1,35)
oNomFor:Refresh()
dbSelectArea("SZO")

Return(.T.)



Static Function FGravaReg

/*************************************************************************************
* Grava os registro do SC3e no SZO
*
*
*******************************************/

Local   nXi
Private nPosItem  := GDFieldPos("ZO_ITEM")
Private nPosProd  := GDFieldPos("ZO_PRODUTO")
Private nPosQuant := GDFieldPos("ZO_QUANT")
Private nPosPrec  := GDFieldPos("ZO_PRECO")
Private nPosTot   := GDFieldPos("ZO_TOTAL")
Private nPosDtIni := GDFieldPos("ZO_DATPRI")
Private nPosDtFim := GDFieldPos("ZO_DATPRF")
Private nPosIpi   := GDFieldPos("ZO_IPI")
Private nPosLocal := GDFieldPos("ZO_LOCAL")
Private nPosObs   := GDFieldPos("ZO_OBS")

If cRotina = "ORCAMENTO" .AND. lCheck
   lGravaOrc := .F.
EndIf   


If Empty(GDFIELDGET("ZO_PRODUTO")) .OR. Empty(GDFIELDGET("ZO_QUANT")) .OR. Empty(GDFIELDGET("ZO_PRECO")) .OR. Empty(GDFIELDGET("ZO_TOTAL"))
      Help("",1,"Cad0001",,OemToAnsi("Campo(s) obrigatosrio(s) não preenchido(s)"),1,30)
      Return
EndIf

If GetMv("MV_FORGENE") <>  cA125Forn .AND. !lCheck
   MsgBox(OemToAnsi("Não é permitido gerar orçamento não compromissado para")+ chr(13) + OemToAnsi("fornecedor que não seja o fornecedor Generico"),OemToAnsi("Atenção"),"INFO")
   Return
EndIf

If  cRotina != "EFETIVA" .AND. lGravaOrc
	For nXi := 1 To Len(aCols)
		IF GDDELETED(nXi)
			Loop
		EndIF
		If RecLock("SZO",.T.)
			Replace  SZO->ZO_FILIAL     With  xFilial("SZO") ,;
			SZO->ZO_NUM			With  cNum,;
			SZO->ZO_FORNECE		With  cA125Forn,;
			SZO->ZO_LOJA		With  cA125Loj,;
			SZO->ZO_ITEM 		With  aCols[nXi][nPosItem],;
			SZO->ZO_PRODUTO		With  aCols[nXi][nPosProd],;
			SZO->ZO_QUANT		With  aCols[nXi][nPosQuant],;
			SZO->ZO_PRECO  		With  aCols[nXi][nPosPrec],;
			SZO->ZO_TOTAL 		With  aCols[nXi][nPosTot],;
			SZO->ZO_DATPRI		With  aCols[nXi][nPosDtIni],;
			SZO->ZO_DATPRF		With  aCols[nXi][nPosDtFim],;
			SZO->ZO_IPI			With  aCols[nXi][nPosIpi],;
			SZO->ZO_LOCAL		With  aCols[nXi][nPosLocal],;
			SZO->ZO_OBS			With  aCols[nXi][nPosObs],;
			SZO->ZO_COND		With  cCondicao,;
			SZO->ZO_CONTATO		With  cContato,;
			SZO->ZO_FILENT		With  cFilEnt,;
			SZO->ZO_EMISSAO		With  dDataBase,;
 		    SZO->ZO_STATUS      With  "O",;
 		    SZO->ZO_STAUXI      With  "O"
 		    
			MsUnLock()
			ConfirmSX8("SZO")
		EndIF
	Next nXi
EndIf

If lCheck
	For nXi := 1 To Len(aCols)
		IF GDDELETED(nXi)
			Loop
		EndIF
		If RecLock("SZO",.T.)
			Replace  SZO->ZO_FILIAL     With  xFilial("SZO") ,;
			SZO->ZO_NUM			With  cNum,;
			SZO->ZO_FORNECE		With  cA125Forn,;
			SZO->ZO_LOJA		With  cA125Loj,;
			SZO->ZO_ITEM 		With  aCols[nXi][nPosItem],;
			SZO->ZO_PRODUTO		With  aCols[nXi][nPosProd],;
			SZO->ZO_QUANT		With  aCols[nXi][nPosQuant],;
			SZO->ZO_PRECO  		With  aCols[nXi][nPosPrec],;
			SZO->ZO_TOTAL 		With  aCols[nXi][nPosTot],;
			SZO->ZO_DATPRI		With  aCols[nXi][nPosDtIni],;
			SZO->ZO_DATPRF		With  aCols[nXi][nPosDtFim],;
			SZO->ZO_IPI			With  aCols[nXi][nPosIpi],;
			SZO->ZO_LOCAL		With  aCols[nXi][nPosLocal],;
			SZO->ZO_OBS			With  aCols[nXi][nPosObs],;
			SZO->ZO_COND		With  cCondicao,;
			SZO->ZO_CONTATO		With  cContato,;
			SZO->ZO_FILENT		With  cFilEnt,;
			SZO->ZO_EMISSAO		With  dDataBase
 		    If lCheckPont
			   Replace SZO->ZO_STATUS      With  "P"
			   Replace SZO->ZO_PONTUAL     With  "P"
  			   Replace SZO->ZO_STAUXI      With  "C"			   
			else
			   Replace SZO->ZO_STATUS      With  "C"
			   Replace SZO->ZO_STAUXI      With  "C"			   
			EndIf
			MsUnLock()
		EndIF
	Next nXi
EndIf

If lCheck
	For nXi := 1 To Len(aCols)
		IF GDDELETED(nXi)
			Loop
		EndIF
		If RecLock("SC3",.T.)
			Replace  SC3->C3_FILIAL     With  xFilial("SC3") ,;
			SC3->C3_NUM			With  cNum,;
			SC3->C3_FORNECE		With  cA125Forn,;
			SC3->C3_LOJA		With  cA125Loj,;
			SC3->C3_ITEM 		With  aCols[nXi][nPosItem],;
			SC3->C3_PRODUTO		With  aCols[nXi][nPosProd],;
			SC3->C3_QUANT		With  aCols[nXi][nPosQuant],;
			SC3->C3_PRECO  		With  aCols[nXi][nPosPrec],;
			SC3->C3_TOTAL 		With  aCols[nXi][nPosTot],;
			SC3->C3_DATPRI		With  aCols[nXi][nPosDtIni],;
			SC3->C3_DATPRF		With  aCols[nXi][nPosDtFim],;
			SC3->C3_IPI			With  aCols[nXi][nPosIpi],;
			SC3->C3_LOCAL		With  aCols[nXi][nPosLocal],;
			SC3->C3_OBS			With  aCols[nXi][nPosObs],;
			SC3->C3_COND		With  cCondicao,;
			SC3->C3_CONTATO		With  cContato,;
			SC3->C3_FILENT		With  cFilEnt,;
	 	    SC3->C3_EMISSAO		With  dDataBase
			MsUnLock()
		EndIF
	Next nXi	
EndIf

oDlg:End() 

Return



User Function FValidLinha         

/*************************************************************************************
* Valida a linha do grid
*
*
*******************************************/

lRel := .T.
If Empty(GDFIELDGET("ZO_PRODUTO")) .OR. Empty(GDFIELDGET("ZO_QUANT")) .OR. Empty(GDFIELDGET("ZO_PRECO")) .OR. Empty(GDFIELDGET("ZO_TOTAL"))
   Help("",1,"Cad0001",,OemToAnsi("Campo(s) obrigatosrio(s) não preenchido(s)"),1,30)
   lRet := .F.
EndIf

Return(lRet)



User Function Efetiva(nOp)

/*************************************************************************************
* Permite Efetivar e visualizar o orcamento 
*
*
*******************************************/

Local aAreaOLD   := GetArea()
Local  cQuery    := ""
Local  aCampos   := {}
Local  nLinha    := 0
Local  nUsado    := 0
Local  cNumPesq  := SZO->ZO_NUM
Local  cItemPesq := SZO->ZO_ITEM
Local 	aButtons   := {}
Local  aArea     := {}
Local  cFiltroStatus := ""
Local  lAditivo := .F.
Private oNomFor,oDlg,oChec,oNomFor
Private dDate      := SZO->ZO_EMISSAO
Private nOpcx      := Iif(nOp==2,1,3)
Private cNomeFor   := Posicione("SA2",1,xFilial("SA2")+SZO->ZO_FORNECE+SZO->ZO_LOJA,"A2_NOME")
Private cNum       := SZO->ZO_NUM    
Private cA125Forn  := SZO->ZO_FORNECE
Private cA125Loj   := SZO->ZO_LOJA   
Private cFilEnt    := SZO->ZO_FILENT 
Private cCondicao  := SZO->ZO_COND   
Private cContato   := SZO->ZO_CONTATO
Private cFornAnt   := ""
Private lCheck     := .T.  
Private lGravaOrc  := .T.
Private lCheckPont := .F.
Private cNumAdt    := SZO->ZO_ADITIVO
If nOp == 2 
	aButtons := {{'PROJETPMS',{||	U_DlgCPCust(2,cNum) },"PMS"}}   
Endif

lInc      := .F.
cRotina := "EFETIVA" 
aCols   := {}
aHeader := {}                   

If nOp <> 2 
   aArea := {}
   aArea := GetArea()
   SZO->(dbSetOrder(1))
   SZO->(dbSeek(xFilial("SZO")+cNumPesq+cItemPesq+"C"))
   If !SZO->(EOF())
        MsgBox(OemToAnsi("Orçamento já efetivado"),OemToAnsi("Atenção"),"INFO")
        Return
   EndIf
   RestArea(aArea)
EndIf


If nOp = 1
   If SZO->ZO_STATUS $ 'T|P' 
      Return
   EndIf
EndIf

If nOp = 2 
    If SZO->ZO_STATUS = "A"
        cFiltroStatus := " AND ZO_STATUS = 'A' "
        lAditivo      := .T.
    EndIf
    If SZO->ZO_STATUS = "C"
        cFiltroStatus := " AND ZO_STATUS = 'C' "
    EndIf
    If SZO->ZO_STATUS $ "T|E"
        cFiltroStatus := " AND ZO_STATUS IN ('T','E')  "
    EndIf
EndIf    


cQuery := " SELECT ZO_ITEM,ZO_PRODUTO,ZO_QUANT,ZO_PRECO,ZO_TOTAL,ZO_DATPRI,ZO_DATPRF,ZO_IPI,ZO_LOCAL,ZO_OBS "
cQuery += " FROM " +RetSQLName("SZO") 
cQuery += " WHERE ZO_FILIAL = '"+xFilial("SZO")+"' AND D_E_L_E_T_ <> '*'"
cQuery += " AND ZO_NUM = '" + cNum +"' AND ZO_FORNECE = '" + cA125Forn + "' AND ZO_LOJA = '" + cA125Loj + "'"
cQuery += cFiltroStatus

dbUseArea(.T., "TOPCONN", TCGenQry(,,cQuery), 'TRB1', .F., .T.)

TCSetField("TRB1", "ZO_DATPRI", "D", 8,  0 )
TCSetField("TRB1", "ZO_DATPRF", "D", 8,  0 )


dbSelectArea("SX3")
dbSeek("SZO")
nUsado:=0
While !EOF() .And. (x3_arquivo == "SZO")
   IF X3USO(x3_usado) .AND. cNivel >= x3_nivel 
      nUsado:=nUsado+1
      AADD(aHeader,{ TRIM(x3_titulo), x3_campo, x3_picture,;
      x3_tamanho, x3_decimal,"AllwaysTrue()",;
      x3_usado, x3_tipo, x3_arquivo, x3_context })
    Endif
    dbSkip()
End

DbSelectArea("TRB1")
DbGoTop()

While TRB1->(!Eof())
    nLinha := nLinha +1
    dbSkip()
EndDo    

DbSelectArea("TRB1")
DbGoTop()

aCols:= {}
aCols:=Array(nLinha,nUsado+1) 
nUsado := 0

While TRB1->(!Eof())
	nUsado := nUsado +1	  
	aCols[nUsado][GDFieldPos("ZO_ITEM")]  := ZO_ITEM
	aCols[nUsado][GDFieldPos("ZO_PRODUTO")]  := ZO_PRODUTO
	aCols[nUsado][GDFieldPos("ZO_QUANT")] := ZO_QUANT
	aCols[nUsado][GDFieldPos("ZO_PRECO")]  := ZO_PRECO
	aCols[nUsado][GDFieldPos("ZO_TOTAL")]   := ZO_TOTAL
	aCols[nUsado][GDFieldPos("ZO_DATPRI")] := ZO_DATPRI
	aCols[nUsado][GDFieldPos("ZO_DATPRF")] := ZO_DATPRF
	aCols[nUsado][GDFieldPos("ZO_IPI")]   := ZO_IPI
	aCols[nUsado][GDFieldPos("ZO_LOCAL")] := ZO_LOCAL
	aCols[nUsado][GDFieldPos("ZO_OBS")]   := ZO_OBS   
    aCols[nUsado][GDFieldPos("ZO_OBS") + 1] := .F.
   	dbSkip()
Enddo

dbSelectArea("TRB1")
dbCloseArea()

@ 000,000 To 305,630 Dialog oDlg Title OemToAnsi("EPC Engenharia")//IIf(SZO->ZO_STATUS="O","Orçamento",IIf(SZO->ZO_STATUS="C","Compromissado",Iif(SZO->ZO_STATUS="T","Tendencia","Pontual")))
@ 017,005 Say OemtoAnsi("Número")
@ 017,028 Get cNum Picture "@!"   When .F. Size 040,025 
@ 017,070 Say OemtoAnsi("Emissão")
@ 016,095 Get dDate Picture "@!"  When .F. Size 040,025 
@ 017,140 Say OemtoAnsi("Fornecedor")
If (nOp == 1)
    @ 016,170 Get  cA125Forn Picture "@!"  VALID A125Fornec(@cFornAnt) .And. CheckSX3("ZO_FORNECE") F3 "SA2" Size 065,025 
	@ 016,238 Get  cA125Loj  Picture "@!"  When .F. Size 015,025
Else
    @ 016,170 Get  cA125Forn Picture "@!"  When .F. Size 065,025 
	@ 016,238 Get  cA125Loj  Picture "@!"  When .F. Size 015,025
EndIf
@ 017,258 Say OemtoAnsi("Cod.Pagto")
@ 016,288 Get  cCondicao Picture "@!"  When .F. Size 015,025 
@ 032,005 Say OemtoAnsi("Contato")
If (nOp == 1)
    @ 031,028 Get cContato Picture "@!"  Size 120,025 
Else
    @ 031,028 Get cContato Picture "@!"  When .F. Size 120,025 
EndIf    
@ 032,155 Say OemtoAnsi("Filila p/Entrega")
@ 031,195 Get cFilEnt Picture "@!"  F3 CpoRetF3("ZO_FILENT","SM0") Size 015,025 When .F.
If (nOp == 1)
    @ 016,288 Get  cCondicao F3 "SE4" Picture "@!"  Valid ExistCpo("SE4",cCondicao) Size 015,025 
Else
	@ 016,288 Get  cCondicao F3 "SE4" Picture "@!"  When .F. Size 015,025 
EndIf
@ 032,230 Checkbox OemToAnsi("Orçamento Compromissado") Var lCheck  Object oChec 
oGetBrw := MsGetDados():New(045,005,145,311,nOpcx,"U_FValidLinha","U_FValidLinha","+ZO_ITEM",.T.,,,,9999)
@ 145,005 Say OemtoAnsi("Fornecedor:")
@ 145,035 Say cNomeFor object oNomFor
If lAditivo
    @ 032,225 Say OemtoAnsi("Aditivo")
    @ 031,245 Get cNumAdt Picture "@!"  Size 040,025 Valid NaoVazio() when .F.
EndIf    

oChec:lVisibleControl := .F.

aColsAnt := Aclone(aCols)

Activate Dialog oDlg Center On Init EnchoiceBar(oDlg,{|| Iif(nOp==1,FGravaReg(),oDlg:End())},{||oDlg:End()},,aButtons)

RestArea(aAreaOLD)

Return



User Function FAltera(nOp1)
/********************************************************************************
* Esta funcao permitura alterar um orçamento e efetuar tentencia
*
*
*******************************************/

Local  aAreaOLD   := GetArea()
Local  aAreaLocal := GetArea()
Local  cQuery     := ""
Local  aCampos    := {}
Local  nLinha     := 0
Local  nUsado     := 0      
Local  cRegAnt1   := "A"
Local  cRegAtual1 := "B"
Local  cRegAnt2   := "A"
Local  cRegAtual2 := "B"
Local  aArea      := {}
Local  cNumPesq   := SZO->ZO_NUM
Local  cItemPesq  := SZO->ZO_ITEM
Local  aButtons   := {}
Private oNomFor,oDlg,oChec,oNomFor
Private dDate     := SZO->ZO_EMISSAO
Private nOpcx     := Iif(nOp1==4,1,3)
Private cNomeFor  := Posicione("SA2",1,xFilial("SA2")+SZO->ZO_FORNECE+SZO->ZO_LOJA,"A2_NOME")
Private cNum      := SZO->ZO_NUM    
Private cA125Forn := SZO->ZO_FORNECE
Private cA125Loj  := SZO->ZO_LOJA   
Private cFilEnt   := SZO->ZO_FILENT 
Private cCondicao := SZO->ZO_COND   
Private cContato  := SZO->ZO_CONTATO
Private cFornAnt  := ""
Private lCheck    := .T.  
Private cRegDel1  := ""
Private cRegDel2  := ""
Private nOp2      := nOp1
Private lOrcam    := .F.
Private cUserFunName := ""
Private nOpPMS
If nOp1 == 3
	nOpPMS := 4        
	aButtons:= {{'PROJETPMS',{||	U_DlgCPCust(nOpPMS,cNum) },"PMS"}}   
EndIf

lInc      := .F.
cRotina := "TENDENCIA" 
aCols   := {}
aHeader := {}         

If nOp1 == 2
    If SZO->ZO_STATUS <> "P"
        MsgBox(OemToAnsi("Este orçamento não é um orçamento pontual.Verifique legenda."),OemToAnsi("Atenção"),"INFO")
        Return
    EndIf    
EndIf

If nOp1 == 1
    If SZO->ZO_STATUS $ "O|P"
        Return
    EndIf    
EndIf                 

If ((nOp1 == 3 .OR. nOp1 == 4)  .AND. (SZO->ZO_STATUS=="O"))
    cUserFunName := "Orcam"
    aAreaLocal := {}
    aAreaLocal := GetArea()
    SZO->(dbSetOrder(1))
    SZO->(dbSeek(xFilial("SZO")+cNumPesq+cItemPesq+"C"))
    If !SZO->(EOF())    
        MsgBox(OemToAnsi("Este orçamento não pode ser alterado!!!"+ chr(13) +"Ja existe programação para o mesmo."),OemToAnsi("Atenção"),"INFO")
	    RestArea(aAreaLocal)
        SZO->(dbGoTop())	    
        Return
    EndIf
    RestArea(aAreaLocal)
    lOrcam := .T.
EndIf 


If ((nOp1 == 3 .OR. nOp1 == 4) .AND. (SZO->ZO_STATUS=="E"))
   Return
EndIf


If ((nOp1 == 3 .OR. nOp1 == 4) .AND. (SZO->ZO_STATUS=="C"))
    cUserFunName := "Compromisso"
    aAreaLocal := {}
    aAreaLocal := GetArea()
    SZO->(dbSetOrder(2))
    SZO->(dbSeek(xFilial("SZO")+cNumPesq+"T"))
    If !SZO->(EOF())    
        MsgBox(OemToAnsi("Esta programação não pode ser alterada!!!"+ chr(13) +"Ja existe Tendencia para a mesma."),OemToAnsi("Atenção"),"INFO")
        RestArea(aAreaLocal)
        SZO->(dbGoTop())
        Return
    EndIf
    SZO->(dbSetOrder(2))
    SZO->(dbSeek(xFilial("SZO")+cNumPesq+"E"))
    If !SZO->(EOF())    
        MsgBox(OemToAnsi("Esta programação não pode ser alterada!!!"+ chr(13) +"Ja existe Tendencia para a mesma."),OemToAnsi("Atenção"),"INFO")
		RestArea(aAreaLocal)
        SZO->(dbGoTop())		
        Return
    EndIf        
    RestArea(aAreaLocal)
    lOrcam := .T.
EndIf
If ((nOp1 == 3) .AND. (SZO->ZO_STATUS=="T"))
    If SZO->ZO_QUJE <> 0
        MsgBox(OemToAnsi("Esta programação não pode ser alterada!!!"+ chr(13) +"Ja existe uma AE para esta programação."),OemToAnsi("Atenção"),"INFO")
        Return
    EndIf
EndIf    
                                            
If ((nOp1 == 3 .OR. nOp1 == 4) .AND. (SZO->ZO_STATUS=="T"))
        Return
EndIf

If ZO_STATUS <> "T"
    aArea := {}
    aArea := GetArea()
    SZO->(dbSetOrder(2))
    SZO->(dbSeek(xFilial("SZO")+cNumPesq+"T"))
    If !SZO->(EOF())  
        MsgBox(OemToAnsi("Este Orçamento já sofreu Tendencia"),OemToAnsi("Atenção"),"INFO")    
        Return
    EndIf
    RestArea(aArea)
EndIf    



cQuery := " SELECT ZO_ITEM,ZO_PRODUTO,ZO_QUANT,ZO_PRECO,ZO_TOTAL,ZO_DATPRI,ZO_DATPRF,ZO_IPI,ZO_LOCAL,ZO_OBS, "
cQuery += " R_E_C_N_O_ as ZO_RECNO FROM " +RetSQLName("SZO") 
cQuery += " WHERE ZO_FILIAL = '"+xFilial("SZO")+"' AND D_E_L_E_T_ <> '*' "
cQuery += " AND ZO_NUM = '" + cNum +"' AND ZO_FORNECE = '" + cA125Forn + "' AND ZO_LOJA = '" + cA125Loj + "'"
cQuery += " AND ZO_STATUS = '" + SZO->ZO_STATUS + "' AND ZO_ENCER <> 'E'"



dbUseArea(.T., "TOPCONN", TCGenQry(,,cQuery), 'TRB1', .F., .T.)

TCSetField("TRB1", "ZO_DATPRI", "D", 8,  0 )
TCSetField("TRB1", "ZO_DATPRF", "D", 8,  0 )


dbSelectArea("SX3")
dbSeek("SZO")
nUsado:=0
While !EOF() .And. (x3_arquivo == "SZO")
   IF X3USO(x3_usado) .AND. cNivel >= x3_nivel 
      nUsado:=nUsado+1
      AADD(aHeader,{ TRIM(x3_titulo), x3_campo, x3_picture,;
      x3_tamanho, x3_decimal,"AllwaysTrue()",;
      x3_usado, x3_tipo, x3_arquivo, x3_context })
    Endif
    dbSkip()
End

DbSelectArea("TRB1")
DbGoTop()

While TRB1->(!Eof())
    nLinha := nLinha +1
    dbSkip()
EndDo    

DbSelectArea("TRB1")
DbGoTop()


aCols:= {}
aCols:=Array(nLinha,nUsado+1) 
nUsado := 0

While TRB1->(!Eof())
	nUsado := nUsado +1	
	aCols[nUsado][GDFieldPos("ZO_ITEM")]     := ZO_ITEM
	aCols[nUsado][GDFieldPos("ZO_PRODUTO")]  := ZO_PRODUTO
	aCols[nUsado][GDFieldPos("ZO_QUANT")]    := ZO_QUANT
	aCols[nUsado][GDFieldPos("ZO_PRECO")]    := ZO_PRECO
	aCols[nUsado][GDFieldPos("ZO_TOTAL")]    := ZO_TOTAL
	aCols[nUsado][GDFieldPos("ZO_DATPRI")]   := ZO_DATPRI
	aCols[nUsado][GDFieldPos("ZO_DATPRF")]   := ZO_DATPRF
	aCols[nUsado][GDFieldPos("ZO_IPI")]      := ZO_IPI
	aCols[nUsado][GDFieldPos("ZO_LOCAL")]    := ZO_LOCAL
	aCols[nUsado][GDFieldPos("ZO_OBS")]      := ZO_OBS   
    aCols[nUsado][GDFieldPos("ZO_OBS") + 1] := .F.
    cRegAtual1:= SZO->ZO_NUM
    If cRegAnt1 <> cRegAtual1
        cRegAnt1 := SZO->ZO_NUM
        cRegDel1 := ALLTRIM(cRegDel1) + "'" +ALLTRIM(SZO->ZO_NUM)+ "',"
    EndIf
    cRegAtual2 := ALLTRIM(SZO->ZO_FORNECE)+ALLTRIM(SZO->ZO_LOJA)
    If cRegAnt2 <> cRegAtual2    
        cRegAnt2 := ALLTRIM(SZO->ZO_FORNECE)+ALLTRIM(SZO->ZO_LOJA)
        cRegDel2 := ALLTRIM(cRegDel2) + "'" +ALLTRIM(SZO->ZO_FORNECE)+ALLTRIM(SZO->ZO_LOJA) + "',"
    EndIf    
	dbSkip()
Enddo

dbSelectArea("TRB1")
dbCloseArea()

@ 000,000 To 305,630 Dialog oDlg Title OemToAnsi("Contratos")
@ 017,005 Say OemtoAnsi("Número")
@ 017,028 Get cNum Picture "@!"   When .F. Size 040,025 
@ 017,070 Say OemtoAnsi("Emissão")
@ 016,095 Get dDate Picture "@!"  When .F. Size 040,025 
@ 017,140 Say OemtoAnsi("Fornecedor")
@ 016,170 Get  cA125Forn Picture "@!"  When .F. Size 065,025 
@ 016,238 Get  cA125Loj  Picture "@!"  When .F. Size 015,025
@ 017,258 Say OemtoAnsi("Cod.Pagto")
@ 016,288 Get  cCondicao Picture "@!"  When .F. Size 015,025 
@ 032,005 Say OemtoAnsi("Contato")
@ 031,028 Get cContato Picture "@!"  When .F. Size 120,025 
@ 032,155 Say OemtoAnsi("Filila p/Entrega")
@ 032,230 Checkbox OemToAnsi("Orçamento Compromissado") Var lCheck  Object oChec 
oGetBrw := MsGetDados():New(045,005,145,311,nOpcx,"AllwaysTrue()","AllwaysTrue()","+ZO_ITEM",.T.,,,,9999)
@ 145,005 Say OemtoAnsi("Fornecedor:")
@ 145,035 Say cNomeFor object oNomFor

oChec:lVisibleControl := .F.

Activate Dialog oDlg Center On Init EnchoiceBar(oDlg,{|| Iif(nOp1==3,FDelAltera(),Iif(nOp1==4,FExcluir(),FDelte())),oDlg:End()},{||oDlg:End()},,aButtons)

RestArea(aAreaOLD)

Return



Static Function FDelte
/*************************************************************************************
* Esta função grava as alteracoes da rotina de tendencia
*
*
*******************************************/

Local cQuery      := ""
Local cSta        := Iif(nOp2 == 2,"P","T")
Local aColsAnt    := AClone(aCols)
Local nXi := 0

Private nPosItem  := GDFieldPos("ZO_ITEM")
Private nPosProd  := GDFieldPos("ZO_PRODUTO")
Private nPosQuant := GDFieldPos("ZO_QUANT")
Private nPosPrec  := GDFieldPos("ZO_PRECO")
Private nPosTot   := GDFieldPos("ZO_TOTAL")
Private nPosDtIni := GDFieldPos("ZO_DATPRI")
Private nPosDtFim := GDFieldPos("ZO_DATPRF")
Private nPosIpi   := GDFieldPos("ZO_IPI")
Private nPosLocal := GDFieldPos("ZO_LOCAL")
Private nPosObs   := GDFieldPos("ZO_OBS")


If !oGetBrw:LMODIFIED
    Return
EndIf         
If nOp2 <> 3
	cQuery := " UPDATE " + RetSQLName("SC3") + " SET D_E_L_E_T_  = '*'  "
	cQuery += " WHERE C3_FILIAL = '" +xFilial("SC3")+ "' AND D_E_L_E_T_ <> '*'"
	cQuery += " AND C3_NUM IN (" + LEFT(ALLTRIM(cRegDel1),LEN(ALLTRIM(cRegDel1))-1) + ")"
	cQuery += " AND C3_FORNECE+C3_LOJA IN (" + LEFT(ALLTRIM(cRegDel2),LEN(ALLTRIM(cRegDel2))-1) + ")"
	
	TCSQLExec(cQuery)
EndIf
cQuery := ""
cQuery := " UPDATE " + RetSQLName("SZO") + " SET D_E_L_E_T_  = '*'  "
cQuery += " WHERE ZO_FILIAL = '" +xFilial("SZO")+ "' AND D_E_L_E_T_ <> '*'"
cQuery += " AND ZO_NUM IN (" + LEFT(ALLTRIM(cRegDel1),LEN(ALLTRIM(cRegDel1))-1) + ")"
cQuery += " AND ZO_FORNECE+ZO_LOJA IN (" + LEFT(ALLTRIM(cRegDel2),LEN(ALLTRIM(cRegDel2))-1) + ")"
cQuery += " AND ZO_STATUS = '"+ cSta  +"' AND ZO_ENCER <> 'E' "


TCSQLExec(cQuery)

For nXi := 1 To Len(aCols)
	IF GDDELETED(nXi)
		Loop
	EndIF
	If RecLock("SC3",.T.)
		Replace  SC3->C3_FILIAL     With  xFilial("SC3") 
		Replace  SC3->C3_NUM		With  cNum
		Replace  SC3->C3_FORNECE	With  cA125Forn
		Replace  SC3->C3_LOJA		With  cA125Loj
		Replace  SC3->C3_ITEM 		With  aCols[nXi][nPosItem]
		Replace  SC3->C3_PRODUTO	With  aCols[nXi][nPosProd]
		Replace  SC3->C3_QUANT		With  aCols[nXi][nPosQuant]
		Replace  SC3->C3_PRECO  	With  aCols[nXi][nPosPrec]
		Replace  SC3->C3_TOTAL 		With  aCols[nXi][nPosTot]
		Replace  SC3->C3_DATPRI		With  aCols[nXi][nPosDtIni]
		Replace  SC3->C3_DATPRF		With  aCols[nXi][nPosDtFim]
		Replace  SC3->C3_IPI		With  aCols[nXi][nPosIpi]
		Replace  SC3->C3_LOCAL		With  aCols[nXi][nPosLocal]
		Replace  SC3->C3_OBS		With  aCols[nXi][nPosObs]
		Replace  SC3->C3_COND		With  cCondicao
		Replace  SC3->C3_CONTATO	With  cContato
		Replace  SC3->C3_FILENT		With  cFilEnt
		Replace  SC3->C3_EMISSAO	With  dDataBase
		MsUnLock()
	EndIF
Next nXi	

For nXi := 1 To Len(aCols)
	IF GDDELETED(nXi)
		Loop
	EndIF
	If RecLock("SZO",.T.)
		Replace  SZO->ZO_FILIAL   		    With  xFilial("SZO") 
		Replace  		SZO->ZO_NUM			With  cNum
		Replace  		SZO->ZO_FORNECE		With  cA125Forn
		Replace  		SZO->ZO_LOJA		With  cA125Loj
		Replace  		SZO->ZO_ITEM 		With  aCols[nXi][nPosItem]
		Replace  		SZO->ZO_PRODUTO		With  aCols[nXi][nPosProd]
		Replace  		SZO->ZO_QUANT		With  aCols[nXi][nPosQuant]
		Replace  		SZO->ZO_PRECO  		With  aCols[nXi][nPosPrec]
		Replace  		SZO->ZO_TOTAL 		With  aCols[nXi][nPosTot]
		Replace  		SZO->ZO_DATPRI		With  aCols[nXi][nPosDtIni]
		Replace  		SZO->ZO_DATPRF		With  aCols[nXi][nPosDtFim]
		Replace  		SZO->ZO_IPI			With  aCols[nXi][nPosIpi]
		Replace  		SZO->ZO_LOCAL		With  aCols[nXi][nPosLocal]
		Replace  		SZO->ZO_OBS			With  aCols[nXi][nPosObs]
		Replace  		SZO->ZO_COND		With  cCondicao
		Replace  		SZO->ZO_CONTATO		With  cContato
		Replace  		SZO->ZO_FILENT		With  cFilEnt
		Replace  		SZO->ZO_EMISSAO		With  dDataBase
		If nOp2 == 2
		   Replace  		SZO->ZO_STATUS      With  "C"		   
  		   Replace  		SZO->ZO_STAUXI      With  "C"		   
		   Replace  		SZO->ZO_PONTUAL     With  "L"	// A letra L indica que o pontual foi liberado	     		   
		else   
		   Replace  		SZO->ZO_STATUS      With  "T"
  		   Replace  		SZO->ZO_STAUXI      With  "T"		   		   
		EndIf   
		MsUnLock()
	EndIF
Next nXi

Return  



Static Function FDelAltera
/*********************************
*
*
*********************************************************************/

Local   nXi
Private nPosItem  := GDFieldPos("ZO_ITEM")
Private nPosProd  := GDFieldPos("ZO_PRODUTO")
Private nPosQuant := GDFieldPos("ZO_QUANT")
Private nPosPrec  := GDFieldPos("ZO_PRECO")
Private nPosTot   := GDFieldPos("ZO_TOTAL")
Private nPosDtIni := GDFieldPos("ZO_DATPRI")
Private nPosDtFim := GDFieldPos("ZO_DATPRF")
Private nPosIpi   := GDFieldPos("ZO_IPI")
Private nPosLocal := GDFieldPos("ZO_LOCAL")
Private nPosObs   := GDFieldPos("ZO_OBS")


If !oGetBrw:LMODIFIED
    Return
EndIf         

If (cUserFunName=="Orcam") //Grava as Alterações do orçamento Simples
	cQuery := ""
	cQuery := " UPDATE " + RetSQLName("SZO") + " SET D_E_L_E_T_  = '*'  "
	cQuery += " WHERE ZO_FILIAL = '" +xFilial("SZO")+ "' AND D_E_L_E_T_ <> '*'"
	cQuery += " AND ZO_NUM IN (" + LEFT(ALLTRIM(cRegDel1),LEN(ALLTRIM(cRegDel1))-1) + ")"
	cQuery += " AND ZO_FORNECE+ZO_LOJA IN (" + LEFT(ALLTRIM(cRegDel2),LEN(ALLTRIM(cRegDel2))-1) + ")"
	cQuery += " AND ZO_STATUS = 'O' "
	
	TCSQLExec(cQuery)

	For nXi := 1 To Len(aCols)
		IF GDDELETED(nXi)
			Loop
		EndIF
		If RecLock("SZO",.T.)
			Replace  SZO->ZO_FILIAL   		    With  xFilial("SZO") 
			Replace  		SZO->ZO_NUM			With  cNum
			Replace  		SZO->ZO_FORNECE		With  cA125Forn
			Replace  		SZO->ZO_LOJA		With  cA125Loj
			Replace  		SZO->ZO_ITEM 		With  aCols[nXi][nPosItem]
			Replace  		SZO->ZO_PRODUTO		With  aCols[nXi][nPosProd]
			Replace  		SZO->ZO_QUANT		With  aCols[nXi][nPosQuant]
			Replace  		SZO->ZO_PRECO  		With  aCols[nXi][nPosPrec]
			Replace  		SZO->ZO_TOTAL 		With  aCols[nXi][nPosTot]
			Replace  		SZO->ZO_DATPRI		With  aCols[nXi][nPosDtIni]
			Replace  		SZO->ZO_DATPRF		With  aCols[nXi][nPosDtFim]
			Replace  		SZO->ZO_IPI			With  aCols[nXi][nPosIpi]
			Replace  		SZO->ZO_LOCAL		With  aCols[nXi][nPosLocal]
			Replace  		SZO->ZO_OBS			With  aCols[nXi][nPosObs]
			Replace  		SZO->ZO_COND		With  cCondicao
			Replace  		SZO->ZO_CONTATO		With  cContato
			Replace  		SZO->ZO_FILENT		With  cFilEnt
			Replace  		SZO->ZO_EMISSAO		With  dDataBase
		    Replace  		SZO->ZO_STATUS      With  "O"		   
		    Replace  		SZO->ZO_STAUXI      With  "O"		   
	    EndIf
	Next nXi
	
EndIf 


If (cUserFunName=="Compromisso")  //Grava as Alterações do orçamento compromissado
	
    cQuery := ""
	cQuery := " UPDATE " + RetSQLName("SZO") + " SET D_E_L_E_T_  = '*'  "
	cQuery += " WHERE ZO_FILIAL = '" +xFilial("SZO")+ "' AND D_E_L_E_T_ <> '*'"
	cQuery += " AND ZO_NUM IN (" + LEFT(ALLTRIM(cRegDel1),LEN(ALLTRIM(cRegDel1))-1) + ")"
	cQuery += " AND ZO_FORNECE+ZO_LOJA IN (" + LEFT(ALLTRIM(cRegDel2),LEN(ALLTRIM(cRegDel2))-1) + ")"
	cQuery += " AND ZO_STATUS = 'C' "
	

	TCSQLExec(cQuery)	
    cQuery := 	""
	cQuery := " UPDATE " + RetSQLName("SC3") + " SET D_E_L_E_T_  = '*'  "
	cQuery += " WHERE C3_FILIAL = '" +xFilial("SC3")+ "' AND D_E_L_E_T_ <> '*'"
	cQuery += " AND C3_NUM IN (" + LEFT(ALLTRIM(cRegDel1),LEN(ALLTRIM(cRegDel1))-1) + ")"
	cQuery += " AND C3_FORNECE+C3_LOJA IN (" + LEFT(ALLTRIM(cRegDel2),LEN(ALLTRIM(cRegDel2))-1) + ")"
	
	TCSQLExec(cQuery)
	
	
	For nXi := 1 To Len(aCols)
		IF GDDELETED(nXi)
			Loop
		EndIF
		If RecLock("SC3",.T.)
			Replace  SC3->C3_FILIAL     With  xFilial("SC3") 
			Replace  SC3->C3_NUM		With  cNum
			Replace  SC3->C3_FORNECE	With  cA125Forn
			Replace  SC3->C3_LOJA		With  cA125Loj
			Replace  SC3->C3_ITEM 		With  aCols[nXi][nPosItem]
			Replace  SC3->C3_PRODUTO	With  aCols[nXi][nPosProd]
			Replace  SC3->C3_QUANT		With  aCols[nXi][nPosQuant]
			Replace  SC3->C3_PRECO  	With  aCols[nXi][nPosPrec]
			Replace  SC3->C3_TOTAL 		With  aCols[nXi][nPosTot]
			Replace  SC3->C3_DATPRI		With  aCols[nXi][nPosDtIni]
			Replace  SC3->C3_DATPRF		With  aCols[nXi][nPosDtFim]
			Replace  SC3->C3_IPI		With  aCols[nXi][nPosIpi]
			Replace  SC3->C3_LOCAL		With  aCols[nXi][nPosLocal]
			Replace  SC3->C3_OBS		With  aCols[nXi][nPosObs]
			Replace  SC3->C3_COND		With  cCondicao
			Replace  SC3->C3_CONTATO	With  cContato
			Replace  SC3->C3_FILENT		With  cFilEnt
			Replace  SC3->C3_EMISSAO	With  dDataBase
			MsUnLock()
		EndIF
	Next nXi	
	
	For nXi := 1 To Len(aCols)
		IF GDDELETED(nXi)
			Loop
		EndIF
		If RecLock("SZO",.T.)
			Replace  SZO->ZO_FILIAL   		    With  xFilial("SZO") 
			Replace  		SZO->ZO_NUM			With  cNum
			Replace  		SZO->ZO_FORNECE		With  cA125Forn
			Replace  		SZO->ZO_LOJA		With  cA125Loj
			Replace  		SZO->ZO_ITEM 		With  aCols[nXi][nPosItem]
			Replace  		SZO->ZO_PRODUTO		With  aCols[nXi][nPosProd]
			Replace  		SZO->ZO_QUANT		With  aCols[nXi][nPosQuant]
			Replace  		SZO->ZO_PRECO  		With  aCols[nXi][nPosPrec]
			Replace  		SZO->ZO_TOTAL 		With  aCols[nXi][nPosTot]
			Replace  		SZO->ZO_DATPRI		With  aCols[nXi][nPosDtIni]
			Replace  		SZO->ZO_DATPRF		With  aCols[nXi][nPosDtFim]
			Replace  		SZO->ZO_IPI			With  aCols[nXi][nPosIpi]
			Replace  		SZO->ZO_LOCAL		With  aCols[nXi][nPosLocal]
			Replace  		SZO->ZO_OBS			With  aCols[nXi][nPosObs]
			Replace  		SZO->ZO_COND		With  cCondicao
			Replace  		SZO->ZO_CONTATO		With  cContato
			Replace  		SZO->ZO_FILENT		With  cFilEnt
			Replace  		SZO->ZO_EMISSAO		With  dDataBase
		    Replace  		SZO->ZO_STATUS      With  "C"		   
		    Replace  		SZO->ZO_STAUXI      With  "C"		   
	    EndIf
	Next nXi
EndIf	

Return



User Function FAditivo
/*************************************************************************************
*Funcao que efetua a monta a tela para o aditivo de contrato
*
************************************/


Local   aAreaOLD   := GetArea()
Local   nUsado     := 0
Local   nOpcx      := 3
Local   cNumPesq   := SZO->ZO_NUM
Private oDlg
Private cNomeFor  := Posicione("SA2",1,xFilial("SA2")+SZO->ZO_FORNECE+SZO->ZO_LOJA,"A2_NOME")
Private cNum      := SZO->ZO_NUM    
Private cA125Forn := SZO->ZO_FORNECE
Private cA125Loj  := SZO->ZO_LOJA   
Private cFilEnt   := SZO->ZO_FILENT 
Private cCondicao := SZO->ZO_COND   
Private cContato  := SZO->ZO_CONTATO
Private dDate     := SZO->ZO_EMISSAO
Private cNumAdt   := "001"


If !SZO->ZO_STATUS $ "T|C|E"
    Return
EndIf

SZO->(dbSetOrder(2))
SZO->(dbSeek(xFilial("SZO")+cNumPesq+"A"))
If !SZO->(EOF())
   cNumAdt := StrZero((Val(SZO->ZO_ADITIVO)+1),3)
EndIf

cRotina := "ADITIVO" 
aCols   := {}
aHeader := {}

dbSelectArea("SX3")
dbSeek("SZO")
nUsado:=0
While !EOF() .And. (x3_arquivo == "SZO")
   IF X3USO(x3_usado) .AND. cNivel >= x3_nivel 
      nUsado:=nUsado+1
      AADD(aHeader,{ TRIM(x3_titulo), x3_campo, x3_picture,;
      x3_tamanho, x3_decimal,"AllwaysTrue()",;
      x3_usado, x3_tipo, x3_arquivo, x3_context })
    Endif
    dbSkip()
End

aCols:=Array(1,nUsado+1)    
dbSelectArea("SX3")
dbSeek("SZO")
nUsado:=0
While !Eof() .And. (x3_arquivo == "SZO")
	IF X3USO(x3_usado) .AND. cNivel >= x3_nivel
		nUsado:=nUsado+1
		IF nOpcx == 3
			IF x3_tipo == "C"
				If AllTrim(x3_campo) = "ZO_ITEM"
				   aCols[1][nUsado] := "001"
				 Else  
				   aCols[1][nUsado] := SPACE(x3_tamanho)
				 EndIf
			Elseif x3_tipo == "N"
				aCols[1][nUsado] := 0
			Elseif x3_tipo == "D"
				aCols[1][nUsado] := dDataBase
			Elseif x3_tipo == "M"
				aCols[1][nUsado] := ""
			Else
				aCols[1][nUsado] := .F.
			Endif
		Endif
	Endif
	dbSkip()
End
aCols[1][nUsado+1] := .F. 

@ 000,000 To 305,630 Dialog oDlg Title OemToAnsi("Contratos")
@ 017,005 Say OemtoAnsi("Número")
@ 017,028 Get cNum Picture "@!"  Size 040,025 When .F.
@ 017,070 Say OemtoAnsi("Emissão")
@ 016,095 Get dDate Picture "@!"  Size 040,025 When .F.
@ 017,140 Say OemtoAnsi("Fornecedor")
@ 016,170 Get  cA125Forn Picture "@!"  Size 065,025 When .F.
@ 016,238 Get  cA125Loj  Picture "@!"  When .F. Size 015,025
@ 017,258 Say OemtoAnsi("Cod.Pagto")
@ 016,288 Get  cCondicao F3 "SE4" Picture "@!"  Size 015,025 When .F.
@ 032,005 Say OemtoAnsi("Contato")
@ 031,028 Get cContato Picture "@!"  Size 120,025 When .F.
@ 032,155 Say OemtoAnsi("Filila p/Entrega")
@ 031,195 Get cFilEnt Picture "@!"  F3 CpoRetF3("ZO_FILENT","SM0") Size 015,025 When .F.
@ 032,225 Say OemtoAnsi("Aditivo")
@ 031,245 Get cNumAdt Picture "@!"  Size 040,025 Valid NaoVazio() when .F.


oGetBrw := MsGetDados():New(045,005,145,311,3,"U_FValidLinha","U_FValidLinha","+ZO_ITEM",.T.,,,,9999)

@ 145,005 Say OemtoAnsi("Fornecedor:")
@ 145,035 Say cNomeFor object oNomFor

Activate Dialog oDlg Center On Init EnchoiceBar(oDlg,{|| GravaAditivo(),oDlg:End()},{||oDlg:End()},,)

RestArea(aAreaOLD)

Return



Static Function GravaAditivo  
/***********************************************************************
* Funcao que efetua a gravacao do aditivo de contrato
*
**********************************/

Local nXi  := 0
Private nPosItem  := GDFieldPos("ZO_ITEM")
Private nPosProd  := GDFieldPos("ZO_PRODUTO")
Private nPosQuant := GDFieldPos("ZO_QUANT")
Private nPosPrec  := GDFieldPos("ZO_PRECO")
Private nPosTot   := GDFieldPos("ZO_TOTAL")
Private nPosDtIni := GDFieldPos("ZO_DATPRI")
Private nPosDtFim := GDFieldPos("ZO_DATPRF")
Private nPosIpi   := GDFieldPos("ZO_IPI")
Private nPosLocal := GDFieldPos("ZO_LOCAL")
Private nPosObs   := GDFieldPos("ZO_OBS")



For nXi := 1 To Len(aCols)
	IF GDDELETED(nXi)
		Loop
	EndIF
	If RecLock("SZO",.T.)
		Replace  SZO->ZO_FILIAL     With  xFilial("SZO") ,;
		SZO->ZO_NUM			With  cNum,;
		SZO->ZO_FORNECE		With  cA125Forn,;
		SZO->ZO_LOJA		With  cA125Loj,;
		SZO->ZO_ITEM 		With  aCols[nXi][nPosItem],;
		SZO->ZO_PRODUTO		With  aCols[nXi][nPosProd],;
		SZO->ZO_QUANT		With  aCols[nXi][nPosQuant],;
		SZO->ZO_PRECO  		With  aCols[nXi][nPosPrec],;
		SZO->ZO_TOTAL 		With  aCols[nXi][nPosTot],;
		SZO->ZO_DATPRI		With  aCols[nXi][nPosDtIni],;
		SZO->ZO_DATPRF		With  aCols[nXi][nPosDtFim],;
		SZO->ZO_IPI			With  aCols[nXi][nPosIpi],;
		SZO->ZO_LOCAL		With  aCols[nXi][nPosLocal],;
		SZO->ZO_OBS			With  aCols[nXi][nPosObs],;
		SZO->ZO_COND		With  cCondicao,;
		SZO->ZO_CONTATO		With  cContato,;
		SZO->ZO_FILENT		With  cFilEnt,;
		SZO->ZO_EMISSAO		With  dDataBase,;
		SZO->ZO_STATUS      With  "A",;
		SZO->ZO_ADITIVO     With cNumAdt,;
		SZO->ZO_STAUXI      With  "A"
		
		MsUnLock()
		ConfirmSX8("SZO")
	EndIF
Next nXi



For nXi := 1 To Len(aCols)
	IF GDDELETED(nXi)
		Loop
	EndIF
	If RecLock("SC3",.T.)
		Replace  SC3->C3_FILIAL     With  xFilial("SC3") ,;
		SC3->C3_NUM			With  cNum,;
		SC3->C3_FORNECE		With  cA125Forn,;
		SC3->C3_LOJA		With  cA125Loj,;
		SC3->C3_ITEM 		With  aCols[nXi][nPosItem],;
		SC3->C3_PRODUTO		With  aCols[nXi][nPosProd],;
		SC3->C3_QUANT		With  aCols[nXi][nPosQuant],;
		SC3->C3_PRECO  		With  aCols[nXi][nPosPrec],;
		SC3->C3_TOTAL 		With  aCols[nXi][nPosTot],;
		SC3->C3_DATPRI		With  aCols[nXi][nPosDtIni],;
		SC3->C3_DATPRF		With  aCols[nXi][nPosDtFim],;
		SC3->C3_IPI			With  aCols[nXi][nPosIpi],;
		SC3->C3_LOCAL		With  aCols[nXi][nPosLocal],;
		SC3->C3_OBS			With  aCols[nXi][nPosObs],;
		SC3->C3_COND		With  cCondicao,;
		SC3->C3_CONTATO		With  cContato,;
		SC3->C3_FILENT		With  cFilEnt,;
		SC3->C3_EMISSAO		With  dDataBase
		MsUnLock()
	EndIF
Next nXi	


Return



Static Function FExcluir
/***********************************************************************
* Permite ao usuario excluir orcamentos errados
*
***************************************/

Local cQuery := ""

If SZO->ZO_STATUS = "C"	
	cQuery := ""
	cQuery := " UPDATE " + RetSQLName("SC3") + " SET D_E_L_E_T_  = '*'  "
	cQuery += " WHERE C3_FILIAL = '" +xFilial("SC3")+ "' AND D_E_L_E_T_ <> '*'"
	cQuery += " AND C3_NUM IN (" + LEFT(ALLTRIM(cRegDel1),LEN(ALLTRIM(cRegDel1))-1) + ")"
	cQuery += " AND C3_FORNECE+C3_LOJA IN (" + LEFT(ALLTRIM(cRegDel2),LEN(ALLTRIM(cRegDel2))-1) + ")"
		
	TCSQLExec(cQuery)
	
EndIf

cQuery := ""
cQuery := " UPDATE " + RetSQLName("SZO") + " SET D_E_L_E_T_  = '*'  "
cQuery += " WHERE ZO_FILIAL = '" +xFilial("SZO")+ "' AND D_E_L_E_T_ <> '*'"
cQuery += " AND ZO_NUM IN (" + LEFT(ALLTRIM(cRegDel1),LEN(ALLTRIM(cRegDel1))-1) + ")"
cQuery += " AND ZO_FORNECE+ZO_LOJA IN (" + LEFT(ALLTRIM(cRegDel2),LEN(ALLTRIM(cRegDel2))-1) + ")"
cQuery += " AND ZO_STATUS = '"+ SZO->ZO_STATUS   +"'"
	
TCSQLExec(cQuery)


Return