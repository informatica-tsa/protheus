#include "rwmake.ch"

User Function ValidDt()

Local lRet := .T.
Local dDataAtu := CTOD("")
Local nxI := 0

nPos1 := aScan(aHeader,{|aAux| Upper(Alltrim(aAux[2])) == "ZK_DATA"})

If aCols[n,nPos1] == CTOD("")
	lRet := .F.
EndIf

dDataAtu := aCols[n,nPos1]

If !aCols[n,Len(aHeader)+1]

	For nxI := 1 To Len(aCols)
		
		If !aCols[nxI,Len(aHeader)+1]
	   		If aCols[nxI,nPos1] == dDataAtu .And. ;
		   		nxI <> n
   		   		MsgBox("A data informada ja existe no cadastro!","Dia Util","INFO")
   				lRet := .F.
	   		EndIf
	   EndIf
	   
	Next
	
EndIf

Return(lRet)