#INCLUDE "RWMAKE.CH" 


User Function WsUsrField()

	Local cAlias := PARAMIXB[1]
	Local aReturn := {}
	
	if 	cAlias == "SQG"		
		aAdd( aReturn,"QG_PRETSAL") 	
		aAdd( aReturn,"QG_MEMO2")
		aAdd( aReturn,"QG_ZLIST")           		      		
	EndIf

Return aReturn