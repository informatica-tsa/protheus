#include "rwmake.ch"
#include "TopConn.ch"
#include 'fileio.ch
/*-----------------------------------------------------------------------|
| Programa  | GERADOR  | Autor ³Eduardo Carraro        | Data | 01/09/00 |
|------------------------------------------------------------------------|
| Descri‡ao | Gerador de arquivos para fluxo economico                   |
|------------------------------------------------------------------------|
| Observac  | Podera ser usado junto ao GerFluxo.PRW ou na importacao do |
|           | SigaEIS, apenas passando Execblock("GERADOR",.f.,.f.)      |
|------------------------------------------------------------------------|
| Uso       | Especifico para EPC/TSA                                    |
|------------------------------------------------------------------------|
| Programador | Data     | Motivo                                        |
|------------------------------------------------------------------------|
| Joao Carlos | 01/11/05 | Conversao SIGACON p/ SIGACTB                  |
| Leandro 	  | 10/09/13 | Ajuste para evitar erro 1/07  na geração com  |
|							perda de referncia // Formato /2013 e não /13|
|-----------------------------------------------------------------------*/


User Function GER2007()
************************************************************************************************************************
*
*
*****

SetPrvt("AARQ,CQUERY,NVALOR,NCONT,CDATACX,CDATARF")
SetPrvt("CCONTA,")

Processa( {|| GERA() },"Geracao Fluxo Economico","Gerando Registro..." )

Return(nil)

User Function GetStrFil()
	aAreaM0 := SM0->(GetArea())
	aFilAux := FWAllFilial()
	sStrFil := ""
	For nAtu := 1 To Len(aFilAux)
		if aFilAux[nAtu] $ '99|97'
			loop
		endif
		
		if nAtu = 1
			sStrFil := "'"+aFilAux[nAtu]+"'"
			loop
		endif
		sStrFil := sStrFil + ",'" + aFilAux[nAtu]+"'"
	Next
	RestArea(aAreaM0)
Return sStrFil


Static Function Gera()
***********************************************************************************************************************
* Rotina que gera oFluxo Economico Baseado nos lançamentos contábeis
*
*
******

Local sStrFil := U_GetStrFil()
Private aArq    := { Alias(), IndexOrd(), Recno() }
Private nValor  := 0
Private nCont   := 0
Private cDataCx :=Space(05)
Private cDataRf :=Space(05)
Private nSeqDoc :=0
Private nValMulta:=0
Private cLote

/*Define o Lote contábil da Folha de pagamento.
// Este será necessário porque no presente momento a contabilização geral da empresa
// considera o campo Centro de custo como SubConta e a SubConta no folha de Pagamento
// é o campo Item Contábil e não o Centro de Custo.Futuramente este tratamento será modificado
// toda a empresa tratará o campo Centro de Custo Como SETOR e Item Contábil como SubConta*/
dbSelectArea( "SX5" )
dbSeek( XFILIAL("SX5")+"09FIS" )
If At(UPPER("EXEC"),SX5->X5_DESCRI) > 0  // Se for ExecBlock
	cLote := &(SX5->X5_DESCRI)
Else
	cLote := Alltrim(SX5->X5_DESCRI)
Endif
cLote:=StrZero(Val(cLote),6,0)

IncProc("Excluindo Registros da tabela SZ0...")

/*Exclui a contabilização maior ou igual a que o ano de 2007.
a atualização do Ano de 2006 deve ser feita no ambiente
SIGA2006 na opção FLUXO GERENCIAL - 2006
Os registros anteriores a 2006 NÃO SÃO EXCLUIDOS EM NEHUM MOMENTO
pelas rotinas de geração do Fluxo
*/
cQuery  := " DELETE "+RetSqlName("SZ0")
cQuery  += " WHERE Z0_DTLANC>='20070101' AND Z0_REVISAO='' AND Z0_VEICULO != 'S' "
TCSQLExec(cQuery)

IncProc("Selecionando Registros dos Lançamentos contabeis novo...")

DbSelectArea("CT2") //Resumo Fluxo Economico
ProcRegua(RecCount())

/*Seleciona todos os lançamentos a partir de 2007 utilizando a seguinte regra:
somente para as contas de Débito ou Crédito que tenha um grupo gerencial
ou as contas que tem o grupo gerencial e o grupo gerencial esteja com o campo
GERAFLUXO = SIM
*/


cQuery:= " SELECT CT2.R_E_C_N_O_  CT2RECNO "
cQuery+= " FROM "+RetSqlName("CT2")+" CT2 "
cQuery+= " LEFT OUTER JOIN "+RetSqlName("CT1")+" CT1C ON (CT2_CREDIT=CT1C.CT1_CONTA AND CT1C.CT1_FILIAL='"+Xfilial("CT1")+"' AND CT1C.D_E_L_E_T_<>'*')"
cQuery+= " LEFT OUTER JOIN "+RetSqlName("CT1")+" CT1D ON (CT2_DEBITO=CT1D.CT1_CONTA AND CT1D.CT1_FILIAL='"+Xfilial("CT1")+"' AND CT1D.D_E_L_E_T_<>'*')"
cQuery+= " LEFT OUTER JOIN "+RetSqlName("SZA")+" SZAC ON (SZAC.ZA_GRUPGER=CT1C.CT1_GRUPO AND SZAC.ZA_FLUXO<>'N' AND SZAC.D_E_L_E_T_<>'*')"
cQuery+= " LEFT OUTER JOIN "+RetSqlName("SZA")+" SZAD ON (SZAD.ZA_GRUPGER=CT1D.CT1_GRUPO AND SZAD.ZA_FLUXO<>'N' AND SZAD.D_E_L_E_T_<>'*')"
cQuery+= " WHERE  CT2_FILIAL IN ("+sStrFil+") AND CT2.CT2_DATA>='20070101'  AND CT2.CT2_DC IN ('1','2','3') AND CT2.CT2_TPSALD IN ('1') AND CT2.D_E_L_E_T_<>'*'"
cQuery+= "   AND (((ISNULL(SZAC.ZA_GRUPGER,'') <> '') "
cQuery+= "       OR (ISNULL(SZAC.ZA_GRUPGER,'') = '' AND LEFT(CT1C.CT1_CONTA,1) IN ('4','5')) )"
cQuery+= "    OR ((ISNULL(SZAD.ZA_GRUPGER,'') <> '') "
cQuery+= "       OR (ISNULL(SZAD.ZA_GRUPGER,'') = '' AND LEFT(CT1D.CT1_CONTA,1) IN ('4','5'))))"

cQuery+= " UNION ALL "

// Dados complementares de depreciação gerencial
cQuery+= " SELECT CT2.R_E_C_N_O_  CT2RECNO "
cQuery+= " FROM "+RetSqlName("CT2")+" CT2 "
cQuery+= " LEFT OUTER JOIN "+RetSqlName("CT1")+" CT1C ON (CT2_CREDIT=CT1C.CT1_CONTA AND CT1C.CT1_FILIAL='"+Xfilial("CT1")+"' AND CT1C.D_E_L_E_T_<>'*')"
cQuery+= " LEFT OUTER JOIN "+RetSqlName("CT1")+" CT1D ON (CT2_DEBITO=CT1D.CT1_CONTA AND CT1D.CT1_FILIAL='"+Xfilial("CT1")+"' AND CT1D.D_E_L_E_T_<>'*')"
cQuery+= " LEFT OUTER JOIN "+RetSqlName("SZA")+" SZAC ON (SZAC.ZA_GRUPGER=CT1C.CT1_GRUPO AND SZAC.ZA_FLUXO<>'N' AND SZAC.D_E_L_E_T_<>'*')"
cQuery+= " LEFT OUTER JOIN "+RetSqlName("SZA")+" SZAD ON (SZAD.ZA_GRUPGER=CT1D.CT1_GRUPO AND SZAD.ZA_FLUXO<>'N' AND SZAD.D_E_L_E_T_<>'*')"
cQuery+= "WHERE  CT2_FILIAL = '97'	AND "
cQuery+= "	CT2.CT2_DATA>='20080101'   "
cQuery+= "	AND CT2.D_E_L_E_T_<>'*'    "
cQuery+= "	AND (((ISNULL(SZAC.ZA_GRUPGER,'') <> '') "
cQuery+= "			OR (ISNULL(SZAC.ZA_GRUPGER,'') = ''  "
cQuery+= "			AND LEFT(CT1C.CT1_CONTA,4) = '4119') ) "
cQuery+= "			OR ((ISNULL(SZAD.ZA_GRUPGER,'') <> '')   "
cQuery+= "			OR (ISNULL(SZAD.ZA_GRUPGER,'') = ''  "
cQuery+= "			AND LEFT(CT1D.CT1_CONTA,4) ='4119' ))) "

dbUseArea(.T., "TOPCONN", TCGenQry(,,cQuery), 'QCT2', .F., .T.)

xnumlan:=0
DbSelectArea("QCT2") //Lancamentos Contabeis
DbGoTop()                       

While !Eof()
	
	dbSelectArea("CT2")
	dbGoto(QCT2->CT2RECNO)
	xnumlan++
	IncProc("Gerando Lancamentos Contabeis..."+CT2->CT2_LOTE)
	// Descarta as contas que iniciam com 1421 com data superior a 2008
	// Volta para o fluxo até terminar a alteracao de depreciacao - CMC 08/01/2009
	// temporariamente substituimos o código 1421 (PATRIMONIO) por um codigo alternativo (0000) ( nas duas comparações !!!!!)
	If  CT2->CT2_FILIAL = '01' .AND. CT2->CT2_DATA >= STOD('20080101') .AND. (Left(CT2->CT2_DEBITO,4) == '0000' .or. Left(CT2->CT2_CREDIT,4) == '0000' )
		GravaLog("log-fluxo-"+cEmpAnt+".log","Registro: "+cValToChar(QCT2->CT2RECNO)+" Descartado registro com data superior a 01/01/2008 e conta 0000")
		dbSelectArea("CT2")
		dbSkip()
	ElseIf CT2->CT2_FILIAL = '01' .AND. (Left(CT2->CT2_DEBITO,4) == '4119' .or. Left(CT2->CT2_CREDIT,4) == '4119' )
		GravaLog("log-fluxo-"+cEmpAnt+".log","Registro: "+cValToChar(QCT2->CT2RECNO)+" Descartado registro com contas(CT2_CREDIT,CT2_DEBITO) iniciadas por 4119...")
		dbSelectArea("CT2")
		dbSkip()
	Else
		// Ricardo(NM) acrescimo conta 118103 - 18/07/2012
		If CT2->CT2_DC='3' .And. ((Left(CT2_CREDIT,6)='115102' .OR. Left(CT2_DEBITO,6)='115102') .or. (Left(CT2_CREDIT,6)='118103' .OR. Left(CT2_DEBITO,6)='118103'))
			nForIni=1   //Partida Dobrada, desta forma será feito dois lançamentos
			nForFim=2
		Else
			If CT2->CT2_DC='1' .or. (CT2->CT2_DC='3' .And. !Empty(CT2->CT2_CCD))
				nForIni=1  //Representa conta de Débito
				nForFim=1
			Else
				nForIni=2 //Representa conta de Credito
				nForFim=2
			Endif
		Endif
		
		//Feito para tratamento de lançamento de Partida Dobrada
		For nTipoLan=nForIni To nForFim
			
			DbSelectArea("SZ0")
			nValor := 0
			
			//Calculando Valor
			If nTipoLan=1
				nValor := 0-(CT2->CT2_VALOR)
				cConta:=CT2->CT2_DEBITO
			Else
				nValor := CT2->CT2_VALOR
				cConta:=CT2->CT2_CREDIT
			EndIf
			
			//Verifica se a conta tem GrupoGerencial, pois estas não devem ir para o Fluxo
			If (CT1->(dbSeek(xFILIAL("CT1")+cConta)) .And. Empty(CT1->CT1_GRUPO)) .Or. ;
				(SZA->(dbSeek(Xfilial("SZA")+CT1->CT1_GRUPO)) .And. SZA->ZA_FLUXO=='N')
				GravaLog("log-fluxo-"+cEmpAnt+".log","Registro: "+cValToChar(QCT2->CT2RECNO)+" Descartado registro CT1_GRUPO vazio ou ZA_FLUXO = N")
				nForIni++
				loop
			Endif
			
			
			cDataCx :=Space(05)
			cDataRf :=Space(05)
			
			//Calculando Data Caixa e Referencia
			If AllTrim(SubStr(CT2->CT2_ORIGEM,1,2)) == "CX"
				if AllTrim(SubStr(CT2->CT2_ORIGEM, 10, 02)) == '20' // Formato /2013 e não /13
					cDataCx := SubStr(CT2->CT2_ORIGEM,07,03) + SubStr(CT2->CT2_ORIGEM,12,02)
					cDataRf := SubStr(CT2->CT2_ORIGEM,21,03) + SubStr(CT2->CT2_ORIGEM,26,02)
				else      
					cDataCx := SubStr(CT2->CT2_ORIGEM,07,05)
					cDataRf := SubStr(CT2->CT2_ORIGEM,19,05)
				endif
			EndIf                                       
									
			If !(Empty(CT2->CT2_CCD) .And. Empty(CT2->CT2_CCC)) /// .and. Alltrim(cConta) #"15230000"
				
				If Alltrim(cLote)<>Alltrim(CT2->CT2_LOTE)
					cCCusto:=IIF(nTipoLan==1,CT2->CT2_CCD,If(Empty(CT2->CT2_CCC),CT2->CT2_CCD,CT2->CT2_CCC))
					cSetor:=Posicione("SZ2",3,Xfilial("cCusto")+cCCusto,"Z2_SETOR")
				Else
					//Lote da Folha, o Centro de Custo é o Item contábil
					//Conforme Observações feitas no inicio da Rotina
					cCCusto:=IIF(nTipoLan==1,Alltrim(CT2->CT2_ITEMD),If(Empty(CT2->CT2_ITEMC),CT2->CT2_ITEMD,CT2->CT2_ITEMC))
					cCCusto:=Alltrim(cCCusto)
					cSetor :=IIF(nTipoLan==1,CT2->CT2_CCD,If(Empty(CT2->CT2_CCC),CT2->CT2_CCD,CT2->CT2_CCC))
				Endif
				GravaLog("log-fluxo-"+cEmpAnt+".log","Registro: "+cValToChar(QCT2->CT2RECNO)+" Gravando registro SZ0... GER2007")
				If RecLock("SZ0",.T.)
					Replace  	Z0_FILIAL  With CT2->CT2_FILIAL ,; //
					Z0_LINHA   With CT2->CT2_LINHA  ,; //C, 2
					Z0_DATA    With SubStr(dToc(CT2->CT2_DATA),4,5) ,;
					Z0_HIST    With CT2->CT2_HIST ,;   //C, 40
					Z0_DTVENC  With SubStr(DtoC(CT2->CT2_DTVENC),4,5) ,;
					Z0_LOTE    With CT2->CT2_LOTE ,;   //C, 4
					Z0_DOC     With CT2->CT2_DOC  ,;   //C, 6
					Z0_VALOR   With nValor        ,;    //N,14,02
					Z0_DTCAIXA With cDataCx       ,;    //D, 8
					Z0_DTREF   With cDataRf       ,;    //D, 8
					Z0_CONTA   With cConta        ,;    //C, 20
					Z0_CC      With cCCusto       ,;
					Z0_SETORIG With cSetor       ,;
					Z0_DTLANC  with CT2->CT2_DATA
					
					If SubStr(cConta,1,1) == "4" .OR. Alltrim(cConta) $ "3112020001_3112020002_3112020003_3121030001_3121030002_3121030003"
						Replace Z0_CUSTO   With ABS(nValor)      //N, 14, 2
					Else
						Replace Z0_RECEITA With ABS(nValor)      //N, 14, 2
					EndIf
					MsUnlock()
					
					// Registro já esta gravado e agora será contas de encargos,Provisões, Licenças e Auxilios

					If cEmpAnt = '01' .And. ((cConta>='5111010001' .And. cConta<='5111010008') .OR.;
						(cConta>='4111010001' .And. cConta<='4111010008'))
						RegToMemory("SZ0",.F.)
						aRatDesp:={}
						Aadd(aRatDesp,{'000095',0.3630})
						Aadd(aRatDesp,{'000096',0.2891})
						Aadd(aRatDesp,{'000097',0.1355})
						
						For nXi:=1 To Len(aRatDesp)
							If RecLock("SZ0",.T.)
								Replace  Z0_FILIAL  With M->Z0_FILIAL,;
								Z0_LINHA   With M->Z0_LINHA,;
								Z0_DATA    With M->Z0_DATA,;
								Z0_HIST    With M->Z0_HIST,;
								Z0_DTVENC  With M->Z0_DTVENC,;
								Z0_LOTE    With M->Z0_LOTE,;
								Z0_DOC     With M->Z0_DOC,;
								Z0_VALOR   With (M->Z0_VALOR*aRatDesp[nXi,2]),;
								Z0_DTCAIXA With M->Z0_DTCAIXA,;
								Z0_DTREF   With M->Z0_DTREF,;
								Z0_CONTA   With M->Z0_CONTA,;
								Z0_CC      With M->Z0_CC,;
								Z0_SETORIG With M->Z0_SETORIG,;
								Z0_CUSTO   With M->Z0_CUSTO,;
								Z0_RECEITA With M->Z0_RECEITA,;
								Z0_GRUPGER With aRatDesp[nXi,1] ,;
								Z0_DTLANC  with CT2->CT2_DATA
								MsUnlock()
								//Faz a gravação dos campos de cadastro
							Endif
						Next nXi
					Endif
				EndIf
			EndIf
			
			// Verifica se Houve atrazo no pedido
			If (Left(CT2->CT2_CREDIT,6)='112101' .or. Left(CT2->CT2_CREDIT,6)='112103') .AND. Val(Left(CT2->CT2_ORIGEM,3))>0
				
				// Posiciona na Nota de Origem SF2
				cNota   :=Substr(CT2->CT2_ORIGEM,5,6)
				cSerie  :=Substr(CT2->CT2_ORIGEM,11,3)
				cParcela:=Substr(CT2->CT2_ORIGEM,14,3)
				
				//Cabeçalho da Nota
				DbSelectArea('SF2')
				DbSetOrder(1)
				DbSeek(Xfilial('SF2')+cNota+cSerie,.f.)
				
				//Itens da Nota
				DbSelectArea('SD2')
				DbSetOrder(3)
				DbSeek(Xfilial('SD2')+cNota+cSerie,.f.)
				//
				cSetor:=Posicione("SZ2",3,Xfilial("cCusto")+Alltrim(SD2->D2_SUBC),"Z2_SETOR")
				//Titulo Gerado
				DbSelectArea('SE1')
				DbSetOrder(1)
				DbSeek(Xfilial('SE1')+cSerie+cNota,.f.)
				nSeqDoc++
				GravaLog("log-fluxo-"+cEmpAnt+".log","Registro: "+cValToChar(QCT2->CT2RECNO)+" Gravando registro de multa na SZ0...")
				nValMulta:=(SF2->F2_VALBRUT*(1.02^(Val(Left(CT2->CT2_ORIGEM,3))/30)-1)*-1)
				If RecLock("SZ0",.T.)
					Replace Z0_FILIAL  With CT2->CT2_FILIAL ,;
					Z0_LINHA   With 'WW'           ,;        //C, 2
					Z0_HIST    With 'M.GERENCIAL - ' + cSerie + '-' + cNota + '-' + Left(CT2->CT2_ORIGEM,3) + '-' + str(SF2->F2_VALBRUT,14,2),;
					Z0_LOTE    With '960000'            ,;      //C, 4
					Z0_DOC     With '96'+StrZero(nSeqDoc,4) ,;  //C, 6
					Z0_VALOR   With nValMulta              ,;   //N,14,02
					Z0_CONTA   With CT2->CT2_CREDIT          ,; //C, 20
					Z0_CC      With Left(SD2->D2_SUBC,4)+'A' ,; //C, 9
					Z0_DTREF   With StrZero(Month(SE1->E1_BAIXA),2)+'/'+Right(StrZero(year(SE1->E1_BAIXA  ),4),2) ,;
					Z0_DATA    With StrZero(Month(SF2->F2_EMISSAO),2)+'/'+Right(StrZero(year(SF2->F2_EMISSAO),4),2) ,;
					Z0_DTVENC  With StrZero(Month(SE1->E1_VENCTO),2)+'/'+ Right(StrZero(year(SE1->E1_VENCTO ),4),2) ,;
					Z0_DTCAIXA With StrZero(Month(SE1->E1_VENCREA),2)+'/'+Right(StrZero(year(SE1->E1_VENCREA),4),2) ,;
					Z0_CUSTO   With nValMulta ,;
					Z0_DTLANC  with CT2->CT2_DATA,;
					Z0_SETORIG With cSetor
				Endif
				MsUnlock()
			Endif
		Next nTipoLan
	EndIf
	
	DbSelectArea("QCT2")
	DbSkip()
EndDo

/*Fechando area, a mesma é utilizada na GER102013*/
DbSelectArea("QCT2")
dbclosearea()

//Restaurando Ambiente
DbSelectArea(aArq[1])
DbSetOrder(aArq[2])
DbGoTo(aArq[3])
Return(.T.)

static Function GravaLog(cArq,cMsg )
 	
	If !File(cArq)
		nHandle := FCreate(cArq)
	else
		nHandle := fopen(cArq , FO_READWRITE + FO_SHARED )
	Endif

	If nHandle == -1
		MsgStop('Erro de abertura : FERROR '+str(ferror(),4))
	Else
		FSeek(nHandle, 0, FS_END)         // Posiciona no fim do arquivo
		FWrite(nHandle, Dtoc(Date())+" - "+Time()+" : "+cUserName+" : "+cMsg+Chr(13)+Chr(10)) // Insere texto no arquivo
		fclose(nHandle)                   // Fecha arquivo
	Endif
	
 
return