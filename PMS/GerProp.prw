#Include "TopConn.ch"
User Function GerProp()
*******************************************************************************************************************
*
*
*******
Private aPos:={08,11,11,70}                       // Posiciona o cCadastro
Private cCadastro:="Gerar Planilhas de Para Elaboração de Propostas"
Private aRotina:={{"Pesquisar" ,"AxPesqui",0,1},;
		          {"GPS"       ,'U_GERPR' ,0,2},;    // padrao Siga
		          {"GSE"       ,'U_GERSU' ,0,3},;    // padrao Siga
		          {"GSS"       ,'U_GERGE' ,0,4}}     // AxVisualizar - padrao Siga
         
dbSelectArea("AF8")
dbSetOrder(1)
mBrowse(06,08,22,71,"AF8") // variaveis aPos, cCadastro, aRotina utilizadas
                           // no mBrowse
Return()



User Function GERPR()
*******************************************************************************************************************
*
*
*******
Local aCampos:={}
Private aNomCamp:={}
//Cria  a estrutura da Tabela a ser exportada
AADD(aCampos,{"CHAVE","C",30,0})
AADD(aCampos,{"ITEM","C",5,0})
AADD(aCampos,{"AREA","C",5,0})
AADD(aCampos,{"DESC","C",40,0})
AADD(aCampos,{"ES","N",12,2})
AADD(aCampos,{"PS","N",12,2})
AADD(aCampos,{"DES","N",12,2})
AADD(aCampos,{"OUT","N",12,2})
AADD(aCampos,{"QTDETOTAL","C",50,0})
AADD(aCampos,{"VLRTOTAL","C",50,0})
AADD(aCampos,{"FORMATO","C",3,0})
AADD(aCampos,{"QTDE","N",5,0})
AADD(aCampos,{"A1EQUIVAL","N",12,2})
AADD(aCampos,{"RSA1EQUI","C",50,0})
AADD(aCampos,{"HHA1EQUI","C",50,0})

//Array de Conversão dos Nomes de Campos para Excel
// Nome do Campo
//Descrição do Campo
//Letra da Planilha Excel
//Formula da Planilha

AADD(aNomCamp,{"ITEM"      ,"Item"              ,"A",""}) //A
AADD(aNomCamp,{"AREA"      ,"Area"              ,"B",""}) //B
AADD(aNomCamp,{"DESC"      ,"Descrição do Item" ,"C",""}) //C
AADD(aNomCamp,{"ES"        ,"Eng.Senior"        ,"D",""}) //D
AADD(aNomCamp,{"PS"        ,"Proj. Senior"      ,"E",""}) //E
AADD(aNomCamp,{"DES"       ,"Desenhista"        ,"F",""}) //F
AADD(aNomCamp,{"OUT"       ,"Outros"            ,"G",""}) //G
AADD(aNomCamp,{"QTDETOTAL" ,"Total"             ,"H",'"=Soma(D"+cLinh+"+E"+cLinh+"+F"+cLinh+")"'}) //H
AADD(aNomCamp,{"VLRTOTAL"  ,"Total R$"          ,"I",'"=($D$2*D"+cLinh+")+($E$2*E"+cLinh+")+($F$2*F"+cLinh+")+($G$2*G"+cLinh+")"'}) //I
AADD(aNomCamp,{"FORMATO"   ,"Formato"           ,"J",""}) //J
AADD(aNomCamp,{"QTDE"      ,"Qtde"              ,"K",""}) //K
AADD(aNomCamp,{"A1EQUIVAL" ,"A1 Equiv."         ,"L",""}) //L
AADD(aNomCamp,{"RSA1EQUI" ,"R$/A1 Equiv."       ,"M",'"=(G"+cLinh+"/L"+cLinh+")"'}) //M
AADD(aNomCamp,{"HHA1EQUI" ,"Hh/A1 Equiv"        ,"N",'"=(H"+cLinh+"/L"+cLinh+")"'}) //N

///Cria a tabela auxiliar

cArqTrab:= CriaTrab(aCampos,.T.)
dbUseArea( .T.,, cArqTrab, "TRB1",.F.,.F.)
IndRegua("TRB1",cArqTrab,"CHAVE",,,OemToAnsi("Selecionando Registros"))


cQuery:=" SELECT AFA.AFA_PROJET,AFA_REVISA,AFA_TAREFA,AFA_ITEM,AFA_QUANT,AFA_CUSTD,AFA_RECURS,"
cQuery+=" AF9.AF9_DESCRI,AF9.AF9_UM,AE8.AE8_EQUIP "
cQuery+=" FROM "+RetSqlName("AFA")+" AFA "
cQuery+=" INNER JOIN "+RetSqlName("AF9")+" AF9 ON "
cQuery+=" (AF9.AF9_PROJET=AFA_PROJET AND AF9.AF9_REVISA=AFA.AFA_REVISA AND AF9_TAREFA=AFA_TAREFA "
cQuery+="  AND AF9.D_E_L_E_T_<>'*') "
cQuery+=" INNER JOIN "+RetSqlName("AE8")+" AE8 ON "
cQuery+=" (AFA.AFA_RECURS=AE8.AE8_RECURS AND AE8.D_E_L_E_T_<>'*') "
cQuery+=" WHERE AFA_PROJET='"+AF8->AF8_PROJET+"' AND AFA_REVISA='"+AF8->AF8_REVISA+"' AND AFA.D_E_L_E_T_<>'*' "
cQuery+=" AND AFA_FILIAL='"+Xfilial("AFA")+"'"
TcQuery cQuery Alias QAFA New

dbSelectArea("TRB1")
Reclock("TRB1",.T.)
MsUnlock()

//Inicia a gravação dos Dados
dbSelectArea("QAFA")
While !Eof() 
	cCChaveAFA:=QAFA->(AE8_EQUIP+AFA_TAREFA+AF9_UM)
	nES:=0
	nPS:=0
	nDES:=0
	nOUT:=0
	
	If Left(AFA_RECURS,3)=='DES'
		nDES:=QAFA->AFA_QUANT
		If QAFA->AFA_CUSTD>0
			nCustDES:=QAFA->AFA_CUSTD
			dbSelectArea("TRB1")
			dbGotop()
			Reclock("TRB1",.F.)			
			Replace DES With QAFA->AFA_CUSTD
			MsUnlock()						
		Endif
	ElseIf Left(AFA_RECURS,3)=='PRJ'
		nPS:=QAFA->AFA_QUANT
		If QAFA->AFA_CUSTD>0
			nCustPRJ:=QAFA->AFA_CUSTD
			dbSelectArea("TRB1")
			dbGotop()
			Reclock("TRB1",.F.)			
			Replace PS With QAFA->AFA_CUSTD
			MsUnlock()						
		Endif
	ElseIf Left(AFA_RECURS,3)=='ENG'
		nES:=QAFA->AFA_QUANT
		If QAFA->AFA_CUSTD>0
			dbSelectArea("TRB1")
			dbGotop()
			Reclock("TRB1",.F.)			
			Replace ES With QAFA->AFA_CUSTD
			MsUnlock()			
		Endif		
	Else
		nOUT:=QAFA->AFA_QUANT
		If QAFA->AFA_CUSTD>0
			dbSelectArea("TRB1")
			dbGotop()
			Reclock("TRB1",.F.)			
			Replace OUT With QAFA->AFA_CUSTD
			MsUnlock()
		Endif		
	Endif
	dbSelectArea("TRB1")
	Reclock("TRB1",!dbSeek(cCChaveAFA))
	Replace CHAVE     With cCChaveAFA,; 
			ITEM      With QAFA->AFA_ITEM,;
			AREA      With QAFA->AE8_EQUIP,;
			DESC      With QAFA->AF9_DESCRI,;
			ES        With ES+nES,;
			PS        With PS+nPS,;
			DES       With DES+nDES,;
			OUT       With OUT+nOUT,;
			FORMATO   With QAFA->AF9_UM ,;
			QTDE      With 1  ,;
			A1EQUIVAL With 1
	MsUnlock()
	dbSelectArea("QAFA")	
	dbSkip()
EndDo
nCont:=2
cArea:="*"
//Monta o totalizador e as Regras que serão geradas na Planilha
dbSelectArea("TRB1")
dbGotop()
dbSkip()
While !Eof()
	If cArea<>AREA
		nCont:=2
		cArea:=TRB1->AREA
	Endif
	nCont++
	cLinh:=Alltrim(Str(nCont,5))
	cQTDETOTAL:=GerForm('QTDETOTAL',cLinh)
	cVLRTOTAL :=GerForm('VLRTOTAL' ,cLinh)
	cA1EQUIVAL:=GerForm('A1EQUIVAL',cLinh)
	cRSA1EQUI :=GerForm('RSA1EQUI' ,cLinh)
	cHHA1EQUI :=GerForm('HHA1EQUI' ,cLinh)
	
	RecLock("TRB1",.F.)
	Replace 	QTDETOTAL With cQTDETOTAL,;
				VLRTOTAL  With cVLRTOTAL,;
				A1EQUIVAL With cA1EQUIVAL,;
				RSA1EQUI  With cRSA1EQUI,;
				HHA1EQUI  With cHHA1EQUI
	dbSelectArea("TRB1")
	dbSkip()
EndDo

dbSelectArea("AF8")
GerPlan()
dbSelectArea("QAFA")
dbCloseArea()
dbSelectArea("TRB1")
dbCloseArea()
Return()



Static Function GerForm(cCampo)
************************************************************************************************************
*
*
*
******
Local cCont:=""
Local nLinAt:=Ascan(aNomCamp,{|x| x[1]==cCampo})
cCont:=&(aNomCamp[nLinAt,4])
Return(cCont)



Static Function GerPlan()
********************************************************************************************************
*
*
*
***** 

Local nX := 0
///  Function PmsPlnExcel(aCampos, cUsrRev, nNivelMax, nPrjOrc, cPlanilha, lCsv)
Private cDirDocs  := MsDocPath() 
Private cPath		  := AllTrim(GetTempPath())
Private aAreaPlan	:= GetArea()
Private nX        := 0
Private xValue    := ""
Private cBuffer   := ""
Private cConteudo:=""
Private cArquivo:=""
Private cCab:=""
Private aAuxRet   := {}
Private cTitle    := ""
Private oExcelApp := Nil
Private CRLF:=chr(13)+Chr(10)
Private nHandle := 0
Private cArea   :="*"
Private nItens  :=0
If !ApOleClient("MsExcel") 
	MsgStop("Microsoft Excel nao instalado.")
	Return
EndIf

dbSelectArea("TRB1")
dbGotop()
While !Eof()
	// Monta o Cabeçalho
	If Empty(cCab)
		For nx := 1 To Len(aNomCamp)
			If nx < Len(aNomCamp)		
				cCab += ToXlsFormat(aNomCamp[nx,2])+";"
			Else
				cCab += ToXlsFormat(aNomCamp[nx,2])
			EndIf		
		Next	
		cCab+=CRLF
		For nx := 1 To Len(aNomCamp)
			xValue :=FieldGet(FieldPos(aNomCamp[nx,1]))
			If nx < Len(aNomCamp)		
				cCab += ToXlsFormat(xValue)+";"
			Else
				cCab += ToXlsFormat(xValue)
			EndIf		
		Next
		dbSkip()
	Endif
	If cArea<>TRB1->AREA
		If cArea<>'*'
			//Grava os totalizadores das Planilhas
			GravaTot()
		Endif
		// gera o arquivo em formato .CSV
		cArquivo  := CriaTrab(,.F.)+".csv"
		
		nHandle := FCreate(cDirDocs + "\" + cArquivo)
		FWrite(nHandle, cCab)
		nItens:=2
		If nHandle == -1
			MsgStop("A planilha não pode ser exportada.")
			Return
		EndIf
		FWrite(nHandle,CRLF)
		cArea:=AREA
	Endif	
	cBuffer := ""
	For nx := 1 To Len(aNomCamp)
		xValue :=FieldGet(FieldPos(aNomCamp[nx,1]))
		If nx < Len(aNomCamp)		
			cBuffer += ToXlsFormat(xValue) + ";"
		Else
			cBuffer += ToXlsFormat(xValue)
		EndIf		
	Next
	FWrite(nHandle, cBuffer)
	FWrite(nHandle, CRLF)
	nItens++
	dbSkip()
EndDo

GravaTot()

nItens:=0
RestArea(aAreaPlan)

Return()



Static function GravaTot()
********************************************************************************************************************
*
*
*
****

Local nLoop := 0
Local nX := 0 

For nLoop:=1 To 2

	cBuffer:=""
	
	For nx := 1 To Len(aNomCamp)
		cConteudo:=""
		If aNomCamp[nx,3]$'EDFGHIL'
			If nLoop==1 .Or. aNomCamp[nx,3]$'HIL'
				cConteudo:="=SOMA("+aNomCamp[nx,3]+"3:"+aNomCamp[nx,3]+Alltrim(Str(nItens,4))+")"
			ElseIf aNomCamp[nx,3]$'EDFG'
				cConteudo:="=$"+aNomCamp[nx,3]+"$2*"+aNomCamp[nx,3]+Alltrim(Str(nItens+1,4))+""
			Endif
		Endif
		If aNomCamp[nx,3]$'B'
			AED->(dbSeek(Xfilial("AED")+cArea))
			If nLoop==1
				cConteudo:="TOTAL QTDE "+AED->AED_DESCRI+":"
			Else
				cConteudo:=" VLR TOTAL "+AED->AED_DESCRI+":"
			Endif			
		Endif
		If aNomCamp[nx,3]$'MN'
			cLinh:=cLinh:=Alltrim(Str(nItens+2,5))
			 cConteudo:=GerForm(aNomCamp[nx,1] ,cLinh)
		Endif
		cBuffer += ToXlsFormat(cConteudo)
		If nx < Len(aNomCamp)		
			cBuffer +=";"
		EndIf		
	Next nx
	FWrite(nHandle,cBuffer)
	FWrite(nHandle,CRLF)
Next nLoop
FClose(nHandle)
// copia o arquivo do servidor para o remote
CpyS2T(cDirDocs + "\" + cArquivo, cPath, .T.)
oExcelApp := MsExcel():New()
oExcelApp:WorkBooks:Open(cPath + cArquivo)
oExcelApp:SetVisible(.T.)		

Return()
