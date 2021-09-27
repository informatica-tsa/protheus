#INCLUDE "protheus.ch"
#INCLUDE "apwebsrv.ch"

/* ===============================================================================
WSDL Location    http://localhost:8051/wsConsultaSQL/MEX?wsdl
Gerado em        09/16/19 09:42:30
Observações      Código-Fonte gerado por ADVPL WSDL Client 1.120703
                 Alterações neste arquivo podem causar funcionamento incorreto
                 e serão perdidas caso o código-fonte seja gerado novamente.
=============================================================================== */

User Function _RAZJVQJ ; Return  // "dummy" function - Internal Use 



/* ====================== SERVICE WARNING MESSAGES ======================
Definition for Type as complexType NOT FOUND. This Object HAS NO RETURN.
====================================================================== */

/* -------------------------------------------------------------------------------
WSDL Service WSwsConsultaSQL
------------------------------------------------------------------------------- */

WSCLIENT WSwsConsultaSQL

	WSMETHOD NEW
	WSMETHOD INIT
	WSMETHOD RESET
	WSMETHOD CLONE
	WSMETHOD Implements
	WSMETHOD CheckServiceActivity
	WSMETHOD AutenticaAcesso
	WSMETHOD RealizarConsultaSQL

	WSDATA   _URL                      AS String
	WSDATA   _HEADOUT                  AS Array of String
	WSDATA   _COOKIES                  AS Array of String
	WSDATA   oWStype                   AS wsConsultaSQL_Type
	WSDATA   lImplementsResult         AS boolean
	WSDATA   lCheckServiceActivityResult AS boolean
	WSDATA   cAutenticaAcessoResult    AS string
	WSDATA   ccodSentenca              AS string
	WSDATA   ncodColigada              AS int
	WSDATA   ccodSistema               AS string
	WSDATA   cparameters               AS string
	WSDATA   cRealizarConsultaSQLResult AS string

ENDWSCLIENT

WSMETHOD NEW WSCLIENT WSwsConsultaSQL
::Init()
If !FindFunction("XMLCHILDEX")
	UserException("O Código-Fonte Client atual requer os executáveis do Protheus Build [7.00.170117A-20190628] ou superior. Atualize o Protheus ou gere o Código-Fonte novamente utilizando o Build atual.")
EndIf
Return Self

WSMETHOD INIT WSCLIENT WSwsConsultaSQL
	::oWStype            := wsConsultaSQL_TYPE():New()
Return

WSMETHOD RESET WSCLIENT WSwsConsultaSQL
	::oWStype            := NIL 
	::lImplementsResult  := NIL 
	::lCheckServiceActivityResult := NIL 
	::cAutenticaAcessoResult := NIL 
	::ccodSentenca       := NIL 
	::ncodColigada       := NIL 
	::ccodSistema        := NIL 
	::cparameters        := NIL 
	::cRealizarConsultaSQLResult := NIL 
	::Init()
Return

WSMETHOD CLONE WSCLIENT WSwsConsultaSQL
Local oClone := WSwsConsultaSQL():New()
	oClone:_URL          := ::_URL 
	oClone:oWStype       :=  IIF(::oWStype = NIL , NIL ,::oWStype:Clone() )
	oClone:lImplementsResult := ::lImplementsResult
	oClone:lCheckServiceActivityResult := ::lCheckServiceActivityResult
	oClone:cAutenticaAcessoResult := ::cAutenticaAcessoResult
	oClone:ccodSentenca  := ::ccodSentenca
	oClone:ncodColigada  := ::ncodColigada
	oClone:ccodSistema   := ::ccodSistema
	oClone:cparameters   := ::cparameters
	oClone:cRealizarConsultaSQLResult := ::cRealizarConsultaSQLResult
Return oClone

// WSDL Method Implements of Service WSwsConsultaSQL

WSMETHOD Implements WSSEND oWStype WSRECEIVE lImplementsResult WSCLIENT WSwsConsultaSQL
Local cSoap := "" , oXmlRet

BEGIN WSMETHOD

cSoap += '<Implements xmlns="http://www.totvs.com/">'
cSoap += WSSoapValue("type", ::oWStype, oWStype , "Type", .F. , .F., 0 , "http://www.totvs.com/", .F.,.F.) 
cSoap += "</Implements>"

oXmlRet := SvcSoapCall(Self,cSoap,; 
	"http://www.totvs.com/IRMSServer/Implements",; 
	"DOCUMENT","http://www.totvs.com/",,,; 
	"http://bhn050103073.bh01.local:8051/wsConsultaSQL/IRMSServer")

::Init()
::lImplementsResult  :=  WSAdvValue( oXmlRet,"_IMPLEMENTSRESPONSE:_IMPLEMENTSRESULT:TEXT","boolean",NIL,NIL,NIL,NIL,NIL,NIL) 

END WSMETHOD

oXmlRet := NIL
Return .T.

// WSDL Method CheckServiceActivity of Service WSwsConsultaSQL

WSMETHOD CheckServiceActivity WSSEND NULLPARAM WSRECEIVE lCheckServiceActivityResult WSCLIENT WSwsConsultaSQL
Local cSoap := "" , oXmlRet

BEGIN WSMETHOD

cSoap += '<CheckServiceActivity xmlns="http://www.totvs.com/">'
cSoap += "</CheckServiceActivity>"

oXmlRet := SvcSoapCall(Self,cSoap,; 
	"http://www.totvs.com/IRMSServer/CheckServiceActivity",; 
	"DOCUMENT","http://www.totvs.com/",,,; 
	"http://bhn050103073.bh01.local:8051/wsConsultaSQL/IRMSServer")

::Init()
::lCheckServiceActivityResult :=  WSAdvValue( oXmlRet,"_CHECKSERVICEACTIVITYRESPONSE:_CHECKSERVICEACTIVITYRESULT:TEXT","boolean",NIL,NIL,NIL,NIL,NIL,NIL) 

END WSMETHOD

oXmlRet := NIL
Return .T.

// WSDL Method AutenticaAcesso of Service WSwsConsultaSQL

WSMETHOD AutenticaAcesso WSSEND NULLPARAM WSRECEIVE cAutenticaAcessoResult WSCLIENT WSwsConsultaSQL
Local cSoap := "" , oXmlRet

BEGIN WSMETHOD

cSoap += '<AutenticaAcesso xmlns="http://www.totvs.com/">'
cSoap += "</AutenticaAcesso>"

oXmlRet := SvcSoapCall(Self,cSoap,; 
	"http://www.totvs.com/IwsBase/AutenticaAcesso",; 
	"DOCUMENT","http://www.totvs.com/",,,; 
	"http://bhn050103073.bh01.local:8051/wsConsultaSQL/IwsBase")

::Init()
::cAutenticaAcessoResult :=  WSAdvValue( oXmlRet,"_AUTENTICAACESSORESPONSE:_AUTENTICAACESSORESULT:TEXT","string",NIL,NIL,NIL,NIL,NIL,NIL) 

END WSMETHOD

oXmlRet := NIL
Return .T.

// WSDL Method RealizarConsultaSQL of Service WSwsConsultaSQL

WSMETHOD RealizarConsultaSQL WSSEND ccodSentenca,ncodColigada,ccodSistema,cparameters WSRECEIVE cRealizarConsultaSQLResult WSCLIENT WSwsConsultaSQL
Local cSoap := "" , oXmlRet

BEGIN WSMETHOD

cSoap += '<RealizarConsultaSQL xmlns="http://www.totvs.com/">'
cSoap += WSSoapValue("codSentenca", ::ccodSentenca, ccodSentenca , "string", .F. , .F., 0 , NIL, .F.,.F.) 
cSoap += WSSoapValue("codColigada", ::ncodColigada, ncodColigada , "int", .F. , .F., 0 , NIL, .F.,.F.) 
cSoap += WSSoapValue("codSistema", ::ccodSistema, ccodSistema , "string", .F. , .F., 0 , NIL, .F.,.F.) 
cSoap += WSSoapValue("parameters", ::cparameters, cparameters , "string", .F. , .F., 0 , NIL, .F.,.F.) 
cSoap += "</RealizarConsultaSQL>"

oXmlRet := SvcSoapCall(Self,cSoap,; 
	"http://www.totvs.com/IwsConsultaSQL/RealizarConsultaSQL",; 
	"DOCUMENT","http://www.totvs.com/",,,; 
	"http://bhn050103073.bh01.local:8051/wsConsultaSQL/IwsConsultaSQL")

::Init()
::cRealizarConsultaSQLResult :=  WSAdvValue( oXmlRet,"_REALIZARCONSULTASQLRESPONSE:_REALIZARCONSULTASQLRESULT:TEXT","string",NIL,NIL,NIL,NIL,NIL,NIL) 

END WSMETHOD

oXmlRet := NIL
Return .T.


// WSDL Data Structure Type

WSSTRUCT wsConsultaSQL_Type
	WSMETHOD NEW
	WSMETHOD INIT
	WSMETHOD CLONE
	WSMETHOD SOAPSEND
ENDWSSTRUCT

WSMETHOD NEW WSCLIENT wsConsultaSQL_Type
	::Init()
Return Self

WSMETHOD INIT WSCLIENT wsConsultaSQL_Type
Return

WSMETHOD CLONE WSCLIENT wsConsultaSQL_Type
	Local oClone := wsConsultaSQL_Type():NEW()
Return oClone

WSMETHOD SOAPSEND WSCLIENT wsConsultaSQL_Type
	Local cSoap := ""
Return cSoap


