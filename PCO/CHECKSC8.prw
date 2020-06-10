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

	If (!EMPTY(SC7->C7_NUMCOT))
		cQuery  := " UPDATE "+RetSqlName("AKD")+" SET D_E_L_E_T_ = '*' , R_E_C_D_E_L_ = R_E_C_N_O_  WHERE AKD_CHAVE LIKE 'SC8"+SC7->C7_FILIAL+SC7->C7_NUMCOT+"%'"
		TCSQLExec(cQuery)
		GravaLog("log_cust_remove_cotacao_alt_pedido-"+cEmpAnt+".log","Pedido: "+SC7->C7_NUM+" => Valor: "+cValToChar(nValor)+" Query: "+cQuery )
	Else
		GravaLog("log_cust_remove_cotacao_alt_pedido-"+cEmpAnt+".log","Pedido: "+SC7->C7_NUM+" => Sem cotação vinculada ao pedido." )
	EndIf
	
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