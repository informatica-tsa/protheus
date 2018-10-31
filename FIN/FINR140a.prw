#include "FINR140.CH"
//#Include "PROTHEUS.Ch"
#Include "rwmake.Ch"
/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o	 ³ FINR140	³ Autor ³ Wagner Xavier 		  ³ Data ³ 01.06.92 		³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Fluxo de Caixa Analitico											 	³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe e ³ FINR140(void)														³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function Finr140a()
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Define Variaveis 														  ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
LOCAL wnrel
LOCAL cString:= "SE1"
LOCAL cDesc1 := STR0001  //"Este programa ir  imprimir o Fluxo de Caixa, informando      "
LOCAL cDesc2 := STR0002  //"ao usu rio quais as suas contas a receber e a pagar dia a    "
LOCAL cDesc3 := STR0003  //"dia e tambem seu dispon¡vel de acordo com os saldos banc rios"
Local aAplicSeh

PRIVATE titulo := OemToAnsi(STR0004)  // "Fluxo de Caixa Analitico"
PRIVATE cabec1
PRIVATE cabec2
PRIVATE tamanho:= "G"
PRIVATE aReturn	:= {OemToAnsi(STR0005), 1,OemToAnsi(STR0006), 2, 2, 1, "",1 }  // "Zebrado"###"Administracao"
PRIVATE nomeprog	:= "FINR140"
PRIVATE aLinha 	:= { }
//PRIVATE cPerg		:= "FIN140"
PRIVATE cPerg		:= "FLXCXA"
PRIVATE adCompras := {},adVendas:={}
PRIVATE aCompras	:= {},aVendas:={}
Private aCompAux := {}, aVendAux := {}
PRIVATE cErros 	:= ""
Private nRegs
Private cIpProj := GetMv("MV_IPPRJAP")
Private nLastKey:=0
Private nMoeda        := 1 // mv_par02

dbSelectArea("SM0")
nRegs:=SM0->(RecCount())
GetMv("MV_IPPRJAP")
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Verifica as perguntas selecionadas 								  ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
//pergunte("FIN140",.F.)
Pergunte("FLXCXA",.F.)

//aAplicSeh := Aplicacoes(mv_par02==1,nMoeda)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Variaveis utilizadas para parametros								  ³
//³ mv_par01				// Nro de Dias 								  ³
//³ mv_par02				// Moeda 										  ³
//³ mv_par03				// Imprime Por Filial ou Empresa 		  ³
//³ mv_par04				// Considera Pedidos de Vendas			  ³
//³ mv_par05				// Considera Pedidos de Compras			  ³
//³ mv_par06				// Considera Vencidos						  ³
//³ mv_par07				// Considera Comissoes						  ³
//³ mv_par08				// Considera Moedas							  ³
//³ mv_par09				// Do Prefixo       							  ³
//³ mv_par10				// At‚ o Prefixo       						  ³
//³ mv_par11				// Retroativo?         						  ³ 
//³ mv_par12				// Outras Moedas?    				        ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Definicao dos cabecalhos												  ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
cabec1 := OemToAnsi(STR0007)  //"Data Ref Prf Numero-PC     Tipo Dt Emiss Cli/For               Nome Cliente/Fornecedor     Historico                Valor Original         a Pagar             a Receber        Disponivel      Observacoes"
cabec2 := " "
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Envia controle para a funcao SETPRINT 							  ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
wnrel := "FINR140"            //Nome Default do relatorio em Disco
//wnrel := SetPrint(cString,wnrel,cPerg,@titulo,cDesc1,cDesc2,cDesc3,.F.,"",,Tamanho,"",.F.)

If nLastKey == 27
	Return
Endif

//SetDefault(aReturn,cString,.F.)

If nLastKey == 27
	Return
Endif


aPerg := {}
//RptStatus({|lEnd| Fa140Imp(@lEnd,wnRel,cString,aAplicSeh)},Titulo)
//Processa({|lEnd| Fa140Imp(@lEnd,wnRel,cString,aAplicSeh)},Titulo)
AADD(aPerg,{cPerg,"Numero de Dias    ?","N",03,0,"G","",""   ,"","","","",""})
AADD(aPerg,{cPerg,"Imprime por       ?","N",01,0,"C","",""   ,"Empresa","Filial","","",""})
AADD(aPerg,{cPerg,"Considera P.Venda ?","N",01,0,"C","",""   ,"Sim","Nao","","",""})
AADD(aPerg,{cPerg,"Considera P.Compra?","N",01,0,"C","",""   ,"Sim","Nao","","",""})
AADD(aPerg,{cPerg,"Prefixo Inicial   ?","C",03,0,"G","",""   ,"","","","",""})
AADD(aPerg,{cPerg,"Prefixo Final     ?","C",03,0,"G","",""   ,"","","","",""})
AADD(aPerg,{cPerg,"Somente Prefixos  ?","C",30,0,"G","",""   ,"","","","",""})
AADD(aPerg,{cPerg,"Exceto Prefixos   ?","C",30,0,"G","",""   ,"","","","",""})
AADD(aPerg,{cPerg,"Tipo Inicial      ?","C",03,0,"G","",""   ,"","","","",""})
AADD(aPerg,{cPerg,"Tipo Final        ?","C",03,0,"G","",""   ,"","","","",""})
AADD(aPerg,{cPerg,"Somente Tipos     ?","C",30,0,"G","",""   ,"","","","",""})
AADD(aPerg,{cPerg,"Exceto Tipos      ?","C",30,0,"G","",""   ,"","","","",""})
AADD(aPerg,{cPerg,"Natureza Inicial  ?","C",10,0,"G","","SED","","","","",""})
AADD(aPerg,{cPerg,"Natureza Final    ?","C",10,0,"G","","SED","","","","",""})
AADD(aPerg,{cPerg,"Somente Naturezas ?","C",30,0,"G","",""   ,"","","","",""})
AADD(aPerg,{cPerg,"Exceto Naturezas  ?","C",30,0,"G","",""   ,"","","","",""})
AADD(aPerg,{cPerg,"Considera Atrasos ?","N",01,0,"C","",""   ,"Sim","Nao","","",""})
AADD(aPerg,{cPerg,"Numero Dias Atraso?","N",03,0,"G","",""   ,"","","","",""})
AADD(aPerg,{cPerg,"Nivel Agrupamento ?","N",01,0,"C","",""   ,"Vencimento","Classificacao","Cliente/Fornecedor","Analitico",""})
AADD(aPerg,{cPerg,"Tipo Classificacao?","N",01,0,"C","",""   ,"Financeira","Contabil","","",""})
AADD(aPerg,{cPerg,"Digitos da Conta  ?","N",01,0,"G","",""   ,"","","","",""})
AADD(aPerg,{cPerg,"Somente Clas. Fin ?","C",30,0,"G","",""   ,"","","","",""}) //CRISLEI TOLEDO - 10/10/07
AADD(aPerg,{cPerg,"Exceto Clas. Fin  ?","C",30,0,"G","",""   ,"","","","",""}) //CRISLEI TOLEDO - 10/10/07



Pergunte(cPerg,.T.)

#IFDEF WINDOWS
   @ 0,0 TO 150,310 DIALOG oDlg TITLE "Fluxo de Caixa Analitico"
   @ 05,09 SAY "Geracao do Fluxo de Caixa Analitico customizado"
   @ 15,09 SAY " emitido em Crystal Report."
   @ 25,09 SAY ""
   @ 35,09 SAY ""

   @ 60,060 BMPBUTTON TYPE 05 ACTION Pergunte("FLXCXA",.T.)
   @ 60,090 BMPBUTTON TYPE 01 ACTION Processa({|lEnd| Fa140Imp(@lEnd,wnRel,cString,aAplicSeh)},Titulo) //MsgRun("Gerando Relatorio. Aguarde...","",{|| CursorWait(), fFin140(), CursorArrow()})
   @ 60,120 BMPBUTTON TYPE 02 ACTION Close(oDlg)
   ACTIVATE DIALOG oDlg CENTER
#ENDIF

Return(Nil)

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o	 ³ FA140Imp ³ Autor ³ Wagner Xavier 		  ³ Data ³ 01.06.92 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Fluxo de Caixa Analitico											  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe e ³ FA140IMP(lEnd,wnRel,cString)										  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ lEnd	  - A‡Æo do Codeblock										  ³±±
±±³			 ³ wnRel   - T¡tulo do relat¢rio 									  ³±±
±±³			 ³ cString - Mensagem													  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso		 ³ Generico 																  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function FA140Imp(lEnd,wnRel,cString,aAplicSeh)

LOCAL cbCont,CbTxt
LOCAL nDias
LOCAL nValor
LOCAL w
LOCAL nTotSaidas
LOCAL dDataVenc
LOCAL lAchou
LOCAL dDataAte
LOCAL dDataImp
LOCAL lFirst			:= .T.
LOCAL nDispon			:= 0
LOCAL nEl				:= 0
LOCAL nDiasInt			:= 0
LOCAL nJurDiario		:= 0
LOCAL nValJuros		:= 0
LOCAL nValGanho		:= 0
LOCAL aValAplic      := 0
LOCAL nTotTitR			:= 0
LOCAL nTotTitP			:= 0
LOCAL nTotGTitR		:= 0
LOCAL nTotGTitP		:= 0
LOCAL nRecHoje			:= 0
LOCAL nPagHoje			:= 0
LOCAL nTotAplic		:= 0
LOCAL nTotResg			:= 0
LOCAL nTotEntradas	:= 0
LOCAL aAplic			:= {}
LOCAL aResgate			:= {}
LOCAL aBancosA			:= {}
LOCAL aBancosR			:= {}
LOCAL nSalDup			:= 0
LOCAL cArqSA6			:= " "
LOCAL cArqSE1			:= " "
LOCAL cArqSE2			:= " "
LOCAL cArqSE5			:= " "
LOCAL cArqSEG			:= " "
LOCAL cArqSEH			:= " "
LOCAL cCondSE5			:= " "
LOCAL nIndexSE3
LOCAL nIndexSE1
LOCAL nIndexSE2
LOCAL nIndexSE5
LOCAL nIndexSEG
LOCAL nIndexSEH
LOCAL nApagVenc		:= 0 
LOCAL nArecVenc		:= 0 
LOCAL nComissoes	:= 0
LOCAL cArqSE3		:= ""
Local dDtSE8        := Ctod("")
Local lSldSE8		:= .F.
Local nIndSE8		:= 1
Local cArqSE8       := ""
Local nRegSa6       := 0
Local nRecSE8       := 0
Local nDecs			:= GetMv("MV_CENT"+(IIF(nMoeda > 1 , STR(nMoeda,1),""))) 
Local nMoedaBco		:= 1
Local cAplCotas   	:= GetMv("MV_APLCAL4")
Local nAscan
Local nXj

nNumDias := MV_PAR01
nTipoRel := MV_PAR02
nConPVen := MV_PAR03
nConPCom := MV_PAR04
cPrefIni := MV_PAR05
cPrefFin := MV_PAR06
cSomPref := MV_PAR07
cExcPref := MV_PAR08
cTipoIni := MV_PAR09
cTipoFin := MV_PAR10
cSomTipo := MV_PAR11
cExcTipo := MV_PAR12
cNatuIni := MV_PAR13
cNatuFin := MV_PAR14
cSomNatu := MV_PAR15
cExcNatu := MV_PAR16
nConAtra := MV_PAR17
nNumAtra := MV_PAR18
nNivDeta := MV_PAR19
nTipClas := MV_PAR20
nDigCta  := MV_PAR21
cSomClFn := MV_PAR22
cExcClFn := MV_PAR23

nConComi := 1  //1-Considera Comissoes 2-Nao Considera Comissoes
nSalRetr := 1  //1-Compoe Saldo Retroativo  2-Nao Compoe Saldo Retroativo
nOutMoed := 1  //1-Considera Outras Moedas 2-Nao Considera Outras Moedas

dDataIni := dDataBase          //MsDate()
dDataFin := dDataBase+nNumdias //MsDate()+nNumDias
dDataAtr := dDataBase-nNumAtra //MsDate()-nNumAtra

//Calcula as aplicacoes com Cotas Diarias
aAplicSeh := Aplicacoes(mv_par02==1,nMoeda)

//Prepara Tabela de Fluxo de Caixa
cQuery := "DELETE FROM "+RetSqlName("SZY")
TcSqlExec(cQuery)

nDigCTA  := 1
nTipClas := 1
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Variaveis utilizadas para Impressao do Cabecalho e Rodape	  ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
cbtxt  := SPACE(10)
cbcont := 0
li 	 := 80
m_pag  := 1

if nTipoRel == 2

	// Contas a receber
	dbSelectArea("SE1")
	cArqSE1 := SubStr(criatrab("",.f.),1,7)+"A"
	IndRegua("SE1",cArqSE1,"DTOS(E1_VENCREA)+E1_NOMCLI+E1_PREFIXO+E1_NUM+E1_PARCELA",,,OemToAnsi(STR0008))  //"Selecionando Registros..."
	nIndexSE1 := RetIndex("SE1") + 1
	#IFNDEF TOP
		SE1->(dbSetIndex(cArqSE1+OrdBagExt()))
	#ENDIF
	dbSetOrder( nIndexSE1 ) 
	
	// Contas a pagar
	dbSelectArea("SE2")
	cArqSE2 := SubStr(criatrab("",.f.),1,7)+"B"
	IndRegua("SE2",cArqSE2,"DTOS(E2_VENCREA)+E2_NOMFOR+E2_PREFIXO+E2_NUM+E2_PARCELA+E2_TIPO",,,OemToAnsi(STR0008))  //"Selecionando Registros..."
	nIndexSE2 := RetIndex("SE2") + 1
	#IFNDEF TOP
		SE2->(dbSetIndex(cArqSE2+OrdBagEXT()))
	#ENDIF
	dbSetOrder( nIndexSE2 )
		
	// Movimentacao bancaria
	dbSelectArea("SE5")
	cArqSE5 := SubStr(criatrab("",.f.),1,7)+"C"
	IndRegua("SE5",cArqSE5,"DTOS(E5_DATA)+E5_BANCO+E5_AGENCIA+E5_CONTA",,,OemToAnsi(STR0008))  //"Selecionando Registros..."
	nIndexSE5 := RetIndex("SE5") + 1
	#IFNDEF TOP
		SE5->(dbSetIndex(cArqSE5+OrdBagEXt()))
	#ENDIF

	//Contas Correntes
	If !Empty(xFilial("SA6"))
		dbSelectArea("SA6")
		cArqSA6 := CriaTrab(,.F.)
		IndRegua("SA6",cArqSA6,"A6_COD+A6_AGENCIA+A6_NUMCON",,,OemToAnsi(STR0008))  //"Selecionando Registros..."
		nIndSA6 := RetIndex("SA6") + 1
		#IFNDEF TOP
			dbSetIndex(cArqSA6+OrdBagExT())
		#ENDIF
		dbSetOrder(nIndSA6)
	Endif

	// Saldo Bancario
	dbSelectArea("SE8")
	cArqSE8 := CriaTrab(,.F.)
	IndRegua("SE8",cArqSE8,"E8_BANCO+E8_AGENCIA+E8_CONTA+DTOS(E8_DTSALAT)",,,OemToAnsi(STR0008))  //"Selecionando Registros..."
	nIndSE8 := RetIndex("SE8") + 1
	#IFNDEF TOP
		dbSetIndex(cArqSE8+OrdBagExT())
	#ENDIF
	dbSetOrder(nIndSE8)

	// Aplicacoes e emprestimos
	dbSelectArea("SEG")
	cArqSEG := SubStr(criatrab("",.f.),1,7)+"D"
	IndRegua("SEG",cArqSEG,"DTOS(EG_DATARES)+EG_BANCO+EG_AGENCIA+EG_CONTA",,,OemToAnsi(STR0008))  //"Selecionando Registros..."
	SEG->(dbCommit())
	nIndexSEG := RetIndex("SEG") + 1
	#IFNDEF TOP
		SEG->(dbSetIndex(cArqSEG+OrdBagEXT()))
	#ENDIF
	// Aplicacoes e emprestimos
	dbCommit()
	dbSelectArea("SEH")
	cArqSEH := criatrab("",.f.)
	IndRegua("SEH",cArqSEH,"EH_STATUS+EH_APLEMP",,,OemToAnsi(STR0008))  //"Selecionando Registros..."
	SEH->(dbCommit())
	nIndexSEH := RetIndex("SEH") + 1
	#IFNDEF TOP
		SEH->(dbSetIndex(cArqSEH+OrdBagExt()))
	#ENDIF
Endif

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Cria indice condicional temporario para analise das comissoes ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
if nConComi == 1		// Analisa comissoes == Sim

	If Empty(cArqSE3)

		dbSelectArea("SE3")
		cArqSE3 := SubStr(criatrab("",.f.),1,7)+"E"
		cChave := "DTOS(E3_DATA)"
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³Condicao 1 - Somente filial 			  ³
		//³Condicao 2 - Todas filias (Empresa)	  ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		#IFDEF TOP
			if nTipoRel == 1
				// Nao Alterar o ctod(01/01/80)
				cCond := 'DTOS(E3_DATA)<="'+Dtos(ctod("01/01/80","ddmmyy"))+'".AND.E3_FILIAL=="'+xFilial("SE3")+'"'
			else
				cCond := 'DTOS(E3_DATA)<="'+Dtos(ctod("01/01/80","ddmmyy"))+'"'
			endif
		#ELSE
			If nTipoRel == 1
				cCond := "EMPTY(E3_DATA) .and. E3_FILIAL == xfilial('SE3')"
			Else
				cCond := "EMPTY(E3_DATA)"
			Endif
		#ENDIF
		
		IndRegua("SE3",cArqSE3,cChave,,cCond,OemToAnsi(STR0008))  //"Selecionando Registros..."
		dbSelectArea("SE3")
		nIndexSE3		:= RetIndex("SE3") + 1
		#IFNDEF TOP
			SE3->(dbSetIndex(cArqSE3+OrdBagExt()))
		#ENDIF
		dbSetOrder(nIndexSE3)
		SE3->(DbGoTop())
	Else
		dbSelectArea("SE3")
		nIndexSE3		:= RetIndex("SE3") + 1
		#IFNDEF TOP
			SE3->(dbSetIndex(cArqSE3+OrdBagExt()))
		#ENDIF
		dbSetOrder( nIndexSE3 )
	Endif
Endif

Titulo += " em "+GetMV("MV_MOEDA"+AllTrim(Str(nMoeda,2)))
dDataAte := dDataBase+nNumDias

IF nMoeda != 1
	cSuf := AllTrim(Str(nMoeda,2))
	cabec1 := OemToAnsi(STR0009) //"Data Ref Prf Numero    PC Tipo Dt Emiss Cli/For               Nome Cliente/Fornecedor     Historico                  Valor Original          a Receber            a Pagar          Disponivel         Taxa do Dia    Observacoes"
	dbSelectArea("SM2")
	dbSeek( dDataBase )
EndIF

IF li == 80
	cabec(titulo,cabec1,cabec2,nomeprog,tamanho,NumImp())
End

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Imprime disponibilidade Bancaria									  ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
dbSelectArea("SA6")
If ( nTipoRel == 1 )
	dbSeek(cFilial)
Else
	dbGotop()
EndIf
cSuf := AllTrim(Str(nMoeda,2,0))
While ! SA6->(Eof()) .and. If(nTipoRel==1,SA6->A6_FILIAL == cFilial,.T.)
	
	IF li > 58
		cabec(titulo,cabec1,cabec2,nomeprog,tamanho,NumImp())
		lFirst:=.T.
	EndIF
	
	IF SA6->A6_FLUXCAI == "N"
		SA6->(dbSkip())
		Loop
	Endif
	nRegSa6 := RecNo()
	If lFirst
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Verifica se houve movimenta‡„o bancaria no dia da emissao do fluxo³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		dbSelectArea("SE5")
		// 1-Verifica filial
		If nTipoRel == 1
			cCondSE5 := "!EOF() .and. E5_DATA == dDataBase .And. E5_FILIAL == xFilial('SE5')"
		Else
			cCondSE5 := "!EOF() .and. E5_DATA == dDataBase"
		Endif
		
		If nTipoRel == 1  // 1-Verifica Filial
			dbSetOrder(1)
			dbSeek(cFilial+DTOS(dDataBase))
		Else
			dbSetOrder(nIndexSE5)
			dbSeek(DTOS(dDataBase))
		Endif
		
		While &cCondSE5
			
			IF nTipoRel == 1 .and. E5_FILIAL != cFilial
				Exit
			EndIF
			
			IF E5_SITUACA == "C" .or. E5_TIPODOC $ "JRşMTşDCşBAşCMşJ2şM2şD2şC2şV2şCXşCPüTL"
				dbSkip( )
				Loop
			EndIf

			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Verifica se existe baixas estornadas           ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			If TemBxCanc(E5_PREFIXO+E5_NUMERO+E5_PARCELA+E5_TIPO+E5_CLIFOR+E5_LOJA+E5_SEQ)
				dbskip()
				loop
			EndIf
			nMoedaTit := BuscaMoeda()
        		
			If cPaisLoc	# "BRA".And.!Empty(SE5->E5_BANCO+SE5->E5_AGENCIA+SE5->E5_CONTA)
				SA6->(DbSetOrder(1))
				SA6->(DbSeek(xFilial()+SE5->E5_BANCO+SE5->E5_AGENCIA+SE5->E5_CONTA))
				nMoedaBco	:=	Max(SA6->A6_MOEDA,1)
			Else
				nMoedaBco	:=	1
			Endif

            If nOutMoed = 2
               If nMoedaBco <> nMoeda   
                  SE5->(dbSkip())
                  Loop
               EndIf
            EndIf
			
			IF E5_TIPODOC == "AP"  .And. E5_RECPAG = "P"     //Aplicacoes
				nTotAplic += xMoeda(E5_VALOR,nMoedaBco,nMoeda,E5_DATA,nDecs+1)
				nEl := Ascan(aBancosA,E5_BANCO)
				IF nEl == 0
					AADD(aBancosA,E5_BANCO)
					AADD(aAplic,{E5_BANCO,E5_VALOR,E5_FILIAL})
				Else
					aAplic[nEl][2] += xMoeda(E5_VALOR,nMoedaBco,nMoeda,E5_DATA,nDecs+1)
				EndIf
			ElseIf E5_TIPODOC == "AP" .And. E5_RECPAG = "R"      //Estorno de Aplicacoes
				nTotAplic -= xMoeda(E5_VALOR,nMoedaBco,nMoeda,E5_DATA,nDecs+1)
				nEl := Ascan(aBancosA,E5_BANCO)
				IF nEl == 0
					AADD(aBancosA,E5_BANCO)
					AADD(aAplic,{E5_BANCO,E5_VALOR,E5_FILIAL})
				Else
					aAplic[nEl][2] -= xMoeda(E5_VALOR,nMoedaBco,nMoeda,E5_DATA,nDecs+1)
				EndIf
			ElseIf E5_TIPODOC == "RF" .And. E5_RECPAG = "R"  //Resgates
				nTotResg += xMoeda(E5_VALOR,nMoedaBco,nMoeda,E5_DATA,nDecs+1)
				nEl := Ascan(aBancosR,E5_BANCO)
				IF nEl == 0
					AADD(aBancosR,E5_BANCO)
					AADD(aResgate,{E5_BANCO,E5_VALOR,E5_FILIAL})
				Else
					aResgate[nEl][2]+=xMoeda(E5_VALOR,nMoedaBco,nMoeda,E5_DATA,nDecs+1)
				EndIf
			ElseIf E5_TIPODOC == "RF" .And. E5_RECPAG = "P"  //Estorno de Resgates
				nTotResg -= xMoeda(E5_VALOR,nMoedaBco,nMoeda,E5_DATA,nDecs+1)
				nEl := Ascan(aBancosR,E5_BANCO)
				IF nEl == 0
					AADD(aBancosR,E5_BANCO)
					AADD(aResgate,{E5_BANCO,E5_VALOR,E5_FILIAL})
				Else
					aResgate[nEl][2]-=xMoeda(E5_VALOR,nMoedaBco,nMoeda,E5_DATA,nDecs+1)
				EndIf	
			ElseIf E5_TIPODOC == "EP" .And. E5_RECPAG=="R" // Emprestimo
				nRecHoje += Iif(nMoeda == 1,xMoeda(E5_VALOR,nMoedaBco,1,E5_DATA,nDecs+1),;
									 xMoeda(E5_VLMOED2,nMoedaTit,nMoeda,E5_DATA,nDecs+1))
			ElseIf E5_TIPODOC == "EP" .And. E5_RECPAG=="P" // Estorno de Emprestimo
				nRecHoje -= Iif(nMoeda == 1,xMoeda(E5_VALOR,nMoedaBco,1,E5_DATA,nDecs+1),;
									 xMoeda(E5_VLMOED2,nMoedaTit,nMoeda,E5_DATA,nDecs+1))
			ElseIf E5_TIPODOC == "PE" .And. E5_RECPAG=="P" // Pagamento de emprestimo
				nPagHoje += Iif(nMoeda == 1,xMoeda(E5_VALOR,nMoedaBco,1,E5_DATA,nDecs+1),;
									 xMoeda(E5_VLMOED2,nMoedaTit,nMoeda,E5_DATA,nDecs+1))
			ElseIf E5_TIPODOC == "PE" .And. E5_RECPAG=="R" // Estorno de pagamento de emprestimo
				nPagHoje -= Iif(nMoeda == 1,xMoeda(E5_VALOR,nMoedaBco,1,E5_DATA,nDecs+1),;
									 xMoeda(E5_VLMOED2,nMoedaTit,nMoeda,E5_DATA,nDecs+1))
			ElseIf E5_RECPAG == "R" .And. ! E5_TIPODOC $ "EP#PE#AP#RF"
				// Movimento a receber que nao seja emprestimo nem pagto de emprestimo
				nRecHoje += Iif(nMoeda == 1,xMoeda(E5_VALOR,nMoedaBco,1,E5_DATA,nDecs+1),;
									 xMoeda(E5_VLMOED2,nMoedaTit,nMoeda,E5_DATA,nDecs+1))
			ElseIf E5_RECPAG == "P" .And. ! E5_TIPODOC $ "EP#PE#AP#RF"
				// Movimento a pagar que nao seja emprestimo nem pagto de emprestimo
				nPagHoje += Iif(nMoeda == 1,xMoeda(E5_VALOR,nMoedaBco,1,E5_DATA,nDecs+1),;
									 xMoeda(E5_VLMOED2,nMoedaTit,nMoeda,E5_DATA,nDecs+1))	 
			EndIf
			
			dbSkip()
			
		End
		
		IF (nPagHoje+nRecHoje+nTotAplic+nTotResg) != 0
			@li,0 PSAY OemToAnsi(STR0010)  //"Movimentacao na data ate a hora da emissao"
			nTotEntradas := nTotResg + nRecHoje
			nTotSaidas	 := nTotAplic + nPagHoje
			li++
			@li,	0 PSAY OemToAnsi(STR0011)+Replicate(".",109)  //"Aplicacoes "
			@li,141 PSAY IIF(nMoeda == 1,nTotAplic,nTotAplic / &('SM2->M2_MOEDA'+cSuf))  PicTure tm(IIF(nMoeda==1,nTotAplic,nTotAplic/&('SM2->M2_MOEDA'+cSuf)),16,nDecs)
			fGravSZY("SAIDA", "APL", dDataBase,"" ,"" ,"" , dDataBase,"" ,"" ,"" ,"" , IIF(nMoeda == 1,nTotAplic,nTotAplic / &('SM2->M2_MOEDA'+cSuf)), "AP",OemToAnsi(STR0011)+Replicate(".",109),"" ,"","")
			IF nTotAplic>0
				For w := 1 To Len(aBancosA)
					li++
					@li,  4 PSAY aAplic[w][1]
					dbSelectArea("SA6")
					If ( xFilial("SA6") == Space(2) )
						dbSeek(cFilial+aAplic[w][1])
					Else
						dbSeek(aAplic[w,3]+aAplic[w][1])
					EndIf
					@li,  9 PSAY AllTrim(A6_NREDUZ)+Replicate(".",90-Len(AllTrim(A6_NREDUZ)))
					@li,123 PSAY IIF(nMoeda==1,aAplic[w][2],aAplic[w][2]/&('SM2->M2_MOEDA'+cSuf))	PicTure tm(IIF(nMoeda==1,aAplic[w][2],aAplic[w][2]/&('SM2->M2_MOEDA'+cSuf)),16,nDecs)
			        fGravSZY("SAIDA", "APL", dDataBase,"" ,"" ,"" , dDataBase,"" ,"" ,"" ,"" , IIF(nMoeda==1,aAplic[w][2],aAplic[w][2]/&('SM2->M2_MOEDA'+cSuf)), "AP",AllTrim(A6_NREDUZ)+Replicate(".",90-Len(AllTrim(A6_NREDUZ))),"" ,"","")
				Next w
			EndIF
			li++
			@li,	0 PSAY OemToAnsi(STR0012)+Replicate(".",111)  //  "Resgates "
			@li,160 PSAY IIF(nMoeda==1,nTotResg,nTotResg/&('SM2->M2_MOEDA'+cSuf))	 PicTure tm(IIF(nMoeda==1,nTotResg,nTotResg/&('SM2->M2_MOEDA'+cSuf)),16,nDecs)
			fGravSZY("ENTRADA", "RES", dDataBase,"" ,"" ,"" , dDataBase,"" ,"" ,"" ,"" , IIF(nMoeda==1,nTotResg,nTotResg/&('SM2->M2_MOEDA'+cSuf)), "RE",OemToAnsi(STR0012)+Replicate(".",111),"" ,"","")
			IF nTotResg>0
				For w:=1 To Len(aBancosR)
					li++
					@li,  4 PSAY aResgate[w][1]
					dbSelectArea("SA6")
					If ( xFilial("SA6") == Space(2) )
						dbSeek(cFilial+aResgate[w][1])
					Else
						dbSeek(aResgate[w,3]+aResgate[w][1])
					EndIf
					@li,  9 PSAY AllTrim(A6_NREDUZ)+Replicate(".",90-Len(AllTrim(A6_NREDUZ)))
					@li,123 PSAY IIF(nMoeda==1,aResgate[w][2],aResgate[w][2]/&('SM2->M2_MOEDA'+cSuf))  PicTure tm(IIF(nMoeda==1,aResgate[w][2],aResgate[w][2]/&('SM2->M2_MOEDA'+cSuf)),16,nDecs)
			        fGravSZY("ENTRADA", "RES", dDataBase,"" ,"" ,"" , dDataBase,"" ,"" ,"" ,"" , IIF(nMoeda==1,aResgate[w][2],aResgate[w][2]/&('SM2->M2_MOEDA'+cSuf)), "RE",AllTrim(A6_NREDUZ)+Replicate(".",90-Len(AllTrim(A6_NREDUZ))),"" ,"","")
				Next w
			EndIF
			li++
			@li,	0 PSAY OemToAnsi(STR0013)+Replicate(".",106)  //"Outras Saidas "
			@li,141 PSAY IIF(nMoeda==1,nPagHoje,nPagHoje/&('SM2->M2_MOEDA'+cSuf))  PicTure tm(IIF(nMoeda==1,nPagHoje,nPagHoje/&('SM2->M2_MOEDA'+cSuf)),16,nDecs)
			fGravSZY("SAIDA", "OUT", dDataBase,"" ,"" ,"" , dDataBase,"" ,"" ,"" ,"" , IIF(nMoeda==1,nPagHoje,nPagHoje/&('SM2->M2_MOEDA'+cSuf)), "RE",OemToAnsi(STR0013)+Replicate(".",106),"" ,"","")
			li++
			@li,	0 PSAY OemToAnsi(STR0014)+Replicate(".",104)  //"Outras Entradas "
			@li,160 PSAY IIF(nMoeda==1,nRecHoje,nRecHoje/&('SM2->M2_MOEDA'+cSuf))  PicTure tm(IIF(nMoeda==1,nRecHoje,nRecHoje/&('SM2->M2_MOEDA'+cSuf)),16,nDecs)
			fGravSZY("ENTRADA", "OUT", dDataBase,"" ,"" ,"" , dDataBase,"" ,"" ,"" ,"" , IIF(nMoeda==1,nRecHoje,nRecHoje/&('SM2->M2_MOEDA'+cSuf)), "RE",OemToAnsi(STR0014)+Replicate(".",104),"" ,"","")
			li+=2
			@li,	0 PSAY OemToAnsi(STR0015)+Replicate(".",90)  //"Totais ate a hora da emissao "
			@li,141 PSAY IIF(nMoeda==1,nTotSaidas,nTotSaidas/&('SM2->M2_MOEDA'+cSuf))	PicTure tm(IIF(nMoeda==1,nTotSaidas,nTotSaidas/&('SM2->M2_MOEDA'+cSuf)),16,nDecs)
			@li,160 PSAY IIF(nMoeda==1,nTotEntradas,nTotEntradas/&('SM2->M2_MOEDA'+cSuf))  PicTure tm(IIF(nMoeda==1,nTotEntradas,nTotEntradas/&('SM2->M2_MOEDA'+cSuf)),16,nDecs)
			li++
			@li,0 PSAY Replicate("-",220)
			li+=2
			nPagHoje := 0
			nRecHoje := 0
			nTotAplic:= 0 
			nTotResg := 0
		EndIF
	EndIF
	
	dbSelectArea("SA6")
	dbGoTo(nRegSa6)
	dbSelectArea("SE8")
	dbSetOrder( nIndSE8 )
	If !(dbSeek(If(nTipoRel==1,xFilial(),"")+SA6->A6_COD+SA6->A6_AGENCIA+SA6->A6_NUMCON+DtoS(dDataBase),.t.))
		dbSkip( -1 )
		dDtSE8  := SE8->E8_DTSALAT
		lSldSE8 := .F. 
		nRecSE8 := SE8->(RECNO())
		While (  !Bof() .And. If(nTipoRel==1,xFilial()==SE8->E8_FILIAL,.T.) .And.;
					SA6->A6_COD+SA6->A6_AGENCIA+SA6->A6_NUMCON == ;
					SE8->E8_BANCO+SE8->E8_AGENCIA+SE8->E8_CONTA .And.;
					SE8->E8_DTSALAT == dDtSE8 )
				nRecSE8 := SE8->(RECNO())
				dbSkip(-1)	
				lSldSE8 := .T.
		EndDo
		If ( lSldSE8 )
			If SE8->(Bof())
				dbGoTo(nRecSE8)
			Else
				dbSkip()
			Endif
		EndIf
	EndIf
	nValor := 0
	While ( !Eof() .And. If(nTipoRel==1,xFilial("SE8")==SE8->E8_FILIAL,.T.) .And.;
		SA6->A6_COD+SA6->A6_AGENCIA+SA6->A6_NUMCON == ;
	  	SE8->E8_BANCO+SE8->E8_AGENCIA+SE8->E8_CONTA .And.;
	   SE8->E8_DTSALAT <= dDataBase)
		nValor += xMoeda(SE8->E8_SALATUA,If(cPaisLoc=="BRA",1,Max(SA6->A6_MOEDA,1)),nMoeda)
		dbSkip()
	Enddo
	nLimCred := xMoeda(SA6->A6_LIMCRED,If(cPaisLoc=="BRA",1,Max(SA6->A6_MOEDA,1)),nMoeda)
	If nValor != 0
		If lFirst
			@ li,0 PSAY OemToAnsi(STR0016)  //"Disponibilidade imediata"
			lFirst := .f.
		EndIf
		li++
		@li,	0 PSAY SA6->A6_NREDUZ + "  (" + SA6->A6_COD + ")" +;
			Space(6)+"  AG: " + SA6->A6_AGENCIA + "  C/C: " +;
			SA6->A6_NUMCON
			
		@li,179 PSAY nValor	Picture tm(nValor,16,nDecs)
		fGravSZY("SALDO", "BCO", dDataBase, "BCO", "", "", dDataBase, "", "", "", "", nValor, "BC",Left(SA6->A6_NREDUZ,15)+" (" + SA6->A6_COD + ")"+" AG: "+SA6->A6_AGENCIA+" C/C: "+SA6->A6_NUMCON, "", "","")
		//li++
		//@li,0 PSAY OemToAnsi(STR0027)+Replicate(".",134)  //"Limite de Credito: "
		//@li,179 PSAY nLimCred Picture tm(nLimCred,16,nDecs)
		//nDispon += (nValor+nLimCred)
		nDispon += nValor
	Endif
	dbSelectArea("SA6")
	// Se emitido por empresa e o SA6 for Exclusivo, posiciono na proxima conta diferenciada
	// ja que a rotina ja aglutinou os saldos de contas identicas (Bco/Age/Cta) que existam 
	// nas diferentes filiais
	If nTipoRel = 2 .and. !Empty(xFilial("SA6"))
		SA6->(dbSeek(SE8->E8_BANCO+SE8->E8_AGENCIA+SE8->E8_CONTA))
	Else
		dbGoTo(nRegSa6)
		SA6->(dbSkip())
	Endif
	lFirst := .f.
EndDO

IF (nRegSa6 != 0)
	li += 2
	@li, 0 PSAY OemToAnsi(STR0017) +Replicate(".",135)  //"Total Disponivel "
	@li,179 PSAY nDispon	PicTure tm(nDispon,16,nDecs)
EndIF

IF !lFirst
	li++
EndIF

lFirst := .T.
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Soma Titulos vencidos - a receber e a pagar						 ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If nConAtra = 1	 // Considera titulos em atraso
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Soma Contas a pagar vencida pela data de Vencimento			  ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
#IFDEF TOP
	IF TcSrvType() != "AS/400" 
		cOrdSE2 := SqlOrder(SE2->(Indexkey()))
		cRecPagAnt := FormatIn( MVPAGANT, "/" )
		cQuery := "SELECT *"
		cQuery += " FROM " + RetSqlName("SE2")
		If nTipoRel == 1
			cQuery += " WHERE E2_FILIAL = '" + xFilial("SE2") + "'"
		Else
			cQuery += " WHERE E2_FILIAL between ' ' AND 'zz'"
		Endif
		cQuery += " AND E2_PREFIXO between '" + cPrefIni + "' AND '"+cPrefFin + "'"
		cQuery += " AND E2_MOEDA IN " + StrTran(FormatIn(AllTrim('12345'),,1),"'","")
		cQuery += " AND E2_VENCREA <= '" + Dtos(dDataBase-1) +"'"
		cQuery += " AND E2_TIPO NOT IN " + cRecPagAnt
		If nSalRetr == 2
			cQuery += " AND E2_SALDO > 0 "
		Endif
		If nOutMoed == 2
			cQuery += " AND E2_MOEDA = " + Str(nMoeda,2)
		Endif
		cQuery += " AND E2_FLUXO <> 'N'"
		cQuery += " AND E2_EMIS1 <= '"+Dtos(dDataBase) +"'"
		cQuery += " AND D_E_L_E_T_ = ' '"
		cQuery += " ORDER BY " + cOrdSE2
		
		cQuery := ChangeQuery(cQuery)
		dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),"E2VENC",.T.,.T.)
		aEval(SE2->(DbStruct()), {|e| If(e[2]!= "C", TCSetField("E2VENC", e[1], e[2],e[3],e[4]),Nil)})
		ProcRegua(RecCount())
		While ! E2VENC->(EOF())
			IncProc()
			If E2VENC->E2_BAIXA > dDataBase .And. nSalRetr == 1
				nSaldo:=SaldoTit(E2VENC->E2_PREFIXO,E2VENC->E2_NUM,E2VENC->E2_PARCELA,E2VENC->E2_TIPO,E2VENC->E2_NATUREZA,"P",E2VENC->E2_FORNECE,nMoeda,E2VENC->E2_VENCREA,dDataBase,E2VENC->E2_LOJA,,If(cPaisLoc=="BRA",E2VENC->E2_TXMOEDA,0))
			Else
				nSaldo:=xMoeda((E2VENC->E2_SALDO+E2VENC->E2_SDACRES-E2VENC->E2_SDDECRE),E2VENC->E2_MOEDA,nMoeda,E2VENC->E2_VENCREA,nDecs+1,If(cPaisLoc=="BRA",E2VENC->E2_TXMOEDA,0))
			EndIf

			If E2VENC->E2_TIPO $ MVABATIM .or. E2VENC->E2_TIPO $ MV_CPNEG
				nApagVenc -= nSaldo
				nVlrPgFlx := nSaldo*-1
			Else
				nApagVenc += nSaldo
				nVlrPgFlx := nSaldo
			Endif

			//Posiciona Fornecedor
			dbSelectArea("SA2")
			dbSetOrder(1) //Filial+Codigo+Loja
			dbSeek(xFilial("SA2")+E2VENC->E2_FORNECE+E2VENC->E2_LOJA)
			
			//Posiciona na Natureza
			dbSelectArea("SED")
			dbSetOrder(1) //Filial+Codigo
			dbSeek(xFilial("SED")+E2VENC->E2_NATUREZ)

			//Posiciona Tabela de Classificacao
			dbSelectArea("SX5")
			dbSetOrder(1) //Filial+Tabela+Chave
			dbSeek(xFilial("SX5")+"99"+SA2->A2_CLASFIN)
			
			//Posiciona na Conta Contabil
			dbSelectArea("CT1")
			dbSetOrder(1) //Filial+Conta
			dbSeek(xFilial("CT1")+Left(SED->ED_CONTA,nDigCTA))

			fGravSZY("SAIDA", E2VENC->E2_TIPO, E2VENC->E2_VENCREA, E2VENC->E2_PREFIXO, E2VENC->E2_NUM, E2VENC->E2_PARCELA, E2VENC->E2_EMISSAO, E2VENC->E2_FORNECE, E2VENC->E2_LOJA, SA2->A2_NOME, Iif(nTipClas==1,SX5->X5_DESCRI,CT1->CT1_DESC01), nVlrPgFlx, "CP",E2VENC->E2_HIST, E2VENC->E2_NATUREZ, "",Iif(nTipClas==1,SX5->X5_CHAVE,CT1->CT1_CONTA))

			E2VENC->(dbSkip())
		Enddo
		dbCloseArea()
		dbSelectArea("SE2")
	Else
#ENDIF
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³Soma Contas a pagar vencida pela data de Vencimento			  ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		dDataVenc := dDataBase-1
		
		dbSelectArea("SE2")
		If nTipoRel == 1
			If lFirst
				RetIndex("SE2")
			EndIf
			dbSelectArea("SE2")
			SE2->(dbSetOrder(3))
			SE2->(dbSeek(cFilial+DTOS(CTOD("01/01/60","ddmmyy")) ,.t.))
		Else
			dbGoTop()
		EndIf
		
		While ! SE2->(EOF()) .And. SE2->E2_VENCREA <= dDataVenc
			
			IF nTipoRel == 1 .and. SE2->E2_FILIAL != cFilial
				Exit
			EndIf
			
			If SE2->E2_TIPO $ MVPAGANT
				SE2->(dbSkip())
				Loop
			EndIf
			
			If ! ( AllTrim(Str(SE2->E2_MOEDA,2)) $ '12345' )
				dbSkip()
				Loop
			EndIf
			
			If SE2->E2_SALDO == 0 .and. IIf(nSalRetr==1,SE2->E2_BAIXA <= dDataBase,.T.)
				SE2->(dbSkip())
				Loop
			EndIf
			
			IF SE2->E2_PREFIXO < cPrefIni .or. SE2->E2_PREFIXO > cPrefFin  //Do Prefixo ao Prefixo
				SE2->(dbSkip())
				Loop
			EndIF
			
			If SE2->E2_FLUXO == "N" .or. SE2->E2_EMIS1 > dDataBase
				dbSkip()
				Loop
			EndIf
			
	        If nOutMoed = 2
	           If SE2->E2_MOEDA != nMoeda   
	              SE2->(dbSkip())
	              Loop
	           EndIf
	        EndIf
		
			If SE2->E2_BAIXA > dDataBase .And. nSalRetr == 1
				nSaldo:=SaldoTit(SE2->E2_PREFIXO,SE2->E2_NUM,SE2->E2_PARCELA,SE2->E2_TIPO,SE2->E2_NATUREZA,"P",SE2->E2_FORNECE,nMoeda,SE2->E2_VENCREA,dDataBase,SE2->E2_LOJA,,If(cPaisLoc=="BRA",SE2->E2_TXMOEDA,0))
			Else
				nSaldo:=xMoeda((SE2->E2_SALDO+SE2->E2_SDACRES-SE2->E2_SDDECRE),SE2->E2_MOEDA,nMoeda,SE2->E2_VENCREA,nDecs+1,If(cPaisLoc=="BRA",SE2->E2_TXMOEDA,0))
			EndIf
			
			If SE2->E2_TIPO $ MVABATIM .Or. SE2->E2_TIPO $ MV_CPNEG
				nApagVenc -= nSaldo
				nVlrPgFlx := nSaldo*-1
			Else
				nApagVenc += nSaldo
				nVlrPgFlx := nSaldo
			EndIf

			//Posiciona Fornecedor
			dbSelectArea("SA2")
			dbSetOrder(1) //Filial+Codigo+Loja
			dbSeek(xFilial("SA2")+SE2->E2_FORNECE+SE2->E2_LOJA)
			
			//Posiciona na Natureza
			dbSelectArea("SED")
			dbSetOrder(1) //Filial+Codigo
			dbSeek(xFilial("SED")+SE2->E2_NATUREZ)

			//Posiciona Tabela de Classificacao
			dbSelectArea("SX5")
			dbSetOrder(1) //Filial+Tabela+Chave
			dbSeek(xFilial("SX5")+"99"+SA2->A2_CLASFIN)
			
			//Posiciona na Conta Contabil
			dbSelectArea("CT1")
			dbSetOrder(1) //Filial+Conta
			dbSeek(xFilial("CT1")+Left(SED->ED_CONTA,nDigCTA))

			fGravSZY("SAIDA", SE2->E2_TIPO, SE2->E2_VENCREA, SE2->E2_PREFIXO, SE2->E2_NUM, SE2->E2_PARCELA, SE2->E2_EMISSAO, SE2->E2_FORNECE, SE2->E2_LOJA, SA2->A2_NOME, Iif(nTipClas==1,SX5->X5_DESCRI,CT1->CT1_DESC01), nVlrPgFlx, "CP",SE2->E2_HIST, SE2->E2_NATUREZ, "",Iif(nTipClas==1,SX5->X5_CHAVE,CT1->CT1_CONTA))

			SE2->(dbSkip())
		End
#IFDEF TOP
	Endif
#ENDIF
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Soma Contas a receber vencida pela data de Vencimento		³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
#IFDEF TOP
	IF TcSrvType() != "AS/400" 
		cRecPagAnt := FormatIn( MVRECANT + "/" + MVIRF, "/" )
		cOrdSE1 := SqlOrder(SE1->(Indexkey()))
		cQuery := "SELECT * "
		cQuery += " FROM " + RetSqlName("SE1")
		If nTipoRel == 1
			cQuery += " WHERE E1_FILIAL = '" + xFilial("SE1") + "'"
		Else
			cQuery += " WHERE E1_FILIAL between ' ' AND 'zz'"
		Endif
		cQuery += " AND E1_PREFIXO between '" + cPrefIni + "' AND '"+cPrefFin + "'"
		cQuery += " AND E1_MOEDA IN " + StrTran(FormatIn(AllTrim('12345'),,1),"'","")
		cQuery += " AND E1_VENCREA <= '" + Dtos(dDataBase-1) +"'"
		cQuery += " AND E1_TIPO NOT IN " + cRecPagAnt
		cQuery += " AND E1_SITUACA NOT IN ('2','7')"
		If nSalRetr == 2
			cQuery += " AND E1_SALDO > 0 "
		Endif
		If nOutMoed == 2
			cQuery += " AND E1_MOEDA = " + Str(nMoeda,2)
		Endif
		cQuery += " AND E1_FLUXO <> 'N'"
		cQuery += " AND E1_EMISSAO <= '"+Dtos(dDataBase) +"'"
		cQuery += " AND D_E_L_E_T_ = ' '"
		cQuery += " ORDER BY " + cOrdSE1
		
		cQuery := ChangeQuery(cQuery)
		dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),"E1VENC",.T.,.T.)
		aEval(SE1->(DbStruct()), {|e| If(e[2]!= "C", TCSetField("E1VENC", e[1], e[2],e[3],e[4]),Nil)})
		ProcRegua(RecCount())	
		While ! E1VENC->(EOF())
			IncProc()
			If E1VENC->E1_BAIXA > dDataBase .And. nSalRetr == 1
				nSaldo:=SaldoTit(E1VENC->E1_PREFIXO,E1VENC->E1_NUM,E1VENC->E1_PARCELA,E1VENC->E1_TIPO,E1VENC->E1_NATUREZA,"R",E1VENC->E1_CLIENTE,nMoeda,E1VENC->E1_VENCREA,dDataBase,E1VENC->E1_LOJA,,If(cPaisLoc=="BRA",E1VENC->E1_TXMOEDA,0))
			Else
				nSaldo:=xMoeda((E1VENC->E1_SALDO+E1VENC->E1_SDACRES-E1VENC->E1_SDDECRE),E1VENC->E1_MOEDA,nMoeda,E1VENC->E1_VENCREA,nDecs+1,If(cPaisLoc=="BRA",E1VENC->E1_TXMOEDA,0))
			End
			IF E1VENC->E1_TIPO $ MVABATIM .OR. E1VENC->E1_TIPO $ MV_CRNEG
				nArecVenc -= nSaldo
				nVlrRcFlx := nSaldo*-1
			Else
				nArecVenc += nSaldo
				nVlrRcFlx := nSaldo
			EndIf

			//Posiciona Cliente
			dbSelectArea("SA1")
			dbSetOrder(1) //Filial+Codigo+Loja
			dbSeek(xFilial("SA1")+E1VENC->E1_CLIENTE+E1VENC->E1_LOJA)
			
			//Posiciona na Natureza
			dbSelectArea("SED")
			dbSetOrder(1) //Filial+Codigo
			dbSeek(xFilial("SED")+E1VENC->E1_NATUREZ)

			//Posiciona Tabela de Classificacao
			dbSelectArea("SX5")
			dbSetOrder(1) //Filial+Tabela+Chave
			dbSeek(xFilial("SX5")+"99"+SA1->A1_CLASFIN)
			
			//Posiciona na Conta Contabil
			dbSelectArea("CT1")
			dbSetOrder(1) //Filial+Conta
			dbSeek(xFilial("CT1")+Left(SED->ED_CONTA,nDigCTA))

			fGravSZY("ENTRADA", E1VENC->E1_TIPO, E1VENC->E1_VENCREA, E1VENC->E1_PREFIXO, E1VENC->E1_NUM, E1VENC->E1_PARCELA, E1VENC->E1_EMISSAO, E1VENC->E1_CLIENTE, E1VENC->E1_LOJA, SA1->A1_NOME, Iif(nTipClas==1,SX5->X5_DESCRI,CT1->CT1_DESC01), nVlrRcFlx, "CR",E1VENC->E1_HIST, E1VENC->E1_NATUREZ, "",Iif(nTipClas==1,SX5->X5_CHAVE,CT1->CT1_CONTA))

			E1VENC->(dbSkip())
		Enddo
		dbCloseArea()
		dbSelectArea("SE1")
	Else	
#ENDIF
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³Soma Contas a receber vencida pela data de Vencimento			  ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		dbSelectArea("SE1")
		If nTipoRel == 1
			If lFirst
				RetIndex("SE1")
			EndIf
			dbSelectArea("SE1")
			SE1->(dbSetOrder(7))
			SE1->(dbseek(cFilial+DTOS(CTOD("01/01/60","ddmmyy")),.T.))
		Else
			dbGoTop()
		EndIf
		
		While ! SE1->(EOF()) .and. SE1->E1_VENCREA <= dDataVenc
			
			IF nTipoRel == 1 .and. cFilial != SE1->E1_FILIAL
				Exit
			EndIf
			
			If SE1->E1_TIPO $ MVRECANT
				SE1->(dbSkip())
				Loop
			EndIf
			
			IF SE1->E1_PREFIXO < cPrefIni .or. SE1->E1_PREFIXO > cPrefFin  //Do Prefixo ao Prefixo
				SE1->(dbSkip())
				Loop
			EndIF
			
			If ! ( AllTrim(Str(SE1->E1_MOEDA,2)) $ '12345' )
				dbSkip( )
				Loop
			EndIf
			
			If SE1->E1_FLUXO == "N" .or. SE1->E1_EMISSAO > dDatabase
				dbSkip()
				Loop
			EndIf
			
			IF SE1->E1_SALDO == 0 .AND. IIF(nSalRetr == 1,SE1->E1_BAIXA <= dDataBase,.T.)
				SE1->(dbSkip())
				Loop
			EndIf
		
	        If nOutMoed = 2
	           If SE1->E1_MOEDA != nMoeda   
	              SE1->(dbSkip())
	              Loop
	           EndIf
	        EndIf
			
			If SE1->E1_BAIXA > dDataBase .And. nSalRetr == 1
				nSaldo:=SaldoTit(SE1->E1_PREFIXO,SE1->E1_NUM,SE1->E1_PARCELA,SE1->E1_TIPO,SE1->E1_NATUREZA,"R",SE1->E1_CLIENTE,nMoeda,SE1->E1_VENCREA,dDataBase,SE1->E1_LOJA,,If(cPaisLoc=="BRA",SE1->E1_TXMOEDA,0))
			Else
				nSaldo:=xMoeda((SE1->E1_SALDO+SE1->E1_SDACRES-SE1->E1_SDDECRE),SE1->E1_MOEDA,nMoeda,SE1->E1_VENCREA,nDecs+1,If(cPaisLoc=="BRA",SE1->E1_TXMOEDA,0))
			End
			
			IF SE1->E1_SITUACA != "2" .And. SE1->E1_SITUACA != "7"
				IF SE1->E1_TIPO $ MVABATIM .OR. SE1->E1_TIPO $ MV_CRNEG
					nArecVenc -= nSaldo
				    nVlrRcFlx := nSaldo*-1
				Else
					nArecVenc += nSaldo
				    nVlrRcFlx := nSaldo
				EndIf
			EndIf

			//Posiciona Cliente
			dbSelectArea("SA1")
			dbSetOrder(1) //Filial+Codigo+Loja
			dbSeek(xFilial("SA1")+SE1->E1_CLIENTE+SE1->E1_LOJA)
			
			//Posiciona na Natureza
			dbSelectArea("SED")
			dbSetOrder(1) //Filial+Codigo
			dbSeek(xFilial("SED")+SE1->E1_NATUREZ)

			//Posiciona Tabela de Classificacao
			dbSelectArea("SX5")
			dbSetOrder(1) //Filial+Tabela+Chave
			dbSeek(xFilial("SX5")+"99"+SA1->A1_CLASFIN)
			
			//Posiciona na Conta Contabil
			dbSelectArea("CT1")
			dbSetOrder(1) //Filial+Conta
			dbSeek(xFilial("CT1")+Left(SED->ED_CONTA,nDigCTA))

			//fGravSZY("ENTRADA", SE1->E1_TIPO, SE1->E1_VENCREA, SE1->E1_PREFIXO, SE1->E1_NUM, SE1->E1_PARCELA, SE1->E1_EMISSAO, SE1->E1_CLIENTE, SE1->E1_LOJA, SA1->A1_NOME, Iif(nTipClas==1,SX5->X5_DESCRI,CT1->CT1_DESC01), nVlrRcFlx, "CR",SE1->E1_HIST, SE1->E1_NATUREZ, "")
			
			SE1->(dbSkip())
		End
#IFDEF TOP
	Endif
#ENDIF		
	If nArecVenc # 0 .or. nApagVenc # 0
		nDispon += nArecVenc
		nDispon -= nApagVenc
		li++
		@ li,000 PSAY OemToAnsi(STR0018)  //"Total de Titulos Vencidos"
		@ li,141 PSAY nApagVenc Picture tm(nApagVenc,16,nDecs)
		@ li,160 PSAY nArecVenc Picture tm(nArecVenc,16,nDecs)
		@ li,179 PSAY nDispon   Picture tm(nDispon,16,nDecs)
		li ++
	Endif
Endif

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Soma as Comissoes. Os criterios de selecao dos registros foram³
//³determinados no instante da criacao do indice condicional.	  ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
if nConComi == 1
	DbSelectArea("SE3")
	dbGoTop()
	While !Eof() .and. SE3->E3_DATA <= dDataBase
		nComissoes += xMoeda(SE3->E3_COMIS,1,nMoeda)
		dbSkip()
	End
	If nComissoes # 0
		li ++
		nDispon -= nComissoes
		@ li,000 PSAY OemToAnsi(STR0019)  //"Total de Comissoes A Pagar"
		@ li,141 PSAY nComissoes Picture tm(nComissoes,16,nDecs)
		@ li,179 PSAY nDispon 	Picture tm(nDispon,16,nDecs)
		li++
	Endif
Endif

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Acessa titulos iniciais												  ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
nDias := (dDataAte-dDataBase)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Controle da Regua 														  ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
ProcRegua(nDias)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Verifica Pedidos de Compra e de Venda								  ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If nConPVen == 1
	//fc020Venda( mv_par08 )
	f020Ven('12345')
Endif

If nConPCom == 1
	//fc020Compra(,,,nMoeda)
	f020Com(,,,nMoeda)
Endif

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Soma Contas a Receber pela data de Vencimento					  ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
For nXj := 1 To nDias
	
	dDataVenc := dDataBase+nXj-1
	
	lAchou := .F.
	dbSelectArea("SE1")
	
	If nTipoRel == 1
		dbSetOrder(7)
		dbseek(cFilial+DTOS(dDataVenc))
	Else
		dbSetOrder( nIndexSE1 )
		dbSeek(DTOS(dDataVenc))
	Endif
	
	IncProc()
	
	While !Eof() .And. SE1->E1_VENCREA == dDataVenc
		
		IF nTipoRel == 1 .and. SE1->E1_FILIAL != cFilial
			Exit
		EndIF
		
		If SE1->E1_TIPO $ MVRECANT
			dbSkip()
			Loop
		Endif
		
		IF SE1->E1_PREFIXO < cPrefIni .or. SE1->E1_PREFIXO > cPrefFin  //Do Prefixo ao Prefixo
			SE1->(dbSkip())
			Loop
		EndIF
		
		If ! ( AllTrim(Str(SE1->E1_MOEDA,2)) $ '12345' )
			dbSkip( )
			Loop
		EndIf
		
		If SE1->E1_FLUXO == "N" .or. SE1->E1_EMISSAO > dDatabase
			dbSkip()
			Loop
		EndIf
		
		IF ( SE1->E1_SALDO = 0 .and. IIF( nSalRetr == 1, SE1->E1_BAIXA <= dDataBase, .T. )  ) .or. SE1->E1_SITUACA $ "27"
			dbSkip()
			Loop
		EndIF
	
        If nOutMoed = 2
           If SE1->E1_MOEDA != nMoeda   
              SE1->(dbSkip())
              Loop
           EndIf
        EndIf

		If SE1->E1_BAIXA > dDataBase .And. nSalRetr == 1
			nSaldup:=SaldoTit(SE1->E1_PREFIXO,SE1->E1_NUM,SE1->E1_PARCELA,SE1->E1_TIPO,SE1->E1_NATUREZA,"R",SE1->E1_CLIENTE,nMoeda,SE1->E1_VENCREA,dDataBase,SE1->E1_LOJA,,If(cPaisLoc=="BRA",SE1->E1_TXMOEDA,0))
		Else
			nSaldup:=xMoeda((SE1->E1_SALDO+SE1->E1_SDACRES-SE1->E1_SDDECRE),SE1->E1_MOEDA,nMoeda,SE1->E1_VENCREA,nDecs+1,If(cPaisLoc=="BRA",SE1->E1_TXMOEDA,0))
		End
		
		dbSelectArea("SE1")
		
		If nTipoRel == 1
			dbSetOrder(7)
		Endif
		
		IF SE1->E1_TIPO $ MVABATIM+"/"+MV_CRNEG
			nDispon-=nSalDup
		Else
			nDispon+=nSalDup
		EndIf
		
		IF li > 58
			cabec(titulo,cabec1,cabec2,nomeprog,tamanho,NumImp())
		EndIf
		
		li++
		IF !lAchou
			@li, 0 PSAY SE1->E1_VENCREA
		EndIf
		
		@li, 11 PSAY SE1->E1_PREFIXO
		@li, 15 PSAY SE1->E1_NUM+(IIF(!EMPTY(SE1->E1_PARCELA),"-",""))+SE1->E1_PARCELA
		@li, 30 PSAY SE1->E1_TIPO
		@li, 34 PSAY SE1->E1_EMISSAO
		@li, 45 PSAY SE1->E1_CLIENTE
		@li, 68 PSAY SubStr(SE1->E1_NOMCLI,1,25)
		@li, 96 PSAY SubStr(SE1->E1_HIST,1,25)
		@li,123 PSAY xMoeda(SE1->E1_VALOR+SE1->E1_ACRESC-SE1->E1_DECRESC,SE1->E1_MOEDA,nMoeda,dDataVenc,,If(cPaisLoc=="BRA",SE1->E1_TXMOEDA,0))  Picture PesqPict("SE1","E1_VALOR",16,nMoeda)
		@li,160 PSAY nSalDup	Picture tm(nSalDup,16,nDecs)
		@li,179 PSAY nDispon	Picture tm(nDispon,16,nDecs)
		IF nMoeda != 1 .and. !lAchou
			@li,199 PSAY &('SM2->M2_MOEDA'+cSuf) Picture tm(&('SM2->M2_MOEDA'+cSuf),10)
			dDataImp:=dDataVenc
		EndIf

	    //Posiciona Cliente
		dbSelectArea("SA1")
		dbSetOrder(1) //Filial+Codigo+Loja
		dbSeek(xFilial("SA1")+SE1->E1_CLIENTE+SE1->E1_LOJA)
			
		//Posiciona na Natureza
		dbSelectArea("SED")
		dbSetOrder(1) //Filial+Codigo
		dbSeek(xFilial("SED")+SE1->E1_NATUREZ)

		//Posiciona Tabela de Classificacao
		dbSelectArea("SX5")
		dbSetOrder(1) //Filial+Tabela+Chave
		dbSeek(xFilial("SX5")+"99"+SA1->A1_CLASFIN)
			
		//Posiciona na Conta Contabil
		dbSelectArea("CT1")
		dbSetOrder(1) //Filial+Conta
		dbSeek(xFilial("CT1")+Left(SED->ED_CONTA,nDigCTA))

		nVlrRcFlx:= xMoeda(SE1->E1_VALOR+SE1->E1_ACRESC-SE1->E1_DECRESC,SE1->E1_MOEDA,nMoeda,SE1->E1_VENCREA,,If(cPaisLoc=="BRA",SE1->E1_TXMOEDA,0))
			
		lAchou:=.t.
		dbSelectArea("SE1")
		IF SE1->E1_TIPO $ MVABATIM+"/"+MV_CRNEG
			nTotTitR -= nSalDup
			nVlrRcFlx:=nSalDup*-1
		Else
			nTotTitR += nSalDup
			nVlrRcFlx:=nSalDup
		End
		fGravSZY("ENTRADA", SE1->E1_TIPO, SE1->E1_VENCREA, SE1->E1_PREFIXO, SE1->E1_NUM, SE1->E1_PARCELA, SE1->E1_EMISSAO, SE1->E1_CLIENTE, SE1->E1_LOJA, SA1->A1_NOME, Iif(nTipClas==1,SX5->X5_DESCRI,CT1->CT1_DESC01), nVlrRcFlx, "CR",SE1->E1_HIST, SE1->E1_NATUREZ, "",Iif(nTipClas==1,SX5->X5_CHAVE,CT1->CT1_CONTA))
		dbSelectArea("SE1")
		dbSkip()
	EndDO
   If cIpProj =="S"
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Verifica se existe aplica‡„o a ser resgatada no dia				³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	dbSelectArea("SEG")
	If nTipoRel == 1
		dbSetOrder(2)
		dbSeek(cFilial+Dtos(dDataVenc))
	Else
		dbSetOrder(nIndexSEG)
		dbSeek(Dtos(dDataVenc))
	Endif
	
	lAchou :=.f.
	While !Eof() .And. EG_DATARES == dDataVenc
		
		IF nTipoRel == 1 .and. EG_FILIAL != cFilial
			Exit
		End
		
		If SEG->EG_TIPO == "EMP"
			dbSkip( )
			Loop
		End
		nDiasInt	:= EG_DATARES-EG_DATA	//Dias de Intervalo
		nJurDiario:= EG_TAXA/nDiasInt	  //Juros Diario
		nValJuros := EG_VALOR+((EG_VALOR*nJurDiario)/100)*nDiasInt
		nValGanho := nValJuros-EG_VALOR
		nValJuros -= nValGanho*EG_IMPOSTO/100 //Impostos
		IF nMoeda == 1
			nDispon += nValJuros
		Else
			dbSelectArea("SM2")
			dbSeek( dDataVenc )
			nDispon += nValJuros/&('SM2->M2_MOEDA'+cSuf)
		EndIF
		dbSelectArea("SEG")
		li++
			IF !lAchou
				@li, 0 PSAY EG_DATARES
			EndIF
			
			fGravSZY("ENTRADA", "RES", dDataBase,"RES" ,"" ,"" ,dDataBase,"" ,"" ,"Resgate Aplicacao"+ SEG->EG_TIPO + "-" + SEG->EG_BANCO,"RESGATE",IIF(nMoeda==1,EG_VALOR,EG_VALOR/&('SM2->M2_MOEDA'+cSuf)), "RE","Resgate Aplicacao"+ SEG->EG_TIPO + "-" + SEG->EG_BANCO,Replicate("9",10) ,"","","")

			@li,011 PSAY OemToAnsi(STR0021)+ SEG->EG_TIPO + " - " + SEG->EG_BANCO  //"Projecao de Resgate de Aplicacao "
			@li,123 PSAY IIF(nMoeda==1,EG_VALOR,EG_VALOR/&('SM2->M2_MOEDA'+cSuf)) Picture tm(IIF(nMoeda==1,EG_VALOR,EG_VALOR/&('SM2->M2_MOEDA'+cSuf)),16,nDecs)
			@li,160 PSAY IIF(nMoeda==1,nValJuros,nValJuros/&('SM2->M2_MOEDA'+cSuf))	  Picture tm(IIF(nMoeda==1,nValJuros,nValJuros/&('SM2->M2_MOEDA'+cSuf)),16,nDecs)
			@li,179 PSAY nDispon		Picture tm(nDispon, 16,nDecs)

			IF nMoeda!=1 .and. !lAchou
				dbSelectArea("SM2")
				dbSeek(dDataVenc)
				@li,199 PSAY &('SM2->M2_MOEDA'+cSuf) Picture tm(&('SM2->M2_MOEDA'+cSuf),10)
			EndIF


			lAchou:=.T.
		dbSelectArea("SEG")
		nTotTitR	+= IIF(nMoeda==1,nValJuros,nValJuros/&('SM2->M2_MOEDA'+cSuf))
		dbSkip()
	EndDO
	dbSelectArea("SEH")
	If nTipoRel == 1
		dbSetOrder(2)
		dbSeek(xFilial("SEH")+"A")
	Else
		dbSetOrder(nIndexSEH)
		dbSeek("A")
	Endif

	lAchou := .f.
	While ( !Eof() .And.If(nTipoRel==1,SEH->EH_FILIAL==xFilial("SEH"),.T.) .And.;
				SEH->EH_STATUS == "A" )
		If ( SEH->EH_APLEMP != "EMP" )
			If ( Empty(SEH->EH_DATARES) .And. nXj==1 ) .Or.;
				( SEH->EH_DATARES == dDataVenc )
				nValJuros := SEH->EH_SALDO
				If !SEH->EH_TIPO $ cAplCotas
					aValAplic := Fa171Calc(	dDataVenc,,,,,,,, nTipoRel = 1)
					nValJuros += aValAplic[5]-aValAplic[2]-aValAplic[3]-aValAplic[4]
				Else
					aValAplic := {0,0,0,0,0,0}
					nAscan := Ascan(aAplicSeh, {|e|	e[1] == SEH->EH_CONTRAT .And.;
													 		   e[2] == SEH->EH_BCOCONT .And.;
															   e[3] == SEH->EH_AGECONT})
					If nAscan > 0																	   
						aValAplic :=	Fa171Calc(dDataVenc,SEH->EH_SLDCOTA,,,,SE9->E9_VLRCOTA,aAplicSeh[nAscan][6],(SEH->EH_SLDCOTA * aAplicSeh[nAscan][6]))
					Endif	
					nValJuros := xMoeda(aValAplic[1]-(aValAplic[2]+aValAplic[3]+aValAplic[4]),1,nMoeda)
				Endif
			Else
				nValJuros := 0
			EndIf
			If ( nValJuros != 0 )
				IF nMoeda == 1
					nDispon += (nValJuros)
				Else
					dbSelectArea("SM2")
					dbSetOrder(1)
					dbSeek( dDataVenc )
					nDispon += (nValJuros)/&('SM2->M2_MOEDA'+cSuf)
				EndIf
				li++
				IF !lAchou
					@li, 0 PSAY SEH->EH_DATARES
				EndIF
				
				fGravSZY("ENTRADA", SEH->EH_TIPO,dDataBase, "RES" ,"" ,"" ,dDataBase,"" ,"" ,"Resgate Aplicacao"+ SEH->EH_TIPO + "-" + SEH->EH_BANCO,"RESGATE" , If(nMoeda==1,SEH->EH_SALDO,SEH->EH_SALDO/&('SM2->M2_MOEDA'+cSuf)), "RE","Resgate Aplicacao"+ SEH->EH_TIPO + "-" + SEH->EH_BANCO,SEH->EH_NATUREZ,"","")
				
				@li,011 PSAY OemToAnsi(STR0021)+SEH->EH_TIPO+" - "+SEH->EH_BANCO  //"Projecao de Resgate de Aplicacao "
				@li,123 PSAY If(nMoeda==1,SEH->EH_SALDO,SEH->EH_SALDO/&('SM2->M2_MOEDA'+cSuf)) PICTURE TM(If(nMoeda==1,SEH->EH_SALDO,SEH->EH_SALDO/&('SM2->M2_MOEDA'+cSuf)),16,nDecs)
				@li,160 PSAY If(nMoeda==1,nValJuros,nValJuros/&('SM2->M2_MOEDA'+cSuf))	  PICTURE TM(If(nMoeda==1,nValJuros,nValJuros/&('SM2->M2_MOEDA'+cSuf)),16,nDecs)
				@li,179 PSAY nDispon		Picture tm(nDispon, 16,nDecs)
				IF ( nMoeda != 1 .And. !lAchou )
					dbSelectArea("SM2")
					dbSetOrder(1)
					dbSeek(dDataVenc)
					@li,199 PSAY &('SM2->M2_MOEDA'+cSuf) Picture tm(&('SM2->M2_MOEDA'+cSuf),10)
				EndIf
			EndIf

			lAchou:=.T.
			nTotTitR	+= If(nMoeda==1,nValJuros,nValJuros/&('SM2->M2_MOEDA'+cSuf))
		EndIf
		dbSelectArea("SEH")
		dbSkip()
	EndDo
Endif
	dbSelectArea("SE2")
	If nTipoRel == 1
		If lFirst
			RetIndex("SE2")
		End
		SE2->(dbSetOrder(3))
		SE2->(dbSeek(cFilial+DTOS(dDataVenc) ,.t.))
	Else
		dbSetOrder( nIndexSE2 )
		SE2->(dbSeek(DTOS(dDataVenc)),.t.)
	End
	
	lAchou := .f.
	While !Eof() .And. E2_VENCREA == dDataVenc
		
		IF nTipoRel == 1 .and. E2_FILIAL != cFilial
			Exit
		EndIF
		
		If SE2->E2_SALDO == 0 .and. IIf(nSalRetr==1,SE2->E2_BAIXA <= dDataBase,.t.)
			SE2->(dbSkip())
			Loop
		End
		
        If nOutMoed = 2
           If SE2->E2_MOEDA != nMoeda   
              SE2->(dbSkip())
              Loop
           EndIf
        EndIf
		
		If SE2->E2_BAIXA > dDataBase .And. nSalRetr == 1
			nSaldup:=SaldoTit(SE2->E2_PREFIXO,SE2->E2_NUM,SE2->E2_PARCELA,SE2->E2_TIPO,SE2->E2_NATUREZA,"P",SE2->E2_FORNECE,nMoeda,SE2->E2_VENCREA,dDataBase,SE2->E2_LOJA,,If(cPaisLoc=="BRA",SE2->E2_TXMOEDA,0))
		Else
			nSaldup:=xMoeda((SE2->E2_SALDO+SE2->E2_SDACRES-SE2->E2_SDDECRE),SE2->E2_MOEDA,nMoeda,SE2->E2_VENCREA,nDecs+1,If(cPaisLoc=="BRA",SE2->E2_TXMOEDA,0))
		End
		
		If E2_TIPO $ MVPAGANT
			dbSkip( )
			Loop
		Endif
		
		IF SE2->E2_PREFIXO < cPrefIni .or. SE2->E2_PREFIXO > cPrefFin  //Do Prefixo ao Prefixo
			SE2->(dbSkip())
			Loop
		EndIF
		
		If ! ( AllTrim(Str(SE2->E2_MOEDA,2)) $ '12345' )
			dbSkip()
			Loop
		End
		
		If SE2->E2_FLUXO == "N" .or. SE2->E2_EMIS1 > dDataBase
			dbSkip()
			Loop
		End
		
		dbSelectArea("SE2")
		If nTipoRel == 1
			dbSetOrder(3)
		Endif
		
		IF E2_TIPO $ MVABATIM+"/"+MV_CPNEG
			nDispon+=nSalDup
		Else
			nDispon-=nSalDup
		Endif
		
		IF li > 58
			cabec(titulo,cabec1,cabec2,nomeprog,tamanho,NumImp())
		Endif
		
		li++
		IF !lAchou
			@li, 0 PSAY SE2->E2_VENCREA
		EndIF
		@li, 11 PSAY SE2->E2_PREFIXO
		@li, 15 PSAY SE2->E2_NUM+(IIF(!EMPTY(SE2->E2_PARCELA),"-",""))+SE2->E2_PARCELA
		@li, 30 PSAY SE2->E2_TIPO
		@li, 34 PSAY SE2->E2_EMISSAO
		@li, 45 PSAY SE2->E2_FORNECEDOR
		@li, 68 PSAY SubStr(SE2->E2_NOMFOR,1,25)
		@li, 96 PSAY SubStr(SE2->E2_HIST,1,25)
		@li,123 PSAY xMoeda(SE2->E2_VALOR+SE2->E2_ACRESC-SE2->E2_DECRESC,SE2->E2_MOEDA,nMoeda,dDataVenc,,If(cPaisLoc=="BRA",SE2->E2_TXMOEDA,0))  Picture PesqPict("SE2","E2_VALOR",16,nMoeda)
		@li,141 PSAY nSalDup					Picture tm(nSalDup,16,nDecs)
		@li,179 PSAY nDispon					Picture tm(nDispon,16,nDecs)
		IF nMoeda!=1 .and. !lAchou
			dbSelectArea("SM2")
			dbSeek(dDataVenc)
			@li,199 PSAY &('SM2->M2_MOEDA'+cSuf) Picture tm(&('SM2->M2_MOEDA'+cSuf),10)
		EndIF

		//Posiciona Fornecedor
		dbSelectArea("SA2")
		dbSetOrder(1) //Filial+Codigo+Loja
		dbSeek(xFilial("SA2")+SE2->E2_FORNECE+SE2->E2_LOJA)
			
		//Posiciona na Natureza
		dbSelectArea("SED")
		dbSetOrder(1) //Filial+Codigo
		dbSeek(xFilial("SED")+SE2->E2_NATUREZ)

		//Posiciona Tabela de Classificacao
		dbSelectArea("SX5")
		dbSetOrder(1) //Filial+Tabela+Chave
		dbSeek(xFilial("SX5")+"99"+SA2->A2_CLASFIN)
			
		//Posiciona na Conta Contabil
		dbSelectArea("CT1")
		dbSetOrder(1) //Filial+Conta
		dbSeek(xFilial("CT1")+Left(SED->ED_CONTA,nDigCTA))

		//nVlrPgFlx := xMoeda(SE2->E2_VALOR+SE2->E2_ACRESC-SE2->E2_DECRESC,SE2->E2_MOEDA,nMoeda,SE2->E2_VENCREA,,If(cPaisLoc=="BRA",SE2->E2_TXMOEDA,0))

		lAchou:=.T.
		dbSelectArea("SE2")
		IF E2_TIPO $ MVABATIM+"/"+MV_CPNEG
			nTotTitP -= nSalDup
			nVlrPgFlx := nSalDup*-1
		Else
			nTotTitP += nSalDup
			nVlrPgFlx := nSalDup
		End
		fGravSZY("SAIDA", SE2->E2_TIPO, SE2->E2_VENCREA, SE2->E2_PREFIXO, SE2->E2_NUM, SE2->E2_PARCELA, SE2->E2_EMISSAO, SE2->E2_FORNECE, SE2->E2_LOJA, SA2->A2_NOME, Iif(nTipClas==1,SX5->X5_DESCRI,CT1->CT1_DESC01), nVlrPgFlx, "CP",SE2->E2_HIST, SE2->E2_NATUREZ, "",Iif(nTipClas==1,SX5->X5_CHAVE,CT1->CT1_CONTA))

		dbSelectArea("SE2")
		dbSkip()
	End
   If cIpProj =="S"
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Verifica se existe emprestimo a pagar no dia.					  ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	dbSelectArea( "SEG" )
	If nTipoRel == 1
		dbSetOrder(2)
		dbSeek(cFilial+Dtos(dDataVenc))
	Else
		dbSetOrder( nIndexSEG ) 
		dbSeek(Dtos(dDataVenc))
	Endif
	
	lAchou := .f.
	While !Eof() .And. EG_DATARES == dDataVenc
		
		IF nTipoRel == 1 .and. EG_FILIAL != cFilial
			Exit
		End
		
		If SEG->EG_TIPO != "EMP"
			dbSkip( )
			Loop
		End
		
		nDiasInt	:= EG_DATARES-EG_DATA	//Dias de Intervalo
		nJurDiario:= EG_TAXA/nDiasInt	  //Juros Diario
		nValJuros := EG_VALOR+((EG_VALOR*nJurDiario)/100)*nDiasInt
		nValGanho := nValJuros-EG_VALOR
		nValJuros -= nValGanho*EG_IMPOSTO/100 //Impostos
		IF nMoeda == 1
			nDispon -= nValJuros
		Else
			dbSelectArea("SM2")
			dbSeek( dDataVenc )
			nDispon -= nValJuros/&('SM2->M2_MOEDA'+cSuf)
		EndIF
		dbSelectArea("SEG")
		li++
		IF !lAchou
			@li, 0 PSAY EG_DATARES
		EndIF
		
		fGravSZY("SAIDA", "APL",dDataBase,"APL" ,"" ,"" ,dDataBase,"" ,"" ,"Aplicacao "+SEG->EG_TIPO+"-"+SEG->EG_BANCO,"APLICACAO" , IIF(nMoeda==1,EG_VALOR,EG_VALOR/&('SM2->M2_MOEDA'+cSuf)), "AP","Aplicacao "+SEG->EG_TIPO+"-"+SEG->EG_BANCO,Replicate("9",10) ,"","")
		
		@li,011 PSAY OemToAnsi(STR0022)   + SEG->EG_TIPO + " - " + SEG->EG_BANCO  //"Projecao de Pagamento de Emprestimo "
		@li,123 PSAY IIF(nMoeda==1,EG_VALOR,EG_VALOR/&('SM2->M2_MOEDA'+cSuf)) Picture tm(IIF(nMoeda==1,EG_VALOR,EG_VALOR/&('SM2->M2_MOEDA'+cSuf)),16,nDecs)
		@li,141 PSAY IIF(nMoeda==1,nValJuros,nValJuros/&('SM2->M2_MOEDA'+cSuf))	  Picture tm(IIF(nMoeda==1,nValJuros,nValJuros/&('SM2->M2_MOEDA'+cSuf)),16,nDecs)
		@li,179 PSAY nDispon		Picture tm(nDispon, 16,nDecs)
		
		IF nMoeda!=1 .and. !lAchou
			dbSelectArea("SM2")
			dbSeek(dDataVenc)
			@li,199 PSAY &('SM2->M2_MOEDA'+cSuf) Picture tm(&('SM2->M2_MOEDA'+cSuf),10)
		EndIF
		
		lAchou:=.T.
		dbSelectArea("SEG")
		nTotTitP	+= IIF(nMoeda==1,nValJuros,nValJuros/ &('SM2->M2_MOEDA'+cSuf))
		dbSkip()
	End
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Verifica se existe emprestimo a pagar no dia.					  ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	dbSelectArea("SEH")
	If ( nTipoRel == 1 )
		dbSetOrder(2)
		dbSeek(xFilial("SEH")+"A")
	Else
		dbSetOrder( nIndexSEH ) 
		dbSeek("A")
	Endif

	lAchou := .f.
	While ( !Eof() .And. If(nTipoRel==1,SEH->EH_FILIAL==xFilial("SEH"),.T.) .And.;
				SEH->EH_STATUS=="A" )
		If ( SEH->EH_APLEMP == "EMP" )
			If ( Empty(SEH->EH_DATARES) .And. nXj==1 ) .Or.;
				( SEH->EH_DATARES == dDataVenc )
				nValJuros := xMoeda(SEH->EH_SALDO,SEH->EH_MOEDA,1)
				aValAplic := Fa171Calc(dDataVenc,,,,,,,, nTipoRel = 1)
				If Len(aValAplic) > 0	
					nValJuros += aValAplic[2,2]
				Endif	
			Else
				nValJuros := 0
			EndIf
			If ( nValJuros != 0 )
				If ( nMoeda == 1 )
					nDispon -= (nValJuros)
				Else
					dbSelectArea("SM2")
					dbSetOrder(1)
					dbSeek( dDataVenc )
					nDispon -= (nValJuros)
				EndIf
				li++
				IF !lAchou
					@li, 0 PSAY SEH->EH_DATARES
				EndIf
		        
		        fGravSZY("SAIDA", SEH->EH_TIPO,dDataBase,"APL" ,"" ,"" ,dDataBase,"" ,"" ,"Aplicacao "+SEH->EH_TIPO+"-"+SEH->EH_BANCO,"APLICACAO" , If(nMoeda==1,SEH->EH_SALDO,SEH->EH_SALDO/&('SM2->M2_MOEDA'+cSuf)), "AP","Aplicacao "+SEH->EH_TIPO+"-"+SEH->EH_BANCO,SEH->EH_NATUREZ,"","")
				
				@li,011 PSAY OemToAnsi(STR0022)+SEH->EH_TIPO+" - "+SEH->EH_BANCO  //"Projecao de Pagamento de Emprestimo "
				@li,123 PSAY If(nMoeda==1,SEH->EH_SALDO,SEH->EH_SALDO/&('SM2->M2_MOEDA'+cSuf)) PICTURE TM(If(nMoeda==1,SEH->EH_SALDO,SEH->EH_SALDO/&('SM2->M2_MOEDA'+cSuf)),16,nDecs)
				@li,141 PSAY If(nMoeda==1,nValJuros,nValJuros/&('SM2->M2_MOEDA'+cSuf)) PICTURE TM(If(nMoeda==1,nValJuros,nValJuros/&('SM2->M2_MOEDA'+cSuf)),16,nDecs)
				@li,179 PSAY nDispon		PICTURE TM(nDispon,16,nDecs)
				If ( nMoeda!=1 .And. !lAchou )
					dbSelectArea("SM2")
					dbSetOrder(1)
					dbSeek(dDataVenc)
					@li,199 PSAY &('SM2->M2_MOEDA'+cSuf) PICTURE TM(&('SM2->M2_MOEDA'+cSuf),10)
				EndIf
				
			EndIf

			lAchou:=.T.
			nTotTitP	+= If(nMoeda==1,nValJuros,nValJuros/&('SM2->M2_MOEDA'+cSuf))
		EndIf
		dbSelectArea("SEH")
		dbSkip()
	EndDo
   Endif
	nEL:=0
	IF Len(aVendas)>0
		nEl:=Ascan(adVendas,dDataVenc)
	EndIF
	lAchou := .f.
	IF nEl != 0
		li++
		IF !lAchou
			@li, 0 PSAY dDataVenc
		EndIF
		@li,11 PSAY OemToAnsi(STR0023)  //"Pedidos de Vendas"
		nValor:=aVendas[nEl][2]
		@li,160 PSAY nValor	  Picture tm(nValor,16,nDecs)
		nDispon += nValor
		@li,179 PSAY nDispon		Picture tm(nDispon, 16,nDecs)
		IF nMoeda != 1 .and. !lAchou
			dbSelectArea("SM2")
			Seek dDataVenc
			@li,199 PSAY &('SM2->M2_MOEDA'+cSuf) Picture tm(&('SM2->M2_MOEDA'+cSuf),10)
		EndIF
		lAchou := .T.
		nTotTitR += nValor
	EndIF
	
	nEl:=0
	
	IF Len(aCompras)>0
		nEl := Ascan(adCompras,dDataVenc)
	EndIF
	
	lAchou := .f.
	IF nEl != 0
		li ++
		IF !lAchou
			@li, 0 PSAY dDataVenc
		EndIF
		@li,11 PSAY OemToAnsi(STR0024)  //"Pedidos de Compras"
		nValor := aCompras[nEl][2]
		@li,141 PSAY nValor	  Picture tm(nValor,16,nDecs)
		nDispon -= nValor
		@li,179 PSAY nDispon		Picture tm(nDispon, 16,nDecs)
		IF nMoeda != 1 .and. ! lAchou
			dbSelectArea("SM2")
			Seek dDataVenc
			@li,199 PSAY &('SM2->M2_MOEDA'+cSuf) Picture tm(&('SM2->M2_MOEDA'+cSuf),10)
		EndIF
		nTotTitP += nValor
		lAchou := .T.
	EndIF
	
	If nTotTitR !=0 .or. nTotTitP != 0
		Li+=2
		IF li > 58
			cabec(titulo,cabec1,cabec2,nomeprog,tamanho,NumImp())
		End
		@Li,000 PSAY OemToAnsi(STR0025) +DTOC(dDataVenc)  //"Total Do Dia ---> "
		@Li,141 PSAY nTotTitP 					  Picture Tm(nTotTitP,16,nDecs)
		@Li,160 PSAY ntotTitR 					  Picture Tm(nTotTitR,16,nDecs)
		@li,179 PSAY nDispon				      Picture tm(nDispon ,16,nDecs)
		Li++
	Endif
	
	nTotGTitR += nTotTitR
	nTotGTitP += nTotTitP
	nTotTitP := 0
	nTotTitR := 0
	
Next nXj

//Pedidos de Vendas
If Len(aVendAux) > 0
   For nXi := 1 To Len(aVendAux)
      dbSelectArea("SA1")
      dbSetOrder(1)
      dbSeek(xFilial("SA1")+aVendAux[nXi,3]+aVendAux[nXi,4])
			
	  //Posiciona na Natureza
	  dbSelectArea("SED")
      dbSetOrder(1) //Filial+Codigo
	  dbSeek(xFilial("SED")+SA1->A1_NATUREZ)

      //Posiciona Tabela de Classificacao
	  dbSelectArea("SX5")
	  dbSetOrder(1) //Filial+Tabela+Chave
	  dbSeek(xFilial("SX5")+"99"+SA1->A1_CLASFIN)
	  
	  //Posiciona no Produto
	  dbSelectArea("SB1")
	  dbSetOrder(1)
	  dbSeek(xFilial("SB1")+aVendAux[nXi,7])
			
	  //Posiciona na Conta Contabil
	  dbSelectArea("CT1")
	  dbSetOrder(1) //Filial+Conta
	  dbSeek(xFilial("CT1")+Left(SB1->B1_CONTA,nDigCTA))

      fGravSZY("ENTRADA", "VEN", aVendAux[nXi,2], "FAT", aVendAux[nXi,1],"", aVendAux[nXi,2], aVendAux[nXi,3], aVendAux[nXi,4], SA1->A1_NOME,  Iif(nTipClas==1,SX5->X5_DESCRI,CT1->CT1_DESC01), aVendAux[nXi,5], "PV","PEDIDO DE VENDAS", SA1->A1_NATUREZ, aVendAux[nXi,6],Iif(nTipClas==1,SX5->X5_CHAVE,CT1->CT1_CONTA))
   Next nXi
EndIf


//Pedidos de Compras
If Len(aCompAux) > 0
   For nXi := 1 To Len(aCompAux)
      dbSelectArea("SA2")
      dbSetOrder(1)
      dbSeek(xFilial("SA2")+aCompAux[nXi,3]+aCompAux[nXi,4])
			
	  //Posiciona na Natureza
	  dbSelectArea("SED")
      dbSetOrder(1) //Filial+Codigo
	  dbSeek(xFilial("SED")+SA2->A2_NATUREZ)

      //Posiciona Tabela de Classificacao
	  dbSelectArea("SX5")
	  dbSetOrder(1) //Filial+Tabela+Chave
	  dbSeek(xFilial("SX5")+"99"+SA2->A2_CLASFIN)
	  
	  //Posiciona no Produto
	  dbSelectArea("SB1")
	  dbSetOrder(1)
	  dbSeek(xFilial("SB1")+aCompAux[nXi,7])
			
	  //Posiciona na Conta Contabil
	  dbSelectArea("CT1")
	  dbSetOrder(1) //Filial+Conta
	  dbSeek(xFilial("CT1")+Left(SB1->B1_CONTA,nDigCTA))

      fGravSZY("SAIDA", "COM", aCompAux[nXi,2], "COM", aCompAux[nXi,1],"", aCompAux[nXi,2], aCompAux[nXi,3], aCompAux[nXi,4], SA2->A2_NOME,  Iif(nTipClas==1,SX5->X5_DESCRI,CT1->CT1_DESC01), aCompAux[nXi,5], "PC","PEDIDO DE COMPRAS", SA2->A2_NATUREZ, aCompAux[nXi,6],Iif(nTipClas==1,SX5->X5_CHAVE,CT1->CT1_CONTA))
   Next nXi
EndIf

IF li != 80
	Li++
	@Li,000 PSAY OemToAnsi(STR0026)  //"Total Geral  --->"
	@Li,141 PSAY nTotGTitP 					  Picture Tm(nTotGTitP,16,nDecs)
	@Li,160 PSAY ntotGTitR 					  Picture Tm(nTotGTitR,16,nDecs)
	@li,179 PSAY nDispon				      Picture tm(nDispon ,16,nDecs)
	Li++
	roda(cbcont,cbtxt,"G")
EndIF
// Contas a receber
RetIndex("SE1")
dbSelectArea("SE1")
SE1->(dbSetOrder(1))
SE1->(dbClearFilter())

// Contas a pagar
RetIndex("SE2")
dbSelectArea("SE2")
SE2->(dbSetOrder(1))
SE2->(dbClearFilter())

// Comissao de vendas
RetIndex("SE3")
dbSelectArea("SE3")
SE3->(dbSetOrder(1))
SE3->(dbClearFilter())

// Movimentacao bancaria
RetIndex("SE5")
dbSelectArea("SE5")
SE5->(dbSetOrder(1))
SE5->(dbClearFilter())

// Contas Corrente
RetIndex("SA6")
dbSelectArea("SA6")
SA6->(dbSetOrder(1))
SA6->(dbClearFilter())

// Saldos bancarios
RetIndex("SE8")
dbSelectArea("SE8")
SE8->(dbSetOrder(1))
SE8->(dbClearFilter())

// Controle de aplicacoes
RetIndex("SEG")
dbSelectArea("SEG")
SEG->(dbSetOrder(1))
SEG->(dbClearFilter())

RetIndex("SEH")
dbSelectArea("SEH")
SEH->(dbSetOrder(1))
SEH->(dbClearFilter())

Ferase(cArqSEH+OrdBagExt())
Ferase(cArqSEG+OrdBagExt())
Ferase(cArqSE5+OrdBagExt())
Ferase(cArqSE2+OrdBagExt())
Ferase(cArqSE1+OrdBagExt())
Ferase(cArqSE3+OrdBagExt())
Ferase(cArqSE8+OrdBagExt())
Ferase(cArqSA6+OrdBagExt())
/*
Set Device To Screen

If aReturn[5] = 1
	Set Printer To
	dbCommitAll()
	ourspool(wnrel)
Endif

MS_FLUSH()
*/
//Pergunte("FLXCXA",.T.)

cParams := &('"'+AllTrim(Str(nNumDias))+';'+AllTrim(Str(nTipoRel))+';'+AllTrim(Str(nConPVen))+';'+AllTrim(Str(nConPCom))+';'+AllTrim(cPrefIni)+';'+Alltrim(cPrefFin)+';'+Alltrim(cSomPref)+';'+Alltrim(cExcPref)+';'+AllTrim(cTipoIni)+';'+Alltrim(cTipoFin)+';'+Alltrim(cSomTipo)+';'+Alltrim(cExcTipo)+;
';'+AllTrim(cNatuIni)+';'+Alltrim(cNatuFin)+';'+Alltrim(cSomNatu)+';'+Alltrim(cExcNatu)+';'+AllTrim(Str(nConAtra))+';'+AllTrim(Str(nNumAtra))+';'+AllTrim(Str(nNivDeta))+';'+AllTrim(Str(nTipClas))+';'+AllTrim(Str(nDigCta))+';'+AllTrim(cSomClFn)+';'+AllTrim(cExcClFn)+'"') //Parametros para o Relatorio

cOpcoes := "1;0;1;Fluxo Caixa Classificado" //Opcoes: 1-Video(1)ou Impressora(2) 2-Atualiza(0)ou Nao(1) 3-Copias e 4-Título

If nNivDeta == 1 //Vencimento
   CallCrys("FLXCXA",cParams,cOpcoes)
ElseIf  nNivDeta == 2 //Classificacao
   CallCrys("FLXCXA2",cParams,cOpcoes)
ElseIf nNivDeta == 3 //Cliente,Fornecedor
   CallCrys("FLXCXA3",cParams,cOpcoes)
ElseIf nNivDeta == 4 //Analitico
   CallCrys("FLXCXA4",cParams,cOpcoes)
EndIf

Return(Nil)


Static Function fGravSZY(cCondicao, cTipo, dDataVen, cPrefixo, cNumero, cParcela, dEmissao, cCliente, cLoja, cNome, cClassif, nVlrFlux, cOrigem,cHist, cNatureza, cCondPag,cCodClas)
************************************************************************************************************************************************************************************
*
***
Local aDupli   := {}
Local aParcela := {"A","B","C","D","E","F","G","H","I","J","K","L","M","N","O","P","Q","R","S","T","U","V","W","X","Y","Z"}
/*
If cOrigem $ "PC_PV"
   aDupli := Condicao(nVlrFlux,cCondPag,0,dEmissao,0)
   For nXl := 1 To Len(aDupli)
      If aDupli[nXl,1] >= dDataAtr .And. aDupli[nXl,1] <= dDataFin .And. aDupli[nXl,2] <> 0
         If RecLock("SZY",.T.)
            Replace ZY_FILIAL  With xFilial("SZY")
            Replace ZY_CONDICA With cCondicao
            Replace ZY_ORIGEM  With cOrigem
            Replace ZY_TIPO    With cTipo
            Replace ZY_DATAVEN With aDupli[nXl,1]
            Replace ZY_PREFIXO With cPrefixo
            Replace ZY_NUMERO  With cNumero
            Replace ZY_PARCELA With aParcela[nXl]
            Replace ZY_EMISSAO With dEmissao
            Replace ZY_CLIENTE With cCliente
            Replace ZY_LOJA    With cLoja
            Replace ZY_NOME    With cNome
            Replace ZY_CLASSIF With cClassif
            Replace ZY_VALOR   With aDupli[nXl,2] //aDupli[nXl,2]*IIf(Substr(cTipo,3,1)=='-',-1,1)
            Replace ZY_HIST    With cHist
            Replace ZY_NATUREZ With cNatureza
            MsUnLock()
         EndIf
      EndIf   
   Next nXl
Else
*/   If dDataVen >= dDataAtr .And. dDataVen <= dDataFin .And. nVlrFlux <> 0
      If RecLock("SZY",.T.)
         Replace ZY_FILIAL  With xFilial("SZY")
         Replace ZY_CONDICA With cCondicao
         Replace ZY_ORIGEM  With cOrigem
         Replace ZY_TIPO    With cTipo
         Replace ZY_DATAVEN With dDataVen
         Replace ZY_PREFIXO With cPrefixo
         Replace ZY_NUMERO  With cNumero
         Replace ZY_PARCELA With cParcela
         Replace ZY_EMISSAO With dEmissao
         Replace ZY_CLIENTE With cCliente
         Replace ZY_LOJA    With cLoja
         Replace ZY_NOME    With cNome
         Replace ZY_CLASSIF With cClassif
         Replace ZY_VALOR   With nVlrFlux //nVlrFlux*IIf(Substr(cTipo,3,1)=='-',-1,1)
         Replace ZY_HIST    With cHist
         Replace ZY_NATUREZ With cNatureza
         //Replace ZY_CODCLAS With cCodClas
         MsUnLock()
      EndIf   
   EndIf   
//EndIf

Return(Nil)


/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o	 ³Fc020Venda³ Autor ³ Wagner Xavier 		  ³ Data ³ 06/07/92 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³Monta array com Pedidos de Venda									  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe	 ³Fc020Venda() 															  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso		 ³ Gen‚rico 																  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function f020Ven( cMoedas, cAliasPv, aTotais, lRegua, nMoeda, aPeriodo, cFilIni, cFilFin )
//Adpatado do fonte FC020Vend() - FINXFUN

LOCAL cNumPed,cCond,nValTot:=0,nValIpi:=0,aVenc:={},i,nPrcVen
LOCAL dData
Local lFc020Vda := ExistBlock("FC020VDA")
LOCAL cFilDe
LOCAL cFilAte
LOCAL cSaveFil := cFilAnt
LOCAL aSaveArea:= SM0->(GetArea())
Local nAscan, dDataFluxo
Local aDesp := {}
Local	lPedido := .T.
Local	lFirst  := .T.
Local nDespFrete := 0
Local lMoedaFre := (SuperGetMv("MV_FRETMOE") == "S")
Local nDecimais := TamSx3("C6_PRCVEN")[2]
Local lAIDInDic := AliasInDic("AID")
Local cAliasSc6 := "SC6"

#IFDEF TOP
	Local aStru := SC6->(dbStruct())
	Local nI := 0
	Local cQuery
#ENDIF

//DEFAULT nMoeda := 1
//DEFAULT cFilIni := "  "
//DEFAULT cFilFin := "zz"
nMoeda := 1
cFilIni := "  "
cFilFin := "zz"

cMoedas := Iif( cMoedas == Nil, "012345", cMoedas )

If nTipoRel == 2		// por empresa
	cFilDe := cFilIni
	cFilAte := cFilFin
Else						// por filial
	cFilDe := cFilAnt
	cFilAte := cFilAnt
Endif

dbSelectArea("SM0")
dbSeek(cEmpAnt + cFilDe , .T. )
While !Eof() .and. M0_CODIGO == cEmpAnt .and. M0_CODFIL <= cFilAte

	cFilAnt := SM0->M0_CODFIL

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Ler Pedidos de Venda 													  ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	dbSelectArea("SC6")
	dbSetOrder(1)
	dbSeek(xFilial())
	#IFDEF TOP
		If TcSrvType() != "AS/400" 
			cAliasSc6 := GetNextAlias()
			If lAIDInDic
				cQuery := "SELECT DISTINCT C6_FILIAL, C6_NUM "
				cQuery += "  FROM "+	RetSqlName("SC6") + " SC6, "
				cQuery +=           	RetSqlName("SC5") + " SC5 "
			Else	
				cQuery := "SELECT * "
				cQuery += "  FROM "+	RetSqlName("SC6") + " SC6 "
			Endif	
			cQuery += " WHERE SC6.C6_FILIAL = '" + xFilial("SC6") + "'"
			cQuery += " AND SC6.C6_BLQ <> 'R'"
			cQuery += " AND SC6.C6_BLQ <> 'S'"
			cQuery += " AND SC6.C6_QTDENT < SC6.C6_QTDVEN"
			If lAIDInDic
				cQuery += " AND SC5.C5_FILIAL = '" + xFilial("SC5") + "'"
				cQuery += " AND SC6.C6_NUM = SC5.C5_NUM "
				cQuery += " AND SC5.D_E_L_E_T_ = ' ' "
				cQuery += " AND SC6.D_E_L_E_T_ = ' ' "
			Else
				cQuery += " AND SC6.D_E_L_E_T_ = ' ' "
				cQuery += " ORDER BY "+ SqlOrder(IndexKey())
			Endif	
			
			cQuery := ChangeQuery(cQuery)
			dbUseArea(.T., "TOPCONN", TCGenQry(,,cQuery), cAliasSc6, .F., .T.)
			
			For nI := 1 to Len(aStru)
				If aStru[nI,2] != 'C'  .And. FieldPos(aStru[nI,1]) > 0
					TCSetField(cAliasSc6, aStru[nI,1], aStru[nI,2],aStru[nI,3],aStru[nI,4])
				Endif
			Next nI
		endif
	#ENDIF

	While (cAliasSc6)->(!Eof()) .AND. (cAliasSc6)->C6_FILIAL == xFilial("SC6")

		cNumPed := (cAliasSc6)->C6_NUM
		nValTot := 0
		nValIpi := 0
		aVenc := {}
		aDesp := {}
		lPedido := .T. 
		lFirst:= .T.	
		While (cAliasSc6)->(!Eof()) .and. (cAliasSc6)->C6_NUM == cNumPed .and. xFilial("SC6") == (cAliasSc6)->C6_FILIAL
			If lRegua != Nil .And. lRegua
				IncProc("Processando Pedidos de vendas")
			Endif	
			If ! lAIDInDic
				IF Substr((cAliasSc6)->C6_BLQ,1,1) $"RS"
					(cAliasSc6)->(dbSkip())
					Loop
				Endif
	
				IF (cAliasSc6)->C6_QTDENT >= (cAliasSc6)->C6_QTDVEN
					(cAliasSc6)->(dbSkip())
					Loop
				Endif
	
				dbSelectArea("SF4")
				SF4->(dbSeek(xFilial("SF4")+(cAliasSc6)->C6_TES))
			
				dbSelectArea(cAliasSc6)
				If SF4->(Eof()) .Or.;
					SF4->F4_DUPLIC == "N"
					(cAliasSc6)->(dbSkip())
					Loop
				Endif
			Endif	
			dbSelectArea("SC5")
			SC5->(MsSeek( xFilial("SC5")+cNumPed ))
			If (STR(SC5->C5_MOEDA,1) $ cMoedas)
				cCond := SC5->C5_CONDPAG
				If ! lAIDInDic
					dbSelectArea(cAliasSc6)
					//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
					//³Calcula o reajuste do pedido de venda								  ³
					//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
					nPrcVen := (cAliasSc6)->C6_PRCVEN
					dData   := Iif( (cAliasSc6)->C6_ENTREG < dDataBase, dDataBase, (DataValida((cAliasSc6)->C6_ENTREG)))
					IF Type(SC5->C5_REAJUST) = "U"
						nPrcVen := xMoeda(nPrcVen,SC5->C5_MOEDA,nMoeda,dData,nDecimais)
					Else
						IF !Empty(SC5->C5_REAJUST)
							nPrcVen := fc020Form(SC5->C5_REAJUST,dData)
						Endif
						nPrcVen := xMoeda(nPrcVen,SC5->C5_MOEDA,nMoeda,dData,nDecimais)
					Endif
					nValTot	:= ((cAliasSc6)->(C6_QTDVEN-C6_QTDENT)) * nPrcVen
					cProd 	:= (cAliasSc6)->C6_PRODUTO
					dbSelectArea("SB1")
					dbSeek(xFilial("SB1")+cProd)
					dbSelectArea(cAliasSc6)
					nValIPI	:= 0
					IF SF4->F4_IPI == "S" .And. SB1->B1_IPI > 0
						nBaseIPI :=((cAliasSc6)->(C6_QTDVEN-SC6->C6_QTDENT))*nPrcVen
						If SF4->F4_BASEIPI > 0
							nBaseIPI*=(SF4->F4_BASEIPI/100)
						Endif
						nValIpi  :=IIf(nBaseIPI=0,0,(nBaseIPI*SB1->B1_IPI)/100)
					Endif
					nValTot += nValIPI
					nValTot *= (SC5->C5_ACRSFIN/100)+1
					dbSelectArea(cAliasSc6)
	
					If lFc020Vda		// Retornar a condicao do Item e do Total
						aVenc := ExecBlock("FC020VDA",.F.,.F.,{(cAliasSc6)->C6_NUM,(cAliasSc6)->C6_ITEM,nValTot,cCond,nValIpi,dData})
					Else
						aVenc := Condicao(nValTot,cCond,nValIpi,dData)
					Endif
				Else
					aVenc := Ma410Fluxo(cNumPed,.F.)	
				Endif	
			    //aadd(aVendAux,{SC6->C6_NUM, SC6->C6_ENTREG, SC6->C6_CLI, SC6->C6_LOJA, nValTot, cCond, SC6->C6_PRODUTO})
				If Len(aVenc)>0 
					If lPedido
						//Despesas, Seguro e Frete
						nDespFrete := xMoeda(SC5->C5_FRETE+SC5->C5_SEGURO+SC5->C5_DESPESA,If(lMoedaFre,SC5->C5_MOEDA,1),nMoeda,dData,nDecimais)
						aDesp := Condicao(nDespFrete,cCond,,dData)
						lPedido := .F.					
						If Len(aDesp) > 0
							For i := 1 To Len(aDesp)
								IF Len(aVendas)=0
									nL := 0
								Else
									nL := Ascan(adVendas,DataValida(aDesp[i][1]))
								Endif
								IF nL != 0
									aVendas[nL][2]+=aDesp[i][2]
									aadd(aVendAux,{SC6->C6_NUM, DataValida(aDesp[i][1]), SC6->C6_CLI, SC6->C6_LOJA, aDesp[i][2], cCond, SC6->C6_PRODUTO})
								Else
									AADD(aVendas,{DataValida(aDesp[i][1]),aDesp[i][2]})
									AADD(aDVendas,DataValida(aDesp[i][1]))
									aadd(aVendAux,{SC6->C6_NUM, DataValida(aDesp[i][1]), SC6->C6_CLI, SC6->C6_LOJA, aDesp[i][2], cCond, SC6->C6_PRODUTO})
								Endif
							Next i
						Endif
					Endif
					// Parcelas do Pedido
					For i := 1 To Len(aVenc)
						IF Len(aVendas)=0
							nL := 0
						Else
							nL := Ascan(adVendas,DataValida(aVenc[i][1]))
						Endif
						IF nL != 0
							aVendas[nL][2]+=aVenc[i][2]
							aadd(aVendAux,{SC6->C6_NUM, DataValida(aVenc[i][1]), SC6->C6_CLI, SC6->C6_LOJA, aVenc[i][2], cCond, SC6->C6_PRODUTO})
						Else
							AADD(aVendas,{DataValida(aVenc[i][1]),aVenc[i][2]})
							AADD(aDVendas,DataValida(aVenc[i][1]))
							aadd(aVendAux,{SC6->C6_NUM, DataValida(aVenc[i][1]), SC6->C6_CLI, SC6->C6_LOJA, aVenc[i][2], cCond, SC6->C6_PRODUTO})
						Endif

						// Se foi enviado o arquivo temporario para geracao do fluxo
						// de caixa analitico, gera o pedido de venda neste arquivo
						If cAliasPv != Nil
							DbSelectArea(cAliasPv)
							dDataFluxo := DataValida(aVenc[i][1])
							nAscan := Ascan(aPeriodo, {|e| e[1] == dDataFluxo})
							// Se a data do pedido ja venceu, insere na primeira data do fluxo
							If dDataFluxo < aPeriodo[1][1]
								dDataFluxo := aPeriodo[1][1]
								nAscan := 1
							Endif	
							If nAscan > 0
								If !dbSeek(dTos(dDataFluxo)+SC5->C5_NUM)
									RecLock(cAliasPv,.T.)
									(cAliasPv)->DATAX  := dDataFluxo
									(cAliasPv)->Periodo:= aPeriodo[nAscan][2]
									(cAliasPv)->NUMERO := SC5->C5_NUM
									(cAliasPv)->EMISSAO:= SC5->C5_EMISSAO
									(cAliasPv)->CLIFOR := SC5->C5_CLIENTE
									(cAliasPv)->LOJAENT:= SC5->C5_LOJAENT
									(cAliasPv)->LOJACLI:= SC5->C5_LOJACLI
									(cAliasPv)->TIPO   := SC5->C5_TIPO
									// Posiciona no cliente para buscar o nome        
									If SC5->C5_TIPO=="D"
										DbSelectArea("SA2")
										DbSetOrder(1)
										MsSeek(xFilial("SA2")+SC5->C5_CLIENTE+SC5->C5_LOJACLI)
										DbSelectArea(cAliasPv)
										(cAliasPv)->NOMCLIFOR:= SA2->A2_NOME
										(cAliasPv)->CHAVE  := xFilial("SC5")+SC5->C5_NUM									
									Else
										DbSelectArea("SA1")
										DbSetOrder(1)
										MsSeek(xFilial("SA1")+SC5->C5_CLIENTE+SC5->C5_LOJACLI)
										DbSelectArea(cAliasPv)
										(cAliasPv)->NOMCLIFOR:= SA1->A1_NOME
										(cAliasPv)->CHAVE  := xFilial("SC5")+SC5->C5_NUM
									Endif
								Else
									RecLock(cAliasPv,.F.)
								Endif	

								//Somo a despesa/Frete/Seguro relativa a parcela apenas uma vez
								//Se refere ao valor da parcela e nao do item
								IF Len(aDesp) > 0 .and. lFirst
									nValDfs := aDesp[i][2]
									lFirst := .F.
								Else
									nValDfs := 0
								Endif

         					(cAliasPv)->SALDO  += aVenc[i][2]+ nValDfs

								// Pesquisa na matriz de totais, os totais de pedidos de compra
								// da data de trabalho.
								nAscan := Ascan( aTotais[4], {|e| e[1] == (cAliasPv)->DATAX})
								If nAscan == 0
									Aadd( aTotais[4], {(cAliasPv)->DATAX,aVenc[i][2]+ nValDfs})
								Else	
									aTotais[4][nAscan][2] += aVenc[i][2]+ nValDfs // Totaliza os pedidos de venda
								Endif	
							Endif	
						Endif	
					Next i
				Endif
			Endif
			dbSelectArea(cAliasSc6)
			If lAIDInDic
				// Se o AID estiver no dicionario, vai para o proximo pedido, pois a Ma410Fluxo ja processou todos
				// o itens, e se nao for para proximo pedido, os dados ficarao duplicados.
				While (cAliasSc6)->(!Eof()) .and. (cAliasSc6)->C6_NUM == cNumPed .and. xFilial("SC6") == (cAliasSc6)->C6_FILIAL
					dbSkip()
				End
			Else
				dbSkip()
			Endif	
		Enddo
	Enddo
	#IFDEF TOP
		If TcSrvType() != "AS/400" 
			dbSelectArea(cAliasSc6)
			dbCloseArea()
			dbSelectArea("SC6")
			dbSetOrder(1)
		endif
	#ENDIF
	If Empty(xFilial("SC6"))
		Exit
	Endif
	dbSelectArea("SM0")
	dbSkip()
Enddo
cFilAnt := cSaveFil
SM0->(RestArea(aSaveArea))
Return .T.

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o	 ³Fc020Compr³ Autor ³ Wagner Xavier 		  ³ Data ³ 06/07/92 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³Monta array com Pedidos de Compras								  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe	 ³Fc020Compr() 															  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso		 ³ Gen‚rico 																  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
STATIC Function f020Com(cAliasPc,aTotais,lRegua,nMoeda,aPeriodo,cFilIni,cFilFin, cPedidos)
//Adaptado do fonte original FC020Compr() - FINXFUN
LOCAL cNumPed,cCond,nValTot:=0,nValIpi:=0,aVenc:={},i,nPrcCompra
LOCAL dData,nValIPILiq
LOCAL nTotDesc
LOCAL cFilDe
LOCAL cFilAte
LOCAL cSaveFil := cFilAnt
LOCAL aSaveArea:= SM0->(GetArea())
LOCAL nAscan, dDataFluxo
Local nDespFrete := 0
Local lFc020Com := ExistBlock("FC020COM")
Local nDecimais := TamSx3("C7_PRECO")[2]

#IFDEF TOP
	Local nI := 0
	Local cQuery
	Local aStru := SC7->(dbStruct()) 
#ENDIF

//DEFAULT nMoeda := 1
//DEFAULT cFilIni := "  "
//DEFAULT cFilFin := "zz"
//Default cPedidos := "3" // Todos os pedidos
nMoeda := 1
cFilIni := "  "
cFilFin := "zz"
cPedidos := "3" // Todos os pedidos

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Funcao utilizada para verificar a ultima versao dos fontes      ³
//³ SIGACUS.PRW, SIGACUSA.PRX e SIGACUSB.PRX, aplicados no rpo do   |
//| cliente, assim verificando a necessidade de uma atualizacao     |
//| nestes fontes. NAO REMOVER !!!							        ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
IF !(FindFunction("SIGACUS_V") .and. SIGACUS_V() >= 20050512)
    Final("Atualizar SIGACUS.PRW !!!")
Endif
IF !(FindFunction("SIGACUSA_V") .and. SIGACUSA_V() >= 20050512)
    Final("Atualizar SIGACUSA.PRX !!!")
Endif
IF !(FindFunction("SIGACUSB_V") .and. SIGACUSB_V() >= 20050512)
    Final("Atualizar SIGACUSB.PRX !!!")
Endif

If nTipoRel == 2		// por empresa
	cFilDe := cFilIni
	cFilAte := cFilFin
Else						// por filial
	cFilDe := cFilAnt
	cFilAte := cFilAnt
Endif

dbSelectArea("SM0")
dbSeek(cEmpAnt + cFilDe , .T. )
While !Eof() .and. M0_CODIGO == cEmpAnt .and. M0_CODFIL <= cFilAte

	cFilAnt := SM0->M0_CODFIL
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Ler Pedidos de Compra													  ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	dbSelectArea("SC7")
	SC7->(dbSetOrder(1))
	dbSeek(xFilial())
	#IFDEF TOP
		If TcSrvType() != "AS/400"
			cQuery := "SELECT * "
			cQuery += "  FROM "+	RetSqlName("SC7")
			cQuery += " WHERE C7_FILIAL = '" + xFilial("SC7") + "'"
			cQuery += "   AND D_E_L_E_T_ = ' ' "
			cQuery += " AND C7_QUJE < C7_QUANT"
			cQuery += " AND C7_RESIDUO <> 'S'"
			cQuery += " AND C7_FLUXO   <> 'N'"
			cQuery += " ORDER BY "+ SqlOrder(IndexKey())
			
			cQuery := ChangeQuery(cQuery)
			dbSelectArea("SC7")
			dbCloseArea()
			dbUseArea(.T., "TOPCONN", TCGenQry(,,cQuery), 'SC7', .F., .T.)
			
			For nI := 1 to Len(aStru)
				If aStru[nI,2] != 'C'
					TCSetField('SC7', aStru[nI,1], aStru[nI,2],aStru[nI,3],aStru[nI,4])
				Endif
			Next nI
		endif
	#ENDIF
	
	While SC7->(!Eof()) .and. SC7->C7_FILIAL == xFilial("SC7")

		cNumPed := SC7->C7_NUM
		nValTot := 0
		nValIpi := 0
		aVenc	:= {}
		cCond	:= SC7->C7_COND
		nTotDesc:= SC7->C7_VLDESC
		nDespFrete := 0

		While SC7->(!Eof()) .And. SC7->C7_NUM==cNumPed .and. xFilial("SC7") == SC7->C7_FILIAL
			If lRegua != Nil .and. lRegua
				IncProc("Processando Pedidos de compras")
			Endif	
			IF SC7->C7_QUJE >= SC7->C7_QUANT .or. SC7->C7_RESIDUO == "S" .or. SC7->C7_FLUXO == "N"
				SC7->(dbSkip())
				Loop
			Endif
			If (SC7->C7_CONAPRO == "B" .And. Left(cPedidos,1) == "1") .Or.;
			   (SC7->C7_CONAPRO != "B" .And. Left(cPedidos,1) == "2")
				SC7->(dbSkip())
				Loop
			Endif

			SB1->(dbSeek( xFilial("SB1") + SC7->C7_PRODUTO)) // Posiciona Produto
			If !Empty(SC7->C7_TES)
				SF4->(dbSeek( xFilial("SF4") + SC7->C7_TES ))  // Posiciona TES
			Else
				SF4->(dbSeek( xFilial("SF4") + RetFldProd(SB1->B1_COD,"B1_TE") ))  // Posiciona TES
			Endif

			// Se nao houver TES no Pedido ou Produto serah considerado			
			// pois o tes no PC nao eh obrigatorio ou comum.
			IF SF4->F4_DUPLIC == "N" .OR. SB1->B1_IMPORT == "S"
				dbSelectArea("SC7")
				dbSkip()
				Loop
			Endif

			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³Calcula o reajuste do pedido de compra								  ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			dData		:= Iif( SC7->C7_DATPRF < dDataBase, dDataBase, DataValida(SC7->C7_DATPRF))
			nPrcCompra 	:= xMoeda(SC7->C7_PRECO,SC7->C7_MOEDA,nMoeda,dData,nDecimais)
			If Type(C7_REAJUST) != "U" .And. !Empty(SC7->C7_REAJUST)
				nPrcCompra := fc020Form(SC7->C7_REAJUST,dData)
			Endif
			nDespFrete := xMoeda(SC7->C7_VALFRE + SC7->C7_SEGURO + SC7->C7_DESPESA,SC7->C7_MOEDA,nMoeda,dData,nDecimais)
			nValTot	  := ((SC7->C7_QUANT-SC7->C7_QUJE) * nPrcCompra ) + nDespFrete
			nValIPI	  := 0
			nValIPILiq  := nValTot
			If nTotDesc == 0
				nTotDesc := CalcDesc(nValTot,SC7->C7_DESC1,SC7->C7_DESC2,SC7->C7_DESC3)
			Else
				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³Proporcionaliza o desconto de pedidos com entrega parcial	  ³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
				nTotDesc := ((SC7->C7_VLDESC * nValTot)/SC7->C7_TOTAL)
			EndIf
			nValTot	  := nValTot - nTotDesc
			IF SC7->C7_IPI > 0
				If SC7->C7_IPIBRUT != "L"
					nBaseIPI := nValTot
				Else
					nBaseIPI := nValIPILiq
				Endif
				IF SF4->F4_BASEIPI > 0
					nBaseIPI *= SF4->F4_BASEIPI / 100
				Endif
				nValIPI := IIf(nBaseIPI = 0, 0, nBaseIPI * SC7->C7_IPI / 100)
			Endif
			nValTot  += nValIPI
			dbSelectArea("SE4")
			dbSeek(xFilial("SE4")+SC7->C7_COND)
			nValTot  *= (SE4->E4_ACRSFIN/100)+1
			dbSelectArea("SC7")
			If lFc020Com		// Retornar a condicao do Item e do Total
				aVenc := ExecBlock("FC020COM",.F.,.F.,{SC7->C7_NUM,SC7->C7_ITEM,nValTot,cCond,nValIpi,dData})
			Else
				aVenc := Condicao(nValTot,cCond,nValIpi,dData)
			Endif
			//aadd(aCompAux,{SC7->C7_NUM, SC7->C7_DATPRF, SC7->C7_FORNECE, SC7->C7_LOJA, nValTot, cCond, SC7->C7_PRODUTO})
			IF Len(aVenc)>0
				For i:=1 To Len(aVenc)
					IF Len(aCompras)=0
						nL:=0
					Else
						nL:=Ascan(adCompras,DataValida(aVenc[i][1]))
					Endif
					IF nL!=0
						aCompras[nL][2]+=aVenc[i][2]
						aadd(aCompAux,{SC7->C7_NUM, DataValida(aVenc[i][1]), SC7->C7_FORNECE, SC7->C7_LOJA, aVenc[i][2], cCond, SC7->C7_PRODUTO})
					Else
						AADD(aCompras,{DataValida(aVenc[i][1]),aVenc[i][2]})
						AADD(adCompras,DataValida(aVenc[i][1]))
						aadd(aCompAux,{SC7->C7_NUM, DataValida(aVenc[i][1]), SC7->C7_FORNECE, SC7->C7_LOJA, aVenc[i][2], cCond, SC7->C7_PRODUTO})
					Endif
					// Se foi enviado o arquivo temporario para geracao do fluxo
					// de caixa analitico, gera o pedido de compra neste arquivo
					If cAliasPc != Nil
						DbSelectArea(cAliasPc)
						dDataFluxo := DataValida(aVenc[i][1])
						nAscan := Ascan(aPeriodo, {|e| e[1] == dDataFluxo})
						// Se a data do pedido ja venceu, insere na primeira data do fluxo
						If dDataFluxo < aPeriodo[1][1]
							dDataFluxo := aPeriodo[1][1]
							nAscan := 1
						Endif	
						If nAscan > 0
							If !dbSeek(dTos(dDataFluxo)+SC7->C7_NUM)
								RecLock(cAliasPc,.T.)
								(cAliasPc)->DATAX  := dDataFluxo
								(cAliasPc)->Periodo:= aPeriodo[nAscan][2]
								(cAliasPc)->NUMERO := SC7->C7_NUM
								(cAliasPc)->EMISSAO:= SC7->C7_EMISSAO
								(cAliasPc)->CLIFOR := SC7->C7_FORNECE
								(cAliasPc)->TIPO   := SC7->C7_TIPO
								(cAliasPc)->ITEM   := SC7->C7_ITEM
							
								// Posiciona no fornecedor para buscar o nome
								DbSelectArea("SA2")
								DbSetOrder(1)
								MsSeek(xFilial("SA2")+SC7->C7_FORNECE+SC7->C7_LOJA)
								DbSelectArea(cAliasPc)
								(cAliasPc)->NOMCLIFOR:= SA2->A2_NOME
								(cAliasPc)->PRODUTO:= SC7->C7_PRODUTO
								(cAliasPc)->CHAVE  := xFilial("SC7")+SC7->C7_NUM+SC7->C7_ITEM+SC7->C7_SEQUEN
                     Else
								RecLock(cAliasPc,.F.)
							Endif	
							(cAliasPc)->SALDO  += aVenc[i][2]

							// Pesquisa na matriz de totais, os totais de pedidos de compra
							// da data de trabalho.
							nAscan := Ascan( aTotais[3], {|e| e[1] == (cAliasPc)->DATAX})
							If nAscan == 0
								Aadd( aTotais[3], {(cAliasPc)->DATAX,aVenc[i][2]})
							Else	
								aTotais[3][nAscan][2] += aVenc[1][2] //(cAliasPc)->SALDO // Totaliza os pedidos de compra
							Endif
						Endif	
					Endif	
				Next i
			Endif
			dbSelectArea("SC7")
			dbSkip()
		Enddo
	Enddo
	#IFDEF TOP
		If TcSrvType() != "AS/400"
			dbSelectArea("SC7")
			dbCloseArea()
			ChKFile("SC7")
			dbSelectArea("SC7")
			dbSetOrder(1)
		endif
	#ENDIF
	If Empty(xFilial("SC7"))
		Exit
	Endif
	dbSelectArea("SM0")
	dbSkip()
Enddo
cFilAnt := cSaveFil
SM0->(RestArea(aSaveArea))
Return .T.