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
| Joao Carlos | 01/11/05 | Conversao SIGACON p/ SIGACTB                 |
|-----------------------------------------------------------------------*/


User Function GERADOR()        
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

Local nXi := 0
Local nTipoLan := 0
 
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

//Exclui a contabilização maior que o ano de 2004.
cQuery  := " DELETE FROM "+RetSqlName("SZ0")
cQuery  += " WHERE ((((SUBSTRING(Z0_DATA ,4,2)+LEFT(Z0_DATA,2)  BETWEEN '0501' AND '9012') "
cQuery  += "     OR (SUBSTRING(Z0_DTREF,4,2)+LEFT(Z0_DTREF,2) BETWEEN '0501' AND '9012')) "
cQuery  += "     OR (Z0_LINHA IN ('PV','MM'))) AND Z0_LINHA<>'ZZ') AND " 
cQuery  += "      Z0_HIST<>'REALIZADO 2005-ENTRADA MANUAL' AND Z0_VEICULO != 'S'"
TCSQLExec(cQuery)

IncProc("Selecionando Registros dos Lançamentos contabeis...")


DbSelectArea("CT2") //Resumo Fluxo Economico
ProcRegua(RecCount())
if cEmpAnt='01'
	cQuery:= " SELECT R_E_C_N_O_ CT2RECNO"
	cQuery+= " FROM "+RetSqlName("CT2")
	cQuery+= " WHERE " 
	cQuery+= "       ((CT2_DEBITO <>'38190000' OR CT2_FILIAL <>'01') AND "
	cQuery+= "        (CT2_CREDIT <>'38190000' OR CT2_FILIAL <>'01') AND "
	cQuery+= "        (CT2_DEBITO <>'37240000'  OR SUBSTRING(CT2_ORIGEM,22,2) < '06' ) AND "
	cQuery+= "	      (CT2_CREDIT <>'37240000'  OR SUBSTRING(CT2_ORIGEM,22,2) < '06' ) AND "
	cQuery+= "        ((Left(CT2_DEBITO,3) <> '152' OR SUBSTRING(CT2_ORIGEM,22,2) < '06') OR Left(CT2_DEBITO,4) = '1522')     AND"
	cQuery+= "        ((Left(CT2_CREDIT,3) <> '152' OR SUBSTRING(CT2_ORIGEM,22,2) < '06') OR (Left(CT2_CREDIT,4)= '1522')     OR "
	cQuery+= "         (CT2_DEBITO <>'' And (CT2_DEBITO <>'38190000'  OR CT2_FILIAL <>'01') AND (CT2_CREDIT <>'38190000' OR CT2_FILIAL <>'01')) )) AND "
	cQuery+= " 	CT2_TPSALD IN ('1','9')  AND D_E_L_E_T_<>'*'" 
	
Else
	cQuery:= " SELECT R_E_C_N_O_ CT2RECNO"
	cQuery+= " FROM "+RetSqlName("CT2") 
//	cQuery+= " WHERE (LEFT(CT2_CREDIT,4)='1524' OR LEFT(CT2_DEBITO,4)='1524') AND D_E_L_E_T_<>'*' AND CT2_DATA>'20060101'"
	cQuery+= " WHERE CT2_TPSALD IN ('1','9')  AND D_E_L_E_T_<>'*'" 
Endif


TcQuery cQuery Alias QCT2 New
xnumlan:=0
DbSelectArea("QCT2") //Lancamentos Contabeis
DbGoTop()

While !Eof() 
	
	dbSelectArea("CT2") 
	dbGoto(QCT2->CT2RECNO)   
   xnumlan++
	IncProc("Gerando Lancamentos Contabeis..."+CT2->CT2_LOTE)
	   
	//Validacao solicitado por Estela em 22/12/05 - Claudio
	
	If !(CT2->CT2_TPSALD $ "1/9")          .OR. ;
	    (CT2->CT2_DEBITO $ "38190000"     .AND. CT2->CT2_FILIAL $ "01" ) .OR. ;
	    (CT2->CT2_DEBITO $ "37240000"     .AND. VAL(SUBSTR(CT2->CT2_ORIGEM,22,2)) >= 6);
		 
		 DbSelectArea("QCT2") //Lancamentos Contabeis
		 DbSkip()		
		 Loop
	EndIf 
    
	If CT2->CT2_DC='3' .And. (Left(CT2_CREDIT,4)='1152' .OR. Left(CT2_DEBITO,4)='1152')
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
	For nTipoLan := nForIni To nForFim
		
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

		cDataCx :=Space(05)
		cDataRf :=Space(05)
	    
		//Calculando Data Caixa e Referencia
		If SubStr(CT2->CT2_ORIGEM,1,2)=="CX"
			cDataCx := SubStr(CT2->CT2_ORIGEM,07,05)
			cDataRf := SubStr(CT2->CT2_ORIGEM,19,05)
		EndIf
	
		//Testando contas patrimoniais
		If (Alltrim(CT2->CT2_CREDIT) == "15230000" .or. Alltrim(CT2->CT2_DEBITO) == "15230000") 
			cConta := "15230000"
		EndIf
	
		If !(Empty(CT2->CT2_CCD) .And. Empty(CT2->CT2_CCC)) /// .and. Alltrim(cConta) #"15230000"
	    	
	    	If Alltrim(cLote)<>Alltrim(CT2->CT2_LOTE) .Or. CT2->CT2_DATA < Stod('20060501')
				cCCusto:=IIF(nTipoLan==1,CT2->CT2_CCD,If(Empty(CT2->CT2_CCC),CT2->CT2_CCD,CT2->CT2_CCC))  //
			Else
				//Lote da Folha, o Centro de Custo é o Item contábil
				//Conforme Observações feitas no inicio da Rotina 
				cCCusto:=IIF(nTipoLan==1,Alltrim(CT2->CT2_ITEMD),If(Empty(CT2->CT2_ITEMC),CT2->CT2_ITEMD,CT2->CT2_ITEMC))
			Endif
	
			If RecLock("SZ0",.T.)
				Replace  Z0_FILIAL  With CT2->CT2_FILIAL ,; //
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
							Z0_CC      With cCCusto
	
	          If SubStr(cConta,1,1) == "3" .or. Alltrim(cConta) $ "41410000_41420000_41430000_42410000_42420000_42430000"
	             Replace Z0_CUSTO   With ABS(nValor)      //N, 14, 2
	          Else
	             Replace Z0_RECEITA With ABS(nValor)      //N, 14, 2
	          EndIf
	          MsUnlock()
				
				// Registro já esta gravado e agora será contas de encargos,Provisões, Licenças e Auxilios
//				If cEmpAnt<>'02' .And. Left(cConta,4)>='3121' .And. Left(cConta,4)<='3124'
				If cEmpAnt = '01' .And. Left(cConta,4)>='3121' .And. Left(cConta,4)<='3124'
					RegToMemory("SZ0",.F.)
					aRatDesp:={}
					Aadd(aRatDesp,{'000095',0.3630})
					Aadd(aRatDesp,{'000096',0.2891})
					Aadd(aRatDesp,{'000097',0.1355})
					For nXi := 1 To Len(aRatDesp)
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
				         			Z0_CUSTO   With M->Z0_CUSTO,;
			             			Z0_RECEITA With M->Z0_RECEITA,;
			          				Z0_GRUPGER With aRatDesp[nXi,1]
							MsUnlock()
							//Faz a gravação dos campos de cadastro
						Endif
					Next nXi
				Endif          
			EndIf
		EndIf
		// Verifica se Houve atrazo no pedido
		If ((Left(CT2->CT2_CREDIT,4))='1121' .or. (Left(CT2->CT2_CREDIT,4))='1125') .AND. Val(Left(CT2->CT2_ORIGEM,3))>0
	
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
	                  Z0_LOTE    With '960000'            ,;        //C, 4
	                  Z0_DOC     With '96'+StrZero(nSeqDoc,4) ,;  //C, 6
	                  Z0_VALOR   With nValMulta              ,;   //N,14,02
	                  Z0_CONTA   With CT2->CT2_CREDIT          ,; //C, 20
	                  Z0_CC      With Left(SD2->D2_SUBC,4)+'A' ,; //C, 9
	                  Z0_DTREF   With StrZero(Month(SE1->E1_BAIXA),2)+'/'+Right(StrZero(year(SE1->E1_BAIXA  ),4),2) ,;
	                  Z0_DATA    With StrZero(Month(SF2->F2_EMISSAO),2)+'/'+Right(StrZero(year(SF2->F2_EMISSAO),4),2) ,;
	                  Z0_DTVENC  With StrZero(Month(SE1->E1_VENCTO),2)+'/'+ Right(StrZero(year(SE1->E1_VENCTO ),4),2) ,;
	                  Z0_DTCAIXA With StrZero(Month(SE1->E1_VENCREA),2)+'/'+Right(StrZero(year(SE1->E1_VENCREA),4),2) ,;
	                  Z0_CUSTO   With nValMulta
			Endif 
			MsUnlock()         
		Endif
	Next nTipoLan    
	
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
    
    If C7_ENCER == "E" .or. ! SubStr(C7_PRODUTO,1,2) $ "SA_SP_SI"
       DbSelectArea("SC7")
       DbSkip()
       Loop
    EndIf
    DbSelectArea("SZ0")
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
               Z0_DATA    With SubStr(dToc(SC7->C7_EMISSAO),4,5) ,;
               Z0_HIST    With "MEDICAO-" + SC7->C7_NUM ,;
               Z0_LOTE    With "990000"    ,;
               Z0_DOC     With "99"+STRZERO(nCont,4) ,;
               Z0_VALOR   With ((SC7->C7_QUJE - SC7->C7_QUANT)* SC7->C7_PRECO) ,;
               Z0_DTREF   With cDataRf           ,;
               Z0_CONTA   With SC7->C7_CONTA     ,;
               Z0_CC      With SC7->C7_CC          
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
