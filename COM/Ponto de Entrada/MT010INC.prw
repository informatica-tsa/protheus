#Include 'RwMake.ch'
#INCLUDE "PROTHEUS.CH"
#include "topconn.ch"  
#include "Ap5mail.ch"  
#INCLUDE "TBICONN.CH"

User Function MT010INC()

	Local  aAreaOld := Getarea()
	Local  aEstru   := {}
	Local  aProdIMP := {}
	Local  aProdAAO := {}
	Local  aProdDEQ := {}
	Local  aProdDER := {}

	Local  aProdIMPA := {}
	Local  aProdAAOA := {}
	Local  aProdDEQA := {}
	Local  aProdDERA := {}

	Local  nAtual 	:= 1
	Local  cCampo   := ""
	Local  cGrupo   := ALLTRIM(SB1->B1_GRUPO)
	Local  cCod   	:= ALLTRIM(SB1->B1_COD)
//	Local  cSelGrup	:= ""

	If cGrupo $ 'AAO|IMP'

		aEstru := SB1->(DbStruct())

		For nAtual := 1 To Len(aEstru)
			cCampo := Alltrim(aEstru[nAtual][1])
			DO CASE
				CASE  cCampo == 'B1_GRUPO'
					aAdd(aProdIMP, 'IMP')
					aAdd(aProdAAO, 'AAO')
					aAdd(aProdDEQ, 'DEQ')
					aAdd(aProdDER, 'DER')
				CASE  cCampo == 'B1_COD'
					aAdd(aProdIMPA, {cCampo,'IMP'+SUBSTR(cCod,4),NIL})
					aAdd(aProdAAOA, {cCampo,'AAO'+SUBSTR(cCod,4),NIL})
					aAdd(aProdDEQA, {cCampo,'DEQ'+SUBSTR(cCod,4),NIL})
					aAdd(aProdDERA, {cCampo,'DER'+SUBSTR(cCod,4),NIL})
					aAdd(aProdIMP, 'IMP'+SUBSTR(cCod,4))	
					aAdd(aProdAAO, 'AAO'+SUBSTR(cCod,4))
					aAdd(aProdDEQ, 'DEQ'+SUBSTR(cCod,4))	
					aAdd(aProdDER, 'DER'+SUBSTR(cCod,4))	
				CASE  cCampo == 'B1_TIPO'
					aAdd(aProdIMP, 'MP')	
					aAdd(aProdAAO, 'A')	
					aAdd(aProdDEQ, 'ME')
					aAdd(aProdDER, 'ME')
				CASE  cCampo == 'B1_LOCPAD'
					aAdd(aProdIMP, '04')
					aAdd(aProdAAO, '03')
					aAdd(aProdDEQ, '01')	
					aAdd(aProdDER, '01')	
				CASE  cCampo == 'B1_CONTA'
					aAdd(aProdIMP, '1181030001')
					aAdd(aProdAAO, '1151020006')
					aAdd(aProdDEQ, '1151020004')
					aAdd(aProdDER, '1151020002')
				CASE  cCampo == 'B1_CTACEI'
					aAdd(aProdIMP, '')
					aAdd(aProdAAO, '4163010006')
					aAdd(aProdDEQ, '')		         	
					aAdd(aProdDER, '')		         	
				CASE  cCampo == 'B1_CTACONS'
					aAdd(aProdIMP, '4121010007')	
					aAdd(aProdAAO, '4113020006')
					aAdd(aProdDEQ, '4121010004')        
					aAdd(aProdDER, '4121010002')
				CASE  cCampo == 'B1_DESC'  
					aAdd(aProdIMPA, {cCampo,AllTrim(&("SB1->"+cCampo)),NIL}) 
					aAdd(aProdAAOA, {cCampo,AllTrim(&("SB1->"+cCampo)),NIL}) 
					aAdd(aProdDEQA, {cCampo,AllTrim(&("SB1->"+cCampo)),NIL}) 
					aAdd(aProdDERA, {cCampo,AllTrim(&("SB1->"+cCampo)),NIL}) 
					aAdd(aProdIMP, &("SB1->"+cCampo)) 
					aAdd(aProdAAO, &("SB1->"+cCampo))
					aAdd(aProdDEQ, &("SB1->"+cCampo))
					aAdd(aProdDER, &("SB1->"+cCampo))        
				OTHERWISE
					aAdd(aProdIMP, &("SB1->"+cCampo)) 
					aAdd(aProdAAO, &("SB1->"+cCampo))
					aAdd(aProdDEQ, &("SB1->"+cCampo))
					aAdd(aProdDER, &("SB1->"+cCampo))
			ENDCASE
		Next

		/*
		While cSelGrup == ""
			cSelGrup := Question()
		Enddo
		*/

		if funname() != "TMata010"
			DO CASE
				CASE  cGrupo == 'IMP'

					RecLock("SB1", .T.)
					For nAtual := 1 To Len(aEstru)
						&(aEstru[nAtual][1]) := aProdDEQ[nAtual]
					Next
					SB1->(MsUnlock())

					RecLock("SB1", .T.)
					For nAtual := 1 To Len(aEstru)
						&(aEstru[nAtual][1]) := aProdDER[nAtual]
					Next
					SB1->(MsUnlock())

					RecLock("SB1", .T.)
					For nAtual := 1 To Len(aEstru)
						&(aEstru[nAtual][1]) := aProdAAO[nAtual]
					Next
					SB1->(MsUnlock())

					//FORÇA UMA ATUALIZAÇÃO PARA INTEGRAR TCOP
					U_TMata010(aProdAAOA)
					U_TMata010(aProdDEQA)
					U_TMata010(aProdDERA)

				CASE  cGrupo == 'AAO'

					RecLock("SB1", .T.)
					For nAtual := 1 To Len(aEstru)
						&(aEstru[nAtual][1]) := aProdDEQ[nAtual]
					Next
					SB1->(MsUnlock())

					RecLock("SB1", .T.)
					For nAtual := 1 To Len(aEstru)
						&(aEstru[nAtual][1]) := aProdDER[nAtual]
					Next
					SB1->(MsUnlock())

					RecLock("SB1", .T.)
					For nAtual := 1 To Len(aEstru)
						&(aEstru[nAtual][1]) := aProdIMP[nAtual]
					Next
					SB1->(MsUnlock())

					//FORÇA UMA ATUALIZAÇÃO PARA INTEGRAR TCOP
					U_TMata010(aProdIMPA)
					U_TMata010(aProdDEQA)
					U_TMata010(aProdDERA)

			ENDCASE
		EndIF

	EndIf

	RestArea(aAreaOld)

Return Nil

//Adicionar na validação do campo B1_GRUPO para não permitir incluir produtos do grupo diretamente.
//(M->B1_GRUPO <> "DER"  .and. M->B1_GRUPO <> "DEQ")                                                                              
//P.E Valida se a cópia de produto pode ser realizada.
User Function MT010VLD	
	Local lRet := .T.	

	if alltrim(SB1->B1_GRUPO) $ "DEQ|DER"
		MsgAlert("Produtos dos Grupos DEQ e DER nao podem ser copiados. Copie um produto AAO ou IMP")
		lRet := .F.
	endif
Return lRet


Static Function Question()

	Local aItems:= {'DEQ','DER'}
	Local oFontCab  := TFont():New("Arial",10,,,.T.,,,,.F.,.F.) 
	
	cCombo1:= ""
	DEFINE MSDIALOG oDlg TITLE "Definições Gerais" FROM 0,0 TO 100,450 OF oMainWnd Pixel
	
	TComboBox():New(010,005,{|U|if(PCount()>0,cCombo1:=U,cCombo1)},aItems,80,09,oDlg,,,,,,.T.,oFontCab,,,,,,,,"cCombo1")
	
	@ 01,05 Say "Informe qual o GRUPO a ser Gerado, Material(DEQ) ou Equipamento(DER)" PIXEL OF oDlg
	
	DEFINE SBUTTON FROM 30, 10   TYPE 1 ENABLE OF oDlg ACTION (oDlg:End(),cCombo1)
	ACTIVATE MSDIALOG oDlg CENTERED 

Return(cCombo1)

User Function TMata010(aProd)

	private lMsErroAuto := .F.
	
	SetFunName("TMata010")

	IF !Empty(aProd)

		MSExecAuto({|x,y| Mata010(x,y)},aProd,4)
		
		If lMsErroAuto
			MostraErro()
		Endif

	ENDIF
 
Return

//AS ROTINAS ABAIXO FORAM APENAS PARA TESTE E CORRECAO

USER Function AtuProd()

	Local cAliasQry 	:= GetNextAlias()
	Local ncont := 0
	Local aProd := {}
	
	PREPARE ENVIRONMENT EMPRESA "02" FILIAL "01" MODULO "EST"

	cQuery :=" SELECT PROT.B1_COD FROM DADOSRM.dbo.TPRODUTO AS RM"
	cQuery +=" INNER JOIN DADOSADV.dbo.SB1020 AS PROT "
	cQuery +="	ON PROT.B1_COD = RM.CODIGOPRD COLLATE SQL_Latin1_General_CP437_BIN "
	cQuery +=" WHERE SUBSTRING(PROT.B1_DESC,1,5) <>  SUBSTRING(RM.DESCRICAO,1,5) COLLATE SQL_Latin1_General_CP437_BIN AND PROT.D_E_L_E_T_ = '' AND RM.CODCOLPRD = 1" 
	cQuery +=" ORDER BY B1_COD"
		
	dbUseArea(.T., "TOPCONN", TCGENQRY(,, cQuery), cAliasQry, .T., .T.)



	While !(cAliasQry)->(Eof()) 
		dbSelectArea("SB1")
		SB1->(dbSetOrder(1))
		if (SB1->(dbSeek(xFilial("SB1")+(cAliasQry)->B1_COD)))
			aProd := {}

			aAdd(aProd, {"B1_COD",SB1->B1_COD,NIL}) 
			aAdd(aProd, {"B1_DESC",AllTrim(SB1->B1_DESC),NIL}) 
			//ConOut(SB1->B1_COD+" : "+SB1->B1_DESC)
			U_TMata010(aProd)
			ncont++
		end
		(cAliasQry)->(DbSkip())
	END

	ConOut("Total : "+CVALTOCHAR(ncont))

	(cAliasQry)->(dbCloseArea())


Return .T.

User Function InsProd(aProd)

	private lMsErroAuto := .F.
	
	//Abre Ambiente (não deve ser utilizado caso utilize interface ou seja chamado de uma outra rotina que já inicializou o ambiente)
	PREPARE ENVIRONMENT EMPRESA "02" FILIAL "01" MODULO "EST"
	SetFunName("InsProd")
	
	IF !Empty(aProd)

		MSExecAuto({|x,y| Mata010(x,y)},aProd,3)
		
		
		If lMsErroAuto
			MostraErro()
		Endif

	endif
 
Return

user function insProdte()

	Local nVar := 1
	Local aprod := {'DER514882','DER514824','DER514881','DER514885','DER514883','DER514880','DER514879','DER514878','DER514823','DER514877'}
	Local aVetor := {}

	for nVar := 1 to Len(aprod)

			//--- Exemplo: Inclusao --- //
			aVetor:= { ;
				{"B1_COD" ,aprod[nVar] ,NIL},;
				{"B1_GRUPO" ,"DER" ,NIL},;
				{"B1_POSIPI" ,"00000000" ,NIL},;
				{"B1_ORIGEM" ,"0" ,NIL},;
				{"B1_CLASFIS" ,"00" ,NIL},;
				{"B1_UPRC" ,1 ,NIL},;
				{"B1_DESC" ,"PRODUTO TESTE - ROTINA AUTOMATICA 555" ,NIL},;
				{"B1_TIPO" ,"PA" ,Nil},;
				{"B1_UM" ,"UN" ,Nil},;
				{"B1_LOCPAD" ,"01" ,Nil},;
				{"B1_PICM" ,0 ,Nil},;
				{"B1_IPI" ,0 ,Nil},;
				{"B1_CONTRAT" ,"N" ,Nil},;
				{"B1_LOCALIZ" ,"N" ,Nil};
			}

			U_InsProd(aVetor)

	next

return .T.
