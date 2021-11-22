#INCLUDE "totvs.ch"
#INCLUDE "protheus.ch"
#INCLUDE "rwmake.ch"

//-------------------------------------------------------------------
/* {Protheus.doc} FA050ALT
/* {Protheus.doc} FA050ALT
Ponto de Entrada Doc Entrada 
Utilizado para validação saldo do projeto TSA 

@protected TSA
@author    Alex T. Souza
@since     12/09/2019

Alteracoes Realizadas desde a Estruturacao Inicial
Data       Programador     Motivo
/*/
//-------------------------------------------------------------------
User Function FA050ALT()
Local aArea 		:= GetArea()
Local lRet			:= .t.
Local oSaldo
Local nAbatFI		:= 0

	If ALTERA .or. INCLUI

		SF1->(dbSetOrder(1))
	
		// So realiza validação para titulos sem vinculo com NF
		If !(SF1->(dbSeek(xFilial("SF1")+M->E2_NUM+M->E2_PREFIXO+M->E2_FORNECE+M->E2_LOJA)))
			
			//Retira valor do saldo no caso de alteração do titulo
			If ALTERA
				nAbatFI := M->E2_VALOR
			Endif
			
			If !Empty(Alltrim(M->E2_ZPRJ))
				oSaldo	:= Z_Saldo():New()
					
				// Valor do titulo
				oSaldo:nValProc		:= M->E2_VALOR    
			
				// Abate valor original do titulo
				oSaldo:nAbatFI		:=  nAbatFI 		    		    
						
				oSaldo:cCodFil 		:= 	xFilial("SE2")
				oSaldo:cCodProj		:=  M->E2_ZPRJ
				oSaldo:cCodTarefa 	:=  M->E2_ZTARE
				oSaldo:dDtEnt		:=  M->E2_ZDTENT
				oSaldo:cCodProc		:= "004"
				oSaldo:cProcesso	:= "Contas a Pagar"
			
				oSaldo:ConsSaldo() 
				oSaldo:Avalia()
								
				If !(oSaldo:lOk)                            
					If !IsBlind()	                            
						nDet := Aviso("Bloqueio de Saldo",oSaldo:cMensagem,{"Fechar"},3)
					Endif	
					lRet := oSaldo:lOk
				Endif
			Endif	
	
		Endif
	Endif

	If lRet
		/*
		//Validação para não permitir inclusão ou alteração do titulo sem informar o codigo de retençao 
		//se o campo Gera Dirf for igual a Sim.
		If M->E2_DIRF $ "1"
		If AllTrim(M->E2_CODRET) == ""
			MsgBox(OemToAnsi("O campo 'Cd. Retenção' precisa ser informado quando o campo 'Gera Dirf' for igual a 'Sim'."),"Gera Dirf","STOP")
			lRet := .F.
		EndIf
		EndIf
		*/
	Endif

	RestArea(aArea)

Return lRet
