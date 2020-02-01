#INCLUDE "RWMAKE.CH"
#INCLUDE "TOPCONN.CH"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³DEFAULTX  ºAdaptacao³Carlos Testa        º Data ³  09/09/03   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Ferramenta para eliminacao de NULOS em banco de Dados        º±±
±±º          ³ Homologados para Protheus.                                   º±±
±±º          ³ Este programa foi adaptado para trabalhar via RDMAKE.        º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP 5.07, 5.08, 6.09 e 7.10                                   º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function DefaultX()
Local _oDlg,_lFimProc := .F.
Local _cMens01	:= OemToAnsi("Antes de Executar esta Rotina, efetue uma CÓPIA DE SEGURANÇA DO BANCO DE DADOS")
Local _cMens02	:= OemToAnsi("Deseja continuar com o Processo ?")
Local _cTitOdlg	:= OemToAnsi("DefaultX - Limpeza de NULOS em Banco de Dados")

Private cEmpAnt,cTabela := space(3)
Private cBanco			:= Space(10)
Private cServer			:= Space(20)
Private cDataBase		:= Space(20)
Private cDetab 			:= Space(3)  
PRIVATE cAteTab 		:= "ZZZ"
Private cDeEmp			:= "01"  
PRIVATE	cAteEmp			:= "99"
Private lChkMens		:= .T.
Private aOpcMens		:= {"Visualizar em Tela","Gerar Log em disco"}
Private nOpcMens		:= 1
PRIVATE  ncont, ntotreg

SET(11,.T.)	// Habilita os deletados das tabelas

If MsgYesNo(_cMens01,_cMens02)
	
	@ 0,0 TO 200,400 DIALOG _oDlg TITLE _cTitOdlg
	@ 05,05 Say "Banco de Dados:"
	@ 05,50 Get cBanco
	@ 15,05 Say "Alias:"
	@ 15,50 Get cDataBase
	@ 25,05 Say "I.P. do Servidor:"
	@ 25,50 Get cServer
	@ 35,05 Say "Tabela De:"
	@ 35,50 Get cDeTab    Picture "@!"
	@ 45,05 Say "Tabela Ate:"
	@ 45,50 Get cAteTab Picture "@!"
	@ 55,05 Say "Empresa De:"
	@ 55,50 Get cDeEmp Picture "99"
	@ 65,05 Say "Empresa Ate:"
	@ 65,50 Get cAteEmp Picture "99"
	@ 75,05 CHECKBOX "Habilita Mensagens de Aviso sobre ajustes nas tabelas." VAR lChkMens OBJECT oChkMens 
	oChkMens:BChange:={||ShowRadio(lChkMens,oOpcMens)}
	@ 85,15 RADIO aOpcMens VAR nOpcMens object oOpcMens
	@ 20,168 BMPBUTTON TYPE 1 ACTION _lFimProc := Defa01()
	@ 40,168 BMPBUTTON TYPE 2 ACTION Close(_oDlg)
	ACTIVATE DIALOG _oDlg CENTERED
	
EndIf
Return Nil

// Executa a malha de processamento para analise dos dados
Static Function Defa01()
Local _cIndEmp
Private _oObjRegua2,_lRetRegua2 := .F.

Connect(nil,cBanco,cDataBase,cServer)

Alert("Certifique-se que não existe ninguem trabalhando no PROTHEUS")

dbSelectArea("SM0")
dbseek(cDeEmp,.t.)

_oObjRegua2:= MsNewProcess():New({|_lRetRegua2| RodaEmp()},"","",.F.)
_oObjRegua2:Activate()

Return Nil

Static Function RodaEmp()
Local _nValInit := 0
Local cEmpAnt	:= "@@"
Local _lTemRegs	:= .T.
Local aAreaSX5	:= {},cIndSX5, cOrdSX5
While SM0->(!Eof()) .and. SM0->M0_CODIGO <= cAteEmp
	IF SM0->M0_CODIGO == cEmpAnt
		SM0->( dbSkip() )
		LOOP
	Endif
	cEmpAnt		:= SM0->M0_CODIGO

	dbSelectArea("SX2")
	dbClearFilter()
	IndRegua("SX2","SX2TRB","X2_CHAVE",,,"REINDEXANDO SX2010 ...")
	If Empty(cDeTab)
		dbGoTop()
	Else
		dbSeek(cDeTab)
	EndIf
	
	If Empty(cDeTab) .AND. cAteTab == "ZZZ"
		_nValInit := SX2->(RecCount())
	Else
		// Contagem das tabelas para inicializacao da Primeira linha da Regua.
	    While SX2->X2_CHAVE <= cAteTab
	    	_nValInit++
	    	dbSkip()
	    EndDo
	    dbSeek(cDeTab)
	EndIf
	
	_oObjRegua2:SetRegua1(_nValInit)
	
	While SX2->(!Eof()) .and. SX2->X2_CHAVE <= cAteTab
	
		_oObjRegua2:IncRegua1("Analisando Tabela "+SX2->X2_ARQUIVO+" | Empresa:"+SM0->M0_FILIAL)

 		RebuildFile(SX2->X2_ARQUIVO,cBanco) //ORIGINAL
		
		dbSelectArea("SX2")
		dbSkip()
		
	EndDo
	
	SM0->( dbSkip() )
EndDo
// Reabre a tabela SX5 com o Padrao do Sistema
SX2->( dbSeek("SX5") )
ChkFile(AllTrim(SX2->X2_ARQUIVO),.F.,"SX5")

TCQUIT()
Alert("Processo concluido. ; Reinicialize o Servico do TopConnect e do Protheus")
Return(.T.)

Static Function RebuildFile(cArquivo,cBanco)
Local ni,cQuery,_aRetNulos,_lTemRegs
Local _lTemNulos := .F.
Local aStru := {}

// Usa recurso de Rename no Banco
lRename  := Iif(UPPER(AllTrim(cBanco)) $ "MSSQL/ORACLE/INFORMIX",.T.,.F.)

cArquivo := Upper(Alltrim(cArquivo))
IF "."$cArquivo
	cArquivo := Subs(cArquivo,1,AT(".",cArquivo)-1)
Endif

//Verifica se a tabela existe e pode ser aberta
IF !TCCanOpen(cArquivo)
	// GeraLog Opcao 2 e para Controle de Alerta Critico
	If lChkMens .and. nOpcMens == 2
		GeraLog("TRBXTRB_NOT",2,procname(),OemToAnsi("Não foi encontrada no banco, a tabela "+cArquivo+"."))
	EndIf
	Return Nil
Endif

// Verifica se existem registros na tabela antes de serem analisados
cQuery		:= 'SELECT COUNT(*) TOTREG FROM ' + cArquivo
dbUseArea(.T., "TOPCONN", TCGenQry(,,cQuery), 'CONT', .F., .T.)
_lTemRegs	:= Iif(CONT->TOTREG > 0,.T.,.F.)
dbCloseArea()
	
If !_lTemRegs	//log aqui ...
	Return Nil
EndIf
	
// Abre a Tabela para coletar a Estrutura Real
dbUseArea(.T.,"TOPCONN",cArquivo,"TRBXTRB",.T.,.F.)
dbSelectArea("TRBXTRB")
aStru		:= dbStruct()
dbCloseArea()

// utiliza a regua2 para incremento das informacoes
_oObjRegua2:SetRegua2(Len(aStru))
If !_lRetRegua2 .and. _lTemRegs
	_oObjRegua2:IncRegua2("Verificando existencia de NULOS Tabela "+SX2->X2_ARQUIVO)
	
	// Verifica se Existem nulos na Tabela
	_aRetNulos := TemNulos(aStru)
	
	// Caso EXISTA Campos com NULL e a estrutura NAO CONTENHA campo(s) do Tipo MEMO, efetua o acerto AUTOMATICO
	If _aRetNulos[1]
		ReConstr(RetSQLName(SX2->X2_ARQUIVO),aStru,_aRetNulos[2])	// Chama a Rotina de Acerto dos Nulos
	EndIf
	
EndIf
Return Nil

Static Function ReConstr(cArquivo,aStruRec,_aEstrNul)

Local lRename := .T.
Local ni := 0

If TCCanOpen("TRBXTRB")
    cQuery := 'SELECT COUNT(*) TOTREG FROM TRBXTRB'
    dbUseArea(.T., "TOPCONN", TCGenQry(,,cQuery), 'CONT', .F., .T.)
    If CONT->TOTREG > 0
        Alert("Existem dados na Tabela Temporaria <<TRBXTRB>>, verifique se os dados foram devolvidos a tabela de Origem. ;  Caso os dados possam ser descartados, DROPE a tabela e recomece o Procedimento.")
        // GeraLog Opcao 2 e para Controle de Alerta Critico
        If lChkMens .and. nOpcMens == 2
	    	GeraLog("TRBXTRB_FULL",2,procname(),OemToAnsi("TRBXTRB com conteúdo da tabela "+cArquivo+". Processo Interrompido."))
		EndIf
        TCQUIT()
        Return
    Else
		If lChkMens
    		If nOpcMens == 1
				Alert("NAO EXISTEM DADOS na Tabela Temporaria <<TRBXTRB>>, ela sera DROPPADA")
		    Else
		    	//GeraLog Opcao 1 sao as mensagens de CRITICA do Defaultx
				GeraLog("TRBXTRB_EMPTY",1,procname(),OemToAnsi("TRBXTRB SEM DADOS. Tabela Droppada, processo normal"))
		    EndIf
		EndIf
        TCDELFILE("TRBXTRB")
    EndIf
    CONT->( dbCloseArea() )
Endif

If AllTrim(UPPER(cBanco)) == "MSSQL"
    cQuery := "sp_rename "+UPPER(cArquivo)+", TRBXTRB"
    TCSQLEXEC(cQuery)
    cQuery := "drop index "+cArquivo+"."+cArquivo+"_RECNO"
    TCSQLEXEC(cQuery)
ElseIf AllTrim(UPPER(cBanco)) == "ORACLE"
    cQuery := "rename "+cArquivo+" to TRBXTRB"
    TCSQLEXEC(cQuery)
    cQuery := "drop index "+cArquivo+"_RECNO"
    TCSQLEXEC(cQuery)
ElseIf AllTrim(UPPER(cBanco)) == "INFORMIX"
    cQuery := "rename table "+cArquivo+" to TRBXTRB"
    TCSQLEXEC(cQuery)
    cQuery := "drop index "+cArquivo+"_RECNO"
    TCSQLEXEC(cQuery)
Else
	// Qdo nao for usado o comando Rename, verifica se a qtdade de registros foi copiada integralmente
	lRename	:= .F.
    dbCreate("TRBXTRB",aStruRec,"TOPCONN")
    // Para os outros bancos, eh necessario comparar os numero de registros.
    cQuery := 'SELECT MIN(R_E_C_N_O_) MINRECNO, MAX(R_E_C_N_O_) MAXRECNO, COUNT(*) TOTREG FROM ' + cArquivo
    dbUseArea(.T., "TOPCONN", TCGenQry(,,cQuery), 'CONT', .F., .T.)

    nCont   := CONT->MINRECNO
    nTotreg := CONT->TOTREG
	_oObjRegua2:SetRegua2(nTotReg)
	While nCont <= CONT->MAXRECNO
        _oObjRegua2:IncRegua2("Preparando TRB apartir da Tabela "+SX2->X2_ARQUIVO+". Regua de Processamento 1/2")
        cQuery := "INSERT INTO TRBXTRB SELECT * FROM "+cArquivo
        cQuery := cQuery + " WHERE R_E_C_N_O_ between "+AllTrim(Str(nCont))+" AND "+AllTrim(Str(nCont+1024))
        TCSQLEXEC(cQuery)
        nCont := nCont + 1025
		// GeraLog Opcao 2 e para Controle de Alerta Critico
		If lChkMens .and. nOpcMens == 2
			GeraLog(cArquivo,2,procname(),OemToAnsi("Transferindo do reg. "+AllTRim(Str(nCont-1025))+" ate reg. "+AllTRim(Str(nCont)+". Não foi usada a opção de rename da tabela original")))
		EndIf
    Enddo
    CONT->( dbCloseArea() )
EndIf

cQuery := 'SELECT MIN(R_E_C_N_O_) MINRECNO, MAX(R_E_C_N_O_) MAXRECNO, COUNT(*) TOTREG FROM TRBXTRB'
dbUseArea(.T., "TOPCONN", TCGenQry(,,cQuery), 'CONT', .F., .T.)

If !lRename
    // Verifica se o Total de registros foi incluso na TRBXTRB
    If nTotReg == CONT->TOTREG
        TCDELFILE(cArquivo)
        dbCreate(cArquivo,aStruRec,"TOPCONN")
        // Controle de Log
		If lChkMens .and. nOpcMens == 2
			GeraLog(cArquivo,2,procname(),OemToAnsi("Registros transferidos sem problemas para tabela TRXTRB."))
		EndIf
    Else
		If lChkMens
    		If nOpcMens == 1
		        Alert("Ocorreu falha na inclusao dos dados na tabela temporaria, o processo sera abortado sem causar problemas")
		    Else
		    	//GeraLog Opcao 1 sao as mensagens de CRITICA do Defaultx
				GeraLog("TRBXTRB_FAIL",1,procname(),OemToAnsi("Não foi possível transferir dados para Tabela TRBXTRB. Tabela Será DROPPADA sem problemas."))
		    EndIf
		EndIf
        TCQUIT()
        return
    Endif
Else
    // Inicializa o Total de Registros para a Verificacao do INSERT
    nTotReg := CONT->TOTREG
    dbCreate(cArquivo,aStruRec,"TOPCONN")
    // Controle de Log
	If lChkMens .and. nOpcMens == 2
		GeraLog(cArquivo,2,procname(),OemToAnsi("Inicializando o número de registros para tratamento"))
	EndIf
EndIf

nCont := CONT->MINRECNO
_oObjRegua2:SetRegua2(nTotReg)

Do While nCont <= CONT->MAXRECNO

    For ni := 1 to Len(_aEstrNul)
        _oObjRegua2:IncRegua2("Verificando/Ajustando nulos do campo "+_aEstrNul[ni,1])
        If _aEstrNul[ni,2] != "M"
            cQuery := "UPDATE TRBXTRB SET "+_aEstrNul[ni,1]+" = "
            IF _aEstrNul[ni,2] == "N"
                cQuery += "0"
            Else
                cQuery += "'"+Space(_aEstrNul[ni,3])+"'"
            Endif
            cQuery += " WHERE "+_aEstrNul[ni,1]+" IS NULL"
            cQuery += " AND R_E_C_N_O_ BETWEEN "+AllTrim(Str(nCont))+" AND "+AllTrim(Str(nCont+1024))
            TCSQLEXEC(cQuery)
        EndIf
    Next
	// GeraLog Opcao 2 e para Controle de Alerta Critico
	If lChkMens .and. nOpcMens == 2
		GeraLog("TRBXTRB_ELIMINATE",2,procname(),OemToAnsi("Eliminando NULLS da tabela TRBXTRB do reg "+AllTrim(Str(nCont))+" ate reg "+AllTrim(Str(nCont+1024))))
	EndIf

    // Insere na Nova Tabela, os registros ja SEM OS NULOS
    cQuery := "INSERT INTO "+cArquivo+" SELECT * FROM TRBXTRB"
    cQuery += " WHERE R_E_C_N_O_ BETWEEN "+Str(nCont)+" AND "+Str(nCont+1024)
    TCSQLEXEC(cQuery)
	// GeraLog Opcao 2 e para Controle de Alerta Critico
	If lChkMens .and. nOpcMens == 2
		GeraLog("TRBXTRB_RECOVERY",2,procname(),OemToAnsi("Reg "+AllTrim(Str(nCont))+" ate reg "+AllTrim(Str(nCont+1024)+" devolvidos à tabela original "+cArquivo)))
	EndIf
    nCont := nCont + 1025
Enddo
CONT->( dbCloseArea() )

cQuery := "SELECT COUNT(*) TOTREG FROM "+cArquivo
dbUseArea(.T., "TOPCONN", TCGenQry(,,cQuery), 'CONT', .F., .T.)

If nTotReg == CONT->TOTREG
	CONT->( dbCloseArea() )
	// Controle de Log
	If lChkMens .and. nOpcMens == 2
		GeraLog(cArquivo,2,procname(),OemToAnsi("Registros transferidos sem problemas para tabela "+cArquivo))
	EndIf
	TCDELFILE("TRBXTRB")
Else
	CONT->( dbCloseArea() )
	If lChkMens
    	If nOpcMens == 1
			Alert("Ocorreu falha na inclusao dos dados na tabela "+cArquivo+". Ajuste de acordo dados da TRBXTRB.")
		 Else
		 	// GeraLog Opcao 1 sao as mensagens de CRITICA do Defaultx
			GeraLog("TRBXTRB_FAIL",1,procname(),OemToAnsi("Ocorreu falha na transferência dos dados da tabela TRBXTRB para a tabela original "+cArquivo+"."))
		 EndIf
	EndIf
	TCQUIT()
	Return Nil
Endif

TCQUIT()
Return Nil

Static Function CONNECT(cType,cBanco,cDataBase,cServer)
cBanco		:= Upper(Alltrim(cBanco))
cDataBase	:= Alltrim(cDataBase)
cServer		:= Upper(Alltrim(cServer))

TCCONTYPE("TCPIP")	// Estabelece comunicacao com o Top em Padrão TCPIP
nConecta := TCLINK(cBanco+"/"+cDataBase,cServer)
If nConecta < 0
   Alert("Falha na Conexao TOPCONN")
   Quit
Endif

Return

Static Function TemNulos(aStru)
Local _lRetNul  := .F.,_aRetFunc,_aCposNul := {}
Local _aStruNul	:= aClone(aStru)
Local ni := 0

AADD(_aStruNul,{"D_E_L_E_T_","C",1,0})	// agrega o campo D_E_L_E_T_ verificacao de existencia de NULOS
_oObjRegua2:SetRegua2(Len(_aStruNul))

For ni := 1 to Len(_aStruNul)
   	_oObjRegua2:IncRegua2("Analisando NULOS no Campo "+_aStruNul[ni,1])
    If _aStruNul[ni,2] != "M"
    	cQuery := "Select count(*) NULOS from "+SX2->X2_ARQUIVO
    	cQuery += " WHERE "+_aStruNul[ni,1]+" IS NULL "
    	dbUseArea(.T., "TOPCONN", TCGenQry(,,cQuery), 'TRBNUL', .F., .T.)
    	dbSelectArea('TRBNUL')
    	If TRBNUL->NULOS > 0
        	_lRetNul := .T.
        	AADD(_aCposNul,_aStruNul[ni])
   	        // GeraLog Opcao 2 e para Controle de Alerta Critico
	        If lChkMens .and. nOpcMens == 2
		    	GeraLog(_aStruNul[ni][1],2,procname(),OemToAnsi("Campo com conteúdo NULL, deverá ser acertado pela rotina."))
			EndIf
		EndIf
		TRBNUL->( dbCloseArea() )
    Else
		If lChkMens
    		If nOpcMens == 1
				Alert(OemToAnsi('Para o campo MEMO "'+_aStruNul[ni,1]+'", não será efetuado o Tratamento do NULL´s'))
		    Else
		    	//GeraLog Opcao 1 sao as mensagens de CRITICA do Defaultx
				GeraLog(_aStruNul[ni,1],1,procname(),OemToAnsi("Campo MEMO, não será efetuado tratamento."))
		    EndIf
		EndIf
    EndIf
Next
_aRetFunc := {_lRetNul,_aCposNul}
Return(_aRetFunc)

// Funcao de Exibicao do Objeto Radio da Tela Principal
Static Function ShowRadio(_lMens,_oOpcMens)
If _lMens
	_oOpcMens:SHOW()
Else
	_oOpcMens:HIDE()
EndIf
Return .T.

// Controle de LOG da Rotina
Static Function GeraLog(_cOrigem,_nOpcLog,_cFuncao,_cCritica)
Local _cNmDefLog	:= "DEFLOG"
Local _aEstrDefLog	:= {}

If !File(_cNmDefLog+".DBF")
	AADD(_aEstrDefLog,{"DATALOG","D",8,0})
	AADD(_aEstrDefLog,{"HORALOG","C",15,0})
	AADD(_aEstrDefLog,{"ORIGEM","C",30,0})
	AADD(_aEstrDefLog,{"OPC_LOG","N",1,0})
	AADD(_aEstrDefLog,{"FUNCAO","C",15,0})
	AADD(_aEstrDefLog,{"CRITICA","C",255,0})
	dbcreate(_cNmDefLog,_aEstrDefLog)
	dbUseArea(.T.,"DBFCDX",_cNmDefLog,"LOG", .T., .F.)
	IndRegua("LOG",_cNmDefLog,"DTOS(DATALOG)+HORALOG",,,"Indexando LOG ...")
EndIf	

If SELECT("LOG") <= 0
	dbUseArea(.T.,"DBFCDX",_cNmDefLog,"LOG", .T., .F.)
	IndRegua("LOG",_cNmDefLog,"DTOS(DATALOG)+HORALOG",,,"Indexando LOG ...")
EndIf

// inclusao de dados
RecLock("LOG",.T.)
LOG->DATALOG	:= Date()
LOG->HORALOG	:= TIME()
LOG->ORIGEM		:= _cOrigem
LOG->OPC_LOG	:= _nOpcLog
LOG->FUNCAO		:= _cFuncao
LOG->CRITICA	:= _cCritica
LOG->( MsUnLock() )

Return Nil