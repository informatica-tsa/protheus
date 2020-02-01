#include "rwmake.ch"
#include "Topconn.ch"
/*
+-----------+------------+----------------+---------------+--------+------------+
| Programa  | RGPE001    | Desenvolvedor  | Mr.Wladimir   | Data   | 04/09/06   |
+-----------+------------+----------------+---------------+--------+------------+
| Descricao | Funcionário Salario X Adicionais                                  |
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

User Function RGPE001()
******************
// Define Variaveis
Local aPerg:={}
Local cPerg:="RGPE01"
Private titulo   := "Funcionário Salario X Adicionais"
Private cDesc1   := ""
Private cDesc2   := ""
Private cDesc3   := ""
Private wnrel    := "RGPE01"            //Nome Default do relatorio em Disco


AADD(aPerg,{cPerg,"Filial de     ?","C",02,0,"G","","","","","","",""})
AADD(aPerg,{cPerg,"Filial Até    ?","C",02,0,"G","","","","","","",""})
AADD(aPerg,{cPerg,"Matricula de  ?","C",06,0,"G","","","SRA","","","",""})
AADD(aPerg,{cPerg,"Matricula Ate ?","C",06,0,"G","","","SRA","","","",""})
AADD(aPerg,{cPerg,"C.Custo de    ?","C",20,0,"G","","","CTT","","","",""})
AADD(aPerg,{cPerg,"C.Custo de    ?","C",20,0,"G","","","CTT","","","",""})
AADD(aPerg,{cPerg,"Admissão de   ?","D",01,0,"G","","","","","","",""})
AADD(aPerg,{cPerg,"Admissão Ate  ?","D",01,0,"G","","","","","","",""})
AADD(aPerg,{cPerg,"Situação da Folha:","C",05,0,"G","fsituacao","","","","","",""})
AADD(aPerg,{cPerg,"Categorias :"   ,"C",15,0,"G","fcategoria","","","","","",""})
AADD(aPerg,{cPerg,"Ordem de Impressão:","N",1,0,"C","","","C.Custo+Nome","C.Custo+Matricula","","","","",""})



Pergunte(cPerg,.T.)

cFilDe     :=MV_PAR01
cFilAte    :=MV_PAR02
cMatDe     :=MV_PAR03
cMatAte    :=MV_PAR04
cCustoDe   :=MV_PAR05
cCustoAte  :=MV_PAR06
cAdmDe     :=Dtos(MV_PAR07)
cAdmAte    :=Dtos(MV_PAR08)
cSituaca   :=""
cCategoria :=""
cOrdem:=StrZero(MV_PAR11,1)



//Executa a Query e Cria o Arquivo de Trabalho a Ser Listado
cCabecalho := "Processando os Dados"
cMsgRegua  := "Processando "
Processa( {|| GravTrab()} ,"Processando os Dados","Aguarde....")
// Parametros: 1-Video
//             0 - Atualizadados
//             1 - Numero de Cópias 
cOptions:="'1';'0';'1';'Funcionários' "
cOptions:="1;0;1;Funcionários"
cParams:=cEmpAnt
Processa( {|| Callcrys("RGPE01",cParams,cOptions)} ,"Emitindo o Relatório","Aguarde....")


Return



Static Function GravTrab()
*********************************************************************************************************
*
*
****

Local nXi := 0

cSituaca   :=""
// Situação
For nXi := 1 To Len(MV_PAR09)
	If Substring(MV_PAR09,nXi,1)<>'*'
		cSituaca+="'"+Substring(MV_PAR09,nXi,1)+If(nXi==Len(MV_PAR09),"'","',")
	Endif
Next nXi

//Categoria
For nXi:=1 To Len(MV_PAR10)
	If Substring(MV_PAR10,nXi,1)<>'*' .And. Substring(MV_PAR10,nXi,1)<>' '
		cCategoria+="'"+Substring(MV_PAR10,nXi,1)+"',"
	Endif
Next nXi
cCategoria:=If(Right(cCategoria,1)=',',Left(cCategoria,Len(cCategoria)-1),cCategoria)
cSituaca  :=If(Right(cSituaca,1)=',',Left(cSituaca,Len(cSituaca)-1),cSituaca)

TcSqlExec("DROP TABLE RGPE01")
cQuery:= " SELECT '"+cEmpAnt+"' RA_EMPRESA,RA_FILIAL,RA_MAT,RA_NOME,RA_CC,RA_SITFOLH,RA_CATFUNC,RA_ADMISSA, "
cQuery+= " RA_SALARIO,RA_ANTEAUM,RA_ADCTRAN, RA_INSMED,RA_INSMIN, RA_INSMAX,RA_PERICUL, "
cQuery+= " IsNull(CTT_DESC01,'') CTT_DESC01, "
cQuery+= " IsNull(RJ_FUNCAO,'') RJ_FUNCAO,IsNull(RJ_DESC,'') RJ_DESC, IsNull(RCE_CODIGO,'') RCE_CODIGO ,IsNull(RCE_DESCRI,'') RCE_DESCRI, "
cQuery+= " Cast(RX_TXT AS NUMERIC) RX_TXT "
cQuery+= " INTO  RGPE01 "
cQuery+= " FROM "+RetSqlName("SRA")+" SRA "
cQuery+= " LEFT OUTER JOIN "+RetSqlName("CTT")+" CTT ON (CTT_CUSTO=RA_CC AND CTT.D_E_L_E_T_<>'*') "
cQuery+= " LEFT OUTER JOIN "+RetSqlName("SRJ")+" SRJ ON (SRJ.RJ_FUNCAO=RA_CODFUNC AND SRJ.D_E_L_E_T_<>'*') "
cQuery+= " LEFT OUTER JOIN "+RetSqlName("RCE")+" RCE ON (RCE_CODIGO=RA_SINDICA AND RCE.D_E_L_E_T_<>'*') "
cQuery+= " INNER JOIN "+RetSqlName("SRX")+" SRX ON ( SRX.RX_TIP='11' AND SRX.RX_COD='' AND SRX.D_E_L_E_T_<>'*') "
cQuery+= " WHERE "
cQuery+= "     SRA.RA_MAT     BETWEEN '"+cMatDe+"'   AND '"+cMatAte+"'"
cQuery+= " AND SRA.RA_FILIAL  BETWEEN '"+cFilDe+"'   AND '"+cFilAte+"'"
cQuery+= " AND SRA.RA_ADMISSA BETWEEN '"+cAdmDe+"'   AND '"+cAdmAte+"'"
cQuery+= " AND SRA.RA_CC      BETWEEN '"+cCustoDe+"' AND '"+cCustoAte+"'"
cQuery+= " AND SRA.RA_CATFUNC  IN  ("+cCategoria+")"
cQuery+= " AND SRA.RA_SITFOLH IN ("+cSituaca+")"
cQuery+= " AND SRA.D_E_L_E_T_<>'*'  "
cQuery+= " ORDER BY "+if(cOrdem='1',"SRA.RA_CC+SRA.RA_NOME","SRA.RA_CC+SRA.RA_MAT")
TcSqlExec(cQuery)

Return()
