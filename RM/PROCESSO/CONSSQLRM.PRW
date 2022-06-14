#INCLUDE "totvs.ch"
#INCLUDE "protheus.ch"
#INCLUDE "rwmake.ch"

//-------------------------------------------------------------------
/* {Protheus.doc} CONSSQLRM
Teste consulta Query RM

@protected TSA
@author    Alex T. Souza
@since     16/09/2019

Alteracoes Realizadas desde a Estruturacao Inicial
Data       Programador     Motivo
/*/
//-------------------------------------------------------------------
User Function CONSSQLRM(cSentenca,cCodSistema,cParam,aCabec, lErro, cMsg)   
	LOCAL cParseURL	:= ALLTRIM(SuperGetMv("FS_RMURLWS",.T.,"http://192.168.11.17:8051")) + "/wsConsultaSQL/MEX?wsdl" 
	LOCAL cUserTOP	:= SuperGetMv("FS_RMUWS",.T.,"mestre") 
	LOCAL cPassTOP	:= SuperGetMv("FS_RMPWS",.T.,"totvs")
	LOCAL cColGlob	:= SuperGetMv("FS_COLGLOB",.T.,"1")
	LOCAL oWsdl
	LOCAL xRet		:= .F.
	LOCAL cRetSend	:= ""                   
	LOCAL aSimple	:= {}	
    LOCAL cErro		:= ""
    LOCAL cAviso	:= ""
    LOCAL nRet      := 0
    Local aResult	:= {}
    Local nXi, nXj	:= 0
        
    Default lErro	:= .f.
    Default cMsg	:= ""        
        
	//-----------------------------------------------------------------------
	// Conecta ao WebService RM
	//-----------------------------------------------------------------------        
    cRetSend := cSentenca+" "+ConectaRM(@oWsdl,@xRet,"RealizarConsultaSQL")
    
    If !xRet
    	lErro := .t.
    Endif	

	//-----------------------------------------------------------------------
	// Define os parametros
	//-----------------------------------------------------------------------
	IF !lErro
		aSimple := oWsdl:SimpleInput()

		FOR nXi := 1 TO LEN(aSimple)
			nID		:= aSimple[nXi][1]
			cNome	:= aSimple[nXi][2]
			IF UPPER(ALLTRIM(cNome)) == "CODSENTENCA"
				oWsdl:SetValue( nID, cSentenca )
			ENDIF
			IF UPPER(ALLTRIM(cNome)) == "CODCOLIGADA"
				oWsdl:SetValue( nID, cColGlob )
			ENDIF
			IF UPPER(ALLTRIM(cNome)) == "CODSISTEMA"
				oWsdl:SetValue( nID, cCodSistema  )
			ENDIF
			IF UPPER(ALLTRIM(cNome)) == "PARAMETERS"
				oWsdl:SetValue( nID, cParam )
			ENDIF
		NEXT nXi

		//-----------------------------------------------------------------------
		// Envia uma mensagem SOAP ao servidor
		//-----------------------------------------------------------------------
		xRet := oWsdl:SendSoapMsg()
		IF !xRet
			cRetSend	:= cSentenca+" "+"Não foi possível enviar a mensagem ao serviço RM TOP: " + oWsdl:cError
			lErro 		:= .t.
		ENDIF
	ENDIF

    
	//-----------------------------------------------------------------------
	// Pega a mensagem de resposta
	//-----------------------------------------------------------------------
	IF !lErro
		cXML := oWsdl:GetSoapResponse()
		cXML := STRTRAN(cXML, "&lt;", "<")
		cXML := STRTRAN(cXML, "&gt;", ">")
		cXML := STRTRAN(cXML, "&#xD;", "")

		cXml := EncodeUTF8(cXml)
		oXml := XmlParser( cXml ,"_",@cErro,@cAviso ) 

		If Type("oXml:_S_ENVELOPE:_S_BODY:_RealizarConsultaSQLResponse:_RealizarConsultaSQLResult:_NEWDATASET:_RESULTADO") != "U"
			oDados := oXml:_S_ENVELOPE:_S_BODY:_RealizarConsultaSQLResponse:_RealizarConsultaSQLResult:_NEWDATASET:_RESULTADO
	
			Do Case
				Case ValType(oDados) == "O"
					aLinha := {}
					For nXi := 1 to len(aCabec)
						If Type("oDados:_"+aCabec[nXi,1]) == "O"
							cConteudo := &("oDados:_"+aCabec[nXi,1]+":Text")
							cConteudo :=  ConvValor(cConteudo,aCabec[nXi,2]) 
							//aadd(aResult[len(aResult)],{aCabec[nXi,1], cConteudo })
							aadd(aLinha,cConteudo)
						Endif
					Next
					If len(aLinha) > 0					
						aadd(aResult,aLinha)
					Endif
				Case ValType(oDados) == "A"
					For nXj := 1 to len(oDados)
						aLinha := {}
						For nXi := 1 to len(aCabec)
							If Type("oDados["+Alltrim(str(nXj))+"]:_"+aCabec[nXi,1]) == "O"
								cConteudo := &("oDados["+Alltrim(str(nXj))+"]:_"+aCabec[nXi,1]+":Text")
								cConteudo :=  ConvValor(cConteudo,aCabec[nXi,2]) 
								//aadd(aResult[len(aResult)],{aCabec[nXi,1], cConteudo })
								aadd(aLinha,cConteudo)
							Endif
						Next
						If len(aLinha) > 0					
							aadd(aResult,aLinha)
						Endif
					Next
	
			EndCase
		Endif			
	ELSE
		IF !EMPTY(cRetSend)
			lErro 	:= .t.
			cMsg	:= cSentenca+" "+cRetSend
		ENDIF
	ENDIF

Return aResult

//-------------------------------------------------------------------
/* {Protheus.doc} CONECTARM
Conexão RM

@protected TSA
@author    Alex T. Souza
@since     16/09/2019

Alteracoes Realizadas desde a Estruturacao Inicial
Data       Programador     Motivo
/*/
//-------------------------------------------------------------------
Static Function ConectaRM(oWsdl,xRet,cOperation)
Local cErro    := ""
Local cUrl     := ALLTRIM(SuperGetMv("FS_RMURLWS",.T.,"http://192.168.11.17:8051")) + "/wsConsultaSQL/MEX?wsdl"
Local cUsuario := SuperGetMv("FS_RMUWS",.T.,"mestre") 
Local cSenha   := SuperGetMv("FS_RMPWS",.T.,"totvs")

Default cOperation 	:= ""
Default xRet 		:= NIL

	If !Empty(cUrl).And. !Empty(cUsuario) .And. !Empty(cSenha)


		//Cria e conecta no Wsdl
		oWsdl := TWsdlManager():New()
		//oWsdl:lVerbose 				:= .T.
		oWsdl:nTimeout 				:= 300		
		oWsdl:nConnectionTimeout 	:= 300
		oWsdl:lSSLInsecure 			:= .T.
		oWsdl:bNoCheckPeerCert 		:= .T. // Desabilita o check de CAs
		//-----------------------------------------------------------------------
		// Faz o parse de uma URL
		//-----------------------------------------------------------------------
		xRet := oWsdl:ParseURL( cUrl )
		
		If !xRet 
			cErro 	:=  "Erro ao executar o ParseURL RM " + oWsdl:cError 
		Endif		
		
		If Empty(cErro)
			oWsdl:SetAuthentication(cUsuario, cSenha)
			
			If !Empty(cOperation)
				xRet := oWsdl:SetOperation(cOperation)
				IF !xRet
					cErro 	:= "Não foi possível definir a operação: " + oWsdl:cError 
				Endif		
			EndIf
	
			//Authenticate pre-emptively
			oWsdl:AddHttpHeader( "Authorization", "Basic " + Encode64(cUsuario + ":" + cSenha) )
			
		EndIf	
	Else	
		cErro := I18n("Não foi possível conectar ao web service RM, verifique os parâmetros #1 / #2 / #3", {"FS_RMURLWS", "FS_RMUWS", "FS_RMPWS"})		
	EndIf
	
Return cErro

//-------------------------------------------------------------------
/* {Protheus.doc} CONVVALOR
Converte valor recebido conforme parametro

@protected TSA
@author    Alex T. Souza
@since     16/09/2019

Alteracoes Realizadas desde a Estruturacao Inicial
Data       Programador     Motivo
/*/
//-------------------------------------------------------------------
Static Function ConvValor(cConteudo,cTipo)
Local xValor

	Do Case
		Case cTipo == "D"
			cConteudo := Substr(cConteudo,1,10)
			cConteudo := StrTran(cConteudo,"-","")
			xValor 	  := stod(cConteudo)
		Case cTipo == "N"
			xValor := Val(cConteudo)
		Case cTipo == "C"
			xValor := cConteudo	
		OtherWise
			xValor := cConteudo	
	EndCase	
	
Return xValor
