
#Include "RWMAKE.CH"

User function Mt241tok()
***********************************************************************************************************************
* Esta rotina tem como Objetivo validar o campo D3_CBASE(C�digo do Bem) para as requisi��es de amplia��o do BEM
*
*****

Local lRet:=.T.
Local nLin := 0

For nLin:=1 to Len(aCols)
	If !GdDeleted(nLin) .And. lRet
		If cTM$GetMv('MV_TMAMPL',,'801') .And. (Empty(GdFieldGet("D3_CODBEM",nLin)) .Or. Empty(GdFieldGet("D3_ITEMBEM",nLin)) )
			MsGBox('Para este tipo de Movimenta��o � necess�rio informar o c�digo do BEM e ITEM')
			lRet:=.f.
		Endif
		If !cTM$GetMv('MV_TMAMPL',,'801') .And. (!Empty(GdFieldGet("D3_CODBEM",nLin)) .Or. !Empty(GdFieldGet("D3_ITEMBEM",nLin)))
			MsGBox('O c�digo do Bem deve ser informado apenas para o(s) tipo(s) de movimenta��o(s):'+GetMv('MV_TMAMPL',,'801'))
			lRet:=.f.	
		Endif
	Endif
Next nLin

Return(lRet)