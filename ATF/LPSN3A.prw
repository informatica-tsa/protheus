#include "rwmake.ch"

User Function LPSN3A

	cAlias := Alias()
	nRec   := Recno()
	nOrdem := IndexOrd()
	
	dbSelectArea("SN1")
	nOrdem2 := IndexOrd()
	nRec2   := Recno()
	cAno    := Right(Alltrim(str(year(dDataBase))),2)
	dbSetOrder(1)
	
	xcChave :=xFilial("SN1")+Left(M->N1_GRUPO,2)+cAno+"9999"
	dbSeek(xcChave,.T.)
	dbSkip(-1)
	cBase := SN1->N1_CBASE

	If (ALTERA .and. (FunName()) == "ATFA240")  .or. (INCLUI .and. (FunName()) == "ATFA012")
		If Left(cBase,4) == Left(M->N1_GRUPO,2)+cAno
		   cBase := StrZero(Val(cBase)+1,8)
		Else
		   cBase := Left(M->N1_GRUPO,2)+cAno+"0001" 
		Endif
	Else
		cBase := M->N1_CBASE
	Endif
	
	dbSelectArea("SN1")
	dbSetOrder(nOrdem2)
	dbGoto(nRec2)
	
	dbSelectArea(cAlias)
	dbSetOrder(nOrdem)
	DbGoto(nRec)

RETURN(cBase)
