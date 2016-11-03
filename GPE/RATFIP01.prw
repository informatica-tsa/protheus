#INCLUDE "PROTHEUS.CH"
#include "topconn.ch"  
#include "Ap5mail.ch"  
                                                                          
/* 
 * @Descrição
 *			   	Permite realizar o rateio das horas na tabela FIPEPC de acordo com as 
 *				verbas cadastradas
 *			   	Depende da consulta SZ2_CO que retorna o número do contrato formatado 
 *				no formato 
 *			   	A0000-00-0000A       
 * 				Realiza a pesquisa nas tabelas de Movimentos menstasi (SRC) ou Resci-
 *				são (SRR) de acordom com o parametro '_cAlias' Passado
 * @Alterado por: Leandro P J Monteiro 		leandro@cntecnologia.com.br		
 * @Alterações	17/07/2013 Alterado o fonte para permitir a inserção de novos registros 
 *				no FIPEPC 
 * @Alterações  31/07/2013 Alterado para considerar horas fracionadas
 * @Alteraçoõe  21/10/2013 Renomeado para RATFIP01.prw para trabalho no sentido de uni-
 *				ficar os fontes que agora fará o rateio de horas  nos lançamentos  men-
 *				sais e também na rescisão.
 * @Alterações  03/11/2016 Alterado local de verificação de verbas para rateio. ThiagoSantos 
 ****************************************************************************************/
User Function RATFIP01(_cAlias)              
	Private cAlias := _cAlias
	Private cTitForm     := "Rateio de Horas " 
	Private oDl002
	Private oDlMont
	Private oFont1   := TFont():New("Arial Black",,024,,.T.,,,,,.F.,.F.)
	Private cVebHExt := GetVerbRat() // PEGA AS VERBAS DA TABELA SRV COM RV_TIPORAT = 2 OU 3
	Private cFolMes  := SuperGetMv ( "MV_FOLMES" , .T. , Space(100))
	Private dUltimoDiaMes := LastDay(ctod('01/'+Substr(cFolMes, 5, 2) + '/' + Substr(cFolMes, 1, 4)))
	Private aSubHora := {}
	Private lLancErro := .F.                 
	Private cMatric := SRA->RA_MAT      
	Private aAreaAlias := GetArea(cAlias)

	Private aVerbas := BuscarVerbas(cAlias) // VERIFICA SE A MATRICULA POSSUIR VERBAR PARA RATEIO 
	Private aItens  := BuscarHoras(cFolMes)
	
	if len(aVerbas) == 0
		MSGINFO("Não existem verbas cadastradas para rateio") 
		Return
	endif
	
	// EXIBE FORMULARIO PRINCIPAL
	Mostra()
	
	RestArea(aAreaAlias)
Return

static Function GetVerbRat()
	Local cVerbas := ""
	Local nCont := 0
	Local cQuery := " SELECT RV_COD FROM SRV010 WHERE RV_TIPORAT = 2 OR RV_TIPORAT = 3 " 
  	if select("Q1") <> 0
		Q1->(dbCloseArea())
	endif 
  	TCQUERY cQuery NEW ALIAS "Q1"
  	                                         
	WHILE !(Q1->(EOF()))
		if nCont > 0
			cVerbas += ";"+alltrim(Q1->RV_COD)
		else
			cVerbas += alltrim(Q1->RV_COD)
		endif
		
		nCont++
		
		Q1->(dbSkip())
	Enddo
	
	if select("Q1") <> 0
		Q1->(dbCloseArea())
	endif 
Return cVerbas

Static Function Mostra()
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Construção da tela -                                                ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ				
	DEFINE MSDIALOG oDl002 TITLE cTitForm FROM 200,300 TO 700,1200 PIXEL
	
		@ 008,010 Say cTitForm Size 200,020 FONT oFont1 COLOR CLR_BLACK PIXEL OF oDl002
		DEFINE SBUTTON FROM 008,389 TYPE 1 ENABLE OF oDl002 ACTION( Sair(.T.) )
		DEFINE SBUTTON FROM 008,419 TYPE 2 ENABLE OF oDl002 ACTION( Sair(.F.) )
		@ 042, 281 BUTTON oBtnMais  PROMPT "+"      SIZE 009, 009 OF oDl002  PIXEL ACTION( Eval({ || Aadd(aItens,{space(14), strzero(Day(dUltimoDiaMes),2) + "/" + strzero(Month(dUltimoDiaMes), 2) + "/" + strzero(Year(dUltimoDiaMes),4),"0:00","0:00",00.00,space(3),space(6),{}}), fMontNovasHoras() }))
		@ 052, 281 BUTTON oBtnMenos PROMPT "-"      SIZE 009, 009 OF oDl002  PIXEL ACTION( Eval({ || IIF(Empty(aItens[oItens:nAt,7]), aItens[oItens:nAt] := Nil , ), fMontNovasHoras() }))

		@ 020, 000 SAY REPLICATE("_",200) SIZE 500, 010 OF oDl002 COLORS CLR_BLACK PIXEL
						
		@ 040,010 ListBox oItens Fields HEADER "FIPCUSTO","FIPDATA","INICIO","FIM","HORAS","Lancamento";
		          Size 270,200 Of oDl002 Pixel On DBLCLICK ( EditaItens() )
			
		@ 040,300 ListBox oVerbas Fields HEADER "Verba","Lancado","Total";
		          Size 140,200 Of oDl002 Pixel //On DBLCLICK ( Edita() )
		
		fSubSetArray(aItens, oItens)
		
		oVerbas:SetArray(aVerbas)
		oVerbas:bLine 		:= {|| {;
			aVerbas[oVerbas:nAT,01],;
			aVerbas[oVerbas:nAT,02],;
			aVerbas[oVerbas:nAT,03]}} 

		Valores()
				
	ACTIVATE MSDIALOG oDl002 CENTERED 
Return

Static Function BuscarVerbas(cAlias)
	aVerbas := {}           
	
	dbSelectArea(cAlias) 
	(cAlias)->(dbSetOrder(1))
	(cAlias)->(dbGoTop())
	
	if (cAlias == "SRC")
		(cAlias)->(dbSeek(xFilial(cAlias)+cMatric))	   // RC_FILIAL + RC_MAT + RC_PD
	else // SRR
		(cAlias)->(dbSeek(xFilial(cAlias)+AllTrim(cMatric)+"R"))	   // RC_FILIAL + RC_MAT + RC_TIPO3 (Rescisão = 'R')
	endif
			
	c_Filial := Alltrim(Alltrim(subStr(cAlias, 2, 2)) + "_FILIAL")
	c_Mat	 := Alltrim(Alltrim(subStr(cAlias, 2, 2)) + "_MAT"	 )
	c_PD	 := Alltrim(Alltrim(subStr(cAlias, 2, 2)) + "_PD"	 )    
	c_Horas	 := Alltrim(Alltrim(subStr(cAlias, 2, 2)) + "_HORAS" )       
	
	WHILE !((cAlias)->(EOF())) .AND. (cAlias)->(&c_Filial) == xFilial(cAlias) .AND. (cAlias)->(&c_Mat) == cMatric	
	
		if alltrim((cAlias)->(&c_PD)) $ alltrim(cVebHExt)
			AADD(aVerbas,{(cAlias)->(&c_PD),0,(cAlias)->(&c_Horas)})
		endif
		(cAlias)->(dbSkip())
		
	Enddo    
Return aVerbas

Static Function BuscarHoras(cFolMes)
	aItens := {}
	
	if select("Q1") <> 0
		Q1->(dbCloseArea())
	endif 
		                                               
	cQuery := " SELECT FIPCODIGO,FIPCUSTO,FIPEXTRAS,FIPPD, " 
	cQuery += " Convert(VARCHAR(10),FIPDATA,103) AS FIPDATA, "
	cQuery += " replace(CAST(FIPHORAI AS VarChar(5)) ,'.',':') AS INICIO, "
	cQuery += " replace(CAST(FIPHORAF AS VarChar(5)) ,'.',':') AS FIM, "
//	cQuery += " Cast((FIPHORAF - FIPHORAI) as int) AS HORAS" 
	cQuery += " Cast(FIPHORAS as numeric(8,2)) AS HORAS" 
//	cQuery += " DATEDIFF (hour, "
//	cQuery += " Cast(replace(CAST(FIPHORAI AS VarChar(5)) ,'.',':') as SmallDateTime), "
//	cQuery += " Cast(replace(CAST(FIPHORAF AS VarChar(5)) ,'.',':') as SmallDateTime)) AS HORAS "
	cQuery += " FROM FIPEPC "
	cQuery += " WHERE FIPANOMES = '"+alltrim(cFolMes)+"' "
	cQuery += "   AND CHAPA     = '"+alltrim(cMatric)+"' "
	cQuery += "   AND FIPEXTRAS = 'S' " // SIMONE, COMENTAR ESTA LINHA PARA EXIBIR TODAS AS HORAS
	cQuery += "   AND FIPEMPRESA = '"+SM0->M0_CODIGO+"'"
	cQuery += " ORDER BY 5,6 "
  
  	TCQUERY cQuery NEW ALIAS "Q1"
  	
	aItens := {}
		                                         
	WHILE !(Q1->(EOF()))
		AADD(aItens,{Q1->FIPCUSTO,alltrim(Q1->FIPDATA),alltrim(Q1->INICIO),alltrim(Q1->FIM),Q1->HORAS,Q1->FIPPD,Q1->FIPCODIGO,{}})
		Q1->(dbSkip())
	Enddo
	
	if select("Q1") <> 0
		Q1->(dbCloseArea())
	endif 
		
	if len(aItens) == 0
		Aadd(aItens,{"","","","","","","",{}})
	endif
Return aItens

Static Function EditaItens()   

    if ( oItens:ColPos == 1 .or. oItens:ColPos == 2 .or. oItens:ColPos == 5 .or. oItens:ColPos == 6 )       	                                                                                                
                
        if (oItens:ColPos == 6)
	        if !("*" $ aItens[oItens:nAT,06])
	        	if (Empty(aItens[oItens:nAT,07]))
	        		// para inserção de novos itens não aceita quebra de horas, neste caso o próprio usuário realiza 2 lançamentos
	        		lEditCell( aItens, oItens, "999", oItens:ColPos , "SRV" )
	        		
					if ("*" $ aItens[oItens:nAT,06])
						aItens[oItens:nAT,06] := "   "
						oItens:Refresh()
	        		endif
	        	else
					lEditCell( aItens, oItens, "@!", oItens:ColPos , "SRV" )
				endif
			endif
			
			if ("*" $ aItens[oItens:nAT,06])
				fRaHora()
			endif
		else                       
			if (!Empty(aItens[oItens:nAt,03]) .and. aItens[oItens:nAt,03] == "0:00")
			
				do case 
					case oItens:ColPos == 5
						lEditCell( aItens, oItens, "99.99", oItens:ColPos , "" )     
					case oItens:ColPos == 2
						lEditCell( aItens, oItens, "@D", oItens:ColPos , "" )
					case oItens:ColPos == 1
						lEditCell( aItens, oItens, "@!", oItens:ColPos , "SZ2_CO" )     
					Otherwise
						lEditCell( aItens, oItens, "@!", oItens:ColPos , "" )
				end Case
			endif
			
			// Caso a edição tenha sido das horas
			if (oItens:ColPos == 5 .and. aItens[oItens:nAt,03] == "0:00")              
				cTotHoras := str(aItens[oItens:nAt, 05])    
				
				//alert(cTotHoras)
				
				aHor := StrTokArr(cTotHoras, ".")				
				
				if (Len(aHor) == 1)
					cMin := '00'
				else     
					cMin := strZero(Round( ( val(allTrim(aHor[2])) / (10 ^ Len(aHor[2]))) * 60 , 0), 2) // calculo para gerar os minutos									
				endif 
				                          
				cHor := strZero(val(allTrim(aHor[1])), 2)
				
				if (val(cHor) >= 24)                        
				                                
					if (ApMsgNoYes ( 'Não é possível realizar um lançamento superior ou igual a 24h. '+ chr(13) +'Deseja dividir o excedente de 23 horas em vários dias? ', 'Rateio de Horas'))
						nHor := val(cHor)            
						while (nHor >= 23)
							aAdd(aItens, {					;
									aItens[oItens:nAt, 01], ;
									aItens[oItens:nAt, 02], ;
									'0:00', '23:00', 23,    ;
									aItens[oItens:nAt, 06],	;
									space(6),{}	;
									})
						
							nHor -= 23                 
							aItens[oItens:nAt, 05] -= 23
						enddo                     
						
						fSubSetArray(aItens, oItens)
						cHor := strzero(nHor, 2)    
					else 
						cHor := '23' 
						aItens[oItens:nAt, 05] := 23
					endif
				endif
				
				aItens[oItens:nAt, 04] := cHor + ":" + cMin
				oItens:Refresh()
			endif
        endif
    endif
           
	Valores()
Return


Static Function fRaHora()
                 
	Local bOkV := .F.

	aSubHora := {}
	
	for nT := 1 to len(aItens[oItens:nAT][8])
		if !empty(aItens[oItens:nAT][8][nT][1])
			aadd(aSubHora,aItens[oItens:nAT][8][nT])
		endif
	next 
	
	if len(aSubHora) == 0
		Aadd(aSubHora,{Space(5),Space(5),0,Space(3)})
	endif
	
	aItens[oItens:nAT][8] := {}
	aItens[oItens:nAT][6] := Space(3)

	DEFINE MSDIALOG oDlMont TITLE cTitForm FROM 200,300 TO 700,700 PIXEL
	
		@ 008,010 Say "Sub Dividir Hora" Size 200,020 FONT oFont1 COLOR CLR_BLACK PIXEL OF oDlMont
		@ 020,000 Say replicate("_",500) Size 500,008 COLOR CLR_RED PIXEL OF oDlMont
		
		@ 040,010 Say "Projeto" Size 021,008 COLOR CLR_BLACK PIXEL OF oDlMont
		@ 040,075 MsGet oMsGet1 Var aItens[oItens:nAT,01] Size 060,009 COLOR CLR_BLACK when(.F.) Picture "@!" PIXEL OF oDlMont

		@ 060,010 Say "Data" Size 021,008 COLOR CLR_BLACK PIXEL OF oDlMont
		@ 060,075 MsGet oMsGet2 Var aItens[oItens:nAT,02] Size 060,009 COLOR CLR_BLACK when(.F.) Picture "@D 99/99/99" PIXEL OF oDlMont

		@ 080,010 Say "Inicio" Size 021,008 COLOR CLR_BLACK PIXEL OF oDlMont
		@ 080,075 MsGet oMsGet3 Var aItens[oItens:nAT,03] Size 060,009 COLOR CLR_BLACK when(.F.) Picture "@!" PIXEL OF oDlMont

		@ 100,010 Say "Fim" Size 021,008 COLOR CLR_BLACK PIXEL OF oDlMont
		@ 100,075 MsGet oMsGet4 Var aItens[oItens:nAT,04] Size 060,009 COLOR CLR_BLACK when(.F.) Picture "@!" PIXEL OF oDlMont

		@ 120,010 Say "Horas" Size 021,008 COLOR CLR_BLACK PIXEL OF oDlMont
		@ 120,075 MsGet oMsGet5 Var aItens[oItens:nAT,05] Size 060,009 COLOR CLR_BLACK when(.F.) Picture "@!" PIXEL OF oDlMont
		
		@ 140,010 ListBox oSubHora Fields HEADER "Inicio","Fim","Hora","Verba" Size 160,080 Of oDlMont Pixel On DBLCLICK ( fEDSubHoras() )
		
		@ 140, 180 BUTTON oButton1 PROMPT "+"      SIZE 009, 009 OF oDlMont PIXEL ACTION( Eval({|| Aadd(aSubHora,{Space(5),Space(5),0,Space(3)}) , fMontSubHoras() }) )
		@ 160, 180 BUTTON oButton1 PROMPT "-"      SIZE 009, 009 OF oDlMont PIXEL ACTION( Eval({|| aSubHora[oSubHora:nAT,01] := Nil , fMontSubHoras() }) )
			
		@ 220,00 Say replicate("_",500) Size 500,008 COLOR CLR_BLACK PIXEL OF oDlMont		
		DEFINE SBUTTON FROM 233,140 TYPE 1 ENABLE OF oDlMont ACTION( Eval({|| bOkV :=.T. , oDlMont:end() }) )
		DEFINE SBUTTON FROM 233,170 TYPE 2 ENABLE OF oDlMont ACTION( Eval({|| bOkV :=.F. , oDlMont:end() }) )
		
		fMontSubHoras()
			
	ACTIVATE MSDIALOG oDlMont CENTERED 
                     
	if bOkV
		nHot21 := 0

		for nI := 1 to len(aSubHora)
			if val(aSubHora[nI][1]) < val(aItens[oItens:nAT,03])
				MSGSTOP("A horas informadas estão erradas! (001)")
				return
			endif
			if val(aSubHora[nI][1]) > val(aItens[oItens:nAT,04])
				MSGSTOP("A horas informadas estão erradas! (001)")
				return
			endif
			if val(aSubHora[nI][2]) > val(aItens[oItens:nAT,04])
				MSGSTOP("A horas informadas estão erradas! (003)")
				return
			endif
			if val(aSubHora[nI][2]) < val(aItens[oItens:nAT,03])
				MSGSTOP("A horas informadas estão erradas! (004)")
				return
			endif
			if !empty(aSubHora[nI][1]) .and. !empty(aSubHora[nI][2]) .and. !empty(aSubHora[nI][3])
				nHot21 += aSubHora[nI][3]
			endif
		next
		
		IF nHot21 != aItens[oItens:nAT,05]
			MSGSTOP("A horas informadas estão erradas! (005)")
			return
		ENDIF
		aItens[oItens:nAT][8] := {}
		aItens[oItens:nAT][6] := "***"
		
		for nT := 1 to len(aSubHora)
			if !empty(aSubHora[nT][1]) .and. !empty(aSubHora[nT][2]) .and. !empty(aSubHora[nT][3])
				aadd(aItens[oItens:nAT][8],aSubHora[nT])
			endif
		next
	endif
	
Return
 
// Monta novas horas para inserção na tela de Rateio
Static function fMontNovasHoras()
	// validando aItens vazio
	if (aItens[1] != nil .and. Empty(aItens[1][3]))
		aItens[1] := nil                        
	endif

	aTempIt  := {}
	aTempIt  := aItens
	aItens   := {}                                  
	
	for nI := 1 to len(aTempIt)
		if aTempIt[nI] != nil
			aadd(aItens,aTempIt[nI])
		endif
	next

	if len(aItens) == 0
		Aadd(aItens,{space(14),strzero(Day(dUltimoDiaMes),2) + "/" + strzero(Month(dUltimoDiaMes), 2) + "/" + strzero(Year(dUltimoDiaMes),4),"0:00","0:00", 0,space(3),space(6),{}})
	endif
	                        
	fSubSetArray(aItens, oItens)
/*	oItens:SetArray(aItens)
	oItens:bLine 		:= {|| {;
		aItens[oItens:nAT,01],;
		aItens[oItens:nAT,02],;
		aItens[oItens:nAT,03],;
		aItens[oItens:nAT,04],;
		aItens[oItens:nAT,05],;
		aItens[oItens:nAT,06]}} 
	
	oItens:Refresh()*/
Return                

Static Function fSubSetArray(_aItens, _oItens)
	_oItens:SetArray(_aItens)
	_oItens:bLine 		:= {|| {;
		_aItens[_oItens:nAT,01],;
		_aItens[_oItens:nAT,02],;
		_aItens[_oItens:nAT,03],;
		_aItens[_oItens:nAT,04],;
		_aItens[_oItens:nAT,05],;
		_aItens[_oItens:nAT,06]}} 
	
	_oItens:Refresh()
Return

Static Function fMontSubHoras()

	aTemp21  := {}
	aTemp21  := aSubHora
	aSubHora := {}
	
	for nI := 1 to len(aTemp21)
		if aTemp21[nI][1] != nil
			aadd(aSubHora,aTemp21[nI])
		endif
	next

	if len(aSubHora) == 0
		Aadd(aSubHora,{Space(5),Space(5),0,Space(3)})
	endif
	
	oSubHora:SetArray(aSubHora)
	oSubHora:bLine 		:= {|| {;
		aSubHora[oSubHora:nAT,01],;
		aSubHora[oSubHora:nAT,02],;
		aSubHora[oSubHora:nAT,03],;
		aSubHora[oSubHora:nAT,04]}} 
		
	oSubHora:Refresh()
	
Return

Static Function fEDSubHoras()

	if  oSubHora:ColPos == 1 .or. oSubHora:ColPos == 2
		lEditCell( aSubHora, oSubHora, "@E 99:99", oSubHora:ColPos )
	endif
	
	if  oSubHora:ColPos == 4
		lEditCell( aSubHora, oSubHora, "@!", oSubHora:ColPos , "SRV" )
	endif
	
	for nI := 1 to len(aSubHora)
		aSubHora[nI,03] := 0
		if !empty(aSubHora[nI,01]) .and. !empty(aSubHora[nI,02])
			aSubHora[nI,03] := val(ELAPTIME(aSubHora[nI,01]+":00",aSubHora[nI,02]+":00"))
		endif
	next

Return


Static Function Valores()
               
	lLancErro := .F.

	for nI := 1 to len(aVerbas)
		aVerbas[nI,2] := 0
	next

	for nI := 1 to len(aItens)
		if empty(aItens[nI][6])
			Loop
		endif                                        
				
		if "*" $ aItens[nI][6]
			for nT := 1 to len(aItens[nI][8])
				if !empty(aItens[nI][8][nT][4])
					nPos := Ascan(aVerbas,{|aAux| aAux[1] == aItens[nI][8][nT][4] })
					If nPos > 0
						aVerbas[nPos,2] := aVerbas[nPos,2] + aItens[nI][8][nT][3]
					else				
						MSGSTOP("Algum lancamento esta errado, a verba lancada não é de hora extra!")
						lLancErro := .T.
					Endif				
				endif
			next
		else
			nPos := Ascan(aVerbas,{|aAux| aAux[1] == aItens[nI][6] })
			If nPos > 0
				aVerbas[nPos,2] := aVerbas[nPos,2] + aItens[nI][5]
			else				
				MSGSTOP("Algum lancamento esta errado, a verba lancada não é de hora extra!")
				lLancErro := .T.
			Endif		
		endif
	next

	oVerbas:Refresh()	
	
	for nI := 1 to len(aVerbas)
		if aVerbas[nI,2] > aVerbas[nI,3]
			MSGSTOP("O valor vinculado é maior que o valor das horas!")
			lLancErro := .T.
			Return
		Endif
	next	

Return

Static Function Sair(lRet)

	if lRet                                   
	
		for nI := 1 to len(aItens)
			// Checando linhas vazias
			if (empty(aItens[nI][1]))
				MSGSTOP("Você deve informar o número do projeto para todas as horas lançadas")
				Return
			endif
			
			// Validando o número da SubConta do projeto
			if (Len(aItens[ni][1]) >= 14) 
				cSubCta := Substr(aItens[ni][1], 10)
				
				DbSelectArea("SZ2")
				SZ2->(DbSetOrder(3))
				SZ2->(DbGoTop())
				SZ2->(DbSeek("  "+cSubCta))
				
				if (SZ2->(Eof()))
					MSGSTOP("O número da subconta deve ser um número válido")
					Return
				endif
			else 
				MSGSTOP("Deve ser informado o número do projeto e da SubConta.")
				Return
			endif	
			
			// Verificando a Data
			if (empty(aItens[nI][2]) .or. Len(aItens[nI][2]) < 10)             
				MSGSTOP("Você deve informar a data do lançamento no formato 'dd/MM/yyyy'.")
				Return                            
			else
				dAux := cTod(aItens[nI][2])
				
				//if !(val(SubStr(cFolMes,5,2)) == Month(dAux) .and. val(SubStr(cFolMes,1,4)) == Year(dAux))
				//	MSGSTOP("O mês e o ano devem ser o de lançamento da folha. ")
				//	Return                            
				//endif            
			endif                
			
			// Verificando as horas iniciais e finais
			if (empty(aItens[nI][3]) .or. empty(aItens[nI][4]))
				MSGSTOP("As horas iniciail e final devem ser informadas.")
				Return                            
			endif
		next
	
		if lLancErro
			MSGSTOP("O valor vinculado é diferente que o valor das horas!")
			Return
		endif                                 
		for nI := 1 to len(aVerbas)
			if aVerbas[nI,2] != aVerbas[nI,3]
				MSGSTOP("O valor vinculado é diferente que o valor das horas!")
				lLancErro := .T.
				Return
			Endif
		next	
		TcSQLExec("UPDATE FIPEPC SET FIPEMPRESA = '"+SM0->M0_CODIGO+"', FIPEXTRAS = 'N', FIPPD = '' WHERE FIPANOMES = '"+alltrim(cFolMes)+"' AND CHAPA = '"+alltrim(cMatric)+"';")
		
		for nI := 1 to len(aItens)         			
			if !empty(aItens[nI][6])       
			
			// Conversao da data para utilização abaixo
			dAux := cTod(aItens[nI][2])                
			cDataAtual := strzero(Day(dAux), 2) + "/" + Strzero(Month(dAux), 2) + "/" + Strzero(Year(dAux), 4)

			                                                 
				if empty(aItens[nI][7])
					// Inserção de novo registro
					cInsert := "INSERT INTO FIPEPC "
					cInsert += "           ([CHAPA]"
					cInsert += "           ,[FIPCUSTO]"
					cInsert += "           ,[FIPDATA]"
//					cInsert += "           ,[FIPCRONOGRAMA]"
//					cInsert += "           ,[FIPATIVIDADES]"
//					cInsert += "           ,[FIPDOCUMENTOS]"
					cInsert += "           ,[FIPHORAI]"
					cInsert += "           ,[FIPHORAF]"
					cInsert += "           ,[FIPHORAS]"
//					cInsert += "           ,[FIPHRNORMAL]"
//					cInsert += "           ,[FIPMINNORMAL]"
//					cInsert += "           ,[FIPHREXTRA]"
//					cInsert += "           ,[FIPHRCOMP]"
//					cInsert += "           ,[FIPHRBANCO]"
					cInsert += "           ,[FIPANOMES]"
//					cInsert += "           ,[FIPESCOPO]"
//					cInsert += "           ,[FIPFATURAVEL]"
					cInsert += "           ,[FIPEXTRAS]"
//					cInsert += "           ,[FIPSITUACAO]"
//					cInsert += "           ,[FIPGERADO]"
//					cInsert += "           ,[FIPREVISAO]"
					cInsert += "           ,[FIPANOMESDATA]"
//					cInsert += "           ,[SETORFIPIMPORTADAS]"
//					cInsert += "           ,[FIPEMPRESA]"
//					cInsert += "           ,[FIPFILIAL]"
//					cInsert += "           ,[FIPORIGEM]"
					cInsert += "           ,[FIPPD]"
					cInsert += "           ,[FIPEMPRESA])"
					cInsert += "    VALUES"
					cInsert += "          ('"+cMatric+"'"//, varchar(6),>"
					cInsert += "           ,'"+aItens[nI][1]+"'"//, varchar(14),>"
					cInsert += "           ,Convert( datetime, '" + cDataAtual + "' , 103)"//, datetime,>     "
//					cInsert += "           ,'"+QTEMPFIP->FIPCRONOGRAMA+"'"//, varchar(21),>"
//					cInsert += "           ,'"+QTEMPFIP->FIPATIVIDADES+"'"//, varchar(10),>"
//					cInsert += "           ,'"+QTEMPFIP->FIPDOCUMENTOS+"'"//, varchar(19),>"
					cInsert += "           ,replace( CAST('"+aItens[nI][3]+"' AS VarChar(5)) ,':','.')"//, numeric(8,2),>"
					cInsert += "           ,replace( CAST('"+aItens[nI][4]+"' AS VarChar(5)) ,':','.')"//, numeric(8,2),>"
					cInsert += "           ,replace( '"+CVALTOCHAR(aItens[nI][5])+"', ',' , '.')"//, numeric(8,2),>"
//					cInsert += "           ,"+CVALTOCHAR(QTEMPFIP->FIPHRNORMAL)+""//, numeric(8,2),>"
//					cInsert += "           ,"+CVALTOCHAR(QTEMPFIP->FIPMINNORMAL)+""//, numeric(18,0),>"
//					cInsert += "           ,"+CVALTOCHAR(QTEMPFIP->FIPHREXTRA)+""//, numeric(8,2),>"
//					cInsert += "           ,"+CVALTOCHAR(QTEMPFIP->FIPHRCOMP)+""//, numeric(8,2),>"
//					cInsert += "           ,"+CVALTOCHAR(QTEMPFIP->FIPHRBANCO)+""//, numeric(8,2),>"
					cInsert += "           ,'"+cFolMes+"'"//, varchar(6),>"
//					cInsert += "           ,'"+QTEMPFIP->FIPESCOPO+"'"//, varchar(1),>"
//					cInsert += "           ,'"+QTEMPFIP->FIPFATURAVEL+"'"//, varchar(1),>"
					cInsert += "           ,'S'"//, varchar(1),>"
//					cInsert += "           ,'"+QTEMPFIP->FIPSITUACAO+"'"//, varchar(2),>"
//					cInsert += "           ,'"+QTEMPFIP->FIPGERADO+"'"//, varchar(1),>"
//					cInsert += "           ,"+CVALTOCHAR(QTEMPFIP->FIPREVISAO)+""//, int,>"
					cInsert += "           ,'"+cFolMes+"'"//, varchar(6),>"
//					cInsert += "           ,'"+QTEMPFIP->SETORFIPIMPORTADAS+"'"//, char(10),>"
//					cInsert += "           ,'"+QTEMPFIP->FIPEMPRESA+"'"//, varchar(2),>"
//					cInsert += "           ,'"+QTEMPFIP->FIPFILIAL+"'"//, varchar(2),>"
//					cInsert += "           ,'"+QTEMPFIP->FIPORIGEM+"'"//, varchar(10),>"
					cInsert += "           ,'"+cvaltochar(aItens[nI][6])+"'
					cInsert += "           ,'"+SM0->M0_CODIGO+"')"//, varchar(3),>)"


					
					TcSQLExec(cInsert)
				else			
					if empty(aItens[nI][8])
						// Atualização do registro
						cUpdate := "UPDATE FIPEPC SET "
						cUpdate += "           [FIPCUSTO] = '"+aItens[nI][1]+"'" //, varchar(14),>"
						cUpdate += "           ,[FIPDATA] = Convert( datetime, '"+cDataAtual+"' , 103)"//, datetime,>     "
						cUpdate += "           ,[FIPHORAF] = replace( CAST('"+aItens[nI][4]+"' AS VarChar(5)) ,':','.')"//, numeric(8,2),>"
						cUpdate += "           ,[FIPHORAS] = replace( '"+CVALTOCHAR(aItens[nI][5])+"', ',' , '.')"//, numeric(8,2),>"
						cUpdate += "           ,[FIPEXTRAS] = 'S'"//, varchar(3),>)"
						cUpdate += "           ,[FIPPD] = '"+cvaltochar(aItens[nI][6])+"'"//, varchar(3),>)"
						cUpdate += "           ,[FIPEMPRESA] = '"+SM0->M0_CODIGO+"'"						
						cUpdate += "     WHERE FIPCODIGO = '"+cvaltochar(aItens[nI][7])+"';
	
						TcSQLExec(cUpdate)
					else 
						if select("QTEMPFIP") <> 0
							QTEMPFIP->(dbCloseArea())
						endif 
							
						cQuery := " SELECT * ,
						cQuery += " Convert(VARCHAR(10),FIPDATA,112) AS FIPDATA2 FROM FIPEPC "
						cQuery += " WHERE FIPCODIGO = '"+cvaltochar(aItens[nI][7])+"' "
					  
					  	TCQUERY cQuery NEW ALIAS "QTEMPFIP"
					  	
						for ngt := 1 to len(aItens[nI][8])
							cInsert := "INSERT INTO FIPEPC "
							cInsert += "           ([CHAPA]"
							cInsert += "           ,[FIPCUSTO]"
							cInsert += "           ,[FIPDATA]"
							cInsert += "           ,[FIPCRONOGRAMA]"
							cInsert += "           ,[FIPATIVIDADES]"
							cInsert += "           ,[FIPDOCUMENTOS]"
							cInsert += "           ,[FIPHORAI]"
							cInsert += "           ,[FIPHORAF]"
							cInsert += "           ,[FIPHORAS]"
							cInsert += "           ,[FIPHRNORMAL]"
							cInsert += "           ,[FIPMINNORMAL]"
							cInsert += "           ,[FIPHREXTRA]"
							cInsert += "           ,[FIPHRCOMP]"
							cInsert += "           ,[FIPHRBANCO]"
							cInsert += "           ,[FIPANOMES]"
							cInsert += "           ,[FIPESCOPO]"
							cInsert += "           ,[FIPFATURAVEL]"
							cInsert += "           ,[FIPEXTRAS]"
							cInsert += "           ,[FIPSITUACAO]"
							cInsert += "           ,[FIPGERADO]"
							cInsert += "           ,[FIPREVISAO]"
							cInsert += "           ,[FIPANOMESDATA]"
							cInsert += "           ,[SETORFIPIMPORTADAS]"
							cInsert += "           ,[FIPEMPRESA]"
							cInsert += "           ,[FIPFILIAL]"
							cInsert += "           ,[FIPORIGEM]"
							cInsert += "           ,[FIPPD]"
				         cInsert += "           ,[FIPEMPRESA])"								
							cInsert += "    VALUES"
							cInsert += "          ('"+QTEMPFIP->CHAPA+"'"//, varchar(6),>"
							cInsert += "           ,'"+QTEMPFIP->FIPCUSTO+"'"//, varchar(14),>"
							cInsert += "           ,'"+QTEMPFIP->FIPDATA2+"'"//, datetime,>     "
							cInsert += "           ,'"+QTEMPFIP->FIPCRONOGRAMA+"'"//, varchar(21),>"
							cInsert += "           ,'"+QTEMPFIP->FIPATIVIDADES+"'"//, varchar(10),>"
							cInsert += "           ,'"+QTEMPFIP->FIPDOCUMENTOS+"'"//, varchar(19),>"
							cInsert += "           ,replace( CAST('"+aItens[nI][8][ngt][1]+"' AS VarChar(5)) ,':','.')"//, numeric(8,2),>"
							cInsert += "           ,replace( CAST('"+aItens[nI][8][ngt][2]+"' AS VarChar(5)) ,':','.')"//, numeric(8,2),>"
							cInsert += "           ,"+CVALTOCHAR(QTEMPFIP->FIPHORAS)+""//, numeric(8,2),>"
							cInsert += "           ,"+CVALTOCHAR(QTEMPFIP->FIPHRNORMAL)+""//, numeric(8,2),>"
							cInsert += "           ,"+CVALTOCHAR(QTEMPFIP->FIPMINNORMAL)+""//, numeric(18,0),>"
							cInsert += "           ,"+CVALTOCHAR(QTEMPFIP->FIPHREXTRA)+""//, numeric(8,2),>"
							cInsert += "           ,"+CVALTOCHAR(QTEMPFIP->FIPHRCOMP)+""//, numeric(8,2),>"
							cInsert += "           ,"+CVALTOCHAR(QTEMPFIP->FIPHRBANCO)+""//, numeric(8,2),>"
							cInsert += "           ,'"+QTEMPFIP->FIPANOMES+"'"//, varchar(6),>"
							cInsert += "           ,'"+QTEMPFIP->FIPESCOPO+"'"//, varchar(1),>"
							cInsert += "           ,'"+QTEMPFIP->FIPFATURAVEL+"'"//, varchar(1),>"
							cInsert += "           ,'"+QTEMPFIP->FIPEXTRAS+"'"//, varchar(1),>"
							cInsert += "           ,'"+QTEMPFIP->FIPSITUACAO+"'"//, varchar(2),>"
							cInsert += "           ,'"+QTEMPFIP->FIPGERADO+"'"//, varchar(1),>"
							cInsert += "           ,"+CVALTOCHAR(QTEMPFIP->FIPREVISAO)+""//, int,>"
							cInsert += "           ,'"+QTEMPFIP->FIPANOMESDATA+"'"//, varchar(6),>"
							cInsert += "           ,'"+QTEMPFIP->SETORFIPIMPORTADAS+"'"//, char(10),>"
							cInsert += "           ,'"+QTEMPFIP->FIPEMPRESA+"'"//, varchar(2),>"
							cInsert += "           ,'"+QTEMPFIP->FIPFILIAL+"'"//, varchar(2),>"
							cInsert += "           ,'"+QTEMPFIP->FIPORIGEM+"'"//, varchar(10),>"
							cInsert += "           ,'"+aItens[nI][8][ngt][4]+"'"//, varchar(3),>)"
							cInsert += "           ,'"+SM0->M0_CODIGO+"')"//, varchar(3),>)"							
							TcSQLExec(cInsert)
						next
						
						if select("Q1") <> 0
							Q1->(dbCloseArea())
						endif 
						
						TcSQLExec("DELETE FROM FIPEPC WHERE FIPEMPRESA = '"+SM0->M0_CODIGO+"' AND FIPCODIGO = '"+cvaltochar(aItens[nI][7])+"'")
					endif		
				endif
			endif
		
		next
		oDl002:End()
		MSGINFO("Operação concluida.")
	else
		if (cAlias == "SRC")
			MSGSTOP("Voce cancelou o rateio de horas, as informações não foram gravadas."+chr(13)+chr(10)+"Edite as verbas novamente para refazer o processo!")
		else 
			if (cAlias == "SRR")
				MSGSTOP("A operação não foi processada, para ter acesso novamente a tela do rateio você deverá excluir a Rescisão e recalculá-la novamente!")
			else
				MSGSTOP("A operação não foi processada e para fazer novamente o rateio você deverá refazer a operação que chegou até esta tela!")
			end if
		end if
		oDl002:End()
	endif
Return