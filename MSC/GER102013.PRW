#include "rwmake.ch"
#include "TopConn.ch"

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
|-----------------------------------------------------------------------*/


User Function GER102013()
************************************************************************************************************************
*
*
*****

SetPrvt("AARQ,CQUERY,NVALOR,NCONT,CDATACX,CDATARF")
SetPrvt("CCONTA,")

Processa( {|| GERA() },"Geracao Fluxo Economico","Gerando Registro..." )

Return(nil)

Static Function Gera()
***********************************************************************************************************************
* Rotina que gera oFluxo Economico Baseado nos lançamentos contábeis
*
*
******

Private aArq    := { Alias(), IndexOrd(), Recno() }
Private nValor  := 0
Private nCont   := 0
Private cDataCx :=Space(05)
Private cDataRf :=Space(05)
Private nSeqDoc :=0
Private nValMulta:=0
Private cLote

//Define o Lote contábil da Folha de pagamento.
// Este será necessário porque no presente momento a contabilização geral da empresa
// considera o campo Centro de custo como SubConta e a SubConta no folha de Pagamento
// é o campo Item Contábil e não o Centro de Custo.Futuramente este tratamento será modificado
// toda a empresa tratará o campo Centro de Custo Como SETOR e Item Contábil como SubConta
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
cQuery  += " WHERE Z0_DTLANC>='20131001' AND Z0_REVISAO='' AND Z0_VEICULO != 'S' "
TCSQLExec(cQuery)

IncProc("Selecionando Registros dos Lançamentos contabeis novo...")

DbSelectArea("CT2") //Resumo Fluxo Economico
ProcRegua(RecCount())

/*Seleciona todos os lançamentos a partir de 2007 utilizando a seguinte regra:
somente para as contas de Débito ou Crédito que tenha um grupo gerencial
ou as contas que tem o grupo gerencial e o grupo gerencial esteja com o campo
GERAFLUXO = SIM
*/
/*

cQuery:= " SELECT CT2.R_E_C_N_O_  CT2RECNO "
cQuery+= " FROM "+RetSqlName("CT2")+" CT2 "
cQuery+= " LEFT OUTER JOIN "+RetSqlName("CT1")+" CT1C ON (CT2_CREDIT=CT1C.CT1_CONTA AND CT1C.CT1_FILIAL='"+Xfilial("CT1")+"' AND CT1C.D_E_L_E_T_<>'*')"
cQuery+= " LEFT OUTER JOIN "+RetSqlName("CT1")+" CT1D ON (CT2_DEBITO=CT1D.CT1_CONTA AND CT1D.CT1_FILIAL='"+Xfilial("CT1")+"' AND CT1D.D_E_L_E_T_<>'*')"
cQuery+= " LEFT OUTER JOIN "+RetSqlName("SZA")+" SZAC ON (SZAC.ZA_GRUPGER=CT1C.CT1_GRUPO AND SZAC.ZA_FLUXO<>'N' AND SZAC.D_E_L_E_T_<>'*')"
cQuery+= " LEFT OUTER JOIN "+RetSqlName("SZA")+" SZAD ON (SZAD.ZA_GRUPGER=CT1D.CT1_GRUPO AND SZAD.ZA_FLUXO<>'N' AND SZAD.D_E_L_E_T_<>'*')"
cQuery+= " WHERE  CT2.CT2_DATA>='20070101'  AND CT2.CT2_DC IN ('1','2','3') AND CT2.CT2_TPSALD IN ('1') AND CT2.D_E_L_E_T_<>'*'"

If cEmpAnt<>'02'
cQuery+= "   AND (ISNULL(SZAD.ZA_GRUPGER,'') <> '' OR ISNULL(SZAC.ZA_GRUPGER,'') <> '')"
Else
cQuery+= "   AND (((ISNULL(SZAC.ZA_GRUPGER,'') <> '') "
cQuery+= "       OR (ISNULL(SZAC.ZA_GRUPGER,'') = '' AND LEFT(CT1C.CT1_CONTA,1) IN ('4','5')) )"
cQuery+= "    OR ((ISNULL(SZAD.ZA_GRUPGER,'') <> '') "
cQuery+= "       OR (ISNULL(SZAD.ZA_GRUPGER,'') = '' AND LEFT(CT1D.CT1_CONTA,1) IN ('4','5'))))"
Endif

TcQuery cQuery Alias QCT2 New

*/

cQuery:= " SELECT CT2.R_E_C_N_O_  CT2RECNO "
cQuery+= " FROM "+RetSqlName("CT2")+" CT2 "
cQuery+= " LEFT OUTER JOIN "+RetSqlName("CT1")+" CT1C ON (CT2_CREDIT=CT1C.CT1_CONTA AND CT1C.CT1_FILIAL='"+Xfilial("CT1")+"' AND CT1C.D_E_L_E_T_<>'*')"
cQuery+= " LEFT OUTER JOIN "+RetSqlName("CT1")+" CT1D ON (CT2_DEBITO=CT1D.CT1_CONTA AND CT1D.CT1_FILIAL='"+Xfilial("CT1")+"' AND CT1D.D_E_L_E_T_<>'*')"
cQuery+= " LEFT OUTER JOIN "+RetSqlName("SZA")+" SZAC ON (SZAC.ZA_GRUPGER=CT1C.CT1_GRUPO2 AND SZAC.ZA_FLUXO<>'N' AND SZAC.D_E_L_E_T_<>'*')"
cQuery+= " LEFT OUTER JOIN "+RetSqlName("SZA")+" SZAD ON (SZAD.ZA_GRUPGER=CT1D.CT1_GRUPO2 AND SZAD.ZA_FLUXO<>'N' AND SZAD.D_E_L_E_T_<>'*')"
cQuery+= " WHERE  CT2_FILIAL IN ('01','02','03','04','05', '20', '21', '22','23','24','25','26','27','28','29','30') AND CT2.CT2_DATA>='20131001'  AND CT2.CT2_DC IN ('1','2','3') AND CT2.CT2_TPSALD IN ('1') AND CT2.D_E_L_E_T_<>'*'"

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
cQuery+= " LEFT OUTER JOIN "+RetSqlName("SZA")+" SZAC ON (SZAC.ZA_GRUPGER=CT1C.CT1_GRUPO2 AND SZAC.ZA_FLUXO<>'N' AND SZAC.D_E_L_E_T_<>'*')"
cQuery+= " LEFT OUTER JOIN "+RetSqlName("SZA")+" SZAD ON (SZAD.ZA_GRUPGER=CT1D.CT1_GRUPO2 AND SZAD.ZA_FLUXO<>'N' AND SZAD.D_E_L_E_T_<>'*')"

cQuery+= "WHERE  CT2_FILIAL = '97'	AND "
cQuery+= "	CT2.CT2_DATA>='20131001'   "
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
	If  CT2->CT2_FILIAL = '01' .AND. CT2->CT2_DATA >= STOD('20131001') .AND. (Left(CT2->CT2_DEBITO,4) == '0000' .or. Left(CT2->CT2_CREDIT,4) == '0000' )
		dbSelectArea("CT2")
		dbSkip()
	ElseIf CT2->CT2_FILIAL = '01' /*.AND. CT2->CT2_DATA <= STOD('20071231')*/ .AND. (Left(CT2->CT2_DEBITO,4) == '4119' .or. Left(CT2->CT2_CREDIT,4) == '4119' )
		ConOut('Descartando Registro. Data '+ dtoc(CT2->CT2_DATA) + ' CD '+ CT2->CT2_DEBITO + ' CC '+CT2->CT2_CREDIT)
		dbSelectArea("CT2")
		dbSkip()
	Else
		//		If CT2->CT2_DC='3' .And. (Left(CT2_CREDIT,6)='115102' .OR. Left(CT2_DEBITO,6)='115102')  - Ricardo(NM) acrescimo conta 118103 - 18/07/2012
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
			If (CT1->(dbSeek(xFILIAL("CT1")+cConta)) .And. Empty(CT1->CT1_GRUPO2)) .Or. ;
				(SZA->(dbSeek(Xfilial("SZA")+CT1->CT1_GRUPO2)) .And. SZA->ZA_FLUXO=='N')
				
				nForIni++
				loop
			Endif
			
			
			cDataCx :=Space(05)
			cDataRf :=Space(05)
			
			//Calculando Data Caixa e Referencia
			If SubStr(CT2->CT2_ORIGEM,1,2)=="CX"
				if (SubStr(CT2->CT2_ORIGEM, 07, 02) == '20') // Formato /2013 e não /13
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
					Z0_GRUPGER With CT1->CT1_GRUPO2  ,; // adicionado por Leandro (CN) em 11-11-2013 para geraçãod o fluxo corretamnte a partir de 1-10-2013
					Z0_SETORIG With cSetor       ,;
					Z0_DTLANC  with CT2->CT2_DATA
					
					///If SubStr(cConta,1,1) == "4" .OR. Alltrim(cConta) $ "41410000_41420000_41430000_42410000_42420000_42430000"
					If SubStr(cConta,1,1) == "4" .OR. Alltrim(cConta) $ "3112020001_3112020002_3112020003_3121030001_3121030002_3121030003"
						Replace Z0_CUSTO   With ABS(nValor)      //N, 14, 2
					Else
						Replace Z0_RECEITA With ABS(nValor)      //N, 14, 2
					EndIf
					MsUnlock()
					
					// Registro já esta gravado e agora será contas de encargos,Provisões, Licenças e Auxilios
					///If cEmpAnt<>'02' .And. Left(cConta,4)>='3121' .And. Left(cConta,4)<='3124'
					//				  	If cEmpAnt <> '02'  .And. ((cConta>='5111010001' .And. cConta<='5111010008') .OR. (cConta>='4111010001' .And. cConta<='4111010008'))
					If cEmpAnt = '01'  .And. ((cConta>='5111010001' .And. cConta<='5111010008') .OR. (cConta>='4111010001' .And. cConta<='4111010008'))
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
					Z0_GRUPGER With CT1->CT1_GRUPO2,;
					Z0_SETORIG With cSetor
				Endif
				MsUnlock()
			Endif
		Next nTipoLan
	EndIf
	
	DbSelectArea("QCT2")
	DbSkip()
EndDo

DbSelectArea("QCT2")
dbclosearea()

DbSelectArea("SC7") //Pedido de Compras
DbSetOrder(5)
DbGoTop()
ProcRegua(RecCount())
While ! Eof()
	IncProc("Gerando Registro de Medicao...")
	
	If C7_RESIDUO='S' .Or. C7_ENCER == "E" .OR. SC7->C7_LOCAL<>'04' ////!SubStr(C7_PRODUTO,1,2) $ "SA_SP_SI"
		DbSelectArea("SC7")
		DbSkip()
		Loop
	EndIf
	dbSelectArea("SB1")
	dbSeek(Xfilial("SB1")+SC7->C7_PRODUTO)
	dbSelectArea("CTD")
	dbSeek(Xfilial("CTD")+SC7->C7_ITEMCTA)
	dbSelectArea("SZ0")
	
	cSetor:=Posicione("SZ2",3,Xfilial("cCusto")+Alltrim(SC7->C7_CC),"Z2_SETOR")
	//Calculando Datas
	cDataCx :=Space(05)
	cDataRf :=Space(05)
	cNumMed :=Space(06)
	//Calculando Data Caixa e Referencia
	cDataCx :=Space(05)
	cDataRf :=SubStr(DToC(SC7->C7_DATPRF),4,5)
	//Calculando Conta
	//Gravando Registros
	/* Alterado por gilson a pedido da simone dia 09 de agosto de 2012
	If RecLock("SZ0",.T.)
	Replace Z0_FILIAL  With Xfilial("SZ0") ,;
	Z0_LINHA   With "MM"  ,; //Medicao
	Z0_DATA    With SubStr(dToc(SC7->C7_EMISSAO),4,5),;
	Z0_HIST    With "MEDICAO-" + SC7->C7_NUM ,;
	Z0_LOTE    With "990000"    ,;
	Z0_DOC     With "99"+STRZERO(nCont,4) ,;
	Z0_VALOR   With ((SC7->C7_QUJE - SC7->C7_QUANT)* SC7->C7_PRECO) ,;
	Z0_DTREF   With cDataRf           ,;
	Z0_CONTA   With if(CTD->CTD_CLASSI<>'D',SB1->B1_CTACONS,SB1->B1_CTADESP),;
	Z0_CC      With SC7->C7_CC        ,;
	Z0_DTLANC  with DATE() ,;
	Z0_SETORIG With cSetor
	//               Z0_VALOR   With 0-(SC7->C7_TOTAL) ,;
	If SubStr(SC7->C7_CONTA,1,1) == "3"
	Replace Z0_CUSTO   With ((SC7->C7_QUJE - SC7->C7_QUANT)* SC7->C7_PRECO) //SC7->C7_TOTAL
	Else
	Replace Z0_RECEITA With ((SC7->C7_QUJE - SC7->C7_QUANT)* SC7->C7_PRECO) //SC7->C7_TOTAL
	EndIf
	MsUnlock()
	nCont:=nCont+1
	EndIf
	*/
	DbSelectArea("SC7")
	DbSkip()
End

//Restaurando Ambiente
DbSelectArea(aArq[1])
DbSetOrder(aArq[2])
DbGoTo(aArq[3])
///MsgBox("Geracao Finalizada Com Exito, Arquivo SZ0 Atualizado!","Termino","INFO")
Return(.T.)