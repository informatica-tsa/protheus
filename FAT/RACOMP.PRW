#include "rwmake.ch"
#include "Topconn.ch"
/*
+-----------+------------+----------------+---------------+--------+------------+
| Programa  | A103F6     | Desenvolvedor  | Mr.Wladimir   | Data   | 20/12/02   |
+-----------+------------+----------------+---------------+--------+------------+
| Descricao | Relatório de Acompanhamento / Atrasos nos contratos               |
+-----------+-------------------------------------------------------------------+
| Uso       | Expecifico EPC/TSA                                                |
+-----------+-------------------------------------------------------------------+
|                   Modificacoes Apos Desenvolvimento Inicial                   |
+-------------+---------+-------------------------------------------------------+
| Responsavel | Data    | Motivo                                                |
+-------------+---------+-------------------------------------------------------+
|             |         |                                                       |
+-------------+---------+-------------------------------------------------------+
*/


User Function RACOMP()        
************************************************************************
* Relatório de Acompanhamento dos contratos
*
****

// Define Variaveis                                             ³

Private titulo   := "Acompanhamento dos Contratos"
Private cDesc1   := ""
Private cDesc2   := ""
Private cDesc3   := ""
Private wnrel    := "RACOMP"            //Nome Default do relatorio em Disco
Private cString  := "SI2"
/// Private aReturn  := { "Zebrado", 1,"Administracao", 2, 2, 1, "",1 }
Private aReturn  := { "Especial", 1,"Administracao", 1, 2, 2, "",1 }
Private nomeprog := "RACOMP"
Private aLinha   := { }
Private nLastKey := 0
Private cPerg    :="RACOMP"
Private cabec1   := "Gerente Responsável |Contr.|   Nome do Cliente    |    Contrato  | Fech. |Refer.|    Data     |Apr.Medic|Emissão| Condições de Pagamentos |   Previsão  |  Pedido a   | Data Do | Numero da |         Data          |    Valor    |   Data    |   Liquido   |Total de Dias" 
Private cabec2   := "                    | EPC  |                      |    Cliente   |Med.Dia| Mes  |(Dia/Mes/Ano)|P/Cliente|Fatura |   Dias / Datas fixas    |   Estimado  |   Faturar   |  Pedido |Nota Fiscal|-----------------------| Emitido(R$) |  Crédito  |Recebido(R$) |Atrasos Reais"
///Private cabec3   := "                    |      |                      |              |       |      |             |P/Cliente|Fatura |                         |             |      R$     | No Siga |           |Emissão    | Vencimento|     R$      |           |             |(Med.-Receb) "
Private cCancel  := "***** CANCELADO PELO OPERADOR *****"
Private tamanho  := "G"
Private limite  := 440
Private li       := 440
Private m_pag    := 1

//Verifica as perguntas selecionadas                           


pergunte(cPerg,.F.)
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Variaveis utilizadas para parametros                         ³
//³ mv_par01      // da Filial                                   ³
//³ mv_par02      // at‚ Filial                                  ³
//³ mv_par03      // Do Cliente                                  ³
//³ mv_par04      // Ate Cliente                                 ³
//³ mv_par05      // Da Loja                                     ³
//³ mv_par06      // Ate Loja                                    ³
//³ mv_par07      // Do Contrato                                 ³
//³ mv_par08      // Ate Contrato                                ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

//³ Envia controle para a funcao SETPRINT                        ³

WnRel := SetPrint(cString,wnrel,cPerg,@titulo,cDesc1,cDesc2,cDesc3,.F.,"",,Tamanho)

If nLastKey == 27
	Set Filter To
	Return
Endif

SetDefault(aReturn,cString)

If nLastKey == 27
	Set Filter To
	Return
Endif
                          
//Executa a Query e Cria o Arquivo de Trabalho a Ser Listado
cCabecalho := "Processando os Dados"
cMsgRegua  := "Processando "
Processa( {|| GravTrab()} ,"Processando os Dados","Aguarde....")
// Parametros: 1-Video
//             0 - Atualizadados
//             1 - Numero de Cópias 
cOptions:="1;0;1;Acompanhamento do Pedido de Vendas"
Callcrys("RELACOMP",,cOptions)
DbSelectArea("ZZ0")                                      
dbCloseArea()

Return


Static Function GravTrab()
************************************************************************************************
* Emite o Relatório
*
******
Local cQuery:=""
Local cConta:=""
Local cGerente:=""
Local dDataLim:=""
Local cAno:=""
Local cMes:=""
Local cDia:=""
Local cCondPag:=""
//Apaga todos os registros do relatorio anterior
cQuery:="DELETE FROM "+RetSqlName("ZZ0")
TcSqlExec(cQuery)




//Cria a Query com os dados
cQuery:=" SELECT SPACE(20) GERENTE,SC5.C5_CONTRAT C5_CONTRAT,SC5.C5_CLIENTE CLIENTE,SC5.C5_LOJACLI LOJA,SC5.C5_DATAREF C5_DATAREF, "
cQuery+=" SC5.C5_NOTA C5_NOTA,SC5.C5_SERIE C5_SERIE, "
cQuery+="       ISNULL(SE1.E1_PARCELA,'') PARCELA,ISNULL(E1_VENCREA,'') E1_VENCREA, "
cQuery+="       ISNULL(SE1.E1_BAIXA,'') E1_BAIXA,ISNULL(SUM(SE1.E1_VALOR),0) E1_VALOR,ISNULL(SUM(SE1.E1_VALLIQ),0) E1_VALLIQ, "
cQuery+="       SC6.C6_NUM NUMPED,SC6.C6_ENTREG C6_ENTREG,SC6.C6_DATFAT C6_DATFAT,ISNULL(SUM(SC6.C6_VALOR),0) C6_VALOR, "
cQuery+="       SZ1.Z1_DIAMM Z1_DIAMM,SZ1.Z1_PRAZOM Z1_PRAZOM,SZ1.Z1_PRAZORE Z1_PRAZORE,SZ1.Z1_TIPORE Z1_TIPORE,"
cQuery+="       SA1.A1_NREDUZ A1_NREDUZ, "
cQuery+="       LEFT(SC5.C5_DATAREF,6)+SZ1.Z1_DIAMM FECHAMED, "
cQuery+="       SPACE(4) CONTA, 0 APROMED,'00000000' DTAPROV,SPACE(8) EMISFA,0 ESTIMADO,0 DIASATR ,0 ATRASOS"
cQuery+=" FROM "+RetSqlName("SC5")+" SC5"
cQuery+=" LEFT OUTER JOIN "+RetSqlName("SE1")+" SE1 ON (SE1.E1_NUM=SC5.C5_NOTA AND SE1.E1_SERIE=SC5.C5_SERIE AND SE1.D_E_L_E_T_<>'*') "
cQuery+=" LEFT OUTER JOIN "+RetSqlName("SC6")+" SC6 ON (SC6.C6_NUM=SC5.C5_NUM AND SC6.C6_CLI=SC5.C5_CLIENTE AND SC6.C6_LOJA=SC5.C5_LOJACLI AND SC5.D_E_L_E_T_<>'*') "
cQuery+=" LEFT OUTER JOIN "+RetSqlName("SA1")+" SA1 ON (SA1.A1_COD=SC5.C5_CLIENTE AND SA1.A1_LOJA=SC5.C5_LOJACLI AND SA1.D_E_L_E_T_<>'*') "
cQuery+=" LEFT OUTER JOIN "+RetSqlName("SZ1")+" SZ1 ON (SZ1.Z1_COD=SC5.C5_CONTRAT AND SC5.D_E_L_E_T_<>'*') "
cQuery+=" WHERE    SC5.C5_FILIAL  BETWEEN '"+Mv_par01+"' AND '"+Mv_par02+"'" 
cQuery+="      AND SC5.C5_CLIENTE BETWEEN '"+Mv_par03+"' AND '"+Mv_par04+"'"
cQuery+="      AND SC5.C5_LOJACLI BETWEEN '"+Mv_par05+"' AND '"+Mv_par06+"'"
cQuery+="      AND SC5.C5_CONTRAT BETWEEN '"+Mv_par07+"' AND '"+Mv_par08+"'"
cQuery+="      AND SC5.C5_EMISSAO BETWEEN '"+DTOS(Mv_par09)+"' AND '"+DTOS(Mv_par10)+"'"
cQuery+="      AND SC5.C5_CONTRAT<>''  "
cQuery+="      AND SC5.D_E_L_E_T_<>'*' "
cQuery+=" GROUP BY  SC5.C5_NUM,SC5.C5_CONTRAT,SC5.C5_CLIENTE,SC5.C5_LOJACLI,SC5.C5_DATAREF,SC5.C5_NOTA,SC5.C5_SERIE,"
cQuery+=" 	   SE1.E1_NUM,SE1.E1_PARCELA,SE1.E1_VENCREA,SE1.E1_BAIXA, "
//cQuery+=" 	   SE1.E1_NUM,SE1.E1_PARCELA,SE1.E1_VENCREA,SE1.E1_BAIXA,SE1.E1_VALOR, "
cQuery+="      SC6.C6_NUM,SC6.C6_ENTREG,SC6.C6_DATFAT,   "
cQuery+="      SZ1.Z1_DIAMM,SZ1.Z1_PRAZOM,SZ1.Z1_PRAZORE,SZ1.Z1_TIPORE,"
cQuery+="      SA1.A1_NREDUZ      "
cQuery+=" ORDER BY SC5.C5_CONTRAT "

TCQUERY cQuery ALIAS "QSE1" NEW
// cArquTrab := TransQuery("QSE1","TRB1")
// nRecCount := RecCount()

//Atualiza os Campos calculados
DbSelectArea("QSE1")
DbGotop()
While !eof() 
    cConta:=""
    cGerente:=""
	cMesAno:=SubStr(QSE1->C5_DATAREF,3,2)+"/"+SubStr(QSE1->C5_DATAREF,5,2)
	cQuery:=" SELECT DISTINCT SZ2.Z2_CONTA,X5_DESCRI "
	cQuery+="    FROM "+RetSqlName("SZ2")+" SZ2"
	cQuery+="    LEFT OUTER JOIN "+RetSqlName("SX5")+" SX5 ON (X5_TABELA='97' AND X5_CHAVE=SZ2.Z2_GEREN AND SX5.D_E_L_E_T_<>'*') "
	cQuery+="    WHERE (SZ2.Z2_COD='"+QSE1->C5_CONTRAT+"' AND SZ2.D_E_L_E_T_<>'*')" 
	
	TCQUERY cQuery ALIAS "QTMP1" NEW //Executa a Query Temporaria
	
	cConta  :=QTMP1->Z2_CONTA            
	cGerente:=QTMP1->X5_DESCRI
	DbSelectArea("QTMP1")
    dbCloseArea()
    
	cQuery:=" SELECT Isnull(SUM(Z0_RECEITA),0) RECEITA"
	cQuery+=" FROM "+RetSqlName("SZ0")
	cQuery+=" WHERE LEFT(Z0_CC,4)='"+cConta+"'"
	cQuery+="       AND Z0_RECEITA<>0   "
	cQuery+="       AND Z0_DTREF='"+cMesAno+"'"
	cQuery+="       AND Z0_REVISAO=(SELECT MAX(Z0_REVISAO) FROM "+RetSqlName("SZ0")
	cQuery+="                       WHERE LEFT(Z0_CC,4)='"+cConta+"'"
	cQuery+="                       AND Z0_RECEITA<>0 "
	cQuery+="                       AND Z0_DTREF='"+cMesAno+"' )"
                                
    TCQUERY cQuery ALIAS "QTMP1" NEW
    
    DbSelectArea("ZZ0")
    If Reclock("ZZ0",.T.)
       	Replace ZZ0_GERENT  With cGerente
    	Replace ZZ0_CONTRA  With QSE1->C5_CONTRAT
    	Replace ZZ0_NREDUZ  With QSE1->A1_NREDUZ
    	Replace ZZ0_DIAMM   With Val(QSE1->Z1_DIAMM)
    	Replace ZZ0_FECHAM  With Stod(QSE1->FECHAMED)
    	Replace ZZ0_PRAZOM  With Val(QSE1->Z1_PRAZOM)
    	Replace ZZ0_EMISFA  With Stod(QSE1->EMISFA)
    	Replace ZZ0_PRAZOR  With Val(QSE1->Z1_PRAZORE)
    	Replace ZZ0_TIPORE  With QSE1->Z1_TIPORE
    	Replace ZZ0_DTAPRO  With Stod(QSE1->DTAPROV)
		Replace ZZ0_VALORP  With QSE1->C6_VALOR
        Replace ZZ0_ENTREG  With Stod(QSE1->C6_ENTREG)
        Replace ZZ0_DIASAT  With QSE1->DIASATR
        Replace ZZ0_NOTA    With QSE1->C5_NOTA
    	Replace ZZ0_SERIE   With QSE1->C5_SERIE
    	Replace ZZ0_DATFAT  With Stod(QSE1->C6_DATFAT)
    	Replace ZZ0_VENCRE  With Stod(QSE1->E1_VENCREA)
    	Replace ZZ0_VALORE  With QSE1->E1_VALOR
    	Replace ZZ0_BAIXA   With Stod(QSE1->E1_BAIXA)
    	Replace ZZ0_VALLIQ  With QSE1->E1_VALLIQ
		Replace ZZ0_ATRASO  With QSE1->ATRASOS
    	//Data da Aprovação
    	If !Empty(QSE1->FECHAMED)
    		Replace ZZ0_DTAPRO With DataValida(ZZ0->ZZ0_FECHAM+ZZ0->ZZ0_PRAZOM)
    	Else	
			Replace ZZ0_DTAPRO With Stod('')
		Endif	
		
	    Replace ZZ0_EMISFA   With ProxUtil(ZZ0->ZZ0_DTAPRO,1)
	    If !Empty(ZZ0->ZZ0_DTAPRO)
	    	If (ZZ0->ZZ0_ENTREG-ZZ0->ZZ0_DTAPRO)>0
    			Replace ZZ0_DIASAT With (ZZ0->ZZ0_ENTREG-ZZ0->ZZ0_DTAPRO)
    		Endif
	    Else 
    	 	Replace ZZ0_DIASAT With 0
	    Endif     
   		 //Calcula os Dias em Atrazo
    	If ZZ0->ZZ0_TIPORE='D'
    		If Day(ZZ0->ZZ0_EMISFA) <= ZZ0->ZZ0_PRAZOR .AND. !Empty(ZZ0->ZZ0_PRAZOR)
				//Proximo Mês   
				cAno:=StrZero(Year(ZZ0->ZZ0_EMISFA),4)
				cMes:=StrZero(Month(ZZ0->ZZ0_EMISFA),2)
				cDia:=StrZero(Day(ZZ0->ZZ0_EMISFA),2)
				If Month(ZZ0->ZZ0_EMISFA)=12
					cAno:=StrZero(Year(ZZ0->ZZ0_EMISFA)+1,4)
					cMes:='01'
				else
				  cMes:=StrZero(Val(cMes)+1,2)
				Endif	
		    else 
		    	cAno:=StrZero(Year(ZZ0->ZZ0_EMISFA),4)
				cMes:=StrZero(Month(ZZ0->ZZ0_EMISFA),2)
				cDia:=StrZero(ZZ0->ZZ0_PRAZOR,2)
		    Endif
		    dDataLim:=Stod(cAno+cMes+cDia)
	    Else
			dDataLim:=ZZ0->ZZ0_EMISFA+ZZ0->ZZ0_PRAZOR
	    Endif         
		//Grava os Atrazos
		If !Empty(dDataLim) .and. !Empty(ZZ0->ZZ0_BAIXA) .and. (ZZ0->ZZ0_BAIXA-dDataLim)>0
			Replace ZZ0_ATRASOS With ZZ0->ZZ0_BAIXA-dDataLim
		Else
		    Replace ZZ0_ATRASOS With 0
		Endif
		// Mes/Ano Fechamento
		If !empty(ZZ0->ZZ0_FECHAM)
			Replace ZZ0_MESREF With fMesDia(Dtos(ZZ0->ZZ0_FECHAM))
		Endif
		
		//Condições de pagamento 
		if ZZ0->ZZ0_PRAZOR>0
			If ZZ0->ZZ0_TIPORE='D'
			   cCondPag:=StrZero(ZZ0->ZZ0_PRAZOR,2)+"-Dias/Emissão da Fatura"
        	else 
				cCondPag:=StrZero(ZZ0->ZZ0_PRAZOR,2)+"-Dia de Cada Mês"
			Endif
		Endif
		Replace ZZ0_CONDIP With  cCondPag
		
		
	Endif
    DbSelectArea("QTMP1")
    dbCloseArea()
	DbSelectArea("QSE1")
	DbSkip()
Enddo
dBSelectArea("QSE1")
dbCloseArea()

Return


Static function ProxUtil(dDataIni,nDias)
************************************************************************************************
* Calcula qual é dia Util
*
****                     

Local dDatafim:=dDataIni
Local nDiasCor:=1
Local nxdias := 0       

If ! Empty(dDataIni)
	While nDiasCor<=nDias
		For nxdias := 1 to 7
			If !StrZero(dow(dDatafim+nxdias),2,0)$'07/01' // Sabado e Domingo
				 dDatafim:=Datavalida(dDatafim+nxdias)
				 nDiasCor++
				 nxdias:=7
	    	Endif
		Next nxdias
	Enddo
Endif	
Return(dDataFim)



Static function fMesDia(cData) // Formato DTOS YYYYMMDD
******************************************************************************
* Retorna a Data em Formato MES/Ano
*
******
Local aMes:={'Jan','Fev','Mar','Abr','Mai','Jun','Jul','Ago','Set','Out','Nov','Dez'}
Local cDtRet:=""
If !empty(cData)
	cDtRet:=aMes[val(Substring(cData,5,2))]+'/'+Substring(cData,3,2)
Endif
Return cDtRet




Static Function TestaSX1()
******************************************************************************
* Sincroniza a tabela de perguntas SX1
*
******

Local nxY := 0
Local nxZ := 0

aPerguntas := {}

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Variaveis utilizadas para parametros                         ³
//³ mv_par01      // da Filial                                   ³
//³ mv_par02      // at‚ Filial                                  ³
//³ mv_par03      // Do Cliente                                  ³
//³ mv_par04      // Ate Cliente                                 ³
//³ mv_par05      // Da Loja                                     ³
//³ mv_par06      // Ate Loja                                    ³
//³ mv_par07      // Do Contrato                                 ³
//³ mv_par08      // Ate Contrato                                ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ


AADD(aPerguntas,{cPerg,"Da Filial          ?","C",02,0,"G","","","","","","",""})
AADD(aPerguntas,{cPerg,"Ate Filial         ?","C",02,0,"G","","","","","","",""})
AADD(aPerguntas,{cPerg,"Do Cliente         ?","C",06,0,"G","","SA1","","","","",""})
AADD(aPerguntas,{cPerg,"Ate Cliente        ?","C",06,0,"G","","SA1","","","","",""})
AADD(aPerguntas,{cPerg,"Da Loja            ?","C",02,0,"G","","","","","","",""})
AADD(aPerguntas,{cPerg,"Ate loja           ?","C",02,0,"G","","","","","","",""})
AADD(aPerguntas,{cPerg,"Do Contrato        ?","C",05,0,"G","","SZ1","","","","",""})
AADD(aPerguntas,{cPerg,"Ate Contrato       ?","C",05,0,"G","","SZ1","","","","",""})
AADD(aPerguntas,{cPerg,"Da Emissao Pedido  ?","D",08,0,"G","","","","","","",""})
AADD(aPerguntas,{cPerg,"Ate emissao Pedido ?","D",08,0,"G","","","","","","",""})


For nxZ := 1 To Len(aPerguntas)

    dbSelectArea("SX1")
    RecLock("SX1",!dbSeek(cPerg+StrZero(nxZ,2)))
    Replace  X1_Grupo   With  cPerg
    Replace  X1_Ordem   With  StrZero(nxZ,2)
    Replace  X1_Pergunt With  aPerguntas[nxZ,2]
    Replace  X1_Variavl With  "Mv_Ch"+IIf(nxZ <=9,AllTrim(Str(nxZ)),Chr(nxZ + 55))
    Replace  X1_Tipo    With  aPerguntas[nxZ,3]
    Replace  X1_Tamanho With  aPerguntas[nxZ,4]
    Replace  X1_Decimal With  aPerguntas[nxZ,5]
    Replace  X1_GSC     With  aPerguntas[nxZ,6]
    Replace  X1_F3      With  aPerguntas[nxZ,8]
    Replace  X1_Var01   With  "Mv_Par"+StrZero(nxZ,2)
    If (aPerguntas[nxZ,6] == "C")
       For nxY := 9 To 13
           If (aPerguntas[nxZ,nxY] == "")
              Exit
           Else
              Do Case
                 Case ((nxY - 8) == 1)
                      Replace X1_Def01 With aPerguntas[nxZ,nxY]
                 Case ((nxY - 8) == 2)
                      Replace X1_Def02 With aPerguntas[nxZ,nxY]
                 Case ((nxY - 8) == 3)
                      Replace X1_Def03 With aPerguntas[nxZ,nxY]
                 Case ((nxY - 8) == 4)
                      Replace X1_Def04 With aPerguntas[nxZ,nxY]
                 Case ((nxY - 8) == 5)
                      Replace X1_Def05 With aPerguntas[nxZ,nxY]
              EndCase
           EndIf
        Next
    EndIf
Next

Return

/*
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
Gerente Responsável |Contr.|   Nome do Cliente    |    Contrato  | Fech. |Refer.|    Data     |Aprovação|Emissão| Condições de Pagamentos |   Previsão  |  Pedido a   | Data Do | Numero da |         Data          |    Valor    |   Data    |   Liquido   |Total de Dias
                    | EPC  |                      |    Cliente   |Medição| Mes  |(Dia/Mes/Ano)| Medição |  Da   |   Dias / Datas fixas    |   Estimado  |   Faturar   |  Pedido |Nota Fiscal|-----------------------|   Emitido   |  Crédito  |   Recebido  |Atrasos Reais
                    |      |                      |              |       |      |             |         |       |                         |             |             |         |           |           |           |             |           |             |             
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
XXXXXXXXXXXXXXXXXXX |99999 |XXXXXXXXXXXXXXXXXXXX  |XXXXXXXXXXXX  |  99   |XXX/99| 99/99/9999  |    99   | XXX-99|XXXXXXXXXXXXXXXXXXXXXXXX |99.999.999,99|99.999.999,99|99/99/999|999999-XXX | 99/99/9999| 99/99/9999|99.999.999,99| 99/99/9999|99.999.999,99|   99   
XXXXXXXXXXXXXXXXXXX |99999 |XXXXXXXXXXXXXXXXXXXX  |XXXXXXXXXXXX  |  99   |XXX/99| 99/99/9999  |    99   | XXX-99|XXXXXXXXXXXXXXXXXXXXXXXX |99.999.999,99|99.999.999,99|99/99/999|999999-XXX | 99/99/9999| 99/99/9999|99.999.999,99| 99/99/9999|99.999.999,99|   99   
XXXXXXXXXXXXXXXXXXX |99999 |XXXXXXXXXXXXXXXXXXXX  |XXXXXXXXXXXX  |  99   |XXX/99| 99/99/9999  |    99   | XXX-99|XXXXXXXXXXXXXXXXXXXXXXXX |99.999.999,99|99.999.999,99|99/99/999|999999-XXX | 99/99/9999| 99/99/9999|99.999.999,99| 99/99/9999|99.999.999,99|   99   
XXXXXXXXXXXXXXXXXXX |99999 |XXXXXXXXXXXXXXXXXXXX  |XXXXXXXXXXXX  |  99   |XXX/99| 99/99/9999  |    99   | XXX-99|XXXXXXXXXXXXXXXXXXXXXXXX |99.999.999,99|99.999.999,99|99/99/999|999999-XXX | 99/99/9999| 99/99/9999|99.999.999,99| 99/99/9999|99.999.999,99|   99   
*/