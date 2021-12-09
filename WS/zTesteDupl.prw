//Bibliotecas
#Include "Protheus.ch"
#Include "TopConn.ch"
#include 'fileio.ch

/*

CODIGO PARA DESMENBRAR VAGAS , CODIGO TEMPORARIO.

*/


User Function InsTeste ()

    Local nVaga := ""
    Local nCont := 1
    Local cQS_FILIAL := ''
    Local cQS_CC := ''
    Local cQS_FUNCAO := ''
    Local cQS_AREA := ''
    Local cQS_NRVAGA := ''
    Local cQS_CLIENTE := ''
    Local cQS_SOLICIT := ''
    Local cQS_PRAZO := ''
    Local cQS_DTABERT := ''
    Local cQS_DTFECH := ''
    Local cQS_VAGAFEC := ''
    Local cQS_VCUSTO := ''
    Local cQS_DESCRIC := ''
    Local cQS_PROCESS := ''
    Local cQS_TIPO := ''
    Local cQS_POSTO := ''
    Local cQS_FILPOST := ''
    Local cQS_TESTE := ''
    Local cQS_PONTOS := ''
    Local cQS_AUTOM := ''
    Local cQS_MSGAPV := ''
    Local cQS_MSGREP := ''
    Local cQS_REINSC := ''
    Local cQS_MATRESP := ''
    Local cQS_FILRESP := ''
    Local cQS_CODPERF := ''
    Local cQS_ZSALARI := ''
    Local cQS_ZJUSTIF := ''
    Local cQS_ZLOCAL := ''
    Local cQS_ZVTRANS := ''
    Local cQS_ZTRANTS := ''
    Local cQS_ZVREFEI := ''
    Local cQS_ZALMOC := ''
    Local cQS_ZCOMPUT := ''
    Local cQS_ZWISE := ''
    Local cQS_ZPPRA := ''
    Local cQS_ZTPADMI := ''
    Local cQS_ZPRIOR := ''
    Local cQS_ZTPFUNC := ''
    Local cQS_ZTEMPO := ''
    Local cQS_ZHRTRAB := ''
    Local cQS_ZBENEF := ''
    Local cQS_ZPLSAUD := ''
    Local cQS_ZADIC := ''
    Local cQS_ZSIGILO := ''
    Local cQS_ZMORADI := ''
    Local cQS_ZDIARIA := ''
    Local cQS_ZFOLGA := ''
    Local cQS_ZCODATI := ''
    Local cQS_ZATIVI := ''
    Local cQS_ZFUNCAO := ''



	dbSelectArea("SQS")
    SQS->(dbGoTop())
	While !Eof() 
        if SQS->QS_NRVAGA > 1
            nVaga := SQS->QS_NRVAGA -1 
            cVaga := SQS->QS_VAGA
            nVagaFec := SQS->QS_VAGAFEC

            If RecLock("SQS",.F.)
                Replace  	QS_NRVAGA 	With 1
                if nVagaFec <> 0
                    Replace  	QS_VAGAFEC 	With 1
                    nVagaFec := nVagaFec -1
                Endif

                MsUnlock()
            endif

            dbSelectArea("SQS")
            SQS->(dbSetOrder(1))
            SQS->(dbSeek(xFilial("SQS")+cVaga))

            cQS_FILIAL :=  SQS->QS_FILIAL
            cQS_CC :=  SQS->QS_CC
            cQS_FUNCAO :=  SQS->QS_FUNCAO
            cQS_AREA :=  SQS->QS_AREA
            cQS_NRVAGA :=  SQS->QS_NRVAGA
            cQS_CLIENTE :=  SQS->QS_CLIENTE
            cQS_SOLICIT :=  SQS->QS_SOLICIT
            cQS_PRAZO :=  SQS->QS_PRAZO
            cQS_DTABERT :=  SQS->QS_DTABERT
            cQS_DTFECH :=  SQS->QS_DTFECH
            cQS_VAGAFEC :=  SQS->QS_VAGAFEC
            cQS_VCUSTO :=  SQS->QS_VCUSTO
            cQS_DESCRIC :=  SQS->QS_DESCRIC
            cQS_PROCESS :=  SQS->QS_PROCESS
            cQS_TIPO :=  SQS->QS_TIPO
            cQS_POSTO :=  SQS->QS_POSTO
            cQS_FILPOST :=  SQS->QS_FILPOST
            cQS_TESTE :=  SQS->QS_TESTE
            cQS_PONTOS :=  SQS->QS_PONTOS
            cQS_AUTOM :=  SQS->QS_AUTOM
            cQS_MSGAPV :=  SQS->QS_MSGAPV
            cQS_MSGREP :=  SQS->QS_MSGREP
            cQS_REINSC :=  SQS->QS_REINSC
            cQS_MATRESP :=  SQS->QS_MATRESP
            cQS_FILRESP :=  SQS->QS_FILRESP
            cQS_CODPERF :=  MSMM(SQS->QS_CODPERF,80,,,,,,"SQS",,"RDY")
            cQS_ZSALARI :=  SQS->QS_ZSALARI
            cQS_ZJUSTIF :=  SQS->QS_ZJUSTIF
            cQS_ZLOCAL :=  SQS->QS_ZLOCAL
            cQS_ZVTRANS :=  SQS->QS_ZVTRANS
            cQS_ZTRANTS :=  SQS->QS_ZTRANTS
            cQS_ZVREFEI :=  SQS->QS_ZVREFEI
            cQS_ZALMOC :=  SQS->QS_ZALMOC
            cQS_ZCOMPUT :=  SQS->QS_ZCOMPUT
            cQS_ZWISE :=  SQS->QS_ZWISE
            cQS_ZPPRA :=  SQS->QS_ZPPRA
            cQS_ZTPADMI :=  SQS->QS_ZTPADMI
            cQS_ZPRIOR :=  SQS->QS_ZPRIOR
            cQS_ZTPFUNC :=  SQS->QS_ZTPFUNC
            cQS_ZTEMPO :=  SQS->QS_ZTEMPO
            cQS_ZHRTRAB :=  SQS->QS_ZHRTRAB
            cQS_ZBENEF :=  SQS->QS_ZBENEF
            cQS_ZPLSAUD :=  SQS->QS_ZPLSAUD
            cQS_ZADIC :=  SQS->QS_ZADIC
            cQS_ZSIGILO :=  SQS->QS_ZSIGILO
            cQS_ZMORADI :=  SQS->QS_ZMORADI
            cQS_ZDIARIA :=  SQS->QS_ZDIARIA
            cQS_ZFOLGA :=  SQS->QS_ZFOLGA
            cQS_ZCODATI :=  SQS->QS_ZCODATI
            cQS_ZATIVI :=  SQS->QS_ZATIVI
            cQS_ZFUNCAO :=  SQS->QS_ZFUNCAO

            GravaLog("Log-Teste-Conv_vaga-"+cEmpAnt+".log","Vaga: "+cVaga )
            FOR nCont := 1 TO nVaga STEP 1
                nCodVaga := GETSXENUM("SQS","QS_VAGA")
                GravaLog("Log-Teste-Conv_vaga-"+cEmpAnt+".log","Gerou ===> "+nCodVaga )
                If RecLock("SQS",.T.)
                Replace  	QS_FILIAL  With  cQS_FILIAL,;
                            QS_VAGA  With  nCodVaga,;
                            QS_CC  With  cQS_CC,;
                            QS_FUNCAO  With  cQS_FUNCAO,;
                            QS_AREA  With  cQS_AREA,;
                            QS_NRVAGA  With  cQS_NRVAGA,;
                            QS_CLIENTE  With  cQS_CLIENTE,;
                            QS_SOLICIT  With  cQS_SOLICIT,;
                            QS_PRAZO  With  cQS_PRAZO,;
                            QS_DTABERT  With  cQS_DTABERT
                            

                            if nVagaFec <> 0
                                Replace QS_VAGAFEC  With  1
                                Replace QS_DTFECH  With  cQS_DTFECH
                                nVagaFec := nVagaFec -1
                            else 
                                Replace QS_VAGAFEC  With  0
                                Replace QS_DTFECH  With  CTOD(SPACE(8))
                            Endif

                Replace     QS_VCUSTO  With  cQS_VCUSTO,;
                            QS_DESCRIC  With  cQS_DESCRIC,;
                            QS_PROCESS  With  cQS_PROCESS,;
                            QS_TIPO  With  cQS_TIPO,;
                            QS_POSTO  With  cQS_POSTO,;
                            QS_FILPOST  With  cQS_FILPOST,;
                            QS_TESTE  With  cQS_TESTE,;
                            QS_PONTOS  With  cQS_PONTOS,;
                            QS_AUTOM  With  cQS_AUTOM,;
                            QS_MSGAPV  With  cQS_MSGAPV,;
                            QS_MSGREP  With  cQS_MSGREP,;
                            QS_REINSC  With  cQS_REINSC,;
                            QS_MATRESP  With  cQS_MATRESP,;
                            QS_FILRESP  With  cQS_FILRESP,;
                            QS_CODPERF  With  cQS_CODPERF,;
                            QS_ZSALARI  With  cQS_ZSALARI,;
                            QS_ZJUSTIF  With  cQS_ZJUSTIF,;
                            QS_ZLOCAL  With  cQS_ZLOCAL,;
                            QS_ZVTRANS  With  cQS_ZVTRANS,;
                            QS_ZTRANTS  With  cQS_ZTRANTS,;
                            QS_ZVREFEI  With  cQS_ZVREFEI,;
                            QS_ZALMOC  With  cQS_ZALMOC,;
                            QS_ZCOMPUT  With  cQS_ZCOMPUT,;
                            QS_ZWISE  With  cQS_ZWISE,;
                            QS_ZPPRA  With  cQS_ZPPRA,;
                            QS_ZTPADMI  With  cQS_ZTPADMI,;
                            QS_ZPRIOR  With  cQS_ZPRIOR,;
                            QS_ZTPFUNC  With  cQS_ZTPFUNC,;
                            QS_ZTEMPO  With  cQS_ZTEMPO,;
                            QS_ZHRTRAB  With  cQS_ZHRTRAB,;
                            QS_ZBENEF  With  cQS_ZBENEF,;
                            QS_ZPLSAUD  With  cQS_ZPLSAUD,;
                            QS_ZADIC  With  cQS_ZADIC,;
                            QS_ZSIGILO  With  cQS_ZSIGILO,;
                            QS_ZMORADI  With  cQS_ZMORADI,;
                            QS_ZDIARIA  With  cQS_ZDIARIA,;
                            QS_ZFOLGA  With  cQS_ZFOLGA,;
                            QS_ZCODATI  With  cQS_ZCODATI,;
                            QS_ZATIVI  With  cQS_ZATIVI,;
                            QS_ZFUNCAO  With  cQS_ZFUNCAO


                    ConfirmSx8()
                    MsUnlock() 

                    MSMM(,LEN(cQS_CODPERF),,cQS_CODPERF,1,,,"SQS","QS_CODPERF")
            
                else
                    RollbackSx8()
                endif
            
            NEXT nCont
            SQS->(dbGoTop()) 
        endif
        SQS->(DbSkip())
    EndDo
			  

    DbCloseArea()

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
		FWrite(nHandle, cMsg+Chr(13)+Chr(10))
		fclose(nHandle) 
	Endif
	
 
return
