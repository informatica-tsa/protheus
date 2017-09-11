#Include 'RwMake.ch'
/*
+-----------------------------------------------------------------------+
¦Programa  ¦MTA094RO  ¦ Autor ¦ Gilson Lucas          ¦Data ¦19.09.2011¦
+----------+------------------------------------------------------------¦
¦Descricao ¦Adiciona impressao da ordem de compra na liberacao do PC    ¦
+----------+------------------------------------------------------------¦
¦ Uso      ¦ ESPECIFICO PARA A TSA                                      ¦
+-----------------------------------------------------------------------¦
¦           ATUALIZACOES SOFRIDAS DESDE A CONSTRUCAO INICIAL            ¦
+-----------------------------------------------------------------------¦
¦PROGRAMADOR  ¦ DATA   ¦ MOTIVO DA ALTERACAO                            ¦
+------------+--------+-------------------------------------------------¦
¦LEANDRO FARIA¦11/09/17¦ ALTERADO PONTO DE ENTRADA MTA097MNU PARA       ¦
¦             ¦        ¦ MTA094RO. MIGRAVACAO V12                       ¦
+-----------------------------------------------------------------------+
*/
User Function MTA094RO
*************************************************************************
*
**

Local aRotina:= PARAMIXB[1]

aAdd(aRotina,{OemToAnsi("Ordem de Compra"),'U_ImpOrdCr()',  0 , 2, 0, nil})

Return (aRotina)



User Function ImpOrdCr()
*************************************************************************
*
**
dbSelectArea("SC7")
SC7->(dbSetOrder(1))
SC7->(dbSeek(xFilial("SC7")+Alltrim(SCR->CR_NUM)))
If !SC7->(Eof())
   If MsgBox(OemToAnsi("Deseja imprimir ordem de compra?"),OemToAnsi("Atencao"),"YESNO",2)
      ExecBlock("PComGrf", .F., .F., { "SC7", SC7->(Recno()), 2 } )
   EndIf
EndIf

Return