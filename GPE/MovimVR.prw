#Include "Rwmake.ch"

User Function MovimVR()
/****************************************************************************************************
* Movimento de vale Refeição
*
*******/
cCadastro:="Cadastro de Vales Refeição"
aRotina:={{"Pesquisar" ,"AxPesqui",0,1},;
          {"Visualizar",'U_CADMOV',0,2},;
          {"Cad.Vale Refeição" ,'U_CADMOV',0,4},;
          {"Gera Mov. Mês"     ,'U_GERMOV',0,6}}

dbSelectArea("SRA") 
dbSetOrder(1)       

mBrowse(06,08,22,71,"SRA")

Return()



User Function CADMOV(cAlias,nRecno,nOpcx)
****************************************************************************************************
* Monta a tela de Manutenção dos Movimentos
*
*****

Local cTitulo:="Manut. dos Movimentos de Vale Refeição"
Local aC:={}
Local aR:={}
Local nxI := 0

Private aHeader:={}
Private aCols:={}
Private M->ZQ_CUSEMP:=0

aCGD:={60,5,250,350}
aCordW:={200,200,600,1000}

cLinhaOk := "AllWaysTrue() .And. U_VLinSZQ()"
cTudoOk  := "AllWaysTrue()"

dbSelectArea("SZQ")
Inclui:=!dbSeek(Xfilial("SZQ")+SRA->RA_MAT)
If inclui
	nOpcx:=3
Endif

RegToMemory("SZQ",Inclui)
M->RA_MAT :=SRA->RA_MAT
M->RA_NOME:=SRA->RA_NOME

AADD(aC,{"M->RA_MAT" ,{16,010},"Matricula.:"    ,"@!",,,.F.})
AADD(aC,{"M->RA_NOME",{16,100},"Nome do Funcionário:" ,"@!",,,.F.})

dbSelectArea("SX3")
SX3->(dbSetorder(1))
dbSeek("SZQ")
While !Eof() .And. (X3_ARQUIVO == "SZQ")
	IF X3USO(X3_USADO) .And. cNivel >= x3_nivel
		AADD(aHeader,{ALLTRIM(X3_TITULO),X3_CAMPO,X3_PICTURE,X3_TAMANHO,;
		X3_DECIMAL,X3_VALID,X3_USADO,X3_TIPO,X3_ARQUIVO})	
	Endif	
	dbSelectArea("SX3")
	SX3->(dbSetorder(1))
	dbSkip()
EndDo

//Monta os Itens
dbSelectArea("SZQ")
dbSetOrder(1)
dbSeek(xFilial("SZQ")+SRA->RA_MAT)

While !Eof() .and. SZQ->ZQ_FILIAL== xFilial("SZQ") .and. SZQ->ZQ_MAT == SRA->RA_MAT

	AADD(aCols,Array(Len(aHeader)+1))

	For nxI := 1 To Len(aHeader)
		If aHeader[nxI,2]<>'ZQ_DESCVR'
			aCols[Len(aCols),nxI]:=FieldGet(FieldPos(aHeader[nxI,2]))
		Else
			aCols[Len(aCols),nxI]:=Posicione("SZP",1,Xfilial("SZP")+SZQ->ZQ_CODVALE,"ZP_DESCRIC")
		Endif	
	Next nxI

	aCols[Len(aCols),Len(aHeader)+1]:=.F.
	dbSelectArea("SZQ")
	dbSkip()

EndDo

If Len(aCols)<=0
	aCols := {Array(Len(aHeader) + 1)}
	For nxI := 1 to Len(aHeader)
		aCols[1,nxI] := CRIAVAR(aHeader[nxI,2])
	Next
	aCols[1,Len(aHeader)+1] := .F.
Endif   

lRetMod2 := Modelo2(cTitulo,aC,aR,aCGD,nOpcx,cLinhaOk,cTudoOk,,,,,aCordW)
If lRetMod2 .And. nOpcx<>2
	GrvMov(nOpcx)
Endif  

Return()



Static Function GrvMov(nOpcx)
****************************************************************************************
* Grava os Dados
*
****

Local nGrvSZQ:=0
Local nHead := 0

Private cCampo:=""

dbSelectArea("SZQ")
dbSetOrder(1)

For nGrvSZQ:=1 To Len(Acols)
	If !GdDeleted(nGrvSZQ)
		dbSelectArea("SZQ")
		dbSetOrder(1)			
		If Reclock("SZQ",!dbSeek(Xfilial("SZQ")+M->RA_MAT+GdFieldGet("ZQ_CODVALE",nGrvSZQ)))
			//Grava os campos chaves
			Replace ZQ_FILIAL With Xfilial("SZQ"),;
					ZQ_MAT    With SRA->RA_MAT
			For nHead := 1 To Len(aHeader)
				If SZQ->(FieldPos(aHeader[nHead,2]))>0
					cCampo:="SZQ->"+aHeader[nHead,2]
					&cCampo:=GdFieldget(aHeader[nHead,2],nGrvSZQ)
				Endif
			Next nHead
		Endif	
		MsUnlock()
	Else 
		If dbSeek(Xfilial("SZQ")+SRA->RA_MAT+GdFieldGet("ZQ_CODVALE",nGrvSZQ))
			Reclock("SZQ",.F.)
			dbDelete()        
			MsUnlock()
		Endif
	Endif
Next nGrvSZQ
Return() 



User Function VLinSZQ()
******************************************************************************************
* Valida a Linha
*
****      
Local nCont:=0
Local lRet:=.T.
If !GdDeleted()
	nCodAtu:=GdFieldGet("ZQ_CODVALE")
	For nCont:=1 to Len(aCols)
		If nCont<>n .And. !GdDeleted(nCont) .And. nCodAtu==GdFieldGet("ZQ_CODVALE",nCont)
			lRet:=.F.		
		Endif
	Next nCont
	If !lRet
		MsgBox("Código Já Cadastrado Para Este Funcionário",".: ATENCAO :.","STOP")
		lRet:=.F.
	Endif
Endif	
Return(lRet)



User Function ValdSZQ()
******************************************************************************************
*
*
****
Local nCusEmp:=0
Local nCusFun:=0
Local cCodVale:=GdFieldGet("ZQ_CODVALE")
Local nVlrTot:=(GdFieldGet("ZQ_QTDE")*GdFieldGet("ZQ_VALOR"))+(GdFieldGet("ZQ_VMAIOR")-GdFieldGet("ZQ_VMENOR"))

dbSelectArea("SZP")
dbSeek(Xfilial("SZP")+cCodVale)
While !Eof()  .And. cCodVale=SZP->ZP_CODIGO
	If SRA->RA_SALARIO>=ZP_SALDE .And. SRA->RA_SALARIO<=SZP->ZP_SALATE
		nCusFun:=(nVlrTot*(SZP->ZP_PERDES/100))
		If nCusFun > SZP->ZP_DESMAX
			nCusFun:=SZP->ZP_DESMAX
		Endif		
		nCusEmp:=nVlrTot-nCusFun
		GdFieldPut("ZQ_CUSFUN",nCusFun)
		GdFieldPut("ZQ_CUSEMP",nCusEmp)
	Endif
	dbSkip()
EndDo
Return(nCusEmp)



User Function GERMOV()
******************************************************************************************
* Gera a Movimetação do Mes
*
****    
Local cPerg:="GERMOV"
Local aPerg:={} 

AADD(aPerg,{cPerg,"Informe o Ano/Mes ?","C",07,0,"G","","","","","","",""})
AADD(aPerg,{cPerg,"Matricula de.. ?","C",06,0,"G","","","","","","",""})
AADD(aPerg,{cPerg,"Matricula Até. ?","C",06,0,"G","","","","","","",""})
AADD(aPerg,{cPerg,"Tipo de Processamento?","N",01,0,"C","","","Calcular","Gerar Lançamento","","",""})
AADD(aPerg,{cPerg,"Acumular Valores?","N",01,0,"C","","","Sim","Não","","",""})


If Pergunte(cPerg,.T.) 
	If MV_PAR04==1
		Processa({|| CalcMov()},"Aguarde..","Calculando nro de Dias..")
	Else
		Processa({|| GerLanc()},"Aguarde..","Gerando Lançamentos na Folha..")	
	Endif
Endif
Return()



Static Function CalcMov()
************************************************************************************************************************
*
*
*
******
Local cAnoMes:=""
Local cDiasMes:=0
Private aCodFol  	:= {}  
Private aRoteiro 	:= {}
Private dDataRef:=Stod(cAnoMes+'01')
Private lUseCadTurno:= .F.				//-- Determina se calculo tera como base Cadastro de Turnos
Private aCodFol  	:= {}  
Private aRoteiro 	:= {}
Private nDiaUteis	:= 0 
Private nDVales  	:= 0
Private nDQVales 	:= 0
Private nDNQVales	:= 0				//-- dias Nao Uteis de V.T.
Private nDiaNUtProp	:= 0				//-- Dias Nao Uteis de Vale Transporte 
Private nDiasProp	:= 0 				//-- Dias uteis de Vale Transporte 
Private nDiaDifer	:= 0 				//-- dias de diferenca de VT ( dias Uteis)
Private nDiaDifN	:= 0 				//-- dias de diferenca de VT ( Nao uteis )
Private nDiferProp	:= 0 				//-- dias de diferenca de VT ( dias Uteis Prop.)
Private nDifNProp	:= 0 				//-- dias de diferenca de VT ( dias Nao Uteis  Prop.) 
Private cDiasMes	:= Getmv("MV_DIASMES")
Private nUlt_Dia  	:= 0
Private nSalMes		:= 0 
Private aCalendario	:= {}
Private cSemana		:= Space(2) 
Private nPercentual := 0
Private lUseCadTurno:= .F.				//-- Determina se calculo tera como base Cadastro de Turnos 
Private cSem:="  "

ProcRegua(SRA->(Reccount()))
cAnoMes:=Alltrim(StrTran(MV_PAR01,'/',''))
cAnoMes:=Alltrim(StrTran(cAnoMes,'\',''))
dDataRef:=Stod(cAnoMes+'01')
nUlt_Dia  	:= LastDay(If(Empty(dDataRef), dDataBase, dDataRef)) 


dbSelectArea("SRA")
dbSeek(Xfilial("SRA")+If(Empty(MV_PAR02),'',MV_PAR02))
While !Eof() .And. RA_MAT <= MV_PAR03
	IncProc("Funcionario:"+SRA->RA_NOME)
	If !SZQ->(dbSeek(Xfilial("SZQ")+SRA->RA_MAT)) .Or. (!Empty(SRA->RA_DEMISSA) .And. dDataRef>=SRA->RA_DEMISSA)
		dbSelectArea("SRA")
		dbSkip()
		Loop
	Endif
	dbSelectArea("RCF")
	dbSetOrder(1)
	dbSelectArea("SZQ")
	dbSetOrder(1)
	dbSeek(Xfilial("SZQ")+SRA->RA_MAT)
	While !Eof() .And. SZQ->ZQ_MAT==SRA->RA_MAT
		// Grava o Numero de dias trabalhado para o Período
		If RCF->(dbSeek(Xfilial("RCF")+cAnoMes+SRA->RA_TNOTRAB))
		   cDiasMes:=RCF->RCF_DIATRA
		ElseIf RCF->(dbSeek(Xfilial("RCF")+cAnoMes))
			cDiasMes:=RCF->RCF_DIATRA
		Endif

		nDiasAfas:=0
		nDTrab:=0
		
		If !Empty(SRA->RA_TNOTRAB)
			//³ Verifica se utiliza Cad. de Turnos ou Cadastro de Periodos   ³
			lUseCadTurno := fUseCadTurno()
		Else 
			lUseCadTurno := .T.
		Endif	
		
		cQTDE  :=0
		cCUSEMP:=0
		cCUSFUN:=0
		cVlrVR :=0 
		U_fRetDTrab(@cQTDE)
		cTipoVR:="N"
		// Valor pela Faixa Salarial
		dbSelectArea("SZP")
		dbSeek(Xfilial("SZP")+SZQ->ZQ_CODVALE)
		While !Eof()  .And. SZQ->ZQ_CODVALE=SZP->ZP_CODIGO
			cTipoVR:=SZP->ZP_FIXO
			If cQTDE>0 .And. SRA->RA_SALARIO>=ZP_SALDE .And. SRA->RA_SALARIO<=ZP_SALATE
				cCUSFUN:=(cQTDE*SZP->ZP_VUNIT)*(SZP->ZP_PERDES/100)
				If cCUSFUN > SZP->ZP_DESMAX
					cCUSFUN:=SZP->ZP_DESMAX
				Endif
				cCUSEMP:=(cQTDE*SZP->ZP_VUNIT)-cCUSFUN
				cVlrVR:=SZP->ZP_VUNIT
			Endif
			dbSkip()
		EndDo
		dbSelectArea("SZQ")
		Reclock("SZQ",.F.)
		Replace 	ZQ_QTDE    With cQTDE ,;
					ZQ_CUSEMP  With cCUSEMP ,;
					ZQ_CUSFUN  With cCUSFUN ,;
					ZQ_VALOR   With cVlrVR
		MsUnlock()
		dbSelectArea("SZQ")
		dbSkip()	
	EndDo
	dbSelectArea("SRA")
	dbSkip()
EndDo
Return()



User Function fRetDTrab(DTrab)
*********************************************************************************************************************
*
*
****
Local ndTrab 		:= 0
Local ndDSR 		:= 0
Local ndNTrab		:= 0 
Local nDiasAfas		:= 0

If lUseCadTurno 
	Alert ('Utilizando cadastro de turno' + SRA->RA_MAT)
	FDiasTrab(@DTrab,cDiasMes,,dDataRef,.F.)
	FDiasAfast(@nDiasAfas,@DTrab,dDataRef,.F.)
Else         
	FTrabCalen(dDataref,;		//-- data de Referencia
               @DTrab	,;		//-- Dias Trabalhados
               @ndNTrab,;		//-- Dias Nao Trabalhados
               @ndDSR,;			//-- Dias de DSR 
               @nDiaNUtProp,;	//-- Dias Nao Uteis de Vale Transporte 
               @nDiasProp,;		//-- Dias uteis de Vale Transporte 
               @nDiferProp,; 	//-- Dias de Diferenca de Vale Transporte
                    ,;			//-- Qtde de Horas de DSR
                    ,;			//-- Qtde de HoraS Trabalhadas 
                    ,;			//-- Dias de Vale Refeicao 
                    ,;
                    ,;
                cSem,;
                .T. ,;		//-- se Verifica Afastamentos
                .T. ,;		//-- se Verifica Admissao 
				@nDifNProp )//-- Dias de Diferença de VT ( dias Nao uteis) 
	//DTrab	:= ndTrab 
Endif		
Return



Static Function GerLanc()
*********************************************************************************************************************
*
*
*****

Local aVerb:={}                    
Local cAnoMes:=Alltrim(StrTran(MV_PAR01,'/',''))
Local nCount := 0

cAnoMes:=Alltrim(StrTran(cAnoMes,'\',''))
dDataRef:=Stod(cAnoMes+'01')

dbSelectArea("SRA")
dbSetOrder(1)
ProcRegua(SRA->(Reccount()))
dbSeek(Xfilial("SRA")+If(Empty(MV_PAR02),'',MV_PAR02))
While !Eof() .And. RA_MAT <= MV_PAR03
	IncProc("Funcionario:"+SRA->RA_NOME)
	If !SZQ->(dbSeek(Xfilial("SZQ")+SRA->RA_MAT)) .Or. (!Empty(SRA->RA_DEMISSA) .And. SRA->RA_DEMISSA <= dDataRef)
		dbSelectArea("SRA")
		dbSkip()
		Loop
	Endif
	aVerb:={}
	dbSelectArea("RCF")
	dbSetOrder(1)
	dbSelectArea("SZQ")
	dbSetOrder(1)
	dbSeek(Xfilial("SZQ")+SRA->RA_MAT)
	While !Eof() .And. SZQ->ZQ_MAT==SRA->RA_MAT
		SZP->(dbSeek(Xfilial("SZP")+SZQ->ZQ_CODVALE))
		nPos:=Ascan(aVerb,{|x| Alltrim(x[1])==Alltrim(SZP->ZP_VERBA)})
		If nPos <= 0
			Aadd(aVerb,{SZP->ZP_VERBA,0,0,SZQ->ZQ_QTDE})
			nPos:=Len(aVerb)
		Endif
		aVerb[nPos,2]+=SZQ->ZQ_CUSFUN
		aVerb[nPos,3]+=SZQ->ZQ_CUSEMP
		//Zera os campos da tabela SZQ
		RecLock("SZQ",.F.)
		If SZP->ZP_FIXO=='S'
			Replace  ZQ_QTDE   With 0,;
					 ZQ_CUSEMP With 0,;
					 ZQ_CUSFUN With 0,;
					 ZQ_VMAIOR With 0,;
					 ZQ_VMENOR With 0
		Else 
			dbDelete()
		Endif				
		MsUnlock()
		dbSelectArea("SZQ")	
		dbSkip()
	EndDo
	For nCount := 1 to Len(aVerb)
		//Grava as Verbas na Tabela SRC
		If aVerb[nCount,2] > 0
			
			dbSelectArea("SRC")	
			cSeq:='0'
			Reclock("SRC",!dbSeek(Xfilial("SRC")+SRA->RA_MAT+aVerb[nCount,1]+SRA->RA_CC+"  "+cSeq))
			Replace  RC_FILIAL  With Xfilial("SRC"),;
						RC_MAT     With SRA->RA_MAT ,;
						RC_TIPO1   With "V",;
						RC_TIPO2   With "G",;
						RC_PD      With aVerb[nCount,1],;
						RC_VALOR   With If(MV_PAR05=1,RC_VALOR+aVerb[nCount,2],aVerb[nCount,2]),;
						RC_HORAS   With aVerb[nCount,4],;
						RC_CC      With SRA->RA_CC ,;
						RC_SEQ     With cSeq
			MsUnlock()
		Endif
		
		//Verba da Empresa
		If aVerb[nCount,3] > 0  
			dbSelectArea("SRC")	
			cSeq:='0' 
			cVerb:=GetMv("MV_VEBEMP",,"704")
			Reclock("SRC",!dbSeek(Xfilial("SRC")+SRA->RA_MAT+cVerb+SRA->RA_CC+"  "+cSeq))
			Replace  RC_FILIAL  With Xfilial("SRC"),;
						RC_MAT     With SRA->RA_MAT, ;
						RC_TIPO1   With "V",;
						RC_TIPO2   With "G",;
						RC_PD      With cVerb,;
						RC_VALOR   With If(MV_PAR05=1,RC_VALOR+aVerb[nCount,3],aVerb[nCount,3]),;
						RC_HORAS   With aVerb[nCount,4],;
						RC_CC      With SRA->RA_CC ,;
						RC_SEQ     With cSeq
			MsUnlock()		
		Endif	
	Next nCount	
	dbSelectArea("SRA")
	dbSkip()	
EndDo	

Return()