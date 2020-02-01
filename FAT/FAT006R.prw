#include "rwmake.ch"
#INCLUDE "PROTHEUS.CH"


#DEFINE MAXBOXH   800                                                // Tamanho maximo do box Horizontal

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ FAT006R  ºAutor  Ailson Menezes Junior  Data   10/05/13    º±±                                                      
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Carta de Correcao de Notas Fiscais                         º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Faturamento                                                º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDATA      ³ ANALISTA ³  MOTIVO                                         º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±º          ³          ³                                                 º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function FAT006R()
Private	_cDoc	:= Space(09),;
		_cSerie	:= Space(03),;
		_cCod	:= Space(06),;
		_cLoj	:= Space(02),;
		_cDat	:= Space(10),;
		_cOut	:= Space(20),;
		_cNom	:= Space(30),;
		_cChvnfe:= Space(30),;
		_nOp1	:= 2,;
		_nOp2	:= 1,;
		_lChk1	:= _lChk2  := _lChk3  := _lChk4  := _lChk5  := _lChk6  := .F.,;
		_lChk7	:= _lChk8  := _lChk9  := _lChk10 := _lChk11 := _lChk12 := .F.,;
		_lChk13 := _lChk14 := _lChk15 := _lChk16 := _lChk17 := _lChk18 := .F.,;
		_lChk19 := _lChk20 := _lChk21 := _lChk22 := _lChk23 := _lChk24 := .F.,;
		_lChk25 := _lChk26 := _lChk27 := _lChk28 := _lChk29 := _lChk30 := .F.,;
		_lChk31 := _lChk32 := _lChk33 := _lChk34 := _lChk35 := _lChk36 := .F.,;
		aCols   := {}
		aHeader := {}
		lPri 	:= .T.
		aAux    := {}

		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³Monta a lista de possiveis erros.³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		aAdd(aAux,{"01","Razao Social",Space(240),.F.})
		aAdd(aAux,{"02","Endereco",Space(240),.F.})
		aAdd(aAux,{"03","Municipio",Space(240),.F.})
		aAdd(aAux,{"04","Estado",Space(240),.F.})
		aAdd(aAux,{"05","Nº de Inscricao no CGC/MF",Space(240),.F.})
		aAdd(aAux,{"06","Nº de Inscricao Estadual",Space(240),.F.})
		aAdd(aAux,{"07","Natureza da Operacao",Space(240),.F.})
		aAdd(aAux,{"08","Codigo Fiscal da Operacao",Space(240),.F.})
		aAdd(aAux,{"09","Via de Transporte",Space(240),.F.})
		aAdd(aAux,{"10","Data da Emissao",Space(240),.F.})
		aAdd(aAux,{"11","Data de Saída",Space(240),.F.})
		aAdd(aAux,{"12","Unidade (Produto)",Space(240),.F.})
		aAdd(aAux,{"13","Quantidade (Produto)",Space(240),.F.})
		aAdd(aAux,{"14","Descricao dos Produtos",Space(240),.F.})
		aAdd(aAux,{"15","Preco Unitario",Space(240),.F.})
		aAdd(aAux,{"16","Valor Unitario",Space(240),.F.})
		aAdd(aAux,{"17","Valor Total do Produto",Space(240),.F.})
		aAdd(aAux,{"18","Classificacao Fiscal",Space(240),.F.})
		aAdd(aAux,{"19","Aliquota do IPI",Space(240),.F.})
		aAdd(aAux,{"20","Valor do IPI",Space(240),.F.})
		aAdd(aAux,{"21","Base de calculo do IPI",Space(240),.F.})
		aAdd(aAux,{"22","Valor Total da Nota Fiscal",Space(240),.F.})
		aAdd(aAux,{"23","Alíquota do ICMS",Space(240),.F.})
		aAdd(aAux,{"24","Base de Cálculo do ICMS",Space(240),.F.})
		aAdd(aAux,{"25","B.C.ICMS Substituição",Space(240),.F.})
		aAdd(aAux,{"26","Valor ICMS Substituição",Space(240),.F.})
		aAdd(aAux,{"27","Termo de Isenção do IPI",Space(240),.F.})
		aAdd(aAux,{"28","Termo de Isenção do ICMS",Space(240),.F.})
		aAdd(aAux,{"29","Peso Bruto/Líquido",Space(240),.F.})
		aAdd(aAux,{"30","Quantidade",Space(240),.F.})
		aAdd(aAux,{"31","Espécie",Space(240),.F.})
		aAdd(aAux,{"32","Nº Inscrição Municipal",Space(240),.F.})
		aAdd(aAux,{"33","Outros",Space(240),.F.})
		aAdd(aAux,{"34","Código Destino",Space(240),.F.})
		aAdd(aAux,{"35","Peso Líquido",Space(240),.F.})
		aAdd(aAux,{"36","Peso Bruto",Space(240),.F.})

		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³Chama a funcao principal para marcacao das incorrecoes.³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		xPrincipal()

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ FAT006R  ºAutor  Ailson Menezes Junior  Data   10/05/13    º±±                                                      
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Monta Janela de retificacao.                               º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Funcao Principal                                           º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDATA      ³ ANALISTA ³  MOTIVO                                         º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±º          ³          ³                                                 º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Static Function xRetifica()

Local t := 0

		If	lPri

			aHeader := {}

			DbSelectArea("SX3")
			SX3->(DbSetOrder(2))
			SX3->(DbSeek("C6_PRODUTO"))

			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³Monta campos para serem retificados.³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			aAdd(aHeader,{'Codigo','XCOD',"99",02,00,'.T.',SX3->X3_USADO,'C',"",SX3->X3_CONTEXT})
			aAdd(aHeader,{'Especificação','XESP',"@!",30,00,'.T.',SX3->X3_USADO,'C',"",SX3->X3_CONTEXT})
			aAdd(aHeader,{'Retificação','XRET',"@!",30,00,'.T.',SX3->X3_USADO,'C',"",SX3->X3_CONTEXT})

			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³Monta registros com os campos marcados.³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			aCols := {}
			For t := 1 to len(aAux)
				Var := "_lChk"+Alltrim(Str(t))
				If	&Var
					_des := Iif(t = 33,_cOut,aAux[t,2])
					aAdd(aCols,{aAux[t,1],_des,aAux[t,3],aAux[t,4]})
				Endif		
			Next t

			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³Linhas Adicionais³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			for t:=1 to 10
				aAdd(aCols,{Space(02),Space(30),Space(30),.F.})
			next t
			lPri := .F.

		EndIf

		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³Monta janela para retificacao.³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		@ 100,001 to 340,530 DIALOG oQuadro2 TITLE OemToAnsi("Retificações")
		@ 006,005 to 093,250 MULTILINE MODIFY DELETE OBJECT oMult  
		@ 100,200 BMPBUTTON TYPE 1 ACTION Close(oQuadro2)
		oMult:oBrowse:GoTop()
		oMult:oBrowse:lAdjustColSize := .T.
		ACTIVATE DIALOG oQuadro2 CENTERED

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ FAT006R  ºAutor  Ailson Menezes Junior  Data   10/05/13    º±±                                                      
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Efetua a validacao geral da Rotina.                        º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Funcao Principal                                           º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDATA      ³ ANALISTA ³  MOTIVO                                         º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±º          ³          ³                                                 º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Static Function xValidTudo(xId,oOut,oDoc,oCod)
Private	lRet := .T.

		If	( xId = "OU" )
			If	_lChk33
				oOut:lVisibleControl:= .T.
				oOut:Enable()	
			Else 
				oOut:lVisibleControl:= .F.
			    oOut:Disable()
			EndIf
		ElseIf	( xId = "O1" ) // Opcao 1 (Sua ou Nossa Nota)
				If	( _nOp1 = 0 )
					MsgBox("Selecione tipo de Nota Fiscal","Atencao","INFO")
					lRet := .F.
				ElseIf	( _nOp1 = 1 ) // Sua (Entrada)
					oDoc:cF3 := "" // SF1
				ElseIf	( _nOp1 = 2 ) // Nossa (Saida)
					oDoc:cF3 := "" // SF2
				EndIf
		ElseIf	( xId = "O2" ) // Opcao 2 (Cliente ou Fornecedor)
				If	( _nOp2 = 0 )
					MsgBox("Selecione tipo de Destinatario","Atencao","INFO")
					lRet := .F.
				ElseIf	( _nOp2 = 1 ) // Cliente
					oCod:cF3 := "SA1" // SA1
				ElseIf	( _nOp2 = 2 ) // Fornecedor
					oCod:cF3 := "SA2" // SA2
				EndIf
		ElseIf	( xId = "D" ) // Documento
				If	Empty(_cDoc)
					MsgBox(OemToAnsi("Informe número da Nota Fiscal"),OemToAnsi("Atenção"),"INFO")
					lRet := .F.
				Else
					_cOrr := Iif(_nOp1=1,SF1->F1_DOC,SF2->F2_DOC)
					If	( _cOrr <> _cDoc )
						_cAlias := Iif(_nOp1=1,"SF1","SF2")
						DbSelectArea(_cAlias)
						(_cAlias)->(DbSetOrder(1))
						If	(_cAlias)->(! DbSeek(xFilial(_cAlias) + _cDoc) )
							MsgBox(OemToAnsi("Número de nota fiscal não cadastrado"),OemToAnsi("Atenção"),("INFO"))
							lRet := .F.
						EndIf
					EndIf
				EndIf
		ElseIf	( xId = "S" ) // Serie
				If	! Empty(_cSerie)
					_cSerCor := Iif(_nOp1=1,SF1->F1_SERIE,SF2->F2_SERIE)
					If	( _cSerCor <> _cSerie )
						_cAlias := Iif(_nOp1=1,"SF1","SF2")
						DbSelectArea(_cAlias)
						(_cAlias)->(DbSetOrder(1))
						If	(_cAlias)->(! DbSeek(xFilial(_cAlias) + _cDoc + _cSerie) )
							MsgBox(OemToAnsi("Número e serie de nota fiscal não cadastrado"),OemToAnsi("Atenção"),("INFO"))
							lRet := .F.
						Else
							_cDat := Dtoc(Iif(_nOp1=1,SF1->F1_EMISSAO,SF2->F2_EMISSAO))
							_cCod := Iif(_nOp1=1,SF1->F1_FORNECE,SF2->F2_CLIENTE)
							_cLoj := Iif(_nOp1=1,SF1->F1_LOJA,SF2->F2_LOJA)
							_cChvnfe := (SF1->F1_CHVNFE,SF2->F2_CHVNFE)
						EndIf
					Else
						_cDat := Dtoc(Iif(_nOp1=1,SF1->F1_EMISSAO,SF2->F2_EMISSAO))
						_cCod := Iif(_nOp1=1,SF1->F1_FORNECE,SF2->F2_CLIENTE)
						_cLoj := Iif(_nOp1=1,SF1->F1_LOJA,SF2->F2_LOJA)
						_cChvnfe := (SF1->F1_CHVNFE,SF2->F2_CHVNFE)
						
					EndIf
				EndIf
		ElseIf	( xId = "C" ) // Codigo
				If	Empty(_cCod) 
					MsgBox("Informe codigo da Empresa cadastrada","Atencao","INFO")
					lRet := .F.
				EndIf
		ElseIf	( xId = "L" ) // Loja 
				If	Empty(_cLoj) 
					MsgBox("Informe loja da Empresa cadastrada","Atencao","INFO")
					lRet := .F.
				Else
					_cAlias := Iif(_nOp2 = 1,"SA1","SA2")
				dbSelectArea(_cAlias)
				dbSetOrder(1)
				dbgotop()
				If !dbseek(xfilial(_cAlias)+ _cCod + _cLoj)
					MsgBox("Código de Empresa informado nao esta cadastrado","Atencao","INFO")
					lRet := .F.
				Else
					_cNom := Iif(_nOp2 = 1,SA1->A1_NOME,SA2->A2_NOME)
					If !Empty(_cDoc) .or. !Empty(_cSerie)
						_cAlias := Iif(_nOp1 = 1,"SF1","SF2")
						dbSelectArea(_cAlias)
						dbSetOrder(2)
						dbgotop()
						if !dbseek(xfilial(_cAlias)+ _cCod + _cLoj + _cDoc + _cSerie)
							MsgBox("Nota Fiscal inexistente para Cliente informado","Atencao","INFO")
							lRet := .F.
						Endif
					Endif		
				Endif		 
			Endif
		Endif  
		
  Return lRet		

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ FAT006R  ºAutor  Ailson Menezes Junior  Data   10/05/13    º±±                                                      
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Inicializar variaveis.                                     º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Funcao Principal                                           º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDATA      ³ ANALISTA ³  MOTIVO                                         º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±º          ³          ³                                                 º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
				
Static Function xInicial(oOut)

	oOut:lVisibleControl:= .F.
	oOut:disable()

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ FAT006R  ºAutor  Ailson Menezes Junior  Data   10/05/13    º±±                                                      
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Apos confirmar, valida.                                    º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Funcao Principal                                           º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDATA      ³ ANALISTA ³  MOTIVO                                         º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±º          ³          ³                                                 º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
		
Static Function xConfirma()

Local t := 0

lRet 	:= .T.

		If	( Empty(_cDoc) ) .or. ( Empty(_cSerie) ) .or. ( Empty(_cCod) ) .or. ( Empty(_cLoj) )
			MsgBox(OemToAnsi("Campos obrigatórios nao foram preenchidos"),OemToAnsi("Atenção"),"INFO")
			lRet := .F.
		Endif

		If	( Len(aCols)=1 ) .and. ( Empty(aCols[1,1]) )
			MsgBox("Codigos de Retificação não foram selecionados","Atencao","INFO")
			lRet := .F.
		EndIf
		
		_Vazio := .F.
		For t := 1 to Len(acols)
			If	( ! Empty(acols[t,1]) ) .and. ( Empty(acols[t,3]) )
				_Vazio := .T.
			EndIf
		Next t

		If	( _Vazio )
			MsgBox(OemToAnsi("Retificações dos codigos nao foram especificadas"),"Atencao","INFO")
			lRet := .F.
		EndIf

		If	( ! lRet )
			Return
		EndIf

		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³Chama a rotina de impressao.³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		xImprRel()                   

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ FAT006R  ºAutor  Ailson Menezes Junior  Data   10/05/13    º±±                                                      
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Rotina de Impressao da carta.                              º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Funcao Principal                                           º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDATA      ³ ANALISTA ³  MOTIVO                                         º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±º          ³          ³                                                 º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Static Function xImprRel()

Local _nNumVia := 0

Private	oFont14		:= TFont():New("Arial",,14,,.f.,,,,,.f.),;
		oFont14n	:= TFont():New("Arial",,14,,.t.,,,,,.f.),;
		oFont12 	:= TFont():New("Arial",,12,,.f.,,,,,.f.),;
		oFont12n	:= TFont():New("Arial",,12,,.t.,,,,,.f.),;
		oFont10 	:= TFont():New("Arial",,10,,.f.,,,,,.f.),;
		oFont08 	:= TFont():New("Arial",,08,,.f.,,,,,.f.),;
		oPrn 		:= TMSPrinter():New()

Private	cbTxt     	:= "",;
		cbCont    	:= "",;
		nOrdem    	:= 0,;
		Tamanho   	:= "M",;
		Limite    	:= 132,;
		Titulo    	:= OemToAnsi("Carta de Correção"),;
		cDesc1    	:= OemToAnsi("Este programa irá emitir a carta de correção de Nota Fiscal informada"),;
		cDesc2    	:= OemToAnsi("de acordo com retificações assinaladas"),;
		cDesc3    	:= OemToAnsi(""),;
		aReturn   	:= {"Zebrado",1,"Administracao",1,2,1,"",1} ,;
		NomeProg  	:= "FAT006R" ,;
		cPerg     	:= "FATS16",;
		nLastKey  	:= 0 ,;
		lContinua 	:= .T.,;
		_nLin      	:= 80,;
		xPag      	:= 1,;
		wnrel     	:= "FAT006R",;
		cString   	:="SF1",;
		_cCab1    	:= OemToAnsi("CARTA DE CORREÇÃO"),;
		_nIni  		:= 20,;
		_nLin 		:= 20,;
		_nInt  		:= 50,;
		_cNomeCli	:= Space(30),;
		_cEndCli	:= Space(30),;
		_cBaiCli	:= Space(30),;
		_cIncrEst	:= Space(30),;
		_cTipoCli	:= Iif(_nOp1=1,"SUA","NOSSA"),;
		_cNumDoc	:= _cDoc,;
		_dEmissao	:= _cDat,;
		_dHoje		:= Str(Day(dDatabase),2)+" de "+MesExtenso(dDatabase)+" de "+str(year(dDataBase),4),;
		cAliasSPED := "SPED150"
		cProtocolo := ""

	   
	   	cQuery    := "SELECT "
		cQuery    += "* 
		cQuery    += "FROM " + "SPED150 "
		cQuery    += "WHERE "
		cQuery    += "NFE_CHV = '"+_cChvnfe+"' "     
		
		cQuery := ChangeQuery(cQuery)
		dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cAliasSPED,,.T.,.T.)
        	//(cAliasSF2)->F2_EMISSAO 
	   
		
		
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³Localiza Empresa³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		_cAlias := Iif(_nOp2=1,"SA1","SA2")
		DbSelectArea(_cAlias)
		(_cAlias)->(DbSetOrder(1))
		(_cAlias)->(DbGoTop())
		If	(_cAlias)->(Dbseek(xFilial(_cAlias)+_cCod+_cLoj))
			_cNomeCli	:= Iif(_nOp2=1,SA1->A1_NOME,SA2->A2_NOME)
			_cEndCli	:= Iif(_nOp2=1,SA1->A1_END,AllTrim(SA2->A2_END))
			_cBaiCli	:= Iif(_nOp2=1,AllTrim(SA1->A1_BAIRRO)+" - "+Alltrim(SA1->A1_MUN)+" - "+SA1->A1_EST+"   CEP: "+TransForm(SA1->A1_CEP,"@R 99999-999"),Alltrim(SA2->A2_BAIRRO)+" - "+Alltrim(SA2->A2_MUN)+" - "+SA2->A2_EST+"   CEP:"+SA2->A2_CEP)
			If	( IIf(_nOp2=1,Len(A1_CGC),Len(A2_CGC)) >= 14 )
				_cIncrEst	:= "CNPJ n. "+TransForm(IIf(_nOp2=1,A1_CGC,A2_CGC),"@R 99.999.999/9999-99")+Space(05)+" Inscr.Estadual n."+IIf(_nOp2 = 1,A1_INSCR,A2_INSCR)
			Else
				_cIncrEst	:= "CPF n. "+TransForm(IIf(_nOp2=1,A1_CGC,A2_CGC),"@R 999.999.999-99")+Space(05)+" Inscr.Estadual n."+IIf(_nOp2 = 1,A1_INSCR,A2_INSCR)
			EndIf	
		EndIf

		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³Envia controle para a funcao SETPRINT ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		wnrel:=SetPrint(cString,NomeProg,cPerg,Titulo,cDesc1,cDesc2,cDesc3,.F.,,,,,.F.)
		If	( nLastKey == 27 .Or. LastKey() == 27 )
			Return(.F.)
		EndIf

		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³Verifica Posicao do Formulario na Impressora     ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		SetDefault(aReturn,cString)
		If	( nLastKey == 27 .Or. LastKey() == 27 )
			Return(.F.)
		EndIf

		For _nNumVia := 1 to 1
			xImpCarta()
		Next _nNumVia

		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³Verifica opcao selecionada pelo usuario.³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		If	( aReturn[5] == 1 ) //1-Disco, 2-Impressora
			oPrn:Preview()
		Else
			oPrn:Setup()
			oPrn:Print()
		EndIf

		Ms_Flush()

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ FAT006R  ºAutor  Ailson Menezes Junior  Data   10/05/13    º±±                                                      
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Funcao para imprimir carta de correcao.                    º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Funcao Principal                                           º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDATA      ³ ANALISTA ³  MOTIVO                                         º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±º          ³          ³                                                 º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Static Function xImpCarta()

Local i := 0
Local t := 0

Local oProPr := ReturnPrtObj()
Local	_nLin 	:= 30,;
		_aVia	:= {'Destinatário','Remetente','Fixa'},;
		cBitMap := GetSrvProfString('Startpath','') + '/logo.bmp'
		
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³Imprime o Titulo da carta.³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		oPrn:Box(_nLin-10,_nIni+1500,_nLin+(5*_nInt)+10,2300)
		oPrn:SayBitmap(040,50,cBitMap,400,166)
		oPrn:Say(_nLin,_nIni+600,Transform(SM0->M0_CGC,"@R 99.999.999/9999-99"),oFont12n,100)
		_nLin := _nLin + _nInt
		oPrn:Say(_nLin,_nIni+600,SM0->M0_NOMECOM,oFont12n,100)
		_nLin := _nLin + _nInt
		oPrn:Say(_nLin,_nIni+600,SM0->M0_ENDENT,oFont10,100)
		_nLin := _nLin + _nInt
		oPrn:Say(_nLin,_nIni+600,SM0->M0_BAIRENT+" "+Transform(SM0->M0_CEPENT,"@R 99999-999"),oFont10,100)
		_nLin := _nLin + _nInt
		oPrn:Say(_nLin,_nIni+600,AllTrim(SM0->M0_CIDENT)+"/"+Trim(SM0->M0_ESTENT),oFont10,100)
		_nLin := _nLin + _nInt
		_nLin := _nLin + _nInt

	   //	oPrn:Say(_nLin+10,_nIni+1980,Str(_nNumVia,1) + "a. via - " + _aVia[_nNumVia] ,oFont10,100)
		_nLin := _nLin + _nInt

		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³Impressao Cabecalho³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		oPrn:Say(_nLin,_nIni+90,"Destinatário:",ofont14,100)
		_nLin := _nLin + _nInt
		oPrn:Say(_nLin,_nIni+90,_cNomeCli,ofont14n,100)
		_nLin := _nLin + _nInt
		oPrn:Say(_nLin,_nIni+90,_cEndCli,ofont14,100)
		_nLin := _nLin + _nInt 
		oPrn:Say(_nLin,_nIni+90,_cBaiCli,ofont14,100)
		_nLin := _nLin + _nInt 
		oPrn:Say(_nLin,_nIni+90,_cIncrEst,ofont14,100)
		_nLin := _nLin + (_nInt*3)

		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³Imprime o Meio da Carta.³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		oPrn:Say(_nLin,_nIni+90,"Comunicação de incorreções da Nota Fiscal Eletrônica",oFont14n,100)
		_nLin := _nLin + _nInt + _nInt
		oPrn:Box(_nLin-10,_nIni+90,_nLin+_nInt+10,2300)
		oPrn:Say(_nLin,_nIni+700," NOTA FISCAL Nº " + _cNumDoc + " SERIE " + _cSerie + " DE " + _dEmissao,ofont14n,100)
		_nLin := _nLin + _nInt + _nInt + _nInt


	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Codigo de barra                                                         ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		nBaseTxt := 500
	   	msBar3( 'CODE128', 8, 4, _cChvnfe, oPrn, .F., , .T., 0.025, 0.8, .F., 'TAHOMA', 'B', .F. )
		_nLin := _nLin + _nInt
   		oPrn:Say(_nLin+097,nBaseTxt,"Chave de acesso da NF-e vinculada: "+(TransForm(SubStr(_cChvnfe,4),"@r 9999 9999 9999 9999 9999 9999 9999 9999 9999 9999 9999")),oFont10, 999)
		_nLin := _nLin + _nInt
		_nLin := _nLin + _nInt
		_nLin := _nLin + _nInt
		_nLin := _nLin + _nInt
		oPrn:Say(_nLin,_nIni+90,"Data do evento: "+Substr((cAliasSPED)->DATE_TRANS,7,2)+"/"+Substr((cAliasSPED)->DATE_TRANS,5,2)+"/"+Substr((cAliasSPED)->DATE_TRANS,1,4),oFont12,100) //(cAliasSPED)->DATE_TRANS,oFont14,100)                       
	    _nLin := _nLin + _nInt 
	    oPrn:Say(_nLin,_nIni+90,"Hora do evento: "+(cAliasSPED)->TIME_TRANS,oFont12,100)                       
		_nLin := _nLin + _nInt 
		_nLin := _nLin + _nInt 
	    oPrn:Say(_nLin,_nIni+90,"Protocolo de autorização da CC-e: "+ALLTRIM(STR((cAliasSPED)->PROTOCOLO)),oFont14n,100)                       
	    _nLin := _nLin + _nInt
 		_nLin := _nLin + _nInt+ _nInt
		_nLin := _nLin + _nInt 

		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³Impressao corpo³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		oPrn:Box(_nLin-10,_nIni+90,_nLin+_nInt+10,700)
		oPrn:Box(_nLin-10,_nIni+900,_nLin+_nInt+10,1500)
		oPrn:Box(_nLin-10,_nIni+1700,_nLin+_nInt+10,2300)
		oPrn:Say(_nLin,_nIni+98,"Cód"+Space(7)+"Especificação",oFont12n,100)
		oPrn:Say(_nLin,_nIni+920 ,"Cód"+Space(7)+"Especificação",oFont12n,100)
		oPrn:Say(_nLin,_nIni+1720,"Cód"+Space(7)+"Especificação",oFont12n,100)
		_nLin := _nLin + _nInt+ 10
		For t := 1 to Len(aAux)/3
			For i := 0 to 2
				_cod := aAux[t+(i*12),1]
				_des := aAux[t+(i*12),2]
				_var := "_lChk"+AllTrim(str(t+(i*12)))
				_fon := IIf(&_var,oFont12n,oFont12)
				_des := IIf(&_var .and. _cod="33",_cOut,_des)
				_col := 10 + _nIni+90 + IIF(i=0,0,Iif(i=1,820,1620))
				oPrn:Say(_nLin,_col,_cod+Space(10)+_des,_fon,100)
			Next i
			_nLin := _nLin + _nInt
		Next t
		_nLin := _nLin + _nInt
		_nLin := _nLin + _nInt + _nInt

		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³Impressao Retificacoes³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		oPrn:Box(_nLin-10,_nIni+90,_nLin+_nInt+10,2300)
		oPrn:Say(_nLin,_nIni+100,"Codigo",oFont12n,100)
		oPrn:Say(_nLin,_nIni+0300,"Retificações a serem consideradas" ,oFont12n,100)
		_nLin := _nLin + _nInt + 20
		For t:= 1 to Len(acols)
			_txt1 	:= Alltrim(acols[t,3])
			_txt2 	:= ""
			_txt3 	:= ""
			_tam 	:= Len(Alltrim(acols[t,3]))
			_ll  	:= _nLin+_nInt+10
			If	( _tam > 65 )
				_txt1 	:= Substr(Alltrim(acols[t,3]),1,65)
				_txt2 	:= Substr(Alltrim(acols[t,3]),66,65)
				_ll 	:= _nLin+_nInt+10+_nInt
				If	( _tam > 130 )
					_txt3 := Substr(Alltrim(acols[t,3]),131,_tam)
					_ll := _nLin+_nInt+10+_nInt+_nInt
				EndIf
			EndIf          

			If	Empty(acols[t,1]) .and. Empty(_txt1)
				Loop
			Endif
			oPrn:Box(_nLin-10,_nIni+90,_ll,2300)
			oPrn:Say(_nLin,_nIni+100  ,acols[t,1],oFont12,100)
			oPrn:Say(_nLin,_nIni+0300,_txt1,oFont12,100)
			If !Empty(_txt2)
				_nLin := _nLin + _nInt 
				oPrn:Say(_nLin,_nIni+0300,_txt2,oFont12,100)
			Endif
			If !Empty(_txt3)
				_nLin := _nLin + _nInt 
				oPrn:Say(_nLin,_nIni+0300,_txt3,oFont12,100)
			Endif
			_nLin := _nLin + _nInt + 20
		Next t	
		_nLin := _nLin + _nInt

		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³Impressao rodape³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		//oPrn:Say(_nLin,_nIni,"",oFont14,100)
		_nLin := _nLin + _nInt + _nInt + _nInt
      /*
		oPrn:Box(_nLin-10,_nIni-10,_nLin+(6*_nInt)+10,800)
		oPrn:Say(_nLin,_nIni,AllTrim(SM0->M0_CIDENT)+", "+_dHoje,oFont10,100)
		oPrn:Say(_nLin,_nIni+1200,"Atenciosamente",oFont12,100)
		_nLin := _nLin + _nInt
		oPrn:Say(_nLin,_nIni,"Local e Data",oFont10,100)
        */
		_nLin := _nLin + _nInt + _nInt
		_nLin := _nLin + _nInt + _nInt
		_nLin := _nLin + _nInt + _nInt
		_nLin := _nLin + _nInt + _nInt
		oPrn:Say(_nLin,_nIni+90,Replicate("_",80),ofont14n,100)
		_nLin := _nLin + _nInt + _nInt
		oPrn:Say(_nLin,_nIni+90,"A Carta de Correcao e disciplinada pelo paragrafo 1o-A do art. 7o do Convenio S/N, de 15 de dezembro de 1970 e pode ser utilizada para",oFont10,100)
		_nLin := _nLin + _nInt 
		oPrn:Say(_nLin,_nIni+90,"regularizacao de erro ocorrido na emissao de documento fiscal, desde que o erro nao esteja relacionado com: I - as variaveis que",oFont10,100)
		_nLin := _nLin + _nInt 
		oPrn:Say(_nLin,_nIni+90,"determinam o valor do imposto tais como: base de calculo, aliquota, diferenca de preco, quantidade, valor da operacao ou da prestacao;",oFont10,100)
		_nLin := _nLin + _nInt 
		oPrn:Say(_nLin,_nIni+90,"II - a correcao de dados cadastrais que implique mudanca do remetente ou do destinatario; III - a data de emissao ou de saida.",oFont10,100)
	//	oPrn:Say(_nLin,_nIni,"",oFont10,100)
	
   		dbSelectArea(cAliasSPED)
			dbCloseArea()
		oPrn:EndPage()

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ FAT006R  ºAutor  Ailson Menezes Junior  Data   10/05/13    º±±                                                      
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Funcao para marcacao dos dados incorretos.                 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Funcao Principal                                           º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDATA      ³ ANALISTA ³  MOTIVO                                         º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±º          ³          ³                                                 º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Static Function xPrincipal()
Local	oQuadro1,oOp1,oOp2,oTxt1,oDoc,oSerie,oTxt2,oCod,oLoj,oChk1,oGrupo1,oChk2,oChk3,oChk4,oChk5,oChk6,oChk7,oChk8,oChk9,oChk10,oChk11,oChk12,oTxt3,otxt4,oTxt5,oTxt6,oTxt7,oTxt8,oTxt9,oTxt10,oTxt11,oTxt12,oTxt13,oTxt14,oBot1,oBot2,oBot3,oTxt15,oTxt16,oTxt17,oTxt18,oTxt19,oTxt20,oTxt21,oTxt22,oTxt23,oTxt24,oTxt25,oTxt26,oChk13,oChk14,oChk15,oChk16,oChk17,oChk18,oChk19,oChk20,oChk21,oChk22,oChk23,oChk24,oTxt27,oTxt28,oTxt29,oTxt30,oTxt31,oTxt32,oTxt33,oTxt34,oTxt35,oTxt36,oTxt37,oTxt38,oChk25,oChk26,oChk27,oChk28,oChk29,oChk30,oChk31,oChk32,oChk33,oChk34,oChk35,oChk36,oDat,oTxt39,oOut,oNom,oTxt40

		oQuadro1 := MsDialog():Create()
		oQuadro1:cName := "oQuadro1"
		oQuadro1:cCaption := "Carta de Correção"
		oQuadro1:nLeft := 0
		oQuadro1:nTop := 0
		oQuadro1:nWidth := 611
		oQuadro1:nHeight := 442
		oQuadro1:lShowHint := .F.
		oQuadro1:lCentered := .T.
		oQuadro1:bInit := {|| xInicial(oOut) }
		
		oOp1 := TRADMENU():Create(oQuadro1)
		oOp1:cName := "oOp1"
		oOp1:nLeft := 15
		oOp1:nTop := 10
		oOp1:nWidth := 101
		oOp1:nHeight := 50
		oOp1:lShowHint := .F.
		oOp1:lReadOnly := .F.
		oOp1:Align := 0
		oOp1:cVariable := "_nOp1"
		oOp1:bSetGet := {|u| If(PCount()>0,_nOp1:=u,_nOp1) }
		oOp1:lVisibleControl := .T.
		oOp1:nOption := 0
		oOp1:aItems := { "Nf. Entrada","Nf. Saida"}
		oOp1:bValid := {|| xValidTudo("O1",oOut,oDoc,oCod) }
		
		oOp2 := TRADMENU():Create(oQuadro1)
		oOp2:cName := "oOp2"
		oOp2:nLeft := 129
		oOp2:nTop := 10
		oOp2:nWidth := 101
		oOp2:nHeight := 50
		oOp2:lShowHint := .F.
		oOp2:lReadOnly := .F.
		oOp2:Align := 0
		oOp2:cVariable := "_nOp2"
		oOp2:bSetGet := {|u| If(PCount()>0,_nOp2:=u,_nOp2) }
		oOp2:lVisibleControl := .T.
		oOp2:nOption := 0
		oOp2:aItems := { "Cliente","Fornecedor"}
		oOp2:bValid := {|| xValidTudo("O2",oOut,oDoc,oCod) }
		
		oTxt1 := TSAY():Create(oQuadro1)
		oTxt1:cName := "oTxt1"
		oTxt1:cCaption := "Documento"
		oTxt1:nLeft := 258
		oTxt1:nTop := 11
		oTxt1:nWidth := 65
		oTxt1:nHeight := 17
		oTxt1:lShowHint := .F.
		oTxt1:lReadOnly := .F.
		oTxt1:Align := 0
		oTxt1:lVisibleControl := .T.
		oTxt1:lWordWrap := .F.
		oTxt1:lTransparent := .T.
		
		oDoc := TGET():Create(oQuadro1)
		oDoc:cName := "oDoc"
		oDoc:nLeft := 326
		oDoc:nTop := 9
		oDoc:nWidth := 65
		oDoc:nHeight := 21
		oDoc:lShowHint := .F.
		oDoc:lReadOnly := .F.
		oDoc:Align := 0
		oDoc:cVariable := "_cDoc"
		oDoc:bSetGet := {|u| If(PCount()>0,_cDoc:=u,_cDoc) }
		oDoc:lVisibleControl := .T.
		oDoc:lPassword := .F.
		oDoc:lHasButton := .F.
		oDoc:bValid := {|| xValidTudo("D") }

		oSerie:= TGET():Create(oQuadro1)
		oSerie:cName := "oSerie"
		oSerie:nLeft := 401
		oSerie:nTop := 9
		oSerie:nWidth := 28
		oSerie:nHeight := 21
		oSerie:lShowHint := .F.
		oSerie:lReadOnly := .F.
		oSerie:Align := 0
		oSerie:cVariable := "_cSerie"
		oSerie:bSetGet := {|u| If(PCount()>0,_cSerie:=u,_cSerie) }
		oSerie:lVisibleControl := .T.
		oSerie:lPassword := .F.
		oSerie:lHasButton := .F.
		oSerie:bValid := {|| xValidTudo("S") }
		
		oTxt2 := TSAY():Create(oQuadro1)
		oTxt2:cName := "oTxt2"
		oTxt2:cCaption := "Código"
		oTxt2:nLeft := 259
		oTxt2:nTop := 39
		oTxt2:nWidth := 65
		oTxt2:nHeight := 17
		oTxt2:lShowHint := .F.
		oTxt2:lReadOnly := .F.
		oTxt2:Align := 0
		oTxt2:lVisibleControl := .T.
		oTxt2:lWordWrap := .F.
		oTxt2:lTransparent := .F.
		
		oCod := TGET():Create(oQuadro1)
		oCod:cName := "oCod"
		oCod:nLeft := 326
		oCod:nTop := 34
		oCod:nWidth := 69
		oCod:nHeight := 21
		oCod:lShowHint := .F.
		oCod:lReadOnly := .F.
		oCod:Align := 0
		oCod:cVariable := "_cCod"
		oCod:bSetGet := {|u| If(PCount()>0,_cCod:=u,_cCod) }
		oCod:lVisibleControl := .T.
		oCod:lPassword := .F.
		oCod:lHasButton := .F.
		oCod:bValid := {|| xValidTudo("C") }
		
		oLoj := TGET():Create(oQuadro1)
		oLoj:cName := "oLoj"
		oLoj:nLeft := 401
		oLoj:nTop := 34
		oLoj:nWidth := 22
		oLoj:nHeight := 21
		oLoj:lShowHint := .F.
		oLoj:lReadOnly := .F.
		oLoj:Align := 0
		oLoj:cVariable := "_cLoj"
		oLoj:bSetGet := {|u| If(PCount()>0,_cLoj:=u,_cLoj) }
		oLoj:lVisibleControl := .T.
		oLoj:lPassword := .F.
		oLoj:lHasButton := .F.
		oLoj:bValid := {|| xValidTudo("L") }
		
		oChk1 := TCHECKBOX():Create(oQuadro1)
		oChk1:cName := "oChk1"
		oChk1:cCaption := "Razão Social"
		oChk1:nLeft := 35
		oChk1:nTop := 85
		oChk1:nWidth := 159
		oChk1:nHeight := 17
		oChk1:lShowHint := .F.
		oChk1:lReadOnly := .F.
		oChk1:Align := 0
		oChk1:cVariable := "_lChk1"
		oChk1:bSetGet := {|u| If(PCount()>0,_lChk1:=u,_lChk1) }
		oChk1:lVisibleControl := .T.
		
		oGrupo1 := TGROUP():Create(oQuadro1)
		oGrupo1:cName := "oGrupo1"
		oGrupo1:cCaption := "Apontar irregularidades"
		oGrupo1:nLeft := 6
		oGrupo1:nTop := 60
		oGrupo1:nWidth := 586
		oGrupo1:nHeight := 271
		oGrupo1:lShowHint := .F.
		oGrupo1:lReadOnly := .F.
		oGrupo1:Align := 0
		oGrupo1:lVisibleControl := .T.
		
		oChk2 := TCHECKBOX():Create(oQuadro1)
		oChk2:cName := "oChk2"
		oChk2:cCaption := "Endereço"
		oChk2:nLeft := 35
		oChk2:nTop := 105
		oChk2:nWidth := 159
		oChk2:nHeight := 17
		oChk2:lShowHint := .F.
		oChk2:lReadOnly := .F.
		oChk2:Align := 0
		oChk2:cVariable := "_lChk2"
		oChk2:bSetGet := {|u| If(PCount()>0,_lChk2:=u,_lChk2) }
		oChk2:lVisibleControl := .T.
		
		oChk3 := TCHECKBOX():Create(oQuadro1)
		oChk3:cName := "oChk3"
		oChk3:cCaption := "Município"
		oChk3:nLeft := 35
		oChk3:nTop := 125
		oChk3:nWidth := 159
		oChk3:nHeight := 17
		oChk3:lShowHint := .F.
		oChk3:lReadOnly := .F.
		oChk3:Align := 0
		oChk3:cVariable := "_lChk3"
		oChk3:bSetGet := {|u| If(PCount()>0,_lChk3:=u,_lChk3) }
		oChk3:lVisibleControl := .T.
		
		oChk4 := TCHECKBOX():Create(oQuadro1)
		oChk4:cName := "oChk4"
		oChk4:cCaption := "Estado"
		oChk4:nLeft := 35
		oChk4:nTop := 145
		oChk4:nWidth := 159
		oChk4:nHeight := 17
		oChk4:lShowHint := .F.
		oChk4:lReadOnly := .F.
		oChk4:Align := 0
		oChk4:cVariable := "_lChk4"
		oChk4:bSetGet := {|u| If(PCount()>0,_lChk4:=u,_lChk4) }
		oChk4:lVisibleControl := .T.
		
		oChk5 := TCHECKBOX():Create(oQuadro1)
		oChk5:cName := "oChk5"
		oChk5:cCaption := "Nº de Inscrição no CGC/MF"
		oChk5:nLeft := 35
		oChk5:nTop := 165
		oChk5:nWidth := 159
		oChk5:nHeight := 17
		oChk5:lShowHint := .F.
		oChk5:lReadOnly := .F.
		oChk5:Align := 0
		oChk5:cVariable := "_lChk5"
		oChk5:bSetGet := {|u| If(PCount()>0,_lChk5:=u,_lChk5) }
		oChk5:lVisibleControl := .T.
		
		oChk6 := TCHECKBOX():Create(oQuadro1)
		oChk6:cName := "oChk6"
		oChk6:cCaption := "Nº de Inscrição Estadual"
		oChk6:nLeft := 35
		oChk6:nTop := 185
		oChk6:nWidth := 159
		oChk6:nHeight := 17
		oChk6:lShowHint := .F.
		oChk6:lReadOnly := .F.
		oChk6:Align := 0
		oChk6:cVariable := "_lChk6"
		oChk6:bSetGet := {|u| If(PCount()>0,_lChk6:=u,_lChk6) }
		oChk6:lVisibleControl := .T.
		
		oChk7 := TCHECKBOX():Create(oQuadro1)
		oChk7:cName := "oChk7"
		oChk7:cCaption := "Natureza de Operação"
		oChk7:nLeft := 35
		oChk7:nTop := 205
		oChk7:nWidth := 159
		oChk7:nHeight := 17
		oChk7:lShowHint := .F.
		oChk7:lReadOnly := .F.
		oChk7:Align := 0
		oChk7:cVariable := "_lChk7"
		oChk7:bSetGet := {|u| If(PCount()>0,_lChk7:=u,_lChk7) }
		oChk7:lVisibleControl := .T.
		
		oChk8 := TCHECKBOX():Create(oQuadro1)
		oChk8:cName := "oChk8"
		oChk8:cCaption := "Código Fiscal da Operação"
		oChk8:nLeft := 35
		oChk8:nTop := 225
		oChk8:nWidth := 159
		oChk8:nHeight := 17
		oChk8:lShowHint := .F.
		oChk8:lReadOnly := .F.
		oChk8:Align := 0
		oChk8:cVariable := "_lChk8"
		oChk8:bSetGet := {|u| If(PCount()>0,_lChk8:=u,_lChk8) }
		oChk8:lVisibleControl := .T.
		
		oChk9 := TCHECKBOX():Create(oQuadro1)
		oChk9:cName := "oChk9"
		oChk9:cCaption := "Via de Transporte"
		oChk9:nLeft := 35
		oChk9:nTop := 245
		oChk9:nWidth := 159
		oChk9:nHeight := 17
		oChk9:lShowHint := .F.
		oChk9:lReadOnly := .F.
		oChk9:Align := 0
		oChk9:cVariable := "_lChk9"
		oChk9:bSetGet := {|u| If(PCount()>0,_lChk9:=u,_lChk9) }
		oChk9:lVisibleControl := .T.
		
		oChk10 := TCHECKBOX():Create(oQuadro1)
		oChk10:cName := "oChk10"
		oChk10:cCaption := "Data da Emissão"
		oChk10:nLeft := 35
		oChk10:nTop := 265
		oChk10:nWidth := 159
		oChk10:nHeight := 17
		oChk10:lShowHint := .F.
		oChk10:lReadOnly := .F.
		oChk10:Align := 0
		oChk10:cVariable := "_lChk10"
		oChk10:bSetGet := {|u| If(PCount()>0,_lChk10:=u,_lChk10) }
		oChk10:lVisibleControl := .T.
		
		oChk11 := TCHECKBOX():Create(oQuadro1)
		oChk11:cName := "oChk11"
		oChk11:cCaption := "Data de Saída"
		oChk11:nLeft := 35
		oChk11:nTop := 285
		oChk11:nWidth := 159
		oChk11:nHeight := 17
		oChk11:lShowHint := .F.
		oChk11:lReadOnly := .F.
		oChk11:Align := 0
		oChk11:cVariable := "_lChk11"
		oChk11:bSetGet := {|u| If(PCount()>0,_lChk11:=u,_lChk11) }
		oChk11:lVisibleControl := .T.
		
		oChk12 := TCHECKBOX():Create(oQuadro1)
		oChk12:cName := "oChk12"
		oChk12:cCaption := "Unidade (Produto)"
		oChk12:nLeft := 35
		oChk12:nTop := 305
		oChk12:nWidth := 159
		oChk12:nHeight := 17
		oChk12:lShowHint := .F.
		oChk12:lReadOnly := .F.
		oChk12:Align := 0
		oChk12:cVariable := "_lChk12"
		oChk12:bSetGet := {|u| If(PCount()>0,_lChk12:=u,_lChk12) }
		oChk12:lVisibleControl := .T.
		
		oTxt3 := TSAY():Create(oQuadro1)
		oTxt3:cName := "oTxt3"
		oTxt3:cCaption := "01"
		oTxt3:nLeft := 14
		oTxt3:nTop := 85
		oTxt3:nWidth := 16
		oTxt3:nHeight := 17
		oTxt3:lShowHint := .F.
		oTxt3:lReadOnly := .F.
		oTxt3:Align := 0
		oTxt3:lVisibleControl := .T.
		oTxt3:lWordWrap := .F.
		oTxt3:lTransparent := .T.
		
		otxt4 := TSAY():Create(oQuadro1)
		otxt4:cName := "otxt4"
		otxt4:cCaption := "02"
		otxt4:nLeft := 14
		otxt4:nTop := 105
		otxt4:nWidth := 16
		otxt4:nHeight := 17
		otxt4:lShowHint := .F.
		otxt4:lReadOnly := .F.
		otxt4:Align := 0
		otxt4:lVisibleControl := .T.
		otxt4:lWordWrap := .F.
		otxt4:lTransparent := .T.
		
		oTxt5 := TSAY():Create(oQuadro1)
		oTxt5:cName := "oTxt5"
		oTxt5:cCaption := "03"
		oTxt5:nLeft := 14
		oTxt5:nTop := 125
		oTxt5:nWidth := 16
		oTxt5:nHeight := 17
		oTxt5:lShowHint := .F.
		oTxt5:lReadOnly := .F.
		oTxt5:Align := 0
		oTxt5:lVisibleControl := .T.
		oTxt5:lWordWrap := .F.
		oTxt5:lTransparent := .T.
		
		oTxt6 := TSAY():Create(oQuadro1)
		oTxt6:cName := "oTxt6"
		oTxt6:cCaption := "04"
		oTxt6:nLeft := 14
		oTxt6:nTop := 145
		oTxt6:nWidth := 16
		oTxt6:nHeight := 17
		oTxt6:lShowHint := .F.
		oTxt6:lReadOnly := .F.
		oTxt6:Align := 0
		oTxt6:lVisibleControl := .T.
		oTxt6:lWordWrap := .F.
		oTxt6:lTransparent := .T.
		
		oTxt7 := TSAY():Create(oQuadro1)
		oTxt7:cName := "oTxt7"
		oTxt7:cCaption := "05"
		oTxt7:nLeft := 14
		oTxt7:nTop := 165
		oTxt7:nWidth := 16
		oTxt7:nHeight := 17
		oTxt7:lShowHint := .F.
		oTxt7:lReadOnly := .F.
		oTxt7:Align := 0
		oTxt7:lVisibleControl := .T.
		oTxt7:lWordWrap := .F.
		oTxt7:lTransparent := .T.
		
		oTxt8 := TSAY():Create(oQuadro1)
		oTxt8:cName := "oTxt8"
		oTxt8:cCaption := "06"
		oTxt8:nLeft := 14
		oTxt8:nTop := 185
		oTxt8:nWidth := 16
		oTxt8:nHeight := 17
		oTxt8:lShowHint := .F.
		oTxt8:lReadOnly := .F.
		oTxt8:Align := 0
		oTxt8:lVisibleControl := .T.
		oTxt8:lWordWrap := .F.
		oTxt8:lTransparent := .T.
		
		oTxt9 := TSAY():Create(oQuadro1)
		oTxt9:cName := "oTxt9"
		oTxt9:cCaption := "07"
		oTxt9:nLeft := 14
		oTxt9:nTop := 205
		oTxt9:nWidth := 16
		oTxt9:nHeight := 17
		oTxt9:lShowHint := .F.
		oTxt9:lReadOnly := .F.
		oTxt9:Align := 0
		oTxt9:lVisibleControl := .T.
		oTxt9:lWordWrap := .F.
		oTxt9:lTransparent := .T.
		
		oTxt10 := TSAY():Create(oQuadro1)
		oTxt10:cName := "oTxt10"
		oTxt10:cCaption := "08"
		oTxt10:nLeft := 14
		oTxt10:nTop := 225
		oTxt10:nWidth := 16
		oTxt10:nHeight := 17
		oTxt10:lShowHint := .F.
		oTxt10:lReadOnly := .F.
		oTxt10:Align := 0
		oTxt10:lVisibleControl := .T.
		oTxt10:lWordWrap := .F.
		oTxt10:lTransparent := .T.
		
		oTxt11 := TSAY():Create(oQuadro1)
		oTxt11:cName := "oTxt11"
		oTxt11:cCaption := "09"
		oTxt11:nLeft := 14
		oTxt11:nTop := 245
		oTxt11:nWidth := 16
		oTxt11:nHeight := 17
		oTxt11:lShowHint := .F.
		oTxt11:lReadOnly := .F.
		oTxt11:Align := 0
		oTxt11:lVisibleControl := .T.
		oTxt11:lWordWrap := .F.
		oTxt11:lTransparent := .T.
		
		oTxt12 := TSAY():Create(oQuadro1)
		oTxt12:cName := "oTxt12"
		oTxt12:cCaption := "10"
		oTxt12:nLeft := 14
		oTxt12:nTop := 265
		oTxt12:nWidth := 16
		oTxt12:nHeight := 17
		oTxt12:lShowHint := .F.
		oTxt12:lReadOnly := .F.
		oTxt12:Align := 0
		oTxt12:lVisibleControl := .T.
		oTxt12:lWordWrap := .F.
		oTxt12:lTransparent := .T.
		
		oTxt13 := TSAY():Create(oQuadro1)
		oTxt13:cName := "oTxt13"
		oTxt13:cCaption := "11"
		oTxt13:nLeft := 14
		oTxt13:nTop := 285
		oTxt13:nWidth := 16
		oTxt13:nHeight := 17
		oTxt13:lShowHint := .F.
		oTxt13:lReadOnly := .F.
		oTxt13:Align := 0
		oTxt13:lVisibleControl := .T.
		oTxt13:lWordWrap := .F.
		oTxt13:lTransparent := .T.
		
		oTxt14 := TSAY():Create(oQuadro1)
		oTxt14:cName := "oTxt14"
		oTxt14:cCaption := "12"
		oTxt14:nLeft := 14
		oTxt14:nTop := 305
		oTxt14:nWidth := 16
		oTxt14:nHeight := 17
		oTxt14:lShowHint := .F.
		oTxt14:lReadOnly := .F.
		oTxt14:Align := 0
		oTxt14:lVisibleControl := .T.
		oTxt14:lWordWrap := .F.
		oTxt14:lTransparent := .T.
		
		oBot1 := SBUTTON():Create(oQuadro1)
		oBot1:cName := "oBot1"
		oBot1:cCaption := "Retificar"
		oBot1:nLeft := 340
		oBot1:nTop := 375
		oBot1:lShowHint := .F.
		oBot1:lReadOnly := .F.
		oBot1:Align := 0
		oBot1:lVisibleControl := .T.
		oBot1:nType := 5
		oBot1:bLClicked := {|| xRetifica() }
		
		oBot2 := SBUTTON():Create(oQuadro1)
		oBot2:cName := "oBot2"
		oBot2:cCaption := "Imprimir"
		oBot2:nLeft := 434
		oBot2:nTop := 375
		oBot2:lShowHint := .F.
		oBot2:lReadOnly := .F.
		oBot2:Align := 0
		oBot2:lVisibleControl := .T.
		oBot2:nType := 1
		oBot2:bLClicked := {|| xConfirma() }
		
		oBot3 := SBUTTON():Create(oQuadro1)
		oBot3:cName := "oBot3"
		oBot3:nLeft := 503
		oBot3:nTop := 375
		oBot3:lShowHint := .F.
		oBot3:lReadOnly := .F.
		oBot3:Align := 0
		oBot3:lVisibleControl := .T.
		oBot3:nType := 2
		oBot3:bLClicked := {|| Close(oQuadro1) }
		
		oTxt15 := TSAY():Create(oQuadro1)
		oTxt15:cName := "oTxt15"
		oTxt15:cCaption := "13"
		oTxt15:nLeft := 205
		oTxt15:nTop := 85
		oTxt15:nWidth := 16
		oTxt15:nHeight := 17
		oTxt15:lShowHint := .F.
		oTxt15:lReadOnly := .F.
		oTxt15:Align := 0
		oTxt15:lVisibleControl := .T.
		oTxt15:lWordWrap := .F.
		oTxt15:lTransparent := .T.
		
		oTxt16 := TSAY():Create(oQuadro1)
		oTxt16:cName := "oTxt16"
		oTxt16:cCaption := "14"
		oTxt16:nLeft := 205
		oTxt16:nTop := 105
		oTxt16:nWidth := 16
		oTxt16:nHeight := 17
		oTxt16:lShowHint := .F.
		oTxt16:lReadOnly := .F.
		oTxt16:Align := 0
		oTxt16:lVisibleControl := .T.
		oTxt16:lWordWrap := .F.
		oTxt16:lTransparent := .T.
		
		oTxt17 := TSAY():Create(oQuadro1)
		oTxt17:cName := "oTxt17"
		oTxt17:cCaption := "15"
		oTxt17:nLeft := 205
		oTxt17:nTop := 124
		oTxt17:nWidth := 16
		oTxt17:nHeight := 17
		oTxt17:lShowHint := .F.
		oTxt17:lReadOnly := .F.
		oTxt17:Align := 0
		oTxt17:lVisibleControl := .T.
		oTxt17:lWordWrap := .F.
		oTxt17:lTransparent := .T.
		
		oTxt18 := TSAY():Create(oQuadro1)
		oTxt18:cName := "oTxt18"
		oTxt18:cCaption := "16"
		oTxt18:nLeft := 205
		oTxt18:nTop := 145
		oTxt18:nWidth := 16
		oTxt18:nHeight := 17
		oTxt18:lShowHint := .F.
		oTxt18:lReadOnly := .F.
		oTxt18:Align := 0
		oTxt18:lVisibleControl := .T.
		oTxt18:lWordWrap := .F.
		oTxt18:lTransparent := .T.
		
		oTxt19 := TSAY():Create(oQuadro1)
		oTxt19:cName := "oTxt19"
		oTxt19:cCaption := "17"
		oTxt19:nLeft := 205
		oTxt19:nTop := 165
		oTxt19:nWidth := 16
		oTxt19:nHeight := 17
		oTxt19:lShowHint := .F.
		oTxt19:lReadOnly := .F.
		oTxt19:Align := 0
		oTxt19:lVisibleControl := .T.
		oTxt19:lWordWrap := .F.
		oTxt19:lTransparent := .T.
		
		oTxt20 := TSAY():Create(oQuadro1)
		oTxt20:cName := "oTxt20"
		oTxt20:cCaption := "18"
		oTxt20:nLeft := 205
		oTxt20:nTop := 185
		oTxt20:nWidth := 16
		oTxt20:nHeight := 17
		oTxt20:lShowHint := .F.
		oTxt20:lReadOnly := .F.
		oTxt20:Align := 0
		oTxt20:lVisibleControl := .T.
		oTxt20:lWordWrap := .F.
		oTxt20:lTransparent := .T.
		
		oTxt21 := TSAY():Create(oQuadro1)
		oTxt21:cName := "oTxt21"
		oTxt21:cCaption := "19"
		oTxt21:nLeft := 205
		oTxt21:nTop := 205
		oTxt21:nWidth := 16
		oTxt21:nHeight := 17
		oTxt21:lShowHint := .F.
		oTxt21:lReadOnly := .F.
		oTxt21:Align := 0
		oTxt21:lVisibleControl := .T.
		oTxt21:lWordWrap := .F.
		oTxt21:lTransparent := .T.
		
		oTxt22 := TSAY():Create(oQuadro1)
		oTxt22:cName := "oTxt22"
		oTxt22:cCaption := "20"
		oTxt22:nLeft := 205
		oTxt22:nTop := 225
		oTxt22:nWidth := 16
		oTxt22:nHeight := 17
		oTxt22:lShowHint := .F.
		oTxt22:lReadOnly := .F.
		oTxt22:Align := 0
		oTxt22:lVisibleControl := .T.
		oTxt22:lWordWrap := .F.
		oTxt22:lTransparent := .T.
		
		oTxt23 := TSAY():Create(oQuadro1)
		oTxt23:cName := "oTxt23"
		oTxt23:cCaption := "21"
		oTxt23:nLeft := 205
		oTxt23:nTop := 245
		oTxt23:nWidth := 16
		oTxt23:nHeight := 17
		oTxt23:lShowHint := .F.
		oTxt23:lReadOnly := .F.
		oTxt23:Align := 0
		oTxt23:lVisibleControl := .T.
		oTxt23:lWordWrap := .F.
		oTxt23:lTransparent := .T.
		
		oTxt24 := TSAY():Create(oQuadro1)
		oTxt24:cName := "oTxt24"
		oTxt24:cCaption := "22"
		oTxt24:nLeft := 205
		oTxt24:nTop := 265
		oTxt24:nWidth := 16
		oTxt24:nHeight := 17
		oTxt24:lShowHint := .F.
		oTxt24:lReadOnly := .F.
		oTxt24:Align := 0
		oTxt24:lVisibleControl := .T.
		oTxt24:lWordWrap := .F.
		oTxt24:lTransparent := .T.
		
		oTxt25 := TSAY():Create(oQuadro1)
		oTxt25:cName := "oTxt25"
		oTxt25:cCaption := "23"
		oTxt25:nLeft := 205
		oTxt25:nTop := 285
		oTxt25:nWidth := 16
		oTxt25:nHeight := 17
		oTxt25:lShowHint := .F.
		oTxt25:lReadOnly := .F.
		oTxt25:Align := 0
		oTxt25:lVisibleControl := .T.
		oTxt25:lWordWrap := .F.
		oTxt25:lTransparent := .T.
		
		oTxt26 := TSAY():Create(oQuadro1)
		oTxt26:cName := "oTxt26"
		oTxt26:cCaption := "24"
		oTxt26:nLeft := 205
		oTxt26:nTop := 305
		oTxt26:nWidth := 16
		oTxt26:nHeight := 17
		oTxt26:lShowHint := .F.
		oTxt26:lReadOnly := .F.
		oTxt26:Align := 0
		oTxt26:lVisibleControl := .T.
		oTxt26:lWordWrap := .F.
		oTxt26:lTransparent := .T.
		
		oChk13 := TCHECKBOX():Create(oQuadro1)
		oChk13:cName := "oChk13"
		oChk13:cCaption := "Quantidade (Produto)"
		oChk13:nLeft := 226
		oChk13:nTop := 85
		oChk13:nWidth := 159
		oChk13:nHeight := 17
		oChk13:lShowHint := .F.
		oChk13:lReadOnly := .F.
		oChk13:Align := 0
		oChk13:cVariable := "_lChk13"
		oChk13:bSetGet := {|u| If(PCount()>0,_lChk13:=u,_lChk13) }
		oChk13:lVisibleControl := .T.
		
		oChk14 := TCHECKBOX():Create(oQuadro1)
		oChk14:cName := "oChk14"
		oChk14:cCaption := "Descrição dos Produtos"
		oChk14:nLeft := 226
		oChk14:nTop := 105
		oChk14:nWidth := 159
		oChk14:nHeight := 17
		oChk14:lShowHint := .F.
		oChk14:lReadOnly := .F.
		oChk14:Align := 0
		oChk14:cVariable := "_lChk14"
		oChk14:bSetGet := {|u| If(PCount()>0,_lChk14:=u,_lChk14) }
		oChk14:lVisibleControl := .T.
		
		oChk15 := TCHECKBOX():Create(oQuadro1)
		oChk15:cName := "oChk15"
		oChk15:cCaption := "Preço Unitário"
		oChk15:nLeft := 226
		oChk15:nTop := 125
		oChk15:nWidth := 159
		oChk15:nHeight := 17
		oChk15:lShowHint := .F.
		oChk15:lReadOnly := .F.
		oChk15:Align := 0
		oChk15:cVariable := "_lChk15"
		oChk15:bSetGet := {|u| If(PCount()>0,_lChk15:=u,_lChk15) }
		oChk15:lVisibleControl := .T.
		
		oChk16 := TCHECKBOX():Create(oQuadro1)
		oChk16:cName := "oChk16"
		oChk16:cCaption := "Valor Unitário"
		oChk16:nLeft := 226
		oChk16:nTop := 145
		oChk16:nWidth := 159
		oChk16:nHeight := 17
		oChk16:lShowHint := .F.
		oChk16:lReadOnly := .F.
		oChk16:Align := 0
		oChk16:cVariable := "_lChk16"
		oChk16:bSetGet := {|u| If(PCount()>0,_lChk16:=u,_lChk16) }
		oChk16:lVisibleControl := .T.
		
		oChk17 := TCHECKBOX():Create(oQuadro1)
		oChk17:cName := "oChk17"
		oChk17:cCaption := "Valor Total do Produto"
		oChk17:nLeft := 226
		oChk17:nTop := 165
		oChk17:nWidth := 159
		oChk17:nHeight := 17
		oChk17:lShowHint := .F.
		oChk17:lReadOnly := .F.
		oChk17:Align := 0
		oChk17:cVariable := "_lChk17"
		oChk17:bSetGet := {|u| If(PCount()>0,_lChk17:=u,_lChk17) }
		oChk17:lVisibleControl := .T.
		
		oChk18 := TCHECKBOX():Create(oQuadro1)
		oChk18:cName := "oChk18"
		oChk18:cCaption := "Classificação Fiscal"
		oChk18:nLeft := 226
		oChk18:nTop := 185
		oChk18:nWidth := 159
		oChk18:nHeight := 17
		oChk18:lShowHint := .F.
		oChk18:lReadOnly := .F.
		oChk18:Align := 0
		oChk18:cVariable := "_lChk18"
		oChk18:bSetGet := {|u| If(PCount()>0,_lChk18:=u,_lChk18) }
		oChk18:lVisibleControl := .T.
		
		oChk19 := TCHECKBOX():Create(oQuadro1)
		oChk19:cName := "oChk19"
		oChk19:cCaption := "Alíquota do IPI"
		oChk19:nLeft := 226
		oChk19:nTop := 205
		oChk19:nWidth := 159
		oChk19:nHeight := 17
		oChk19:lShowHint := .F.
		oChk19:lReadOnly := .F.
		oChk19:Align := 0
		oChk19:cVariable := "_lChk19"
		oChk19:bSetGet := {|u| If(PCount()>0,_lChk19:=u,_lChk19) }
		oChk19:lVisibleControl := .T.
		
		oChk20 := TCHECKBOX():Create(oQuadro1)
		oChk20:cName := "oChk20"
		oChk20:cCaption := "Valor do IPI"
		oChk20:nLeft := 226
		oChk20:nTop := 225
		oChk20:nWidth := 159
		oChk20:nHeight := 17
		oChk20:lShowHint := .F.
		oChk20:lReadOnly := .F.
		oChk20:Align := 0
		oChk20:cVariable := "_lChk20"
		oChk20:bSetGet := {|u| If(PCount()>0,_lChk20:=u,_lChk20) }
		oChk20:lVisibleControl := .T.
		
		oChk21 := TCHECKBOX():Create(oQuadro1)
		oChk21:cName := "oChk21"
		oChk21:cCaption := "Base de Cálculo do IPI"
		oChk21:nLeft := 226
		oChk21:nTop := 245
		oChk21:nWidth := 159
		oChk21:nHeight := 17
		oChk21:lShowHint := .F.
		oChk21:lReadOnly := .F.
		oChk21:Align := 0
		oChk21:cVariable := "_lChk21"
		oChk21:bSetGet := {|u| If(PCount()>0,_lChk21:=u,_lChk21) }
		oChk21:lVisibleControl := .T.
		
		oChk22 := TCHECKBOX():Create(oQuadro1)
		oChk22:cName := "oChk22"
		oChk22:cCaption := "Valor Total da Nota Fiscal"
		oChk22:nLeft := 226
		oChk22:nTop := 265
		oChk22:nWidth := 159
		oChk22:nHeight := 17
		oChk22:lShowHint := .F.
		oChk22:lReadOnly := .F.
		oChk22:Align := 0
		oChk22:cVariable := "_lChk22"
		oChk22:bSetGet := {|u| If(PCount()>0,_lChk22:=u,_lChk22) }
		oChk22:lVisibleControl := .T.
		
		oChk23 := TCHECKBOX():Create(oQuadro1)
		oChk23:cName := "oChk23"
		oChk23:cCaption := "Alíquota do ICMS"
		oChk23:nLeft := 226
		oChk23:nTop := 285
		oChk23:nWidth := 159
		oChk23:nHeight := 17
		oChk23:lShowHint := .F.
		oChk23:lReadOnly := .F.
		oChk23:Align := 0
		oChk23:cVariable := "_lChk23"
		oChk23:bSetGet := {|u| If(PCount()>0,_lChk23:=u,_lChk23) }
		oChk23:lVisibleControl := .T.
		
		oChk24 := TCHECKBOX():Create(oQuadro1)
		oChk24:cName := "oChk24"
		oChk24:cCaption := "Base de Cálculo do ICMS"
		oChk24:nLeft := 226
		oChk24:nTop := 305
		oChk24:nWidth := 159
		oChk24:nHeight := 17
		oChk24:lShowHint := .F.
		oChk24:lReadOnly := .F.
		oChk24:Align := 0
		oChk24:cVariable := "_lChk24"
		oChk24:bSetGet := {|u| If(PCount()>0,_lChk24:=u,_lChk24) }
		oChk24:lVisibleControl := .T.
		
		oTxt27 := TSAY():Create(oQuadro1)
		oTxt27:cName := "oTxt27"
		oTxt27:cCaption := "25"
		oTxt27:nLeft := 396
		oTxt27:nTop := 85
		oTxt27:nWidth := 16
		oTxt27:nHeight := 17
		oTxt27:lShowHint := .F.
		oTxt27:lReadOnly := .F.
		oTxt27:Align := 0
		oTxt27:lVisibleControl := .T.
		oTxt27:lWordWrap := .F.
		oTxt27:lTransparent := .T.
		
		oTxt28 := TSAY():Create(oQuadro1)
		oTxt28:cName := "oTxt28"
		oTxt28:cCaption := "26"
		oTxt28:nLeft := 396
		oTxt28:nTop := 105
		oTxt28:nWidth := 16
		oTxt28:nHeight := 17
		oTxt28:lShowHint := .F.
		oTxt28:lReadOnly := .F.
		oTxt28:Align := 0
		oTxt28:lVisibleControl := .T.
		oTxt28:lWordWrap := .F.
		oTxt28:lTransparent := .T.
		
		oTxt29 := TSAY():Create(oQuadro1)
		oTxt29:cName := "oTxt29"
		oTxt29:cCaption := "27"
		oTxt29:nLeft := 396
		oTxt29:nTop := 125
		oTxt29:nWidth := 16
		oTxt29:nHeight := 17
		oTxt29:lShowHint := .F.
		oTxt29:lReadOnly := .F.
		oTxt29:Align := 0
		oTxt29:lVisibleControl := .T.
		oTxt29:lWordWrap := .F.
		oTxt29:lTransparent := .T.
		
		oTxt30 := TSAY():Create(oQuadro1)
		oTxt30:cName := "oTxt30"
		oTxt30:cCaption := "28"
		oTxt30:nLeft := 396
		oTxt30:nTop := 145
		oTxt30:nWidth := 16
		oTxt30:nHeight := 17
		oTxt30:lShowHint := .F.
		oTxt30:lReadOnly := .F.
		oTxt30:Align := 0
		oTxt30:lVisibleControl := .T.
		oTxt30:lWordWrap := .F.
		oTxt30:lTransparent := .T.
		
		oTxt31 := TSAY():Create(oQuadro1)
		oTxt31:cName := "oTxt31"
		oTxt31:cCaption := "29"
		oTxt31:nLeft := 396
		oTxt31:nTop := 165
		oTxt31:nWidth := 16
		oTxt31:nHeight := 17
		oTxt31:lShowHint := .F.
		oTxt31:lReadOnly := .F.
		oTxt31:Align := 0
		oTxt31:lVisibleControl := .T.
		oTxt31:lWordWrap := .F.
		oTxt31:lTransparent := .T.
		
		oTxt32 := TSAY():Create(oQuadro1)
		oTxt32:cName := "oTxt32"
		oTxt32:cCaption := "30"
		oTxt32:nLeft := 396
		oTxt32:nTop := 185
		oTxt32:nWidth := 16
		oTxt32:nHeight := 17
		oTxt32:lShowHint := .F.
		oTxt32:lReadOnly := .F.
		oTxt32:Align := 0
		oTxt32:lVisibleControl := .T.
		oTxt32:lWordWrap := .F.
		oTxt32:lTransparent := .T.
		
		oTxt33 := TSAY():Create(oQuadro1)
		oTxt33:cName := "oTxt33"
		oTxt33:cCaption := "31"
		oTxt33:nLeft := 396
		oTxt33:nTop := 205
		oTxt33:nWidth := 16
		oTxt33:nHeight := 17
		oTxt33:lShowHint := .F.
		oTxt33:lReadOnly := .F.
		oTxt33:Align := 0
		oTxt33:lVisibleControl := .T.
		oTxt33:lWordWrap := .F.
		oTxt33:lTransparent := .T.
		
		oTxt34 := TSAY():Create(oQuadro1)
		oTxt34:cName := "oTxt34"
		oTxt34:cCaption := "32"
		oTxt34:nLeft := 396
		oTxt34:nTop := 225
		oTxt34:nWidth := 16
		oTxt34:nHeight := 17
		oTxt34:lShowHint := .F.
		oTxt34:lReadOnly := .F.
		oTxt34:Align := 0
		oTxt34:lVisibleControl := .T.
		oTxt34:lWordWrap := .F.
		oTxt34:lTransparent := .T.
		
		oTxt35 := TSAY():Create(oQuadro1)
		oTxt35:cName := "oTxt35"
		oTxt35:cCaption := "33"
		oTxt35:nLeft := 396
		oTxt35:nTop := 245
		oTxt35:nWidth := 16
		oTxt35:nHeight := 17
		oTxt35:lShowHint := .F.
		oTxt35:lReadOnly := .F.
		oTxt35:Align := 0
		oTxt35:lVisibleControl := .T.
		oTxt35:lWordWrap := .F.
		oTxt35:lTransparent := .T.
		
		oTxt36 := TSAY():Create(oQuadro1)
		oTxt36:cName := "oTxt36"
		oTxt36:cCaption := "34"
		oTxt36:nLeft := 396
		oTxt36:nTop := 265
		oTxt36:nWidth := 16
		oTxt36:nHeight := 17
		oTxt36:lShowHint := .F.
		oTxt36:lReadOnly := .F.
		oTxt36:Align := 0
		oTxt36:lVisibleControl := .T.
		oTxt36:lWordWrap := .F.
		oTxt36:lTransparent := .T.
		
		oTxt37 := TSAY():Create(oQuadro1)
		oTxt37:cName := "oTxt37"
		oTxt37:cCaption := "35"
		oTxt37:nLeft := 396
		oTxt37:nTop := 286
		oTxt37:nWidth := 16
		oTxt37:nHeight := 16
		oTxt37:lShowHint := .F.
		oTxt37:lReadOnly := .F.
		oTxt37:Align := 0
		oTxt37:lVisibleControl := .T.
		oTxt37:lWordWrap := .F.
		oTxt37:lTransparent := .T.
		
		oTxt38 := TSAY():Create(oQuadro1)
		oTxt38:cName := "oTxt38"
		oTxt38:cCaption := "36"
		oTxt38:nLeft := 396
		oTxt38:nTop := 305
		oTxt38:nWidth := 16
		oTxt38:nHeight := 17
		oTxt38:lShowHint := .F.
		oTxt38:lReadOnly := .F.
		oTxt38:Align := 0
		oTxt38:lVisibleControl := .T.
		oTxt38:lWordWrap := .F.
		oTxt38:lTransparent := .T.
		
		oChk25 := TCHECKBOX():Create(oQuadro1)
		oChk25:cName := "oChk25"
		oChk25:cCaption := "B.C. ICMS Substituição"
		oChk25:nLeft := 417
		oChk25:nTop := 85
		oChk25:nWidth := 159
		oChk25:nHeight := 17
		oChk25:lShowHint := .F.
		oChk25:lReadOnly := .F.
		oChk25:Align := 0
		oChk25:cVariable := "_lChk25"
		oChk25:bSetGet := {|u| If(PCount()>0,_lChk25:=u,_lChk25) }
		oChk25:lVisibleControl := .T.
		
		oChk26 := TCHECKBOX():Create(oQuadro1)
		oChk26:cName := "oChk26"
		oChk26:cCaption := "Valor ICMS Substituição"
		oChk26:nLeft := 417
		oChk26:nTop := 105
		oChk26:nWidth := 159
		oChk26:nHeight := 17
		oChk26:lShowHint := .F.
		oChk26:lReadOnly := .F.
		oChk26:Align := 0
		oChk26:cVariable := "_lChk26"
		oChk26:bSetGet := {|u| If(PCount()>0,_lChk26:=u,_lChk26) }
		oChk26:lVisibleControl := .T.
		
		oChk27 := TCHECKBOX():Create(oQuadro1)
		oChk27:cName := "oChk27"
		oChk27:cCaption := "Termo de Isenção do IPI"
		oChk27:nLeft := 417
		oChk27:nTop := 125
		oChk27:nWidth := 159
		oChk27:nHeight := 17
		oChk27:lShowHint := .F.
		oChk27:lReadOnly := .F.
		oChk27:Align := 0
		oChk27:cVariable := "_lChk27"
		oChk27:bSetGet := {|u| If(PCount()>0,_lChk27:=u,_lChk27) }
		oChk27:lVisibleControl := .T.
		
		oChk28 := TCHECKBOX():Create(oQuadro1)
		oChk28:cName := "oChk28"
		oChk28:cCaption := "Termo de Isenção do ICMS"
		oChk28:nLeft := 417
		oChk28:nTop := 145
		oChk28:nWidth := 159
		oChk28:nHeight := 17
		oChk28:lShowHint := .F.
		oChk28:lReadOnly := .F.
		oChk28:Align := 0
		oChk28:cVariable := "_lChk28"
		oChk28:bSetGet := {|u| If(PCount()>0,_lChk28:=u,_lChk28) }
		oChk28:lVisibleControl := .T.
		
		oChk29 := TCHECKBOX():Create(oQuadro1)
		oChk29:cName := "oChk29"
		oChk29:cCaption := "Peso Bruto/Líquido"
		oChk29:nLeft := 417
		oChk29:nTop := 165
		oChk29:nWidth := 159
		oChk29:nHeight := 16
		oChk29:lShowHint := .F.
		oChk29:lReadOnly := .F.
		oChk29:Align := 0
		oChk29:cVariable := "_lChk29"
		oChk29:bSetGet := {|u| If(PCount()>0,_lChk29:=u,_lChk29) }
		oChk29:lVisibleControl := .T.
		
		oChk30 := TCHECKBOX():Create(oQuadro1)
		oChk30:cName := "oChk30"
		oChk30:cCaption := "Quantidade"
		oChk30:nLeft := 417
		oChk30:nTop := 185
		oChk30:nWidth := 159
		oChk30:nHeight := 17
		oChk30:lShowHint := .F.
		oChk30:lReadOnly := .F.
		oChk30:Align := 0
		oChk30:cVariable := "_lChk30"
		oChk30:bSetGet := {|u| If(PCount()>0,_lChk30:=u,_lChk30) }
		oChk30:lVisibleControl := .T.
		
		oChk31 := TCHECKBOX():Create(oQuadro1)
		oChk31:cName := "oChk31"
		oChk31:cCaption := "Espécie"
		oChk31:nLeft := 417
		oChk31:nTop := 205
		oChk31:nWidth := 159
		oChk31:nHeight := 17
		oChk31:lShowHint := .F.
		oChk31:lReadOnly := .F.
		oChk31:Align := 0
		oChk31:cVariable := "_lChk31"
		oChk31:bSetGet := {|u| If(PCount()>0,_lChk31:=u,_lChk31) }
		oChk31:lVisibleControl := .T.
		
		oChk32 := TCHECKBOX():Create(oQuadro1)
		oChk32:cName := "oChk32"
		oChk32:cCaption := "Nº Inscrição Municipal"
		oChk32:nLeft := 417
		oChk32:nTop := 225
		oChk32:nWidth := 159
		oChk32:nHeight := 17
		oChk32:lShowHint := .F.
		oChk32:lReadOnly := .F.
		oChk32:Align := 0
		oChk32:cVariable := "_lChk32"
		oChk32:bSetGet := {|u| If(PCount()>0,_lChk32:=u,_lChk32) }
		oChk32:lVisibleControl := .T.
		
		oChk33 := TCHECKBOX():Create(oQuadro1)
		oChk33:cName := "oChk33"
		oChk33:cCaption := "Outros"
		oChk33:nLeft := 417
		oChk33:nTop := 245
		oChk33:nWidth := 159
		oChk33:nHeight := 17
		oChk33:lShowHint := .F.
		oChk33:lReadOnly := .F.
		oChk33:Align := 0
		oChk33:cVariable := "_lChk33"
		oChk33:bSetGet := {|u| If(PCount()>0,_lChk33:=u,_lChk33) }
		oChk33:lVisibleControl := .T.
		oChk33:bLClicked := {|| xValidTudo("OU",oOut) }
		
		oChk34 := TCHECKBOX():Create(oQuadro1)
		oChk34:cName := "oChk34"
		oChk34:cCaption := "Código Destino"
		oChk34:nLeft := 417
		oChk34:nTop := 265
		oChk34:nWidth := 159
		oChk34:nHeight := 17
		oChk34:lShowHint := .F.
		oChk34:lReadOnly := .F.
		oChk34:Align := 0
		oChk34:cVariable := "_lChk34"
		oChk34:bSetGet := {|u| If(PCount()>0,_lChk34:=u,_lChk34) }
		oChk34:lVisibleControl := .T.
		
		oChk35 := TCHECKBOX():Create(oQuadro1)
		oChk35:cName := "oChk35"
		oChk35:cCaption := "Peso Líquido"
		oChk35:nLeft := 417
		oChk35:nTop := 285
		oChk35:nWidth := 159
		oChk35:nHeight := 17
		oChk35:lShowHint := .F.
		oChk35:lReadOnly := .F.
		oChk35:Align := 0
		oChk35:cVariable := "_lChk35"
		oChk35:bSetGet := {|u| If(PCount()>0,_lChk35:=u,_lChk35) }
		oChk35:lVisibleControl := .T.
		
		oChk36 := TCHECKBOX():Create(oQuadro1)
		oChk36:cName := "oChk36"
		oChk36:cCaption := "Peso Bruto"
		oChk36:nLeft := 417
		oChk36:nTop := 305
		oChk36:nWidth := 159
		oChk36:nHeight := 17
		oChk36:lShowHint := .F.
		oChk36:lReadOnly := .F.
		oChk36:Align := 0
		oChk36:cVariable := "_lChk36"
		oChk36:bSetGet := {|u| If(PCount()>0,_lChk36:=u,_lChk36) }
		oChk36:lVisibleControl := .T.
		
		oDat := TGET():Create(oQuadro1)
		oDat:cName := "oDat"
		oDat:nLeft := 480
		oDat:nTop := 9
		oDat:nWidth := 71
		oDat:nHeight := 21
		oDat:lShowHint := .F.
		oDat:lReadOnly := .T.
		oDat:Align := 0
		oDat:cVariable := "_cDat"
		oDat:bSetGet := {|u| If(PCount()>0,_cDat:=u,_cDat) }
		oDat:lVisibleControl := .T.
		oDat:lPassword := .F.
		oDat:lHasButton := .F.
		
		oTxt39 := TSAY():Create(oQuadro1)
		oTxt39:cName := "oTxt39"
		oTxt39:cCaption := "Outros"
		oTxt39:nLeft := 368
		oTxt39:nTop := 340
		oTxt39:nWidth := 43
		oTxt39:nHeight := 17
		oTxt39:lShowHint := .F.
		oTxt39:lReadOnly := .F.
		oTxt39:Align := 0
		oTxt39:lVisibleControl := .T.
		oTxt39:lWordWrap := .F.
		oTxt39:lTransparent := .T.
		
		oOut := TGET():Create(oQuadro1)
		oOut:cName := "oOut"
		oOut:nLeft := 415
		oOut:nTop := 336
		oOut:nWidth := 177
		oOut:nHeight := 21
		oOut:lShowHint := .F.
		oOut:lReadOnly := .F.
		oOut:Align := 0
		oOut:cVariable := "_cOut"
		oOut:bSetGet := {|u| If(PCount()>0,_cOut:=u,_cOut) }
		oOut:lVisibleControl := .T.
		oOut:lPassword := .F.
		oOut:Picture := "@!"
		oOut:lHasButton := .F.
		
		oNom := TGET():Create(oQuadro1)
		oNom:cName := "oNom"
		oNom:nLeft := 8
		oNom:nTop := 336
		oNom:nWidth := 354
		oNom:nHeight := 21
		oNom:lShowHint := .F.
		oNom:lReadOnly := .T.
		oNom:Align := 0
		oNom:cVariable := "_cNom"
		oNom:bSetGet := {|u| If(PCount()>0,_cNom:=u,_cNom) }
		oNom:lVisibleControl := .T.
		oNom:lPassword := .F.
		oNom:lHasButton := .F.
		
		oTxt40 := TSAY():Create(oQuadro1)
		oTxt40:cName := "oTxt40"
		oTxt40:cCaption := "Emissão"
		oTxt40:nLeft := 433
		oTxt40:nTop := 12
		oTxt40:nWidth := 48
		oTxt40:nHeight := 17
		oTxt40:lShowHint := .F.
		oTxt40:lReadOnly := .F.
		oTxt40:Align := 0
		oTxt40:lVisibleControl := .T.
		oTxt40:lWordWrap := .F.
		oTxt40:lTransparent := .T.
		
		oQuadro1:Activate()

Return