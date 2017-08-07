#Include "RwMake.ch"
/*
+-----------------------------------------------------------------------+
¦Programa  ¦MT120BRW   ¦ Autor ¦ Gilson Lucas          ¦Data ¦19.08.2011¦
+----------+------------------------------------------------------------¦
¦Descricao ¦Envio de E-mail no pedido de compra            		   		¦
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
User Function MT120BRW
**************************************************************************
*
**
aAdd(aRotina,{"E-mail"   ,'U_MailLib()',0,4})
aAdd(aRotina,{"Inf Ad"   ,'U_WFW120P()',0,4})



Return


User Function MailLib()
**************************************************************************
*
**

If MsgBox("Deseja Enviar o e-mail para o aprovador ?","Atencao","YESNO",2)
   // Nao substituir o execblock. Chamada de ponto de entrada com passagem de paramxib.Nao funciona passagem por referencia.
   ExecBlock("MT097END",.F.,.F.,{SC7->C7_NUM,'',2})
EndIf

Return