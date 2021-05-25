#Include 'Protheus.ch'
#Include 'ParmType.ch'


//+------------+------------+--------+--------------------------------------------+
//| Função:    | xFormula   | Autor: | David Alves dos Santos                     | 
//+------------+------------+--------+--------------------------------------------+
//| Descrição: | Rotina para execução de funções dentro do Protheus.              |
//+------------+------------------------------------------------------------------+
//|------------------------> SigaMDI.net - Cursos Online <------------------------|
//+-------------------------------------------------------------------------------+
User Function xFormula()
	
	//-> Declaração de variáveis.
	Local bError 
	Local cGet1Frm := PadR("Ex.: u_NomeFuncao() ", 50)
	Local oDlg1Frm := Nil
	Local oSay1Frm := Nil
	Local oGet1Frm := Nil
	Local oBtn1Frm := Nil
	Local oBtn2Frm := Nil
	
	//-> Recupera e/ou define um bloco de código para ser avaliado quando ocorrer um erro em tempo de execução.
	bError := ErrorBlock( {|e| cError := e:Description } ) //, Break(e) } )
	
	//-> Inicia sequencia.
	BEGIN SEQUENCE
	
		//-> Construção da interface.
		oDlg1Frm := MSDialog():New( 091, 232, 225, 574, "SigaMDI.net | Fórmulas" ,,, .F.,,,,,, .T.,,, .T. )
		
		//-> Rótulo. 
		oSay1Frm := TSay():New( 008 ,008 ,{ || "Informe a sua função aqui:" } ,oDlg1Frm ,,,.F. ,.F. ,.F. ,.T. ,CLR_BLACK ,CLR_WHITE ,084 ,008 )
		
		//-> Campo.
		oGet1Frm := TGet():New( 020 ,008 ,{ | u | If( PCount() == 0 ,cGet1Frm ,cGet1Frm := u ) } ,oDlg1Frm ,150 ,008 ,'!@' ,,CLR_BLACK ,CLR_WHITE ,,,,.T. ,"" ,,,.F. ,.F. ,,.F. ,.F. ,"" ,"cGet1Frm" ,,)
		
		//-> Botões.
		oBtn1Frm := TButton():New( 040 ,008 ,"Executar" ,oDlg1Frm ,{ || &(cGet1Frm)    } ,037 ,012 ,,,,.T. ,,"" ,,,,.F. )
		oBtn2Frm := TButton():New( 040 ,120 ,"Sair"     ,oDlg1Frm ,{ || oDlg1Frm:End() } ,037 ,012 ,,,,.T. ,,"" ,,,,.F. )
		
		//-> Ativação da interface.
		oDlg1Frm:Activate( ,,,.T.)
	
	RECOVER
		
		//-> Recupera e apresenta o erro.
		ErrorBlock( bError )
		MsgStop( cError )
		
	END SEQUENCE
	
Return

User Function zValidaDate(dData,nMeses,lPast,lFuture,lDay)
	lRet := .T.
	dDataA := Date()

	if (VALTYPE(dData) == "D" .OR. VALTYPE(dData) == "C")		

		if (VALTYPE(dData) == "C")
			dData := CTOD(dData)
		EndIf

		if cValtoChar(dData) != "  /  /  "

			if(lDay)
				cAnoMesD := dData
				cAnoMesA := dDataA
			else
				cAnoMesD := strZero(YEAR(dData),4)+strZero(MONTH(dData),2)
				cAnoMesA := strZero(YEAR(dDataA),4)+strZero(MONTH(dDataA),2)
			EndIf
			

			//permite somente lancamentos no dia
			If( !lPast .and. !lFuture)
				If( cAnoMesD != cAnoMesA )
					MSGALERT("Data digitada fora do mês atual")
					lRet := .F.
				EndIf
			elseIf( !lPast)
				If( cAnoMesD != cAnoMesA .and. dData < dDataA )
					MSGALERT("Data no passado fora do mês atual não é permitido!")
					lRet := .F.
				EndIf
			elseIf( !lFuture)
				If( cAnoMesD != cAnoMesA .and. dData > dDataA )
					MSGALERT("Data no futuro fora do mês atual não é permitido!")
					lRet := .F.
				EndIf
			EndIf

			If( lPast )
				If( dData < MonthSub( dDataA, nMeses ) ) 
					MSGALERT("Data digita ultrapassa o limite permitido de "+cValtoChar(nMeses)+" mes(es) no passado")
					lRet := .F.
				EndIf
			EndIf

			If( lFuture )
				If( dData > MonthSum( dDataA, nMeses ) )
					MSGALERT("Data digita ultrapassa o limite permitido de "+cValtoChar(nMeses)+" mes(es) no futuro.")
					lRet := .F.
				EndIf
			EndIf
		else
			lRet := .F.
		EndIf
	else
		lRet := .F.
	EndIf

Return lRet


User Function  zVParcial()

Local aAreaOld  := GetArea()
Local aAreaSC7  := SC7->(GetArea())
Local nPosPrd    := aScan(aHeader,{|x| AllTrim(x[2]) == 'C7_PRODUTO'})
Local nPosItem    := aScan(aHeader,{|x| AllTrim(x[2]) == 'C7_ITEM'})
Local lValido := .T.

dbSelectArea('SC7')
dbSetOrder(4)
If MsSeek(xFilial('SC7')+aCols[n][nPosPrd]+cA120Num+aCols[n][nPosItem])
	If (C7_QUJE > 0) .Or. (C7_RESIDUO == 'S') .Or. (C7_QTDACLA > 0) 
		MSGALERT("Dt. de entrega desta linha não pode ser alterada, pois encontra-se Atendida, Parcialmente atendida, como pre-nota ou saldo eliminado.")         
		lValido := .F.     
	EndIf
EndIf 

RestArea(aAreaOld)
RestArea(aAreaSC7)

Return(lValido) 

User Function  zVAltSD1()

Local nPosPed    := aScan(aHeader,{|x| AllTrim(x[2]) == 'D1_PEDIDO'})
Local nPosXpco    := aScan(aHeader,{|x| AllTrim(x[2]) == 'D1_XPCO'})
Local lValido := .T.


	If (!EMPTY(aCols[n][nPosPed]) .AND. aCols[n][nPosXpco]=="S") 
		MSGALERT("Dt. de referência,Subconta e C.Custo desta linha não pode ser alterada, pois está amarrada ao pedido de compras. Alteração somente no pedido.")         
		lValido := .F.     
	EndIf


Return(lValido) 

User Function ValidaBloq(cTpSald)

	//PEGA INFORMAÇÃO DE APROVAÇÃO DA LINHA DO PEDIDO, POIS NÃO ESTA NA ACOLS
	Local cAprov := POSICIONE("SC7",1,XFILIAL("SC7")+CA120NUM+GDFIELDGET("C7_ITEM")+GDFIELDGET("C7_SEQUEN"),"C7_CONAPRO")
	Local nValor := 0

	//VERIFICA O TIPO PARA AVALIAR O RETORNO
	if cTpSald = "PR"
		nValor := IIF(!EMPTY(GDFIELDGET("C7_NUMSC")).AND.(GDFIELDGET("C7_XPCO1")=="S") .AND. (cAprov != "L") ,POSICIONE("SC1",1,XFILIAL("SC1")+GDFIELDGET("C7_NUMSC")+GDFIELDGET("C7_ITEMSC"),"C1_QUANT")*SC1->C1_XVUNIT,0)
	elseIf	cTpSald = "EM"
		nValor := IIF(!EMPTY(GDFIELDGET("C7_NUMSC")).AND.(GDFIELDGET("C7_XPCO1")=="S") .AND. (cAprov != "L") ,GDFIELDGET("C7_TOTAL") +GDFIELDGET("C7_VALIPI")+GDFIELDGET("C7_DESPESA")+GDFIELDGET("C7_VALFRE")-GDFIELDGET("C7_VLDESC"),0)
	EndIf
	
Return nValor





