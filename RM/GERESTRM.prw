#Include "RWMAKE.CH"      
#Include "TopConn.ch"
#include "Ap5mail.ch"  
/*
+-----------------------------------------------------------------------+
¦Programa  ¦GERESTRM   ¦ Autor ¦ Thiago Santos         ¦Data ¦09.04.2020¦
+----------+------------------------------------------------------------¦
¦Descricao ¦Rotina para gerar estimado do RM - TOP        		   		¦
+----------+------------------------------------------------------------¦
¦ Uso      ¦ ESPECIFICO PARA A TSA                                      ¦
+-----------------------------------------------------------------------¦
¦           ATUALIZACOES SOFRIDAS DESDE A CONSTRUCAO INICIAL            ¦
+-----------------------------------------------------------------------¦
¦PROGRAMADOR ¦ DATA   ¦ MOTIVO DA ALTERACAO                             ¦
+------------+--------+-------------------------------------------------¦
¦            ¦        ¦                                                 ¦
+-----------------------------------------------------------------------+
*/

User Function GERESTRM()
  
	Local cPerg:="ESTSZB" 
	Local aPerg:={}
	
	If !File("CalcEstimadoRM-"+cEmpAnt+".txt")              
	
		nFile:=FCreate("CalcEstimadoRM-"+cEmpAnt+".txt")
		FWrite(nFile,"Usuário:"+cUserName+Chr(13)+Chr(10))
		FWrite(nFile,"Inicio do Calculo:"+Dtoc(Date())+" - "+Time()+Chr(13)+Chr(10))
		FClose(nFile)          
	
		AADD(aPerg,{cPerg,"Revisão de  ?","C",06,0,"G","","","","","","",""})
		AADD(aPerg,{cPerg,"Revisão Ate ?","C",06,0,"G","","","","","","",""})
		
		
		@ 0,0 TO 180,450 DIALOG oDlg1 TITLE "Gerador do Estimado do RM"
		
		@ 04,05 TO 55,220
		@ 10,10 SAY "Esta rotina tem o intuito de gerar o Estimado do RM individualmente para o Fluxo "
		@ 20,10 SAY "Econômico. Esta Rotina podera demandar"
		@ 30,10 SAY " alguns minutos e nao e' recomendavel interrompe-la. Clique em <OK> para confirmar"
		@ 40,10 SAY " ou <Cancela> para Cancelar."
		@ 65,120 BMPBUTTON TYPE 01 ACTION (Confirma(),Close(oDlg1))
		@ 65,148 BMPBUTTON TYPE 02 ACTION Close(oDlg1)
		@ 65,178 BMPBUTTON TYPE 05 ACTION Pergunte(cPerg,.T.)
		
		ACTIVATE DIALOG oDlg1 CENTER

	  	FErase("CalcEstimadoRM-"+cEmpAnt+".txt")
	else 
		MsgBox("O Estimado do RM já esta sendo processado por "+Chr(13)+Chr(10)+MemoRead("CalcEstimadoRM"+cEmpAnt+".txt"))
	endif
		
Return

Static Function Confirma()

	Processa( {|| GetEstRM() },"Importando Registros das Tabela do Top RM para a SZ0","Alterando Registro ..." )
	
Return()

Static Function GetEstRM()
		Local nValor 	:= 0
		Local cQuery 	:= ""
		Local cQuery2 	:= ""
		Local cSeq   	:= "00"
		Local cSetor 	:= ""
		Local aArea 	:= GetArea()
		Local cPerg		:= "ESTSZB"
		Local cCcusto 	:= ""
		Local cAccount  := GetMv("MV_WFACC") 
		Local cCtaPass  := GetMv("MV_WFPASSW")
		Local cCtaSmpt  := GetMv("MV_WFSMTP")
		Local cSendBy	:= GetMv("RM_SENDBY")
		Local cSendTo	:= GetMv("RM_SENDTO")
		Local cBancoRM	:= GetMv("RM_BANCO")
		Local cMens		:= ""
		Local cMens2	:= ""
		Local cProjAux 	:= ""
		Local cTrfAux	:= ""
		Local cTrfAux1	:= ""
		Local chtmlca 	:= ""
		Local chtmlcb 	:= ""
		Local chtmlcc 	:= ""
		Local cHtmlFi 	:= ""
		Local lerro		:= .F.
		Local cEol		:= Chr(13)
		
		
		
		chtmlca:='<html> '+cEol
		cHtmlCa+='	<head>'+cEol
		cHtmlCa+='		<TITLE>-Lista de Inconsistências </TITLE>'+cEol
		cHtmlCa+='	</HEAD>'+cEol
		cHtmlCa+='	<Table border=2 cellspacing=0 bordercolor="black" width=800 >'+cEol
		cHtmlCa+='		<tr>'+cEol
		cHtmlCa+='			<td align="Left" colspan=5  bgColor="Silver" ><B> Segue abaixo a lista de inconsistências do Top RM. É necessário que todas as pendências sejam solucionadas para que o estimado destas linhas entrem no fluxo. </B><br></td>'+cEol
		cHtmlCa+='		</tr>'+cEol
		cHtmlCa+='		<tr>'+cEol
		cHtmlCa+='			<td colspan=5 > </td>'+cEol
		cHtmlCa+='		</tr>'+cEol
		
		cHtmlCb+= cHtmlCa
		cHtmlCb+='		<tr>'+cEol
		cHtmlCb+='			<td align=center bgColor="Silver">Projeto</td>'+cEol
		cHtmlCb+='			<td align=center bgColor="Silver">Cod. Tarefa</td>'+cEol
		cHtmlCb+='			<td align=center bgColor="Silver">Desc. Tarefa</td>'+cEol
		cHtmlCb+='			<td align=center bgColor="Silver">C.C do Projeto</td>'+cEol
		cHtmlCb+='			<td align=center bgColor="Silver">C.C da Tarefa</td>'+cEol
		cHtmlCb+='		</tr>'+cEol
		
		cHtmlCc+= cHtmlCa
		cHtmlCc+='		<tr>'+cEol
		cHtmlCc+='			<td align=center bgColor="Silver">Projeto</td>'+cEol
		cHtmlCc+='			<td align=center bgColor="Silver">Cod. Tarefa</td>'+cEol
		cHtmlCc+='			<td align=center bgColor="Silver">Desc. Tarefa</td>'+cEol
		cHtmlCc+='			<td align=center bgColor="Silver">Grupo</td>'+cEol
		cHtmlCc+='			<td align=center bgColor="Silver">Conta Orçamentária</td>'+cEol
		cHtmlCc+='		</tr>'+cEol
		
		cHtmlFi+='	</table>'+cEol
		cHtmlFi+='</html> '+cEol
		
		Pergunte(cPerg,.F.)
		
		cQuery  := " DELETE FROM "+RetSqlName("SZ0")
		cQuery  += " WHERE Z0_LINHA in ('ZZ') AND "
		cQuery  += "       Z0_HIST LIKE 'ESTIMADO RM -%' "
		
		
		TCSQLExec(cQuery)
		
		cQuery:= "		SELECT PROJ.CODPRJ,PROJ.POSICAO, "
		cQuery+= "		(CASE "
		cQuery+= "      WHEN POSICAO = 1 THEN 'Em Andamento'"
		cQuery+= "		WHEN POSICAO = 2 THEN 'Paralisado'"
		cQuery+= "		WHEN POSICAO = 3 THEN 'Concluído'"
		cQuery+= "		WHEN POSICAO = 4 THEN 'A Executar'"
		cQuery+= "		WHEN POSICAO = 5 THEN 'Em Negociação'"
		cQuery+= "		WHEN POSICAO = 6 THEN 'Revisado'"
		cQuery+= "		WHEN POSICAO = 7 THEN 'Cancelado'"
		cQuery+= "		ELSE ''"
		cQuery+= "		END) MSTATUS,"
		cQuery+= "		PROJ.TIPOFASE,"
		cQuery+= "		(CASE "
		cQuery+= "		WHEN PROJ.TIPOFASE = 1 THEN 'Proposta'"
		cQuery+= "		WHEN PROJ.TIPOFASE = 2 THEN 'Venda'"
		cQuery+= "		WHEN PROJ.TIPOFASE = 3 THEN 'Planejamento'"
		cQuery+= "		WHEN PROJ.TIPOFASE = 4 THEN 'A Execução'"
		cQuery+= "		ELSE ''"
		cQuery+= "		END) MFASE,"
		cQuery+= "		CRONOG.CODCOLIGADA,FILIAL.IDINTEGRACAO AS FILIAL_PROTHEUS,CRONOG.IDPRJ,CRONOG.IDTRF,CRONOG.CODTRF,CRONOG.IDPERIODO,CRONOG.NOME,INSUMO.CODISM,CRONOG.DTINICIO,CRONOG.DTFIM,CAST(CRONOG.VALORPLANEJADO AS float) AS VALORPLANEJADO,TRF.CODCCUSTO AS CODCUSTOTAREFA,PROJ.CODCCUSTO AS CODCUSTOPROJETO, COMP.CONTAORC, MINSUMO.CODGIS AS GRUPO, SUBSTRING(CONVERT(varchar, CRONOG.DTINICIO ,3),4,5) AS MES_REF FROM "+cBancoRM+".dbo.MXMTAREFACRONOG AS CRONOG " 
		cQuery+= "		INNER JOIN "+cBancoRM+".dbo.MPRJ AS PROJ ON PROJ.CODCOLIGADA = CRONOG.CODCOLIGADA AND PROJ.IDPRJ = CRONOG.IDPRJ"
		cQuery+= "		INNER JOIN "+cBancoRM+".dbo.GFILIAL AS FILIAL ON FILIAL.CODCOLIGADA = PROJ.CODCOLIGADA AND FILIAL.CODFILIAL = PROJ.CODFILIAL"
		cQuery+= "		LEFT JOIN "+cBancoRM+".dbo.MTRFCCUSTO AS TRF ON TRF.CODCOLIGADA = CRONOG.CODCOLIGADA AND TRF.IDPRJ = CRONOG.IDPRJ AND TRF.IDTRF = CRONOG.IDTRF"
		cQuery+= "		LEFT JOIN "+cBancoRM+".dbo.MTRFCOMPL AS COMP ON COMP.CODCOLIGADA = CRONOG.CODCOLIGADA AND COMP.IDPRJ = CRONOG.IDPRJ AND COMP.IDTRF = CRONOG.IDTRF"
		cQuery+= "		LEFT JOIN "+cBancoRM+".dbo.MTAREFA AS MTRF ON MTRF.CODCOLIGADA = CRONOG.CODCOLIGADA AND MTRF.IDPRJ = CRONOG.IDPRJ AND MTRF.IDTRF = CRONOG.IDTRF"
		cQuery+= "		LEFT JOIN "+cBancoRM+".dbo.MISM AS INSUMO ON INSUMO.CODCOLIGADA = CRONOG.CODCOLIGADA AND INSUMO.IDPRJ = CRONOG.IDPRJ AND INSUMO.IDISM = MTRF.IDISM"
		cQuery+= "		LEFT JOIN "+cBancoRM+".dbo.MGIS AS MINSUMO ON MINSUMO.CODCOLIGADA = CRONOG.CODCOLIGADA AND MINSUMO.IDPRJ = INSUMO.IDPRJ AND MINSUMO.IDGIS = INSUMO.IDGIS"
		cQuery+= "		WHERE  "
		cQuery+= "		CRONOG.VALORPLANEJADO IS NOT NULL AND CRONOG.VALORPLANEJADO > 0"
		cQuery+= "		AND PROJ.POSICAO = '4'"										  
		cQuery+= "		AND (PROJ.TIPOFASE = '3' OR PROJ.TIPOFASE = '4')"			   
		cQuery+= "		AND MINSUMO.CODGIS IS NOT NULL		"						   
		cQuery+= "		AND COMP.CONTAORC  IS NOT NULL	AND RTRIM(COMP.CONTAORC) <> ''" 
		cQuery+= "		AND (TRF.CODCCUSTO IS NOT NULL OR PROJ.CODCCUSTO IS NOT NULL ) ORDER BY PROJ.CODPRJ, CRONOG.CODTRF"
		
		
		TcQuery cQuery Alias QRM New
		dbSelectArea("QRM")
		dbGotop()
			
		While !Eof()
			
			lerro := .F.
			
			//##########################################
			//VALIDAÇÃO PARA VERIFICAR SE O PROJETO NO LOOP MUDOU PARA ENVIO DO EMAIL
			If (cProjAux == "")
				cProjAux := QRM->CODPRJ 	
			ElseIf cProjAux != QRM->CODPRJ 
				If !empty(cMens)
					cSendTo := Iif (empty(U_GerPlan(substr(cProjAux,2,4))),cSendTo,cSendTo+";"+U_GerPlan(substr(cProjAux,2,4)))
					CONNECT SMTP SERVER cCtaSmpt ACCOUNT cAccount PASSWORD cCtaPass 
					SEND MAIL FROM  cSendBy TO  cSendTo SUBJECT 'Top(RM) Inconsistencias no planejamento (Subcontas Distintas) do projeto: '+cProjAux BODY cHtmlCb+cMens+cHtmlFi 
					DISCONNECT SMTP SERVER
					cMens  		:= ""
				EndIf
				If !empty(cMens2)
					cSendTo := Iif (empty(U_GerPlan(substr(cProjAux,2,4))),cSendTo,cSendTo+";"+U_GerPlan(substr(cProjAux,2,4)))
					CONNECT SMTP SERVER cCtaSmpt ACCOUNT cAccount PASSWORD cCtaPass 
					SEND MAIL FROM  cSendBy TO  cSendTo SUBJECT 'Top(RM) Inconsistencias no planejamento (Grupo e conta divergente) do projeto: '+cProjAux BODY cHtmlCc+cMens2+cHtmlFi 
					DISCONNECT SMTP SERVER
					cMens2 		:= ""
				EndIf
				cProjAux 	:= QRM->CODPRJ 
			EndIf
			//##########################################
			
			If empty(QRM->CODCUSTOTAREFA)
	        	cCcusto :=  QRM->CODCUSTOPROJETO							
	        Else
	        	cCcusto :=  QRM->CODCUSTOTAREFA
	        	If (substr(QRM->CODCUSTOTAREFA,1,4) != substr(QRM->CODCUSTOPROJETO,1,4) .And. !Empty(QRM->CODCUSTOPROJETO))
	        		lerro := .T.
	        		If (cTrfAux == "" .or. cTrfAux != QRM->CODTRF )
	        			cMens+='		<tr>'+cEol
		        		cMens+='			<td align=center  bgColor="Silver">'+AllTrim(QRM->CODPRJ)+'</td>'+cEol
						cMens+='			<td align=center  bgColor="Silver">'+AllTrim(QRM->CODTRF)+'</td>'+cEol
						cMens+='			<td align=center  bgColor="Silver">'+AllTrim(QRM->NOME)+'</td>'+cEol
						cMens+='			<td align=center  bgColor="Silver">'+AllTrim(QRM->CODCUSTOPROJETO)+'</td>'+cEol
						cMens+='			<td align=center  bgColor="Silver">'+AllTrim(QRM->CODCUSTOTAREFA)+'</td>'+cEol
						cMens+='		</tr>'+cEol
						cTrfAux := QRM->CODTRF
	        		endif
	        	EndIf
	        EndIf	
				
			cQuery2 := "SELECT COUNT(*) AS QTD FROM CT1"+cEmpAnt+"0 WHERE D_E_L_E_T_ = '' AND CT1_CONTA = '"+ALLTRIM(QRM->CONTAORC)+"' AND CT1_GRUPO = '"+ALLTRIM(QRM->GRUPO)+"'"	
	        TcQuery cQuery2 Alias QCT1 New
			dbSelectArea("QCT1")
			dbGotop()
			if QCT1->QTD = 0
				lerro := .T.
				If (cTrfAux1 == "" .or. cTrfAux1 != QRM->CODTRF )
	        			cMens2+='		<tr>'+cEol
		        		cMens2+='			<td align=center  bgColor="Silver">'+AllTrim(QRM->CODPRJ)+'</td>'+cEol
						cMens2+='			<td align=center  bgColor="Silver">'+AllTrim(QRM->CODTRF)+'</td>'+cEol
						cMens2+='			<td align=center  bgColor="Silver">'+AllTrim(QRM->NOME)+'</td>'+cEol
						cMens2+='			<td align=center  bgColor="Silver">'+AllTrim(QRM->GRUPO)+'</td>'+cEol
						cMens2+='			<td align=center  bgColor="Silver">'+AllTrim(QRM->CONTAORC)+'</td>'+cEol
						cMens2+='		</tr>'+cEol
						cTrfAux1 := QRM->CODTRF
	        	endif
			endif
			dbSelectArea("QCT1")	
			dbCloseArea()
			
			cSetor := Posicione("SZ2",3,QRM->FILIAL_PROTHEUS+Alltrim(QRM->CODCUSTOPROJETO),"Z2_SETOR")
			nValor := (-1) * QRM->VALORPLANEJADO
			
			If !lerro
			  	DbSelectArea("SZ0")
				Reclock("SZ0",.T.)
					Replace Z0_FILIAL 	With QRM->FILIAL_PROTHEUS
					Replace Z0_LINHA 	With "ZZ"
					Replace Z0_HIST 	With "ESTIMADO RM - TRF: " + QRM->CODTRF
					Replace Z0_LOTE 	With "9800"      	
					Replace Z0_DOC 	 	With "9800"+cSeq 	
					Replace Z0_VALOR 	With nValor 										
					Replace Z0_CONTA 	With QRM->CONTAORC	 
			        Replace Z0_CC		With cCcusto
					Replace Z0_DESC2	With QRM->NOME	
					Replace Z0_DTREF 	With QRM->MES_REF
					Replace Z0_DATA 	With "" 		
					Replace Z0_DTCAIXA 	With ""   		
					Replace Z0_DTVENC  	With ""   		  
					Replace Z0_GRUPGER 	With QRM->GRUPO
					Replace Z0_CUSTO   	With Iif(nValor < 0,nValor,0)
					Replace Z0_RECEITA 	With Iif(nValor > 0,nValor,0)
					Replace Z0_Revisao 	With MV_PAR02																	
					Replace Z0_DTLANC  	With ddatabase																	
					Replace Z0_SETORIG 	With cSetor       																
				MsUnlock()
			   
				cSeq   := StrZero(Val(cSeq)+1,2)
			EndIf
		    
			dbSelectArea("QRM")
			dbSkip()
			
	    EndDo
	    
	    //VERIFICA SE EXISTE MENSAGEM COM ENVIO PENDENTE
	    //##########################################
	    If !empty(cMens)
			cSendTo := Iif (empty(U_GerPlan(substr(cProjAux,2,4))),cSendTo,cSendTo+";"+U_GerPlan(substr(cProjAux,2,4)))
			CONNECT SMTP SERVER cCtaSmpt ACCOUNT cAccount PASSWORD cCtaPass 
			SEND MAIL FROM  cSendBy TO  cSendTo SUBJECT 'Top(RM) Inconsistencias no planejamento (Subcontas Distintas) do projeto: '+cProjAux BODY cHtmlCb+cMens+cHtmlFi 
			DISCONNECT SMTP SERVER
			
		EndIf
		
		If !empty(cMens2)
			cSendTo := Iif (empty(U_GerPlan(substr(cProjAux,2,4))),cSendTo,cSendTo+";"+U_GerPlan(substr(cProjAux,2,4)))
			CONNECT SMTP SERVER cCtaSmpt ACCOUNT cAccount PASSWORD cCtaPass 
			SEND MAIL FROM  cSendBy TO  cSendTo SUBJECT 'Top(RM) Inconsistencias no planejamento (Grupo e conta divergente) do projeto: '+cProjAux BODY cHtmlCc+cMens2+cHtmlFi 
			DISCONNECT SMTP SERVER
			
		EndIf
		//##########################################
	    
	    QRM->(DbCloseArea())
	    
	    RestArea(aArea)
	    
	    U_EXEQUERY(StrZero(Year(dDatabase),4)) //Query de atualizaçao do dados
	    
	    MSGINFO( "Rev. "+MV_PAR02+" foi criada com sucesso! ", "Rotinado de estimado do RM" )
return

User function GerPlan(cProj)

	Local cGerPlan	:= ""
	Local cQuery	:= ""
	
	cQuery := "SELECT TOP 1					
	cQuery += "	    SX5.X5_DESCRI,(SELECT RA_EMAIL FROM DADOSADV.dbo.SRA"+cEmpAnt+"0 WHERE RA_NOMECMP LIKE SX5.X5_DESCRI AND D_E_L_E_T_ = '' AND RA_DEMISSA = '') AS EMAILGER,"
	cQuery += "	    SZ1.Z1_CONTA,SZ2.Z2_LETRA,SZ1.Z1_NREDUZ,SZ1.Z1_NOME,SZ2.Z2_SETOR,SZ2.Z2_GEREN,SZ2.Z2_PROP,"
	cQuery += "	    (SELECT RA_NOME FROM DADOSADV.dbo.SRA"+cEmpAnt+"0 WHERE RA_MAT = SZ2.Z2_PLAN AND D_E_L_E_T_ = '') AS Z2_PLAN,"
	cQuery += "	    (SELECT RA_EMAIL FROM DADOSADV.dbo.SRA"+cEmpAnt+"0 WHERE RA_MAT = SZ2.Z2_PLAN AND D_E_L_E_T_ = '') AS EMAILPLAN,"
	cQuery += "	    Z2_PRAZO  "
	cQuery += "	    FROM DADOSADV.dbo.SZ1"+cEmpAnt+"0 AS SZ1"
	cQuery += "	    INNER JOIN DADOSADV.dbo.SZ2"+cEmpAnt+"0 AS SZ2 ON SZ2.Z2_CONTA = SZ1.Z1_CONTA"
	cQuery += "	    INNER JOIN DADOSADV.dbo.SX5"+cEmpAnt+"0 AS SX5 ON SX5.X5_CHAVE = SZ2.Z2_GEREN AND X5_TABELA = '97'"
	cQuery += "	    INNER JOIN DADOSADV.dbo.SA1"+cEmpAnt+"0 AS SA1 ON SA1.A1_COD   = SZ1.Z1_CODCLI "
	cQuery += "WHERE SZ1.D_E_L_E_T_ = '' AND SZ2.D_E_L_E_T_ = '' AND SX5.D_E_L_E_T_ = '' AND SA1.D_E_L_E_T_ = '' AND SZ1.Z1_CONTA = '"+cProj+"' AND Z2_LETRA NOT IN ('A','B','C','D') ORDER BY Z2_LETRA ASC"	
	
    TcQuery cQuery Alias GQRY New
	dbSelectArea("GQRY")
	dbGotop()
	while !Eof()
	
		if(!empty(GQRY->EMAILGER))
			cGerPlan += GQRY->EMAILGER
		endif
		if(!empty(GQRY->EMAILPLAN))
			if(empty(cGerPlan))
				cGerPlan += GQRY->EMAILPLAN
			else
				cGerPlan += ";"+GQRY->EMAILPLAN
			endif
		endif
		
		dbSelectArea("GQRY")
		dbSkip()
	enddo
	dbSelectArea("GQRY")	
	dbCloseArea()

Return cGerPlan
