#include "rwmake.ch"
/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³AGEITAU   º                                                 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ INFOR. A AGENCIA DO FORNECEDOR PARA CNAB A PAGAR DO BANCO  º±±
±±º          ³ ITAU (SISPAG).                                             º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³                                                            º±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

User Function AGEFITAU

Local _cAgen
Local _cNumCon
Local _cDac

_cAgen		:= ""
_cNumCon	:= ALLTRIM(SA2->A2_NUMCON)
_cDac		:= ALLTRIM(SA2->A2_DIGCON)


Do Case
	
	Case SA2->A2_BANCO == "341" .AND. SEA->EA_MODELO $ "02/10"
		_cAgen := StrZero(Val(SA2->A2_AGENCIA),5)+" "+"00"+StrZero(Val(_cNumCon),10)+" "+"0"
		Return(_cAgen)
		
	Case SA2->A2_BANCO == "341" .AND. ! SEA->EA_MODELO $ "02/10"
		_cAgen := StrZero(Val(SA2->A2_AGENCIA),5)+" "+"00"+StrZero(Val(_cNumCon),10)+" "+_cDac
		Return(_cAgen)
		
	Case SA2->A2_BANCO <> "341" .and. len(alltrim(_cDac))==1
		_cAgen := StrZero(Val(SA2->A2_AGENCIA),5)+" "+"00"+StrZero(Val(_cNumCon),10)+" "+_cDac
		Return(_cAgen)
		
	OtherWise
		_cAgen := StrZero(Val(SA2->A2_AGENCIA),5)+" "+"00"+StrZero(Val(_cNumCon),10)+_cDac
		Return(_cAgen)
		
EndCase

Return
