#Include 'RwMake.ch'
#INCLUDE "PROTHEUS.CH"
#include "topconn.ch"  
#include "Ap5mail.ch"  

User Function MT010INC()

	Local  aAreaOld := Getarea()
	Local  aEstru   := {}
	Local  aProdIMP := {}
	Local  aProdAAO := {}
	Local  aProdDEQ := {}
	Local  aProdDER := {}
	Local  nAtual 	:= 1
	Local  cCampo   := ""
	Local  cGrupo   := ALLTRIM(SB1->B1_GRUPO)
	Local  cCod   	:= ALLTRIM(SB1->B1_COD)
	Local  cSelGrup	:= ""

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
				OTHERWISE
					aAdd(aProdIMP, &("SB1->"+cCampo)) 
					aAdd(aProdAAO, &("SB1->"+cCampo))
					aAdd(aProdDEQ, &("SB1->"+cCampo))
					aAdd(aProdDER, &("SB1->"+cCampo))
			ENDCASE
		Next

		While cSelGrup == ""
			cSelGrup := Question()
		Enddo

		
		DO CASE
			CASE  cGrupo == 'IMP' .and. cSelGrup == 'DEQ'
				RecLock("SB1", .T.)
				For nAtual := 1 To Len(aEstru)
					&(aEstru[nAtual][1]) := aProdDEQ[nAtual]
				Next
				SB1->(MsUnlock())
	
				RecLock("SB1", .T.)
				For nAtual := 1 To Len(aEstru)
					&(aEstru[nAtual][1]) := aProdAAO[nAtual]
				Next
				SB1->(MsUnlock())
			CASE  cGrupo == 'AAO' .and. cSelGrup == 'DEQ'
				RecLock("SB1", .T.)
				For nAtual := 1 To Len(aEstru)
					&(aEstru[nAtual][1]) := aProdIMP[nAtual]
				Next
				SB1->(MsUnlock())
	
				RecLock("SB1", .T.)
				For nAtual := 1 To Len(aEstru)
					&(aEstru[nAtual][1]) := aProdDEQ[nAtual]
				Next
				SB1->(MsUnlock())
			CASE  cGrupo == 'IMP' .and. cSelGrup == 'DER'
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
			CASE  cGrupo == 'AAO' .and. cSelGrup == 'DER'
				RecLock("SB1", .T.)
				For nAtual := 1 To Len(aEstru)
					&(aEstru[nAtual][1]) := aProdIMP[nAtual]
				Next
				SB1->(MsUnlock())
	
				RecLock("SB1", .T.)
				For nAtual := 1 To Len(aEstru)
					&(aEstru[nAtual][1]) := aProdDER[nAtual]
				Next
				SB1->(MsUnlock())
		ENDCASE

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

