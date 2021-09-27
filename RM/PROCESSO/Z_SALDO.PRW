#include "PROTHEUS.CH"
#include "TBICONN.CH"
#INCLUDE "totvs.ch"
#INCLUDE "rwmake.ch"
#DEFINE QUEBRA CHR(13)+CHR(10)

//-------------------------------------------------------------------
/* {Protheus.doc} Z_Saldo
Classe utilizada para buscar saldo do projeto 

@protected TSA
@author    Alex T. Souza
@since     27/09/2019

Alteracoes Realizadas desde a Estruturacao Inicial
Data       Programador     Motivo
/*/
//-------------------------------------------------------------------


Class Z_Saldo
	Data cMensagem
	Data cColigada
	Data cCodFil
	Data cCodProj
	Data cIDProj
	Data cCodTarefa
	Data aIDTarefa  As Array
	Data dDtEnt
	Data nSaldo
	Data nTotSC
	Data nTotPC
	Data nTotNF
	Data nTotFI	
	Data nAbatSC
	Data nAbatPC
	Data nAbatNF
	Data nAbatFI
	Data nTotal
	Data cCodProc
	Data cProcesso
	Data cIdPeriodo
	Data dIniPer
	Data dFimPer
	Data nValProc
	Data lOk
	
	Method New() CONSTRUCTOR
	Method Ini()
	Method Consulta()
	Method ConsSaldo()
	Method Avalia()
	

EndClass

//Construtor da classe
Method New() Class Z_Saldo
	
	::Ini()

Return(Self)

//Ini da classe
Method Ini() Class Z_Saldo

	::cMensagem		:= ""
	::nSaldo		:= 0
	::nTotSC		:= 0
	::nTotPC		:= 0
	::nTotNF		:= 0
	::nTotFI		:= 0
	::nAbatSC 		:= 0
	::nAbatPC 		:= 0
	::nAbatNF 		:= 0
	::nAbatFI 		:= 0
	::nTotal		:= 0
	::nValProc		:= 0
	::cColigada		:= ""
	::cCodFil		:= ""
	::cCodProj		:= ""
	::cIDProj		:= ""
	::cCodTarefa	:= ""
	::aIDTarefa		:= {}
	::cCodProc		:= ""
	::cProcesso		:= ""
	::cIdPeriodo	:= ""
	::dDtEnt		:= ddatabase	
	::dIniPer		:= ctod("")
	::dFimPer		:= ctod("")
	::lOk			:= .t.
Return()

//Metodo ConsSaldo
Method ConsSaldo() Class Z_Saldo
	::Consulta()
Return()

//Consulta Saldo Projeto
Method Consulta() Class Z_Saldo
	Local cAlias
	Local cQuery	:= ""
	Local oBDados
	Local lErro		:= .f.
	Local cMsg		:= ""
	Local aPeriodo	:= {}	
	Local aTarefa	:= {}
	Local nXi		:= 0	
	
	If !lErro
		::cColigada := BuscaColigada(cEmpAnt,::cCodFil,@lErro,@cMsg)
	Endif	
	
	If !lErro
		::cIDProj  	:= IDPrjNoDEPARA(::cCodProj,@lErro,@cMsg)
	Endif
	
	If !lErro	
		aTarefa := StrToKarr( ::cCodTarefa, ";" )
		For nXi := 1 to len(aTarefa)
			aadd(::aIDTarefa,BuscaIDTrf(::cColigada,::cIDProj, aTarefa[nXi],@lErro,@cMsg))
		Next	
	Endif	
	
	If !lErro
		If len(aPeriodo  := BuscaPeriodo(::cColigada,::cIDProj,::dDtEnt,@lErro,@cMsg)) > 0
			::cIdPeriodo 	:= aPeriodo[1]
			::dIniPer 		:= aPeriodo[2]
			::dFimPer 		:= aPeriodo[3]
		Endif			
	Endif
	
	If !lErro	
		::nSaldo := 0
		For nXi := 1 to len(::aIDTarefa)
			::nSaldo += BuscaSaldo(::cColigada,::cIDProj,::aIDTarefa[nXi],::cIdPeriodo,lErro,cMsg)
		Next	
	Endif	
	
	If !Empty(Alltrim(::cCodProj))
		::lOk 		:= !lErro
		::cMensagem	:= cMsg
	Else
		::lOk 		:= .t.
		::cMensagem	:= ""
	Endif
	If !Empty(::cCodProj) .and. !Empty(::cCodTarefa) .and. !lErro

		::nTotSC 	:= ValorSC(::cCodFil,::cCodProj,::cCodTarefa,::dIniPer,::dFimPer)
		::nTotPC 	:= ValorPC(::cCodFil,::cCodProj,::cCodTarefa,::dIniPer,::dFimPer)
		::nTotNF	:= 0 //ValorNF(::cCodFil,::cCodProj,::cCodTarefa,::dIniPer,::dFimPer)
		::nTotFI    := 0 //ValorFI(::cCodFil,::cCodProj,::cCodTarefa,::dIniPer,::dFimPer)		
		
		::nTotSC := ::nTotSC - ::nAbatSC
		::nTotPC := ::nTotPC - ::nAbatPC
		::nTotNF := ::nTotNF - ::nAbatNF
		::nTotFI := ::nTotFI - ::nAbatFI
		
		Do Case
			Case ::cCodProc	== "001" // Solicitação de Compras
				::nTotSC := ::nTotSC + ::nValProc
			Case ::cCodProc	== "002" // Pedido de Compras
				::nTotPC := ::nTotPC + ::nValProc
		EndCase	

		::nTotal	:= ::nTotal + ::nTotSC + ::nTotPC  + ::nTotNF + ::nTotFI		

	Endif
	
Return()


//Avalia se processo pode continuar
Method Avalia() Class Z_Saldo
Local cMsg	:= ""
	
	If ::lOk
		If ::nSaldo - ::nTotal >= 0
			::lOk := .t.
		Else
			::lOk := .f.
			
			//Monta mensagem do Saldo 
			
			cMsg    := ""
			cMsg	+=	"Coligada "+::cColigada+QUEBRA
			cMsg	+=	"ID Projeto "+::cIDProj+QUEBRA
			cMsg	+=	"Os saldos atuais do RM TOP são insuficientes "+QUEBRA
			cMsg	+=	"para realizar essa operacao na Data de Entrega "+DTOC(::dDtEnt)+" "+QUEBRA
			cMsg	+=	"Periodo de "+DTOC(::dIniPer)+" ate "+DTOC(::dFimPer)+" "+QUEBRA+QUEBRA
			cMsg	+=  "Processo: "+::cProcesso+QUEBRA+QUEBRA
			cMsg	+=  "Saldo RM Top para o periodo: "+TRANSFORM(::nSaldo,"@E 999,999,999,999.99")+QUEBRA+QUEBRA
			cMsg	+=  "Solicitação Compras: "+TRANSFORM(::nTotSC,"@E 999,999,999,999.99")+QUEBRA
			cMsg	+=  "Pedido de Compras: "+TRANSFORM(::nTotPC,"@E 999,999,999,999.99")+QUEBRA
			cMsg	+=  "Nota Fiscal: "+TRANSFORM(::nTotNF,"@E 999,999,999,999.99")+QUEBRA
			cMsg	+=  "Financeiro: "+TRANSFORM(::nTotFI,"@E 999,999,999,999.99")+QUEBRA+QUEBRA
			cMsg	+=  "Saldo Final: "+TRANSFORM(::nSaldo - ::nTotal,"@E 999,999,999,999.99")+QUEBRA+QUEBRA
			cMsg	+=	"Solicite o ajuste do saldo no RM TOP ou ajuste da Data de Entrega "+QUEBRA
			
			::cMensagem	:= cMsg
				
		Endif	
	Endif

Return()

Static Function ValorNF(cFil,cPrj,cTar,dPerIni,dPerFim)
Local cQuery    	:= ""
Local cAliasQry 	:= GetNextAlias()
Local nTotal		:= 0

cQuery += "SELECT  SUM(SD1.D1_TOTAL) TOTALNF FROM " + RetSqlName("SD1")+" SD1 "
cQuery += "WHERE SD1.D1_FILIAL = '"+Alltrim(cFil)+"' AND  SD1.D1_ZPRJ = '"+Alltrim(cPrj)+"' AND SD1.D1_ZTARE = '"+Alltrim(cTar)+"' AND  "
cQuery += "AND SD1.D1_ZDTENT >= '"+DtoS(dPerIni)+"' AND SD1.D1_ZDTENT <= '"+DtoS(dPerFim)+"' "
cQuery += "AND SD1.D_E_L_E_T_ <> '*' "

dbUseArea(.T., "TOPCONN", TCGENQRY(,, cQuery), cAliasQry, .T., .T.)

If !(cAliasQry)->(Eof()) 
	nTotal := (cAliasQry)->TOTALNF
Endif

(cAliasQry)->(dbCloseArea())

Return nTotal

Static Function ValorPC(cFil,cPrj,cTar,dPerIni,dPerFim)
Local cQuery    	:= ""
Local cAliasQry 	:= GetNextAlias()
Local nTotal		:= 0

cQuery += "SELECT  SUM(SC7.C7_PRECO*(SC7.C7_QUANT-SC7.C7_QUJE)) TOTALPC FROM " + RetSqlName("SC7")+" SC7 "
cQuery += "WHERE SC7.C7_FILIAL = '"+Alltrim(cFil)+"' AND SC7.C7_QUANT-SC7.C7_QUJE > 0 AND SC7.C7_ZPRJ = '"+Alltrim(cPrj)+"' AND SC7.C7_ZTARE = '"+Alltrim(cTar)+"' "
cQuery += "AND SC7.C7_ZDTENT >= '"+DtoS(dPerIni)+"' AND SC7.C7_ZDTENT <= '"+DtoS(dPerFim)+"' AND "
cQuery += "SC7.D_E_L_E_T_ <> '*' "

dbUseArea(.T., "TOPCONN", TCGENQRY(,, cQuery), cAliasQry, .T., .T.)

If !(cAliasQry)->(Eof()) 
	nTotal := (cAliasQry)->TOTALPC
Endif

(cAliasQry)->(dbCloseArea())

Return nTotal


Static Function ValorSC(cFil,cPrj,cTar,dPerIni,dPerFim)
Local cQuery    	:= ""
Local cAliasQry 	:= GetNextAlias()
Local nTotal		:= 0

cQuery += "SELECT  SUM(SC1.C1_VUNIT*(SC1.C1_QUANT-SC1.C1_QUJE)) TOTALSC FROM " + RetSqlName("SC1")+" SC1 "
cQuery += "WHERE SC1.C1_FILIAL = '"+Alltrim(cFil)+"' AND SC1.C1_QUANT-SC1.C1_QUJE > 0 AND SC1.C1_ZPRJ = '"+Alltrim(cPrj)+"' AND SC1.C1_ZTARE = '"+Alltrim(cTar)+"' AND SC1.C1_APROV IN ('','L') "
cQuery += "AND SC1.C1_ZDTENT >= '"+DtoS(dPerIni)+"' AND SC1.C1_ZDTENT <= '"+DtoS(dPerFim)+"' "
cQuery += "AND SC1.D_E_L_E_T_ <> '*' "

dbUseArea(.T., "TOPCONN", TCGENQRY(,, cQuery), cAliasQry, .T., .T.)

If !(cAliasQry)->(Eof()) 
	nTotal := (cAliasQry)->TOTALSC
Endif

(cAliasQry)->(dbCloseArea())

Return nTotal


Static Function ValorFI(cFil,cPrj,cTar,dPerIni,dPerFim)
Local cQuery    	:= ""
Local cAliasQry 	:= GetNextAlias()
Local nTotal		:= 0

cQuery += "SELECT SUM(E2_VALOR) TOTALFI FROM " + RetSqlName("SE2")+" SE2 "
cQuery += "WHERE NOT EXISTS (SELECT F1_DOC FROM " + RetSqlName("SF1")+" SF1 "
cQuery += "                    WHERE SE2.E2_FILIAL = SF1.F1_FILIAL AND "
cQuery += "				       SE2.E2_NUM = SF1.F1_DOC AND "
cQuery += "				       SE2.E2_PREFIXO = SF1.F1_PREFIXO AND "
cQuery += "					   SE2.E2_FORNECE = SF1.F1_FORNECE AND "
cQuery += "					   SE2.E2_LOJA = SF1.F1_LOJA AND SF1.D_E_L_E_T_ <> '*' ) "
cQuery += "AND SE2.E2_FILIAL = '"+Alltrim(cFil)+"' "
cQuery += "AND SE2.E2_ZPRJ = '"+Alltrim(cPrj)+"' AND SE2.E2_ZTARE = '"+Alltrim(cTar)+"' " 
cQuery += "AND SE2.E2_ZDTENT >= '"+DtoS(dPerIni)+"' AND SE2.E2_ZDTENT <= '"+DtoS(dPerFim)+"' "
cQuery += "AND SE2.D_E_L_E_T_ <> '*' "

dbUseArea(.T., "TOPCONN", TCGENQRY(,, cQuery), cAliasQry, .T., .T.)

If !(cAliasQry)->(Eof()) 
	nTotal := (cAliasQry)->TOTALFI
Endif

(cAliasQry)->(dbCloseArea())

Return nTotal


Static Function BuscaColigada(cEmp,cFil,lErro,cMsg)
Local cColigada 	:= ""
Local cQuery    	:= ""
Local cAliasQry 	:= GetNextAlias()

	Default lErro 		:= .f.
	Default cMsg		:= ""
	
	cQuery += "SELECT XXD_COMPA FROM " + RetSqlName("XXD")+" XXD "
	cQuery += "WHERE XXD.XXD_REFER = 'RM' AND "
	cQuery += "      XXD.XXD_EMPPRO = '"+cEmp+"' AND "
	cQuery += "      XXD.XXD_FILPRO = '"+cFil+"' "
	
	dbUseArea(.T., "TOPCONN", TCGENQRY(,, cQuery), cAliasQry, .T., .T.)
	
	If !(cAliasQry)->(Eof()) 
		cColigada := Alltrim((cAliasQry)->XXD_COMPA)
	Endif
	
	(cAliasQry)->(dbCloseArea())
	
	If Empty(Alltrim(cColigada))
		cMsg 	+= QUEBRA+"Nao encontrou coligada para a Empresa "+cEmp+" Filial "+cFil
		lErro	:= .t.
	Endif		

Return cColigada

Static Function IDPrjNoDEPARA(cCodPrj,lErro,cMsg)
Local cRet 			:= ""
Local aAux			:= ""
Local cSentenca		:= "FSTSADEPARAMPRJ"
Local cCodSistema	:= "M"
Local cParam		:= ""
Local aCabec		:= {}
Local aResult		:= {}
Local cValExt		:= ""

	Default cCodPrj := ""
	Default lErro 	:= .f.
	Default cMsg	:= ""

	cValExt			:= Alltrim(cEmpAnt)+"|"+Alltrim(cFilAnt)+"|"+Alltrim(cCodPrj)

	cParam	:= "VALOREXTERNO="+Alltrim(cValExt)

	aadd(aCabec,{"VALORRM","C"}) // Posicao 1
	
	aResult := U_CONSSQLRM(cSentenca,cCodSistema,cParam,aCabec,@lErro,@cMsg)
	
	If len(aResult) > 0
		cRet 	:= aResult[1,1] // VALORRM		
	Endif
	
	If !Empty(cCodPrj)
		If Empty(Alltrim(cRet))
			cMsg 	+= QUEBRA+"Nao foi possivel encontrar ID do Projeto "+cCodPrj+" valorexterno = "+cValExt
			lErro	:= .t.
		Else	
			aAux	:= StrToKarr( cRet, "|" )
			cRet	:= aAux[2]
		Endif	
	Endif
	
Return cRet


Static Function BuscaIDPrj(cColigada,cCodPrj,lErro,cMsg)
Local cRet := ""
Local cSentenca		:= "FSTSAPRJ"
Local cCodSistema	:= "M"
Local cParam		:= ""
Local aCabec		:= {}
Local aResult		:= {}

	Default lErro 	:= .f.
	Default cMsg	:= ""

	cParam	:= "CODCOLIGADA="+Alltrim(cColigada)+";CODPRJ="+Alltrim(cCodPrj)

	aadd(aCabec,{"IDPRJ","C"}) // Posicao 1
	aadd(aCabec,{"CODPRJ","C"}) // Posicao 2
	aadd(aCabec,{"REVISAO","C"}) // Posicao 3
	
	aResult := U_CONSSQLRM(cSentenca,cCodSistema,cParam,aCabec,@lErro,@cMsg)
	
	If len(aResult) > 0
		cRet := aResult[1,1] // IDPRJ
	Endif
	
	If Empty(Alltrim(cRet))
		cMsg 	+= QUEBRA+"Nao foi possivel encontrar ID do Projeto "+cCodPrj
		lErro	:= .t.
	Endif	

Return cRet


Static Function BuscaIDTrf(cColigada,cIDPrj,cCodTrf,lErro,cMsg)
Local cRet := ""
Local cSentenca		:= "FSTSATAREFA"
Local cCodSistema	:= "M"
Local cParam		:= ""
Local aCabec		:= {}
Local aResult		:= {}

	Default lErro 	:= .f.
	Default cMsg	:= ""
	
	cParam	:= "CODCOLIGADA="+Alltrim(cColigada)+";IDPRJ="+Alltrim(cIDPrj)+";CODTRF="+Alltrim(cCodTrf)

	aadd(aCabec,{"IDTRF","C"}) // Posicao 1
	aadd(aCabec,{"CODTRF","C"}) // Posicao 2
	
	aResult := U_CONSSQLRM(cSentenca,cCodSistema,cParam,aCabec,@lErro,@cMsg)
	
	If len(aResult) > 0
		cRet := aResult[1,1] // IDPRJ
	Endif	
	
	If Empty(Alltrim(cRet))
		cMsg 	+= QUEBRA+"Nao foi possivel encontrar ID da Tarefa "+cCodTrf
		lErro	:= .t.
	Endif		

Return cRet


Static Function BuscaPeriodo(cColigada,cIDPrj,dData,lErro,cMsg)
Local cSentenca		:= "FSTSAPERIODO"
Local cCodSistema	:= "M"
Local cParam		:= ""
Local aCabec		:= {}
Local aResult		:= {}
Local aRet			:= {}
Local cData			:= ""

	Default lErro 	:= .f.
	Default cMsg	:= ""
	
	cData	:= StrZero(Day(dData),2)+"/"+StrZero(Month(dData),2)+"/"+StrZero(Year(dData),4)
	cParam	:= "CODCOLIGADA="+Alltrim(cColigada)+";CODPRJ="+Alltrim(cIDPrj)+";DATA="+Alltrim(cData)

	aadd(aCabec,{"IDPERIODO","C"}) // Posicao 1
	aadd(aCabec,{"DTINICIO","D"}) // Posicao 2
	aadd(aCabec,{"DTFIM","D"}) // Posicao 2
	
	aResult := U_CONSSQLRM(cSentenca,cCodSistema,cParam,aCabec,@lErro,@cMsg)
	
	If len(aResult) > 0
		aadd(aRet, aResult[1,1] ) 	// IDPeriodo
		aadd(aRet, aResult[1,2] )	// DATA INCIO
		aadd(aRet, aResult[1,3] )	// DATA FIM
	Endif	
	
	If len(aRet) <= 0
		cMsg 	+= QUEBRA+"Nao foi possivel encontrar o Periodo para o Projeto "+cIDPrj+" na data "+DtoC(dData)
		lErro	:= .t.
	Endif		

Return aRet


Static Function BuscaSaldo(cColigada,cIDPrj,cIDTrf,cIDPeriodo,lErro,cMsg)
Local cSentenca		:= "FSTSACRONOGRAMA"
Local cCodSistema	:= "M"
Local cParam		:= ""
Local aCabec		:= {}
Local aResult		:= {}
Local nRet			:= 0
Local cData			:= ""

	Default lErro 	:= .f.
	Default cMsg	:= ""

	cParam	:= "CODCOLIGADA="+Alltrim(cColigada)+";IDPRJ="+Alltrim(cIDPrj)+";"
	cParam	+= "IDTRF="+Alltrim(cIDTrf)+";IDPERIODO="+Alltrim(cIDPeriodo)

	aadd(aCabec,{"VALORPLANEJADO","N"}) // Posicao 1

	aResult := U_CONSSQLRM(cSentenca,cCodSistema,cParam,aCabec,@lErro,@cMsg)
	
	If len(aResult) > 0
		nRet := aResult[1,1]  	// Saldo
	Endif	
	
	If len(aResult) <= 0
		cMsg 	+= QUEBRA+"Nao foi possivel encontrar o Saldo "
		lErro	:= .t.
	Endif		

Return nRet
