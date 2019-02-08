#Include "RwMake.ch"
#Include "Colors.ch"
#INCLUDE "topconn.ch"
/*
+-----------------------------------------------------------------------+
¦Programa  ¦GPECOD     ¦ Autor ¦ Thiago Santos         ¦Data ¦03.02.2019¦
+----------+------------------------------------------------------------¦
¦Descricao ¦Retorna matricula de acordo com tipo de funcionario		  ¦
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

User Function CodGpe(cTipo)
	Local aAreaTrb := GetArea()
	Local nIncre := 1
	Local cPrimeira := ""
	
	
	If     cTipo == '1' 
		cQuery:="SELECT TOP 1 RA_MAT FROM "+RetSqlName("SRA")+" WHERE D_E_L_E_T_ = '' AND RA_MAT LIKE '00%' ORDER BY RA_MAT DESC" //FUNCIONARIO
		cPrimeira := "000001"
	ElseIf cTipo == '2' 
		cQuery:="SELECT TOP 1 RA_MAT FROM "+RetSqlName("SRA")+" WHERE D_E_L_E_T_ = '' AND RA_MAT LIKE '30%' ORDER BY RA_MAT DESC" //PJ
		cPrimeira := "300001"
	ElseIf cTipo == '3'
		cQuery:="SELECT TOP 1 RA_MAT FROM "+RetSqlName("SRA")+" WHERE D_E_L_E_T_ = '' AND RA_MAT LIKE '01%' ORDER BY RA_MAT DESC" //ESTAGIARIO
		cPrimeira := "015001"
	Else	
		cQuery:="SELECT TOP 1 RA_MAT FROM "+RetSqlName("SRA")+" WHERE D_E_L_E_T_ = '' AND RA_MAT LIKE '99%' ORDER BY RA_MAT ASC" //DIRETORIA
		cPrimeira := "999999"
		nIncre := -1
	EndIf
	
	cMatricula:= ""
	
	TCQUERY cQuery ALIAS "MAT" New
	dbSelectArea("MAT")
	
	if !Eof()
		//Transformar o conteudo de alfa para numerico e somar 1
		nMatricula := val(MAT->RA_MAT)+nIncre
		//Retornar o contador para alfa, com zeros a esquerda
		cMatricula:=StrZero(nMatricula,6)
	Else
		cMatricula := cPrimeira
	EndIf
	
	dbSelectArea("MAT")
	dbCloseArea()
	
	RestArea(aAreaTrb)
	
Return(cMatricula)