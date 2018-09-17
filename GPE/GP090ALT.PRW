#INCLUDE "PROTHEUS.CH"
#include "topconn.ch"  
#include "Ap5mail.ch"  
                                                                          
/* 
 * @Descrição
 *			   	Permite realizar o rateio das horas na tabela FIPEPC de acordo com as verbas cadastradas
 *			   	Depende da consulta SZ2_CO que retorna o número do contrato formatado no formato 
 *			   	A0000-00-0000A       
 * @Alterado por: Leandro P J Monteiro 		leandro@cntecnologia.com.br		
 * @Alterações	17/07/2013 Alterado o fonte para permitir a inserção de novos registros no FIPEPC 
 * @Alterações  31/07/2013 Alterado para considerar horas fracionadas
 * @Alterações  25/10/2013 Alterado para chamar a Função RATFIP01.prw, que é unica entre os lançamentos
 * 				mensais (SRC) e lançamentos de Rescisão(SRR)
 * @Alterações  03/11/2016 Remoção de blocos não utilizados do PRW. ThiagoSantos
 ****************************************************************************************/
User Function GP090ALT
	
	TelaIni()
	 
Return


Static Function TelaIni()

	Local cTypeRgb := Space(3)
	Local aItems:= {'FOL','RES'}
	Local lok := .F.
	Local   oFontCab  := TFont():New("Arial",10,,,.T.,,,,.F.,.F.) 
	
	cCombo1:= aItems[1]
	DEFINE MSDIALOG oDlg TITLE "Definições Gerais" FROM 0,0 TO 100,250 OF oMainWnd Pixel
	
	TComboBox():New(010,005,{|U|if(PCount()>0,cCombo1:=U,cCombo1)},aItems,80,09,oDlg,,,,,,.T.,oFontCab,,,,,,,,"cCombo1")
	
	@ 01,05 Say "Informe se é recisão ou Folha" PIXEL OF oDlg
	//@ 10,05 Get cTypeRgb Valid !Empty(cTypeRgb) PIXEL OF oDlg
	
	DEFINE SBUTTON FROM 30, 10   TYPE 1 ENABLE OF oDlg ACTION (oDlg:End(),U_RatFip01("RGB",cCombo1),lOk:=.T.)
	DEFINE SBUTTON FROM 30, 40   TYPE 2 ENABLE OF oDlg ACTION (lOk:=.F.,oDlg:End())
	ACTIVATE MSDIALOG oDlg CENTERED 

Return(lOk)
