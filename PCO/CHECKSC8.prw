#Include 'RwMake.ch'
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

	cQuery  := " UPDATE "+RetSqlName("AKD")
	cQuery  += " SET D_E_L_E_T_ = '*' , R_E_C_D_E_L_ = R_E_C_N_O_ "
 	cQuery  += " WHERE AKD_CHAVE LIKE 'SC8"+SC7->C7_FILIAL+SC7->C7_NUMCOT+"%'"
 	  
	TCSQLExec(cQuery)

RestArea(aAreaOld)

return nValor