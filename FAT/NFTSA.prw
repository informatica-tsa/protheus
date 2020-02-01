#Include "rwmake.ch"      

/*
+-----------------+------------------------+----------------------+
|Programa: NFTSA  | Autor: Leonardo Alves  |Data: 14/03/2006      |
+-----------+-----------------------------------------------------+
|Descrição: |Nota Fiscal Entrada e saida da TSA                   |
+-----------+-----------------------------------------------------+
|Uso:       |Especifico da TSA                                    |
+-----------------------------------------------------------------+
|*************** ALTERAÇÕES APOS O DESENVOLVIMENTO ***************|  
+-----------------------------------------------------------------+
|Data     |Desenvovedor  |Motivo da Alteração                     |
+---------+--------------+----------------------------------------+
|05/05/06 |Daniel More.  |Ajustes em toda a NF                    |
+---------+--------------+----------------------------------------+
*/

User Function NFTSA()
/**************************************************************
*
*
*************/

Local cDesc1  := OemToAnsi("Este programa irá emitir a Nota Fiscal de Entrada/Saída")
Local cDesc2  := OemToAnsi("de produtos")
Local cDesc3  := ""
Local cPerg   := "NFTSAF"
Local cString := "SF2"
Local wnrel   := "NFTSAF"
Local aPerg  :={}

Private cTitulo  := OemToAnsi("Nota Fiscal de Entrada/Saída")
Private NomeProg := "NFTSAF"
Private Limite   := 220
private nLastKey := 0
Private nLinha   := 0
Private aReturn  := { OemToAnsi("Zebrado"), 1,OemToAnsi("Administracao"), 4, 2, 1, "",1 }
Private cNotaInic := ""
Private cNotaFina := ""
Private cSeriNtFi := ""
Private nTipoNtFi := 0
Private cMsg1Item := ""

Private cArqTrab1
Private cArqTrab2
Private cArqTrab3

Private aFaturas   := {}
Private aCodiFiOP  := {}
Private lAchou     := .F.

If nTipoNtFi == 0   

	AADD(aPerg,{cPerg,"Nota de        ?","C",06,0,"G","","SF2","","","","",""})
	AADD(aPerg,{cPerg,"Nota Até       ?","C",06,0,"G","","SF2","","","","",""})
	AADD(aPerg,{cPerg,"Serie          ?","C",03,0,"G","","","","","","",""})
	AADD(aPerg,{cPerg,"Tipo de Nota   ?","N",06,0,"C","","","Entrada","Saida","","",""})
//	AADD(aPerg,{cPerg,"Obs 1º Item    ?","C",60,0,"G","","","","","","",""})
	

	
	Pergunte(cPerg,.F.)
	
	wnrel := SetPrint(cString,wnrel,cPerg,@cTitulo,cDesc1,cDesc2,cDesc3,.T.,"",,"G")
	If (nLastKey == 27)
		Return
	EndIf
	cNotaInic := Mv_Par01
	cNotaFina := Mv_Par02
	cSeriNtFi := Mv_Par03
	nTipoNtFi := Mv_Par04
	cMsg1Item := Mv_Par05
Else 
	wnrel := SetPrint(cString,wnrel,""/*cPerg*/,@cTitulo,cDesc1,cDesc2,cDesc3,.T.,"",,"G")	
	If (nLastKey == 27)
		Return
	Endif
	nTipoFilt := 1
	cNotaInic := cNotaImp
	cNotaFina := cNotaImp
	cSeriNtFi := cSeriNtFi
	nTipoNtFi := nTipoNot
Endif

SetDefault(aReturn,cString)
		
If (nLastKey == 27)
	Return
Endif


FGravTrab()

If !Empty(cNotaFina)	
	If lAchou == .T.
		RptStatus({|lEnd| FImpNota(@lEnd,wnRel,cString)},"Aguarde","Emitindo Notas...")
	EndIf
EndIf

Set Device To Screen
Set Filter To

SetPgEject(.F.)

If aReturn[5] == 1
	Set Printer TO
	dbcommitAll()
	ourspool(wnrel)
Endif

MS_FLUSH()

If Select("TRBI") <> 0
	dbSelectArea("TRBI")
	dbCloseArea()
	FErase(cArqTrab1+".*")
EndIf

If Select("TRBC") <> 0
	dbSelectArea("TRBC")
	dbCloseArea()
	FErase(cArqTrab2+".*")
EndIf

If Select("TRBF") <> 0
	dbSelectArea("TRBF")
	dbCloseArea()
	FErase(cArqTrab3+".*")
EndIf

Return



Static Function FCriaTrab()
/*************************************************************************************
* Cria os arquivos de trabalho
*
*******/
Local aTempStru := {}

Aadd(aTempStru,{"NumeNtFi","C",009,0})
Aadd(aTempStru,{"SeriNtFi","C",003,0})
Aadd(aTempStru,{"CodiProd","C",007,0}) 
Aadd(aTempStru,{"DescProd","C",350,0})
Aadd(aTempStru,{"NumeLote","C",007,0}) 
Aadd(aTempStru,{"DataVali","D",008,0})
Aadd(aTempStru,{"ClasFisc","C",003,0})
Aadd(aTempStru,{"CodiUnid","C",002,0})
Aadd(aTempStru,{"QtdeProd","N",005,0})
Aadd(aTempStru,{"ValrUnit","N",011,2})
Aadd(aTempStru,{"ValrTota","N",011,2})
Aadd(aTempStru,{"PercICMS","N",002,0})
Aadd(aTempStru,{"PercICMR","N",002,0})
Aadd(aTempStru,{"PercIPI" ,"N",002,0})
Aadd(aTempStru,{"ValrIPI" ,"N",011,2})
Aadd(aTempStru,{"CodiTes" ,"C",003,0})
Aadd(aTempStru,{"CodiFiOP","C",004,0})
Aadd(aTempStru,{"TotaDola","N",014,2})
Aadd(aTempStru,{"Tipo"    ,"C",002,0})

cArqTrab1 := CriaTrab(aTempStru,.T.)

dbUseArea( .T.,, cArqTrab1, "TRBI",.F.,.F.)
IndRegua("TRBI",cArqTrab1,"NumeNtFi+SeriNtFi+CodiProd+NumeLote",,,"Selecionando Registros...")

aTempStru := {}

Aadd(aTempStru,{"DescNtFi","N",014,02})
Aadd(aTempStru,{"NumeNtFi","C",009,00})
Aadd(aTempStru,{"SeriNtFi","C",003,00})
Aadd(aTempStru,{"CodiTes" ,"C",003,00})
Aadd(aTempStru,{"CodiFiOP","C",004,00})
Aadd(aTempStru,{"DataEmis","D",008,00})
Aadd(aTempStru,{"MenNota" ,"C",200,00})
Aadd(aTempStru,{"Contrato","C",006,00})
Aadd(aTempStru,{"Obra"    ,"C",060,00})
Aadd(aTempStru,{"Disposi" ,"C",060,00})
Aadd(aTempStru,{"MenNot2" ,"C",200,00})
Aadd(aTempStru,{"ValrNota","N",011,02})
Aadd(aTempStru,{"TipoClFo","C",001,00})
Aadd(aTempStru,{"CodiClFo","C",006,00})
Aadd(aTempStru,{"LojaClFo","C",002,00})
Aadd(aTempStru,{"CodiPedi","C",006,00})
Aadd(aTempStru,{"CodiTran","C",006,00})
Aadd(aTempStru,{"ValrSegu","N",011,02})
Aadd(aTempStru,{"ValrOutr","N",011,02})
Aadd(aTempStru,{"ValrDesp","N",011,02})
Aadd(aTempStru,{"ValrFret","N",011,02})
Aadd(aTempStru,{"ValrArma","N",011,02})
Aadd(aTempStru,{"ValDespa","N",011,02})
Aadd(aTempStru,{"BCalICMS","N",011,02})
Aadd(aTempStru,{"BCalIPI" ,"N",011,02})
Aadd(aTempStru,{"ValrICMS","N",011,02})
Aadd(aTempStru,{"BaseICMR","N",011,02})
Aadd(aTempStru,{"ValrICMR","N",011,02})
Aadd(aTempStru,{"ValrIPI" ,"N",011,02})
Aadd(aTempStru,{"ValrMerc","N",011,02})
Aadd(aTempStru,{"NumeDupl","C",006,00})
Aadd(aTempStru,{"CondPaga","C",003,00})
Aadd(aTempStru,{"CodVend" ,"C",006,00})
Aadd(aTempStru,{"NomVend" ,"C",040,00})
Aadd(aTempStru,{"LogVend" ,"C",040,00})
Aadd(aTempStru,{"BaiVend" ,"C",020,00})
Aadd(aTempStru,{"CidVend" ,"C",015,00})
Aadd(aTempStru,{"EstVend" ,"C",002,00})
Aadd(aTempStru,{"PesoBrut","N",009,02})
Aadd(aTempStru,{"PesoLiqu","N",009,02})
Aadd(aTempStru,{"TipoClie","C",001,00})
Aadd(aTempStru,{"TipoEsp1","C",010,00})
Aadd(aTempStru,{"TipoEsp2","C",010,00})
Aadd(aTempStru,{"QtdeVolu","N",005,00})
Aadd(aTempStru,{"Tipo"    ,"C",001,00})
Aadd(aTempStru,{"Especie" ,"C",005,00})
Aadd(aTempStru,{"ListPedi","C",060,00})

cArqTrab2 := CriaTrab(aTempStru,.T.)

dbUseArea( .T.,, cArqTrab2, "TRBC",.F.,.F.)
IndRegua("TRBC",cArqTrab2,"NumeNtFi+SeriNtFi",,,"Selecionando Registros...")

aTempStru := {}

Aadd(aTempStru,{"NumeNtFi","C",09,0})
Aadd(aTempStru,{"SeriNtFi","C",03,0})
Aadd(aTempStru,{"NumeDupl","C",06,0})
Aadd(aTempStru,{"NumeParc","C",01,0})
Aadd(aTempStru,{"DataVenc","D",08,0})
Aadd(aTempStru,{"ValrDupl","N",17,2})
Aadd(aTempStru,{"ValrTota","N",17,2})

cArqTrab3 := CriaTrab(aTempStru,.T.)

dbUseArea( .T.,, cArqTrab3, "TRBF",.F.,.F.)
IndRegua("TRBF",cArqTrab3,"NumeNtFi+SeriNtFi+NumeParc",,,"Selecionando Registros...")

Return



Static Function FGravTrab()
/*************************************************************************************
* Grava os dados no arquivo de trabalho
*
*******/

Private lFirst      := .T.
Private aArraPedi   := {}
Private cCodiPedi   := ""
Private cListPedi   := ""
Private cMenNota    := ""
Private cMenNot2    := ""
Private aClasFisc := {}

If (nTipoNtFi == 2) // Saida


	dbSelectArea("SF2")
	dbSetOrder(1)
	dbSeek(xFilial("SF2")+cNotaInic,.T.)
	
	While (!Eof())                           .And. ;
	  (SF2->F2_FILIAL == xFilial("SF2")) .And. ;
	  	  (SF2->F2_DOC    <= cNotaFina)
	    
		    	  
		/*******************************************
		 *Se Achou e  a primeira entrada no loop,  *
		 *entao cria arquivo de trabalho           *
		 *******************************************/       
		If lAchou == .F.
			FCriaTrab() 
		EndIf
		    	  
		lAchou := .T.
		FGravaNFS()
		
		dbSelectArea("SF2")
		dbSkip()
	EndDo

Else //Entrada
	dbSelectArea("SF1")
	dbSetOrder(1)
	dbSeek(xFilial("SF1")+cNotaInic,.T.)
	
	While (!Eof())                           .And. ;
		  (SF1->F1_FILIAL == xFilial("SF1")) .And. ;
		  (SF1->F1_DOC    <= cNotaFina)
	      
	      If Upper(SF1->F1_FORMUL) != 'S'
	         SF1->(dbSkip())
	         Loop
	      EndIf
       /*******************************************
        *Se Achou e  a primeira entrada no loop,  *
       	*entao cria arquivo de trabalho           *
	    *******************************************/      
        If lAchou == .F.
			FCriaTrab()		
		EndIf
		lAchou   := .T.
		cMenNota := ""
		
		dbSelectArea("SD1")
		dbSetOrder(1)
		dbSeek(xFilial("SD1")+SF1->F1_DOC+SF1->F1_SERIE+SF1->F1_FORNECE+SF1->F1_LOJA)
		
		While (!Eof())                             .And. ;
			  (SD1->D1_FILIAL  == xFilial("SD1"))  .And. ;
			  (SD1->D1_DOC     == SF1->F1_DOC)     .And. ;
			  (SD1->D1_SERIE   == SF1->F1_SERIE)   .And. ;
			  (SD1->D1_FORNECE == SF1->F1_FORNECE) .And. ;
			  (SD1->D1_LOJA    == SF1->F1_LOJA)
			
			dbSelectArea("SB1")
			dbSetOrder(1)
			dbSeek(xFilial("SB1")+SD1->D1_COD)
			
			dbSelectArea("TRBI")
			dbSetOrder(1)
			dbSeek(SF1->F1_DOC+SF1->F1_SERIE+SD1->D1_COD)
			
//			If Eof()
				TRBI->(dbAppend())
				Replace NumeNtFi With SD1->D1_DOC
				Replace SeriNtFi With SD1->D1_SERIE
				Replace CodiProd With SD1->D1_COD
				Replace DescProd With AllTrim(SB1->B1_DESC)
				Replace ClasFisc With SB1->B1_CLASFIS
				Replace CodiUnid With SB1->B1_UM
				Replace PercICMS With SD1->D1_PICM
				Replace PercIPI  With SD1->D1_IPI
				Replace ValrIPI  With SD1->D1_ValIPI
				Replace CodiTes  With SD1->D1_TES
				Replace CodiFiOP With SD1->D1_CF
				Replace QtdeProd With SD1->D1_QUANT
				Replace ValrUnit With SD1->D1_VUNIT
				Replace ValrTota With SD1->D1_TOTAL
//			Else
//				Replace QtdeProd With TRBI->QtdeProd + SD1->D1_QUANT
//				Replace ValrTota With TRBI->ValrTota + SD1->D1_TOTAL
//			EndIf
			
			cCodiPedi := SD1->D1_PEDIDO
			cCodiTes  := SD1->D1_TES
			cCodiFiOP := SD1->D1_CF
			
			If Ascan(aCodiFiOP,cCodiFiOP) == 0 .AND. cCodiFiOp <> ""
				AADD(aCodiFiOP,cCodiFiOP)						
			EndIf
			
			If Ascan(aClasFisc,SB1->B1_CLASFIS) == 0 .AND. (! SB1->B1_CLASFIS $ "01_02")
				AADD(aClasFisc,SB1->B1_CLASFIS)
			EndIf
			
			dbSelectArea("SD1")
			dbskip()
		EndDo
		
		dbSelectArea("SE1")
		dbSetOrder(1)
		dbSeek(xFilial("SE1")+SF1->F1_PREFIXO+SF1->F1_DUPL)
		
		While (!Eof())                             .And. ;
			  (SE1->E1_FILIAL  == xFilial("SE1"))  .And. ;
			  (SE1->E1_PREFIXO == SF1->F1_PREFIXO) .And. ;
			  (SE1->E1_NUM     == SF1->F1_DUPL)
			
			If (!("NF" $ SE1->E1_TIPO))				
				dbSelectArea("SE1")
				dbSkip()
				Loop
			Endif
			
			dbSelectArea("TRBF")
			TRBF->(dbAppend())
			
			Replace NumeNtFi With SF1->F1_DOC
			Replace SeriNtFi With SF1->F1_SERIE
			Replace NumeDupl With SF1->F1_DUPL
			Replace NumeParc With SE1->E1_PARCELA
			Replace DataVenc With SE1->E1_VENCTO
			Replace ValrDupl With SE1->E1_VALOR
			Replace ValrTota With ValrTota+SE1->E1_VALOR
			
			dbSelectArea("SE1")
			dbSkip()
		EndDo
		
		dbSelectArea("TRBC")
		TRBC->(dbAppend())
		
		Replace MenNota   With Left(cMenNota,Len(cMenNota)-3)
		Replace NumeNtFi  With SF1->F1_DOC
		Replace SeriNtFi  With SF1->F1_SERIE
		Replace CodiTes   With cCodiTes
		Replace CodiFiOP  With cCodiFiOP
		Replace DataEmis  With SF1->F1_EMISSAO
		Replace ValrNota  With SF1->F1_VALBRUT
		Replace CodiClFo  With SF1->F1_FORNECE
		Replace LojaClFo  With SF1->F1_LOJA
		Replace CodiTran  With ""
		Replace CodiPedi  With cCodiPedi
		Replace ValrSegu  With SF1->F1_SEGURO
		Replace ValrFret  With SF1->F1_FRETE
		Replace BCalICMS  With SF1->F1_BASEICM
		Replace ValrICMS  With SF1->F1_VALICM
		Replace ValrOutr  With 0
		Replace ValrDesp  With SF1->F1_DESPESA
		Replace BaseICMR  With 0
		Replace ValrICMR  With 0
		Replace BCalIPI   With SF1->F1_BASEIPI
		Replace ValrIPI   With SF1->F1_VALIPI
		Replace ValrMerc  With SF1->F1_VALMerc
		Replace NumeDupl  With SF1->F1_DUPL
		Replace CondPaga  With SF1->F1_COND
		Replace Especie   With SF1->F1_ESPECIE
		Replace PesoBrut  With 0
		Replace PesoLiqu  With 0
		Replace TipoEsp1  With ""
		Replace TipoEsp2  With ""
		Replace QtdeVolu  With 0
		
		If (SF2->F2_TIPO == "D")
			Replace TipoClFo  With  "C"
		Else
			Replace TipoClFo  With  "F"
		EndIf
		
		dbSelectArea("SF1")
		dbSkip()
	EndDo
Endif

Return



Static Function FGravaNFS()
/*************************************************************************************
* 
*
*******/

Local nContAuxi := 0
	
lFirst := .T.
		
dbSelectArea("SA1")
dbSeek(xFilial("SA1")+SF2->F2_CLIENTE+SF2->F2_LOJA)
		
aArraPedi := {}
cMenNota  := ""
cMenNot2  := ""
		
dbSelectArea("SD2")
dbSetOrder(3)
dbSeek(xFilial("SD2")+SF2->F2_DOC+SF2->F2_Serie)
		
While (!Eof())                           .And. ;
	  (SD2->D2_Filial == xFilial("SD2")) .And. ;
	  (SD2->D2_DOC    == SF2->F2_DOC)    .And. ;
	  (SD2->D2_SERIE  == SF2->F2_SERIE)
								
	dbSelectArea("SC6")
	dbSetOrder(1)
	dbSeek(xFilial("SC6")+SD2->D2_PEDIDO+SD2->D2_ITEMPV)
			
	dbSelectArea("SB1")
	dbSetOrder(1)
	dbSeek(xFilial("SB1")+SD2->D2_COD)
								
	dbSelectArea("TRBI")
	dbSetOrder(1)
	dbSeek(SF2->F2_DOC+SF2->F2_SERIE+SD2->D2_COD+SD2->D2_LOTECTL)
			
//	If Eof()
		dbAppend()
		Replace NumeNtFi With SD2->D2_DOC
		Replace SeriNtFi With SD2->D2_SERIE
		Replace CodiProd With SD2->D2_COD
		Replace DescProd With AllTrim(SB1->B1_DESC)
		Replace NumeLote With SD2->D2_LOTECTL
		Replace DataVali With SD2->D2_DTVALID
		Replace ClasFisc With SD2->D2_CLASFIS
		Replace CodiUnid With SB1->B1_UM
		Replace PercICMS With SD2->D2_PICM
		Replace PercICMR With SB1->B1_PICMRet
		Replace PercIPI  With SD2->D2_IPI
		Replace ValrIPI  With SD2->D2_ValIPI
		Replace CodiTes  With SD2->D2_TES
		Replace CodiFiOP With SD2->D2_CF
		Replace Tipo     With SB1->B1_TIPO
		Replace QtdeProd With SD2->D2_QUANT
		Replace ValrUnit With SD2->D2_PRCVEN
		Replace ValrTota With SD2->D2_TOTAL
//	Else
//		Replace QtdeProd With TRBI->QtdeProd + SD2->D2_QUANT
//		Replace ValrTota With TRBI->ValrTota + SD2->D2_TOTAL
//	EndIf
	
	cCodiFiOP := SD2->D2_CF
	
	If Ascan(aCodiFiOP,cCodiFiOP) == 0 .AND. cCodiFiOp <> ""
		AADD(aCodiFiOP,cCodiFiOP)
	EndIf
			
	If Ascan(aClasFisc,SB1->B1_CLASFIS) == 0 .And. (!SB1->B1_CLASFISC $ "01_02")
		AADD(aClasFisc,SB1->B1_CLASFIS)
	EndIf
			
	dbSelectArea("SC5")
	dbSetOrder(1)
	dbSeek(xFilial("SC5")+SD2->D2_PEDIDO)

	If !AllTrim(SC5->C5_MENNOTA) $ cMenNota .AND. AllTrim(SC5->C5_MENNOTA) <> ""
		cMenNota += AllTrim(SC5->C5_MENNOTA)+" / "
	Endif

	If !AllTrim(SC5->C5_MENNOT2) $ cMenNota .AND. AllTrim(SC5->C5_MENNOT2) <> ""
		cMenNota += AllTrim(SC5->C5_MENNOT2)+" / "
	Endif

	dbSelectArea("SF4")
	dbSetOrder(1)
	dbSeek(xFilial("SF4")+SD2->D2_TES)
			
	cCodiPedi := SD2->D2_PEDIDO
		
	If (aScan(aArraPedi,cCodiPedi) == 0)
		aAdd(aArraPedi,cCodiPedi)
	EndIf
			
	If (lFirst)
		cCodiTes  := SD2->D2_TES
		cCodiFiOP := SD2->D2_CF
		lFirst    := .F.
	EndIf
			
	dbSelectArea("SD2")
	dbSkip()
			
EndDo
			
aSort(aArraPedi)
		
For nContAuxi := 1 To Len(aArraPedi)
	cListPedi := cListPedi + aArraPedi[nContAuxi] + " / "
Next nContAuxi
		
Do Case
	Case (Len(AllTrim(cListPedi)) <= 8)
		cListPedi := Left(cListPedi,6)
	Case (Len(AllTrim(cListPedi)) > 60)
		cListPedi := Left(cListPedi,54) + "..."
	OtherWise
		cListPedi := Left(cListPedi,Len(cListPedi) - 3)
EndCase
		
dbSelectArea("SE1")
dbSetOrder(2)
dbSeek(xFilial("SE1")+SF2->F2_CLIENTE+SF2->F2_LOJA+SF2->F2_PREFIXO+SF2->F2_DUPL)
		
While (!Eof())                             .And. ;
	  (SE1->E1_FILIAL  == xFilial("SE1"))  .And. ;
	  (SE1->E1_PREFIXO == SF2->F2_PREFIXO) .And. ;
	  (SE1->E1_NUM     == SF2->F2_DUPL)
			
	If (!("NF" $ SE1->E1_TIPO))
		dbSelectArea("SE1")
		dbSkip()
		Loop
	Endif
			
	dbSelectArea("TRBF")
	TRBF->(dbAppend())
			
	Replace NumeNtFi  With SF2->F2_DUPL
	Replace SeriNtFi  With SF2->F2_SERIE
	Replace NumeDupl  With SF2->F2_DUPL
	Replace NumeParc  With SE1->E1_PARCELA
	Replace DataVenc  With SE1->E1_VENCTO
	Replace ValrDupl  With SE1->E1_VALOR
	Replace ValrTota  With ValrTota+SE1->E1_VALOR
			
	dbSelectArea("SE1")
	dbSkip()
EndDo
		
dbSelectArea("SA3")
dbSetOrder(1)
dbSeek(xFilial("SA3")+SF2->F2_VEND1)
		
dbSelectArea("TRBC")
TRBC->(dbAppend())
		
Replace MenNota  With Left(cMenNota,Len(cMenNota)-3)
Replace MenNot2  With Left(cMenNot2,Len(cMenNot2)-3)
Replace DescNtFi With SF2->F2_DESCONT            
Replace NumeNtFi With SF2->F2_DOC
Replace SeriNtFi With SF2->F2_SERIE
Replace CodiTes  With cCodiTes
Replace CodiFiOP With cCodiFiOP
Replace DataEmis With SF2->F2_EMISSAO
Replace ValrNota With SF2->F2_VALBRUT
Replace CodiClFo With SF2->F2_CLIENTE
Replace LojaClFo With SF2->F2_LOJA
Replace CodiTran With SF2->F2_TRANSP
Replace CodiPedi With cCodiPedi
Replace ValrFret With SF2->F2_FRETE
Replace ValrSegu With SF2->F2_SEGURO
Replace BCalICMS With SF2->F2_BASEICMS
Replace BCalIPI  With SF2->F2_BASEIPI
Replace ValrICMS With SF2->F2_VALICM
Replace BaseICMR With SF2->F2_BRICMS
Replace ValrICMR With SF2->F2_ICMSRET
Replace ValrIPI  With SF2->F2_VALIPI
Replace ValrMerc With SF2->F2_VALMERC
Replace NumeDupl With SF2->F2_DUPL
Replace CondPaga With SF2->F2_COND
Replace CodVend  With SF2->F2_VEND1
Replace NomVend  With SA3->A3_NOME
Replace LogVend  With SA3->A3_END
Replace BaiVend  With SA3->A3_BAIRRO
Replace CidVend  With SA3->A3_MUN
Replace EstVend  With SA3->A3_EST
Replace PesoBrut With SF2->F2_PBRUTO
Replace PesoLiqu With SF2->F2_PLIQUI
Replace TipoEsp1 With SF2->F2_ESPECI1
Replace TipoEsp2 With SF2->F2_ESPECI2
Replace QtdeVolu With SF2->F2_VOLUME1
Replace ListPedi With cListPedi
		
If (SF2->F2_TIPO $ "N/C/P/I/S/T/O")
	Replace TipoClFo With  "C"
Else
	Replace TipoClFo With  "F"
EndIf
		
cListPedi  := ""
		
Return



Static Function FImpNota(lEnd,wnRel,cString)
/*************************************************************************************
* Imprime a Nota Fiscal de Entrada e de Saida
*
*******/
Local nContItem := 0
Local nLinAux   := 0
Local lMsg1Item := .F.

Local nResto:=0
Local nLinDesc:=0
Local nX:=0
Local nC:=1
Local nC1:=80
Local nPag:= 1

Private nLinMsg   := 0
Private cObsNota  := ""
Private nItens    := 1
Private nPulo     := 15 //Numero de linhas impressao
Private cMenNota  := ""

dbSelectArea("TRBC")
dbGoTop()

SetRegua(RecCount())

@ PROW(),PCOL() PSAY AvalImp(Limite)

While (!Eof())
	
	IncRegua()                  
	
	nPag:=1
	
	SC5->(dbSetOrder(1))
	SC5->(dbSeek(xFilial("SC5")+TRBC->CodiPedi))
	cMenNota:=SC5->C5_REFER
	
	nPagUlt:=FImpFatur() //verifica numero de paginas da NF para imprimir a fatura somente na ultima página
	fImpCabe(nPag,nPagUlt)
	
	nLinha := 22
	lMsg1Item:=.F.
	nC:=1
	nC1:=80
	nItens:=1	
		
	dbSelectArea("TRBI")
	dbSeek(TRBC->NumeNtFi+TRBC->SeriNtFi)

	
	While (!Eof())                          .And. ;
		  (TRBI->NumeNtFi == TRBC->NumeNtFi) .And. ;
		  (TRBI->SeriNtFi == TRBC->SeriNtFi)
				  
		//Numero de itens <= ao total de itens que podem impressos
		If nItens <= nPulo
		
			If !Empty(AllTrim(cMenNota)) .AND. !lMsg1Item
				nResto:=(Len(AllTrim(cMenNota))/80)-Int(Len(AllTrim(cMenNota))/80)
				nLinDesc:=Iif(nResto<>0,(Int(Len(AllTrim(cMenNota))/80))+1,(Len(AllTrim(cMenNota))/80))
				//quebra da mensagem				
				For nX:=1 To nLinDesc 
				   cImpLin:=SubStr(AllTrim(cMenNota),nC,80)				
					@ nLinha, 012 PSAY cImpLin
					nLinha++
					nItens++
					nC+=80
				Next nX
				
				lMsg1Item:=.T.

			EndIf
		
			fImpItem()
			
			dbSelectArea("TRBI")
			dbSkip()
			nItens++
		Else
			FImpPag() //Imprimir --> ***********
			nItens := 1
			nPag++
			fImpCabe(nPag,nPagUlt)
			nLinha := 22
		EndIf
	EndDo
	
	//fImpOBS("1")   
	
 	fImpRoda()

	dbSelectArea("TRBC")
	dbSkip()
EndDo

Return



Static Function fImpCabe(nPag,nPagUlt)
/*************************************************************************************
* Imprime a Nota Fiscal de Entrada e de Saida (Cabecalho)
*
*******/

Local cNomeClfo, cCGCCliFo, cTeleClFo, cEndeClFo, cBairClFo
Local cCEPCliFo, cMuniClFo, cEstaClFo, cInscClFo
Local cImprFiOP := "" 
Local cExtenso  := ""
Local nXi := 0
LOcal nFatur := 0 
//fConfig("G", 18)


If nTipoNtFi == 2
	@ 001,104 PSAY "X"
Else
	@ 001,118 PSAY "X"
EndIf  

@ 001,151 PSAY TRBC->NumeNtFi

//fConfig("M", 15)

dbSelectArea("SF4")
dbSetOrder(1)
dbSeek(xFilial("SF4")+TRBC->CodiTes)

dbSelectArea("SM4")
dbSetOrder(1)
dbSeek(xFilial("SM4")+SF4->F4_FORMULA)

dbSelectArea("SX5")
dbSetOrder(1)
dbSeek(xFilial("SX5")+"13"+SF4->F4_CF)

@ 006,003 PSAY Left(SF4->F4_TEXTO,40)

@ 006,055 PSAY TRBC->CodiFiOP Picture "9999" 

If (TRBC->TipoClFo == "C")
	dbSelectArea("SA1")
	dbSeek(xFilial("SA1")+TRBC->CodiClFo+TRBC->LojaClFo)
	
	cNomeClfo := SA1->A1_NOME
	cCGCCliFo := SA1->A1_CGC
	cTeleClFo := Left(SA1->A1_TEL, 15)
	cEndeClFo := SA1->A1_END
	cBairClFo := SA1->A1_BAIRRO
	cCEPCliFo := SA1->A1_CEP
	cMuniClFo := SA1->A1_DESCMUN
	cEstaClFo := SA1->A1_EST
	cInscClFo := SA1->A1_INSCR
Else
	dbSelectArea("SA2")
	dbSeek(xFilial("SA2")+TRBC->CodiClFo+TRBC->LojaClFo)
	
	cNomeClfo := SA2->A2_NOME
	cCGCCliFo := SA2->A2_CGC
	cTeleClFo := Left(SA2->A2_TEL, 15)
	cEndeClFo := SA2->A2_END
	cBairClFo := SA2->A2_BAIRRO
	cCEPCliFo := SA2->A2_CEP
	cMuniClFo := SA2->A2_MUN
	cEstaClFo := SA2->A2_EST
	cInscClFo := SA2->A2_INSCR
EndIf

@ 009, 003 PSAY AllTrim(cNomeClFo)
@ 009, 105 PSAY cCGCCliFo Picture "@R 99.999.999/9999-99"
@ 009, 145 PSAY TRBC->DataEmis

@ 011, 003 PSAY Left(cEndeClFo,40)
@ 011, 088 PSAY cBairClFo
@ 011, 122 PSAY cCEPCliFo Picture "@R 99999-999"
@ 011, 145 PSAY dDataBase

@ 013, 003 PSAY cMuniClFo 
@ 013, 070 PSAY cTeleClFo
@ 013, 093 PSAY cEstaClFo 
@ 013, 105 PSAY cInscClFo 

dbSelectArea("TRBF")
dbSeek(TRBC->NumeNtFi+TRBC->SeriNtFi)

aFaturas:={}

If !Eof()	

//	cExtenso := PADR(AllTrim(Extenso(TRBF->ValrDupl)),300,"*")
//	cExtenso := PADR(AllTrim(Extenso(TRBF->ValrTota)),300,"*")
	cExtenso := PADR(AllTrim(Extenso(TRBC->ValrNota)),300,"*")
	For nXi := 1 To 5
		AADD(aFaturas, { Substr(cExtenso,((nXi-1)*75)+1,75)," "," ",0})
		If TRBF->NumeNtFi == TRBC->NumeNtFi .And. TRBF->SeriNtFi == TRBC->SeriNtFi
			aFaturas[Len(aFaturas)][2] := Alltrim(TRBF->NumeDupl+Iif(!Empty(TRBF->NumeParc),"-"+TRBF->NumeParc,""))
			aFaturas[Len(aFaturas)][3] := TRBF->DataVenc
			aFaturas[Len(aFaturas)][4] := TRBF->ValrDupl
		EndIf
		TRBF->(dbSkip())
	Next nXi
	
//	Alert(nPag)
//	Alert(nPagUlt)
	
	If nPag == nPagUlt

		For nFatur := 1 To Len(aFaturas) 
			@ 015+nFatur, 020 PSAY Left(aFaturas[nFatur][1],75)
			If nFatur <> 0	
				@ 015+nFatur, 103 PSAY Alltrim(aFaturas[nFatur-0][2])
				If aFaturas[nFatur-0][4]>0
					If Empty(SC5->C5_TXTVCTO)              //Texto para condicao de pagamento //Wladimir 13/12/06 - TRATAMENTO DE NF CONTRA APRESENTACAO				
						
						@ 015+nFatur, 123 PSAY aFaturas[nFatur-0][3]
						@ 015+nFatur, 144 PSAY aFaturas[nFatur-0][4] Picture "@E@Z 999,999,999.99"
					Else                                           
						   @ 015+nFatur, 123 PSAY SC5->C5_TXTVCTO
							@ 015+nFatur, 144 PSAY aFaturas[nFatur-0][4] Picture "@E@Z 999,999,999.99"
					Endif
				Endif
			EndIf
		Next nFatur
	
	Else
		
		For nFatur:=1 To 4
			@ 015+nFatur, 020 PSAY " " 
			If nFatur <> 1	
				@ 015+nFatur, 103 PSAY " " 
				@ 015+nFatur, 123 PSAY " " 
				@ 015+nFatur, 144 PSAY " " 
			EndIf
		Next nFatur	
	
	EndIf

Else
	For nFatur:=1 To 4
		@ 015+nFatur, 020 PSAY " " 
		If nFatur <> 1	
			@ 015+nFatur, 103 PSAY " " 
			@ 015+nFatur, 123 PSAY " " 
			@ 015+nFatur, 144 PSAY " " 
		EndIf
	Next nFatur	
EndIf

dbSelectArea("TRBC")

Return



Static Function fImpItem()
/*************************************************************************************
* Imprime a Nota Fiscal de Entrada e de Saida (Itens)
*
*******/

Local nResto:=(Len(AllTrim(TRBI->DescProd))/80)-Int(Len(AllTrim(TRBI->DescProd))/80)
Local nLinDesc:=Iif(nResto<>0,(Len(AllTrim(TRBI->DescProd))/80)+1,(Len(AllTrim(TRBI->DescProd))/80))
Local nX:=0
Local nC:=1
Local nC1:=80

@ nLinha, 003 PSAY Left(TRBI->CodiProd,07) 
For nX:=1 To nLinDesc
	If nX < nLinha .AND. nX <> 1
		nLinha++
		nItens++
	EndIf
	@ nLinha, 012 PSAY SubStr(AllTrim(TRBI->DescProd),nC,80)
	nC+=80
Next nX
@ nLinha, 094 PSAY TRBI->ClasFisc
@ nLinha, 100 PSAY TRBI->CodiUnid
@ nLinha, 103 PSAY TRBI->QtdeProd Picture "@E 999,999.99"  
@ nLinha, 121 PSAY TRBI->ValrUnit Picture "@E 999,999.99"
@ nLinha, 138 PSAY TRBI->ValrTota Picture "@E 9,999,999.99"
@ nLinha, 156 PSAY TRBI->PercICMS Picture "@E 99"

nLinha++

Return



Static Function fImpPag()
/*************************************************************************************
* Imprime "-x-x-" nos campos quando há paginação
*
*******/


@ 39, 013 PSAY "-x-x-"
@ 39, 045 PSAY "-x-x-"
@ 39, 080 PSAY "-x-x-"
@ 39, 110 PSAY "-x-x-"
@ 39, 144 PSAY "-x-x-"
@ 41, 013 PSAY "-x-x-"
@ 41, 045 PSAY "-x-x-"
@ 41, 080 PSAY "-x-x-"
@ 41, 110 PSAY "-x-x-"
@ 41, 144 PSAY "-x-x-"

@ 43, 085 PSAY " "
@ 44, 003 PSAY " "
@ 44, 133 PSAY " "
@ 46, 003 PSAY " "
@ 46, 072 PSAY " "
@ 46, 121 PSAY " "
@ 46, 133 PSAY " "
@ 48, 003 PSAY " "
@ 48, 016 PSAY " "
@ 48, 110 PSAY " "
@ 48, 146 PSAY " "

//Dados adicionais
If (nTipoNtFi == 2)
	FImpDadAd()
EndIf	

@ 60, 134 PSAY TRBC->NumeNtFi

@ 66, 001 PSAY ""

SetPrc(000,000)

dbSelectArea("TRBC")

Return



Static Function fImpRoda()
/*************************************************************************************
* Imprime a Nota Fiscal de Entrada e de Saida (Rodape)
*
*******/

Local cTextoFim  := ""
Local nX         := 0
Local nFat1      := 0
Local nFat2      := 0

//fConfig("P", 18)

If Empty(TRBC->BCalICMS)
	@ 39, 013 PSAY "-x-x-"
Else
	@ 39, 013 PSAY TRBC->BCalICMS Picture "@E@Z 999,999,999.99"
EndIf
If Empty(TRBC->ValrICMS)
	@ 39, 045 PSAY "-x-x-"
Else 
	@ 39, 045 PSAY TRBC->ValrICMS Picture "@E@Z 999,999,999.99"
EndIf
If Empty(TRBC->BaseICMR)
	@ 39, 080 PSAY "-x-x-"
Else 
	@ 39, 080 PSAY TRBC->BaseICMR Picture "@E@Z 999,999,999.99"
EndIf
If Empty(TRBC->ValrICMR)
	@ 39, 110 PSAY "-x-x-"
Else 
	@ 39, 110 PSAY TRBC->ValrICMR Picture "@E@Z 999,999,999.99"
EndIf
If Empty(TRBC->ValrMerc)
	@ 39, 144 PSAY "-x-x-"
Else 
	@ 39, 144 PSAY TRBC->ValrMerc Picture "@E@Z 999,999,999.99"
EndIf

If Empty(TRBC->ValrFret)
	@ 41, 013 PSAY "-x-x-"
Else 
	@ 41, 013 PSAY TRBC->ValrFret Picture "@E@Z 999,999,999.99"
EndIf
If Empty(TRBC->ValrSegu)
	@ 41, 045 PSAY "-x-x-"
Else 
	@ 41, 045 PSAY TRBC->ValrSegu Picture "@E@Z 999,999,999.99"
EndIf	
If Empty(TRBC->ValrOutr)
	@ 41, 080 PSAY "-x-x-"
Else 
	@ 41, 080 PSAY TRBC->ValrOutr Picture "@E@Z 999,999,999.99"
EndIf
If Empty(TRBC->ValrIPI)
	@ 41, 110 PSAY "-x-x-"
Else 
	@ 41, 110 PSAY TRBC->ValrIPI  Picture "@E@Z 999,999,999.99"
EndIf	
If Empty(TRBC->ValrNota)
	@ 41, 144 PSAY "-x-x-"
Else 
	@ 41, 144 PSAY TRBC->ValrNota Picture "@E@Z 999,999,999.99"
EndIf

SA4->(dbSetOrder(1))
SA4->(dbSeek(xFilial("SA4")+TRBC->CodiTran))

//fConfig("M", 15)

@ 44, 003 PSAY SA4->A4_NOME

If (nTipoNtFi == 2)
	SC5->(dbSetOrder(1))
	SC5->(dbSeek(xFilial("SC5")+TRBC->CodiPedi))
	If (SC5->C5_TPFRETE == "C")
		@ 44, 085 PSAY "1"
	ElseIf !SC5->(Eof())
		@ 44, 085 PSAY "2"
	Endif
EndIf

If !Empty(SC5->C5_PLACA)
   @ 44, 090 PSAY SC5->C5_PLACA
EndIf
If !Empty(SA4->A4_CGC)
	@ 44, 133 PSAY SA4->A4_CGC Picture "@R 99.999.999/9999-99"
EndIf

@ 46, 003 PSAY SA4->A4_END
@ 46, 072 PSAY SA4->A4_MUN
@ 46, 121 PSAY SA4->A4_EST
@ 46, 133 PSAY SA4->A4_INSEST

@ 48, 003 PSAY TRBC->QtdeVolu Picture "@E@Z 999,999"
@ 48, 016 PSAY TRBC->TipoEsp1
If !Empty(SC5->C5_MARCA)
   @ 48, 045 PSAY SC5->C5_MARCA
EndIf
@ 48, 110 PSAY TRBC->PesoBrut Picture "@E@Z 999,999,999.99"
@ 48, 146 PSAY TRBC->PesoLiqu Picture "@E@Z 999,999,999.99"

//Dados adicionais
If (nTipoNtFi == 2)
	FImpDadAd()
EndIf

//fConfig("P", 18)

@ 60, 134 PSAY TRBC->NumeNtFi

@ 66, 001 PSAY ""

SetPrc(000,000)

dbSelectArea("TRBC")

Return



Static Function FImpDadAd()

//Dados adicionais
SZ1->(dbSetOrder(1))
SZ1->(dbSeek(xFilial("SZ1")+SC5->C5_CONTRATO))
	
SM4->(dbSetOrder(1))
SM4->(dbSeek(xFilial("SM4")+SC5->C5_MENPAD))

@ 51, 001 PSAY "Contrato: "+SC5->C5_CONTRATO+"-"+SZ1->Z1_NOME 
@ 52, 001 PSAY "Obra: "+SZ1->Z1_CONTA+"-"+SZ1->Z1_NOMCONTA
@ 53, 001 PSAY "Cliente: "+SC5->C5_CLIENTE+"/"+SC5->C5_LOJACLI
@ 54, 001 PSAY SubStr(SM4->M4_FORMULA,01,70)
@ 55, 001 PSAY SubStr(SM4->M4_FORMULA,71,70)
@ 56, 001 PSAY SubStr(TRBC->MenNota,01,070)
@ 57, 001 PSAY SubStr(TRBC->MenNota,71,70)

Return



Static Function FImpFatur()

Local nResto:=0
Local nLinDesc:=0
Local nX:=0
Local nC:=1
Local nC1:=80
Local nLinPag:=0

nResto:=(Len(AllTrim(cMenNota))/80)-Int(Len(AllTrim(cMenNota))/80)
nLinDesc:=Iif(nResto<>0,(Int(Len(AllTrim(cMenNota))/80))+1,(Len(AllTrim(cMenNota))/80))
nLinPag+=nLinDesc


dbSelectArea("TRBI")
dbSeek(TRBC->NumeNtFi+TRBC->SeriNtFi)
	
While (!Eof())                          .And. ;
	  (TRBI->NumeNtFi == TRBC->NumeNtFi) .And. ;
	  (TRBI->SeriNtFi == TRBC->SeriNtFi)

		nResto:=(Len(AllTrim(TRBI->DescProd))/80)-Int(Len(AllTrim(TRBI->DescProd))/80)
		nLinDesc:=Iif(nResto<>0,(Int(Len(AllTrim(TRBI->DescProd))/80))+1,(Len(AllTrim(TRBI->DescProd))/80))
		nLinPag+=nLinDesc				  
			
		dbSelectArea("TRBI")
		dbSkip()
EndDo

nRet:=Iif((nLinPag/nPulo)-Int(nLinPag/nPulo)<>0,Int(nLinPag/nPulo)+1,Int(nLinPag/nPulo))
//nRet:=Iif((nLinPag/nPulo+1)-Int(nLinPag/nPulo+1)<>0,Int(nLinPag/nPulo+1)+1,Int(nLinPag/nPulo+1))

Return(nRet)

Static Function fConfig(cTamanho, nChar)
/******************************************************************
* 
*
*****/

Local aDriver := ReadDriver()

If nChar == NIL
	 @ PRow(),PCol() PSAY &(If(cTamanho=="P",aDriver[1],If(cTamanho=="G",aDriver[5],aDriver[3])))
Else
	If nChar == 15
		@ PRow(),PCol() PSAY &(If(cTamanho=="P",aDriver[1],If(cTamanho=="G",aDriver[5],aDriver[3])))
	Else
		@ PRow(),PCol() PSAY &(If(cTamanho=="P",aDriver[2],If(cTamanho=="G",aDriver[6],aDriver[4])))
	EndIf
EndIf

Return