#INCLUDE "totvs.ch"
#INCLUDE "protheus.ch"
#INCLUDE "topconn.ch"
#INCLUDE "rwmake.ch"

//____________________________________________________________________
//====================================================================
//       R.E.L.A.T.Ó.R.I.O  D.E  C.O.N.T.A.B.I.L.I.Z.A.Ç.Ã.O
//
//	Rotina responsável por montar toda a estrutura do relatório de
//  Contabilização - SIGACTB
//
//			Alterações Realizadas desde a Estruturação Inicial
//____________________________________________________________________
//====================================================================

//____________________________________________________________________
//====================================================================
User Function RLCONR04()

	Private aPergs  := {}

    Private dData1  := CTOD('//')
	Private dData2  := CTOD('//')
	Private nPrcSE1 := 1
	Private nPrcSE2 := 1
	Private nPrcSE5 := 1
	Private nPrcSF1 := 1
	Private nPrcSF2 := 1
	Private nPrcSF3 := 1
	Private cLocalSaid := Padr("c:\microsiga\excel\",200)

	Private oExcel := Nil

	
	AADD( aPergs , { 1 , "Data de"  				, dData1  ,   ,      , "" ,     , 060 , .T. } )  
	AADD( aPergs , { 1 , "Data até" 				, dData2  ,   ,      , "" ,     , 060 , .T. } )

	AADD( aPergs , { 2 , "Exibir Contas a Receber" , nPrcSE1   , {"1=Sim","2=Nao"} , 040 , ".T." , .T. } )
	AADD( aPergs , { 2 , "Exibir Contas a Pagar"   , nPrcSE2   , {"1=Sim","2=Nao"} , 040 , ".T." , .T. } )
	AADD( aPergs , { 2 , "Exibir Mov. Bancário"    , nPrcSE5   , {"1=Sim","2=Nao"} , 040 , ".T." , .T. } )
	AADD( aPergs , { 2 , "Exibir Notas de Entrada" , nPrcSF1   , {"1=Sim","2=Nao"} , 040 , ".T." , .T. } )
	AADD( aPergs , { 2 , "Exibir Notas de Saída"   , nPrcSF2   , {"1=Sim","2=Nao"} , 040 , ".T." , .T. } )
	AADD( aPergs , { 2 , "Exibir Livros Fiscais"   , nPrcSF3   , {"1=Sim","2=Nao"} , 040 , ".T." , .T. } )
	aAdd( aPergs , { 1 , "Local de saída do excel" , cLocalSaid, "", ".T.", "", ".T.", 80 , .T. } )

	If 	ParamBox(aPergs,"Parâmetros!")

		dData1  	:= MV_PAR01
		dData2  	:= MV_PAR02
		nPrcSE1 	:= VAL(cValToChar(MV_PAR03))
		nPrcSE2 	:= VAL(cValToChar(MV_PAR04))
		nPrcSE5 	:= VAL(cValToChar(MV_PAR05))
		nPrcSF1 	:= VAL(cValToChar(MV_PAR06))
		nPrcSF2 	:= VAL(cValToChar(MV_PAR07))
		nPrcSF3 	:= VAL(cValToChar(MV_PAR08))
		cLocalSaid 	:= MV_PAR09


		//-- Se a soma das opções for 12...
		//-- Significa que o usuário não deseja imprimir nenhuma tabela!
		//-- Exemplo: (2=Nao = 2+2+2+2+2+2 = 12)
		If (nPrcSE1+nPrcSE2+nPrcSE5+nPrcSF1+nPrcSF2+nPrcSF3) < 12

			FwMsgRun(,{|oSay| FMntRlt(oSay) },"Relatório de Contabilização","Processando Estrutura do Relatório...",)

			FwMsgRun(,{|oSay| FMntCst(oSay,1), FMntCst(oSay,2), FMntCst(oSay,3), FMntCst(oSay,4), FMntCst(oSay,5), FMntCst(oSay,6), },"Relatório de Contabilização","Processando Consultas do Relatório...",)

			FwMsgRun(,{|oSay| FOpnRlt(oSay)},"Relatório de Contabilização","Processando Abertura do Relatório...",)

		Else
			MsgInfo("O relatório não pode ser impresso, pois não foram escolhidas rotinas para serem processadas!","Atenção!")
		Endif

	Endif

Return

//____________________________________________________________________
//====================================================================
//	Rotina responsável por montar toda a estrutura do relatório de
//  Contabilização - SIGACTB
//
//	Observações
//		* SE1 - Títulos Receber
//		* SE2 - Títulos Pagar
//		* SE5 - Movimento Bancário
//		* SF1 - Notas de Entrada
//		* SF2 - Notas de Entrada
//		* SF3 - Livros Fiscais

//====================================================================
Static Function FMntRlt(oSay)

	oExcel := FWMSExcel():New()

	oExcel:SetFont('Calibri')			//-- Fonte da planilha
	oExcel:SetHeaderSizeFont(10)		//-- Tamanho da fonte do cabeçalho
	oExcel:SetLineSizeFont(10)			//-- Tamanho da fonte da linha 1
	oExcel:Set2LineSizeFont(10)			//-- Tamanho da fonte da linha 2
	oExcel:SetBgColorHeader('#4F4F4F')	//-- Cor da célula do cabeçalho
	oExcel:SetTitleFrColor('#000000')	//-- Cor da fonte do título
	oExcel:SetLineBgColor('#DCDCDC')	//-- Cor da célula da linha 1
    oExcel:Set2LineBgColor('#FFFFFF')	//-- Cor da célula da linha 2

	//-- Verifica se as abas serão impressas conforme os parâmetros informados
	If nPrcSE1 == 1
		oExcel:AddworkSheet( "Contas a Receber" )
		
		oExcel:AddTable( "Contas a Receber" , "Contas a Receber" )
		
		oExcel:AddColumn( "Contas a Receber" , "Contas a Receber" , "Documento"      , 2 , 1 )
		oExcel:AddColumn( "Contas a Receber" , "Contas a Receber" , "Data"           , 2 , 4 )
		oExcel:AddColumn( "Contas a Receber" , "Contas a Receber" , "Valor"          , 2 , 3 )
		oExcel:AddColumn( "Contas a Receber" , "Contas a Receber" , "Contabilizado?" , 2 , 1 )
	Endif

	If nPrcSE2 == 1
		oExcel:AddworkSheet( "Contas a Pagar" )

		oExcel:AddTable( "Contas a Pagar" , "Contas a Pagar" )

		oExcel:AddColumn( "Contas a Pagar" , "Contas a Pagar" , "Documento"      , 2 , 1 )
		oExcel:AddColumn( "Contas a Pagar" , "Contas a Pagar" , "Data"           , 2 , 4 )
		oExcel:AddColumn( "Contas a Pagar" , "Contas a Pagar" , "Valor"          , 2 , 3 )
		oExcel:AddColumn( "Contas a Pagar" , "Contas a Pagar" , "Contabilizado?" , 2 , 1 )
	Endif

	If nPrcSE5 == 1
		oExcel:AddworkSheet( "Movimento Bancario" )

		oExcel:AddTable( "Movimento Bancario" , "Movimento Bancario" )

		oExcel:AddColumn( "Movimento Bancario" , "Movimento Bancario" , "Número"         , 2 , 1 )
		oExcel:AddColumn( "Movimento Bancario" , "Movimento Bancario" , "Data"           , 2 , 4 )
		oExcel:AddColumn( "Movimento Bancario" , "Movimento Bancario" , "Valor"          , 2 , 3 )
		oExcel:AddColumn( "Movimento Bancario" , "Movimento Bancario" , "Banco"          , 2 , 1 )
		oExcel:AddColumn( "Movimento Bancario" , "Movimento Bancario" , "Agencia"        , 2 , 1 )
		oExcel:AddColumn( "Movimento Bancario" , "Movimento Bancario" , "Conta"          , 2 , 1 )
		oExcel:AddColumn( "Movimento Bancario" , "Movimento Bancario" , "Tipo"           , 2 , 1 )
		oExcel:AddColumn( "Movimento Bancario" , "Movimento Bancario" , "Contabilizado?" , 2 , 1 )
	Endif

	If nPrcSF1 == 1
		oExcel:AddworkSheet( "Notas de Entrada" )

		oExcel:AddTable( "Notas de Entrada" , "Notas de Entrada" )

		oExcel:AddColumn( "Notas de Entrada" , "Notas de Entrada" , "Filial"         , 2 , 1 )
		oExcel:AddColumn( "Notas de Entrada" , "Notas de Entrada" , "Série"          , 2 , 1 )
		oExcel:AddColumn( "Notas de Entrada" , "Notas de Entrada" , "Documento"      , 2 , 1 )
		oExcel:AddColumn( "Notas de Entrada" , "Notas de Entrada" , "Digitação"      , 2 , 4 )
		oExcel:AddColumn( "Notas de Entrada" , "Notas de Entrada" , "Valor"          , 2 , 3 )
		oExcel:AddColumn( "Notas de Entrada" , "Notas de Entrada" , "Fornecedror"    , 2 , 1 )
		oExcel:AddColumn( "Notas de Entrada" , "Notas de Entrada" , "Loja"           , 2 , 1 )
		oExcel:AddColumn( "Notas de Entrada" , "Notas de Entrada" , "Nome"           , 2 , 1 )
		oExcel:AddColumn( "Notas de Entrada" , "Notas de Entrada" , "PIS"            , 2 , 3 )
		oExcel:AddColumn( "Notas de Entrada" , "Notas de Entrada" , "COFINS"         , 2 , 3 )
		oExcel:AddColumn( "Notas de Entrada" , "Notas de Entrada" , "ICMS"           , 2 , 3 )
		oExcel:AddColumn( "Notas de Entrada" , "Notas de Entrada" , "Contabilizado?" , 2 , 1 )
		oExcel:AddColumn( "Notas de Entrada" , "Notas de Entrada" , "Motivo"         , 2 , 1 )
		oExcel:AddColumn( "Notas de Entrada" , "Notas de Entrada" , "CFOPs"          , 2 , 1 )
	Endif

	If nPrcSF2 == 1
		oExcel:AddworkSheet( "Notas de Saida" )

		oExcel:AddTable( "Notas de Saida" , "Notas de Saida" )

		oExcel:AddColumn( "Notas de Saida" , "Notas de Saida" , "Filial"        , 2 , 1 )
		oExcel:AddColumn( "Notas de Saida" , "Notas de Saida" , "Série"         , 2 , 1 )
		oExcel:AddColumn( "Notas de Saida" , "Notas de Saida" , "Documento"     , 2 , 1 )
		oExcel:AddColumn( "Notas de Saida" , "Notas de Saida" , "Emissão"       , 2 , 4 )
		oExcel:AddColumn( "Notas de Saida" , "Notas de Saida" , "Valor"         , 2 , 3 )
		oExcel:AddColumn( "Notas de Saida" , "Notas de Saida" , "Cliente"       , 2 , 1 )
		oExcel:AddColumn( "Notas de Saida" , "Notas de Saida" , "Loja"          , 2 , 1 )
		oExcel:AddColumn( "Notas de Saida" , "Notas de Saida" , "Nome"          , 2 , 1 )
		oExcel:AddColumn( "Notas de Saida" , "Notas de Saida" , "PIS"           , 2 , 3 )
		oExcel:AddColumn( "Notas de Saida" , "Notas de Saida" , "COFINS"        , 2 , 3 )
		oExcel:AddColumn( "Notas de Saida" , "Notas de Saida" , "ICMS"          , 2 , 3 )
		oExcel:AddColumn( "Notas de Saida" , "Notas de Saida" , "Contabilizado?" , 2 , 1 )
	Endif

	If nPrcSF3 == 1
		oExcel:AddworkSheet( "Livros Fiscais" )

		oExcel:AddTable( "Livros Fiscais" , "Livros Fiscais" )

		oExcel:AddColumn( "Livros Fiscais" , "Livros Fiscais" , "Série"          , 2 , 1 )
		oExcel:AddColumn( "Livros Fiscais" , "Livros Fiscais" , "Documento"      , 2 , 1 )
		oExcel:AddColumn( "Livros Fiscais" , "Livros Fiscais" , "Emissão"        , 2 , 4 )
		oExcel:AddColumn( "Livros Fiscais" , "Livros Fiscais" , "Especie"        , 2 , 1 )
		oExcel:AddColumn( "Livros Fiscais" , "Livros Fiscais" , "Contabilizado?" , 2 , 1 )
	Endif

Return

//____________________________________________________________________
//====================================================================
//	Rotina responsável por montar toda a estrutura da consulta do 
//	relatório de Contabilização - SIGACTB

//====================================================================
Static Function FMntCst(oSay,nOpc)

    Local aAlias  := GetArea()
    Local cAlias  := GetNextAlias()
    Local cQuery  := ""
	Local cNomFor := ""

	//=====================================
	//-- TABELA SE1 -> TÍTULOS A RECEBER
	//=====================================
	If nOpc == 1 .AND. nPrcSE1 == 1

	  	cQuery := " SELECT SE1.E1_NUM     , " + CRLF
		cQuery += "        SE1.E1_VALOR   , " + CRLF
		cQuery += "        SE1.E1_LA      , " + CRLF
		cQuery += "        SD1.D1_DTDIGIT   " + CRLF
	  	cQuery += " FROM " + RetSqlName("SE1") + " SE1 " + CRLF

	  	cQuery += " INNER JOIN " + RetSqlName("SD1") + " SD1 " + CRLF
		cQuery += "  ON ( SD1.D1_FILIAL  = SE1.E1_FILIAL " + CRLF
		cQuery += "   AND SD1.D1_DOC     = SE1.E1_NUM " + CRLF
		cQuery += "   AND SD1.D_E_L_E_T_ = '' " + CRLF
		cQuery += "   AND SD1.D1_DTDIGIT BETWEEN '" + DTOS(dData1) + "' AND '" + DTOS(dData2) + "' ) " + CRLF

	  	cQuery += " WHERE SE1.D_E_L_E_T_ = '' " + CRLF
		cQuery += "   AND SE1.E1_LA <> 'S' " + CRLF
		cQuery += "   AND SE1.E1_FILIAL  = '" + xFilial("SE1") + "' " + CRLF

		DbUseArea(.T.,"TOPCONN",TCGenQry(,,cQuery),cAlias,.F.,.T.)

		DbSelectArea(cAlias)
		(cAlias)->(DbGoTop())

		//-- Criando as linhas
		While !(cAlias)->(EOF())
			oExcel:AddRow( "Contas a Receber" , "Contas a Receber" , { (cAlias)->E1_NUM , cValToChar(Stod((cAlias)->D1_DTDIGIT)) , (cAlias)->E1_VALOR ,"NÃO" } )
			(cAlias)->(DbSkip())
		Enddo

		(cAlias)->(DbCloseArea())

	Endif

	//=====================================
	//-- TABELA SE2 -> TÍTULOS A PAGAR
	//=====================================
	If nOpc == 2 .AND. nPrcSE2 == 1

	  	cQuery := " SELECT SE2.E2_NUM     , " + CRLF
		cQuery += "        SE2.E2_VALOR   , " + CRLF
		cQuery += "        SE2.E2_LA      , " + CRLF
		cQuery += "        SD2.D2_DTDIGIT   " + CRLF
	  	cQuery += " FROM " + RetSqlName("SE2") + " SE2 " + CRLF

	  	cQuery += " INNER JOIN " + RetSqlName("SD2") + " SD2 " + CRLF
		cQuery += "  ON ( SD2.D2_FILIAL  = SE2.E2_FILIAL " + CRLF
		cQuery += "   AND SD2.D2_DOC     = SE2.E2_NUM " + CRLF
		cQuery += "   AND SD2.D_E_L_E_T_ = '' " + CRLF
		cQuery += "   AND SD2.D2_DTDIGIT BETWEEN '" + DTOS(dData1) + "' AND '" + DTOS(dData2) + "' ) " + CRLF

	  	cQuery += " WHERE SE2.D_E_L_E_T_ = '' " + CRLF
		cQuery += "   AND SE2.E2_LA <> 'S' " + CRLF
		cQuery += "   AND SE2.E2_FILIAL  = '" + xFilial("SE2") + "' " + CRLF

		DbUseArea(.T.,"TOPCONN",TCGenQry(,,cQuery),cAlias,.F.,.T.)

		DbSelectArea(cAlias)
		(cAlias)->(DbGoTop())

		//-- Criando as linhas
		While !(cAlias)->(EOF())
			oExcel:AddRow( "Contas a Pagar" , "Contas a Pagar" , { (cAlias)->E2_NUM , cValToChar(Stod((cAlias)->D2_DTDIGIT)) , (cAlias)->E2_VALOR , "NÃO" } )
			(cAlias)->(DbSkip())
		Enddo

		(cAlias)->(DbCloseArea())

	Endif

	//=====================================
	//-- TABELA SE5 -> MOVIMENTO BANCÁRIO
	//=====================================
	If nOpc == 3 .AND. nPrcSE5 == 1

		cQuery := " SELECT SE5.E5_NUMERO  , " + CRLF
		cQuery += "        SE5.E5_DATA    , " + CRLF
		cQuery += "        SE5.E5_VALOR   , " + CRLF
		cQuery += "        SE5.E5_BANCO   , " + CRLF
		cQuery += "        SE5.E5_AGENCIA , " + CRLF
		cQuery += "        SE5.E5_CONTA   , " + CRLF
		cQuery += "        SE5.E5_TIPO    , " + CRLF
		cQuery += "        SE5.E5_LA        " + CRLF
	  	cQuery += " FROM " + RetSqlName("SE5") + " SE5 " + CRLF
	  	cQuery += " WHERE SE5.E5_FILIAL  = '" + xFilial("SE5") + "' " + CRLF
		cQuery += "   AND SE5.E5_DATA BETWEEN '" + DTOS(dData1) + "' AND '" + DTOS(dData2) + "' " + CRLF
		cQuery += "   AND SE5.E5_LA <> 'S' " + CRLF
		cQuery += "   AND SE5.D_E_L_E_T_ = '' " + CRLF

		DbUseArea(.T.,"TOPCONN",TCGenQry(,,cQuery),cAlias,.F.,.T.)

		DbSelectArea(cAlias)
		(cAlias)->(DbGoTop())

		//-- Criando as linhas
		While !(cAlias)->(EOF())
			oExcel:AddRow( "Movimento Bancario" , "Movimento Bancario" , { (cAlias)->E5_NUMERO 	, ;
																		   cValToChar(Stod((cAlias)->E5_DATA)) , ;
																		   (cAlias)->E5_VALOR 	, ;
																		   (cAlias)->E5_BANCO 	, ;
																		   (cAlias)->E5_AGENCIA , ;
																		   (cAlias)->E5_CONTA 	, ;
																		   (cAlias)->E5_TIPO	, ; 
																		   "NÃO" 				} )
			(cAlias)->(DbSkip())
		Enddo

		(cAlias)->(DbCloseArea())

	Endif

	//=====================================
	//-- TABELA SF1 -> NOTAS DE ENTRADA
	//=====================================
	If nOpc == 4 .AND. nPrcSF1 == 1

		cQuery := " SELECT SF1.F1_FILIAL  , " + CRLF
		cQuery += "        SF1.F1_SERIE   , " + CRLF
		cQuery += "        SF1.F1_DOC     , " + CRLF
		cQuery += "        SF1.F1_DTDIGIT , " + CRLF
		cQuery += "        SF1.F1_VALBRUT , " + CRLF
		cQuery += "        SF1.F1_FORNECE , " + CRLF
		cQuery += "        SF1.F1_LOJA    , " + CRLF
		cQuery += "        SF1.F1_VALPIS  , " + CRLF
		cQuery += "        SF1.F1_VALCOFI , " + CRLF
		cQuery += "        SF1.F1_VALICM  , " + CRLF
		cQuery += "        SE5.E5_MOTBX     " + CRLF
	  	cQuery += " FROM " + RetSqlName("SF1") + " SF1 " + CRLF
		cQuery += " LEFT JOIN " + RetSqlName("SE5") + " SE5 ON ( SE5.E5_FILIAL = SF1.F1_FILIAL AND SE5.E5_NUMERO = SF1.F1_DOC AND SE5.E5_FORNECE = SF1.F1_FORNECE AND SE5.E5_LOJA = SF1.F1_LOJA AND SE5.D_E_L_E_T_ = '' ) " + CRLF
	  	cQuery += " WHERE SF1.F1_FILIAL  = '" + xFilial("SF1") + "' " + CRLF
		cQuery += "   AND SF1.F1_DTDIGIT BETWEEN '" + DTOS(dData1) + "' AND '" + DTOS(dData2) + "' " + CRLF
		cQuery += "   AND SF1.F1_DTLANC  = '' " + CRLF
		cQuery += "   AND SF1.D_E_L_E_T_ = '' " + CRLF
		cQuery += " GROUP BY SF1.F1_FILIAL  , " + CRLF
		cQuery += "          SF1.F1_SERIE   , " + CRLF
		cQuery += "          SF1.F1_DOC     , " + CRLF
		cQuery += "          SF1.F1_DTDIGIT , " + CRLF
		cQuery += "          SF1.F1_VALBRUT , " + CRLF
		cQuery += "          SF1.F1_FORNECE , " + CRLF
		cQuery += "          SF1.F1_LOJA    , " + CRLF
		cQuery += "          SF1.F1_VALPIS  , " + CRLF
		cQuery += "          SF1.F1_VALCOFI , " + CRLF
		cQuery += "          SF1.F1_VALICM  , " + CRLF
		cQuery += "          SE5.E5_MOTBX     " + CRLF

		DbUseArea(.T.,"TOPCONN",TCGenQry(,,cQuery),cAlias,.F.,.T.)

		DbSelectArea(cAlias)
		(cAlias)->(DbGoTop())

		While !(cAlias)->(EOF())
			cNomFor := ''
			cNomFor := Posicione("SA2",1,xFilial("SA2") + (cAlias)->F1_FORNECE + (cAlias)->F1_LOJA,"A2_NOME")

			/*(cAlias)->F1_VALCOF                               ,;*/
			oExcel:AddRow( "Notas de Entrada" , "Notas de Entrada" , { (cAlias)->F1_FILIAL + " - " + Upper(FWFilialName()) ,;
																	   (cAlias)->F1_SERIE 								   ,;
																	   (cAlias)->F1_DOC   								   ,;
																	   cValToChar(STOD((cAlias)->F1_DTDIGIT)) 			   ,;
																	   (cAlias)->F1_VALBRUT 							   ,;
																	   (cAlias)->F1_FORNECE								   ,;
																	   (cAlias)->F1_LOJA								   ,;
																	   cNomFor								   			   ,;
																	   (cAlias)->F1_VALPIS                                 ,;
																	   " "                                                 ,;
																	   (cAlias)->F1_VALICM                                 ,;
																	   "NÃO"											   ,;
																	   (cAlias)->E5_MOTBX 								   ,;
																	   FBCFOPS((cAlias)->F1_FILIAL, (cAlias)->F1_DOC, (cAlias)->F1_SERIE, (cAlias)->F1_FORNECE, (cAlias)->F1_LOJA ) })
			(cAlias)->(DbSkip())
		Enddo

		(cAlias)->(DbCloseArea())

	Endif

	//=====================================
	//-- TABELA SF2 -> NOTAS DE SAÍDA
	//=====================================
	If nOpc == 5 .AND. nPrcSF2 == 1

		cQuery := " SELECT SF2.F2_FILIAL  , " + CRLF
		cQuery += "        SF2.F2_SERIE   , " + CRLF
		cQuery += "        SF2.F2_DOC     , " + CRLF
		cQuery += "        SF2.F2_EMISSAO , " + CRLF
		cQuery += "        SF2.F2_VALBRUT , " + CRLF
		cQuery += "        SF2.F2_CLIENTE , " + CRLF
		cQuery += "        SF2.F2_LOJA    , " + CRLF
		cQuery += "        SA1.A1_NOME    , " + CRLF
		cQuery += "        SF2.F2_VALPIS  , " + CRLF
		cQuery += "        SF2.F2_VALCOFI , " + CRLF
		cQuery += "        SF2.F2_VALICM    " + CRLF
	  	cQuery += " FROM " + RetSqlName("SF2") + " SF2 " + CRLF
		cQuery += " LEFT JOIN " + RetSqlName("SA1") + " SA1 ON ( SA1.A1_COD = SF2.F2_CLIENTE AND SA1.A1_LOJA = SF2.F2_LOJA AND SA1.D_E_L_E_T_ = '' ) " + CRLF
	  	cQuery += " WHERE SF2.F2_FILIAL  = '" + xFilial("SF2") + "' " + CRLF
		cQuery += "   AND SF2.F2_EMISSAO BETWEEN '" + DTOS(dData1) + "' AND '" + DTOS(dData2) + "' " + CRLF
		cQuery += "   AND SF2.F2_DTLANC = '' " + CRLF
		cQuery += "   AND SF2.D_E_L_E_T_ = '' " + CRLF

		DbUseArea(.T.,"TOPCONN",TCGenQry(,,cQuery),cAlias,.F.,.T.)

		DbSelectArea(cAlias)
		(cAlias)->(DbGoTop())

		//-- Criando as linhas
		While !(cAlias)->(EOF())
			oExcel:AddRow( "Notas de Saida" , "Notas de Saida" , { (cAlias)->F2_FILIAL 		  , ;
																   (cAlias)->F2_SERIE 		  , ;
																   (cAlias)->F2_DOC   		  , ;
																   STOD((cAlias)->F2_EMISSAO) , ;
																   (cAlias)->F2_VALBRUT 	  , ;
																   (cAlias)->F2_CLIENTE 	  , ;
																   (cAlias)->F2_LOJA 		  , ;
																   (cAlias)->A1_NOME 		  , ;
																   (cAlias)->F2_VALPIS 		  , ;
																   (cAlias)->F2_VALCOFI 	  , ;
																   (cAlias)->F2_VALICM 		  , ;
																   "NÃO" 					  } )
			(cAlias)->(DbSkip())
		Enddo

		(cAlias)->(DbCloseArea())

	Endif

	//=====================================
	//-- TABELA SF3 -> LIVROS FISCAIS
	//=====================================
	If nOpc == 6 .AND. nPrcSF3 == 1

		cQuery := " SELECT SF3.F3_SERIE   , " + CRLF
		cQuery += "        SF3.F3_NFISCAL , " + CRLF
		cQuery += "        SF3.F3_EMISSAO , " + CRLF
		cQuery += "        SF3.F3_ESPECIE   " + CRLF
	  	cQuery += " FROM " + RetSqlName("SF3") + " SF3 " + CRLF
	  	cQuery += " WHERE SF3.F3_FILIAL  = '" + xFilial("SF3") + "' " + CRLF
		cQuery += "   AND SF3.F3_EMISSAO BETWEEN '" + DTOS(dData1) + "' AND '" + DTOS(dData2) + "' " + CRLF
		cQuery += "   AND SF3.F3_DTLANC = '' " + CRLF
		cQuery += "   AND SF3.D_E_L_E_T_ = '' " + CRLF

		DbUseArea(.T.,"TOPCONN",TCGenQry(,,cQuery),cAlias,.F.,.T.)

		DbSelectArea(cAlias)
		(cAlias)->(DbGoTop())

		//-- Criando as linhas
		While !(cAlias)->(EOF())
			oExcel:AddRow( "Livros Fiscais" , "Livros Fiscais" , { (cAlias)->F3_SERIE , (cAlias)->F3_NFISCAL , cValToChar(Stod((cAlias)->F3_EMISSAO)) , (cAlias)->F3_ESPECIE , "NÃO" } )
			(cAlias)->(DbSkip())
		Enddo

		(cAlias)->(DbCloseArea())

	Endif

	 RestArea(aAlias)

Return

Static Function FBCFOPS(cFilSF1, cDocSF1, cSerSF1, cForSF1, cLojSF1)

	Local aArea  := GetArea()
	Local cArea  := GetNextAlias()
	Local cQry   := ""
	Local cCFOPS := ""

	cQry := " SELECT D1_CF " + CRLF
	cQry += " FROM " + RetSqlName("SD1") + " " + CRLF
	cQry += " WHERE D1_FILIAL   = '" + cFilSF1 + "' " + CRLF
	cQry += "   AND D1_DOC      = '" + cDocSF1 + "' " + CRLF
	cQry += "   AND D1_SERIE    = '" + cSerSF1 + "' " + CRLF
	cQry += "   AND D1_FORNECE  = '" + cForSF1 + "' " + CRLF
	cQry += "   AND D1_LOJA     = '" + cLojSF1 + "' " + CRLF
	cQry += "   AND D_E_L_E_T_  = '' " + CRLF
	cQry += " GROUP BY D1_CF   " + CRLF

	DbUseArea(.T.,"TOPCONN",TCGenQry(,,cQry),cArea,.F.,.T.)

	DbSelectArea(cArea)
	(cArea)->(DbGoTop())

	While !(cArea)->(EOF())

		If !Empty((cArea)->D1_CF)
			cCFOPS += (cArea)->D1_CF + " "
		Endif

		(cArea)->(DbSkip())

	Enddo

	(cArea)->(DbCloseArea())

	 RestArea(aArea)

Return(cCFOPS)

//____________________________________________________________________
//====================================================================
//	Rotina responsável salvar e abrir o relatório de Contabilização
//	do módulo SIGACTB
//
//	Exemplos: cBIMakeID()

//____________________________________________________________________
//====================================================================
Static Function FOpnRlt(oSay)

    Local oExc := Nil
	Local cLoc := trim(cLocalSaid)
	Local cArq := 'RLCONR04' + '-' + DTOS(Date()) + '-' + AllTrim(StrTran(Time(),':','')) + '.xml'

	If !ExistDir(cLoc)
		If MakeDir(cLoc) <> 0
			MakeDir(cLoc)
			If !ExistDir("c:\microsiga\excel\")
				MakeDir("c:\microsiga\excel\")
			Endif
		Endif
	Endif

	If File(cLoc + cArq)
		FErase(cLoc + cArq)
	Endif

	oExcel:Activate()
	oExcel:GetXmlFile(cLoc+cArq)

	If !ApOleClient("MsExcel")
		MsgInfo('Microsoft Excel não instalado!' + CRLF + CRLF + 'Acesse o arquivo em:' + CRLF + CRLF + cLoc+cArq,'Error!')
	Else
		oExc := MsExcel():New()			//-- Abre uma nova conexão com o excel
		oExc:WorkBooks:Open(cLoc+cArq)  //-- Abre uma planilha
		oExc:SetVisible(.T.)        	//-- Visualiza a planilha
		oExc:Destroy()              	//-- Encerra o processo
	Endif

Return
