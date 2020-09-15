#INCLUDE "RWMAKE.CH" 
#Include "TopConn.ch"


User Function WsUsrField()

	Local cAlias := PARAMIXB[1]
	Local aReturn := {}
	
	if 	cAlias == "SQG"	
		aAdd( aReturn,"QG_ZDESDEF")	
		//aAdd( aReturn,"QG_PRETSAL") 	
		aAdd( aReturn,"QG_MEMO2")
		//aAdd( aReturn,"QG_FONTE")           		      		
	EndIf

Return aReturn


user function wsRS10Curric()

	Local oCurric 	:= Paramixb[1] //-- Objeto correspondente ao curriculo do candidato  
	Local cQuery	:= "SELECT RA_CIC, RA_MAT, RA_DEMISSA FROM "+RetSqlName("SRA")+" WHERE D_E_L_E_T_ = '' AND RA_CIC = '"+oCurric:Cpf+"' ORDER BY RA_DEMISSA"
	
	Local lExiste 	:= .F.
	Local lAtivo	:= .F.
	
	conout(oCurric:Curriculum )  //-- identificação do curriculo
	conout(oCurric:Name )        //-- Nome do candidato
	conout(oCurric:Cpf )         //-- Cpf do candidato
	
	TcQuery cQuery Alias ZSRA New
	dbSelectArea("ZSRA")

	While !Eof()
	
		if(Alltrim(ZSRA->RA_DEMISSA) == "")
			lAtivo	:= .T.
			exit
		else
			lExiste 	:= .T.
		EndIf
			
		dbSkip()
	EndDo
	
	dbSelectArea("ZSRA")
	dbCloseArea()
	
	if(lAtivo)
		cQuery  := " UPDATE "+RetSqlName("SQG")+" SET QG_SITUAC = 'FUN' WHERE QG_CIC = '"+oCurric:Cpf+"'"
		TCSQLExec(cQuery)
	Elseif(lExiste)
		cQuery  := " UPDATE "+RetSqlName("SQG")+" SET QG_SITUAC = '006' WHERE QG_CIC = '"+oCurric:Cpf+"'"
		TCSQLExec(cQuery)
	EndIf
	
return Nil