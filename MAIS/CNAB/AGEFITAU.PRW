#include "rwmake.ch"
/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �AGEITAU   �                                                 ���
�������������������������������������������������������������������������͹��
���Descricao � INFOR. A AGENCIA DO FORNECEDOR PARA CNAB A PAGAR DO BANCO  ���
���          � ITAU (SISPAG).                                             ���
�������������������������������������������������������������������������͹��
���Uso       �                                                            ���
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/

User Function AGEFITAU

Local _cAgen   
Local _cNumCon
Local _cDac

_cAgen		:= ""
_cNumCon	:= ALLTRIM(SA2->A2_NUMCON)
_cDac		:= ALLTRIM(SA2->A2_DIGCONT)


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
