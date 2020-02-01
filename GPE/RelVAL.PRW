#Include "PROTHEUS.Ch"
#Include "TopConn.ch"

User Function RELVAL()

Local cTitulo 		:= " Relatório de Vale Alimentação"
Local lRet			:= .T.
PRIVATE nLastKey 	:= 0
PRIVATE cPerg	 	:= "LISVRA"
PRIVATE aLinha		:= {}
Private aPerg:={}
Private cPerg:="LISVRA"
PRIVATE nomeProg 	 := "LISVRA"
m_pag		:= 1

AADD(aPerg,{cPerg,"Centro de Custo de  ?","C",09,0,"G","","CTT","","","","",""})
AADD(aPerg,{cPerg,"Centro de Custo Até ?","C",09,0,"G","","CTT","","","","",""})
AADD(aPerg,{cPerg,"Tipo                ?","N",01,0,"C","","","Analítico","Sintético","","",""})
AADD(aPerg,{cPerg,"Cod Vale De...?","C",03,0,"G","","","","","","",""})
AADD(aPerg,{cPerg,"Cod Vale Ate..?","C",03,0,"G","","","","","","",""})
AADD(aPerg,{cPerg,"Tipo de Vale  ?","N",01,0,"C","","","VR","VA","TODOS","",""})
AADD(aPerg,{cPerg,"Ordem de Impressão"   ,"N",09,0,"C","","","Nome","Centro de Custo","Matricula","",""})
PutSx1(cPerg,"08",OemToAnsi("Filial Inicial ?")    ,OemToAnsi("Filial Inicial ?")    ,OemToAnsi("Filial Inicial ?")    ,"mv_ch8","C",02,0,0,"G","","","","","mv_par08","","","","","","","","","","","","","","","","",{ OemToAnsi("Define a filial inicial para filtro")}, {}, {} )
PutSx1(cPerg,"09",OemToAnsi("Filial Final ?")      ,OemToAnsi("Filial Final ?")      ,OemToAnsi("Filial Final ?")      ,"mv_ch9","C",02,0,0,"G","","","","","mv_par09","","","","","","","","","","","","","","","","",{ OemToAnsi("Define a filial final para filtro")}, {}, {} )



Pergunte(cPerg,.F.)

If !Pergunte("LISVRA",.T.)
	Return
EndIf	
nOrdImp:=MV_PAR07
wnrel := "LISVRA"            

Processa({|| CursorWait(), GerList(cTitulo) ,CursorArrow()},"Aguarde....")

Return

Static Function GerList(cTitulo)
******************************************************************************************************************************
*
*
*****
Local oPrint
Local i 	:= 1
 //Define se a folha de parametros sera impressa no inicio
Local cNameFile		:= ""                 
Private nlin 	:= 0                        
Private oFont16, oFont08, oFont10 , oFont14
Private aResTp:={}
Private aRes:={}
Private nPag:=0
Private cCCCust:=""

cQuery:=" SELECT DISTINCT RA_MAT, RA_NOME,RA_CC,CTT_DESC01,SZQ.* FROM "+RetSqlName("SRA")+" SRA "
cQuery+=" INNER JOIN "+RetSqlName("SZQ")+" SZQ ON (SRA.RA_MAT=SZQ.ZQ_MAT AND SZQ.D_E_L_E_T_<>'*' "
cQuery+=" AND ZQ_CODVALE BETWEEN '"+MV_PAR04+"' AND '"+MV_PAR05+"') "
cQuery+=" INNER JOIN "+RetSqlName("CTT")+" CTT ON (CTT.CTT_FILIAL='"+Xfilial("CTT")+"' AND CTT.CTT_CUSTO=SRA.RA_CC      AND CTT.D_E_L_E_T_<>'*') "
cQuery+=" INNER JOIN "+RetSqlName("SZP")+" SZP ON (SZP.ZP_FILIAL='"+Xfilial("SZP")+"'  AND SZP.ZP_CODIGO=SZQ.ZQ_CODVALE AND SZP.D_E_L_E_T_<>'*') "
cQuery+=" WHERE SRA.RA_FILIAL BETWEEN '"+MV_PAR08+"' AND '"+MV_PAR09+"' AND SRA.RA_DEMISSA='' "
cQuery+=" AND RA_CC BETWEEN '"+MV_PAR01+"' AND '"+MV_PAR02+"'"
cQuery+=" AND  SRA.D_E_L_E_T_<>'*' "
If  MV_PAR06<>3 
	If MV_PAR06==1 
	  cQuery+=" AND SZP.ZP_TIPO='VR' "
	Else 
	  cQuery+=" AND SZP.ZP_TIPO='VA' "
	Endif 
Endif

cQuery+=" ORDER BY "
do Case
	Case nOrdImp=1
		cQuery+=" RA_NOME"
	Case nOrdImp=2
		cQuery+=" SRA.RA_CC,RA_NOME"
	Case nOrdImp=3
		cQuery+=" RA_MAT"
EndCase
TcQuery cQuery Alias QSRA New

oFont08	:= TFont():New("Courier New",08,08,,.F.,,,,.T.,.F.)
oFont10	:= TFont():New("Arial",10,10,,.F.,,,,.T.,.F.)
oFont10N	:= TFont():New("Arial",10,10,,.T.,,,,.T.,.F.)
oFont14	:= TFont():New("Arial",14,14,,.F.,,,,.T.,.F.)
oFont16	:= TFont():New("Arial",16,16,,.T.,,,,.T.,.F.)
oFont20	:= TFont():New("Arial",20,20,,.T.,,,,.T.,.F.)

oPrint:= TMSPrinter():New(cTitulo)
//oPrint:SetLandscape()
//oPrint:Portable()
nLin:=ImpCab(oPrint,1)

dbSelectArea("QSRA")
dbGotop()
While QSRA->(!Eof())   
	SZP->(dbSeek(xFilial("SZP")+QSRA->ZQ_CODVALE))
	If MV_PAR06<>3 .And. SZP->ZP_TIPO$If(MV_PAR06==2,'VR','VA')
		dbSelectArea("QSRA")
		dbSkip()
		Loop
	Endif
	ImpDet(oPrint,@nLin)
	dbSelectArea("QSRA")
	dbSkip()
EndDo
oPrint:Box(4200,50,4600,2400)
ImpRes(oPrint,nLin)
dbSelectArea("QSRA")
dbCloseArea()
oPrint:Preview()  				// Visualiza antes de imprimir

Return()



Static Function ImpCab(oPrint,nTp)
****************************************************************************************************************
*
*
*****
Local cCompet:=GetMv("MV_FOLMES")
Local nAnoComp:=Val(Left(cCompet,4))
Local nMesComp:=Val(Right(Alltrim(cCompet),2))+1

If nMesComp >=13
	nMesComp=1
	nAnoComp=nAnoComp+1
Endif

cCompet:=StrZero(nMesComp,2)+'/'+StrZero(nAnoComp,4)
nPag++
cCCCust:=QSRA->RA_CC
cNameFile  := "epc"+cEmpAnt+cFilAnt+".bmp"
If !File(cNameFile)
	cNameFile := "epc"+cEmpAnt+".bmp"
Endif
oPrint:SayBitmap(10,50,cNameFile,400,250)
oPrint:Say(100,500,"RELATÓRIO DE VALE ALIMENTAÇÃO / REFEIÇÃO ",oFont16)
oPrint:Box(050,2000,180,2350)
oPrint:Say(055,2020 ,"Pagina:"+Str(nPag,2),oFont08)
oPrint:Say(090,2020 ,"Data.:"+Dtoc(Date()),oFont08)
oPrint:Say(120,2020 ,"Hora.:"+Time(),oFont08)
oPrint:Say(230,0050  ,"Ref. a Competencia:"+cCompet,oFont14)
If nTp==1
	If nOrdImp==2
		oPrint:Say(290,0050  ,"Centro de Custo...:"+QSRA->RA_CC+" - "+Posicione("CTT",1,Xfilial("CTT")+cCCCust,"CTT_DESC01"),oFont14)
	Endif
	oPrint:Box(350,50,400,2350)
	oPrint:Say(350,50  ,"Chapa",oFont10)
	oPrint:Say(350,200 ,"Funcionário",oFont10)
	oPrint:Say(350,850 ,"Dias Uteis",oFont10)
	oPrint:Say(350,1050,"Valor",oFont10)
	oPrint:Say(350,1200,"Total",oFont10)
	oPrint:Say(350,1400,"Desconto",oFont10)
	oPrint:Say(350,1600,"Tipo",oFont10)
	oPrint:Say(350,1800,"Assinatura",oFont10)
	nLin:=400
Else
	nLin:=400		
Endif
/*
For ny:=0 To 2000 Step 100
	oPrint:Say(ny,01,StrZero(ny,4),oFont10)
Next Ny
For nx:=0 To 3500 Step 100
	oPrint:Say(1,nx,StrZero(nx,4),oFont10)
Next nx
  */
Return(nLin)



Static Function ImpDet(oPrint,nLin)
**************************************************************************************************************
*
*
*******          
Local nPosRes:=0
Local nPosTp:=0

If nlin > 3300 .Or. (MV_PAR07==2 .And. cCCCust<>QSRA->RA_CC)
	oPrint:EndPage()
	oPrint:StartPage()
	nLin:=ImpCab(oPrint,1)	
Endif

SZP->(dbSeek(xFilial("SZP")+QSRA->ZQ_CODVALE))
nTotFun:=QSRA->(ZQ_CUSFUN+ZQ_CUSEMP)

//Centro de Custo
nPosRes:=Ascan(aRes,{|x| Alltrim(x[1])==Alltrim(QSRA->RA_CC)})
If nPosRes==0
	AADD(aRes,{QSRA->RA_CC,0,0})
	nPosRes:=Len(aRes)
Endif

aRes[nPosRes,2]+=nTotFun
aRes[nPosRes,3]+=QSRA->ZQ_CUSEMP

// TIPO
nPosTp:=Ascan(aResTp,{|x| Alltrim(x[1])==Alltrim(SZP->ZP_TIPO)})
If nPosTp==0
	AADD(aResTp,{SZP->ZP_TIPO,0,0})
	nPosTp:=Len(aResTp)
Endif
aResTp[nPosTp,2]+=nTotFun
aResTp[nPosTp,3]+=QSRA->ZQ_CUSEMP

oPrint:Say(nLin,050,QSRA->RA_MAT,oFont10)
oPrint:Say(nLin,200,QSRA->RA_NOME,oFont10)
oPrint:Say(nLin,900 ,TransForm(QSRA->ZQ_QTDE,"@E 999"),oFont10,,,,1)
oPrint:Say(nLin,1120,TransForm(QSRA->ZQ_VALOR,"@E 9,999.99"),oFont10,,,,1)
oPrint:Say(nLin,1270,TransForm(nTotFun,"@E 9,999.99"),oFont10,,,,1)
oPrint:Say(nLin,1530,TransForm(QSRA->ZQ_CUSFUN,"@E 9,999.99"),oFont10,,,,1)
oPrint:Say(nLin,1600,SZP->ZP_TIPO,oFont10)

oPrint:Line(nLin+50,50,nLin+50,2350)
nLin+=60
Return(nLin+1)



Static Function ImpRes(oPrint,nLin)
**************************************************************************************************************
*
*
*******          

Local nCount := 0

oPrint:EndPage()
oPrint:StartPage()
ImpCab(oPrint,2)	
nLin:=350
nLinFim:=nLin+((Len(aResTp)+1)*60)
nTot1:=0
nTot2:=0
nTot3:=0

//Imprime o Resumo Por Tipo
oPrint:Box(nLin,50,nLinFim,2000)
oPrint:Say(nLin,80,"Tipo",oFont10N)
oPrint:Say(nLin,700,"Vlr Funcionário",oFont10N)
oPrint:Say(nLin,1100,"Vlr Empresa",oFont10N)
oPrint:Say(nLin,1600,"Vlr Total",oFont10N)
oPrint:Line(nLin,590,nLinFim,590)
oPrint:Line(nLin,990,nLinFim,990)
oPrint:Line(nLin,1390,nLinFim,1390)
oPrint:Line(nLin+50,50,nLin+50,2000)
nLin+=70

For nCount := 1 To Len(aResTp)
	oPrint:Say(nLin,060,aResTp[nCount,1]+'-'+Tabela("Z4",aResTp[nCount,1]),oFont10)
	oPrint:Say(nLin,750 ,TransForm(aResTp[nCount,2],"@E 99999.99"),oFont10,,,,2)
	oPrint:Say(nLin,1150,TransForm(aResTp[nCount,3],"@E 999,999.99"),oFont10,,,,2)
	oPrint:Say(nLin,1650,TransForm(aResTp[nCount,2]+aResTp[nCount,3],"@E 999,999.99"),oFont10,,,,2)
	nTot1+=aResTp[nCount,2]
	nTot2+=aResTp[nCount,3]
	nTot3+=aResTp[nCount,2]+aResTp[nCount,3]
	nLin+=60
Next nCount

oPrint:Box(nLinFim+10,50,nLinFim+(50*2),2000)
oPrint:Line(nLinFim+10,590,nLinFim+(50*2),590)
oPrint:Line(nLinFim+10,990,nLinFim+(50*2),990)
oPrint:Line(nLinFim+10,1390,nLinFim+(50*2),1390)

oPrint:Say(nLinFim+50,060,"Total...:",oFont10N)
oPrint:Say(nLinFim+50,750 ,TransForm(nTot1,"@E 999,999.99"),oFont10N,,,,2)
oPrint:Say(nLinFim+50,1150,TransForm(nTot2,"@E 999,999.99"),oFont10N,,,,2)
oPrint:Say(nLinFim+50,1650,TransForm(nTot3,"@E 999,999.99"),oFont10N,,,,2)
nLin:=nLinFim+200
 
//Resumo por Centro de Custo
nTot1:=0
nTot2:=0
nTot3:=0
nLinFim:=nLin+((Len(aRes)+1)*60)

oPrint:Box(nLin,50,nLinFim,2000)
oPrint:Say(nLin,60,"Centro de Custo",oFont10N)
oPrint:Say(nLin,1220,"Vlr Funcionário",oFont10N)
oPrint:Say(nLin,1500,"Vlr Empresa",oFont10N)
oPrint:Say(nLin,1800,"Vlr Total",oFont10N)

oPrint:Line(nLin,1200,nLinFim,1200)
oPrint:Line(nLin,1450,nLinFim,1450)
oPrint:Line(nLin,1700,nLinFim,1700)
oPrint:Line(nLin+50,50,nLin+50,2000)

nLin+=70
For nCount:=1 To Len(aRes)
	CTT->(dbSeek(xFilial("CTT")+aRes[nCount,1]))
	oPrint:Say(nLin,060,QSRA->RA_CC+'-'+CTT->CTT_DESC01,oFont10)
	oPrint:Say(nLin,1440 ,TransForm(aRes[nCount,2],"@E 99999.99"),oFont10,,,,1)
	oPrint:Say(nLin,1680,TransForm(aRes[nCount,3],"@E 999,999.99"),oFont10,,,,1)
	oPrint:Say(nLin,1980,TransForm(aRes[nCount,2]+aRes[nCount,3],"@E 999,999.99"),oFont10,,,,1)
	nTot1+=aRes[nCount,2]
	nTot2+=aRes[nCount,3]
	nTot3+=aRes[nCount,2]+aRes[nCount,3]
	nLin+=60
Next nCount
oPrint:Box(nLinFim+10,50,nLinFim+(50*2),2000)
oPrint:Line(nLinFim+10,1200,nLinFim+(50*2),1200)
oPrint:Line(nLinFim+10,1450,nLinFim+(50*2),1450)
oPrint:Line(nLinFim+10,1700,nLinFim+(50*2),1700)

oPrint:Say(nLinFim+50,060,"Total...:",oFont10N)
oPrint:Say(nLinFim+50,1440 ,TransForm(nTot1,"@E 99999.99"),oFont10N ,,,,1)
oPrint:Say(nLinFim+50,1680,TransForm(nTot2,"@E 999,999.99"),oFont10N,,,,1)
oPrint:Say(nLinFim+50,1980,TransForm(nTot3,"@E 999,999.99"),oFont10N,,,,1)
nLin+=50
Return(nLin+1)

/*
-----------------------------------------------------------------------
|Centro de Custo               | Funcionário |  Empresa  |    Total   |
|---------------------------------------------------------------------|
|                              |             |           |            |
|                              |             |           |            |
|                              |             |           |            |
|                              |             |           |            |
|                              |             |           |            |
|                              |             |           |            |
|                                                                     |
-----------------------------------------------------------------------
  */




