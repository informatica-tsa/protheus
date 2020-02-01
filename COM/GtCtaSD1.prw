/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³ GtCtaSD1 ³ Autor ³Crislei de A. Toledo   ³ Data ³06/02/2007³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡ao ³ Rotina para retornar a conta contabil de acordo com a TES  ³±±
±±³          ³ e o Item Contabil informado na NF de Entrada	              ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Especifico para EPC                                        ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

#include "rwmake.ch"

User Function GtCtaSD1(cAlias)

Local cRet := ""
Local aArqAnt := {Alias(), IndexOrd(), Recno()}
Local aArqSB1 := {"SB1", SB1->(IndexOrd()), SB1->(Recno())}
Local aArqSF4 := {"SF4", SF4->(IndexOrd()), SF4->(Recno())}
Local aArqCTT := {"CTT", CTT->(IndexOrd()), CTT->(Recno())}

Local nPosProd	 := 0
Local nPosTES 	 := 0
Local nPosItCta := 0

Do Case
	Case cAlias $ "SD1"
		nPosProd	:= aScan(aHeader,{|x| Alltrim(x[2]) == "D1_COD"})
		nPosTES		:= aScan(aHeader,{|x| Alltrim(x[2]) == "D1_TES"})
		nPosItCta	:= aScan(aHeader,{|x| Alltrim(x[2]) == "D1_ITEMCTA"})
	Case cAlias $ "SC7"
		nPosProd	:= aScan(aHeader,{|x| Alltrim(x[2]) == "C7_PRODUTO"})
		nPosTES		:= aScan(aHeader,{|x| Alltrim(x[2]) == "C7_TES"})
		nPosItCta	:= aScan(aHeader,{|x| Alltrim(x[2]) == "C7_ITEMCTA"})
EndCase

If Posicione("SF4",1,xFilial("SF4")+aCols[1,nPosTES],"F4_ESTOQUE") $ "S" //se atualiza estoque
	cRet := Posicione("SB1",1,xFilial("SB1")+aCols[1,nPosProd],"B1_CONTA") //retorna B1_CONTA
Else
	If XFILIAL(cAlias) >= "20" .AND. XFILIAL(cAlias) <= "90"
		cRet := SUBSTR(Posicione("SB1",1,xFilial("SB1")+aCols[1,nPosProd],"B1_CTACEI"),1,4)+STRZERO(VAL(XFILIAL(cAlias))-19,2)+SUBSTR(Posicione("SB1",1,xFilial("SB1")+aCols[1,nPosProd],"B1_CTACEI"),7,4) //retorna conta do CEI
	Else
		If Posicione("CTD",1,xFilial("CTD")+aCols[1,nPosItCta],"CTD_CLASSI") $ "D" //Se nao atualiza estoque e o item contabil e de despesa
			cRet := Posicione("SB1",1,xFilial("SB1")+aCols[1,nPosProd],"B1_CTADESP")//retorna B1_CTADESP
		Else //Se nao atualiza estoque e o Item contabil e custo direto/indireto
			cRet := Posicione("SB1",1,xFilial("SB1")+aCols[1,nPosProd],"B1_CTACONS") //retorna B1_CTACONS
		EndIf
	EndIf
	//	If cAlias = "SD1"
	//	EndIf
EndIf
dbSelectArea(aArqCTT[01])
dbSetOrder(aArqCTT[02])
dbGoTo(aArqCTT[03])

dbSelectArea(aArqSF4[01])
dbSetOrder(aArqSF4[02])
dbGoTo(aArqSF4[03])

dbSelectArea(aArqSB1[01])
dbSetOrder(aArqSB1[02])
dbGoTo(aArqSB1[03])

dbSelectArea(aArqAnt[01])
dbSetOrder(aArqAnt[02])
dbGoTo(aArqAnt[03])

Return(cRet)