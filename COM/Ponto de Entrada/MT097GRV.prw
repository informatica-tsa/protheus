#Include 'RwMake.ch'
/*
+-----------------------------------------------------------------------+
¦Programa  ¦           ¦ Autor ¦ Gilson Lucas          ¦Data ¦19.08.2011¦
+----------+------------------------------------------------------------¦
¦Descricao ¦Flag o PC para bloqueio apos alteracao                      ¦
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
User function MT120GRV
  
Local  nXi      := 0           
Local  nYi      := 0
Local  cNumPed  := Paramixb[1]
//Local  lInclui  := Paramixb[2] 
Local  lAltera  := Paramixb[3] 
//Local  lDeleta  := Paramixb[4]
Local  aAreaOld := Getarea()
Local  aCpoVal  := {"C7_COND","C7_FILENT","C7_DATPRF","C7_DINICOM","C7_DINITRA","C7_DINICQ","C7_CONTATO","C7_OBS","C7_MESENTR","C7_DETCD","C7_DETPZ","C7_DETGR","C7_DETPR","C7_DETIN","C7_DETOU","C7_DETLC","C7_DETCF","C7_DETFT","C7_DETDC","C7_DISCIPL","C7_GERENCI"}
Local  aAreaSC7 := SC7->(GetArea())
Local  lRet		:= .T.
Local  _cMens01	:= OemToAnsi("Essa alteração vai resultar no retorno dos níveis de aprovação!")+Chr(13)+Chr(10)
Public aItenDiv := {}
Public aSC7Old  := {}
// QUANDO ALTERA "C7_DATPRF", AUTOMATICAMENTE ALTERA TAMBÉM "C7_DINICOM","C7_DINITRA","C7_DINICQ"

If lAltera        
	//REALIZA BACKPUP DAS INFORMAÇÕES DE ALCADA PARA RESTAURAR EM WFW120P.PRW CASO OS CAMPOS ALTERADOS NÃO VOLTE APROVAÇÃO.
	aSC7Old  := {}
	dbSelectArea("SC7")	
	SC7->(dbSetOrder(1))
	SC7->(dbSeek(xFilial("SC7")+cNumPed))
	While !SC7->(Eof()) .and. xFilial("SC7")== SC7->C7_FILIAL .And.  cNumPed== SC7->C7_NUM
		Aadd(aSC7Old,{SC7->(Recno()),SC7->C7_CONAPRO,SC7->C7_APROV})	
		SC7->(dbSkip())
	End
	
	//VERIFICA OS CAMPOS QUE FORAM ALTERADO E COMPARA COM OS CAMPOS LIBERADOS PARA ALTERAÇÃO
	For nXi := 1 To Len(aCols)
		If GdDeleted(nXi)	
			Aadd(aItenDiv,{0,""})
			_cMens01 += "Linha deletada"+Chr(13)+Chr(10)
		Else
			SC7->(dbSeek(xFilial("SC7")+cNumPed+GdFieldGet("C7_ITEM",nXi)))
			If SC7->(Eof())                   
				Aadd(aItenDiv,{0,""})
				_cMens01 += OemToAnsi("Item não localizado.")+Chr(13)+Chr(10)
			Else     
				For nYi := 1 To len(aHeader)
					If aHeader[nYi][10] # "V" 
						If aScan(aCpoVal,Alltrim(aHeader[nYi][2])) == 0
							If GdFieldGet(aHeader[nYi][2],nXi) # SC7->&(aHeader[nYi][2])
					    		Aadd(aItenDiv,{SC7->(Recno()),SC7->C7_CONAPRO})	
								_cMens01 += "Campo alterado:"+aHeader[nYi][2]+" Atual: "+cvaltochar(GdFieldGet(aHeader[nYi][2],nXi))+" Anterior: "+cvaltochar(SC7->&(aHeader[nYi][2]))+Chr(13)+Chr(10)
					    	EndIf
					    EndIf
				    EndIf
				Next nYi 
			EndIf			
		EndIf
	Next nXi 
Else
	aMantLib := {}
EndIf 

if 	!Empty(aItenDiv)
	_cMens01 += OemToAnsi("(Sim) para Continuar e (Não) para Cancelar as alterações !")
	lRet := MsgYesNo(_cMens01,"Retorno de aprovação")
EndIf

RestArea(aAreaOld)
RestArea(aAreaSC7) 
Return lRet


/*
+-----------------------------------------------------------------------+
¦Programa  ¦           ¦ Autor ¦ Gilson Lucas          ¦Data ¦19.08.2011¦
+----------+------------------------------------------------------------¦
¦Descricao ¦Indica se a rotina deve passar pela alçada                  ¦
+----------+------------------------------------------------------------¦
¦ Uso      ¦ ESPECIFICO PARA A TSA                                      ¦
+-----------------------------------------------------------------------¦
¦           ATUALIZACOES SOFRIDAS DESDE A CONSTRUCAO INICIAL            ¦
+-----------------------------------------------------------------------¦
¦PROGRAMADOR ¦ DATA   ¦ MOTIVO DA lSaidaCAO                             ¦
+------------+--------+-------------------------------------------------¦
¦            ¦        ¦                                                 ¦
+-----------------------------------------------------------------------+
*/
User Function MT097GRV
/*
+-----------------------------------------------------------------------+
Retorno :

lRet = .T. continua o processo da MaAlcDoc e grava a tabela SCR.

lRet = .F. Interrompe o processo e não grava a tabela SCR. Quando .F.
		   o sistema limpa o grupo de aprovador do pedido, por isso foi
		   necessário adicionar o campo C7_APROV ao array de restauração
		   aSC7Old da SC7.
+-----------------------------------------------------------------------+
*/
Local lRet    := .T.
//Local cQuery  := ""

If Funname() $ 'MATA121|ENCPEDC' 
	If Altera .and. Empty(aItenDiv)
		lRet := .F.
	EndIf
EndIf

Return(lRet)
