//Bibliotecas
#Include "Protheus.ch"
#Include "APWebSrv.ch"
#Include "TBIConn.ch"
#Include "TBICode.ch"
#Include "TopConn.ch"
#Include "aarray.ch"
#Include "json.ch"
#Include "shash.ch"


WsService zWsRecrutamento Description "WebService com funcoes de integração com módulo de Recrutamento e Seleção."
	//Atributos
	WsData   cDadJSON as String
	WsData   cMsgJSON as String

	//Metodos
	WSMETHOD InsertVagas	  Description "Metodo para inserir registro de vagas"
EndWsService


WsMethod InsertVagas WsReceive cDadJSON WsSend cMsgJSON WsService zWsRecrutamento
	//Retorno do Metodo InsertVagas (.T. se esta tudo certo ou .F. se houve falha)
	Local lRet       := .T.
	
	//Variavel de Token pegando da tabela SX6
	Local cToken     := Alltrim(GetMV('MV_ZTOKENW'))
	
	//Parametros recebidos pelo JSON (variavel cDadJSON)
	Local cQS_FILIAL		:= ""
	Local cQS_FUNCAO		:= ""
	Local cQS_DESCRIC 	:= ""
	Local cQS_ZSALARI 	:= ""
	Local cQS_NRVAGA		:= ""
	Local cQS_ZJUSTIF		:= ""
	Local cQS_CLIENTE		:= ""
	Local cQS_SOLICIT		:= ""
	Local cQS_PRAZO		:= ""
	Local cQS_DTABERT		:= ""
	Local cQS_CC			:= ""
	Local cQS_PERFIL 		:= ""
	Local cQS_ZLOCAL		:= ""
	Local cQS_ZVTRANS  	:= ""
	Local cQS_ZTRANTS  	:= ""
	Local cQS_ZVREFEI  	:= ""
	Local cQS_ZALMOC  	:= ""
	Local cQS_ZCOMPUT  	:= ""
	Local cQS_ZWISE    	:= ""
	Local cTokenWs 		:= ""
		
	//Variaveis usadas para transformar o JSON em Objeto
	Private oJSON    := Nil
	Private oDados   := Nil
	
	ConOut("JSON Recebido:        "+::cDadJSON)
	//Deserializando o JSON (transformando a "string" em "objeto")
	If (FWJsonDeserialize(::cDadJSON, @oJSON))
	
		//Separando o objeto de dados, e o Token
		oDados     := oJSON:Dados
		cTokenWs  := Iif(Type("oJSON:Token") != "U", oJSON:Token, "")
		
		//Se o Token recebido for o mesmo do parametro, prossegue
		//ConOut("Token do parametro: "+cToken)
		//ConOut("Token enviado: "+cTokenWs)
		If cToken == cTokenWs
			
			//Pegando os 3 filtros possiveis vindo dentro de "Dados"		
			cQS_FILIAL		:= Upper(Alltrim(Iif(Type("oDados:QS_FILIAL") 	!= "U", oDados:QS_FILIAL, "")))
			cQS_FUNCAO		:= Upper(Alltrim(Iif(Type("oDados:QS_FUNCAO") 	!= "U", oDados:QS_FUNCAO, "")))
			cQS_ZSALARI 	:= VAL(Upper(Alltrim(Iif(Type("oDados:QS_ZSALARI") 	!= "U", oDados:QS_ZSALARI, ""))))
			cQS_NRVAGA		:= VAL(Upper(Alltrim(Iif(Type("oDados:QS_NRVAGA") 	!= "U", oDados:QS_NRVAGA, ""))))
			cQS_ZJUSTIF	:= Upper(Alltrim(Iif(Type("oDados:QS_ZJUSTIF") 	!= "U", oDados:QS_ZJUSTIF, "")))
			cQS_CLIENTE	:= Upper(Alltrim(Iif(Type("oDados:QS_CLIENTE") 	!= "U", oDados:QS_CLIENTE, "")))
			cQS_SOLICIT	:= Upper(Alltrim(Iif(Type("oDados:QS_SOLICIT")	!= "U", oDados:QS_SOLICIT, "")))
			cQS_PRAZO		:= VAL(Upper(Alltrim(Iif(Type("oDados:QS_PRAZO") 		!= "U", oDados:QS_PRAZO, ""))))
			cQS_DTABERT	:= CTOD(Upper(Alltrim(Iif(Type("oDados:QS_DTABERT")	!= "U", oDados:QS_DTABERT, ""))))
			cQS_CC			:= Upper(Alltrim(Iif(Type("oDados:QS_CC") 		!= "U", oDados:QS_CC, "")))
			cQS_PERFIL 	:= Upper(Alltrim(Iif(Type("oDados:QS_PERFIL") 	!= "U", oDados:QS_PERFIL, "")))
			cQS_ZLOCAL		:= Upper(Alltrim(Iif(Type("oDados:QS_ZLOCAL") 	!= "U", oDados:QS_ZLOCAL, "")))
			cQS_ZVTRANS  	:= Upper(Alltrim(Iif(Type("oDados:QS_ZVTRANS") 	!= "U", oDados:QS_ZVTRANS, "")))
			cQS_ZTRANTS  	:= Upper(Alltrim(Iif(Type("oDados:QS_ZTRANTS") 	!= "U", oDados:QS_ZTRANTS, "")))
			cQS_ZVREFEI  	:= Upper(Alltrim(Iif(Type("oDados:QS_ZVREFEI") 	!= "U", oDados:QS_ZVREFEI, "")))
			cQS_ZALMOC  	:= Upper(Alltrim(Iif(Type("oDados:QS_ZALMOC") 	!= "U", oDados:QS_ZALMOC, "")))
			cQS_ZCOMPUT  	:= Upper(Alltrim(Iif(Type("oDados:QS_ZCOMPUT") 	!= "U", oDados:QS_ZCOMPUT, "")))
			cQS_ZWISE    	:= Upper(Alltrim(Iif(Type("oDados:QS_ZWISE") 		!= "U", oDados:QS_ZWISE, "")))

			If Empty(cQS_FUNCAO) .And. Empty(cQS_ZSALARI)
				SetSoapFault('Erro', 'Os campos QS_FUNCAO,QS_ZSALARI são de preenchimento obrigatório!')
				lRet := .F.
			Else
					
					IF !ExistCpo("SRJ", cQS_FUNCAO)
						SetSoapFault('Erro', 'Função selecionada não foi encontrada!')
						lRet := .F.
					ENDIF
					
					dbSelectArea("SRJ")
					SRJ->(dbSetOrder(1))
					SRJ->(dbSeek(xFilial("SRJ")+cQS_FUNCAO))
					
					IF Alltrim(SRJ->RJ_FUNCAO) != Alltrim(cQS_FUNCAO)
						ConOut("Funcao posicionada: "+SRJ->RJ_FUNCAO)
						ConOut("Funcao posicionada: "+cQS_FUNCAO)
						SetSoapFault('Erro', 'Não foi possível posicionar na função selecionada!')
						lRet := .F.
					ENDIF
					
					cQS_DESCRIC := SRJ->RJ_DESC
					
					IF cQS_ZSALARI == 0 .Or. cQS_NRVAGA == 0 .Or. cQS_PRAZO == 0
						SetSoapFault('Erro', 'Os campos QS_PRAZO,QS_NRVAGA,QS_ZSALARI estão zerados ou sua conversão resultou em erro!')
						lRet := .F.
					ENDIF
					
					IF Alltrim(DTOS(cQS_DTABERT)) == ""
						SetSoapFault('Erro', 'O campo QS_DTABERT está vazio ou sua conversão resultou em erro!')
						lRet := .F.
					ENDIF
			
					DbSelectArea("SQS")
					nCodVaga := GETSXENUM("SQS","QS_VAGA")
					If RecLock("SQS",.T.)
							Replace  	QS_FILIAL 		With cQS_FILIAL	,;
										QS_VAGA		With nCodVaga 	,;                                                                                                     
										QS_FUNCAO 		With cQS_FUNCAO	,; 
										QS_DESCRIC 	With cQS_DESCRIC	,; 
										QS_ZSALARI 	With cQS_ZSALARI 	,; 
										QS_NRVAGA 		With cQS_NRVAGA	,; 
										QS_ZJUSTIF 	With cQS_ZJUSTIF 	,; 
										QS_CLIENTE 	With cQS_CLIENTE	,; 
										QS_SOLICIT 	With cQS_SOLICIT 	,; 
										QS_PRAZO 		With cQS_PRAZO	,; 
										QS_DTABERT 	With cQS_DTABERT 	,; 
										QS_CC 			With cQS_CC 		,; 
										QS_ZLOCAL 		With cQS_ZLOCAL 	,; 
										QS_ZVTRANS 	With cQS_ZVTRANS 	,; 
										QS_ZTRANTS 	With cQS_ZTRANTS 	,; 
										QS_ZVREFEI   	With cQS_ZVREFEI	,; 
										QS_ZALMOC  	With cQS_ZALMOC	,; 
										QS_ZCOMPUT 	With cQS_ZCOMPUT	,; 
										QS_ZWISE 		With cQS_ZWISE   
										  
							ConfirmSx8()
							MsUnlock() 
							
							MSMM(,LEN(cQS_PERFIL),,cQS_PERFIL,1,,,"SQS","QS_CODPERF")
							
							//JSON de retorno
							::cMsgJSON += ' {                               '    + CRLF
							::cMsgJSON += '  "Vaga" : {                     '    + CRLF
							::cMsgJSON += '      "Codigo":"'+nCodVaga+'"    '    + CRLF
							::cMsgJSON += '  }                              '    + CRLF
							::cMsgJSON += ' }                               '    + CRLF
	
					else
					    RollbackSx8()
					endif
	
					DbCloseArea()
				
			EndIf
			
		//Caso seja um token invalido
		Else
			SetSoapFault('Erro', 'Token invalido!')
			lRet := .F.
		EndIf
		
	//Se houve erro ao deserializar o JSON
	Else
		SetSoapFault('Erro', 'JSON nao deserializado!')
		lRet := .F.
	EndIf

Return lRet