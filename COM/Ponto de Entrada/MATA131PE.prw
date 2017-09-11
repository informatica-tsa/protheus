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
		//Chamada na ativa��o da tela
	ElseIf cIdPonto == 'MODELPRE'
		//Chamada na pre-valida��o do modelo
	ElseIf cIdPonto == 'FORMPRE'
		//Chamada na pre-valida��o do formul�rio 
	ElseIf cIdPonto == 'MODELPOS'
		//Chamada na valida��o total do modelo
	ElseIf cIdPonto == 'FORMPOS'
		//Chamada na valida��o total do formul�rio
	ElseIf cIdPonto == 'FORMLINEPRE'    
		//Chamada na pre valida��o da linha do formul�rio      
	ElseIf cIdPonto == 'FORMLINEPOS'
		//Chamada na valida��o da linha do formul�rio
	ElseIf cIdPonto == 'MODELCOMMITTTS'
		//Chamada apos a grava��o total do modelo e dentro da transa��o      
	ElseIf cIdPonto == 'MODELCOMMITNTTS'
		//Chamada apos a grava��o total do modelo e fora da transa��o 

		//Grava dados complementares na contacao  
		U_FSCOMP01()
	
	ElseIf cIdPonto == 'FORMCOMMITTTSPOS'
		//Chamada apos a grava��o da tabela do formul�rio
	ElseIf cIdPonto == 'MODELCANCEL'
		//Chamada no cancelamento do bot�o.
	ElseIf cIdPonto == 'BUTTONBAR'
		//Para a inclus�o de bot�es na ControlBar
	EndIf

EndIf

Return(xRet)
