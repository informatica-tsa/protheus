#Include "Rwmake.ch" 

User Function CadSZR()
****************************************************************************************************
* Cadastro de Planos de Saude
*
*******
cCadastro:="Cadastro de Planos de Saude"
aRotina:={{"Pesquisar" ,"AxPesqui",0,1},;
          {"Visualizar",'U_MODSZR',0,2},;
          {"Incluir"   ,'U_MODSZR',0,3},;
          {"Alterar"   ,'U_MODSZR',0,4},;
          {"Excluir"   ,'U_MODSZR',0,5},;
          {"Reajuste"  ,'U_REAJSZR',0,5},;
          {"Gerar Movimentos",'U_MOVPLS',0,2}}

dbSelectArea("SZR") 
dbSetOrder(1)       

mBrowse(06,08,22,71,"SZR")

Return()



User Function MODSZR(cAlias,nRecno,nOpcx)
****************************************************************************************************
* Monta a tela de Manutenção
*
*****

Local cTitulo:="Cadastro de Plano de Saude"
Local aC:={}
Local aR:={}
Local nxI := 0

Private aHeader:={}
Private aCols:={}

aCGD:={100,5,250,350}
aCordW:={200,200,400,800}

cLinhaOk := "AllWaysTrue() .And. U_VldLinSZR()"
cTudoOk  := "AllWaysTrue() .And. U_VldLinSZR()"
RegToMemory("SZR",nOpcx==3)


AADD(aC,{"M->ZR_PLANO"   ,{16,010},"Codigo.....:"     ,"@!","ExistChav('SZR') .And. ExistCpo('SX5','Z3'+M->ZR_PLANO,1)","Z3",Inclui})
AADD(aC,{"M->ZR_DESC"    ,{16,100},"Descrição.....:"  ,"@!",'!Empty(M->ZR_DESC)',,.T.})
AADD(aC,{"M->ZR_VALOR"   ,{36,010},"Valor Plano.:"    ,"@E 99999.99",'',,.T.})
AADD(aC,{"M->ZR_TRAEREO" ,{36,100},"Tx Transp Aéreo:" ,"@E 99999.99",,,.T.})
AADD(aC,{"M->ZR_TXODONT" ,{36,200},"Tx Odontológico:" ,"@E 99999.99",,,.T.})
AADD(aC,{"M->ZR_TXIMPLA" ,{36,300},"Tx Implantação:"  ,"@E 99999.99",,,.T.})
AADD(aC,{"M->ZR_VERBFUN" ,{56,010},"Verba Funcionário:","@E 999",,"SRV",.T.})
AADD(aC,{"M->ZR_VERBAGR" ,{56,100},"Verba Agregado:"   ,"@E 999",,"SRV",.T.})

dbSelectArea("SX3")
dbSeek("SZR")
While !Eof() .And. (X3_ARQUIVO == "SZR")
	IF X3USO(X3_USADO) .And. cNivel >= x3_nivel .And. Ascan(ac,{|x| Substr(Alltrim(x[1]),4)==Alltrim(X3_CAMPO)})=0
		
		AADD(aHeader,{ALLTRIM(X3_TITULO),X3_CAMPO,X3_PICTURE,X3_TAMANHO,;
                    X3_DECIMAL,X3_VALID,X3_USADO,X3_TIPO,X3_ARQUIVO})	
	Endif	
	dbSelectArea("SX3")
	dbSkip()
EndDo
dbSelectArea("SZR")
dbSetOrder(1)
dbSeek(xFilial("SZR")+M->ZR_PLANO)
While (! Eof()) .and. (SZR->ZR_FILIAL== xFilial("SZR") ) .and. (SZR->ZR_PLANO == M->ZR_PLANO)
	AADD(aCols,Array(Len(aHeader)+1))
	For nxI := 1 To Len(aHeader)
		aCols[Len(aCols),nxI]:=FieldGet(FieldPos(aHeader[nxI,2]))
	Next nxI
	aCols[Len(aCols),Len(aHeader)+1]:=.F.
	dbSelectArea("SZR")
	dbSkip()
EndDo
If Len(aCols)<=0
	aCols := {Array(Len(aHeader) + 1)}
	For nxI := 1 to Len(aHeader)
		aCols[1,nxI] := CRIAVAR(aHeader[nxI,2])
	Next
	aCols[1,Len(aHeader)+1] := .F.
Endif   

lRetMod2 := Modelo2(cTitulo,aC,aR,aCGD,nOpcx,cLinhaOk,cTudoOk,,,"M->ZR_ITEM",,aCordW)
If nOpcx=3 .And. lRetMod2
	ConfirmSx8()
Else	 
	RollBackSx8()
Endif
If lRetMod2 .And. nOpcx<>2
	GravaSZR(nOpcx)
Endif  

Return()



Static Function GravaSZR(nOpcx)
****************************************************************************************
* Grava os Dados
*
****

Local nGrvSZR := 0
Local nHead := 0

Private cCampo:=""
dbSelectArea("SZR")
dbSetOrder(1)
If nOpcx<>5
	For nGrvSZR:=1 To Len(Acols)
		If !GdDeleted(nGrvSZR)
			dbSelectArea("SZR")
			dbSetOrder(1)			
			If Reclock("SZR",!dbSeek(Xfilial("SZR")+M->ZR_PLANO+GdFieldGet("ZR_ITEM",nGrvSZR)))
				For nHead := 1 To Len(aHeader)
					cCampo:="SZR->"+aHeader[nHead,2]
					&cCampo:=GdFieldget(aHeader[nHead,2],nGrvSZR)
				Next nHead
				//Grava os campos chaves
				Replace  ZR_PLANO   With M->ZR_PLANO  ,;
		   				ZR_DESC    With M->ZR_DESC   ,;
	 						ZR_VALOR   With M->ZR_VALOR  ,;
							ZR_TRAEREO With M->ZR_TRAEREO,;
							ZR_TXODONT With M->ZR_TXODONT,;
 							ZR_VERBFUN With M->ZR_VERBFUN,;
							ZR_VERBAGR With M->ZR_VERBAGR,;
							ZR_TXIMPLA With M->ZR_TXIMPLA
			Endif	
			MsUnlock()
		Else 
			If dbSeek(Xfilial("SZR")+M->ZR_PLANO+GdFieldGet("ZR_ITEM",nGrvSZR))
				Reclock("SZR",.F.)
				dbDelete()        
				MsUnlock()
			Endif
		Endif
	Next nGrvSZR
Else  
	dbSelectArea("SZR")
	If dbSeek(Xfilial("SZR")+M->ZR_PLANO)
		While !Eof() .And. Xfilial("SZR")==SZR->ZR_FILIAL .And. M->ZR_PLANO==SZR->ZR_PLANO
			Reclock("SZR",.F.)
			dbDelete()
			MsUnlock()
			dbSkip()
		EndDo
	Endif
Endif

Return()



User Function VldLinSZR()
***********************************************************************************************************************
*
*
****
Local nCont:=1
Local nLinx:=1
Local nValorDe:=0
Local nValorAte:=0
Local lRet:=.T.
Local nFor:=0
Local aTps:={'E','S'}

cMens:=""
/// Valida o Valor de
For nFor=1 To len(aTps)
	For nCont:=1 To Len(aCols)
		//Valida a Linha
		If !GdDeleted(nCont) .And. GdFieldGet("ZR_TIPO",nCont)==aTps[nFor]
			nValorDe :=GDFieldGet("ZR_FXDE",nCont)	
			nValorAte:=GDFieldGet("ZR_FXATE",nCont)
			For nLinx:=nCont To Len(aCols)
				If !GdDeleted(nLinx) .And. nLinx<>nCont .And. GdFieldGet("ZR_TIPO",nLinx)==aTps[nFor]
					If nValorde  >= GDFieldGet("ZR_FXDE" ,nLinx) .Or.;
						nValorAte >= GDFieldGet("ZR_FXATE",nLinx) .Or.;
						nValorAte >= GDFieldGet("ZR_FXDE" ,nLinx)
						lRet:=.F.
						cMens:=" Erro nos intervalos de Faixa salarial/Etária"
					Endif
				Endif
			Next nLinx
		Endif
		If lRet 
			If GdFieldGet("ZR_TIPO",nCont)='S'
				If GdFieldGet("ZR_VDESC",nCont)>0
					lRet:=.F.
					cMens:=" Para faixa Salarial Deve Ser Informado o Percentual de Desconto."
				Endif
			ElseIf GdFieldGet("ZR_TIPO",nCont)='E'
				If GdFieldGet("ZR_PDESC",nCont)>0
					lRet:=.F.
					cMens:=" Para Faixa Etária Deve Ser Informado o Valor do Desconto."
				Endif
			Endif
		Endif
	Next nCont
Next nFor
//Aviso ao usuário
If !lRet
	MsgBox(cMens,".: ATENCAO :.","STOP")
Endif  

Return(lRet)



User Function REAJSZR(cAlias,nRecno,nOpcx)
**************************************************************************************************************
*
*
****  
Local aPerg:={}
Local cPerg:="SZR001"
AADD(aPerg,{cPerg,"Plano de     ?","C",06,0,"G","","","","","","",""})
AADD(aPerg,{cPerg,"Plano Até    ?","C",06,0,"G","","","","","","",""})
AADD(aPerg,{cPerg,"Perc. Reaj. Plano ?","N",5,2,"G","","","","","","",""})
AADD(aPerg,{cPerg,"Perc. Reaj. Odont ?","N",5,2,"G","","","","","","",""})
AADD(aPerg,{cPerg,"Perc. Reaj. Aereo ?","N",5,2,"G","","","","","","",""})
AADD(aPerg,{cPerg,"Perc. Reaj. Desc.Agregado ?","N",5,2,"G","","","","","","",""})
AADD(aPerg,{cPerg,"Perc. Reaj. Tx Implantação?","N",5,2,"G","","","","","","",""})


If Pergunte(cPerg,.T.) .And. MsgBox("Confirma o Reajuste da Tabela ?","Pergunta","YESNO")
	//Faz o reajuste das Tabelas por Percentual
	dbSelectArea("SZR")
	dbSeek(Xfilial("SZR")+If(Empty(Alltrim(MV_PAR01)),'',Alltrim(MV_PAR01)))
	While !Eof() .And. ZR_PLANO<=MV_PAR02
		
		nVlrReaVlr:=ZR_VALOR	
		nVlrReaAer:=ZR_TRAEREO
		nVlrReaOd:=ZR_TXODONT	
		nVlrReaAg:=ZR_VDESC      
		nTxImplan:=ZR_TXIMPLA
		If MV_PAR03 > 0
			nVlrReaVlr:=ZR_VALOR*((100+MV_PAR03)/100)
		Endif
		
		If MV_PAR04 > 0
			nVlrReaAer:=ZR_TRAEREO*((100+MV_PAR04)/100)
		Endif
		
		If MV_PAR05 > 0
			nVlrReaOd:=ZR_TXODONT*((100+MV_PAR06)/100)
		Endif
		
		If MV_PAR06 > 0
			nVlrReaAg:=ZR_VDESC*((100+MV_PAR06)/100)
		Endif		
		If MV_PAR07 > 0
			nTxImplan:=ZR_TXIMPLA*((100+MV_PAR07)/100)
		Endif		      
	
		dbSelectArea("SZR")
		Reclock("SZR",.F.)
		Replace  ZR_VALOR   With nVlrReaVlr,;
					ZR_TRAEREO With nVlrReaAer,;
					ZR_TXODONT With nVlrReaOd ,;
					ZR_VDESC   With nVlrReaAg,;
					ZR_TXIMPLA With nTxImplan
	   MsUnlock()
	   dbSkip()
	
	EndDo	
Endif
Return()



User Function MOVPLS()
******************************************************************************************
* Gera a Movimetação do Mes
*
****    
Local cPerg:="MOVPLS"
Local aPerg:={} 

AADD(aPerg,{cPerg,"Informe o Ano/Mes ?","C",07,0,"G","","","","","","",""})
AADD(aPerg,{cPerg,"Filial de... ?","C",02,0,"G","","","","","","",""})
AADD(aPerg,{cPerg,"Filial Até.  ?","C",02,0,"G","","","","","","",""})
AADD(aPerg,{cPerg,"Matricula de.. ?","C",06,0,"G","","SRA","","","","",""})
AADD(aPerg,{cPerg,"Matricula Até. ?","C",06,0,"G","","SRA","","","","",""})
AADD(aPerg,{cPerg,"Centro de Custo de  ?","C",09,0,"G","","CTT","","","","",""})
AADD(aPerg,{cPerg,"Centro de Custo Até ?","C",09,0,"G","","CTT","","","","",""})
AADD(aPerg,{cPerg,"Situação da Folha"    ,"C",05,0,"G","fsituacao","","","","","",""})
AADD(aPerg,{cPerg,"Categorias ?"         ,"C",15,0,"G","fcategoria","","","","","",""})



If Pergunte(cPerg,.T.) 
	cAnoMes:=MV_PAR01
	cFilDe :=MV_PAR02
	cFilAte:=MV_PAR03
	cMatDe :=MV_PAR04
	cMatAte:=MV_PAR05
	cCustoDe :=MV_PAR06
	cCustoAte:=MV_PAR07
	cSit     :=MV_PAR08
	cCat     :=MV_PAR09
	dbSelectArea("SM0")
	dbSeek(cEmpAnt+If(Empty(cFilDe),'',cFilDe))
	While !Eof() .And. cEmpAnt==SM0->M0_CODIGO .And. SM0->M0_CODFIL<=cFilAte
		cFilAnt:=SM0->M0_CODFIL
		dbSelectArea("SRA")
		dbSeek(Xfilial("SRA")+If(Empty(cMatDe),'',cMatde))
		While !Eof() .And. SRA->RA_MAT <= cMatAte
			If Empty(SRA->RA_DEMISSA) .And. SRA->RA_SITFOLH$cSit .And. SRA->RA_CATFUNC$cCat .And. ;
			SRA->RA_CC >=cCustoDe .And. SRA->RA_CC <=cCustoAte
			
				Processa({|| MCalcSZR()()},"Aguarde..","Gerando Movimento mensal...")
				
			Endif
			dbSelectArea("SRA")
			dbSkip()
		EndDo
		
		dbSelectArea("SM0")
		dbSkip()
	EndDo
Endif

Return()



Static Function MCalcSZR()
********************************************************************************************************
*
*
******

Local aVerb:={}
Local nNroMin:=0
Local nVlrTot:=0
Local nVlrFun:=0
Local nVlrEmp:=0
Local nCount := 0
	
dbSelectArea("SRX")
dbSeek(Xfilial("SRX")+'11')
If Alltrim(SRA->RA_CATFUNC)$'G'
	nNroMin:=Round(SRA->(RA_SALARIO*RA_HRSMES)/Val(SRX->RX_TXT),2)
Else
	nNroMin:=Round(SRA->RA_SALARIO/Val(SRX->RX_TXT),2)
Endif

nVlrTot:=0
nVlrFun:=0
nVlrEmp:=0
cCodVerb:=""
//Faz os lançamentos para o prório Funcionário
dbSelectArea("SZR")
dbSetOrder(1)
If !dbSeek(Xfilial("SZR")+SRA->RA_UNIMED)
	Return()
Endif
If SZT->(dbSeek(Xfilial("SZT")+SRA->RA_CC))
	dbSelectArea("SZT")
	While !Eof() .And. SRA->RA_CC==SZT->ZT_CCUSTO
		If ((nNroMin >= SZT->ZT_FXDE)  .And. (SZT->ZT_FXATE >= nNroMin)) .And. SZT->ZT_TIPOD=='P'  .And.;
		   (Alltrim(SRA->RA_UNIMED)==Alltrim(SZT->ZT_PLANO) .Or. Empty(SZT->ZT_PLANO))
		   
			nVlrTot:=SZR->(ZR_VALOR+ZR_TXODONT)
			nVlrFun:=SZR->(ZR_VALOR+ZR_TXODONT)*(SZT->ZT_PDESC/100)		
			nVlrEmp:=(nVlrTot-nVlrFun)
			cCodVerb:=SZR->ZR_VERBFUN
		Endif
		dbSelectArea("SZT")
		dbSkip()
	EndDo	
Endif

If nVlrTot == 0
	dbSelectArea("SZR")
	dbSetOrder(1)
	dbSeek(Xfilial("SZR")+SRA->RA_UNIMED)
	While !Eof() .And. SZR->ZR_PLANO <= SRA->RA_UNIMED
		If (SZR->ZR_TIPO=='E') .Or. (nNroMin < ZR_FXDE)  .Or. (SZR->ZR_FXATE < nNroMin)
			dbSelectArea("SZR")
			dbSkip()
			Loop
		Endif    
		nVlrTot:=SZR->(ZR_VALOR+ZR_TXODONT)
		nVlrFun:=SZR->(ZR_VALOR+ZR_TXODONT)*(SZR->ZR_PDESC/100)
		nVlrEmp:=(nVlrTot-nVlrFun)		
		cCodVerb:=SZR->ZR_VERBFUN
	   dbSelectArea("SZR")
	   dbSkip()
	EndDo
Endif	
dbSelectArea("SZR")                  
dbSeek(Xfilial("SZR")+AllTrim(SRB->RB_PLANOUN))
If nVlrTot > 0
   nPosVerb:=Ascan(aVerb,{|x| Alltrim(x[1])==Alltrim(cCodVerb)})
   If nPosVerb==0
   	Aadd(aVerb,{cCodVerb,0,0,0})
   	nPosVerb:=Len(aVerb)
   Endif
   aVerb[nPosVerb,2]+=nVlrFun
   aVerb[nPosVerb,3]+=nVlrEmp
   aVerb[nPosVerb,4]++
   
	If SZR->ZR_TRAEREO > 0 .And. AllTrim(SRA->RA_TXAEREO)=='S'
		cVerb:='431'
		nPosVerb:=Ascan(aVerb,{|x| Alltrim(x[1])==cVerb})
   		If nPosVerb==0
   			Aadd(aVerb,{cVerb,0,0,0})
	   		nPosVerb:=Len(aVerb)
   		Endif
		aVerb[nPosVerb,2]:=SZR->ZR_TRAEREO
		aVerb[nPosVerb,4]++
	Endif
	
	//Taxa de Implantação do Funcionário
	If (nVlrFun>0 .Or.nVlrEmp>0) .And. Left(Dtos(SRA->RA_DTINCLU),6)==Left(Dtos(dDataBase),6)
	   nPosVerb:=Ascan(aVerb,{|x| Alltrim(x[1])==Alltrim('499')})
	   If nPosVerb==0
	   	Aadd(aVerb,{'499',0,0,0})
	   	nPosVerb:=Len(aVerb)
	   Endif
	   aVerb[nPosVerb,2]+=SZR->ZR_TXIMPLA
	   aVerb[nPosVerb,4]++	 		
	Endif   
Endif

//Dependentes e Agregados
dbSelectArea("SRB")
dbSetOrder(1)
dbSeek(SRA->RA_FILIAL+SRA->RA_MAT)
While !Eof() .And. SRA->RA_MAT==SRB->RB_MAT
	If SRB->RB_UNIMED<>'S' .Or. !SZR->(dbSeek(Xfilial("SZR")+SRB->RB_PLANOUN))
		dbSelectArea("SRB")
		dbSkip()
		Loop
	Endif
	nIdade:=Calc_Idade(dDatabase,SRB->RB_DTNASC)
	dbSelectArea("SZR")                  
	dbSetOrder(1)
	dbSeek(Xfilial("SZR")+AllTrim(SRB->RB_PLANOUN))
	nVlrTot:=0
	nVlrFun:=0
	nVlrEmp:=0
	//Verifica se há Excessão por Centro de Custo.
	If SZT->(dbSeek(Xfilial("SZT")+SRA->RA_CC))
		dbSelectArea("SZT")
		While !Eof() .And. SRA->RA_CC==SZT->ZT_CCUSTO
			If ((nNroMin >= ZT_FXDE)  .or. (ZT_FXATE >= nNroMin)) .And. (SZT->ZT_TIPOD==Alltrim(SRB->RB_GRAUPAR) ;
				 .And. Alltrim(SRB->RB_PLANOUN)==Alltrim(SZT->ZT_PLANO) .Or. Empty(SZT->ZT_PLANO))
				nVlrTot:=SZR->(ZR_VALOR+ZR_TXODONT)
				nVlrFun:=SZR->(ZR_VALOR+ZR_TXODONT)*(SZT->ZT_PDESC/100)
				nVlrEmp:=(nVlrTot-nVlrFun)		
			Endif
			dbSelectArea("SZT")
			dbSkip()
   	EndDo	
	Endif
	//Caso não encontre utiliza a tabela cadastrada
	If nVlrTot == 0
		dbSelectArea("SZR")                  
		dbSeek(Xfilial("SZR")+AllTrim(SRB->RB_PLANOUN))
		While !Eof() .And.  SZR->ZR_PLANO <= SRB->RB_PLANOUN
			If  (Alltrim(SRB->RB_GRAUPAR)<>'O' .And. ((nNroMin < ZR_FXDE)  .or. (ZR_FXATE < nNroMin)) );
				.Or. (Alltrim(SRB->RB_GRAUPAR)=='O'  .And. ((nIdade < ZR_FXDE)  .or.  (ZR_FXATE < nIdade )) ) ;
				.Or. (Alltrim(SRB->RB_GRAUPAR)=='O' .And. SZR->ZR_TIPO=='S') ;
				.Or. (Alltrim(SRB->RB_GRAUPAR)<>'O' .And. SZR->ZR_TIPO=='E')
				dbSelectArea("SZR")
				dbSkip()
				Loop
			Endif

			If AllTrim(SRB->RB_GRAUPAR)=='O' // agregados
				nVlrTot:=SZR->ZR_VDESC+ZR_TXODONT
				nVlrFun:=SZR->ZR_VDESC+ZR_TXODONT
				nVlrEmp:=0
				cCodVerb:=SZR->ZR_VERBAGR
			Else
				nVlrTot:=SZR->(ZR_VALOR+ZR_TXODONT)
				nVlrFun:=SZR->(ZR_VALOR+ZR_TXODONT)*(SZR->ZR_PDESC/100)
				nVlrEmp:=(nVlrTot-nVlrFun)		
				cCodVerb:=SZR->ZR_VERBFUN
	   	Endif
			dbSelectArea("SZR")
		   dbSkip()
		EndDo
	Endif
	
	dbSelectArea("SZR")                  
	dbSeek(Xfilial("SZR")+AllTrim(SRB->RB_PLANOUN))
	
	If nVlrTot > 0
	   //Verba de Dependentes e Agregados
	   nPosVerb:=Ascan(aVerb,{|x| Alltrim(x[1])==Alltrim(cCodVerb)})
	   If nPosVerb==0
	   	Aadd(aVerb,{cCodVerb,0,0,0})
	   	nPosVerb:=Len(aVerb)
	   Endif
	   aVerb[nPosVerb,2]+=nVlrFun
	   aVerb[nPosVerb,3]+=nVlrEmp
	   aVerb[nPosVerb,4]++
	 	
	 	//Taxa de Implantação
	 	If Left(Dtos(SRB->RB_DTIMPLA),6)==Left(Dtos(dDataBase),6)
			cVerb:='499'
			nPosVerb:=Ascan(aVerb,{|x| Alltrim(x[1])==cVerb})
			If nPosVerb==0
				Aadd(aVerb,{cVerb,0,0,0})
				nPosVerb:=Len(aVerb)
			Endif
			aVerb[nPosVerb,2]+=SZR->ZR_TXIMPLA
			aVerb[nPosVerb,4]++	 		
		Endif
		
		//Taxa de Aero Taxi
		If SZR->ZR_TRAEREO > 0 .And. AllTrim(SRA->RA_TXAEREO)=='S'
			cVerb:='431'
			nPosVerb:=Ascan(aVerb,{|x| Alltrim(x[1])==cVerb})
			If nPosVerb==0
				Aadd(aVerb,{cVerb,0,0,0})
				nPosVerb:=Len(aVerb)
			Endif
			aVerb[nPosVerb,2]+=SZR->ZR_TRAEREO
			aVerb[nPosVerb,3]+=0
			aVerb[nPosVerb,4]++	 		
		Endif
   Endif
   dbSelectArea("SRB")
   dbSkip()	
EndDo

Pergunte("GPM020",.F.)

For nCount := 1 to Len(aVerb)
	
	//Grava as Verbas na Tabela SRC
	If aVerb[nCount,2]>0
		dbSelectArea("SRC")	
		cSeq:=' '
		//+"  "+cSeq
		RecLock("SRC",!dbSeek(SRA->RA_FILIAL+SRA->RA_MAT+aVerb[nCount,1]+SRA->RA_CC))
		Replace  RC_FILIAL  With SRA->RA_FILIAL,;
					RC_MAT     With SRA->RA_MAT ,;
					RC_TIPO1   With "V",;
					RC_TIPO2   With "G",; 
					RC_PD      With aVerb[nCount,1],;
					RC_VALOR   With aVerb[nCount,2],;
					RC_HORAS   With aVerb[nCount,4],;
					RC_CC      With SRA->RA_CC ,;
					RC_DATA    With mv_par09
		MsUnlock()
	Endif
	//Verba da Empresa
	If aVerb[nCount,3]>0
		dbSelectArea("SRC")
		cSeq:=' ' 
		cVerb:="720"
		Reclock("SRC",!dbSeek(SRA->RA_FILIAL+SRA->RA_MAT+cVerb+SRA->RA_CC))
		Replace  RC_FILIAL  With SRA->RA_FILIAL,;
					RC_MAT     With SRA->RA_MAT, ;
					RC_TIPO1   With "V",;
					RC_TIPO2   With "G",;
					RC_PD      With cVerb,;
					RC_VALOR   With aVerb[nCount,3],;
					RC_HORAS   With aVerb[nCount,4],;
					RC_CC      With SRA->RA_CC ,;
					RC_DATA    With mv_par09
		MsUnlock()		
	Endif		
Next nCount	

Return(.T.)