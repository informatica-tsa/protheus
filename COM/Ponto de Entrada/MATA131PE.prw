#Include 'Protheus.ch'
#Include 'FWMVCDef.ch'

//-------------------------------------------------------------------------------
/*/{Protheus.doc} MATA131
P.E MVC executada na rotina de geracao contacao
        
@author 	Leandro de Faria
@since 		11/09/2017

@version 	P12.1.006
@Project	Migracao V12
/*/ 
//-------------------------------------------------------------------------------
User Function MATA131()

Local aParam	:= ParamIxb
Local oObj      := Nil
Local cIdPonto  := ""
Local cIdModel  := ""
Local xRet 		:= .T.

If !Empty(aParam) 
	
	oObj       := aParam[1]
	cIdPonto   := aParam[2]
	cIdModel   := aParam[3]

	If cIdPonto == 'MODELVLDACTIVE'
		//Chamada na ativação da tela
	ElseIf cIdPonto == 'MODELPRE'
		//Chamada na pre-validação do modelo
	ElseIf cIdPonto == 'FORMPRE'
		//Chamada na pre-validação do formulário 
	ElseIf cIdPonto == 'MODELPOS'
		//Chamada na validação total do modelo
	ElseIf cIdPonto == 'FORMPOS'
		//Chamada na validação total do formulário
	ElseIf cIdPonto == 'FORMLINEPRE'    
		//Chamada na pre validação da linha do formulário      
	ElseIf cIdPonto == 'FORMLINEPOS'
		//Chamada na validação da linha do formulário
	ElseIf cIdPonto == 'MODELCOMMITTTS'
		//Chamada apos a gravação total do modelo e dentro da transação      
	ElseIf cIdPonto == 'MODELCOMMITNTTS'
		//Chamada apos a gravação total do modelo e fora da transação 

		//Grava dados complementares na contacao  
		U_FSCOMP01()
	
	ElseIf cIdPonto == 'FORMCOMMITTTSPOS'
		//Chamada apos a gravação da tabela do formulário
	ElseIf cIdPonto == 'MODELCANCEL'
		//Chamada no cancelamento do botão.
	ElseIf cIdPonto == 'BUTTONBAR'
		//Para a inclusão de botões na ControlBar
	EndIf

EndIf

Return(xRet)
