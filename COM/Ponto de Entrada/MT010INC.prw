#Include 'RwMake.ch'

User Function MT010INC()

	Local  aAreaOld := Getarea()
	Local  aEstru   := {}
	Local  aProdIMP := {}
	Local  aProdAAO := {}
	Local  aProdDEQ := {}
	Local  nAtual 	:= 1
	Local  cCampo   := ""
	Local  cGrupo   := ALLTRIM(SB1->B1_GRUPO)
	Local  cCod   	:= ALLTRIM(SB1->B1_COD)

	If cGrupo $ 'DEQ|AAO|IMP'

		aEstru := SB1->(DbStruct())

		For nAtual := 1 To Len(aEstru)
			cCampo := Alltrim(aEstru[nAtual][1])
			DO CASE
				CASE  cCampo == 'B1_GRUPO'
					aAdd(aProdIMP, 'IMP')
					aAdd(aProdAAO, 'AAO')
					aAdd(aProdDEQ, 'DEQ')
				CASE  cCampo == 'B1_COD'
					aAdd(aProdIMP, 'IMP'+SUBSTR(cCod,4))	
					aAdd(aProdAAO, 'AAO'+SUBSTR(cCod,4))
					aAdd(aProdDEQ, 'DEQ'+SUBSTR(cCod,4))	
				CASE  cCampo == 'B1_TIPO'
					aAdd(aProdIMP, 'MP')	
					aAdd(aProdAAO, 'A')	
					aAdd(aProdDEQ, 'ME')
				CASE  cCampo == 'B1_LOCPAD'
					aAdd(aProdIMP, '04')
					aAdd(aProdAAO, '03')
					aAdd(aProdDEQ, '01')	
				CASE  cCampo == 'B1_CONTA'
					aAdd(aProdIMP, '1181030001')
					aAdd(aProdAAO, '1151020006')
					aAdd(aProdDEQ, '1151020004')
				CASE  cCampo == 'B1_CTACEI'
					aAdd(aProdIMP, '')
					aAdd(aProdAAO, '4163010006')
					aAdd(aProdDEQ, '')		         	
				CASE  cCampo == 'B1_CTACONS'
					aAdd(aProdIMP, '4121010007')	
					aAdd(aProdAAO, '4113020006')
					aAdd(aProdDEQ, '4121010004')
				OTHERWISE
					aAdd(aProdIMP, &("SB1->"+cCampo)) 
					aAdd(aProdAAO, &("SB1->"+cCampo))
					aAdd(aProdDEQ, &("SB1->"+cCampo))
			ENDCASE
		Next

		DO CASE
			CASE  cGrupo == 'DEQ'
				RecLock("SB1", .T.)
				For nAtual := 1 To Len(aEstru)
					&(aEstru[nAtual][1]) := aProdIMP[nAtual]
				Next
				SB1->(MsUnlock())
	
				RecLock("SB1", .T.)
				For nAtual := 1 To Len(aEstru)
					&(aEstru[nAtual][1]) := aProdAAO[nAtual]
				Next
				SB1->(MsUnlock())
			CASE  cGrupo == 'IMP'
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
			OTHERWISE
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
		ENDCASE

	EndIf

	RestArea(aAreaOld)

Return Nil