/*
+----------+----------+-------+---------------------+-----+-----------------+
|Programa  |FA240PA   |Autor  |Thiago Victor  |Data |  08/11/2017           |
+----------+----------+-------+---------------------+-----+-----------------+
|Desc.     |O ponto de entrada FA240PA permite a sele��o de PA com movimento|
|          |banc�rio na tela de Border� de pagamento.                       |
|          |Chamado ao incluir o titulo de PA na rotina de manuten��o de    |
|          |Border�  (Retorno do chamado: #1634609)                                                       |
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

	Local lRet  :=  .T. // .T. - para o sistema permitir a sele��o de PA (com mov. Banc�rio) na tela de border� de pagamento e
						// .F. - para n�o permitir.
	lRet :=  MsgYesNo("Deseja permitir a sele��o de PA (com mov. Banc�rio) na tela de border� de pagamento? ","Ponto de entrada: FA240PA")
	
Return lRet