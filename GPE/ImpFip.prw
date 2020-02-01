#include "rwmake.ch"
#include "topconn.ch"  

User Function ImpFip()
*******************************************************************************************************************
*
*
******  

Private cMens     :=""
Private lTestPath := .F.
Private nLastKey  := 0
Private cInd1	   := CriaTrab(,.f.)
Private cAnoMesAtu:= GetMv("MV_FOLMES")
Private cDireArqu :="\\epcs02\Protheus8\Protheus_Data\Fip\Inbox\"
Private cDirSave  :="\\epcs02\Protheus8\Protheus_Data\Fip\OutBox\"
Private cPerg     :="IMPFIP"
Private aPerg     :={}
Private lGerMov   :=.f.
Private cDataIni:='99999999'
Private cDataFim:=''

AADD(aPerg,{cPerg,"Competencia Ano Mes?"    ,"C",06,0,"G","!Empty(MV_PAR01)","","","","","",""})
AADD(aPerg,{cPerg,"Matricula de  ?"         ,"C",06,0,"G","","SRA","","","","",""})
AADD(aPerg,{cPerg,"Matricula Até ?"         ,"C",06,0,"G","","SRA","","","","",""})
AADD(aPerg,{cPerg,"Pasta do arquivo:?"      ,"C",60,0,"G","","","","","","",""})
AADD(aPerg,{cPerg,"Importa Movimeto(S/N)?"  ,"N",1,0,"C","","","Sim","Não","","",""})
AADD(aPerg,{cPerg,"Refaz Lançamentos Já Importados de Planilha?"  ,"N",1,0,"C","","","Sim","Não","","",""})
AADD(aPerg,{cPerg,"Gera Resumo de horas(S/N)? "  ,"N",1,0,"C","","","Sim","Não","","",""})


If Pergunte(cPerg,.T.)
	cMens:="  Este programa tem como Objetivo Importar os arquivos de apontamento de Horas"
	cMens+=" da Folha Individual de Ponto que encontra-se na Pasta:"
	cMens+=" \PROTJEUS8\PROTHEUS_DATA\FIP com a seguinte Nomeclatura: "
	cMens+=" FIP<Ano e Mes da Competencia no seguinte formato AAAAMM >+<Matricula>.CSV "
	
	BatchProcess("Importação da FIP",cMens,cPerg,{|| Processa({|| GERFIPEPC()},"Aguarde","Processando...")})
Endif
Return()




Static Function GERFIPEPC()
******************************************************************************************************************
*
*
*******
Local cArqsFip:=""
Local aArqFIP:={}
Local nXi:=0    
Local nProc:=0
Local nFip := 0 

Private cCompet:=""
Private nTipoArq:=0
Private cCodAtiv:="00"
Private cAnoMes:=""
Private cLog:=""
Private aDiasFIP:={}

Pergunte("IMPFIP",.f.)


cAnoMes:=MV_PAR01
cDireArqu:=If(Empty(MV_PAR04),cDireArqu,Alltrim(MV_PAR04))
lGerMov=(MV_PAR05==1)   
lGerResumo=(MV_PAR07==1)   

For nFip := 1 To 2   
	nTipoArq:=nFip
	cArqsFip:=cDireArqu+'FIP'+StrZero(nFip,1)+MV_PAR01
	Adir(cArqsFip+'*.CSV',aArqFIP)
	If Len(aArqFIP)>0
		nProc:=0
		For nXi:=1 To Len(aArqFIP)
			If SubsTr(aArqFIP[nXi],9,6)>= MV_PAR02 .And. SubsTr(aArqFIP[nXi],9,6) <=MV_PAR03
				ProcArqFip(cDireArqu+aArqFIP[nXi],aArqFIP[nXi])
				nProc++
			Endif	
		Next nXi
	Else
		
	Endif
Next nFip
If nProc>0
	MsgBox("Nro de Arquivos processados: "+Alltrim(Str(nProc,5))+" Arquivo(s)")	
Else
	MsgBox("Arquivos não encontrados, verifique os parametros e arquivos da pasta "+MV_PAR04)
Endif
Return(.T.)



Static Function ProcArqFip(cFileFip,cNomeArq)
******************************************************************************************************************
*
*
*****
Local cBuffer:="*"
Local nHandle:=0
Local nBtLidos:=0
Local nXz:=0     
Local aDiasFip:={}
Local lHEFunc:=.T.
Local nXy := 0
 
Private aExistFIP:={}
Private cMat:=Space(6)
Private cConta:=""
Private cErro:=""
Private cEol:=Chr(13)+Chr(10)
Private cTipoHr:=" "

nLinArq:=0
nHandle:=FOpen(cFileFip)
nTamFile:=fSeek(nHandle,0,2)
fSeek(nHandle,0,0)
ProcRegua(nTamFile) // Numero de registros a processar
If nHandle < 0
	MsgBox("Erro ao Abrir arquivo"+cFileFip)
	Return()
Endif
While nBtLidos < nTamFile  .And. cBuffer<>''
	IncProc("Lendo Arquivo "+cFileFip)
	aDiasFip:={}
	cBuffer:=RetLin(nHandle,@nBtLidos)
	nLinArq++
	cAtiv:=""
	cItemContr:=""
	cRev:='0'
	IncProc()
	If nTipoArq==1
		If nLinArq==1 .And. Left(cBuffer,2)<>'C1'
			cErro+="Empr:"+cEmpAnt+" Filial:"+cFilAnt+"- Erro de Conteudo do Arquivo "+cEol
			Exit
		Endif 
		Do Case 
			Case Left(cBuffer,2)=='C1'
				lHEFunc:=.T.
				cMat:=Alltrim(RetText(cBuffer,4))
				If !Empty(cMat)
					cMat:=StrZero(Val(cMat),6)
					cQuery:=" SELECT RA_DEMISSA,RA_FILIAL,RA_MAT,RA_HORARIO FROM "+RetSqlName("SRA")+" WHERE RA_MAT='"+cMat+"' AND RA_FILIAL='"+Xfilial("SRA")+"' AND D_E_L_E_T_<>'*'"
					TcQuery cQuery Alias QSRA New
					dbSelectArea("QSRA")
					dbGotop()
					If Eof() .Or. Alltrim(QSRA->RA_DEMISSA)<>''
						if Eof()
							cErro+="Empr:"+cEmpAnt+" Filial:"+cFilAnt+"- Erro: Matricula inválida! (Plan Mod 1)"+cEol
						EnDif
						If Alltrim(QSRA->RA_DEMISSA)<>''
							cErro+="Empr:"+cEmpAnt+" Filial:"+cFilAnt+"- Erro: Funcionário("+cMat+"') Demitido em("+QSRA->RA_DEMISSA+")! (Plan Mod 1)"+cEol
						Endif
					Else
						dbSelectArea("SRA")
						dbSeek(QSRA->(RA_FILIAL+RA_MAT))
						dbSelectArea("QSRA")
						// Verifica se o Funcionário já tem Horas Extras
						lHEFunc:=ExistExtras(cMat)	
						//AValia os dias que o funcionário tem FIP
						aExistFIP:=DiasComFip(cMat)
						
						//Verifica a tabela de horário
						cQuery:=" SELECT * FROM HORARIO WHERE CODIGO='"+Alltrim(QSRA->RA_HORARIO)+"' AND ENTRADA1>'0' AND ENTRADA2>'0' AND SAIDA1>'0' AND SAIDA2>'0' "
						TcQuery cQuery Alias QHOR New
						dbSelectArea("QHOR")
						if Eof()					
						
							cErro+="Empr:"+cEmpAnt+" Filial:"+cFilAnt+"- Erro: Tabela de Horário("+Alltrim(QSRA->RA_HORARIO)+") para o Funcionário Mat("+Alltrim(QSRA->RA_MAT)+") é inválida"
						Endif
						dbSelectArea("QHOR")
						dbCloseArea()
					Endif
					dbSelectArea("QSRA")
					dbCloseArea()
				Else 
					cErro+="Empr:"+cEmpAnt+" Filial:"+cFilAnt+"- Erro: Erro na Estrutura a Matricula deve estar na Linha 1 Coluna (Plan Mod 1)"
				Endif	
			Case Left(cBuffer,2)=='C2'
				cMes:=RetText(cBuffer,10)
				///cAnoMes:=cAnoMes+If(Len(Alltrim(cMes))<2,'0'+Alltrim(cMes),cMes)
				cTipoHr:=If(RetText(cBuffer,5)$'E1/E2/E3','S','N')
				
				If Alltrim(RetText(cBuffer,5))$'FE' .And. Left(cConta,1)+Right(cConta,1)='9F' 
					cErro+="Empr:"+cEmpAnt+" Filial:"+cFilAnt+"- Lançamentos de Férias deve Ser no contrato Corporativo 9...F  (Plan Mod 1)"
				Endif
				If Alltrim(RetText(cBuffer,5))$'L' .And. Left(cConta,1)+Right(cConta,1)$'9L' 
					cErro+="Empr:"+cEmpAnt+" Filial:"+cFilAnt+"- Lançamentos de Licença Médica deve Ser no contrato Corporativo 9...L  (Plan Mod 1)"
				Endif     
				
				
			Case Left(cBuffer,2)$'D1/D2/D3'
				If Left(cBuffer,2)$'D1/D2/D3' .And. !Empty(Alltrim(RetText(cBuffer,3)))
					cConta:=Alltrim(RetText(cBuffer,3))
					cConta:=cConta+Space(14-Len(cConta))
				Endif
				//If Empty(Alltrim(cConta))
					//cErro+="Empr:"+cEmpAnt+" Filial:"+cFilAnt+"- Erro: Erro na Estrutura do Arquivo a Conta deve estar na linha a coluna C (Plan Mod 1)"+cEol
				//Endif				
				cItemContr:=""
				cRev:=''
				cAtiv:=''
				
				aDiasFip:=RetMarcFip(cBuffer,5)
				cCodAtiv:=RetText(cBuffer,4) 
				cTipoHora:=RetText(cBuffer,5)
				// Código da Atividade
				nXe:=1
				
			    // Codigo de Atividades
				For nXy := 1 to Len(cCodAtiv)
					If Substr(cCodAtiv,nXy,1)=='#'
						nXe++
						nXy++
					Endif
					If nXe==1
						cAtiv+=Substr(cCodAtiv,nXy,1)
					Endif
					If nXe==2
						cItemContr+=Substr(cCodAtiv,nXy,1)
					Endif
					If nXe==3
						cRev+=Substr(cCodAtiv,nXy,1)
					Endif     
				Next nXY
				//Consiste ATIVIDADES
				cQuery:=" SELECT CODIGO,DESCRICAO FROM ATIVIDADES "
				cQuery+=" WHERE FIP_CODIGO='002' AND LEFT(DESCRICAO,2)='"+cAtiv+"'"
				cQuery+="   AND DESCRICAO LIKE '%-%' AND LEFT(CODIGO,1)='5'"
				TcQuery cQuery New Alias QTMP
				dbSelectArea("QTMP")
				dbGotop()
			   If !Eof()
					cAtiv:=QTMP->CODIGO
			   Else
					cAlerta:=" Atenção !, Codigo da Atividade "+cAtiv+" não encontrado, importado o padrão: 511"+cEol
					cAtiv:='511'
				EndIf
				dbSelectArea("QTMP")
				dbCloseArea()
			    
				//Consiste ITEM DE CONTROLE
				cQuery:=" SELECT CODIGO FROM ITEM_CONTROLE "
				cQuery+=" WHERE COD_SETOR='2"+Alltrim(SRA->RA_CC)+"' AND "
				cQuery+=" DESCRICAO='"+cItemContr+"'"
			  
				TcQuery cQuery New Alias QTMP
				dbSelectArea("QTMP")
				dbGotop()
				If !Eof()
					cItemContr:=Alltrim(Str(QTMP->CODIGO,4,0))
				Else
					cItemContr:='5'
				EndIf
				dbSelectArea("QTMP")
				dbCloseArea()				
				
			Case Left(cBuffer,2)=='D2'
				aDiasFip:=RetMarcFip(cBuffer,5)
				cAtiv:=RetText(cBuffer,5)
				cCodAtiv:=If(Empty(cAtiv),cCodAtiv,StrZero(Val(cAtiv),3))
				cTipoHora:=RetText(cBuffer,5)
			Case Left(cBuffer,2)=='D3'
				aDiasFip:=RetMarcFip(cBuffer,5)
				cAtiv:=RetText(cBuffer,5)
				cCodAtiv:=If(Empty(cAtiv),cCodAtiv,StrZero(Val(cAtiv),3))
				cTipoHora:=RetText(cBuffer,5)
		EndCase
	Else 
		Do Case 
			Case nLinArq==1 
				If Alltrim(Left(cBuffer,2))=='C1'
					cErro+="Empr:"+cEmpAnt+" Filial:"+cFilAnt+"- Erro: O conteudo do arquivo esta fora do padrão (Plan Mod 2)"+cEol
				Endif
			Case nLinArq==5 // Linha que indica a Competencia
				cConta:=Alltrim(RetText(cBuffer,2))
				cConta:=cConta+Space(14-Len(cConta))
				If Empty(Alltrim(cConta))
					cErro+="Empr:"+cEmpAnt+" Filial:"+cFilAnt+"- Erro: Erro na Estrutura do Arquivo a Conta deve estar na Linha 5 coluna B (Plan Mod 2)"+cEol
				Endif
				cMes   :=StrZero(Val(RetText(cBuffer,6)),4)+StrZero(Val(RetText(cBuffer,5)),2)
				If Alltrim(cAnoMes)<>cMes
					cErro+="Empr:"+cEmpAnt+" Filial:"+cFilAnt+"- Erro: O mes e Ano do Arquivo Difere do Parametro:"+cAnoMes+" (Plan Mod 2)"+cEol
				Endif   
				
			Case nLinArq > 7 // Linhas que contém os apontamentos
				cTipoHora:=Alltrim(RetText(cBuffer,3))

				If Alltrim(RetText(cBuffer,3))$'FE' .And. Left(cConta,1)+Right(cConta,1)='9F' 
					cErro+="Empr:"+cEmpAnt+" Filial:"+cFilAnt+"- Lançamentos de Férias deve Ser no contrato Corporativo 9...F  (Plan Mod 2)"
				Endif
				If Alltrim(RetText(cBuffer,3))$'L' .And. Left(cConta,1)+Right(cConta,1)$'9L' 
					cErro+="Empr:"+cEmpAnt+" Filial:"+cFilAnt+"- Lançamentos de Licença Médica deve Ser no contrato Corporativo 9...L  (Plan Mod 2)"
				Endif     
				
				If Upper(Alltrim(RetText(cBuffer,1)))=='MATRICULA'
					cMat:=Alltrim(RetText(cBuffer,2))
					lHEFunc:=.T.
					If !Empty(cMat)
						cMat:=StrZero(Val(cMat),6)
						cQuery:=" SELECT RA_FILIAL,RA_MAT FROM "+RetSqlName("SRA")+" WHERE RA_MAT='"+cMat+"' AND RA_FILIAL='"+Xfilial("SRA")+"' AND D_E_L_E_T_<>'*'"
						TcQuery cQuery Alias QSRA New
						dbSelectArea("QSRA")
						dbGotop()
						If Eof()
							cErro:="Empr:"+cEmpAnt+" Filial:"+cFilAnt+"- Matricula inválida!"
						Else
							dbSelectArea("SRA")
							dbSeek(QSRA->(RA_FILIAL+RA_MAT))
							dbSelectArea("QSRA")
							// Verifica se o Funcionário já tem Horas Extras
							lHEFunc:=ExistExtras(cMat)	
							
							//AValia os dias que o funcionário tem FIP
							aExistFIP:=DiasComFip(cMat)
						Endif
						dbSelectArea("QSRA")
						dbCloseArea()				  
						//Processa as Marcações para esta Linha
					Else 
						Exit
					Endif
				Endif	
				aDiasFip:=RetMarcFip(cBuffer,3)
		EndCase	
	Endif	
	dbSelectArea("SZ2")
	dbSetOrder(3)
	if !SZ2->(dbSeek(Xfilial("SZ2")+Alltrim(cConta)))
		cErro+="Empr:"+cEmpAnt+" Filial:"+cFilAnt+"- Erro: SubConta "+Alltrim(cConta)+" inválida favor verificar a Planilha"+cEol		
	Endif
	
	//Valida a conta na Importação
	If Empty(cErro) .And. cMat>=MV_PAR02 .And. cMat<=MV_PAR03
		lgerou:=.F.  
		if Alltrim( cAtiv)=''
			cAtiv:='000'
		Endif
		For nXz:=1 to Len(aDiasFip)
			If !Empty(cMat)
				//Avalia as horas Extras
				cTipoHr  :=If(cTipoHora$'E1/E2/E3/AN/A' .AND. Alltrim(cTipoHora)<>'N' ,'E1',cTipoHora)
				//Executa a Procesure de Gravação dos Dados....			
				IncProc("Gravando os dados na FIP...")
				If !Empty(cConta)
					TCSPExec(xProcedures("IMPFIP"),cMat ,aDiasFip[nXz,1], aDiasFip[nXz,2], cAnoMes, cConta, cTipoHr, cAtiv, Val(cItemContr), Val(cRev), cEmpAnt, cFilAnt, 'N', 'N', 'PLANILHA')
					lgerou:=.t.
				Else
					cErro+="Empr:"+cEmpAnt+" Filial:"+cFilAnt+" -  SUBCONTA Conta da Matricula:"+cMat+" Esta em Branco ou não encontrada"+cEol
				Endif
				If lHEFunc .And. (Alltrim(cTipoHora)<>'N' .And. Alltrim(cTipoHora) $ 'E1/E2/E3/AN/A') .And. cAnoMes==cAnoMesAtu
					//Gera os lançamentos de Hora extras na tabela SRC
					If lGerMov
						GerHEFunc(cMat,aDiasFip[nXz,2],cTipoHora)
					Endif
				Endif		    
			Endif	
		Next nXz
		//Indica que a Importação esta Correta
		If lGerResumo .And. Empty(cErro) .And. lgerou
			TCSPExec(xProcedures("sp_Gera_Medicao"),cMat,cFilAnt,StrTran(cDataIni,'-',''),StrTran(cDataFim,'-',''))
		Endif
	Else
		///Exit
	Endif
EndDo
FClose(nHandle)
__CopyFile(cFileFip,cDirSave+StrTran(cNomeArq,'.CSV',If(Empty(cErro),'.PROC','.ERR')))
If !Empty(cErro)
	nFileErr:=Fcreate(cDireArqu+StrTran(cNomeArq,'.CSV','.LOG'))
	Fwrite(nFileErr,cErro)
	Fclose(nFileErr)
Else
	Ferase(cFileFip)	
Endif

Return(.T.)



Static Function RetMarcFip(cBuffer,nColIni)
******************************************************************************************************************
*
*
******
Local nDiaIni:=0
Local cMesFip:=""
Local cAnoFip:=""
Local dUltDiaMes:=0
Local aRet:={}     
Local nXy:=0 
nDiaIni:=25
cMesFip:=StrZero(If(Substr(cAnoMes,5,2)=='01',12,Val(Substr(cAnoMes,5,2))-1),2)
cAnoFip:=StrZero(If(Substr(cAnoMes,5,2)=='01',Val(Left(cAnoMes,4))-1,Val(Left(cAnoMes,4)))   ,4)
dUltDiaMes:=LastDay(Stod(cAnoFip+cMesFip+'01'))
For nXy:=1 To 31
			nHorasFip:=Val(StrTran(RetText(cBuffer,nColIni+nXy),',','.'))
			nDiaIni++
			If (Day(dUltDiaMes)<=30) .And. (Day(dUltDiaMes)+1=nDiaIni)
				Loop
			Endif
			cDiaFip:=StrZero(nDiaIni,2)
			If (cAnoFip+cMesFip+cDiaFip) > Dtos(dUltDiaMes)
				If cMesFip=='12'
					cAnoFip:=StrZero(Val(cAnoFip)+1,4)
					cMesFip:='01'
				Else	
					cMesFip:=StrZero(Val(cMesFip)+1,2)
				Endif
				nDiaIni:=1
				cDiaFip:=StrZero(nDiaIni,2)
				dUltDiaMes:=LastDay(Stod(cAnoFip+cMesFip+'01'))
			Endif
			cData:=(cAnoFip+'-'+cMesFip+'-'+cDiaFip)	
			If nHorasFip>0 .And. !ExistLan(cMat,cData)
				Aadd(aRet,{cData,nHorasFip})
			Endif
Next nXy
Return(aRet)



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



Static function RetLin(nHandle,nBtLidos)
******************************************************************************************************************
*
*
******
Local cEol:=Chr(10)
Local cBuffer:=""
Local cByte:=""
While !cByte$cEol .And. nBtLidos < nTamFile
	cByte:=""
	fRead(nHandle,@cByte,1) //Leitura da primeira linha do arquivo texto
	If cByte<>Chr(13) .And. cByte<>Chr(10)
		cBuffer+=cByte
	Endif
	nBtLidos++
EndDo
Return(cBuffer)


                        
Static Function ExistLan(cMat,cData)
**************************************************************************************************************
*
*
****** 
Local lRet:=.F.
Local aAreaAt:=GetArea()

If Ascan(aExistFIP,cData)>0
	lRet:=.T.
Endif
RestArea(aAreaAt)

Return(lRet)



Static Function DiasComFip(cMat)
**************************************************************************************************************
*
*
****** 
Local aAreaAt:=GetArea()
Local nDiaIni:=25
Local cMesFip:=StrZero(If(Substr(cAnoMes,5,2)=='01',12                    ,Val(Substr(cAnoMes,5,2))-1),2)
Local cAnoFip:=StrZero(If(Substr(cAnoMes,5,2)=='01',Val(Left(cAnoMes,4))-1,Val(Left(cAnoMes,4)))   ,4)
Local dUltDiaMes:=LastDay(Stod(cAnoFip+cMesFip+'01'))
Local aFIP:={}
Local nXy := 0

cDataIni:='99999999'
cDataFim:=''

For nXy := 1 To 31
		nDiaIni++
		cDiaFip:=StrZero(nDiaIni,2)
		If (cAnoFip+cMesFip+cDiaFip) > Dtos(dUltDiaMes)
			If cMesFip=='12'
				cAnoFip:=StrZero(Val(cAnoFip)+1,4)
				cMesFip:='01'
			Else	
				cMesFip:=StrZero(Val(cMesFip)+1,2)                                     '
			Endif
			nDiaIni:=1
			cDiaFip:=StrZero(nDiaIni,2)
			dUltDiaMes:=LastDay(Stod(cAnoFip+cMesFip+'01'))
		Endif
		If (cAnoFip+cMesFip+cDiaFip)<cDataIni
			cDataIni:=(cAnoFip+cMesFip+cDiaFip)
		Endif
		If (cAnoFip+cMesFip+cDiaFip)>cDataFim
			cDataFim:=(cAnoFip+cMesFip+cDiaFip)
		Endif	
Next nXy
If Day(Stod(cDataFim))=26
	cDataFim:=Dtos(Stod(cDataFim)-1)
Endif

cDataIni:=Left(cDataIni,4)+'-'+Substr(cDataIni,5,2)+'-'+Right(cDataIni,2)
cDataFim:=Left(cDataFim,4)+'-'+Substr(cDataFim,5,2)+'-'+Right(cDataFim,2)
 
//Exclui os lançamento antes de Incluir o lançamento 
If MV_PAR06=1
	cQuery:=" DELETE FIPEPC "
	cQuery+=" WHERE CHAPA='"+cMat+"' AND FIPDATA BETWEEN '"+cDataIni+"' AND '"+cDataFim+"'"
	TcSqlExec(cQuery)
Endif
cQuery:=" SELECT DISTINCT "
cQuery+=" CAST(YEAR(FIPDATA)  AS Char(4)) ANO ,"
cQuery+=" CAST(Month(FIPDATA) AS Char(2)) MES ,"
cQuery+=" CAST(DAY(FIPDATA)   AS Char(2)) DIA  "   
cQuery+=" FROM FIPEPC "
cQuery+=" WHERE CHAPA='"+cMat+"' AND FIPDATA BETWEEN '"+cDataIni+"' AND '"+cDataFim+"'"
TcQuery cQuery Alias QFIP New

dbSelectArea("QFIP")
dbGotop()
While !Eof()
	Aadd(aFIP,QFIP->(StrZero(Val(Ano),4)+ StrZero(Val(Mes),2)+ StrZero(Val(Dia),2) ))
	dbSelectArea("QFIP")
	dbSkip()
EndDo
dbSelectArea("QFIP")
dbCloseArea()

RestArea(aAreaAt)
Return(aFIP)



Static Function GerHEFunc(cMat,nHE,cTpHE)
******************************************************************************************************************
* Verifica se existem Horas Extras para o Funcionário
*
******
Local cMatric:=cMat
Local nHExtras:=nHE
Local cVerbExt:=""
Local cSeq:='0'
Do Case
	Case cTpHE='E1'
		If SRA->RA_CC$'*****'
			cVerbExt:='109'
		Else
			cVerbExt:='105'
		Endif
	Case cTpHE='E2'
		cVerbExt:='106'
	Case cTpHE='E3'
		cVerbExt:='107'
	Case cTpHE$'A/AN'  //Adicional Noturno
		cVerbExt:='110'
EndCase

dbSelectArea("SRC")

If dbSeek(SRA->(RA_FILIAL+RA_MAT)+cVerbExt+SRA->RA_CC)
	nHExtras:=nHE+SRC->RC_HORAS
Endif
nMinHr:=(Int(nHExtras)*60)+((nHExtras-Int(nHExtras))*100)
nMinHr:=Int(nMinHr/60)+(Mod(nMinHr,60)/100)

//Grava as Verbas na Tabela SRC
dbSelectArea("SRC")	
Reclock("SRC",!dbSeek(SRA->(RA_FILIAL+RA_MAT)+cVerbExt+SRA->RA_CC))
Replace RC_FILIAL  With SRA->(RA_FILIAL),;
		RC_MAT     With SRA->RA_MAT ,;
		RC_TIPO1   With "H",;
		RC_PD      With cVerbExt,;
		RC_HORAS   With nMinHr,;
		RC_CC      With SRA->RA_CC
MsUnlock()

Return()



Static Function ExistExtras(cMat)
******************************************************************************************************************
* Verifica se existem Horas Extras para o Funcionário
*
******
Local aReaAt:=GetArea()
Local lRet:=(QSRA->RA_FILIAL<>'97')
If lRet
	cQuery:=" SELECT RC_PD,RC_HORAS FROM "+RetSqlName("SRC")+" WHERE RC_MAT='"+cMat+"' "
	cQuery+=" AND RC_PD IN ('105','106','109') AND D_E_L_E_T_<>'*' "
	TcQuery cQuery Alias QSRC New
	dbSelectArea("QSRC")
	dbGotop()
	If !Eof()
		While !Eof()
			cLog+=" Atenção Matricula:"+cMat+" Existem:"+Alltrim(Str(QSRC->RC_HORAS,12,0))+" Horas Extras já lançadas na Verba("+QSRC->RC_PD+") "+cEol
			dbSkip()
		EndDo
		lHEFunc:=.F.
	Endif	
	dbSelectArea("QSRC")
	dbCloseArea()
Endif
RestArea(aReaAt)
Return(lRet)

