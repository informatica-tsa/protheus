/*
+-------------+---------+-------------+-------------------+-------+----------------------+
| Programa    | GERESTI  | Programador | Wladimir         | Data  | 11/04/06             |
+-------------+---------+-------------+-------------------+-------+----------------------+
| Descricao   | Processa a Rotinas do estimado de Forma Individual                       |
+-------------+--------------------------------------------------------------------------+
| Uso         | Especifico para EPC                                                      |
+-------------+--------------------------------------------------------------------------+
|                          Modificacoes efetuadas no Programa                            |
+---------+-------------+----------------------------------------------------------------+
| Data    | Responsavel | Motivo                                                         |
+---------+-------------+----------------------------------------------------------------+
|         |             |                                                                |
+---------+-------------+----------------------------------------------------------------+
*/

#include "rwmake.ch"        // incluido pelo assistente de conversao do AP5 IDE em 25/06/01
#Include "TopConn.ch"
#include 'fileio.ch

User Function GERESTI()
  
	Local cPerg:="ESTSZB" 
	Local aPerg:={}
	
	If !File("CalcEstimado-"+cEmpAnt+".txt")              
	
		//Cria o Arquivo com as informações de Quem esta Executando
		nFile:=FCreate("CalcEstimado-"+cEmpAnt+".txt")
		FWrite(nFile,"Usuário:"+cUserName+Chr(13)+Chr(10))
		FWrite(nFile,"Inicio do Calculo:"+Dtoc(Date())+" - "+Time()+Chr(13)+Chr(10))
		FClose(nFile)          
	
		AADD(aPerg,{cPerg,"Revisão de  ?","C",06,0,"G","","","","","","",""})
		AADD(aPerg,{cPerg,"Revisão Ate ?","C",06,0,"G","","","","","","",""})
		
		
		@ 0,0 TO 180,450 DIALOG oDlg1 TITLE "Gerador do Estimado"
		
		@ 04,05 TO 55,220
		@ 10,10 SAY "Esta rotina tem o intuito de gerar o Estimado individualmente para o Fluxo "
		@ 20,10 SAY "Econômico. Esta Rotina podera demandar"
		@ 30,10 SAY " alguns minutos e nao e' recomendavel interrompe-la. Clique em <OK> para confirmar"
		@ 40,10 SAY " ou <Cancela> para Cancelar."
		//Pergunte(cPerg,.F.) forca o carregamento das perguntas caso nao seja acionado os parametros
		@ 65,120 BMPBUTTON TYPE 01 ACTION (Pergunte(cPerg,.F.),Confirma(),Close(oDlg1)) 
		@ 65,148 BMPBUTTON TYPE 02 ACTION Close(oDlg1)
		@ 65,178 BMPBUTTON TYPE 05 ACTION Pergunte(cPerg,.T.)
		
		ACTIVATE DIALOG oDlg1 CENTER
		
		// apaga o arquivo com as informações de geração
	  	FErase("CalcEstimado-"+cEmpAnt+".txt")
	else 
		MsgBox("O Estimado já esta sendo processado por "+Chr(13)+Chr(10)+MemoRead("CalcEstimado"+cEmpAnt+".txt"))
	endif
		
Return	



Static Function Confirma()

	Local cMes := MV_PAR02
	Local cMesAnt := AnoMes(MonthSub(CTOD("01/"+RIGHT(ALLTRIM(cMes),2)+"/"+LEFT(ALLTRIM(cMes),4)),1))

	If !ChecaRev(ALLTRIM(cMes))
		If ChecaRev(cMesAnt)
			GravaLog("log-Estimado-"+cEmpAnt+".log","Iniciado com sucesso! RevIni:"+MV_PAR01+"RevFim:"+MV_PAR02)
			Processa( {|| IMPSZB() },"Importando Registros da Tabela SZB para a SZ0","Alterando Registro ..." )
		Else
			MsgBox("A Rev. ("+cMesAnt+") ainda está aberta! Portanto, a Rev ("+cMes+") não pode ser processada.")
		EndIf
	Else
		MsgBox("O Estimado para esta Rev. ("+cMes+") já está fechado!")
	EndIf
	
Return()



Static Function ImpSZB()



	// Rotina para importar dados do arquivo SZB para ao SZ0

	Local i := 0
	Local cQuery :=""
	Local cPerg:="ESTSZB"
	Local cRevIni:=""
	Local cRevFim:=""
	Local cListFil := GetFiliais() //Pega as filiais da empresa corrente.
	Private cSeq   := "00"
	Private cIndex := CriaTrab(NIL,.F.)
	
	ProcRegua(SZB->(RecCount()))
	
	Pergunte(cPerg,.F.)
	cRevIni:=If(Empty(MV_PAR01),"",Alltrim(MV_PAR01))
	cRevFim:=MV_PAR02
	dbSelectArea("CT1")
	IndRegua("CT1",cIndex,"CT1_FILIAL+CT1_GRUPO",,,"Selecionando Registros ...")
	
	IncProc("Excluindo Registros do Fluxo ")
	
	cQuery  := " DELETE FROM "+RetSqlName("SZ0")
	cQuery  += " WHERE Z0_LINHA in ('ZZ','PC', 'EM') AND Z0_FILIAL IN (" + cListFil + ") AND"
	cQuery  += "       Z0_REVISAO <> '' "
	//cQuery  += " AND   Z0_REVISAO BETWEEN '"+MV_PAR01+"' AND '"+MV_PAR02+"' AND Z0_VEICULO != 'S' " SEMPRE EXCLUIR AS REVISOES AO GERAR ESTIMADO | Z0_VEICULO NAO POSSUI REVISAO PORTANTO NÃO PRECISA DESTA TRATATIVA
	
	TCSQLExec(cQuery)
	lMensagem:=.t.
	cMensCT1=""

	dbSelectArea("SZB")
	dbSetOrder(5)
	SET SOFTSEEK ON
	dbSeek(Xfilial("SZB")+cRevFim)
	While ! Eof() .And. SZB->ZB_REVISAO = cRevFim // NÃO TRAZER REVISOES ANTIGAS
		
	   IncProc("Importando Revisão.: "+SZB->ZB_REVISAO)
	              
	   	//Alteração para tratar o CT1_GRUPO até 30/09/2013 e CT1_GRUPO2 a partir de 01/10/2013
	   	if (SZB->ZB_ANO <= '2013' )
		   	dbSelectArea("CT1")         
		   	dbSetOrder(4)  // CT1_FILIAL + CT1_GRUPO		
		   	dbGotop()          
	
		   	if SZB->ZB_GrupGer == '000077' .or. SZB->ZB_GrupGer == '000078' // Ajuste para fazer a pesquisa com o grupo correto para casos anteriores a 01/10
		   		cGrupoGer := '000009'
		   	else
			   	cGrupoGer := SZB->ZB_GrupGer
		   	endif
			
			if !dbSeek(xFilial("CT1")+cGrupoGer) //Valida se o grupo gerencial existe
			   If SZB->ZB_GrupGer$cMensCT1
			   	Msgbox("Atenção, Grupo Gerencial: "+SZB->ZB_GrupGer+" Não Encontrado no Cadastro de Plano de Contas !, Informe ao setor contábil")
			   	lMensagem:=.f.
			   	cMensCT1+=SZB->ZB_GrupGer
			   Endif 
				dbSelectArea("SZB")
				dbSkip()
				Loop
			Endif
		
			For i := 1 to 12      
				if (SZB->ZB_ANO == '2013' .and. i >= 10 ) // ele processa 2013 até o mes 09
					Loop // avança para o próximo registro
				endif
				
				nValMes := &("SZB->ZB_Mes"+StrZero(i,2))
		
				if ! Empty(nValMes)
					FGravaSz0(StrZero(i,2))
			   	endIf	
		   	Next        
		endif
		
	   	if (SZB->ZB_ANO >= '2013')
		   	dbSelectArea("CT1")                                                                                                                   
		   	dbOrderNickName("GRP2") // CT1_FILIAL + CT1_GRUPO2 + CT1_CONTA
		   	dbGotop()          
		   	
			if !dbSeek(xFilial("CT1")+SZB->ZB_GrupGer) //Valida se o grupo gerencial existe
			   If SZB->ZB_GrupGer$cMensCT1
			   	Msgbox("Atenção, Grupo Gerencial: "+SZB->ZB_GrupGer+" Não Encontrado no Cadastro de Plano de Contas !, Informe ao setor contábil")
			   	lMensagem:=.f.
			   	cMensCT1+=SZB->ZB_GrupGer
			   Endif 
				dbSelectArea("SZB")
				dbSkip()
				Loop
			Endif
		
			For i := 1 to 12
				if (SZB->ZB_ANO == '2013' .and. i < 10 ) // ele processa 2013 a partir do mes 10
					Loop // avança para o próximo registro
				endif
	                 
				// Se o mês for maior ou igual a Dez/2013 somente processa SZB se for receita ou imposto (grupGer = 000015)
				If ! ( ;
					(SZB->ZB_ANO == '2013' .and. i == 12 .and. ( SubStr(SZB->ZB_GrupGer,3,1) == "1" .or. SZB->ZB_GrupGer == '000015' )) .or. ;
					(SZB->ZB_ANO >  '2013' .and. (SubStr(SZB->ZB_GrupGer,3,1) == "1" .or. SZB->ZB_GrupGer == '000015' ));
					)
					Loop
				endif
	
				nValMes := &("SZB->ZB_Mes"+StrZero(i,2))
		
				If ! Empty(nValMes)
					FGravaSz0(StrZero(i,2))
			   EndIf	
		   	Next
		endif	
		   
		cSeq := "00"
		dbSelectArea("SZB")
		dbSkip()
	EndDo
	SET SOFTSEEK OFF
	                                                       
	// Busca os valores orçados da tabela AK2 do PCO
	if (MV_PAR01 != MV_PAR02)
		MSGAlert(OemToAnsi('Os parametros Revisões inicial e Final São Diferentes. ' + chr(13) + chr(10) +' Para registro no Fluxo das revisão do PCO (AK2) será utilizada a Revisão final informada.'),'Alerta: parametros divergentes.')
	endif                                                                                                                                                                                               

	FGrvPCO()
	FGrvSZE()
	
	//Atualiza a Situação.
	cQuery:=" UPDATE "+RetSqlName("SZ0")+" SET Z0_SITUACA ='ESTIMADO' "
	cQuery+=" WHERE (NOT LEFT(Z0_CC,4) IN ('8100','8110')) "
	cQuery+="       AND Z0_REVISAO<>''                     "
	cQuery+="       AND (NOT '000034' IN (SELECT ZA_GRUPGER FROM "+RetSqlName("SZA")+" WHERE ZA_CONTA=Z0_CONTA )) "
	TcSqlExec(cQuery)     
	
	IncProc("Executando query de atualizacao (EXEQUERY)")
	
	U_EXEQUERY(StrZero(Year(dDatabase),4)) //Query de atualizaçao do dados
	
	IncProc("Executando chamada de procedure...")
	
	GrvProcd(cRevFim)

	GravaLog("log-Estimado-"+cEmpAnt+".log","Finalizado com sucesso! RevIni:"+MV_PAR01+"RevFim:"+MV_PAR02)
	
	MsgBox("Processo Finalizado !","Termino","INFO")
	
Return
	   
Static Function GrvProcd(cRef)
 
	Local nResult := -1
	
	DO CASE
		CASE cEmpAnt = '02'
			nResult := TCSPEXEC("FluxoConsolidacao", cRef)
		CASE cEmpAnt = '03'
			nResult := TCSPEXEC("FluxoConsolidacaoLynx", cRef)
		CASE cEmpAnt = '04'
			nResult := TCSPEXEC("FluxoConsolidacaoMoc", cRef)
         OTHERWISE
         	nResult := -1
    ENDCASE
	
	IF nResult = -1
		GravaLog("log-cust-procedure-"+cEmpAnt+".log",'Erro na execução da Stored Procedure : '+TcSqlError())
	Else
		GravaLog("log-cust-procedure-"+cEmpAnt+".log","Execurado com sucesso! RevIni:"+MV_PAR01+"RevFim:"+MV_PAR02)
	Endif
 
Return

Static function ChecaRev(cRev)

	Local oFile
	Local cLinha := ""
	Local lRet := .F.
	oFile := FWFileReader():New("log-Ctrl-Rev-Fluxo-"+cEmpAnt+".log")
	if (oFile:Open())
	   while (oFile:hasLine())
	   		cLinha := oFile:GetLine()
	   		//Conout(cRev)
			if ALLTRIM(cLinha) == cRev
				lRet := .T.
				//Conout(cLinha)
				Exit
			EndIf
	   end
	   oFile:Close()
	endif

Return lRet

Static Function GravaLog(cArq,cMsg )
 	
	If !File(cArq)
		nHandle := FCreate(cArq)
	else
		nHandle := fopen(cArq , FO_READWRITE + FO_SHARED )
	Endif

	If nHandle == -1
		MsgStop('Erro de abertura : FERROR '+str(ferror(),4))
	Else
		FSeek(nHandle, 0, FS_END) 
		FWrite(nHandle, Dtoc(Date())+" - "+Time()+" : "+cUserName+" : "+cMsg+Chr(13)+Chr(10))
		fclose(nHandle) 
	Endif
	
 
return

Static Function FGravaSz0(cMesRefe)
	
	// Gravacao no SZ0

	
	cSeq   :=  StrZero(Val(cSeq)+1,2)
	 
	If SubStr(SZB->ZB_GrupGer,3,1) == "1"
		nValor := &("SZB->ZB_Mes"+cMesRefe)
	Else
		nValor := (-1)*&("SZB->ZB_Mes"+cMesRefe)
	EndIf	
	cSetor:=Posicione("SZ2",3,Xfilial("cCusto")+Alltrim(SZB->ZB_CCUSTO),"Z2_SETOR")
	                                                                                                                   
	// Análise do CT1_GRUPO ou CT1_GRUPO2 de acordo com o período. Até 30/09/2013 é CT1_GRUPO e a partir de 01/10/2013 é CT1_GRUPO2 - 10/2013
	DbSelectArea('SZB')
	
	if (SZB->ZB_ANO < '2013' .or. (SZB->ZB_ANO == '2013' .and. val(cMesRefe) < 10))	    
		cGrupo := Alltrim(CT1->CT1_GRUPO)
	
		// Ajuste para acertar a conta a ser exibida quando o grupo for '000016'  - DESPESAS DIVERSAS - Leandro 09/2013
		IF (Alltrim(CT1->CT1_GRUPO) == '000016')
			cConta := '4113090010'                                    
		else
			cConta := CT1->CT1_CONTA
		endif                                                                                                                                
	else                              
		// Período a partir de 10/2013
		cGrupo := Alltrim(CT1->CT1_GRUPO2)
		// Ajuste para acertar a conta a ser exibida quando o grupo for '000016'  - DESPESAS DIVERSAS - Ajuste para CT1_GRUPO2
		IF (Alltrim(CT1->CT1_GRUPO2) == '000016')
			cConta := '4113090010'
		else
			cConta := CT1->CT1_CONTA
		endif                                                                                                                                
		
	endif
	
	DbSelectArea("SZ0")
	Reclock("SZ0",.T.)
	Replace Z0_FILIAL With xFilial("SZ0"),;
	        Z0_LINHA 	With "ZZ"        ,;
	        Z0_HIST 	With "ESTIMADO SZB"  ,;
	        Z0_LOTE 	With "9800"      ,;
	        Z0_DOC 	 	With "9800"+cSeq ,;
	        Z0_VALOR 	With nValor      ,;
	        Z0_CONTA 	With cConta	,;  //CT1->CT1_CONTA alterado por leandro em 09/2013 ,; //TBH127 - 01/11/05
	        Z0_CC 		With SZB->ZB_CCUSTO ,;
	        Z0_DESC2	With SZB->ZB_BENEFIC ,;
	        Z0_DTREF 	With cMesRefe+"/"+SubStr(SZB->ZB_Ano,3,2) ,;
	        Z0_DATA 	With "" ,;
	        Z0_DTCAIXA With ""   ,;
	        Z0_DTVENC  With ""   ,;  
	        Z0_GRUPGER With cGrupo ,; // CT1->CT1_GRUPO Adicionado por leandro em 10/2013 para correção do erro na geração dos dados com Grupo2
	        Z0_CUSTO   With Iif(nValor < 0,nValor,0) ,;
	        Z0_RECEITA With Iif(nValor > 0,nValor,0) ,;
	        Z0_Revisao With SZB->ZB_Revisao,;
	        Z0_DTLANC  With ddatabase,;
	        Z0_SETORIG With cSetor
	MsUnlock()
	
	DbSelectArea("SZ0") 
	
Return()
      
/******************************************************************************
 * Realiza a leitura dos valores orçados da Tabela AKD e salva na SZ0 para or-
 * çamentos realizados a partir de Dez/2013           
 * Alterado para pegar da AKD e para baixar os valores lançados na SZ0 para
 * que os valores emenhados (tipo 'PC' na AKD) sejam transferidos de mês 
 * saindo do mês orçado para o mês que efetivamente foi entregue, e faturado
 *****************************************************************************/
Static Function FGrvPCO()
	cxEnter := chr(10) + chr(13)         
                                                   
	cQry := " SELECT * 
	cQry += " FROM " + RetSqlName('AKD') + " AKD "
	cQry += " WHERE AKD_DATA >= '20131201' "
	cQry += " 	AND (( AKD_TPSALD in('OR', 'PC', 'EM' ) AND AKD_TIPO = '1' ) OR ( AKD_TPSALD in ( 'PC', 'EM' ) AND AKD_TIPO = '2' )) "
	cQry += " 	AND D_E_L_E_T_ <> '*' "
	
	bQuery  := {|| If(Select("QAKD") > 0, QAKD->(dbCloseArea()), Nil), dbUseArea(.T.,"TOPCONN",TCGENQRY(,,cQry),"QAKD",.F.,.T.), dbSelectArea("QAKD"), QAKD->(dbGoTop()) }
	Eval(bQuery)
	
	Count To nQtdReg
	
	QAKD->(dbGoTop())
	ProcRegua(nQtdReg)
	IncProc("Processando Estimado PCO (Tabela AKD)")
	    
	while(!QAKD->(Eof()))
		
     	IncProc("Processando Estimado PCO (Tabela AKD)")
		cSeq   := StrZero(Val(cSeq)+1,2)
		cSetor := Posicione("SZ2",3,Xfilial("cCusto")+Alltrim(QAKD->AKD_CC),"Z2_SETOR")
		

		do case 
			case QAKD->AKD_TPSALD == 'PC'
				if (QAKD->AKD_TIPO == '1')
		   			cHist	:= 'EMPENHADO AKD - ' // NA GERACAO DO PEDIDO
		  		else
				  	if (QAKD->AKD_PROCES != '000056')
		   				cHist	:= 'BAIXA EMPENHADO AKD - '  //NA ENTRADA DA NOTA
					else
						cHist	:= ''  //ELIMINA RESIDUO PC TIPO 2                                                              
					endif                                                                 
		  		endif
			case QAKD->AKD_TPSALD == 'EM'
				if (QAKD->AKD_TIPO == '1')
					cHist  	:= 'DEBITO EMPENHADO - ' // NA GERACAO DO PEDIDO
				else                                 
					cHist  	:= 'BAIXA DEBITO EMPENHADO - ' //NA ENTRADA DA NOTA 
				endif
			otherwise
				cHist  	:= 'ESTIMADO AKD - '
		endcase                                                     
		
		cQry := " SELECT TOP 1 AK2_DESCRI "  + cxEnter
		cQry +=	" FROM " + RetSqlName('AK2') + " AK2 " + cxEnter
		cQry += " WHERE AK2_FILIAL = '" + QAKD->AKD_FILIAL + "' AND AK2_ORCAME = '" + QAKD->AKD_CODPLA + "'" + cxEnter
		cQry += "		AND AK2_CO = '" + QAKD->AKD_CO + "' AND D_E_L_E_T_ <> '*' and AK2_VALOR = " + str(QAKD->AKD_VALOR1)
		cQry += " ORDER BY AK2_VERSAO DESC
	
		bQuery  := {|| If(Select("QAK2") > 0, QAKD->(dbCloseArea()), Nil), dbUseArea(.T.,"TOPCONN",TCGENQRY(,,cQry),"QAK2",.F.,.T.), dbSelectArea("QAK2"), QAK2->(dbGoTop()) }
		Eval(bQuery)                                                                                                                                                   
		
		if QAK2->(!Eof())
			cDesc := QAK2->AK2_DESCRI
		else         
			cDesc := ''                                                                                                                                                               
		endif    
		
		QAK2->(DbCloseArea())


		// Tratamento do Valor para lançamento correto // PC / EM / ZZ
		if	( QAKD->AKD_TPSALD == "EM" .and. QAKD->AKD_TIPO = '1' ) .or. ( QAKD->AKD_TPSALD == "PC" .and. QAKD->AKD_TIPO = '2' )
			nValor := QAKD->AKD_VALOR1
		else 
			nValor := (-1) * QAKD->AKD_VALOR1
		endif
		
        // Atualização da SZ0 com lançamentos
		DbSelectArea("SZ0")
		Reclock("SZ0",.T.)
		Replace Z0_FILIAL 	With QAKD->AKD_FILIAL ,;
		        Z0_LINHA 	With IF(QAKD->AKD_TPSALD == "PC", "PC", "ZZ"),;  // Verifica se é PC [para lançamento como Empenho]
		        Z0_HIST 	With cHist + STRTRAN(QAKD->AKD_HIST, "BAIXA", "")	,;
		        Z0_LOTE 	With "9800"      	,;
		        Z0_DOC 	 	With "9800"+cSeq 	,;
		        Z0_VALOR 	With nValor ,; 
		        Z0_CONTA 	With QAKD->AKD_CO	,;  
		        Z0_CC 		With QAKD->AKD_CC 	,;
		        Z0_DESC2	With cDesc 			,;
		        Z0_DTREF 	With SubStr(QAKD->AKD_DATA, 5,2) +"/"+ SubStr(QAKD->AKD_DATA, 3,2) ,;
		        Z0_DATA 	With "" 		,;
		        Z0_DTCAIXA 	With ""   		,;
		        Z0_DTVENC  	With ""   		,;  
		        Z0_GRUPGER 	With QAKD->AKD_OPER ,; 
		        Z0_CUSTO   	With Iif(nValor < 0,nValor,0) ,;
		        Z0_RECEITA 	With Iif(nValor > 0,nValor,0) ,;
		        Z0_Revisao 	With MV_PAR02	,;
		        Z0_DTLANC  	With ddatabase	,;
		        Z0_SETORIG 	With cSetor		
		MsUnlock()
		
		QAKD->(DbSkip())
	enddo                                                                                                                                                    	          

Return

Static Function FGrvSZE()

	Local cCONTA	:= Alltrim(GetMV("CN_MBSZECON"))	
	Local cGRUPGER  := Alltrim(GetMV("CN_MBSZEALT"))
	Local lCria		:= .T.
	Local cDoc		:= ""
	Local cHist		:= "PREV RESTITUICAO ICMS/ST"
	//Local nTamCPo	:= TamSx3("Z0_DOC")[1]-2  não esta sendo usada
	Local cCount	:= StrZero(1,TamSx3("Z0_DOC")[1]-2)

	dbSelectArea("SZE")
	SZE->(dbSetOrder(1))
	SZE->(dbGoTop())
	                                   
	
	ProcRegua(SZE->(RecCount()))
	
	While !(SZE->(eof()))
	
		IncProc("")
		
		cDoc := "95"+cCount
		cCount := Soma1(cCount)
		cDatRef := SubStr(SZE->ZE_REF,1,2)+"/"+SubStr(SZE->ZE_REF,-2)
			
	
		RecLock('SZ0',lCria)//FLUXO ECONOMICO               
			Replace Z0_FILIAL  with SZE->ZE_FILIAL // Filial (C,  2,  0)* Campo não usado
			Replace Z0_LINHA   with "ZZ" // Linha Doc. (C,  2,  0)
			Replace Z0_HIST    with cHist // Historico (C, 40,  0)
			Replace Z0_DOC     with cDoc // Documento (C,  9,  0)
			Replace Z0_VALOR   with SZE->ZE_VALOR // Valor (N, 14,  2)
			Replace Z0_CONTA   with cCONTA // Conta (C, 20,  0)
			Replace Z0_CC      with SZE->ZE_CC // Centro Custo (C, 20,  0)
			Replace Z0_DTREF   with cDatRef // Dt. Refer. (C,  5,  0)
			Replace Z0_REVISAO with MV_PAR02 // REVISAO (C,  6,  0)
			Replace Z0_SITUACA with "ESTIMADO" // Situacao (C, 45,  0)
			Replace Z0_DTLANC  with Date() // Dt Lancament (D,  8,  0)
			Replace Z0_GRUPGER with cGRUPGER // Grupo Gerenc (C,  6,  0)
			Replace Z0_VRPREV  with SZE->ZE_VALOR // Vlr Prev (N, 12,  2)
			Replace Z0_DESC01  with POSICIONE("CTT",1,xFilial("CTT")+SZE->ZE_CC,"CTT_DESC01") // Desc. CCusto (C, 40,  0)
			Replace Z0_FATOR   with POSICIONE("SZA",1,xFilial("SZA")+cGRUPGER,"ZA_FATOR") // Fator (N, 12,  2)
			Replace Z0_DESGER  with POSICIONE("SZA",1,xFilial("SZA")+cGRUPGER,"ZA_DESCRI") // Desc Grupo (C, 40,  0)
			Replace Z0_CODCONT with POSICIONE("CTT",1,xFilial("CTT")+SZE->ZE_CC,"CTT_CODCON") // CodCont (C,  5,  0)
		MsUnLock('SZ0') 
		
		SZE->(dbSkip())
	
	EndDo

Return

Static Function GetFiliais()

	local aFilAux := FWAllFilial()
	local nAtu
	local cList
	

	For nAtu := 1 To Len(aFilAux)
		if nAtu == 1
			cList := "'" + aFilAux[nAtu] + "'"
		else
			cList := cList + ",'" + aFilAux[nAtu] + "'"
		endif
	Next
	
return cList
