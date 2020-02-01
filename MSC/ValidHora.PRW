/*
+---------+----------+------+----------------------------------+-------+---------+
|Programa |VALIDHORA |Autor | Crislei Toledo							| Data  | 07/05/02|	
+---------+----------+------+----------------------------------+-------+---------+
|Descricao| Validacao do numero de horas informadas pelo usuario						|
+--------------------------------------------------------------------------------+
|							Alteracoes feitas desde a criacao									|
+-------------+-----------+------------------------------------------------------+
|Programador  |Data       |Descricao															|
+-------------+-----------+------------------------------------------------------+
|				  |           |																		|
+-------------+-----------+------------------------------------------------------+
*/

#include "rwmake.ch"

User Function ValidHora()

Local   lRet      := .T.   
Local   cCodGerHr := GetMv("US_GRHREX")
Local 	nxJ := 0
Private cMes      := PARAMIXB[01]
Private cHoraFunc := "M->ZB_HrMes"+cMes
Private cHrFuncio := "ZB_HRMES"+cMes
Private nHoraFunc := 0
Private nTotaHora := 0
Private nSomaHora := 0
Private nSomHrFun := 0
Private cTotaHora := ""
Private cSetor := ""

nPosDesc := aScan(aHeader,{|aAux| Upper(Alltrim(aAux[2])) == "ZB_DESCRI"})
nPosHora := aScan(aHeader,{|aAux| Upper(Alltrim(aAux[2])) == cHrFuncio})

//Retirado a Pedido da Virginia em 11/12/2006

If cEmpAnt=='02' .And. GdFieldget("ZB_TIPO")$'F' .And. !Empty(GdFieldget("ZB_MATPJ"))
	cCodFun:=Posicione("SRA",1,'97'+GdFieldget("ZB_MATPJ"),"RA_MAT")
Else
	cCodFun:=AllTrim(aCols[n,nPosDesc])
Endif
If ((Alltrim(cCodGerHr)) #  Alltrim(GdFieldGet("ZB_GRUPGER",n)))
	nHoraFunc := ((Val(SubStr(AllTrim(&cHoraFunc),1,3))*60) + (Val(SubStr(AllTrim(&cHoraFunc),5,2))))/60
EndIf	

If FunName() == "CADAORC"
	nTotaHora := ExecBlock("CalcHora",.F.,.F.,{cCodFun,cMes+"/"+M->CANO})
	For nxJ := 1 To Len(aCols)
		If aCols[n,nPosDesc] == aCols[nxJ,nPosDesc] .And. ((Alltrim(cCodGerHr)) #  Alltrim(GdFieldGet("ZB_GRUPGER",nxJ)))
		
			If (nxJ == n) .or. (!Empty(GdFieldget("ZB_MATPJ")) .And. cCodFun<>GdFieldget("ZB_MATPJ",nxJ))
	 			nSomHrFun := 0                    
	 		Else
		 		nSomHrFun := ((Val(SubStr(AllTrim(aCols[nxJ,nPosHora]),1,3))*60) + (Val(SubStr(AllTrim(aCols[nxJ,nPosHora]),5,2))))/60
			EndIf		 		
	 		nSomaHora += nSomHrFun
		EndIf
	Next

	nSomaHora += nHoraFunc
 	
Else
	nTotaHora := ExecBlock("CalcHora",.F.,.F.,{AllTrim(cCodFun),cMes+"/"+M->CANO})
	For nxJ := 1 To Len(aCols)
		If nxJ == n
			nSomHrFun := 0
		Else
			nSomHrFun := ((Val(SubStr(AllTrim(aCols[nxJ,nPosHora]),1,3))*60) + (Val(SubStr(AllTrim(aCols[nxJ,nPosHora]),5,2))))/60
		EndIf
 		nSomaHora += nSomHrFun
	Next
	nSomaHora += nHoraFunc
EndIf
cTotaHora := ExecBlock("ConvHora",.F.,.F.,{nTotaHora})

If nHoraFunc > nTotaHora
	MsgBox("O numero de horas informado e superior ao total de horas do setor: " + cTotaHora,"Validacao","STOP")
	lRet := .F.
ElseIf nHoraFunc < nTotaHora
	If FunName() == "CADAORC" 
		If (Alltrim(cCodGerHr) #  Alltrim(GdFieldGet("ZB_GRUPGER",n)))
			MsgBox("O total de horas para este setor e: " + cTotaHora,"Informacao","INFO")
		EndIf	
	Else
		MsgBox("O total de horas para este setor e: " + cTotaHora,"Informacao","INFO")
	Endif
EndIf

If lRet .And. nSomaHora > nTotaHora
	MsgBox("Total de "+ExecBlock("ConvHora",.F.,.F.,{nSomaHora})+"Hrs lançadas para este colaborador e superior ao total de horas do setor: " + cTotaHora+"Hrs.","Inconsistencia","STOP")
	lRet := .F.
EndIf

Return(lRet)