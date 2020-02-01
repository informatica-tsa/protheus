#INCLUDE "FIVEWIN.CH"
#INCLUDE "GPER340.CH"

User Function RGPE341()
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Define Variaveis Locais (Basicas)                            ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Local cString := "SRA"        // alias do arquivo principal (Base)
Local aOrd    := {"C.Custo + Matricula ","C.Custo + Nome",OemtoAnsi("C.Custo + Função"),"Nome","Matricula",OemtoAnsi("Função")}
Local cDesc1  := OemtoAnsi("Relação de adimitidos e demitidos.")
Local cDesc2  := "Ser  impresso de acordo com os parametros solicitados pelo"
Local cDesc3  := "usuario."
Local aRegs	  := {}

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Define Variaveis Private(Basicas)                            ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Private aReturn  := {"Zebrado",1,"Administração",2,2,1,"",1 }
Private NomeProg := "GPER341"
Private aLinha   := { }
Private nLastKey := 0
Private cPerg    := "GPR341"
Private limite := 60 // maximo de linhas por folha
Private nLin := 0
Private nLinInc  := 8 // controle de linhas
Private nTipo := 15 // NAO SEI O QUE FAZ, MAS SE TIRAR DA PAU
Private m_pag    := 01 // NUMERO DA PRIMEIRA PAGINA
			
Private Cabec1   := "" // Cabecario
Private Cabec2   := "" // Cabecario
Private cDiv     := " | "

Cabec1 += cDiv	
Cabec1 += PADC("Filial",Coluna("SRA","RA_FILIAL"),Space(1)) 

Cabec1 += cDiv	
Cabec1 += PADC("Matricula",Coluna("SRA","RA_MAT"),Space(1))

Cabec1 += cDiv	
Cabec1 += PADC("Nome",Coluna("SRA","RA_NOME"),Space(1))

Cabec1 += cDiv	
Cabec1 += PADC("Centro Custo",Coluna("SRA","RA_CC"),Space(1))

Cabec1 += cDiv	
Cabec1 += PADC("Funcao",Coluna("SRA","RA_CODFUNC"),Space(1))

Cabec1 += cDiv	
Cabec1 += PADC("Admissao",Coluna("SRA","RA_ADMISSA"),Space(1))

Cabec1 += cDiv	
Cabec1 += PADC("Demissao",Coluna("SRA","RA_DEMISSA"),Space(1))
	
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Variaveis Utilizadas na funcao IMPR                          ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Private Titulo   := "Relação de adimitidos e demitidos."
Private nTamanho := "M"
/*
ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
³           Grupo  Ordem Pergunta Portugues     Pergunta Espanhol             Pergunta Ingles         Variavel 	Tipo  Tamanho Decimal Presel  GSC   Valid                              Var01     	 Def01      DefSPA1      DefEng1      Cnt01          					  Var02  Def02    	    DefSpa2          DefEng2	Cnt02  Var03 		Def03      DefSpa3    DefEng3  		Cnt03  Var04  Def04     DefSpa4    DefEng4  Cnt04 		 Var05  Def05       DefSpa5	 DefEng5   Cnt05  	XF3  GrgSxg   cPyme   aHelpPor  aHelpEng	 aHelpSpa    cHelp  ³
ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ*/
/*Aadd(aRegs,{cPerg,"01","Filial De ?         ",""                             ,""                    ,    "mv_ch1","C" ,02    ,0		,1	 ,"C"   ,"naovazio"							,"mv_par01"	,""          ,""          ,""        ,""		                        ,""		,""             ,""              ,""          ,""	,"" 		,""			,""			,""			,"" 	,"" 	,""			,""		,""		  ,""		,""		,""			,""		,""			,""		,""		,""		,""		,{}	        ,{}			,{}		,""})
Aadd(aRegs,{cPerg,"02","Filial Ate ?        ",""                             ,""                    ,    "mv_ch2","C" ,02    ,0		,0	 ,"C"   ,"naovazio"						    ,"mv_par02"	,""          ,""          ,""        ,""		                        ,""		,""             ,""              ,""          ,""	,"" 		,""			,""			,""			,"" 	,"" 	,""			,""		,""		  ,""		,""		,""			,""		,""			,""		,""		,""		,""		,{}	        ,{}			,{}		,""})
Aadd(aRegs,{cPerg,"03","Centro de Custo De ?",""                             ,""                    ,    "mv_ch3","C" ,09    ,0		,0	 ,"C" 	,"NaoVazio"							,"mv_par03"	,""          ,""          ,""        ,""								,""		,""             ,""              ,""          ,""	,""			,""			,""			,""			,""		,""		,""			,""		,""		  ,"" 		,""		,""			,""		,""			,""		,""		,""		,""		,{}			,{}			,{}		,""}) 
Aadd(aRegs,{cPerg,"04","Centro de Custo Ate?",""                             ,""                    ,    "mv_ch4","C" ,09    ,0		,1	 ,"C"   ,"naovazio"							,"mv_par04"	,""          ,""          ,""        ,""		                        ,""		,""             ,""              ,""          ,""	,"" 		,""			,""			,""			,"" 	,"" 	,""			,""		,""		  ,""		,""		,""			,""		,""			,""		,""		,""		,""		,{}	        ,{}			,{}		,""})
Aadd(aRegs,{cPerg,"05","Matricula De ?      ",""                             ,""                    ,    "mv_ch5","C" ,06    ,0		,0	 ,"C"   ,"naovazio"						    ,"mv_par05"	,""          ,""          ,""        ,""		                        ,""		,""             ,""              ,""          ,""	,"" 		,""			,""			,""			,"" 	,"" 	,""			,""		,""		  ,""		,""		,""			,""		,""			,""		,""		,""		,""		,{}	        ,{}			,{}		,""})
Aadd(aRegs,{cPerg,"06","Matricula Ate ?     ",""                             ,""                    ,    "mv_ch6","C" ,06    ,0		,0	 ,"C" 	,"NaoVazio"							,"mv_par06"	,""          ,""          ,""        ,""								,""		,""             ,""              ,""          ,""	,""			,""			,""			,""			,""		,""		,""			,""		,""		  ,"" 		,""		,""			,""		,""			,""		,""		,""		,""		,{}			,{}			,{}		,""})
Aadd(aRegs,{cPerg,"07","Nome De ?           ",""                             ,""                    ,    "mv_ch7","C" ,30    ,0		,1	 ,"C"   ,"naovazio"							,"mv_par07"	,""          ,""          ,""        ,""		                        ,""		,""             ,""              ,""          ,""	,"" 		,""			,""			,""			,"" 	,"" 	,""			,""		,""		  ,""		,""		,""			,""		,""			,""		,""		,""		,""		,{}	        ,{}			,{}		,""})
Aadd(aRegs,{cPerg,"08","Nome Ate ?          ",""                             ,""                    ,    "mv_ch8","C" ,30    ,0		,0	 ,"C"   ,"naovazio"						    ,"mv_par08"	,""          ,""          ,""        ,""		                        ,""		,""             ,""              ,""          ,""	,"" 		,""			,""			,""			,"" 	,"" 	,""			,""		,""		  ,""		,""		,""			,""		,""			,""		,""		,""		,""		,{}	        ,{}			,{}		,""})
Aadd(aRegs,{cPerg,"09","Funcao De ?         ",""                             ,""                    ,    "mv_ch9","C" ,05    ,0		,0	 ,"C" 	,"NaoVazio"							,"mv_par09"	,""          ,""          ,""        ,""								,""		,""             ,""              ,""          ,""	,""			,""			,""			,""			,""		,""		,""			,""		,""		  ,"" 		,""		,""			,""		,""			,""		,""		,""		,""		,{}			,{}			,{}		,""})
Aadd(aRegs,{cPerg,"10","Funcao Ate ?        ",""                             ,""                    ,    "mv_cha","C" ,05    ,0		,1	 ,"C"   ,"naovazio"							,"mv_par10"	,""          ,""          ,""        ,""		                        ,""		,""             ,""              ,""          ,""	,"" 		,""			,""			,""			,"" 	,"" 	,""			,""		,""		  ,""		,""		,""			,""		,""			,""		,""		,""		,""		,{}	        ,{}			,{}		,""})
Aadd(aRegs,{cPerg,"11","Periodo de ?        ",""                             ,""                    ,    "mv_chb","C" ,01    ,0		,0	 ,"C"   ,"naovazio"						    ,"mv_par11"	,""          ,""          ,""        ,""		                        ,""		,""             ,""              ,""          ,""	,"" 		,""			,""			,""			,"" 	,"" 	,""			,""		,""		  ,""		,""		,""			,""		,""			,""		,""		,""		,""		,{}	        ,{}			,{}		,""})
Aadd(aRegs,{cPerg,"12","Periodo ate ?       ",""                             ,""                    ,    "mv_chc","C" ,01    ,0		,0	 ,"C" 	,"NaoVazio"							,"mv_par12"	,""          ,""          ,""        ,""								,""		,""             ,""              ,""          ,""	,""			,""			,""			,""			,""		,""		,""			,""		,""		  ,"" 		,""		,""			,""		,""			,""		,""		,""		,""		,{}			,{}			,{}		,""})*/ 

Aadd(aRegs,{cPerg,"01","Adimitido de ?        ",""                             ,""                    ,    "mv_ch1","D" ,08    ,0		,0	 ,"G"   ,""     						    ,"mv_par01"	,""          ,""          ,""        ,""		                        ,""		,""             ,""              ,""          ,""	,"" 		,""			,""			,""			,"" 	,"" 	,""			,""		,""		  ,""		,""		,""			,""		,""			,""		,""		,""		,""		,{}	        ,{}			,{}		,""})
Aadd(aRegs,{cPerg,"02","Adimitido ate ?       ",""                             ,""                    ,    "mv_ch2","D" ,08    ,0		,0	 ,"G" 	,""     							,"mv_par02"	,""          ,""          ,""        ,""								,""		,""             ,""              ,""          ,""	,""			,""			,""			,""			,""		,""		,""			,""		,""		  ,"" 		,""		,""			,""		,""			,""		,""		,""		,""		,{}			,{}			,{}		,""}) 
Aadd(aRegs,{cPerg,"03","Demitido de ?        ",""                             ,""                    ,    "mv_ch3","D" ,08    ,0		,0	 ,"G"   ,""     						    ,"mv_par03"	,""          ,""          ,""        ,""		                        ,""		,""             ,""              ,""          ,""	,"" 		,""			,""			,""			,"" 	,"" 	,""			,""		,""		  ,""		,""		,""			,""		,""			,""		,""		,""		,""		,{}	        ,{}			,{}		,""})
Aadd(aRegs,{cPerg,"04","Demitido ate ?       ",""                             ,""                    ,    "mv_ch4","D" ,08    ,0		,0	 ,"G" 	,""     							,"mv_par04"	,""          ,""          ,""        ,""								,""		,""             ,""              ,""          ,""	,""			,""			,""			,""			,""		,""		,""			,""		,""		  ,"" 		,""		,""			,""		,""			,""		,""		,""		,""		,{}			,{}			,{}		,""})
ValidPerg(aRegs,cPerg,.F.)

if !Pergunte(cPerg,.T.)  
	Return
Endif

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Envia controle para a funcao SETPRINT                        ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
wnrel:="GPER341"            //Nome Default do relatorio em Disco
wnrel:=SetPrint('',wnrel,cPerg,Titulo,cDesc1,cDesc2,cDesc3,.F.,aOrd,,nTamanho)

If nLastKey = 27
	Return
EndIf

SetDefault(aReturn,'')

If nLastKey = 27
	Return
EndIf

RptStatus({|lEnd| GP340Imp(@lEnd,wnRel,'')},Titulo)

Return

/*
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ GP340IMP ³ Autor ³ R.H.                  ³ Data ³ 15.04.96 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ ImpressÆo da Relacao de Cargos e Salarios                  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ GP340IMP(lEnd,WnRel,cString)                               ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Generico                                                   ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
Static Function GP340IMP(lEnd,WnRel,cString)
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Define Variaveis Locais (Programa)                           ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Local aStruSRA                                          
Local cArqNtx   := cIndCond := ""
Local cAliasSRA := GetNextAlias() 	//Alias da Query

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Carregando variaveis mv_par?? para Variaveis do Sistema.	 ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Local nOrdem	    := aReturn[8]
Local cPerDe	    := mv_par01
Local cPerAte	    := mv_par02
Local cDesDe	    := mv_par03
Local cDesAte	    := mv_par04
Local cOrder        := "RA_CC,RA_FILIAL,RA_MAT"
Local nX := 0

//apmsgalert(cPerDe) 
//apmsgalert(valtype(cPerDe))
//apmsgalert(cPerAte) 
//apmsgalert(valtype(cPerAte)) 

//apmsgalert(mv_par01) 
//apmsgalert(valtype(mv_par01))
//apmsgalert(mv_par02) 
//apmsgalert(valtype(mv_par02))

//Titulo := STR0012			//"RELACAO DE CARGOS E SALARIOS "
If nOrdem==1
	Titulo += "C.Custo + Matricula "
	cOrder := "RA_CC,RA_FILIAL,RA_MAT"
ElseIf nOrdem==2
	Titulo += "C.Custo + Nome"
	cOrder := "RA_CC,RA_NOME"
ElseIf nOrdem==3 
	Titulo += OemtoAnsi("C.Custo + Função")
	cOrder := "RA_CC,RA_CODFUNC"
ElseIf nOrdem == 4		
	Titulo += "Nome"
	cOrder := "RA_NOME"
ElseIf nOrdem == 5		
	Titulo += "Matricula"
	cOrder := "RA_MAT"
ElseIf nOrdem == 6		
	Titulo += OemtoAnsi("Função")
	cOrder := "RA_CODFUNC,RA_MAT"
EndIf		

cQueWh := ""
cQuery := " SELECT * FROM " + RetSqlName("SRA")
cQuery += " WHERE D_E_L_E_T_ <> '*' "
if !empty(cPerDe)
	cQueWh += iif(empty(cQueWh),""," AND ")
	cQueWh += " RA_ADMISSA >= '" + dtos(cPerDe) + "'"
endif	
if !empty(cPerAte)
	cQueWh += iif(empty(cQueWh),""," AND ")
	cQueWh += " RA_ADMISSA <= '" + dtos(cPerAte) + "' "	
endif
if !empty(cDesDe)
	cQueWh += iif(empty(cQueWh),""," AND ")
	cQueWh += " RA_ADMISSA >= '" + dtos(cDesDe) + "'"
endif	
if !empty(cDesAte)
	cQueWh += iif(empty(cQueWh),""," AND ")
	cQueWh += " RA_ADMISSA <= '" + dtos(cDesAte) + "' "	
endif
cQuery += iif(empty(cQueWh),""," and "+cQueWh+"") 
cQuery += " ORDER BY "+cOrder

//u_impt2(cQuery)

cQuery := ChangeQuery(cQuery)	
aStruSRA := SRA->(dbStruct())

dbUseArea(.T., "TOPCONN", TCGenQry(,,cQuery), cAliasSRA, .F., .T.)

For nX := 1 To Len(aStruSRA)
	If ( aStruSRA[nX][2] <> "C" )
		TcSetField(cAliasSRA,aStruSRA[nX][1],aStruSRA[nX][2],aStruSRA[nX][3],aStruSRA[nX][4])
	EndIf
Next nX

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Carrega Regua Processamento											  ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
SetRegua(0)

Cabecario()

While !(cAliasSRA)->(Eof())

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Movimenta Regua Processamento										  ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	IncRegua()

	If lEnd
		@Prow()+1,0 PSAY cCancel
		Exit
	EndIf
	
		fLinha()
		@ nLin,00000000 PSAY cDiv
		@ nLin,pcol() PSAY (cAliasSRA)->RA_FILIAL
		@ nLin,pcol() PSAY cDiv
		@ nLin,pcol() PSAY (cAliasSRA)->RA_MAT
		@ nLin,pcol() PSAY cDiv
		@ nLin,pcol() PSAY (cAliasSRA)->RA_NOME
		@ nLin,pcol() PSAY cDiv
		@ nLin,pcol() PSAY (cAliasSRA)->RA_CC
		@ nLin,pcol() PSAY cDiv
		@ nLin,pcol() PSAY (cAliasSRA)->RA_CODFUNC
		@ nLin,pcol() PSAY cDiv
		@ nLin,pcol() PSAY (cAliasSRA)->RA_ADMISSA
		@ nLin,pcol() PSAY cDiv
		@ nLin,pcol() PSAY (cAliasSRA)->RA_DEMISSA
		
	(cAliasSRA)->(dbSkip())
EndDo


dbSelectArea(cAliasSRA)
(cAliasSRA)->(dbCloseArea())


//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Termino do relatorio													  ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

If aReturn[5] = 1
	Set Printer To
	Commit
	ourspool(wnrel)
Endif

Return 

Static Function Cabecario()

	Cabec(titulo,Cabec1,Cabec2,NomeProg,nTamanho,nTipo)
	nLin := nLinInc
					
Return

Static Function fLinha(nMais)

	Default nMais := 0

	if nLin+nMais > limite
		Cabecario()
		nLin += 1
	else
		nLin += 1
	endif

Return

Static Function Coluna(cPref,cCampo)

	Local nRet := 0

	aInfCpo := TamSx3(cCampo)
	
	if aInfCpo[3] == "D"
		nRet := 8
	elseif aInfCpo[3] == "N"
		nRet := len(TRANSFORM(1,PesqPict(cPref,cCampo)))
	else
		nRet := aInfCpo[1]
	endif
	
Return(nRet)
