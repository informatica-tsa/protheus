#Include "rwmake.ch"
#Include "colors.ch"
#Define  _CRLF CHR(13)+CHR(10)

/*
+------------+---------+--------------------------+--------+------------------+
| Programa   | WFW120P | Development by Carraro   |  Data  | 08/11/2001       |
+------------+---------+--------------------------+--------+------------------+
| Descricao  | Ponto de Entrada Para Gravacao dos Descritivos do Ped. Compra  |
+------------+----------------------------------------------------------------+
| Uso        | Exclusivo EPC                                                  |
+------------+----------------------------------------------------------------+
|                    Modificacoes Apos Desenvolvimento Inicial                |
+---------+-------------+-----------------------------------------------------+
|  Data   | Responsavel | Motivo                                              |
+---------+-------------+-----------------------------------------------------+
|05/08/03 |Crislei      |Para impressao dos novos itens Garantia e Instrucoes |
|         |             |de faturamento. Alteracao da ordem de digitacao con- |
|         |             |forme sequencia na impressao do relatorio de PC      |
+---------+-------------+-----------------------------------------------------+
|01/01/06 |Leo Alves    |A restrição foi tirada pela solicitação da Renata TSA|      
|         |             |Pois as mensagens so apareciam se a manutenção do pe |
|         |             |dido, fosse incluida pela propia rotina de geração de| 
|         |             |pedidos de compra, a manutenção de um pedido gerado  |
|         |             |pela rotina decotação não trazia as mensagens.       |
|         |             |Linha 121.                                           |
+---------+-------------+-----------------------------------------------------+
|21/06/11 |Gilson Lucas |Adequacoes para TSA eliminando referencias da EPC.   |
+---------+-------------+-----------------------------------------------------+
*/

User Function LimpaVar()

	/*Limpa as variáveis publicas para não manter lixo.*/
	IF TYPE ("aSC7Old") == "A" .And. TYPE ("aItenDiv") == "A" 
			aItenDiv := {}
			aSC7Old  := {}
	EndIf
	U_WFW120P()

return(.T.)

User Function WFW120P()

	Local aAreaOld := GetArea()
	Local aAreaSC7 := SC7->(GetArea())
	Local nXi := 0

	/*Valida se a variavel existe, pois se acessar o botao inf. Ad sem entrar no pedido a variável não vai existir*/
	IF TYPE ("aSC7Old") == "A"
		If  Funname() $ 'MATA121|ENCPEDC' 
			If Altera .and. !Empty(aSC7Old) .and. Empty(aItenDiv)
				dbSelectArea("SC7")
				For nXi := 1 To Len(aSC7Old)     
					SC7->(dbGoTo(aSC7Old[nXi][1]))
					If !SC7->(Eof())
						If RecLock("SC7",.F.)
							Replace C7_CONAPRO 	With aSC7Old[nXi][2]
							Replace C7_APROV 	With aSC7Old[nXi][3]
							SC7->(MsUnLock())
						EndIf
					EndIf
				Next nXi 
			EndIf
		EndIf
	EndIf
	
	/*Limpa as variáveis publicas para não manter lixo.*/
	aItenDiv := {}
	aSC7Old  := {}
	
	If l120Auto
		Return(.T.)
	Endif
	
	If MsgBox("Deseja carregar mensagens padrao do contrato?","Atencao","YESNO",2)
	   DialMsgFim()
	EndIf

	RestArea(aAreaOld)
	RestArea(aAreaSC7)

Return(.T.)



Static Function DialMsgFim()

	Local oDlg        
	Local lConfirm    := .F.
	Local aObjects 	  := {}
	Local aPosObj     := {}
	Local cMarCont    := Iif(!Empty(SC7->C7_MARCOS),SC7->C7_MARCOS,"")
	Local cEscopo     := Iif(!Empty(SC7->C7_ESCOPO),SC7->C7_ESCOPO,"")
	Local cCondGerais := Iif(!Empty(SC7->C7_CONDGER),SC7->C7_CONDGER,MemoRead( "\custom_files\cond_gerais\Cond_gerais.txt"))
	Local lFlatMode   := If(FindFunction("FLATMODE"),FlatMode(),SetMDIChild())
	Local aSize    	  := MsAdvSize(.T.,.F.,Iif(lFlatMode,330,300)) //(lEnchoiceBar,lTelaPadrao,ntamanho_linhas)
	Local aInfo    	  := {aSize[1],aSize[2],aSize[3],aSize[4],3,3}
	Local oFont       := TFont():New( "Arial",,14,,.T.,,,,.F.,.F. )
	Private cA120Num  := SC7->C7_NUM
	
	Aadd(aObjects,{010,030,.T.,.F.,.F.}) //{TamX,TamY,DimX,DimY,lDimensaoXeY}
	Aadd(aObjects,{010,050,.T.,.T.,.F.}) //{TamX,TamY,DimX,DimY,lDimensaoXeY}
	Aadd(aObjects,{010,050,.T.,.T.,.F.}) //{TamX,TamY,DimX,DimY,lDimensaoXeY}
	Aadd(aObjects,{010,100,.T.,.T.,.F.}) //{TamX,TamY,DimX,DimY,lDimensaoXeY}
	aPosObj := MsObjSize(aInfo,aObjects)
	
	oDlg:=MSDialog():New(aSize[7],0,aSize[6],aSize[5],OemToAnsi(cCadastro+" | OC: "+SC7->C7_NUM),,,,,,,,,.t.)
	oDlg:lEscClose  := .F. //Nao permite sair ao se pressionar a tecla ESC.
	oDlg:lMaximized := .T.
	
	TGroup():New(aPosObj[1,1],aPosObj[1,2]+05,aPosObj[1,3],(aPosObj[1,4]-aPosObj[1,2]-5),"",oDlg,,,.T.,.T.)
	TSay():New(aPosObj[1,1]+10,015,{|| OemToAnsi("Esta Rotina Tem o Intuito de Informar ao Sistema Os Detalhes Do Pedido de Compras Para Posterior Impressao, Caso Nao Sejam Necessarios Tais Detalhes Apenas Clique no Botao de Cancelamento.")},oDlg,,oFont,,,,.T.,,,560,050)
		
	TGroup():New(aPosObj[2,1],aPosObj[2,2]+05,aPosObj[2,3],(aPosObj[2,4]-aPosObj[2,2]-5),OemToAnsi("Escopo"),oDlg,,,.T.,.T.)
	TMultiGet():New(aPosObj[2][1]+10,aPosObj[2][2]+10,{|u|If(Pcount()>0,cEscopo:=u,cEscopo)},oDlg        ,(aPosObj[2][4]-aPosObj[2][2])-30,(aPosObj[2][3]-aPosObj[2][1])-30,,.T.,,,,.T.,,,,,,.F.,,,,.F.,.T.)
	
	TGroup():New(aPosObj[3,1],aPosObj[3,2]+05,aPosObj[3,3],(aPosObj[3,4]-aPosObj[3,2]-5),OemToAnsi("Marcos contratuais"),oDlg,,,.T.,.T.)
	TMultiGet():New(aPosObj[3][1]+10,aPosObj[3][2]+10,{|u|If(Pcount()>0,cMarCont:=u,cMarCont)},oDlg        ,(aPosObj[3][4]-aPosObj[3][2])-30,(aPosObj[3][3]-aPosObj[3][1])-30,,.T.,,,,.T.,,,,,,.F.,,,,.F.,.T.)
	
	
	TGroup():New(aPosObj[4,1],aPosObj[4,2]+05,aPosObj[4,3],(aPosObj[4,4]-aPosObj[4,2]-5),OemToAnsi("Condições Gerais"),oDlg,,,.T.,.T.)
	TMultiGet():New(aPosObj[4][1]+10,aPosObj[4][2]+10,{|u|If(Pcount()>0,cCondGerais:=u,cCondGerais)},oDlg,(aPosObj[4][4]-aPosObj[4][2])-30,(aPosObj[4][3]-aPosObj[4][1])-30,,.T.,,,,.T.,,,,,,.F.,,,,.F.,.T.)
	
	
	oDlg:Activate(,,,.t.,, EnchoiceBar(oDlg,{|| lConfirm := .T.,oDlg:End()   },{|| oDlg:End()},,{}))
	
	If lConfirm
	   dbSelectArea("SC7")
	   SC7->(dbSetOrder(1))
	   SC7->(dbSeek(xFilial("SC7")+cA120Num))
	   While !SC7->(Eof()) .And. SC7->(C7_FILIAL+C7_NUM) == xFilial("SC7")+cA120Num
	      If RecLock("SC7",.F.)
	         Replace C7_CONDGER With cCondGerais,;
	                 C7_ESCOPO  With cEscopo,;
	                 C7_MARCOS  With cMarCont
	         SC7->(MsUnlock())
	      EndIf 
	      SC7->(DbSkip())
	   EndDo
	EndIf

Return(.T.)
