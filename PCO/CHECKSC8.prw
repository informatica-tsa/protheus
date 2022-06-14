#Include 'Protheus.ch'
#Include 'FWMVCDef.ch'
#include 'fileio.ch
#include "rwmake.ch" 
/*
+-----------------------------------------------------------------------+
¦Programa  ¦           ¦ Autor ¦ Thiago Santos         ¦Data ¦01.04.2020¦
+----------+------------------------------------------------------------¦
¦Descricao ¦ Verifica se existe lançamento na AKD pela rotina de cotação¦
+----------+------------------------------------------------------------¦
¦ Uso      ¦ ESPECIFICO PARA A TSA                                      ¦
+-----------------------------------------------------------------------¦
¦           ATUALIZACOES SOFRIDAS DESDE A CONSTRUCAO INICIAL            ¦
+-----------------------------------------------------------------------¦
¦PROGRAMADOR ¦ DATA   ¦ MOTIVO DA ALTERACAO                             ¦
+------------+--------+-------------------------------------------------¦
¦            ¦        ¦                                                 ¦
+-----------------------------------------------------------------------+
*/
User function CHECKSC8

	Local aAreaOld := GetArea()
	Local nValor := IIF(!EMPTY(SC7->C7_NUMSC).AND.SC7->C7_XPCO=="S",POSICIONE("SC1",1,XFILIAL("SC1")+SC7->C7_NUMSC+SC7->C7_ITEMSC,"C1_QUANT")*SC1->C1_XVUNIT,0)
	Local nControl := 0
	Local cChave := ''
	
	//PROCURA NA TABELA DE COTAÇÃO PELO NUMERO DO PEDIDO, CASO A LINHA DO PEDIDO TENHA PERDIDO A REFERENCIA
	cQuery1  := "SELECT C8_NUMPED,C8_TOTAL,C8_FILIAL,C8_NUM,C8_FORNECE,C8_LOJA,C8_ITEM,C8_NUMPRO FROM "+RetSqlName("SC8")+" WHERE C8_NUMPED = '"+SC7->C7_NUM+"'  AND D_E_L_E_T_ = ''"
	dbUseArea(.T., "TOPCONN", TCGenQry(,,cQuery1), 'QRSC8', .F., .T.)
	DbSelectArea("QRSC8")
	DbGoTop()
	While !Eof()

		cChave := "SC8"+QRSC8->C8_FILIAL+QRSC8->C8_NUM+QRSC8->C8_FORNECE+QRSC8->C8_LOJA+QRSC8->C8_ITEM+QRSC8->C8_NUMPRO

		cQuery3  := "SELECT R_E_C_N_O_ FROM "+RetSqlName("AKD")+" WHERE AKD_CHAVE = '"+cChave+"'  AND D_E_L_E_T_ = ''"
		dbUseArea(.T., "TOPCONN", TCGenQry(,,cQuery3), 'QRAKD', .F., .T.)
		DbSelectArea("QRAKD")
		DbGoTop()

		while !Eof()
			nControl := nControl+1			
			cQuery2  := "UPDATE "+RetSqlName("AKD")+" SET D_E_L_E_T_ = '*' , R_E_C_D_E_L_ = R_E_C_N_O_  WHERE R_E_C_N_O_ = "+cvaltochar(QRAKD->R_E_C_N_O_)
			TCSQLExec(cQuery2)
			GravaLog("log_cust_remove_cotacao_alt_pedido-"+cEmpAnt+".log","Pedido: "+QRSC8->C8_NUMPED+" => Valor: "+cValToChar(QRSC8->C8_TOTAL)+" Item: "+QRSC8->C8_ITEM+" Cotacao: "+QRSC8->C8_NUM+" Chave: "+cChave+" Query: "+cQuery2 )
			
			DbSelectArea("QRAKD")
			DbSkip()
		EndDo			
		DbSelectArea("QRAKD")
		dbclosearea()


		DbSelectArea("QRSC8")
		DbSkip()
	EndDo

	if nControl == 0
		GravaLog("log_cust_remove_cotacao_alt_pedido-"+cEmpAnt+".log","Pedido: "+SC7->C7_NUM+" Item: "+SC7->C7_ITEM+" Cotacao: "+SC7->C7_NUMCOT+" => Nao foram encontrados itens para remover da AKD" )
	EndIf	
	
	/*Fechando e restaurando area*/
	DbSelectArea("QRSC8")
	dbclosearea()
	RestArea(aAreaOld)

return nValor


User Function CHECKSC7(nValor)

	Local nRvalor 	:= 0
	Local lControl 	:= .T.
	Local cChave 	:=  "SC7"+SC8->C8_FILIAL+SC8->C8_NUMPED+SC8->C8_ITEMPED

	//VERIFICA SE EXISTE LANCAMENTO NA AKD
	cQuery3  := "SELECT R_E_C_N_O_ FROM "+RetSqlName("AKD")+" WHERE AKD_CHAVE = '"+cChave+"'  AND D_E_L_E_T_ = ''"
	dbUseArea(.T., "TOPCONN", TCGenQry(,,cQuery3), 'QRAKD', .F., .T.)
	DbSelectArea("QRAKD")
	DbGoTop()

	while !Eof()
		lControl := .F.
		GravaLog("log_cust_remove_cotacao_alt_pedido-"+cEmpAnt+".log","Pedido: "+SC8->C8_NUMPED+" ItemPed: "+SC8->C8_ITEM+" Cotacao: "+SC8->C8_NUM+" Skip lancamento(Pedido ja existente na AKD pela SC7) " )
		DbSelectArea("QRAKD")
		DbSkip()
	EndDo			
	DbSelectArea("QRAKD")
	dbclosearea()

	nRvalor := IF(!EMPTY(SC8->C8_NUMSC) .AND. SC8->C8_XPCO=="S" .AND. lControl .AND. EMPTY(SC8->C8_ZPRJ), nValor ,0)

Return nRvalor


Static Function GravaLog(cArq,cMsg )
 	
	If !File(cArq)
		nHandle := FCreate(cArq)
	else
		nHandle := fopen(cArq , FO_READWRITE + FO_SHARED )
	Endif

	If nHandle == -1
		MsgStop('Erro de abertura : FERROR '+str(ferror(),4))
	Else
		FSeek(nHandle, 0, FS_END)         // Posiciona no fim do arquivo
		FWrite(nHandle, Dtoc(Date())+" - "+Time()+" : "+cUserName+" : "+cMsg+Chr(13)+Chr(10)) // Insere texto no arquivo
		fclose(nHandle)                   // Fecha arquivo
	Endif
	
 
return



User Function DCHECKSD1()

	Local dtsolic := POSICIONE("SC1",6,XFILIAL("SC1")+SD1->D1_PEDIDO+SD1->D1_ITEMPC,"C1_EMISSAO")
	Local dpedido := POSICIONE("SC7",1,XFILIAL("SC7")+SD1->D1_PEDIDO+SD1->D1_ITEMPC,"C7_DATPRF")
	Local dDate := IIF ;
					(;
						!EMPTY(SD1->D1_ITEMPC) .AND. SD1->D1_XPCO=="S",;
						IIF;
							( ;
								!EMPTY(dtsolic), dtsolic, dpedido;
							)  ,;
						D1_EMISSAO ;
					)

Return dDate


//TEMPORARIO
User Function CTBNFEDT()

	Local aItems:= {'DIGITACAO','EMISSAO'}
	Local lok := .F.
	Local   oFontCab  := TFont():New("Arial",10,,,.T.,,,,.F.,.F.)
	Local lRet:= .F.
	
	cCombo1:= aItems[1]
	DEFINE MSDIALOG oDlg TITLE "Definições Gerais" FROM 0,0 TO 100,250 OF oMainWnd Pixel
	
	TComboBox():New(010,005,{|U|if(PCount()>0,cCombo1:=U,cCombo1)},aItems,80,09,oDlg,,,,,,.T.,oFontCab,,,,,,,,"cCombo1")
	
	@ 01,05 Say "Informe por qual data deseja contabilizar" PIXEL OF oDlg
	
	DEFINE SBUTTON FROM 30, 10   TYPE 1 ENABLE OF oDlg ACTION (lOk:=.T.,oDlg:End())
	DEFINE SBUTTON FROM 30, 40   TYPE 2 ENABLE OF oDlg ACTION (lOk:=.F.,oDlg:End())
	ACTIVATE MSDIALOG oDlg CENTERED 

	if cCombo1 == 'DIGITACAO'
		lRet := .F.
	else
		lRet := .T.
	ENDIF

Return(lRet)

