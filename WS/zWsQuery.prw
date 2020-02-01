#Include "Protheus.ch"
#Include "APWebSrv.ch"
#Include "TBIConn.ch"
#Include "TBICode.ch"
#Include "TopConn.ch"
#Include "aarray.ch"
#Include "json.ch"
#Include "shash.ch"


WsService zWsQuery Description "WebService para consultas complexas."

	WsData   cDadQuery  as String
	WsData   cDadCampos as String
	WsData   cDadWhere  as String
	WsData   cMsgXml    as String

	WSMETHOD Consultar	  Description "Metodo para consultas SQL"
	
EndWsService


WsMethod Consultar WsReceive cDadQuery,cDadCampos,cDadWhere   WsSend cMsgXml WsService zWsQuery

	Local lRet       	:= .T.
	Local cQuery		:= cDadQuery 
	Local aArray := {}
	Local nCnt
	
	ConOut("Inicio ImpXML: "+Time())
	 
	aArray := StrToKarr( cDadCampos , ',')
	if LEN(aArray) == 0 .or. empty(cDadQuery)
		SetSoapFault("Erro","Os campos de exibicao estao vazios ou a query esta vazia")
		ConOut("Os campos de exibicao estao vazios ou a query esta vazia")
		lRet := .F.
	Else
			if !empty(cDadWhere)
				cQuery := cDadQuery+" WHERE "+cDadWhere
			Endif
		
			ConOut("Query recebida: "+cDadQuery)
			ConOut("Campos recebidos: "+cDadCampos)
			ConOut("Where recebidos: "+cDadWhere)
	
			TcQuery cQuery Alias ZQUR New
			dbSelectArea("ZQUR")
			::cMsgXml += "<TABLEDATA>" + CRLF
			While !Eof()
					::cMsgXml += "    <Projeto>"	 + CRLF
					For nCnt := 1 To LEN(aArray) Step 1
						::cMsgXml += "        <"+ALLTRIM(aArray[nCnt])+">"
						::cMsgXml += ALLTRIM(cVALtoChar(&("ZQUR->"+ALLTRIM(aArray[nCnt]))))
						::cMsgXml += "</"+ALLTRIM(aArray[nCnt])+">" + CRLF
					Next
					::cMsgXml += "    </Projeto>" + CRLF
				dbSkip()
			EndDo
			::cMsgXml += "</TABLEDATA>"
			dbSelectArea("ZQUR")
			dbCloseArea()
	Endif
Return lRet