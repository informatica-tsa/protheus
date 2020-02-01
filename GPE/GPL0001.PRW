#Include "Rwmake.ch"
#Include "TopConn.ch"


User Function GPL0001()
************************************************************************************************************************
*
*
****
Local aPerg:={}
Local cPerg:="GPL001"
Local cMens:="Este Programa tem como objetivo Gerar uma planiha em formato Excel com todo o passivo trabalhista."


AADD(aPerg,{cPerg,"Nome do Arquivo ?","C",20,0,"G","","","","","","",""})
AADD(aPerg,{cPerg,"Pasta do Arquivo?","C",60,0,"G","","","","","","",""})
AADD(aPerg,{cPerg,"Filial de  ?"         ,"C",02,0,"G","","SM0","","","","",""})
AADD(aPerg,{cPerg,"Filial Até ?"         ,"C",02,0,"G","","SM0","","","","",""})
AADD(aPerg,{cPerg,"Matricula de    ?","C",06,0,"G","","SRA","","","","",""})
AADD(aPerg,{cPerg,"Matricula Ate   ?","C",06,0,"G","","SRA","","","","",""})
AADD(aPerg,{cPerg,"C.Custo de    ?","C",TamSx3("CTT_CUSTO")[1],0,"G","","CTT","","","","",""})
AADD(aPerg,{cPerg,"C.Custo Ate   ?","C",TamSx3("CTT_CUSTO")[1],0,"G","","CTT","","","","",""})
AADD(aPerg,{cPerg,"Situação da Folha"    ,"C",05,0,"G","fsituacao","","","","","",""})
AADD(aPerg,{cPerg,"Categorias ?"         ,"C",15,0,"G","fcategoria","","","","","",""})
AADD(aPerg,{cPerg,"Ordem ?"              ,"N",1,0,"C","","","CC.Matricula","CC.Nome","","",""})



Pergunte(cPerg,.F.)

BatchProcess("Gerar Arquivo ",cMens,'GPL001',{|| Processa({|| GeraPLAN(.T.)},"Aguarde","Gerando Arquivo")})

Return()



Static function GeraPLAN()
*********************************************************************************************************************
*
*
******
Private cNomeFile :="" 
Private cDirFile  :=""
Private cEol      :=Chr(13)+Chr(10)
Private cCCDe  :=""
Private cCCAte :=""
Private cMatDe    :=""
Private cMatAte   :=""
Private cFilDe    :=""
Private cFilAte   :=""
Private cNomeFile :="" 
Private cSituacao :=""
Private cCategoria:=""

Pergunte('GPL001',.F.)

cNomeFile :=MV_PAR01
cDirFile  :=MV_PAR02
cFilDe    :=MV_PAR03
cFilAte   :=MV_PAR04
cMatDe    :=MV_PAR05
cMatAte   :=MV_PAR06
cCCDe  :=MV_PAR07
cCCAte :=MV_PAR08
cSituacao :=MV_PAR09
cCategoria:=MV_PAR10

cNomeFile:=AllTrim(cNomeFile)+If('.'$cNomeFile,'','.XLS')
cFileC :=Alltrim(cDirFile)+'\'+cNomeFile
If File(cFileC)
	If !Msgbox("Atenção, Este arquivo já Existe Deseja Substituí-lo?","ATENCAO","YESNO")
		Return()
	Endif
Endif
nFile:=FCreate(cFileC,1)
If nFile < 0 
	Msgbox("Erro ao Criar o Arquivo, Verifique se o Caminho foi digitado corretamente","ERRO")
	Return()
Endif
//
GerDados()
// Carrega o Arquivo com as Configurações
ProcFile(nFile)
If File(cFileC) 
	If MsgBox("Aqruivo gerado Com Sucesso, Deseja Visualizar-lo?","Atencao","YESNO")
		nRet:= ShellExecute( "open",cFileC,"","",5)
	Endif
Else
	Msgbox("Erro ao Criar o Arquivo, Verifique se o Caminho foi digitado corretamente","ERRO")
EndIf   


Return()



Static Function ProcFile(nFile)
*************************************************************************************************************************************************
* Gera a Query com as Informações
*
*****
Local cCust:='*'
Local aValrItem:={}
Local aValrSub:={}
Local aValrTot:={}
Local cEol      :=Chr(13)+Chr(10)
Local cCont:="3"
Local cLinIni:=cCont
Local nX := 0

Fwrite(nFile,MemoRead("Plan001.txt")+cEol)

//Carrega os Arrays
Aadd(aValrItem,Array(23))
Aadd(aValrItem,Array(23))
For nX := 1 to 23
	aValrItem[1,nX]:=0
	aValrItem[2,nX]:='='
Next nX

dbSelectArea("QSRA")
dbGotop()
While !Eof()
   
   If !SRG->(dbSeek(Xfilial("SRR")+QSRA->RA_MAT))
   	dbSelectArea("QSRA")
   	dbSkip()
   	Loop
   Endif
	For nX:=1 to 23
		aValrItem[1,nX]:=0
	Next nX  
	If cCust<>QSRA->RA_CC
	    If cCust<>'*'
	    	
	    	//Gera o SubTotal
			Fwrite(nFile," <tr class=xl24 height=22 style='height:15.0pt'> "+cEol)
			Fwrite(nFile,"  <td colspan=3 height=22 class=xl40 style='border-right:.5pt solid black; "+cEol)
			Fwrite(nFile,"  height:15.0pt'>SubTotal Ccusto:</td>                                     "+cEol)
			//Monta o grid Com SubTotal
			For nX:=68 to 87
				Fwrite(nFile,'  <td class=xl37 align=right x:num="" x:fmla="=SUM('+Chr(nX)+cLinIni+':'+Chr(nX)+cCont+')"</td>'+cEol)
				//Esta Linha Terá as formulas com o total Geral
				aValrItem[2,(nX-64)]:=aValrItem[2,(nX-64)]+Chr(nX)+Alltrim(Str((Val(cCont)+1),6,0))+'+'
			Next nX
			Fwrite(nFile," </tr>	                   "+cEol)			
			
			cCont:=Alltrim(Str((Val(cCont)+1),6,0))
	    Endif
	    cCont:=Alltrim(Str((Val(cCont)+1),6,0))	
	    
		CTT->(dbSeek(Xfilial("CTT")+QSRA->RA_CC))
		Fwrite(nFile," <tr class=xl24 height=22 style='height:15.0pt'> "+cEol)
		Fwrite(nFile,"  <td colspan=23 height=22 class=xl31 style='border-right:1.0pt solid black; "+cEol)
		Fwrite(nFile,"  height:15.0pt'>Centro de Custo:"+QSRA->RA_CC+' - '+CTT->CTT_DESC01+'</td> '+cEol)
		Fwrite(nFile," </tr> "+cEol)
		cLinIni:=Alltrim(Str((Val(cCont)+1),6,0))	
		cCust:=QSRA->RA_CC
		
	Endif       
	cCont:=Alltrim(Str((Val(cCont)+1),6,0))
	//Zera os Valores por Item
	aValrItem[1,1]:=QSRA->RA_MAT              //Matricula
	aValrItem[1,2]:=QSRA->RA_NOME 				//Nome
	aValrItem[1,3]:=Dtoc(QSRA->RA_ADMISSA)    //Admissão
	aValrItem[1,4]:=If(QSRA->RA_CATFUNC$'GH',(QSRA->RA_SALARIO*QSRA->RA_HRSMES),QSRA->RA_SALARIO)          //Salário
	aValrItem[1,5]:=RetVerbRR("'127'")        //Ferias Vencisa
	aValrItem[1,6]:=RetVerbRR("'128'")        //Ferias Proporcional
	aValrItem[1,7]:=RetVerbRR("'284','285'")  //Ferias Médias
	aValrItem[1,8]:=RetVerbRR("'197'")        // 1/3 Ferias
	aValrItem[1,9]:=RetVerbRR("'132'")        //13 Salario
	aValrItem[1,10]:=RetVerbRR("'287'")       // Media 13 Salario
	aValrItem[1,11]:=RetVerbPI("D")          //Bco Hras Dias
	aValrItem[1,12]:=RetVerbPI("H")          //Bco Hras Horas
	aValrItem[1,13]:='=((L'+cCont+')*20)/100' //DSR
	aValrItem[1,14]:=RetVerbRR("'733'")       //FGTS -Saldo
	
	aValrItem[1,15]:=RetVerbRR("'785','783','776','777'")  // FGTS Recisão Trab
	aValrItem[1,16]:=RetVerbRR("'778','784'")   //FGTS ART 22   Trab
	aValrItem[1,17]:=RetVerbRR("'785','777'")  // FGTS Recisão Inden
	aValrItem[1,18]:=(aValrItem[1,14]+RetVerbRR("'785'"))/2  //FGTS ART 22 Inden

	aValrItem[1,19]:='=((I'+cCont+'+J'+cCont+'+K'+cCont+'+L'+cCont+'+M'+cCont+')*27.8)/100' //INSS
	//Aviso-Trab c/INSS
	aValrItem[1,20]:=RetVerbRR("'161'")
	aValrItem[1,20]:=aValrItem[1,20]+(aValrItem[1,20]*(27.8/100)) 
	//Aviso - Ind+Reflexos	
	///aValrItem[1,19]:=(RetVerbRR("'177'")/3)
	aValrItem[1,21]+=RetVerbRR("'177','286','141','175','289','178'") 
	
	//Total Indenizado
	aValrItem[1,22]:='=SUM(E'+cCont+',F'+cCont+',G'+cCont+',H'+cCont+',I'+cCont+',J'+cCont+',K'+cCont+',L'+cCont+',M'+cCont+',O'+cCont+',P'+cCont+',S'+cCont+',T'+cCont+')'

	//Total Trabalhado
	aValrItem[1,23]:='=SUM(E'+cCont+',F'+cCont+',G'+cCont+',H'+cCont+',I'+cCont+',J'+cCont+',K'+cCont+',L'+cCont+',M'+cCont+',Q'+cCont+',R'+cCont+',S'+cCont+',U'+cCont+')'
 
	//Gera os Valores
	Fwrite(nFile," <tr class=xl24 height=20 style='height:15.0pt'> "+cEol)
	Fwrite(nFile,"  <td height=20 class=xl34 align=right style='height:15.0pt' x:num="+aValrItem[1,1]+"></td> "+cEol) //Matricula
	Fwrite(nFile,"  <td class=xl35>"+aValrItem[1,2]+"</td> "+cEol) //Nome
	Fwrite(nFile,'  <td class=xl36 align=right x:num="">'+aValrItem[1,3]+'</td>'+cEol) // Data de Admissao
	Fwrite(nFile,'  <td class=xl37 align=right x:num="">'+Alltrim(Str(aValrItem[1,4],12,2))+"</td>"+cEol) // Salário
	Fwrite(nFile,'  <td class=xl37 align=right x:num="">'+Alltrim(Str(aValrItem[1,5],12,2))+"</td>"+cEol) //Ferias Vencidas
	Fwrite(nFile,'  <td class=xl37 align=right x:num="">'+Alltrim(Str(aValrItem[1,6],12,2))+' </td>'+cEol)   //Proporcional
	Fwrite(nFile,'  <td class=xl37 align=right x:num="">'+Alltrim(Str(aValrItem[1,7],12,2))+'</td>'+cEol) //Medias
	Fwrite(nFile,'  <td class=xl35 align=right x:num="">'+Alltrim(Str(aValrItem[1,8],12,2))+'</td>'+cEol) //1/3 Férias
	Fwrite(nFile,'  <td class=xl37 align=right x:num="">'+Alltrim(Str(aValrItem[1,9],12,2))+'</td>'+cEol) //13º Salario
	Fwrite(nFile,'  <td class=xl37 align=right x:num="">'+Alltrim(Str(aValrItem[1,10],12,2))+'</td>'+cEol) //Medias
	Fwrite(nFile,'  <td class=xl37 align=right x:num="">'+Alltrim(Str(aValrItem[1,11],12,2))+'</td>'+cEol) //Dias
	Fwrite(nFile,'  <td class=xl37 align=right x:num="">'+Alltrim(Str(aValrItem[1,12],12,2))+'</td>'+cEol) //horas
	Fwrite(nFile,'  <td class=xl35 align=right x:num="" x:fmla="'+aValrItem[1,13]+'"></td>'+cEol) //DSR
	Fwrite(nFile,'  <td class=xl37 align=right x:num="">'+Alltrim(Str(aValrItem[1,14],12,2))+'</td>'+cEol)//SALDO
	Fwrite(nFile,'  <td class=xl37 align=right x:num="">'+Alltrim(Str(aValrItem[1,15],12,2))+'</td>'+cEol) // fgts(Recisão Trab
	Fwrite(nFile,'  <td class=xl37 align=right x:num="">'+Alltrim(Str(aValrItem[1,16],12,2))+'</td>'+cEol)// Art 22(Multa) Trab
	Fwrite(nFile,'  <td class=xl37 align=right x:num="">'+Alltrim(Str(aValrItem[1,17],12,2))+'</td>'+cEol) // fgts(Recisão Inden
	Fwrite(nFile,'  <td class=xl37 align=right x:num="">'+Alltrim(Str(aValrItem[1,18],12,2))+'</td>'+cEol)// Art 22(Multa) Inden	
	Fwrite(nFile,'  <td class=xl37 align=right x:num="" x:fmla="'+aValrItem[1,19]+'"></td>'+cEol) // INSS
	Fwrite(nFile,'  <td class=xl37 align=right x:num="" x:fmla="'+Alltrim(Str(aValrItem[1,20],12,2))+'"></td>'+cEol) //Trab C/inss
	Fwrite(nFile,'  <td class=xl37 align=right x:num="">'+Alltrim(Str(aValrItem[1,21],12,2))+'</td>'+cEol) //Ind+ reflexos
	Fwrite(nFile,'  <td class=xl37 align=right x:num="" x:fmla="'+aValrItem[1,22]+'"></td>'+cEol) //Indenizado
	Fwrite(nFile,'  <td class=xl39 align=right x:num="" x:fmla="'+aValrItem[1,23]+'"></td>'+cEol) //Trabalhado
	Fwrite(nFile,' </tr> '+cEol)
	dbSelectArea("QSRA")
	dbskip()
EndDo
//Gera o SubTotal
Fwrite(nFile," <tr class=xl24 height=20 style='height:15.0pt'> "+cEol)
Fwrite(nFile,"  <td colspan=3 height=20 class=xl40 style='border-right:.5pt solid black; "+cEol)
Fwrite(nFile,"  height:15.0pt'>SubTotal Ccusto:</td>                                     "+cEol)
For nX:=68 to 87
	Fwrite(nFile,'  <td class=xl37 align=right x:num="" x:fmla="=SUM('+Chr(nX)+cLinIni+':'+Chr(nX)+cCont+')"</td>'+cEol)
	//Esta Linha tem a soma do total Geral
	aValrItem[2,(nX-64)]:=aValrItem[2,(nX-64)]+Chr(nX)+Alltrim(Str((Val(cCont)+1),6,0))
Next nX
Fwrite(nFile," </tr>	                   "+cEol)

//Gera o Total
Fwrite(nFile," <tr class=xl24 height=21 style='height:15.75pt'> "+cEol)
Fwrite(nFile,"  <td colspan=3 height=21 class=xl44 style='border-right:.5pt solid black; "+cEol)
Fwrite(nFile,"  height:15.75pt'>Total Geral:</td>"+cEol)

//Gera o Grid Com o Total
For nX:=4 To 23
	Fwrite(nFile,'  <td class=xl37 align=right x:num="" x:fmla="'+aValrItem[2,nX]+'"</td>'+cEol) // Salário
Next
Fwrite(nFile," </tr>	                   "+cEol)

///Fwrite(nFile,MemoRead("Plan002.txt"))
Fwrite(nFile,"</table>"+cEol)
Fwrite(nFile,"</body>"+cEol)
Fwrite(nFile,"</html>"+cEol)
//Fecha o Arquivo
Fclose(nFile)    
dbSelectArea("QSRA")
dbCloseArea()


Return()



Static Function RetVerbRR(cCodPD)
*************************************************************************************************************************************************
* Gera a Query com as Informações
*
*****
Local aAreaQSRA:=GetArea()
Local nRet:=0

cQuery:=" SELECT IsNull(SUM(RR_VALOR),0) VALOR FROM "+RetSqlName("SRR")
cQuery+=" WHERE RR_MAT='"+QSRA->RA_MAT+"' AND "
cQuery+=" RR_DATA='"+Dtos(SRG->RG_DATADEM)+"' AND"
cQuery+=" RR_PD IN ("+cCodPD+") AND "
cQuery+=" RR_TIPO3='R' AND "
cQuery+=" D_E_L_E_T_<>'*' "
TcQuery cQuery Alias QTMP New
nRet:=QTMP->VALOR
dbSelectArea("QTMP")
dbCloseArea()
RestArea(aAreaQSRA)

Return(nRet)

 

Static Function RetVerbPI(cTipo)
*************************************************************************************************************************************************
* Gera a Query com as Informações
*
*****
Local aAreaQSRA:=GetArea()
Local nRet:=0
dbSelectArea("SPI")
dbSeek(Xfilial("SPI")+QSRA->RA_MAT)
While !Eof() .AND. SPI->PI_MAT=QSRA->RA_MAT
	If cTipo='D'
		//Dias
		If PI_PD$'501'  
			nRet+=((SPI->PI_QUANT)*SRG->RG_SALDIA)
		Endif
		If PI_PD$'500'  
			nRet-=((SPI->PI_QUANT)*SRG->RG_SALDIA)
		Endif   
	Else
		//Horas
		If PI_PD$'503'  
			nRet+=(SPI->PI_QUANT*SRG->RG_SALHORA)
		Endif
		If PI_PD$'504'  
			nRet-=(SPI->PI_QUANT*SRG->RG_SALHORA)
		Endif
	Endif	
	dbSelectArea("SPI")
	dbSkip()   
EndDo
If cTipo='V'
	nRet:=nRet*nSalHr
Endif
//Dias de credito 501/ dias de debito 500/
//horas de credito 503 / horas de debito 504
Return(nRet)


Static Function GerDados()
*************************************************************************************************************************************************
* Gera a Query com as Informações
*
*****

Local cSitQuery := ""
Local cCatQuery := ""
Local cQuery:=""
Local nS := 0
Local nX := 0

//-- Modifica variaveis para a Query
cSitQuery := ""
For nS := 1 to Len(cSituacao)
	cSitQuery += "'"+Subs(cSituacao,nS,1)+"'"
	If ( nS+1) <= Len(cSituacao)
		cSitQuery += "," 
	Endif
Next nS
cCatQuery := ""
For nS:=1 to Len(cCategoria)
	cCatQuery += "'"+Subs(cCategoria,nS,1)+"'"
	If ( nS+1) <= Len(cCategoria)
		cCatQuery += "," 
	Endif
Next nS
cQuery := " SELECT RA_MAT,RA_ADMISSA,RA_SALARIO,RA_NOME,RA_CC,RA_FILIAL,RA_CATFUNC,RA_HRSMES,RA_HRSEMAN "		
cQuery += " FROM "+	RetSqlName("SRA")
cQuery += " WHERE "
cQuery += " RA_FILIAL  between '" + cFilDe  + "' AND '" + cFilAte + "' AND"
cQuery += " RA_MAT     between '" + cMatDe  + "' AND '" + cMatAte + "' AND"
cQuery += " RA_CC      between '" + cCcDe   + "' AND '" + cCcate  + "' AND"
cQuery += " RA_CATFUNC IN (" + Upper(cCatQuery) + ") AND" 
cQuery += " RA_SITFOLH IN (" + Upper(cSitQuery) + ") AND" 
cQuery += "  D_E_L_E_T_ <> '*' "
cQuery += " ORDER BY RA_CC,RA_NOME"
Fwrite(FCreate("Teste.slq"),cQuery)
cQuery := ChangeQuery(cQuery)	
aStruSRA := SRA->(dbStruct())
dbUseArea(.T., "TOPCONN", TCGenQry(,,cQuery), 'QSRA', .F., .T.)
For nX := 1 To Len(aStruSRA)
	If ( aStruSRA[nX][1]$'RA_MAT,RA_ADMISSA,RA_SALARIO,RA_NOME,RA_CATFUNC' ) .AND. aStruSRA[nX][2]<>'C'
		TcSetField("QSRA",aStruSRA[nX][1],aStruSRA[nX][2],aStruSRA[nX][3],aStruSRA[nX][4])
	EndIf
Next nX
Return()


