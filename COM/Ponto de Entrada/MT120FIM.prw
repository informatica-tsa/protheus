#Include "Rwmake.ch"
/*
+-----------+------------+----------------+------------------+--------+------------+
| Programa  | MT120FIM   | Desenvolvedor  | Thiago Santos	 | Data   | 23/08/2017 |
+-----------+------------+----------------+------------------+--------+------------+
| Descricao | PONTO DE ENTRADA - EXCLUI PEDIDO NA SCR 		                       |
+-----------+----------------------------------------------------------------------+
| Uso       | Especifico TSA                                                   |
+-----------+----------------------------------------------------------------------+
|                   Modificacoes Apos Desenvolvimento Inicial                      |
+-------------+---------+----------------------------------------------------------+
| Humano      | Data    | Motivo                                                   |
| THIGO SANTOS|23/08/17	| CORREÇÃO DE FUNÇÃO TCSQLNAME => TCSQLEXEC
+-------------+---------+----------------------------------------------------------+
+-------------+---------+----------------------------------------------------------+
*/

User Function MT120FIM()
	Local aPar   := Paramixb
	Local cQuery := ""
	
	If aPar[1] == 5 .And. aPar[3] == 1
	   cQuery := "UPDATE "+RetSqlName("SCR") +" SET D_E_L_E_T_ = '*' "
	   cQuery += " WHERE CR_FILIAL = '"+xFilial("SCR")+"'"
	   cQuery += " AND CR_NUM = '"+aPar[2]+"'"   
	   cQuery += " AND D_E_L_E_T_ = ''"
	   TcSqlExec(cQuery)
	   TcRefresh(RetSqlName("SCR"))
	EndIf

Return