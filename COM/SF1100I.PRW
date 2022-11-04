/*
+-----------------------------------------------------------------------+
¦Programa  ¦ SF1100I  ¦ Autor ¦ Crislei de A. Toledo  ¦ Data ¦20.03.2006¦
+----------+------------------------------------------------------------¦
¦Descriçào ¦ Ponto de Entrada gravacao da NF de Entrada                 ¦
+----------+------------------------------------------------------------¦
¦ Uso      ¦ ESPECIFICO PARA CBM                                        ¦
+-----------------------------------------------------------------------¦
¦           ATUALIZACOES SOFRIDAS DESDE A CONSTRUCAO INICIAL            ¦
+-----------------------------------------------------------------------¦
¦PROGRAMADOR ¦ DATA   ¦ MOTIVO DA ALTERACAO                             ¦
+------------+--------+-------------------------------------------------¦
¦            ¦        ¦                                                 ¦
+------------+--------+-------------------------------------------------+
*/
#Include "Protheus.ch"
#INCLUDE "Rwmake.ch"
#include "Topconn.ch"
#include "ap5mail.ch"

User Function SF1100I()

Local aAliasAnt:={Alias(),IndexOrd(),RecNo()}
Local aAliasSE2:={SE2->(IndexOrd()),SE2->(Recno())}
Local aAliasSD1:={SD1->(IndexOrd()),SD1->(Recno())}
Local aAliasSA2:={SA2->(IndexOrd()),SA2->(Recno())}
Local aAliasSA6:={SA6->(IndexOrd()),SA6->(Recno())}
Local aAliasSF1:={SF1->(IndexOrd()),SF1->(Recno())}
Local aAliasSF3:={SF3->(IndexOrd()),SF3->(Recno())}
Local aAliasSFT:={SFT->(IndexOrd()),SFT->(Recno())}
Local nVretIss := 0
Local nVretPis := 0
Local nVretCof := 0
Local nVretCsl := 0
Local nVretSes := 0
Local cHistF1 := Space(TamSx3("E2_HIST")[1])
Local oFont    := TFont():New( "Times New Roman",,16,,.T.,,,,.F.,.F. )
Local oDlgPar := nil
Local oBar := nil
Local lOk := .f.

Private cCadastro := "Observação"

If !EMPTY(SF1->F1_DUPL)
	cHistF1 := "CTO"
	dbSelectArea("SD1")
	dbSetOrder(1)
	dbSeek(xFilial("SD1")+SF1->F1_DOC+SF1->F1_SERIE+SF1->F1_FORNECE+SF1->F1_LOJA)
	
	While (!Eof())                             .And. ;
		(SD1->D1_FILIAL  == xFilial("SD1"))  .And. ;
		(SD1->D1_DOC     == SF1->F1_DOC)     .And. ;
		(SD1->D1_SERIE   == SF1->F1_SERIE)   .And. ;
		(SD1->D1_FORNECE == SF1->F1_FORNECE) .And. ;
		(SD1->D1_LOJA    == SF1->F1_LOJA)
		cHistF1 := SUBSTR(ALLTRIM(cHistF1)+"-"+ALLTRIM(SD1->D1_ITEMCTA)+Space(TamSx3("E2_HIST")[1]-Len(ALLTRIM(cHistF1)+"-"+ALLTRIM(SD1->D1_ITEMCTA))),1,TamSx3("E2_HIST")[1])
		dbskip()
	EndDo
	
	oDlgPar := MSDialog():New(000,000,115,350,OemToAnsi('Observação'),,,,nOR(WS_VISIBLE,WS_POPUP),CLR_BLACK,CLR_WHITE,,,.T.,,,)
	//    oDlgPar:=MSDialog():New(000,000,115,350,OemToAnsi("Observação"),,,,,CLR_BLACK,CLR_WHITE,,,.T.)
	oDlgPar:lEscClose:=.F.  //Nao permite sair ao se pressionar a tecla ESC.
	
	oBar:=tBar():New(oDlgPar,,,.t.,,,,.f.)
	TBtnBmp():NewBar("OK"    ,,,,OemToAnsi("Confirma"),{|| lOk:=.t.,oDlgPar:End()},,oBar,,,,,,,,,,,,)
	//    TBtnBmp():NewBar("CANCEL",,,,OemToAnsi("Cancela") ,{|| lOk:=.f.,oDlgPar:End()},,oBar,,,OemToAnsi("Sai da Rotina"),,,,,,,,,)
	
	TGroup():New(015,005,050,172,"",oDlgPar,,,.T.,.T.)
	TSay():New(022,010,{|| OemToAnsi("Informar o Histórico do Título a Pagar.")},oDlgPar,,oFont,,,,.T.,,,280,050)
	TSay():New(037,010,{|| OemToAnsi("Histórico:") },oDlgPar,,oFont,,,,.T.,,,280,050)
	TGet():New(035,055,{|u| if(PCount()>0,cHistF1:=u,cHistF1)}, oDlgPar, 100, 10, , {|| ! Empty(cHistF1) }, CLR_HBLUE, CLR_WHITE,,,,.T.,,,{|| .t. },,,/*CHANGE*/,.F.,.F.,,"cHistF1")
	
	oDlgPar:Activate(,,,.T.,{|| AllwaysTrue() },,)

EndIf

If SF1->F1_TIPO <> "D"
	//Verifica se gerou titulo em SE2 E GRAVA DADOS COMPLEMENTARES
	dbSelectArea("SE2")
	dbSetOrder(6) //E2_FILIAL+E2_FORNECE+E2_LOJA+E2_PREFIXO+E2_NUM+E2_PARCELA+E2_TIPO
	If dbSeek(xFilial("SE2")+SF1->F1_FORNECE+SF1->F1_LOJA+SF1->F1_SERIE+SF1->F1_DOC,.T.)
		While ! Eof()                             .And. ;
			SE2->E2_Filial  == xFilial("SE2")   .And. ;
			SE2->E2_PREFIXO == SF1->F1_SERIE    .And. ;
			SE2->E2_NUM     == SF1->F1_DOC      .And. ;
			SE2->E2_FORNECE == SF1->F1_FORNECE  .And. ;
			SE2->E2_LOJA    == SF1->F1_LOJA
			
			nVretPis += SE2->E2_VRETPIS
			nVretCof += SE2->E2_VRETCOF
			nVretCsl += SE2->E2_VRETCSL
			nVretIss += SE2->E2_ISS
			nVretSes += SE2->E2_SEST
			
			//POSICIONA SD1 NO PRIMEIRO ITEM DA NF PARA GRAVAR A DATA DE REFERENCIA NO TITTULO NO CONTAS A PAGAR.
			dbSelectArea("SD1")
			dbSetOrder(1)
			dbSeek(xFilial("SD1")+SF1->F1_DOC+SF1->F1_SERIE+SF1->F1_FORNECE+SF1->F1_LOJA,.T.)
			
			//ATUALIZA O CAMPO E2_NOMEFOR COM O NOME DO FORNECEDOR POIS O SISTEMA GRAVA O NOME FANTASIA.
			//POSICIONA SA2 PARA BUSCAR O NOME DO FORNECEDOR.
			dbSelectArea("SA2")
			dbSetOrder(1)
			dbSeek(xFilial("SA2")+SF1->F1_FORNECE+SF1->F1_LOJA)
			
			If RecLock("SE2",.F.)
				Replace E2_NOMFOR  With SA2->A2_NOME
				If SF1->F1_EMISSAO > GetMv("MV_ULMES")
					Replace E2_EMIS1   With SF1->F1_EMISSAO
				EndIf
				Replace E2_DATAREF With SD1->D1_DTREF
				Replace E2_ALIQISS With Iif(SE2->E2_ISS <> 0,SD1->D1_ALIQISS,0)
				If !EMPTY(SF1->F1_DUPL)
					Replace E2_HIST With Upper(cHistF1)
				EndIf
				MsUnlock()
			EndIf
			
			//Verifica Cada título de imposto gerado, gravando a Conta Contabil referente ao codigo de retencao.
			FAtuCodRet()
			
			dbSelectArea("SE2")
			dbSkip()
		EndDo
	EndIf
EndIf

//Atualiza cabeçalho da NF com os valores a serem retidos de ISS, PIS, COFINS e CSLL
//SF1 - CABECALHO DAS NF’S DE ENTRADA
dbSelectArea("SF1")
If RecLock("SF1",.F.)

	Replace SF1->F1_DTENT   With SF1->F1_DTDIGIT
	
	/*If SF1->F1_EMISSAO > GetMv("MV_ULMES") //data de fechamento do estoque
		
		Replace SF1->F1_DTDIGIT With SF1->F1_EMISSAO
		
		// SFT - ITENS DOS LIVROS FISCAIS
		dbSelectArea("SFT")
		dbSetOrder(1)
		dbSeek(xFilial("SFT")+"E"+SF1->F1_SERIE+SF1->F1_DOC+SF1->F1_FORNECE+SF1->F1_LOJA)
		While (!Eof()) .And. SF1->F1_FORNECE = SFT->FT_CLIEFOR  .And. SF1->F1_LOJA = SFT->FT_LOJA  .And. SF1->F1_FILIAL = SFT->FT_FILIAL .And. SF1->F1_DOC = SFT->FT_NFISCAL  .And. SF1->F1_SERIE = SFT->FT_SERIE .And. SFT->FT_TIPOMOV = 'E'  
			If RecLock ("SFT", .F.)
				Replace SFT->FT_ENTRADA With SF1->F1_EMISSAO
			EndIf
			MsUnlock()
			
			dbSkip()
		EndDo

		// SF3 - LIVROS FISCAIS
		dbSelectArea("SF3")
		dbSetOrder(4)
		dbSeek(xFilial("SF3")+SF1->F1_FORNECE+SF1->F1_LOJA+SF1->F1_DOC+SF1->F1_SERIE)
		While (!Eof()) .And. SF1->F1_FORNECE = SF3->F3_CLIEFOR  .And. SF1->F1_LOJA = SF3->F3_LOJA  .And. SF1->F1_FILIAL = SF3->F3_FILIAL .And. SF1->F1_DOC = SF3->F3_NFISCAL  .And. SF1->F1_SERIE = SF3->F3_SERIE
			If RecLock ("SF3", .F.)
				Replace SF3->F3_ENTRADA With SF1->F1_EMISSAO
			EndIf
			MsUnlock()
			
			dbSkip()
		EndDo
	EndIf*/
	
	Replace SF1->F1_VRETISS With nVretIss
	Replace SF1->F1_VRETPIS With nVretPis
	Replace SF1->F1_VRETCOF With nVretCof
	Replace SF1->F1_VRETCSL With nVretCsl
	Replace SF1->F1_VRETSES With nVretSes
	
	If !EMPTY(SF1->F1_DUPL)
		Replace SF1->F1_HISTORI  With Upper(cHistF1)
	EndIf
	MsUnlock()
EndIf


lContAut:=.t. //Chama tela de contabilizacao ao sair da mata103
If Empty(dDataDe) .Or. SF1->F1_DTDIGIT < dDataDe
	dDataDe := SF1->F1_DTDIGIT
EndIf

If Empty(dDataAte) .Or. SF1->F1_DTDIGIT > dDataAte
	dDataAte := SF1->F1_DTDIGIT
EndIf


//Verifica se deve enviar e-mail para fornecedor (Caso de PJ's)
dbSelectArea("SA2")
dbSetOrder(1)
dbSeek(xFilial("SA2")+SF1->F1_FORNECE+SF1->F1_LOJA)
If !Eof()
	If SA2->A2_SERVTEC $ "S"
		FSendMail()
	EndIf
EndIf


//Retorna Ambiente
DbSelectArea("SA2")
DbSetOrder(aAliasSA2[1])
DbGoTo(aAliasSA2[2])

DbSelectArea("SA6")
DbSetOrder(aAliasSA6[1])
DbGoTo(aAliasSA6[2])

DbSelectArea("SE2")
DbSetOrder(aAliasSE2[1])
DbGoTo(aAliasSE2[2])

DbSelectArea("SF1")
DbSetOrder(aAliasSF1[1])
DbGoTo(aAliasSF1[2])

DbSelectArea("SF3")
DbSetOrder(aAliasSF3[1])
DbGoTo(aAliasSF3[2])

DbSelectArea("SD1")
DbSetOrder(aAliasSD1[1])
DbGoTo(aAliasSD1[2])

DbSelectArea("SFT")
DbSetOrder(aAliasSFT[1])
DbGoTo(aAliasSFT[2])

DbSelectArea(aAliasAnt[1])
DbSetOrder(aAliasAnt[2])
DbGoTo(aAliasAnt[3])

Return


Static Function FSendMail()
***************************************************************************************************************
* Envio de e-mail para fornecedores (PJ)
*
****

Local cCabec    := ""
Local cTexto    := ""
Local cRoda     := ""
Local cCtaMail  := ""
Local cAccount  := GetMv("MV_WFACC")
Local cCtaPass  := GetMv("MV_WFPASSW")
Local cCtaSmpt  := GetMv("MV_WFSMTP")
Local cSendBy   := GetMv("MV_MAILPJ") //PARAMETRO CRIADO PARA ARMAZENAR O E-MAIL DOS PRESTADORES DE SERVICOS TECNICOS.

dbSelectArea("SA2")
If !Empty(AllTrim(SA2->A2_EMAIL))
	cCtaMail  := AllTrim(SA2->A2_EMAIL)
Else
	//Se o fornecedor, não tiver e-mail cadastrado, retorna sem o envio do e-mail.
	Return()
Endif

dbSelectArea("SE2")
dbSetOrder(6) //E2_FILIAL+E2_FORNECE+E2_LOJA+E2_PREFIXO+E2_NUM+E2_PARCELA+E2_TIPO
dbSeek(xFilial("SE2")+SF1->F1_FORNECE+SF1->F1_LOJA+SF1->F1_SERIE+SF1->F1_DOC,.T.)

dbSelectArea("SA6")
dbSetOrder(1)
dbSeek(xFilial("SA6")+SA2->A2_BANCO)

cCabec := 'Prezado Fornecedor <br><br>'
/*
cTexto := 'Informamos que o pagamento da Nota Fiscal número ' + SF1->F1_DOC + ' de '
cTexto += DTOC(SF1->F1_EMISSAO) + ' no valor líquido de R$ ' + Transform(SE2->E2_VALOR,"@E 999,999,999.99")
cTexto += ' está programado para o dia ' + DTOC(SE2->E2_VENCREA) + '. <br><br>'
cTexto += 'O pagamento será efetuado no Banco: ' + SA2->A2_BANCO + ' - ' + SA6->A6_NOME + '<br>'
cTexto += 'Agencia: ' + SA2->A2_AGENCIA + '<br>'
cTexto += 'Conta Corrente: ' + SA2->A2_NUMCON + '<br><br>'
cTexto += 'Lembramos que caso os dados para crédito em conta estejam incorretos ou em branco, favor reenviá-los para o e-mail: '
cTexto += '<a href="mailto:tesourariapj@epcbh.com.br">tesouraria_pj@epcbh.com.br</a>, imediatamente. <br><br> '
*/

cTexto := 'Informamos que o pagamento da Nota Fiscal número ' + SF1->F1_DOC + ' de '
cTexto += DTOC(SF1->F1_EMISSAO) + '<br> '
cTexto += '<b>Valor Bruto:</b> R$ ' + Transform(SF1->F1_VALBRUT,"@E 999,999,999.99")
cTexto += ' está programado para o dia ' + DTOC(SE2->E2_VENCREA) + '. <br><br>'
cTexto += '<b>Foram retidos os seguintes impostos:</b> <br><br>
If SE2->E2_ISS > 0
	cTexto += '<b>ISS:</b> R$ ' + Transform(SE2->E2_ISS,"@E 999,999,999.99") + '<br>'
EndIf

If SE2->E2_IRRF > 0
	cTexto += '<b>IRRF:</b> R$ ' + Transform(SE2->E2_IRRF,"@E 999,999,999.99") + '<br>'
EndIf

If SE2->E2_INSS > 0
	cTexto += '<b>INSS:</b> R$ ' + Transform(SE2->E2_VRETPIS,"@E 999,999,999.99") + '<br>'
EndIf

If SE2->E2_VRETPIS > 0
	cTexto += '<b>PIS:</b> R$ ' + Transform(SE2->E2_VRETPIS,"@E 999,999,999.99") + '<br>'
EndIf

If SE2->E2_VRETCOF > 0
	cTexto += '<b>COFINS:</b> R$ ' + Transform(SE2->E2_VRETCOF,"@E 999,999,999.99") + '<br>'
EndIf

If SE2->E2_VRETCSL > 0
	cTexto += '<b>CSLL:</b> R$ ' + Transform(SE2->E2_VRETCSL,"@E 999,999,999.99") + '<br><br>'
EndIf

cTexto += 'O pagamento no Valor líquido de R$ ' + Transform(SE2->E2_VALOR,"@E 999,999,999.99") + ' será efetuado no Banco: ' + SA2->A2_BANCO + ' - ' + SA6->A6_NOME + ','
cTexto += ' Agencia: ' + SA2->A2_AGENCIA + ', '
cTexto += 'Conta Corrente: ' + SA2->A2_NUMCON + '<br><br>'
cTexto += 'Lembramos que caso os dados para crédito em conta estejam incorretos ou em branco, favor reenviá-los para o e-mail: '
cTexto += '<a href="mailto:jdalmo@tsamg.com.br">jdalmo@tsamg.com.br</a>, imediatamente. <br><br> '

cRoda := 'Atenciosamente, <br>'
cRoda += 'Andreia Ramos Batista <br>'
cRoda += 'Tesouraria '


CONNECT SMTP SERVER cCtaSmpt ACCOUNT cAccount PASSWORD cCtaPass
SEND MAIL FROM  cSendBy TO  cCtaMail ;
SUBJECT 'PAGAMENTO DE PRESTADORES DE SERVICOS TECNICOS' ;
BODY ;
cCabec  + '<br>' + ;
cTexto  + '<br>' + ;
cRoda   + '<br>'
DISCONNECT SMTP SERVER

Return


Static Function FAtuCodRet()
***************************************************************************************************************
* Atualiza conta contabil de Titulos de Impostos de acordo com o codigo de retencao informado no titulo
* referente ao imposto
****

Local aArqSE2   := {"SE2",SE2->(IndexOrd()), SE2->(Recno())}
Local cParcIRF  := ""
Local cParcPIS  := ""
Local cParcCOF  := ""
Local cParcCSL  := ""
Local cParcISS  := ""
Local cNumeNF   := ""
Local cSeriNF   := ""
Local cFornTX   := GetMV("MV_UNIAO")
Local cFornISS  := GetMV("MV_MUNIC")
Local dDataRF   := CTOD("")
Local dDtEmis1  := CTOD("")
Local nAliqISS  := 0


//Localiza parcelas referentes aos impostos
cNumeNF  := SE2->E2_NUM
cSeriNF  := SE2->E2_PREFIXO
cParcIRF := SE2->E2_PARCIR
cParcPIS := SE2->E2_PARCPIS
cParcCOF := SE2->E2_PARCCOF
cParcCSL := SE2->E2_PARCSLL
cParcISS := SE2->E2_PARCISS
dDataRF  := SE2->E2_DATAREF
dDtEmis1 := SE2->E2_EMIS1
nAliqISS := SE2->E2_ALIQISS

//Localiza titulo de IR
dbSelectArea("SE2")
dbSetOrder(1)
If dbSeek(xFilial("SE2")+cSeriNF+cNumeNF+cParcIRF+"TX "+cFornTX)
	If RecLock("SE2",.F.)
		Replace E2_CCONTAB With Tabela("Z0",SE2->E2_CODRET,.F.)
		Replace E2_DATAREF With dDataRF
		Replace E2_EMIS1   With dDtEmis1
		MsUnlock()
	EndIf
EndIf

//Localiza titulo de PIS
dbSelectArea("SE2")
dbSetOrder(1)
If dbSeek(xFilial("SE2")+cSeriNF+cNumeNF+cParcPIS+"TX "+cFornTX)
	If RecLock("SE2",.F.)
		Replace E2_CCONTAB With Tabela("Z0",SE2->E2_CODRET,.F.)
		Replace E2_DATAREF With dDataRF
		Replace E2_EMIS1   With dDtEmis1
		MsUnlock()
	EndIf
EndIf

//Localiza titulo de COFINS
dbSelectArea("SE2")
dbSetOrder(1)
If dbSeek(xFilial("SE2")+cSeriNF+cNumeNF+cParcCOF+"TX "+cFornTX)
	If RecLock("SE2",.F.)
		Replace E2_CCONTAB With Tabela("Z0",SE2->E2_CODRET,.F.)
		Replace E2_DATAREF With dDataRF
		Replace E2_EMIS1   With dDtEmis1
		MsUnlock()
	EndIf
EndIf

//Localiza titulo de CSLL
dbSelectArea("SE2")
dbSetOrder(1)
If dbSeek(xFilial("SE2")+cSeriNF+cNumeNF+cParcCSL+"TX "+cFornTX)
	If RecLock("SE2",.F.)
		Replace E2_CCONTAB With Tabela("Z0",SE2->E2_CODRET,.F.)
		Replace E2_DATAREF With dDataRF
		Replace E2_EMIS1   With dDtEmis1
		MsUnlock()
	EndIf
EndIf


//Localiza titulo de ISS
dbSelectArea("SE2")
dbSetOrder(1)
If dbSeek(xFilial("SE2")+cSeriNF+cNumeNF+cParcISS+"ISS"+cFornISS)
	If RecLock("SE2",.F.)
		Replace E2_DATAREF With dDataRF
		Replace E2_ALIQISS With nAliqISS
		MsUnlock()
	EndIf
EndIf


dbSelectArea(aArqSE2[01])
dbSetOrder(aArqSE2[02])
dbGoTo(aArqSE2[03])

Return
