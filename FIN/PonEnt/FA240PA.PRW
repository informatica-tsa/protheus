/*
+----------+----------+-------+---------------------+-----+-----------------+
|Programa  |FA240PA   |Autor  |Thiago Victor  |Data |  08/11/2017           |
+----------+----------+-------+---------------------+-----+-----------------+
|Desc.     |O ponto de entrada FA240PA permite a seleção de PA com movimento|
|          |bancário na tela de Borderô de pagamento.                       |
|          |Chamado ao incluir o titulo de PA na rotina de manutenção de    |
|          |Borderô  (Retorno do chamado: #1634609)                                                       |
+----------+----------------------------------------------------------------+
|            ALTERACOES REALIZADAS DESDE A CRIACAO                          |
+----------+-------------+--------------------------------------------------+
| DATA     | PROGRAMADOR | DESCRICAO                                        |
+----------+-------------+--------------------------------------------------+
|          |             |                                                  |
+----------+-------------+--------------------------------------------------+
*/

#Include  'Protheus.ch'

User Function FA240PA()

	Local lRet  :=  .T. // .T. - para o sistema permitir a seleção de PA (com mov. Bancário) na tela de borderô de pagamento e
						// .F. - para não permitir.
	lRet :=  MsgYesNo("Deseja permitir a seleção de PA (com mov. Bancário) na tela de borderô de pagamento? ","Ponto de entrada: FA240PA")
	
Return lRet