/* PROGRAMA DESENVOLVIDO POR: CRISLEI TOLEDO - 03/05/02 -
   ESTE PROGRAMA IRA BUSCAR OS DADOS DO ARQUIVO SZB E ATUALIZAR O SZI, CRIANDO 1 REGISTRO PARA
   CADA CAMPO MES NO SZB.*/
   
#include "rwmake.ch"

User Function AtuSZI()

Processa( {|| RunProc() },"Atualizando Mes Orcamento","Atualizando Registro ..." )

Return

Static Function RunProc()

Local cSZBMes := ""
Local nXA := 0

dbSelectArea("SZB")
dbSetOrder(1)
dbGoTop()
ProcRegua(RecCount())

While !Eof()
	IncProc("Acertando Registro : "+StrZero(Recno(),6))
	dbSelectArea("SZI")
	dbSetOrder(1)
	dbSeek(xFilial("SZI")+SZB->ZB_CCUSTO+SZB->ZB_ANO+SZB->ZB_REVISAO+SZB->ZB_ITEMORC)

	While (! Eof()) 			   .And. ;
   	   (xFilial("SZI")  == SZI->ZI_Filial)  .And. ;
      	(SZI->ZI_CCUSTO  == SZB->ZB_CCUSTO)  .And. ;
      	(SZI->ZI_ANO     == SZB->ZB_ANO)     .And. ;
      	(SZI->ZI_REVISAO == SZB->ZB_REVISAO) .And. ;
      	(SZI->ZI_ITEMORC == SZB->ZB_ITEMORC)

	   If RecLock("SZI",.F.)
   		dbDelete()
   		MsUnLock()
   		dbSkip()
   	EndIf
	End

	//Grava novos registros
	//cria um registro para cada mes do arquivo SZB
   For nXA := 1 To 12
   	cSZBMes := "SZB->ZB_MES" + StrZero(nXA,2)
   	If &cSZBMes <> 0
			If RecLock("SZI",.T.)
				Replace ZI_FILIAL  With xFilial("SZI")
	   		Replace ZI_CCUSTO  With SZB->ZB_CCUSTO
   			Replace ZI_ANO     With SZB->ZB_ANO
   			Replace ZI_GRUPGER With SZB->ZB_GRUPGER
			   Replace ZI_REVISAO With SZB->ZB_REVISAO
			   Replace ZI_ITEMORC With SZB->ZB_ITEMORC
	   		Replace ZI_DESCRI  With SZB->ZB_DESCRI
		  		Replace ZI_DESC2	 With SZB->ZB_DESC2
   			Replace ZI_RENDI	 With SZB->ZB_RENDI
   			Replace ZI_MESANO  With StrZero(nXA,2)+"/"+SZB->ZB_ANO
	   		Replace ZI_VALRMES With &cSZBMes
	   		//FALTA GRAVAR A QTDE DE HORAS (FUNCAO PARA CALCULAR DE ACORDO COM O CALENDARIO
   			//DO CONTRATO - IMPLEMENTACAO FUTURA
				MsUnLock()	
			EndIf
		EndIf
	Next
	
	dbSelectArea("SZB")
	dbSkip()
End

Return