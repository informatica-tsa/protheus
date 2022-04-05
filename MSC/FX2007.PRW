#include "rwmake.ch"        // incluido pelo assistente de conversao do AP5 IDE em 25/06/01
#include "TopConn.ch"
#include 'fileio.ch

	/*
	ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
	±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
	±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
	±±³Programa  ³ GERFLUXO ³ Autor ³Eduardo Carraro        ³ Data ³ 01/09/00 ³±±
	±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
	±±³Descri‡ao ³ Rotina para Geracao dos arquivos para o fluxo economico    ³±±
	±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
	±±³Uso       ³ Especifico para EPC/TSA                                    ³±±
	±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
	±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
	ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
	*/

User Function FX2007()        // incluido pelo assistente de conversao do AP5 IDE em 25/06/01
	
	@ 0,0 TO 180,450 DIALOG oDlg1 TITLE "Gerador do Fluxo Economico"	
	@ 04,05 TO 55,220
	@ 10,10 SAY "Esta rotina tem o intuito de gerar o arquivo SZ0 (Fluxo Economico) para posterior"
	@ 20,10 SAY "utilizacao no SigaEIS(Executive Information System). Esta Rotina podera demandar"
	@ 30,10 SAY "alguns minutos e nao e' recomendavel interrompe-la. Clique em <OK> para confirmar"
	@ 40,10 SAY "ou <Cancela> para Cancelar.Este programa trata apenas todas as filiais."
	@ 65,150 BMPBUTTON TYPE 01 ACTION Confirma()
	@ 65,178 BMPBUTTON TYPE 02 ACTION Cancela()
	
	ACTIVATE DIALOG oDlg1 CENTER

Return


Static Function Confirma()
	Local Ano := YEAR(DATE())+1
	Local sAnoAt := cValToChar(YEAR(DATE()))
	Local nHist := 10
	Local nCnt := 0
	
	If cEmpAnt # '02' .and. cEmpAnt # '03' .and. cEmpAnt # '04'
		MsgBox("O Fluxo Gerencial so pode ser processado na Empresa 02 ou 03 ou 04")
	Else
		If !File("CalcFluxo-"+cEmpAnt+".txt")              
		
			MsgBox("O Fluxo Gerencial "+sAnoAt+" vai ser processado  ...")
	
			/*Cria o Arquivo com as informações de Quem esta Executando*/
			
			nFile:=FCreate("CalcFluxo-"+cEmpAnt+".txt")
			FWrite(nFile,"Usuário:"+cUserName+Chr(13)+Chr(10))
			FWrite(nFile,"Inicio do Calculo:"+Dtoc(Date())+" - "+Time()+Chr(13)+Chr(10))
			FClose(nFile) 
			If File("log-fluxo-"+cEmpAnt+".log")//Arquivo de log do fluxo.
		  		FErase("log-fluxo-"+cEmpAnt+".log")
			Endif

			GravaLog("log-fluxo-"+cEmpAnt+".log","Iniciado com sucesso!")
			
			//LIMPA TABELA ANTES DE REALIZAR O PROCESSAMENTO
			cQuery  := " DELETE FROM "+RetSqlName("SZ0")
			TCSQLExec(cQuery)      
			       
			ExecBlock("GER2007",.F.,.F.)    //Rotina que gera oFluxo Economico Baseado nos lançamentos contábeis
			ExecBlock("GER102013",.F.,.F.)  //Rotina que gera oFluxo Economico Baseado nos lançamentos contábeis | Para gerar com novos grupos(CT1_GRUPO2) a partir de 01/10/2013 - Ricardo NM
			ExecBlock("IMPSC6",.F.,.F.)     //Rotina de Geracao de Pedidos de Venda
			ExecBlock("GRVEICULOS",.F.,.F.) //Rotina de geração de Locação interna de veiculos
			
			For nCnt := 0 To nHist Step 1
				U_EXEQUERY(cValToChar(Ano))//Rotina de atualização de dados
				Ano--
			Next
			   
	 		if ExistBlock("GerBcHora")
					U_GerBcHora() 		   //Rotina para levar banco de horas
			endif
			
			Close(oDlg1)
			If File("Fluxo-"+cEmpAnt+".txt")
		  		FErase("Fluxo-"+cEmpAnt+".txt")
			Endif
			FWrite(FCreate("Fluxo-"+cEmpAnt+".txt"),"Usuário: "+cUserName+Chr(13)+Chr(10)+" Data da Ultima geração do Fluxo:"+Dtoc(Date())+" - "+Time())
		  	FErase("CalcFluxo-"+cEmpAnt+".txt")
			GravaLog("log-fluxo-"+cEmpAnt+".log","Finalizado com sucesso!")
			MsgBox("O Fluxo Gerencial "+sAnoAt+" processado com sucesso.")
		Else
			MsgBox("O Fluxo Gerencial já esta sendo processado por "+Chr(13)+Chr(10)+MemoRead("CalcFluxo"+cEmpAnt+".txt"))
		Endif	
	EndIf

RETURN



Static Function Cancela()

	Close(oDlg1)

Return

Static Function GravaLog(cArq,cMsg )
 	
	If !File(cArq)
		nHandle := FCreate(cArq)
	else
		nHandle := fopen(cArq , FO_READWRITE + FO_SHARED )
	Endif

	If nHandle == -1
		MsgStop('Erro de abertura : FERROR '+str(ferror(),4))
	Else
		FSeek(nHandle, 0, FS_END) 
		FWrite(nHandle, Dtoc(Date())+" - "+Time()+" : "+cUserName+" : "+cMsg+Chr(13)+Chr(10))
		fclose(nHandle) 
	Endif
	
 
return
