#Include 'Protheus.ch'
#Include 'FWMVCDef.ch'
#include 'fileio.ch
#include "rwmake.ch" 

//-------------------------------------------------------------------------------
/*/{Protheus.doc} FSCOMP01
Grava informacoes complementares na cotacao
        
@author 	Leandro de Faria
@since 		11/09/2017

@version 	P12.1.006
@Project	Migracao V12
/*/ 
//-------------------------------------------------------------------------------
User Function FSCOMP01()

Local aAreas   := {SC8->(GetArea()),GetArea(),SC1->(GetArea())}
Local cNumCot  := SC8->C8_NUM
Local cNumFil  := SC8->C8_FILIAL
Local cMsg := ""
SC1->(dbSetOrder(1))
SC8->(dbSetOrder(4))
SC8->(dbSeek(xFilial("SC8")+cNumCot))

	Do While SC8->( !Eof() .AND. SC8->C8_FILIAL = cNumFil .AND. SC8->C8_NUM = cNumCot  )
		If SC1->(dbSeek(xFilial("SC1")+SC8->C8_NUMSC+SC8->C8_ITEMSC))
		    SC8->(RecLock("SC8",.F.))
		        SC8->C8_XCO     :=  SC1->C1_XCO
		        SC8->C8_XCLASSE :=  SC1->C1_XCLASSE     
		        SC8->C8_XOPER   :=  SC1->C1_XOPER
		        SC8->C8_XORCAME :=  SC1->C1_XORCAME
		        SC8->C8_XPCO    :=  SC1->C1_XPCO 
		        SC8->C8_XPCO1   :=  SC1->C1_XPCO1
		        SC8->C8_CONTA   :=  SC1->C1_CONTA
		        SC8->C8_ITEMCTA :=  SC1->C1_ITEMCTA
		        SC8->C8_CC  	   :=  SC1->C1_CC
		    SC8->(MsUnlock())
		    GravaLog("log-cust-cotacao-"+cEmpAnt+".log","A SOLICITACAO: "+SC8->C8_NUMSC+" E A COTACAO: "+cNumCot+" ITEM: "+SC1->C1_ITEM+" PRODUTO: "+SC1->C1_PRODUTO+" Gravado com sucesso!")
		Else
			cMsg := "EXISTE DIVERGENCIA ENTRE A SOLICITACAO: "+SC8->C8_NUMSC+" E A COTACAO: "+cNumCot+". GENTILEZA PROCURAR A CI ANTES DE SEGUIR COM O PROCESSO. ITEM: "+SC8->C8_ITEMSC+" PRODUTO: "+SC8->C8_PRODUTO
			MSGALERT(cMsg)
			GravaLog("log-cust-cotacao-"+cEmpAnt+".log",cMsg)
		EndIf
		SC8->(dbSkip())
	End Do
	 

AEval(aAreas, {|x| RestArea(x)})

Return Nil

Static Function GravaLog(cArq,cMsg )
 	
	If !File(cArq)
		nHandle := FCreate(cArq)
	else
		nHandle := fopen(cArq , FO_READWRITE + FO_SHARED )
	Endif

	If nHandle == -1
		MsgStop('Erro de abertura : FERROR '+str(ferror(),4))
	Else
		FSeek(nHandle, 0, FS_END)         // Posiciona no fim do arquivo
		FWrite(nHandle, Dtoc(Date())+" - "+Time()+" : "+cUserName+" : "+cMsg+Chr(13)+Chr(10)) // Insere texto no arquivo
		fclose(nHandle)                   // Fecha arquivo
	Endif
	
 
return