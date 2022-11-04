/*
+-------------+---------+-------------+-------------------+-------+----------------------+
| Programa    |EXEQUERY | Programador | Wladimir R.Fernan | Data  | 10/02/03             |
+-------------+---------+-------------+-------------------+-------+----------------------+
| Descricao   | Querys de atualizacao de dados                                           |
+-------------+--------------------------------------------------------------------------+
| Uso         | Especifico para EPC                                                      |
+-------------+--------------------------------------------------------------------------+
|                          Modificacoes efetuadas no Programa                            |
+---------+-------------+----------------------------------------------------------------+
| Data    | Responsavel | Motivo                                                         |
+---------+-------------+----------------------------------------------------------------+
|         |             |                                                                |
+---------+-------------+----------------------------------------------------------------+
*/

#include "rwmake.ch"      
#include "TopConn.ch"

User Function EXEQUERY(cAno)
************************************************************************************
*
*
****
	Local cQuery := ""
	Local cfator := "1.77"

	//   	nFile:=FCreate("\custom_logs\fluxo\execqueryfluxo.txt")
	//	FWrite(nFile,"Ano:"+cAno+Chr(13)+Chr(10))
	//	FWrite(nFile,"Inicio do Calculo:"+Dtoc(Date())+" - "+Time()+Chr(13)+Chr(10))
	//   	FClose(nFile)

	TcSqlExec(cQuery)
	//O grupo Gerencial já preenchido deve deve ser tratado separadamente

	If cEmpAnt == '03'
		cfator := "1.51"
	elseIf cEmpAnt == '04'
		cfator := "1"
	Endif 

   cQuery:=" UPDATE "+RetSqlName("SZ0")+" SET "
	cQuery+="       Z0_VRPREV  =isNull(SZ1.Z1_VRPREV ,0 ), "
	cQuery+="       Z0_PROP    =IsNull(SZ2.Z2_PROP   ,''), "
	cQuery+="       Z0_SITUAC  =IsNull(SZ2.Z2_SITUAC ,''), "
	cQuery+="       Z0_DESC01  =IsNull(CT1.CT1_DESC01,''), "
	cQuery+="       Z0_FATOR   = CASE "
	cQuery+="						WHEN "
	cQuery+="							SZ0.Z0_GRUPGER NOT IN ('000007','000008')	OR "
	cQuery+="							ISNULL(CT1.CT1_FATOR ,1 ) <> "+cfator+"		OR "
	cQuery+="							ISNULL(SZ2.Z2_FATOR  ,"+cfator+" ) = "+cfator+""
	cQuery+="						THEN ISNULL(CT1.CT1_FATOR ,1 )"
	cQuery+="						ELSE SZ2.Z2_FATOR  "           
	cQuery+="					  END,"
	cQuery+="       Z0_CODCONT =IsNull(SZ1.Z1_COD    ,''), "
	cQuery+="       Z0_DESCSET =IsNull(CTT.CTT_DESC01,''), "
	cQuery+="       Z0_DESGER  =IsNull(SZA.ZA_DESCRI ,''), "
	cQuery+="       Z0_FATORE   = CASE "
	cQuery+="						WHEN "
	cQuery+="							SZ0.Z0_GRUPGER NOT IN ('000007','000008')	OR "
	cQuery+="							ISNULL(CT1.CT1_FATOR ,1 ) <> "+cfator+"		OR "
	cQuery+="							ISNULL(SZ2.Z2_FATOR  ,"+cfator+" ) = "+cfator+""
	cQuery+="						THEN ISNULL(CT1.CT1_FATOR ,1 )"
	cQuery+="						ELSE SZ2.Z2_FATOR  "           
	cQuery+="					  END,"
	cQuery+="       Z0_CLIENTE =IsNull(SA1.A1_NREDUZ ,''), "
	cQuery+="       Z0_OS      =IsNull(SZ2.Z2_OS     ,''), "
	cQuery+="       Z0_SUBCTA  =Left(Z0_CC,5) ,"
	cQuery+="       Z0_SETOR   =IsNull(SZ2.Z2_SETOR,'')"   
	cQuery+=" FROM "+RetSqlName("SZ0")+" SZ0 "
	cQuery+="	Left Outer Join "+RetSqlName("CT1")+" CT1 ON (SZ0.Z0_CONTA = CT1.CT1_CONTA AND CT1.D_E_L_E_T_<>'*')   "
	cQuery+="	Left Outer Join "+RetSqlName("SZ2")+" SZ2 ON (SZ0.Z0_CC    = SZ2.Z2_SUBC   AND SZ2.D_E_L_E_T_<>'*')   "
	cQuery+="	Left Outer Join "+RetSqlName("CTT")+" CTT ON (SZ2.Z2_SETOR = CTT.CTT_CUSTO AND CTT.D_E_L_E_T_<>'*')   "
	cQuery+="	Left Outer Join "+RetSqlName("SZ1")+" SZ1 ON (SZ1.Z1_COD   = SZ2.Z2_COD    AND SZ1.D_E_L_E_T_<>'*')   "
	cQuery+="	Left Outer Join "+RetSqlName("SZA")+" SZA ON (SZ0.Z0_GRUPGER = SZA.ZA_GRUPGER AND SZA.D_E_L_E_T_<>'*') "
	cQuery+="	Left Outer Join "+RetSqlName("SA1")+" SA1 ON (SA1.A1_COD   = SZ1.Z1_CODCLI   AND SA1.A1_LOJA  = SZ1.Z1_LOJA  AND SA1.D_E_L_E_T_<>'*') "
	cQuery+=" WHERE LEFT(Z0_DTLANC,4)='"+cAno+"' AND Z0_GRUPGER<>'' AND SZ0.Z0_DTREF<>'' AND  SZ0.D_E_L_E_T_<>'*' " 
	TcSqlExec(cQuery)
	
	
	cQuery:=" UPDATE "+RetSqlName("SZ0")+" SET "
	cQuery+="       Z0_VRPREV  =IsNull(SZ1.Z1_VRPREV ,0 ), "
	cQuery+="       Z0_PROP    =IsNull(SZ2.Z2_PROP   ,''), "
	cQuery+="       Z0_SITUAC  =IsNull(SZ2.Z2_SITUAC ,''), "
	cQuery+="       Z0_DESC01  =IsNull(CT1.CT1_DESC01,''), "
	cQuery+="       Z0_FATOR   =IsNull(CT1.CT1_FATOR ,1 ), "
	cQuery+="       Z0_CODCONT =IsNull(SZ1.Z1_COD    ,''), "
	cQuery+="       Z0_DESCSET =IsNull(CTT.CTT_DESC01,''), "
	cQuery+="       Z0_GRUPGER =IsNull(SZA.ZA_GRUPGER,''), "
	cQuery+="       Z0_DESGER  =IsNull(SZA.ZA_DESCRI ,''), "
	cQuery+="       Z0_FATORE  =IsNull(SZA.ZA_FATOR  ,1 ), "
	cQuery+="       Z0_CLIENTE =IsNull(SA1.A1_NREDUZ ,''), "
	cQuery+="       Z0_OS      =IsNull(SZ2.Z2_OS     ,''), "
	cQuery+="       Z0_SUBCTA  =Left(Z0_CC,5),"
    cQuery+="       Z0_SETOR   =IsNull(SZ2.Z2_SETOR,'')"  
    cQuery+=" FROM "+RetSqlName("SZ0")+" SZ0 "
	cQuery+="	Left Outer Join "+RetSqlName("CT1")+" CT1 ON (SZ0.Z0_CONTA = CT1.CT1_CONTA AND CT1.D_E_L_E_T_<>'*')   "
	cQuery+="	Left Outer Join "+RetSqlName("SZ2")+" SZ2 ON (SZ0.Z0_CC    = SZ2.Z2_SUBC   AND SZ2.D_E_L_E_T_<>'*')   "
	cQuery+="	Left Outer Join "+RetSqlName("CTT")+" CTT ON (SZ2.Z2_SETOR = CTT.CTT_CUSTO AND CTT.D_E_L_E_T_<>'*')   "
	cQuery+="	Left Outer Join "+RetSqlName("SZ1")+" SZ1 ON (SZ1.Z1_COD   = SZ2.Z2_COD    AND SZ1.D_E_L_E_T_<>'*')   "
	cQuery+="	Left Outer Join "+RetSqlName("SZA")+" SZA ON (CT1.CT1_GRUPO = SZA.ZA_GRUPGER AND SZA.D_E_L_E_T_<>'*') "
	cQuery+="	Left Outer Join "+RetSqlName("SA1")+" SA1 ON (SA1.A1_COD   = SZ1.Z1_CODCLI   AND SA1.A1_LOJA  = SZ1.Z1_LOJA  AND SA1.D_E_L_E_T_<>'*') "
	cQuery+=" WHERE  LEFT(Z0_DTLANC,4)='"+cAno+"' AND Z0_GRUPGER='' AND SZ0.Z0_DTREF<>'' AND  SZ0.D_E_L_E_T_<>'*' " 
	TcSqlExec(cQuery) 
	
	//Tratamento Específico para o Setor
	cQuery:=" UPDATE "+RetSqlName("SZ0")+" SET "
	cQuery+="       Z0_DESCSET =IsNull(CTT.CTT_DESC01,'') "
	cQuery+=" FROM "+RetSqlName("SZ0")+" SZ0 "
    cQuery+=" INNER JOIN "+RetSqlName("SZ2")+" SZ2 ON (SZ0.Z0_CC=SZ2.Z2_SUBC   AND SZ2.D_E_L_E_T_<>'*')   "
	cQuery+=" INNER JOIN "+RetSqlName("CTT")+" CTT ON (SZ0.Z0_SETOR=CTT.CTT_CUSTO AND CTT.D_E_L_E_T_<>'*')   "   
	cQuery+=" WHERE Z0_SETOR='' AND LEFT(Z0_DTLANC,4)='"+cAno+"' AND Z0_GRUPGER<>'' "
	cQuery+=" AND SZ0.Z0_DTREF<>''" 
	TcSqlExec(cQuery) 
	
Return
