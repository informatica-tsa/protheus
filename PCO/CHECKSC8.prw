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
Local nValor := 0 

	If (!EMPTY(SC7->C7_NUMCOT))
		cQuery  := " UPDATE "+RetSqlName("AKD")+" SET D_E_L_E_T_ = '*' , R_E_C_D_E_L_ = R_E_C_N_O_  WHERE AKD_CHAVE LIKE 'SC8"+SC7->C7_FILIAL+SC7->C7_NUMCOT+"%'"
		TCSQLExec(cQuery)
		GravaLog("log_cust_remove_cotacao_alt_pedido-"+cEmpAnt+".log","Pedido: "+SC7->C7_NUM+" => Valor: "+cValToChar(SC7->C7_TOTAL)+" Item: "+SC7->C7_ITEM+" Query: "+cQuery )
	Else
		dbSelectArea("SC8")
		dbSetOrder(1)
		dbSeek(Xfilial("SC8")+SC7->C7_NUM)
		
		if !Eof() .And. SC8->C8_NUMPED = SC7->C7_NUM
			cQuery  := " UPDATE "+RetSqlName("AKD")+" SET D_E_L_E_T_ = '*' , R_E_C_D_E_L_ = R_E_C_N_O_  WHERE AKD_CHAVE LIKE 'SC8"+SC8->C8_FILIAL+SC8->C8_NUM+"%'"
			TCSQLExec(cQuery)
			GravaLog("log_cust_remove_cotacao_alt_pedido-"+cEmpAnt+".log","Pedido: "+SC7->C7_NUM+"Cotacao localizada: "+SC8->C8_NUM+" Item: "+SC7->C7_ITEM+" Cotacao: "+SC7->C7_NUMCOT+" Query: "+cQuery )
		Else			
			GravaLog("log_cust_remove_cotacao_alt_pedido-"+cEmpAnt+".log","Pedido: "+SC7->C7_NUM+" Item: "+SC7->C7_ITEM+" Cotacao: "+SC7->C7_NUMCOT+" => Sem cotacao vinculada ao pedido." )
		EndIf
		
		DBCloseArea()

	EndIf
	
	nValor := IIF(!EMPTY(SC7->C7_NUMSC).AND.SC7->C7_XPCO=="S",POSICIONE("SC1",1,XFILIAL("SC1")+SC7->C7_NUMSC+SC7->C7_ITEMSC,"C1_QUANT")*SC1->C1_XVUNIT,0)
	
RestArea(aAreaOld)

return nValor


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