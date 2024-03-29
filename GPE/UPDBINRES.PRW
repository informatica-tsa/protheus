#INCLUDE "PROTHEUS.CH"

User Function UPDBINRES()

Local aButtons  := {}
Local aSays     := {}
Local cMsg      := ""
Local lContinua := .F.
Local nOpcA     := 0
Local aErros	:= {}
Local cMsgHelp	:= ""
Local cLink		:= 'https://tdn.totvs.com/x/D4uMHw'

Private aCodFol := {}
Private aLog    := {}
Private aTitle  := {}
Private cPerg   := "UPDBINRES"

//Carrega o array aCodFol para verificar o cadastro de verbas x Ids de c�lculo
Fp_CodFol(@aCodFol, cFilAnt, .F., .F.)

//Verifica se existe o cadastro da verba de Id 1661 e se a verba foi preenchida
If Len(aCodFol) >= 1661
	lContinua := !Empty( aCodFol[1661,1] )
EndIf 

//Se n�o existir cadastro da verba para o Id 1661, aborta o processamento da rotina
// VERIFICA SE ENCONTROU O GRUPO DE PERGUNTAS
If lContinua  .And. GetRpoRelease() != "12.1.017" .And. !SX1->(DbSeek('UPDBINRES'))
	cMsg :=  + CRLF + OemToAnsi("N�o foi encontrado o grupo de perguntas: ") + Alltrim(cPerg)
	
	cMsgHelp := ""
	cMsgHelp += + CRLF + OemToAnsi("Antes de prosseguir ser� necess�rio criar o grupo de perguntas. Para isso, siga as instru��es contidos no link abaixo:")
	cMsgHelp += + CRLF + cLink + CRLF

	aAdd(aErros, cMsgHelp)
	
	Help(,, 'NOPERGUNT',, cMsg, 1, 0,,,,,, {aErros})
			
	Return()
ElseIf !lContinua
	cMsg := OemToAnsi( "Para executar essa rotina � obrigat�rio o cadastro da verba (Tipo 4 - Base Desconto) do seguinte identificador:" ) + CRLF
	cMsg += OemToAnsi( "1661 - Base dedutora INSS 13�" )
	MsgInfo( cMsg )
	Return()
EndIf

//Cria as perguntas no dicion�rio SX1 para filtro do processamento
If GetRpoRelease() <= "12.1.017"
	fCriaSX1()
EndIf

aAdd(aSays,OemToAnsi( "Este programa tem como objetivo gerar a verba do Id 1661 - Base dedutora INSS 13�" ))
aAdd(aSays,OemToAnsi( "no movimento de rescis�o (tabela SRR) para os funcion�rios que foram demitidos ap�s" ))
aAdd(aSays,OemToAnsi( "o c�lculo da 2� parcela do 13� sal�rio." ))
aAdd(aSays,OemToAnsi( 'Clique no bot�o "Abrir" para consultar a documenta��o no TDN para verificar os' ))
aAdd(aSays,OemToAnsi( "procedimentos necess�rios para transmitir corretamente o evento ao RET." ))

aAdd(aButtons, { 14,.T.,{|| ShellExecute("open","http://tdn.totvs.com/pages/viewpage.action?pageId=451256962","","",1) } } )
aAdd(aButtons, { 5,.T.,{|| Pergunte(cPerg,.T. ) } } )
aAdd(aButtons, { 1,.T.,{|o| nOpcA := 1,IF(gpconfOK(), FechaBatch(), nOpcA := 0 ) }} )
aAdd(aButtons, { 2,.T.,{|o| FechaBatch() }} )

//Abre a tela de processamento
FormBatch( "Gera��o da Base dedutora INSS 13�", aSays, aButtons )

//Efetua o processamento de gera��o
If nOpcA == 1
    Aadd( aTitle, OemToAnsi( "Funcion�rios que tiveram a verba de Id 1661 gerada:" ) )
    Aadd( aLog, {} )
    ProcGpe( {|lEnd| fProcessa()},,,.T. )
    fMakeLog(aLog,aTitle,,,"UPDBINRES",OemToAnsi("Log de Ocorr�ncias"),"M","P",,.F.)
EndIf

Return

/*/{Protheus.doc} fProcessa
Fun��o que efetua o processamento para a gera��o do Id 1661
/*/
Static Function fProcessa()

Local cAliasQry := GetNextAlias()
Local cFilOld   := cFilAnt
Local cJoinRRRV	:= "% " + FWJoinFilial( "SRR", "SRV" ) + " %"
Local cWhere    := ""
Local nValor1661:= ""
Local lNovo     := .F.

Pergunte( cPerg, .F. )
MakeSqlExpr( cPerg )

//Filial
If !Empty(mv_par01)
    cWhere += mv_par01
EndIf

//Matricula
If !Empty(mv_par02)
	cWhere += Iif(!Empty(cWhere)," AND ","")
	cWhere += mv_par02
EndIf

//Periodo inicial
cWhere += Iif(!Empty(cWhere)," AND ","")
cWhere += "RR_PERIODO >= '" + mv_par03 + "' "

//Periodo final
cWhere += "AND RR_PERIODO <= '" + mv_par04 + "' "

//Filtro para somente trazer verbas que existam no c�lculo de f�rias (SRH)
//cWhere += "AND EXISTS( SELECT SRR.RR_FILIAL, SRR.RR_MAT, SRR.RR_PD FROM " + RetSqlName('SRR') + " SRR WHERE SRR.RR_FILIAL = SRD.RD_FILIAL AND SRR.RR_MAT = SRD.RD_MAT AND SRR.RR_DATAPAG = SRD.RD_DATPGT AND SRR.RR_PD = SRD.RD_PD AND SRR.RR_ROTEIR = 'FER' AND SRR.D_E_L_E_T_ = ' ' )"

//Prepara a vari�vel para uso no BeginSql
cWhere := "%" + cWhere + "%"

//Processa a query e cria a tabela tempor�ria com os resultados
BeginSql alias cAliasQry
	SELECT SRR.RR_FILIAL, SRR.RR_MAT, SRR.RR_CC, SRR.RR_PERIODO, SRR.RR_SEMANA, SRR.RR_DATA, SRR.RR_DATAPAG, SRR.RR_DTREF, MIN(SRR.RR_SEQ) AS RR_SEQ, SUM(SRR.RR_VALOR) AS RR_VALOR
    FROM %table:SRR% SRR
    INNER JOIN %table:SRV% SRV
    ON	%exp:cJoinRRRV% AND
        SRV.RV_COD = SRR.RR_PD AND
        SRV.%notDel%
	WHERE %exp:cWhere% AND
        SRV.RV_CODFOL = '0247' AND
        SRR.%notDel%
	GROUP BY SRR.RR_FILIAL, SRR.RR_MAT, SRR.RR_CC, SRR.RR_PERIODO, SRR.RR_SEMANA, SRR.RR_DATA, SRR.RR_DATAPAG, SRR.RR_DTREF
EndSql 

While (cAliasQry)->( !EoF() )
    //Carrega o array aCodFol para verificar o cadastro de verbas x Ids de c�lculo
    If (cAliasQry)->RR_FILIAL != cFilOld
        cFilOld := (cAliasQry)->RR_FILIAL
        RstaCodFol()
        Fp_CodFol(@aCodFol, (cAliasQry)->RR_FILIAL, .F., .F.)  
    EndIf

    nValor1661 := (cAliasQry)->RR_VALOR

    //Ordena a tabela SRA pela ordem 1 - RA_FILIAL+RA_MAT
    SRA->( dbSetOrder(1) )
    //Posiciona na tabela SRA
    SRA->( dbSeek( (cAliasQry)->RR_FILIAL + (cAliasQry)->RR_MAT ) )
    
    //Ordena a tabela SRD pela ordem 1 - RR_FILIAL+RR_MAT+RR_TIPO3+DTOS(RR_DATA)+RR_PD+RR_CC
    SRR->( dbSetOrder(1) )

    If SRR->( dbSeek( (cAliasQry)->RR_FILIAL + (cAliasQry)->RR_MAT + "R" + (cAliasQry)->RR_DATA + aCodFol[0183, 1] + (cAliasQry)->RR_CC ) )
        nValor1661 += SRR->RR_VALOR
    EndIf

    //Verifica se a verba de Id 1661 j� exista na tabela SRR
    lNovo := SRR->( !dbSeek( (cAliasQry)->RR_FILIAL + (cAliasQry)->RR_MAT + "R" + (cAliasQry)->RR_DATA + aCodFol[1661, 1] + (cAliasQry)->RR_CC ) )

    //Trava o registro na SRD para edi��o
    If SRR->( RecLock("SRR", lNovo) )
        //Se for inclus�o, grava todos campos da SRR
        //Se for altera��o, apenas altera o valor do registro
        If lNovo
            SRR->RR_FILIAL  := (cAliasQry)->RR_FILIAL
            SRR->RR_MAT     := (cAliasQry)->RR_MAT
            SRR->RR_PD      := aCodFol[1661, 1]
            SRR->RR_TIPO1   := "V"
            SRR->RR_TIPO2   := "R"
            SRR->RR_DATA    := sToD((cAliasQry)->RR_DATA)
            SRR->RR_TIPO3   := "R"
            SRR->RR_PERIODO := (cAliasQry)->RR_PERIODO
            SRR->RR_ROTEIR  := "RES"
            SRR->RR_SEMANA  := (cAliasQry)->RR_SEMANA
            SRR->RR_DATAPAG := sToD((cAliasQry)->RR_DATAPAG)
            SRR->RR_SEQ     := (cAliasQry)->RR_SEQ
            SRR->RR_PROCES  := SRA->RA_PROCES
            SRR->RR_DTREF   := sToD((cAliasQry)->RR_DTREF)
            SRR->RR_CC      := (cAliasQry)->RR_CC
        EndIf
        SRR->RR_VALOR   := nValor1661
        
        //Adiciona no log de ocorr�ncias
        aAdd( aLog[1], "Filial: " + (cAliasQry)->RR_FILIAL + "  -  Matr�cula: " + (cAliasQry)->RR_MAT + "  -  Per�odo: " + (cAliasQry)->RR_PERIODO + "  -  Valor: R$ " + Transform( nValor1661, "@E 99,999,999,999.99" ) )

        //Libera o registro da SRD
        SRR->( MsUnlock() )
    EndIf
    
    //Pula para o pr�ximo registro
    (cAliasQry)->( dbSkip() )
EndDo

//Fecha a tabela tempor�ria da query
(cAliasQry)->( dbCloseArea() )

Return

/*/{Protheus.doc} fCriaSX1
Fun��o que cria as perguntas que ser�o utilizdas na rotina
/*/
Static Function fCriaSX1()

Local aHelpPor := {}

AAdd( aHelpPor, "Informe o per�odo inicial para a" )
AAdd( aHelpPor, "gera��o da verba de base." )
EngHLP117( "P"+".UPDBRES03.", aHelpPor, aHelpPor, aHelpPor )

aHelpPor := {}
AAdd( aHelpPor, "Informe o per�odo final para a" )
AAdd( aHelpPor, "gera��o da verba de base." )
EngHLP117( "P"+".UPDBRES04.", aHelpPor, aHelpPor, aHelpPor )

//			<cGrupo>	, <cOrdem>	, <cPergunt>				, <cPerSpa>	, <cPerEng>		, <cVar>	,<cTipo>	,<nTamanho>	,<nDecimal>		, <nPresel>		,<cGSC>	,<cValid>							,<cF3>		,<cGrpSxg>	,<cPyme>	,<cVar01>			,<cDef01> 		,<cDefSpa1>		,<cDefEng1>		,<cCnt01>		,<cDef02>				,<cDefSpa2>				,<cDefEng2>			,<cDef03>	, <cDefSpa3>	,<cDefEng3>		, <cDef04>	,<cDefSpa4>		, <cDefEng4>	,<cDef05>		, <cDefSpa5>	, <cDefEng5>	, <aHelpPor>, <aHelpEng>	, <aHelpSpa>	, <cHelp> )
EngSX1117( cPerg 	    , "01" 		,"Filial ?"			 		, ""		, ""		 	, "MV_CH1" 	, "C" 		, 99		,0				, 0	   			, "R" 	, ""								, "XM0" 	, ""		, "S" 		, "MV_PAR01" 		, "" 	   		, "" 			, "" 			, "RR_FILIAL"	, "" 					, ""					, "" 	 			, "" 		, "" 			, "" 			, "" 		, ""	 		, ""	  	 	, ""			, "" 		 	, ""	  		, {}	   	, {}   			, {} 			, ".RHFILDE."	)
EngSX1117( cPerg 	    , "02" 		,"Matr�cula ?"	 			, "" 		, ""			, "MV_CH2"	, "C" 		, 99   		,0	  			, 0	  	 		, "R" 	, ""								, "SRA" 	, "" 		, "S" 		, "MV_PAR02" 		, "" 	  		, "" 			, "" 			, "RR_MAT"		, "" 					, ""					, "" 	 			, "" 		, "" 			, "" 			, "" 	 	, ""	  		, ""	   		, ""		  	, "" 		 	, ""	  		, {}	   	, {} 			, {} 			, ".RHMATD."	)
EngSX1117( cPerg 	    , "03"		,"Per�odo inicial? (AAAAMM)", ""		, ""	        , 'MV_CH3'	, 'C'		, 6			,0				, 0				, 'G'	, 'NaoVazio()'						, ""		, ""		, "S"		, "MV_PAR03"		, "" 	   		, ""			, "" 	   		, ""			, "" 					, "" 					, "" 	 			, ""	  	, ""	   		, ""		  	, "" 		, ""	  		, ""	   		, "" 			, "" 			, ""	  		, {}	   	, {} 			, {} 			, ".UPDBRES03."	)
EngSX1117( cPerg 	    , "04"		,"Per�odo final? (AAAAMM)"	, ""		, ""	        , 'MV_CH4'	, 'C'		, 6			,0				, 0				, 'G'	, 'NaoVazio()'						, ""		, ""		, "S"		, "MV_PAR04"		, "" 			, ""			, "" 	   		, ""			, "" 					, "" 					, "" 	 			, ""	  	, ""	   		, ""		  	, "" 		, ""	  		, ""	   		, "" 			, "" 			, ""	  		, {}	   	, {} 			, {} 			, ".UPDBRES04."	)

Return