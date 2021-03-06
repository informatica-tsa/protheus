/*
+----------------------------------------------------------------------------+
�Programa  � F050ALT  � Autor � Crislei de Almeida Toledo  � Data �21.02.2006�
+----------+-----------------------------------------------------------------+
�Descri��o � Ponto de Entrada na rotina de Alteracao de Contas a Pagar       �
�          � Validacao do campo E2_DIRF e E2_CODRET                          �
+----------+-----------------------------------------------------------------+
� Uso      � ESPECIFICO PARA EPC                                             �
+----------------------------------------------------------------------------+
�           ATUALIZACOES SOFRIDAS DESDE A CONSTRUCAO INICIAL                 �
+----------------------------------------------------------------------------+
�PROGRAMADOR � DATA   � MOTIVO DA ALTERACAO                                  �
+------------+--------+------------------------------------------------------+
�            �        �                                                      |
+----------------------------------------------------------------------------+
*/

#INCLUDE "RWMAKE.CH"

User Function FA050ALT()

Local lRet    := .T.

/*
//Valida��o para n�o permitir inclus�o ou altera��o do titulo sem informar o codigo de reten�ao 
//se o campo Gera Dirf for igual a Sim.
If M->E2_DIRF $ "1"
   If AllTrim(M->E2_CODRET) == ""
      MsgBox(OemToAnsi("O campo 'Cd. Reten��o' precisa ser informado quando o campo 'Gera Dirf' for igual a 'Sim'."),"Gera Dirf","STOP")
      lRet := .F.
   EndIf
EndIf
*/

Return(lRet)