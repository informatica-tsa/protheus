/*
+-----------------------------------------------------------------------+
¦Programa  ¦ ImpMedPJ  ¦ Autor ¦                      ¦ Data ¦29.07.2006¦
+----------+------------------------------------------------------------¦
¦Descriçào ¦ Rotina para gerar os pedidos de Compra para contratados    ¦
¦          ¦                                                            ¦
+----------+------------------------------------------------------------¦
¦ Uso      ¦ ESPECIFICO PARA EPC                                        ¦
+-----------------------------------------------------------------------¦
¦           ATUALIZACOES SOFRIDAS DESDE A CONSTRUCAO INICIAL            ¦
+-----------------------------------------------------------------------¦
¦PROGRAMADOR ¦ DATA   ¦ MOTIVO DA ALTERACAO                             ¦
+------------+--------+-------------------------------------------------¦
¦            ¦        ¦                                                 |
+-----------------------------------------------------------------------+
*/
#INCLUDE "RWMAKE.CH"
#Include "ap5mail.ch"
#INCLUDE "TOPCONN.CH"

User Function ImpMedPj()
*******************************************************************************************************************
* 
*
****  




/*GRUPO DE PERGUNTA 
MES DE REFERENCIA
MATRICULA DE............ATE
SETOR DE................ATE 
*/
Private cArqPjs:=Space(60)
Private cCompet:=GetMv('MV_FOLMES')
Private cEol:=Chr(13)+Chr(10)
Private cOrdCom := Space(06)
Private cNumEpc := Space(19)  
Private cMRateio1:='200705'
Private cMRateio2:='200706'

If cFilAnt=='01'
	
	@ 000,000 TO 210,400 DIALOG oDlg TITLE "Gera Pedido de Compras para Contratados"
	@ 005,005 TO 089,190 TITLE "Informe os Parametros"
	@ 025,007 SAY "Competencia: "
	@ 025,060 GET cCompet SIZE 40,70 VALID NaoVazio() .And. GFILEISSD("cArqPjs")
	@ 050,007 SAY "Mes Rateio: "
	@ 050,060 GET cMRateio1 SIZE 40,70 VALID NaoVazio()
	@ 050,110 GET cMRateio2 SIZE 40,70 VALID NaoVazio()
	@ 075,007 SAY 'Arquivo a ser importado'
	@ 075,070 Get cArqPjs Valid If( File(cArqPjs),.T.,MsgBox('Arquivo não Encontrado')) Object oGet01
	
	@ 090,150 BMPBUTTON Type 01 ACTION FOk(cArqPjs)
	
	ACTIVATE DIALOG oDlg CENTERED
Else
	MsgBox("Esta importação deve ser feita na Filial MATRIZ.")
Endif

Return()



Static Function GFILEISSD(cCampo)
****************************************************************************************************************
*
*
****

&cCampo:=cGetFile("Arquivo CSV| *.CSV|","Selecione o Arquivo",0,"C:\",.T.,GETF_LOCALHARD+GETF_LOCALFLOPPY)
oGet01:Refresh()

Return(.T.)



Static Function Fok(cArqPjs)
****************************************************************************************************************
*
*
*****
Local lValid:=.T.
Private cArqCrit:=""
Private nHandle:=Fopen(cArqPjs)
Private nTamFile:=0
Private nBtLidos:=0
oDlg:End()

If nHandle <0
	MsgBox("Erro ao Abrir arquivo: "+cArqPjs+"...")
	lValid:=.F.
	Return()
Endif
nTamFile:=fSeek(nHandle,0,2)

Processa({||VldFile(@lValid)},"Aguarde Validando o Arquivo",'Aguarde......')

If lValid
	Processa({||GerMovMes(@lValid)},"Aguarde Gerando Movimento do Mês",'Aguarde......')	
Endif

EnvMail()

dbSelectArea("TRBC")
dbCloseArea() 
FErase(cArqCrit)
FErase(StrTran(cArqCrit,'.DBF','.CDX'))



Return()



Static Function  VldFile(lValid)
**************************************************************************************************************
*
*
******* 
Local cErro:=""
Local aStru := {}
Local nVlrPC:=0
fSeek(nHandle,0,0)

//Cria o Arquivo de Criticas da ImportaçÃo
AADD(aStru, {"MATRIC"   ,"C",06, 0 })
AADD(aStru, {"CRITICA"  ,"M",10, 0 })
AADD(aStru, {"FORNECE"  ,"C",40, 0 })
AADD(aStru, {"CODFOR"   ,"C",40, 0 })
AADD(aStru, {"PEDCOMP"  ,"C",6, 0 })
AADD(aStru, {"GERPC"    ,"C",1, 0 })
AADD(aStru, {"VALORPC"  ,"N",12,2 })

cArqCrit := CriaTrab(aStru, .T.)
dbUseArea(.T.,,cArqCrit, "TRBC",.F.)

	dbSelectArea("TRBC")
	IndRegua("TRBC",cArqCrit,"MATRIC",,,"Criando Arquivo Trabalho ...")

//Linha do Cabeçalho
//Buffer:=RetLin(nHandle,@nBtLidos) 

While nBtLidos <= nTamFile
	cBuffer:=RetLin(nHandle,@nBtLidos)
	
	cMat:=RetText(cBuffer,1)
	If !Empty(Alltrim(cMat))
		cMat:=StrZero(Val(cMat),6)
		cValorMat:=StrTran(RetText(cBuffer,2),'R$','')
		cValorMat:=StrTran(cValorMat,'.','')
		cValorMat:=StrTran(cValorMat,',','')
		nVlrMat:=(Val(cValorMat)/100)
		
		If !SRA->(dbSeek('97'+cMat))
			FGravaCrit(cMat,"Matricula não encontrada no cadastro !",,'N')
		Else
			If Empty(SRA->RA_FOR)
				FGravaCrit(cMat,"Não Existe Fornecedor cadastrado para este contratado ",,'N')
			Endif
		Endif
		//Grava o Registro de Liberação para a geração do PC
		If !TRBC->(dbSeek(cMat))
			FGravaCrit(cMat,,,'S',nVlrMat)
		Endif
	Else
		Exit
	Endif	
EndDo
If !Empty(cErro)
	lValid:=.F.	
Endif
Return()



Static Function GerMovMes(lValid)  
**************************************************************************************************************
*
*
******* 
Local cVerbExt:='101'
Local cSemana:="  "
Local cSeq:="0"


dbSelectArea("TRBC")
dbGotop()
//Linha do Cabeçalho
While !Eof()
	If TRBC->GERPC=='S'
		dbSelectArea("SRA")
		dbSeek('97'+TRBC->MATRIC)
		
		//Verifica se há Pedido de compras para a Matricula dentro do periodo selecionado.
		cNumPedExist:=""
		cQuery:=" SELECT C7_NUM FROM "+RetSqlName("SC7")
		cQuery+=" WHERE C7_MAT='"+SRA->RA_MAT+"' AND C7_MESENTR='"+Right(cCompet,2)+"/"+Left(cCompet,4)+"'"
		cQuery+=" AND D_E_L_E_T_<>'*' AND C7_TIPREG='1'"
		TcQuery cQuery Alias QTMP NEW
		dbSelectArea("QTMP")
		dbGotop()
		If !Eof()
			cNumPedExist:=QTMP->C7_NUM
			//Listao Numero do Pedido já existente.
			dbSelectArea("QTMP")
			While !Eof()
				If Empty(QTMP->C7_NUM)
					FGravaCrit(SRA->RA_MAT,"Existe o Pedido Nro:"+QTMP->C7_NUM+" na Competência "+cCompet,,'N')
				Endif				
				dbSkip()
			EndDo
		Endif
		dbCloseArea()
		
		//Grava as Verbas na Tabela SRC
		dbSelectArea("SRC")	
		Reclock("SRC",!dbSeek(SRA->(RA_FILIAL+RA_MAT)+cVerbExt+SRA->RA_CC))
		Replace RC_FILIAL  With SRA->(RA_FILIAL),;
				RC_MAT     With SRA->RA_MAT ,;
				RC_TIPO1   With "H",;
				RC_PD      With cVerbExt,;
				RC_VALOR   With TRBC->VALORPC ,;
				RC_HORAS   With 1         ,;
				RC_CC      With SRA->RA_CC,;
				RC_PEDCOM  with cNumPedExist
		MsUnlock()
			//Gera o Pedido de Compras para o PJ
			If !GerPcom(@lValid)		
				FGravaCrit(SRA->RA_MAT,cEol+"Erro ao Gerar Pedido. Caso não haja críticas nas linhas acima, contacte o Administrador!",,'N')	
			Else
				If !Empty(SRA->RA_DEMISSA)
					FGravaCrit(SRA->RA_MAT,cEol+"Data de demissão/cancelamento dia: "+Dtoc(SRA->RA_DEMISSA)+cEol)
				Endif
				FGravaCrit(SRA->RA_MAT,"Pedido de Compras Nro:"+SRC->RC_PEDCOM+" Gerado Com sucesso",SRC->RC_PEDCOM+cEol)	
			Endif 
		//Else
			
		//Endif
		//Grava o Código e Nome do fornecedor
		cNomeFor:=Posicione("SA2",1,xFilial("SA2")+SRA->RA_FOR,"A2_NOME")
		dbSelectArea("TRBC")		
		Reclock("TRBC",.F.)
		Replace FORNECE With cNomeFor,;
				  CODFOR  With SRA->RA_FOR
		MsUnlock()		
	Endif
	dbSelectArea("TRBC")
	dbSkip()
EndDo

Return()



Static Function GerPcom(lValid)
*******************************************************************************************************************
*
*
******

Local cQuery:=""
Local nVlrTot:=0     
Local aHoraCCUsto:={}
Local nXi := 0

Private nQtdTot:=0

cQuery:=" SELECT  FIPCUSTO, "
cQuery+="         Convert(Char(5), "
cQuery+="            Cast(replace( CAST(FIPEPC.FIPHORAF AS varchar(5)) ,'.',':') as smalldatetime) "
cQuery+=" 	  - Cast(replace( CAST(FIPEPC.FIPHORAI AS varchar(5)) ,'.',':') as smalldatetime),108) AS HORASDIA "
cQuery+=" FROM FIPEPC "  
cQuery+=" INNER JOIN "+RetSqlName("SZ2")+" Z ON FIPEPC.FIPCUSTO = Substring(Z.Z2_COD,1,5) + '-' + Substring(Z.Z2_OS,1,2) + '-' + Substring(Z.Z2_SUBC,1,5) " 
cQuery+=" WHERE  CHAPA = '"+SRA->RA_MAT+"' AND FIPEMPRESA = '"+SM0->M0_CODIGO+"' AND " 
If cMRateio1<>cMRateio2
	cQuery+=" FIPEPC.FIPANOMES IN ('"+cMRateio1+"','"+cMRateio2+"') "
Else
	cQuery+=" FIPEPC.FIPANOMES ='"+cMRateio1+"'"
Endif
cQuery+=" ORDER BY FIPCUSTO "

TcQuery cQuery Alias QPCOM New
dbSelectArea("QPCOM")
dbGoTop()

While !Eof() 
	nMinItem:=(Val(Left(HORASDIA,2))*60)+Val(Right(HORASDIA,2))
	nQtdTot+=nMinItem
	nPos:=Ascan(aHoraCCUsto,{|x| x[1]==FIPCUSTO})
	If nPos <= 0
		Aadd(aHoraCCUsto,{FIPCUSTO,0,0})
		nPos:=Len(aHoraCCUsto)
	Endif
	aHoraCCUsto[nPos,2]+=nMinItem
	dbSkip()
EndDo

dbSelectArea("QPCOM")
dbCloseArea()
aItemPed:={} 
aCabPed:={}

If nQtdTot>0
	cLojaF=Posicione("SA2",1,Xfilial("SA2")+SRA->RA_FOR,"A2_LOJA")
	//Cabeçalho do Pedido de Compras
	aAdd(aCabPed,{"C7_FILIAL"  ,Xfilial("SC7")})// Filial
	aAdd(aCabPed,{"C7_NUM"     ,''            })
	aAdd(aCabPed,{"C7_EMISSAO" ,dDataBase     })// Data de Emissao
	aAdd(aCabPed,{"C7_FORNECE" ,SRA->RA_FOR   })// Fornecedor
	aAdd(aCabPed,{"C7_LOJA"    ,cLojaF        })// Loja do Fornecedor
	aAdd(aCabPed,{"C7_CONTATO" ,SRA->RA_NOME  })// Contato
	aAdd(aCabPed,{"C7_COND"    ,"100"         })// Condicao de pagamento
	aadd(aCabPed,{"C7_FILENT"  ,cFilAnt       })
	nValorTot:=0
	nVlrItem:=Round(SRC->RC_VALOR/(nQtdTot/60),2)  
	lMsErroAuto:=.F.
	For nXi := 1 To Len(aHoraCCUsto)
		cProdSC7:=BuscaProd(Substring(aHoraCCUsto[nXi,1],10,5))
		if !SB1->(dbSeek(Xfilial("SB1")+cProdSC7))
			FGravaCrit(SRC->RC_MAT,cEol+"Produto("+Alltrim(cProdSC7)+") Inválido para a SubConta:"+Alltrim(Substring(aHoraCCUsto[nXi,1],10,5)),,'N')
			lMsErroAuto:=.T.
		endif
		nQuant  :=NoRound((aHoraCCUsto[nXi,2]/60),2)
		nValorTot+=NoRound(nVlrItem*nQuant,2)
		If nQuant*nVlrItem>0                                                        	
			//Executa a rotina automática
			Aadd(aItemPed,{{"C7_ITEM"    ,StrZero(nXi,4),Nil},; //Numero do Item
						    {"C7_PRODUTO",cProdSC7,Nil},; //Codigo do Produto
							{"C7_QUANT"  ,nQuant          ,Nil},; //Quantidade
							{"C7_PRECO"  ,nVlrItem        ,Nil},; //Valor do Item do Pedido
							{"C7_DATPRF" ,Stod(cCompet+'01')	      ,Nil},; //Data De Entrega
							{"C7_FLUXO"  ,"N"			  ,Nil},; //Fluxo de Caixa (S/N)
							{"C7_CC"     ,Right(aHoraCCUsto[nXi,1],5),Nil},; //Fluxo de Caixa (S/N)
							{"C7_ITEMCTA",Substring(aHoraCCUsto[nXi,1],10,5),Nil},; // Item contábil
							{"C7_MAT"    ,SRA->RA_MAT     ,Nil  },;     
							{"C7_TIPREG" ,'1'             ,Nil  },;
							{"C7_LOCAL"  ,'04'            ,Nil}}) //Local Padrão
		///Else		 
		  ///	FGravaCrit(SRC->RC_MAT,"O Lançamento no C.Custo:"+Right(aHoraCCUsto[nXi,1],5)+" Com valor Zerado",,'N')
		Else
			FGravaCrit(SRA->RA_MAT,cEol+"Produto("+Alltrim(cProdSC7)+") Valor Zerado "+cEol,,'N')  
		Endif					
	Next nXi
	nOpc:=3
	
	lHelpAuto:=.T.
	cOrdCom := Space(06)
	cNumEpc := Space(19) 
	if !lMsErroAuto .aND. Len(aItemPed)>0
		MSExecAuto({|v,x,y,z| MATA120(v,x,y,z)},1,aCabPed,aItemPed,nOpc)
		//Acerta o Arredontamento do Item no pedido

		nUltRec:=0
		dbSelectArea("SC7")
		If dbSeek(Xfilial("SC7")+SRC->RC_PEDCOM)
			While !Eof() .And. SC7->C7_FILIAL=Xfilial("SC7") .And. SRC->RC_PEDCOM=SC7->C7_NUM
				nVlrTot:=nVlrTot-SC7->C7_TOTAL
				nUltRec:=Recno()
				dbSelectArea("SC7")
				dbSkip()
			EndDo
			If nVlrTot<>0
				dbSelectArea("SC7")
				dbGoto(nUltRec)
				If Reclock("SC7",.F.)
					nValorItem:=SC7->C7_TOTAL+(SRC->RC_VALOR+nVlrTot)
					nQuant:=(nValorItem/SC7->C7_PRECO)
					Replace  C7_TOTAL With nValorItem,;
								C7_QUANT With nQuant
					MsUnlock()		
				Endif
			Endif		
		Endif
	Else
		lMsErroAuto:=.t.	
	Endif
Else 
	FGravaCrit(SRC->RC_MAT,"Não Existe FIP cadastrada para este Contratado.",,'N')
	lMsErroAuto:=.t.
Endif
Return(!lMsErroAuto)



Static Function FGravaCrit(cMat,cCritica,cPedComp,CGerPC,nVlrPc)
*******************************************************************************************************************
*
*
******
Local aAreaAnt:=GetArea()
Local cCritTRBC :=If(cCritica=Nil,"",cCritica)
Local cPedTRBC  :=If(cPedComp=Nil,"",cPedComp)
Local CGerPCTRBC:=If(cGerPC=Nil  ,"",cGerPC)
Local nVlrPCTRBC:=If(nVlrPc=Nil,0,nVlrPc) 

dbSelectArea("TRBC")
Reclock("TRBC",!dbSeek(cMat))
Replace MATRIC  With cMat,;
		CRITICA With CRITICA+cCritTRBC,;
		PEDCOMP With If(Empty(cPedTRBC),PEDCOMP,cPedTRBC),;
		GERPC   with If(Empty(CGerPCTRBC),GERPC,CGerPCTRBC),;
		VALORPC With nVlrPCTRBC
		
MsUnlock()

RestArea(aAreaAnt)
Return()



Static Function RetText(cBuffer,nPos)
*******************************************************************************************************************
*
*
*******
Local cByte:=""
Local cRet:=""
Local nCont:=0
Local nXi:=0

For nXi:=1 to Len(cBuffer)
	If SubStr(cBuffer,nXi,1)==';'
		nCont++
	Endif	
	If nCont ==(nPos-1) .And. SubStr(cBuffer,nXi,1)<>';'
		cRet+=SubStr(cBuffer,nXi,1)
	Endif
Next nXi

Return(cRet)



Static Function RetLin(nHandle,nBtLidos)
******************************************************************************************************************
*
*
******
Local cEol:=Chr(10)
Local cBuffer:=""
Local cByte:=""
While !cByte$cEol .And. nBtLidos <= nTamFile
	cByte:=""
	fRead(nHandle,@cByte,1) //Leitura da primeira linha do arquivo texto
	If cByte<>Chr(13) .And. cByte<>Chr(10)
		cBuffer+=cByte
	Endif
	nBtLidos++
EndDo
Return(cBuffer)

Static Function BuscaProd(cCustoFIP)
*******************************************************************************************************************
*
*
*****
Local cProd:=" "
Local cCodPesq:=" "
Local cSubcAdm:=" "
///Local cCond:= If(Substr(cCustoFIP,2,1)=='9',"SA5->A5_TIPPROD=='A'","SA5->A5_TIPPROD=='P'")

dbSelectArea("CTT")
If CTT->(dbSeek(Xfilial("CTT")+Alltrim(cCustoFIP))) .And. CTT->CTT_BLOQ='1'
	//FGravaCrit(SRC->RC_MAT,cEol+"C.Custo :"+Alltrim(cCustoFIP)+" Bloqueado para lançamentos",,'N')
	//lMsErroAuto:=.T.
Endif

cQuery:=" SELECT Z2_SETOR,Z2_SUBC FROM SZ2010 "
cQuery+=" WHERE LEFT(Z2_SUBC,1)='9' AND RIGHT(rtrim(Z2_LETRA),1)='A' "
cQuery+=" AND D_E_L_E_T_<>'*' AND Z2_SETOR IN "
cQuery+=" (SELECT DISTINCT Z2_SETOR FROM SZ2010 "
cQuery+=" WHERE Z2_SUBC='"+Alltrim(cCustoFIP)+"' AND D_E_L_E_T_<>'*' ) "

TcQuery cQuery Alias QSUBC New

DbSelectArea("QSUBC")
dbGotop()
If !Eof()
	cSubcAdm:=QSUBC->Z2_SUBC
Endif
dbCloseArea()


dbSelectArea("CTD")
dbSetOrder(1)
If CTD->(dbSeek(Xfilial("CTD")+Alltrim(cCustoFIP)))

	If CTD->CTD_BLOQ='1'
		//FGravaCrit(SRC->RC_MAT,cEol+"SubConta :"+Alltrim(cCustoFIP)+" Bloqueado para lançamentos",,'N')
		//lMsErroAuto:=.T.
		cCustoFIP:=cSubcAdm
	Endif	 
	If Posicione("SZ2",3,Xfilial("SZ2")+Alltrim(cCustoFIP),"Z2_SITUAC")='3'
		//FGravaCrit(SRC->RC_MAT,cEol+"Subconta:"+Alltrim(cCustoFIP)+" Esta encerrada contabilmente e não pode receber lançamentos",,'N')
		///lMsErroAuto:=.T.
		cCustoFIP:=cSubcAdm
	Endif	
	cProd:=CTD->CTD_PRODPJ
Endif

//Valida Novamente o C.Custo Administrativo
If cCustoFIP == cSubcAdm
	dbSelectArea("CTD")
	dbSetOrder(1)
	If CTD->(dbSeek(Xfilial("CTD")+Alltrim(cCustoFIP)))
	
		If CTD->CTD_BLOQ='1'
			FGravaCrit(SRC->RC_MAT,cEol+"SubConta :"+Alltrim(cCustoFIP)+" Bloqueado para lançamentos",,'N')
			lMsErroAuto:=.T.
		Endif	 
		If Posicione("SZ2",3,Xfilial("SZ2")+Alltrim(cCustoFIP),"Z2_SITUAC")='3'
			FGravaCrit(SRC->RC_MAT,cEol+"Subconta:"+Alltrim(cCustoFIP)+" Esta encerrada contabilmente e não pode receber lançamentos",,'N')
			lMsErroAuto:=.T.
		Endif	
		cProd:=CTD->CTD_PRODPJ
	Endif
Endif

Return(cProd)



Static Function EnvMail()
************************************************************************************************************************
*
*
*******
Local cCabec    := ""
Local cTexto    := ""
Local cRoda     := ""
Local cMens     := "CRITICA DE IMPORTAÇÃO DOS PEDIDOS DE COMPRA"+cEol
Local cCtaMail  := ""
Local cAccount  := GetMv("MV_WFACC") 
Local cCtaPass  := GetMv("MV_WFPASSW")
Local cCtaSmpt  := GetMv("MV_WFSMTP") 
Local cSendBy   := GetMv("MV_MAILPJS",,'')
Local cArqCrit  :=CriaTrab("",.F.)

cCtaMail:=cSendBy
cMat:="*"
dbSelectArea("TRBC")
IndRegua("TRBC",cArqCrit,"FORNECE",,,"Criando Arquivo Trabalho ...")
dbGotop()
While !Eof()
	If SRA->(dbSeek('97'+TRBC->MATRIC))
		SA2->(dbSeek(Xfilial("SA2")+SRA->RA_FOR))
		cMens+=""+SA2->A2_COD+"-"+Padc(Left(SA2->A2_NOME,30),30)+":"+TRBC->CRITICA+cEol
		If !Empty(TRBC->PEDCOMP)
			//Monta a Lista de Itens e Totaliza o Pedido de Compras
			nVlrTot:=0
			dbSelectArea("SC7")
			dbSeek(Xfilial("SC7")+TRBC->PEDCOMP)
			While !Eof() .And. SC7->C7_FILIAL=Xfilial("SC7") .And. TRBC->PEDCOMP=SC7->C7_NUM
				cMens+="Item: "+Alltrim(SC7->C7_PRODUTO)+'-'+Alltrim(Str(SC7->C7_TOTAL,12,2))+cEol
				nVlrTot+=SC7->C7_TOTAL
				dbSelectArea("SC7")				
				dbSkip()
			EndDo
			cMens+="Total do Pedido:"+Alltrim(Str(nVlrTot,12,2))+cEol+cEol
		Endif
		
	Else 
		cMens+=+TRBC->MATRIC+" :"+TRBC->CRITICA+cEol
	Endif
	dbSelectArea("TRBC")
	dbSkip()
EndDo

CONNECT SMTP SERVER cCtaSmpt ACCOUNT cAccount PASSWORD cCtaPass 
SEND MAIL FROM  cSendBy TO  cCtaMail ; 
SUBJECT 'Importação do Pedido de Compras para PJ' ;
BODY cMens

DISCONNECT SMTP SERVER

Return
