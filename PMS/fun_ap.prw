#Include "Protheus.ch"  

/*
+-----------------------------------------------------------------------------+
| Programa  |DlgCPCust | Desenvolvedor | Marcelo A. Silva | Data | 25/11/2003 |
|-----------------------------------------------------------------------------|
| Descricao | Conferencia do pedido de venda liberado de credito/estoque      |
|-----------------------------------------------------------------------------|
| Uso       | Especifico EPC                                                  |
|-----------------------------------------------------------------------------|
|                  Modificacoes desde a construcao inicial                    |
|-----------------------------------------------------------------------------|
| Responsavel  | Data      | Motivo                                           |
|-----------------------------------------------------------------------------|
|              |           |                                                  | 
+--------------+-----------+--------------------------------------------------+
*/

User Function DlgCPCust(nOpcao,cNumCP)
/******************************************************************************
*
*
*************/


SetPrvt("NTOTPERC,NPOSPERC,NPOSITEM,NQUANTCP,CITEMCP,NPOSRAT")
SetPrvt("ASAVAROTINA,ASAVCOLS,ASAVHEADER,NSAVN,LGETDADOS,NQTMAXCP,oDlgCP")
SetPrvt("ACOLS,AHEADER,AHEADERAFL,NY,OGETDADOS,LOK")
SetPrvt("ARATAFL,N,nx")


lOk				:= .T.		
nTotPerc		:= 0
nPosPerc		:= 0
nPosItem		:= aScan(aHeader,{|x| Alltrim(x[2]) == "ZO_ITEM"})
nQuantCP		:= aCols[n][aScan(aHeader,{|x| Alltrim(x[2]) == "ZO_QUANT"})]
cItemCP			:= aCols[n][nPosItem]
nPosRat			:= aScan(aRatAFL,{|x| x[1] == aCols[n][nPosItem]})
aSavaRotina		:= aClone(aRotina)
aSavCols		:= aClone(aCols)
aSavHeader		:= aClone(aHeader)
nSavN			:= n
lGetDados		:= .T.
nQtMaxCP		:= nQuantCP
aCols	   		:= {}
aHeader			:= {}


If nOpcao == 3
	dbSelectArea("SX3")
	dbSetOrder(1)
	MsSeek("AFL")
	While !EOF() .And. (x3_arquivo == "AFL")
		IF X3USO(x3_usado) .AND. cNivel >= x3_nivel
			AADD(aHeader,{ TRIM(x3titulo()), x3_campo, x3_picture,;
				x3_tamanho, x3_decimal, x3_valid,;
				x3_usado, x3_tipo, x3_arquivo,x3_context } )
		Endif
		If AllTrim(x3_campo) == "AFL_QUANT"
			nPosPerc	:= Len(aHeader)
		EndIf
		dbSkip()
	End
	aHeaderAFL	:= aClone(aHeader)
	If nPosRat > 0
		aCols	:= aClone(aRatAFL[nPosRat][2])
	Else
		aadd(aCols,Array(Len(aHeader)+1))
		For ny := 1 to Len(aHeader)
			If Trim(aHeader[ny][2]) == "AFL_ITEM"
				aCols[1][ny] 	:= "01"
			Else
				aCols[1][ny] := CriaVar(aHeader[ny][2])
			EndIf
			aCols[1][Len(aHeader)+1] := .F.
		Next ny
	EndIf
Else
	dbSelectArea("SX3")
	dbSetOrder(1)
	MsSeek("AFL")
	While !EOF() .And. (x3_arquivo == "AFL")
		IF X3USO(x3_usado) .AND. cNivel >= x3_nivel
			AADD(aHeader,{ TRIM(x3titulo()), x3_campo, x3_picture,;
				x3_tamanho, x3_decimal, x3_valid,;
				x3_usado, x3_tipo, x3_arquivo,x3_context } )
		Endif
		If AllTrim(x3_campo) == "AFL_QUANT"
			nPosPerc	:= Len(aHeader)
		EndIf
		dbSkip()
	End
	aHeaderAFL	:= aClone(aHeader)
	dbSelectArea("AFL")
	dbSetOrder(2)
	If nPosRat == 0
		If MsSeek(xFilial()+cNumCP+cItemCP)
			While !Eof() .And. xFilial()+cNumCP+cItemCP==;
				AFL_FILIAL+AFL_NUMCP+AFL_ITEMCP
				aADD(aCols,Array(Len(aHeader)+1))
				For ny := 1 to Len(aHeader)
					If ( aHeader[ny][10] != "V")
						aCols[Len(aCols)][ny] := FieldGet(FieldPos(aHeader[ny][2]))
					Else
						aCols[Len(aCols)][ny] := CriaVar(aHeader[ny][2])
					EndIf
					aCols[Len(aCols)][Len(aHeader)+1] := .F.
				Next ny
				dbSkip()
			End
		Else
			aadd(aCols,Array(Len(aHeader)+1))
			For ny := 1 to Len(aHeader)
				If Trim(aHeader[ny][2]) == "AFL_ITEM"
					aCols[1][ny] 	:= "01"
				Else
					aCols[1][ny] := CriaVar(aHeader[ny][2])
				EndIf
				aCols[1][Len(aHeader)+1] := .F.
			Next ny
		EndIf
	Else
		aCols := aClone(aRatAFL[nPosRat][2])
	EndIf
EndIf


If lGetDados
	DEFINE FONT oBold NAME "Arial" SIZE 0, -13 BOLD
	Define MSDialog oDlgCP From 88 ,22  TO 350,619 Pixel Title OemToAnsi("Gerenciamento de Projetos - CP")
		oGetDados := MSGetDados():New(23,3,112,296,nOpcao,'PMSAFLLOK','PMSAFLTOK','+AFL_ITEM',.T.,,,,100,'PMSAFLFOK')
		@ 16 ,3   TO 18 ,310 LABEL '' OF oDlgCP PIXEL
		@ 6 ,10   SAY 'Num. CP' Of oDlgCP PIXEL SIZE 27 ,9 //
		@ 5 ,35  SAY  cNumCP+"/"+cItemCP Of oDlgCP PIXEL SIZE 40,9 FONT oBold
		@ 6 ,190  SAY 'Quantidade' Of oDlgCP PIXEL SIZE 31 ,9 //
		@ 5 ,230  MSGET nQuantCP Picture PesqPict('SZO','ZO_QUANT') When .F. PIXEL SIZE 50,9
		@ 118,249 BUTTON 'Confirma' SIZE 35 ,9   FONT oDlgCP:oFont ACTION {||(lOk:=.T.,oDlgCP:End()),(lOk:=.F.)}  OF oDlgCP PIXEL  // //{||If(oGetDados:TudoOk(),(lOk:=.T.,oDlgCP:End()),(lOk:=.F.))}  OF oDlgCP PIXEL  //
		@ 118,210 BUTTON 'Cancelar' SIZE 35 ,9   FONT oDlgCP:oFont ACTION (oDlgCP:End())  OF oDlgCP PIXEL  //
	ACTIVATE MSDIALOG oDlgCP 
EndIf

If nOpcao <> 2 .And. lOk
	If nPosRat > 0
		aRatAFL[nPosRat][2]	:= aClone(aCols)
	Else
		aADD(aRatAFL,{aSavCols[nSavN][nPosItem],aClone(aCols)})
	EndIf

EndIf

aCols	:= aClone(aSavCols)
aHeader	:= aClone(aSavHeader)
n		:= nSavN

Return 
