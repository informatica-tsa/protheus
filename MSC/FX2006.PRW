#include "rwmake.ch"        // incluido pelo assistente de conversao do AP5 IDE em 25/06/01

User Function FX2006()        // incluido pelo assistente de conversao do AP5 IDE em 25/06/01

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

@ 0,0 TO 180,450 DIALOG oDlg1 TITLE "Gerador do Fluxo Economico - 2006"

@ 04,05 TO 55,220
@ 10,10 SAY "Esta rotina tem o intuito de gerar o arquivo SZ0 (Fluxo Economico) para posterior"
@ 20,10 SAY "utilizacao no SigaEIS(Executive Information System). Esta Rotina podera demandar"
@ 30,10 SAY "alguns minutos e nao e' recomendavel interrompe-la. Clique em <OK> para confirmar"
@ 40,10 SAY "ou <Cancela> para Cancelar."
@ 65,150 BMPBUTTON TYPE 01 ACTION Confirma()// Substituido pelo assistente de conversao do AP5 IDE em 25/06/01 ==> @ 65,150 BMPBUTTON TYPE 01 ACTION Execute(Confirma)
@ 65,178 BMPBUTTON TYPE 02 ACTION Cancela()// Substituido pelo assistente de conversao do AP5 IDE em 25/06/01 ==> @ 65,178 BMPBUTTON TYPE 02 ACTION Execute(Cancela)

ACTIVATE DIALOG oDlg1 CENTER

Return

// Substituido pelo assistente de conversao do AP5 IDE em 25/06/01 ==> Function Confirma
Static Function Confirma()
*****************************************************************************
* Botao de confirmacao
*
***
If !File("\custom_logs\fluxo\CalcFluxo-"+cEmpAnt+".txt")
	//Cria o Arquivo com as informações de Quem esta Executando
	nFile:=FCreate("\custom_logs\fluxo\CalcFluxo-"+cEmpAnt+".txt")
	FWrite(nFile,"Usuário:"+cUserName+Chr(13)+Chr(10))
	FWrite(nFile,"Inicio do Calculo:"+Dtoc(Date())+" - "+Time()+Chr(13)+Chr(10))
	FClose(nFile)
 	ExecBlock("GER2006",.F.,.F.) //Rotina de Geracao
	///ExecBlock("IMPSZB",.F.,.F.) //Rotina de Geracao do Estimado (ESTE PROCESSO ESTA RODANDO SEPARADAMENTE)
	///ExecBlock("IMPSC6",.F.,.F.) //Rotina de Geracao de Pedidos ESTE PROCESSO É GERADO PELA ROTINA DE 2007
	U_EXEQUERY('2005') //Query de atualizaçao do dados
	U_EXEQUERY('2006') //Query de atualizaçao do dados
	/* Executa a Procedure de atualização dos Dados para a Base OFICIAL 2007
	 Exclui os dados na Base 2007 / Atual */
	Empr:= SM0->M0_CODIGO
	TCSPExec(xProcedures("FX2006"),Empr)		
	Close(oDlg1)
	If File("\custom_logs\fluxo\fluxo-"+cEmpAnt+".txt")
  		FErase("\custom_logs\fluxo\fluxo-"+cEmpAnt+".txt")
	Endif
	FWrite(FCreate("\custom_logs\fluxo\fluxo-"+cEmpAnt+".txt"),"Data da Ultima geração do Fluxo:"+Dtoc(Date())+Time())
  	FErase("\custom_logs\fluxo\CalcFluxo-"+cEmpAnt+".txt")
Else
	MsgBox("O Fluxo Gerencial já esta sendo processado por "+Chr(13)+Chr(10)+MemoRead("\custom_logs\fluxo\CalcFluxo-"+cEmpAnt+".txt"))
Endif	
return()


// Substituido pelo assistente de conversao do AP5 IDE em 25/06/01 ==> Function Cancela
Static Function Cancela()
*****************************************************************************
* Botao de cancelamento
*
***

Close(oDlg1)

Return
