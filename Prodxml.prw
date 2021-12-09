#INCLUDE "TOTVS.CH"
#INCLUDE "XMLXFUN.CH"

User Function getObjXML()	

	Private cPerg := "IMPPRD"
	Private aPerg := {}
	AADD(aPerg,{cPerg,"Qtd de xml?"						,"C",03,0,"G","!Empty(MV_PAR01)","","","","","",""})
	Pergunte(cPerg,.T.)
	
	//Processa({|| ImportXml()}, "Aguarde. Executando rotina...")
	BatchProcess("Importação","Impotação de XML",cPerg,{|| Processa({||ImportXml()},"Aguarde","Processando...")})

Return()
 
Static Function ImportXml()
Local cError   := ""
Local cWarning := ""
Local cXmlFile := "produtos.xml"
Local oXml   := NIL
Local nAtual := ""
Local nCont  := ""
Local nCont1 := ""
Local nQtd  := MV_PAR01


	
    
    ProcRegua(nQtd)
    
	For nCont1 := 1 To nQtd
		
		IncProc("Importando XML: produtos"+cValToChar(nCont1)+".xml","Aguarde...")
		
		cXmlFile := "produtos"+cValToChar(nCont1)+".xml"
		//Gera o Objeto XML
		oXml := XmlParserFile( cXmlFile, "_", @cError, @cWarning )
		If (oXml == NIL )
		  MsgStop("Falha ao gerar Objeto XML : "+cError+" / "+cWarning)
		  Return
		Endif
		 
		 
		//Se tiver erros, mostra ao usuário
	    If !Empty(cError)
	        Aviso('Atenção', "Erros: "+cError, {'Ok'}, 03)
	    else
	    	//Se tiver avisos, mostra ao usuário
		    If !Empty(cWarning)
		        Aviso('Atenção', "Avisos: "+cWarning, {'Ok'}, 03)
		    Else
		    	// Mostrando a informação do Node
				oProds := oXml:_PRODUTOS:_PRODUTO
				
				For nAtual := 1 To Len(oProds)
				
					//##################################################
					//#################CRIAR PRODUTOS###################
					//##################################################
				    //cMsg += "ID: "+oProds[nAtual]:_B1_COD:Text
				    //cMsg += Chr(13)+Chr(10)
				    
				    For nCont := 1 To 3 
						dbSelectArea("SB1")
						RecLock("SB1",.T.)
	
							DO CASE
						        CASE nCont = 1
								    Replace B1_GRUPO	With 'DEQ'
									Replace B1_COD  	With 'DEQ'+SUBSTR(oProds[nAtual]:_B1_COD:Text,4)
									Replace B1_TIPO		With 'ME'
									Replace B1_LOCPAD	With '01'
									Replace B1_CONTA	With '1151020004'
									Replace B1_CTACEI	With ''
									Replace B1_CTACONS	With '4121010004'
						         CASE nCont = 2
						            Replace B1_GRUPO	With 'IMP'
									Replace B1_COD  	With 'IMP'+SUBSTR(oProds[nAtual]:_B1_COD:Text,4)
									Replace B1_TIPO		With 'MP'
									Replace B1_LOCPAD	With '04'
									Replace B1_CONTA	With '1181030001'
									Replace B1_CTACEI	With ''
									Replace B1_CTACONS	With '4121010007'
						         OTHERWISE
						           	Replace B1_GRUPO	With 'AAO'
									Replace B1_COD  	With 'AAO'+SUBSTR(oProds[nAtual]:_B1_COD:Text,4)
									Replace B1_TIPO		With 'A'
									Replace B1_LOCPAD	With '03'
									Replace B1_CONTA	With '1151020006'
									Replace B1_CTACEI	With '4163010006'
									Replace B1_CTACONS	With '4113020006'
							ENDCASE
							
							Replace B1_DESC 	With oProds[nAtual]:_B1_DESC:Text
							Replace B1_DESCDET 	With oProds[nAtual]:_B1_DESC:Text
							Replace B1_UM   	With oProds[nAtual]:_B1_UM:Text
							Replace B1_FILIAL	With oProds[nAtual]:_B1_FILIAL:Text
							Replace B1_ALIQISS	With Val(oProds[nAtual]:_B1_ALIQISS:Text)
							Replace B1_PICM		With Val(oProds[nAtual]:_B1_PICM:Text)
							Replace B1_POSIPI	With oProds[nAtual]:_B1_POSIPI:Text
							Replace B1_IPI		With Val(oProds[nAtual]:_B1_IPI:Text)
							Replace B1_PICMRET	With Val(oProds[nAtual]:_B1_PICMRET:Text)
							Replace B1_PICMENT	With Val(oProds[nAtual]:_B1_PICMENT:Text)
							Replace B1_CONV		With Val(oProds[nAtual]:_B1_CONV:Text)
							Replace B1_TIPCONV	With oProds[nAtual]:_B1_TIPCONV:Text
							Replace B1_QE		With Val(oProds[nAtual]:_B1_QE:Text)
							Replace B1_PRV1		With Val(oProds[nAtual]:_B1_PRV1:Text)
							Replace B1_EMIN		With Val(oProds[nAtual]:_B1_EMIN:Text)
							Replace B1_CUSTD	With Val(oProds[nAtual]:_B1_CUSTD:Text)
							Replace B1_UPRC		With Val(oProds[nAtual]:_B1_UPRC:Text)
							Replace B1_PESO		With Val(oProds[nAtual]:_B1_PESO:Text)
							Replace B1_ESTSEG	With Val(oProds[nAtual]:_B1_ESTSEG:Text)
							Replace B1_PE		With Val(oProds[nAtual]:_B1_PE:Text)
							Replace B1_LE		With Val(oProds[nAtual]:_B1_LE:Text)
							Replace B1_LM		With Val(oProds[nAtual]:_B1_LM:Text)
							Replace B1_CTADESP	With oProds[nAtual]:_B1_CTADESP:Text
							Replace B1_TOLER	With Val(oProds[nAtual]:_B1_TOLER:Text)
							Replace B1_QB		With Val(oProds[nAtual]:_B1_QB:Text)
							Replace B1_APROPRI	With oProds[nAtual]:_B1_APROPRI:Text
							Replace B1_FANTASM	With oProds[nAtual]:_B1_FANTASM:Text
							Replace B1_DATREF	With Date() //CtoD(oProds[nAtual]:_B1_DATREF:Text)
							Replace B1_TIPODEC	With oProds[nAtual]:_B1_TIPODEC:Text
							Replace B1_UREV		With Date() //CtoD(oProds[nAtual]:_B1_UREV:Text)
							Replace B1_ORIGEM	With oProds[nAtual]:_B1_ORIGEM:Text
							Replace B1_CLASFIS	With oProds[nAtual]:_B1_CLASFIS:Text
							Replace B1_RASTRO	With oProds[nAtual]:_B1_RASTRO:Text
							Replace B1_COMIS	With Val(oProds[nAtual]:_B1_COMIS:Text)
							Replace B1_MRP		With oProds[nAtual]:_B1_MRP:Text
							Replace B1_PERINV	With Val(oProds[nAtual]:_B1_PERINV:Text)
							Replace B1_NOTAMIN	With Val(oProds[nAtual]:_B1_NOTAMIN:Text)
							Replace B1_PRVALID	With Val(oProds[nAtual]:_B1_PRVALID:Text)
							Replace B1_CONTRAT	With oProds[nAtual]:_B1_CONTRAT:Text
							Replace B1_NUMCOP	With Val(oProds[nAtual]:_B1_NUMCOP:Text)
							Replace B1_LOCALIZ	With oProds[nAtual]:_B1_LOCALIZ:Text
							Replace B1_ANUENTE	With oProds[nAtual]:_B1_ANUENTE:Text
							Replace B1_VLREFUS	With Val(oProds[nAtual]:_B1_VLREFUS:Text)
							Replace B1_IMPORT	With oProds[nAtual]:_B1_IMPORT:Text
							Replace B1_OPAUTOM	With oProds[nAtual]:_B1_OPAUTOM:Text
							Replace B1_TIPOCQ	With oProds[nAtual]:_B1_TIPOCQ:Text
							Replace B1_SOLICIT	With oProds[nAtual]:_B1_SOLICIT:Text
							Replace B1_NUMCQPR	With Val(oProds[nAtual]:_B1_NUMCQPR:Text)
							Replace B1_CONTCQP	With Val(oProds[nAtual]:_B1_CONTCQP:Text)
							Replace B1_INSS		With oProds[nAtual]:_B1_INSS:Text
							Replace B1_CLASSVE	With oProds[nAtual]:_B1_CLASSVE:Text
							Replace B1_ENVOBR	With oProds[nAtual]:_B1_ENVOBR:Text
							Replace B1_FLAGSUG	With oProds[nAtual]:_B1_FLAGSUG:Text
							Replace B1_MCUSTD	With oProds[nAtual]:_B1_MCUSTD:Text
							Replace B1_MIDIA	With oProds[nAtual]:_B1_MIDIA:Text
							Replace B1_MTBF		With Val(oProds[nAtual]:_B1_MTBF:Text)
							Replace B1_MTTR		With Val(oProds[nAtual]:_B1_MTTR:Text)
							Replace B1_PCOFINS	With Val(oProds[nAtual]:_B1_PCOFINS:Text)
							Replace B1_PCSLL	With Val(oProds[nAtual]:_B1_PCSLL:Text)
							Replace B1_PPIS		With Val(oProds[nAtual]:_B1_PPIS:Text)
							Replace B1_QTMIDIA	With Val(oProds[nAtual]:_B1_QTMIDIA:Text)
							Replace B1_REDINSS	With Val(oProds[nAtual]:_B1_REDINSS:Text)
							Replace B1_REDIRRF	With Val(oProds[nAtual]:_B1_REDIRRF:Text)
							Replace B1_VLR_IPI	With Val(oProds[nAtual]:_B1_VLR_IPI:Text)
							Replace B1_FAIXAS	With Val(oProds[nAtual]:_B1_FAIXAS:Text)
							Replace B1_NROPAG	With Val(oProds[nAtual]:_B1_NROPAG:Text)
							Replace B1_ATIVO	With oProds[nAtual]:_B1_ATIVO:Text
							Replace B1_PESBRU	With Val(oProds[nAtual]:_B1_PESBRU:Text)
							Replace B1_VLR_ICM	With Val(oProds[nAtual]:_B1_VLR_ICM:Text)
							Replace B1_VLRSELO	With Val(oProds[nAtual]:_B1_VLRSELO:Text)
							Replace B1_CPOTENC	With oProds[nAtual]:_B1_CPOTENC:Text
							Replace B1_POTENCI	With Val(oProds[nAtual]:_B1_POTENCI:Text)
							Replace B1_QTDACUM	With Val(oProds[nAtual]:_B1_QTDACUM:Text)
							Replace B1_QTDINIC	With Val(oProds[nAtual]:_B1_QTDINIC:Text)
							Replace B1_MSBLQL	With "2"
							Replace B1_REDPIS	With Val(oProds[nAtual]:_B1_REDPIS:Text)
							Replace B1_LOTVEN	With Val(oProds[nAtual]:_B1_LOTVEN:Text)
							Replace B1_REDCOF	With Val(oProds[nAtual]:_B1_REDCOF:Text)
							Replace B1_EMAX		With Val(oProds[nAtual]:_B1_EMAX:Text)
							Replace B1_PIS		With oProds[nAtual]:_B1_PIS:Text
							Replace B1_UMOEC	With Val(oProds[nAtual]:_B1_UMOEC:Text)
							Replace B1_UVLRC	With Val(oProds[nAtual]:_B1_UVLRC:Text)
							Replace B1_COFINS	With oProds[nAtual]:_B1_COFINS:Text
							Replace B1_CSLL		With oProds[nAtual]:_B1_CSLL:Text
							Replace B1_CNAE		With oProds[nAtual]:_B1_CNAE:Text
							Replace B1_AGREGCU	With oProds[nAtual]:_B1_AGREGCU:Text
							Replace B1_USAFEFO	With oProds[nAtual]:_B1_USAFEFO:Text
							Replace B1_CRDEST	With Val(oProds[nAtual]:_B1_CRDEST:Text)
							Replace B1_FRACPER	With Val(oProds[nAtual]:_B1_FRACPER:Text)
							Replace B1_INT_ICM	With Val(oProds[nAtual]:_B1_INT_ICM:Text)
							Replace B1_RETOPER	With oProds[nAtual]:_B1_RETOPER:Text
							Replace B1_PAUTFET	With Val(oProds[nAtual]:_B1_PAUTFET:Text)
							Replace B1_PRFDSUL	With Val(oProds[nAtual]:_B1_PRFDSUL:Text)
							Replace B1_FECP		With Val(oProds[nAtual]:_B1_FECP:Text)
							Replace B1_BASTSC	With oProds[nAtual]:_B1_BASTSC:Text
							Replace B1_VLR_PIS	With Val(oProds[nAtual]:_B1_VLR_PIS:Text)
							Replace B1_VLR_COF	With Val(oProds[nAtual]:_B1_VLR_COF:Text)
							Replace B1_ESCRIPI	With oProds[nAtual]:_B1_ESCRIPI:Text
							Replace B1_DESPIMP	With oProds[nAtual]:_B1_DESPIMP:Text
							Replace B1_PMACNUT	With Val(oProds[nAtual]:_B1_PMACNUT:Text)
							Replace B1_PMICNUT	With Val(oProds[nAtual]:_B1_PMICNUT:Text)
							Replace B1_QBP		With Val(oProds[nAtual]:_B1_QBP:Text)
							Replace B1_FETHAB	With oProds[nAtual]:_B1_FETHAB:Text
							Replace B1_ALFECOP	With Val(oProds[nAtual]:_B1_ALFECOP:Text)
							Replace B1_ALFECST	With Val(oProds[nAtual]:_B1_ALFECST:Text)
							Replace B1_CRDPRES	With Val(oProds[nAtual]:_B1_CRDPRES:Text)
							Replace B1_CFEMA	With Val(oProds[nAtual]:_B1_CFEMA:Text)
							Replace B1_ALFUMAC	With Val(oProds[nAtual]:_B1_ALFUMAC:Text)
							Replace B1_AFETHAB	With Val(oProds[nAtual]:_B1_AFETHAB:Text)
							Replace B1_AFACS	With Val(oProds[nAtual]:_B1_AFACS:Text)
							Replace B1_AFABOV	With Val(oProds[nAtual]:_B1_AFABOV:Text)
							Replace B1_RICM65	With oProds[nAtual]:_B1_RICM65:Text
							Replace B1_PR43080	With Val(oProds[nAtual]:_B1_PR43080:Text)
							Replace B1_FECPBA	With Val(oProds[nAtual]:_B1_FECPBA:Text)
							Replace B1_DCRII	With Val(oProds[nAtual]:_B1_DCRII:Text)
							Replace B1_COEFDCR	With Val(oProds[nAtual]:_B1_COEFDCR:Text)
							Replace B1_PRINCMG	With Val(oProds[nAtual]:_B1_PRINCMG:Text)
							Replace B1_ALFECRN	With Val(oProds[nAtual]:_B1_ALFECRN:Text)
							Replace B1_LOTESBP	With Val(oProds[nAtual]:_B1_LOTESBP:Text)
							Replace B1_VLCIF	With Val(oProds[nAtual]:_B1_VLCIF:Text)
							Replace B1_AFAMAD	With Val(oProds[nAtual]:_B1_AFAMAD:Text)
							Replace B1_MARKUP	With Val(oProds[nAtual]:_B1_MARKUP:Text)
							Replace B1_GARANT	With oProds[nAtual]:_B1_GARANT:Text
							Replace B1_PERGART	With Val(oProds[nAtual]:_B1_PERGART:Text)
							Replace B1_AFUNDES	With Val(oProds[nAtual]:_B1_AFUNDES:Text)
							Replace B1_AIMAMT	With Val(oProds[nAtual]:_B1_AIMAMT:Text)
							Replace B1_AFASEMT	With Val(oProds[nAtual]:_B1_AFASEMT:Text)
							//Replace B1_MOPC		With oProds[nAtual]:_B1_MOPC:Text
							Replace B1_IMPNCM	With Val(oProds[nAtual]:_B1_IMPNCM:Text)
							Replace B1_QTDSER	With oProds[nAtual]:_B1_QTDSER:Text
		
						MsUnlock()
						//cMsg += "ID: "+cValToChar(nCont)
						//cMsg += Chr(13)+Chr(10)
				    Next
				    
				    //##################################################
					//#################CRIAR PRODUTOS###################
					//##################################################
					
				Next
				//Aviso('Atenção', cMsg, {'Ok'}, 03)
				
		    EndIf
	    
	    EndIf
    
    Next
    
Return ""