/*
+-----------------------------------------------------------------------+
¦Programa  ¦ LP666CTA ¦ Autor ¦ CRISLEI TOLEDO        ¦ Data ¦20.12.2006¦
+----------+------------------------------------------------------------¦
¦Descriçào ¦ RETORNA A CONTA CONTABIL DE ACORDO COM AS REGRAS DE CONTABI¦
¦          ¦ LIZACAO                                                    ¦
+----------+------------------------------------------------------------¦
¦ Uso      ¦ ESPECIFICO                                                 ¦
+-----------------------------------------------------------------------¦
¦           ATUALIZACOES SOFRIDAS DESDE A CONSTRUCAO INICIAL            ¦
+-----------------------------------------------------------------------¦
¦PROGRAMADOR ¦ DATA   ¦ MOTIVO DA ALTERACAO                             ¦
+------------+--------+-------------------------------------------------¦
+-----------------------------------------------------------------------+
*/

#INCLUDE "rwmake.ch"

User Function LP666CTA()

Local cRet := ""
Local cClasItm := ""

cClasItm := POSICIONE("CTD",1,XFilial("CTD")+SD3->D3_ITEMCTA,"CTD_CLASSI")

If xFilial("SD3") >= "20" .AND. xFilial("SD3") <= "90"
   If SB1->(FieldPos("B1_CTCEIES")) > 0
      cRet := SUBSTR(Posicione("SB1",1,xFilial("SB1")+SD3->D3_COD,"B1_CTCEIES"),1,4)+STRZERO(VAL(XFILIAL("SD3"))-19,2)+SUBSTR(Posicione("SB1",1,xFilial("SB1")+SD3->D3_COD,"B1_CTCEIES"),7,4) //retorna conta do CEI
   Endif
Else
   If cClasItm $ "D"
      cRet := POSICIONE("SB1",1,Xfilial("SB1")+SD3->D3_COD,"B1_CTADESP")
   ElseIf !EMPTY(SD3->D3_OP) .AND. LEFT(SD3->D3_CF,2) == 'RE'
      cRet := "1181030004" // REGRA ADICIONADA A PEDIDO DO GLEISON EM 11/09/2019 JUNTAMENTE COM HEMERSON. 
   Else
      cRet := POSICIONE("SB1",1,Xfilial("SB1")+SD3->D3_COD,"B1_CTACONS")
   EndIf
EndIf
   
Return(cRet)