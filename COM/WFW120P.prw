#Include "rwmake.ch"
#Include "colors.ch"
#Define  _CRLF CHR(13)+CHR(10)

/*
+------------+---------+--------------------------+--------+------------------+
| Programa   | WFW120P | Development by Carraro   |  Data  | 08/11/2001       |
+------------+---------+--------------------------+--------+------------------+
| Descricao  | Ponto de Entrada Para Gravacao dos Descritivos do Ped. Compra  |
+------------+----------------------------------------------------------------+
| Uso        | Exclusivo EPC                                                  |
+------------+----------------------------------------------------------------+
|                    Modificacoes Apos Desenvolvimento Inicial                |
+---------+-------------+-----------------------------------------------------+
|  Data   | Responsavel | Motivo                                              |
+---------+-------------+-----------------------------------------------------+
|05/08/03 |Crislei      |Para impressao dos novos itens Garantia e Instrucoes |
|         |             |de faturamento. Alteracao da ordem de digitacao con- |
|         |             |forme sequencia na impressao do relatorio de PC      |
+---------+-------------+-----------------------------------------------------+
|01/01/06 |Leo Alves    |A restrição foi tirada pela solicitação da Renata TSA|      
|         |             |Pois as mensagens so apareciam se a manutenção do pe |
|         |             |dido, fosse incluida pela propia rotina de geração de| 
|         |             |pedidos de compra, a manutenção de um pedido gerado  |
|         |             |pela rotina decotação não trazia as mensagens.       |
|         |             |Linha 121.                                           |
+---------+-------------+-----------------------------------------------------+
|21/06/11 |Gilson Lucas |Adequacoes para TSA eliminando referencias da EPC.   |
+---------+-------------+-----------------------------------------------------+
*/ 
User Function WFW120P()
*******************************************************************************
*
**
Local aAreaOld := GetArea()
Local aAreaSC7 := SC7->(GetArea())
Local nXi := 0

If  Funname() $ 'MATA121|ENCPEDC' 
	If Altera .and. !Empty(aSC7Old) .and. Empty(aItenDiv)
		dbSelectArea("SC7")
		For nXi := 1 To Len(aSC7Old)     
			SC7->(dbGoTo(aSC7Old[nXi][1]))
			If !SC7->(Eof())
				If RecLock("SC7",.F.)
					Replace C7_CONAPRO 	With aSC7Old[nXi][2]
					Replace C7_APROV 	With aSC7Old[nXi][3]
					SC7->(MsUnLock())
				EndIf
			EndIf
		Next nXi 
   	EndIf
EndIf

If l120Auto
	Return(.T.)
Endif

If MsgBox("Deseja carregar mensagens padrao do contrato?","Atencao","YESNO",2)
   DialMsgFim()
EndIf

RestArea(aAreaOld)
RestArea(aAreaSC7)

Return(.T.)



Static Function DialMsgFim()
*******************************************************************************
*
**
Local oDlg        
Local lConfirm    := .F.
Local aObjects 	  := {}
Local aPosObj     := {}
Local cMarCont    := Iif(!Empty(SC7->C7_MARCOS),SC7->C7_MARCOS,"")
Local cEscopo     := Iif(!Empty(SC7->C7_ESCOPO),SC7->C7_ESCOPO,"")
Local cCondGerais := Iif(!Empty(SC7->C7_CONDGER),SC7->C7_CONDGER,MemoRead( "\Cond_Gerais\Cond_gerais.txt"))
Local lFlatMode   := If(FindFunction("FLATMODE"),FlatMode(),SetMDIChild())
Local aSize    	  := MsAdvSize(.T.,.F.,Iif(lFlatMode,330,300)) //(lEnchoiceBar,lTelaPadrao,ntamanho_linhas)
Local aInfo    	  := {aSize[1],aSize[2],aSize[3],aSize[4],3,3}
Local oFont       := TFont():New( "Arial",,14,,.T.,,,,.F.,.F. )
Private cA120Num  := SC7->C7_NUM

Aadd(aObjects,{010,030,.T.,.F.,.F.}) //{TamX,TamY,DimX,DimY,lDimensaoXeY}
Aadd(aObjects,{010,050,.T.,.T.,.F.}) //{TamX,TamY,DimX,DimY,lDimensaoXeY}
Aadd(aObjects,{010,050,.T.,.T.,.F.}) //{TamX,TamY,DimX,DimY,lDimensaoXeY}
Aadd(aObjects,{010,100,.T.,.T.,.F.}) //{TamX,TamY,DimX,DimY,lDimensaoXeY}
aPosObj := MsObjSize(aInfo,aObjects)

oDlg:=MSDialog():New(aSize[7],0,aSize[6],aSize[5],OemToAnsi(cCadastro),,,,,,,,,.t.)
oDlg:lEscClose  := .F. //Nao permite sair ao se pressionar a tecla ESC.
oDlg:lMaximized := .T.

TGroup():New(aPosObj[1,1],aPosObj[1,2]+05,aPosObj[1,3],(aPosObj[1,4]-aPosObj[1,2]-5),"",oDlg,,,.T.,.T.)
TSay():New(aPosObj[1,1]+10,015,{|| OemToAnsi("Esta Rotina Tem o Intuito de Informar ao Sistema Os Detalhes Do Pedido de Compras Para Posterior Impressao, Caso Nao Sejam Necessarios Tais Detalhes Apenas Clique no Botao de Cancelamento.")},oDlg,,oFont,,,,.T.,,,560,050)
	
TGroup():New(aPosObj[2,1],aPosObj[2,2]+05,aPosObj[2,3],(aPosObj[2,4]-aPosObj[2,2]-5),OemToAnsi("Escopo"),oDlg,,,.T.,.T.)
TMultiGet():New(aPosObj[2][1]+10,aPosObj[2][2]+10,{|u|If(Pcount()>0,cEscopo:=u,cEscopo)},oDlg        ,(aPosObj[2][4]-aPosObj[2][2])-30,(aPosObj[2][3]-aPosObj[2][1])-30,,.T.,,,,.T.,,,,,,.F.,,,,.F.,.T.)

TGroup():New(aPosObj[3,1],aPosObj[3,2]+05,aPosObj[3,3],(aPosObj[3,4]-aPosObj[3,2]-5),OemToAnsi("Marcos contratuais"),oDlg,,,.T.,.T.)
TMultiGet():New(aPosObj[3][1]+10,aPosObj[3][2]+10,{|u|If(Pcount()>0,cMarCont:=u,cMarCont)},oDlg        ,(aPosObj[3][4]-aPosObj[3][2])-30,(aPosObj[3][3]-aPosObj[3][1])-30,,.T.,,,,.T.,,,,,,.F.,,,,.F.,.T.)


TGroup():New(aPosObj[4,1],aPosObj[4,2]+05,aPosObj[4,3],(aPosObj[4,4]-aPosObj[4,2]-5),OemToAnsi("Condições Gerais"),oDlg,,,.T.,.T.)
TMultiGet():New(aPosObj[4][1]+10,aPosObj[4][2]+10,{|u|If(Pcount()>0,cCondGerais:=u,cCondGerais)},oDlg,(aPosObj[4][4]-aPosObj[4][2])-30,(aPosObj[4][3]-aPosObj[4][1])-30,,.T.,,,,.T.,,,,,,.F.,,,,.F.,.T.)


oDlg:Activate(,,,.t.,, EnchoiceBar(oDlg,{|| lConfirm := .T.,oDlg:End()   },{|| oDlg:End()},,{}))

If lConfirm
   dbSelectArea("SC7")
   SC7->(dbSetOrder(1))
   SC7->(dbSeek(xFilial("SC7")+cA120Num))
   While !SC7->(Eof()) .And. SC7->(C7_FILIAL+C7_NUM) == xFilial("SC7")+cA120Num
      If RecLock("SC7",.F.)
         Replace C7_CONDGER With cCondGerais,;
                 C7_ESCOPO  With cEscopo,;
                 C7_MARCOS  With cMarCont
         SC7->(MsUnlock())
      EndIf 
      SC7->(DbSkip())
   EndDo
EndIf

Return


/*
Local   aArqAn     :=GetArea()
Local   aRet       := {}
Local   nXi        := 0
Local   aAreaOld   := Getarea()
Local   aAreaSC7   := SC7->(GetArea())

Private oDlgFirst
Private cDetCondi
Private cDetDocto
Private cDetPrazo
Private cDetPreco
Private cDetLocal
Private cDetGaran
Private cDetFatur
Private cDetInpec
Private cDetConfi
Private cDetOutro
Private lConfirma  :=.f.
Private aVetTSA    := {}

Private cA120Num := SC7->C7_NUM


Aadd(aVetTSA, {"1 _Condicoes Gerais"			,OemToAnsi("1 - CONDIÇÕES GERAIS DE FORNECIMENTO")})
Aadd(aVetTSA, {"2 E_ntrega/Embalagem" 		,OemToAnsi("2 - PRAZO DE ENTREGA / TRANSPORTE / EMBALAGEM")})
Aadd(aVetTSA, {"3 _Garantia"				,OemToAnsi("3 - GARANTIA")})
Aadd(aVetTSA, {"4 _Multa" 					,OemToAnsi("4 - MULTA")})
Aadd(aVetTSA, {"5 _Inpecao"	,OemToAnsi("5 - INSPEÇÃO E CERTIFICAÇÃO DOS MATERIAIS E PROCEDIMENTOS UTILIZADOS")})
Aadd(aVetTSA, {"6 Re_scisão" 				,OemToAnsi("6 - RESCISÃO")})
Aadd(aVetTSA, {"7 F_oro"					,OemToAnsi("7 - FORO")})
Aadd(aVetTSA, {"8 Con_firmação"			    ,OemToAnsi("8 - CONFIRMAÇÃO DO PEDIDO")})
Aadd(aVetTSA, {"9 Obs _Embarque" 		    , OemToAnsi("9 - OBSERVAÇÕES PARA EMBARQUE E SUBSTITUIÇÃO TRIBUTÁRIA")})
Aadd(aVetTSA, {"10 Obs _Geral"				,OemToAnsi("10 - OBSERVAÇÃO GERAL")})

If Funname() == 'MATA121'
	If Altera .and. !Empty(aSC7Old) .and. Empty(aItenDiv)
		dbSelectArea("SC7")
		For nXi := 1 To Len(aSC7Old)     
			SC7->(dbGoTo(aSC7Old[nXi][1]))
			If !SC7->(Eof())
				If RecLock("SC7",.F.)
					Replace C7_CONAPRO With aSC7Old[nXi][2]
					SC7->(MsUnLock())
				EndIf
			EndIf
		Next nXi 
   	EndIf
EndIf
     
aItenDiv := {}
aSC7Old  := {}
RestArea(aAreaOld)
RestArea(aAreaSC7)   



If l120Auto
	Return(.T.)
Endif

//Posiciona pra pegar Memos
dbSelectArea("SC7")
SC7->(dbSetOrder(1))
SC7->(dbSeek(xFilial("SC7")+cA120Num))
   

cDetCondi := IIf(INCLUI,"",SC7->C7_DETCD) //Condicoes    01
cDetPrazo := IIf(INCLUI,"",SC7->C7_DETPZ) //Prazo        02
cDetGaran := IIf(INCLUI,"",SC7->C7_DETGR) //Garantia     03
cDetPreco := IIf(INCLUI,"",SC7->C7_DETPR) //Preco        04
cDetInpec := IIf(INCLUI,"",SC7->C7_DETIN) //Inspecao     05
cDetOutro := IIf(INCLUI,"",SC7->C7_DETOU) //Outros       06
cDetLocal := IIf(INCLUI,"",SC7->C7_DETLC) // Loc. Entr.  07
cDetConfi := IIf(INCLUI,"",SC7->C7_DETCF) //Confirmacao  08
cDetFatur := IIf(INCLUI,"",SC7->C7_DETFT) //Inst Faturam 09
cDetDocto := IIf(INCLUI,"",SC7->C7_DETDC) //Documentos   10

lDetCondi := Empty(cDetCondi)
lDetPrazo := Empty(cDetPrazo)
lDetGaran := Empty(cDetGaran)
lDetPreco := Empty(cDetPreco)
lDetInpec := Empty(cDetInpec)
lDetOutro := Empty(cDetOutro)
lDetLocal := Empty(cDetLocal)
lDetConfi := Empty(cDetConfi)
lDetFatur := Empty(cDetFatur)
lDetDocto := Empty(cDetDocto)



If MsgBox("Deseja carregar mensagens padrao do contrato?","Atencao","YESNO",2)
   If !INCLUI
      aRet := FCarrMens()
      For nXi := 1 To Len(aRet)
          For nYi := 1 To Len(aRet[nXi])
              Do Case
                 Case nXi == 1
                      If lDetCondi
                         cDetCondi += aRet[nXi][nYi]+ _CRLF
                      EndIf   
                 Case nXi == 2
                      If lDetPrazo
                         cDetPrazo += aRet[nXi][nYi]+ _CRLF
                      EndIf   
                 Case nXi == 3
                      If lDetGaran
                         cDetGaran += aRet[nXi][nYi]+ _CRLF
                      EndIf   
                 Case nXi == 4
                      If lDetPreco
                         cDetPreco += aRet[nXi][nYi]+ _CRLF
                      EndIf   
                 Case nXi == 5
                      If lDetInpec
                         cDetInpec += aRet[nXi][nYi]+ _CRLF
                      EndIf   
                 Case nXi == 6
                      If lDetOutro
                         cDetOutro += aRet[nXi][nYi]+ _CRLF
                      EndIf   
                 Case nXi == 7
                      If lDetLocal
                         cDetLocal += aRet[nXi][nYi]+ _CRLF
                      Endif   
                 Case nXi == 8
                      If lDetConfi
                         cDetConfi += aRet[nXi][nYi]+ _CRLF
                      EndIf   
                 Case nXi == 9
                      If lDetFatur
                         cDetFatur += aRet[nXi][nYi]+ _CRLF
                      EndIf   
                 Case nXi == 10
                      If lDetDocto
                         cDetDocto += aRet[nXi][nYi]+ _CRLF
                      EndIf   
              EndCase
          Next nYi 
      Next nXi
   EndIf
   //nValTotal:= MaFisRet(,"NF_TOTAL")
   //cDetPreco := StrTran(cDetPreco,"@VALEXTENSO", "R$ "+Alltrim(Str(nValTotal,14,2))+" ("+ Alltrim(Extenso(nValTotal))+")")
   //cDetLocal := StrTran(cDetLocal,"@PRZENTREGA", Dtoc(SC7->C7_DATPRF) )
Else
   lConfirma := .T.
EndIf

While !lConfirma
	@ 000,000 To 250,500 DIALOG oDlgFirst Title "Detalhes do Pedido"
	@ 005,005 To 050,245 Title "Atencao"
	@ 012,010 SAY "Esta Rotina Tem o Intuito de Informar ao Sistema Os Detalhes Do Pedido de Compras Para" Color CLR_HBLUE Size 230,07
	@ 025,010 SAY "Posterior Impressao, Caso Nao Sejam Necessarios Tais Detalhes Apenas Clique no Botao  " Color CLR_HBLUE Size 230,07
	@ 037,010 SAY "de Cancelamento." Color CLR_HBLUE Size 200,07
	
	@ 055,005 To 115,245
	//	   @ 065,010 BUTTON "_Cond. Gerais" 		    Size 45,12 Action FDialog(2)
	
	@ 065,010 BUTTON aVetTSA[01][1]	Size 70,12 Action FDialTsa(01)
	@ 065,085 BUTTON aVetTSA[02][1] Size 70,12 Action FDialTsa(02)
	@ 065,160 BUTTON aVetTSA[03][1] Size 70,12 Action FDialTsa(03)
	
	@ 080,010 BUTTON aVetTSA[04][1] Size 45,12 Action FDialTsa(04)
	@ 080,060 BUTTON aVetTSA[05][1] Size 70,12 Action FDialTsa(05)
	@ 080,135 BUTTON aVetTSA[06][1] Size 45,12 Action FDialTsa(06)
	@ 080,185 BUTTON aVetTSA[07][1] Size 45,12 Action FDialTsa(07)
	
	@ 095,010 BUTTON aVetTSA[08][1]	Size 45,12 Action FDialTsa(08)
	@ 095,060 BUTTON aVetTSA[09][1]	Size 45,12 Action FDialTsa(09)
	@ 095,110 BUTTON aVetTSA[10][1] Size 45,12 Action FDialTsa(10)
	
	@ 095,170 BMPBUTTON Type 01 Action FConfGrav()
	@ 095,200 BMPBUTTON Type 02 Action FCancGrav()
	
	Activate Dialog oDlgFirst Centered
	
EndDo

Restarea(aArqAn)

Return(.T.)



Static Function FConfGrav()
***********************************************************************************
* Confirmacao de Gravacao
*
***

Local oDlgSecond
Local cDiscipl:=IIf(INCLUI,Space(02),SC7->C7_DISCIPL)
Local cGerenci:=IIf(INCLUI,Space(02),SC7->C7_GERENCI)


   lConfirma := .t.
   Close(oDlgFirst)
   dbSelectArea("SC7")
   SC7->(dbSetOrder(1))
   SC7->(dbSeek(xFilial("SC7")+cA120Num))
   While !SC7->(Eof()) .And. SC7->(C7_FILIAL+C7_NUM) == xFilial("SC7")+cA120Num
      If RecLock("SC7",.F.)
         Replace C7_DETCD With cDetCondi,;
                 C7_DETPZ With cDetPrazo,;
                 C7_DETGR With cDetGaran,;
                 C7_DETPR With cDetPreco,;
                 C7_DETIN With cDetInpec,;
                 C7_DETOU With cDetOutro,;
                 C7_DETLC With cDetLocal,;
                 C7_DETCF With cDetConfi,;
                 C7_DETFT With cDetFatur,;
                 C7_DETDC With cDetDocto
         SC7->(MsUnlock())
      EndIf 
      SC7->(DbSkip())
   EndDo


Return
            


Static Function FCancGrav()
***********************************************************************************
* Cancelamento de Gravacao
*
***

   lConfirma := .t.
   Close(oDlgFirst)


Return



Static Function FDialTsa(nTipo)
************************************************************************************
* Dialog de Detalhes
*
***

Do Case
   Case nTipo == 1
        cDetCondi := FTelaDet(nTipo,cDetCondi)
   Case nTipo == 2
		cDetPrazo := FTelaDet(nTipo,cDetPrazo)
   Case nTipo == 3
		cDetGaran := FTelaDet(nTipo, cDetGaran)
   Case nTipo == 4
		cDetPreco := FTelaDet(nTipo, cDetPreco)
   Case nTipo == 5
		cDetInpec := FTelaDet(nTipo, cDetInpec)
   Case nTipo == 6
		cDetOutro := FTelaDet(nTipo, cDetOutro)
   Case nTipo == 7
		cDetLocal := FTelaDet(nTipo, cDetLocal)
   Case nTipo == 8
		cDetConfi := FTelaDet(nTipo, cDetConfi)
   Case nTipo == 9
		cDetFatur := FTelaDet(nTipo, cDetFatur)
   Case nTipo == 10
		cDetDocto := FTelaDet(nTipo, cDetDocto)
EndCase

Return



Static Function FTelaDet(nTipo, cDetMens)
************************************************************************************
* Dialog de Detalhes
*
***

Local oDlgAux

@ 000,000 To 210,500 DIALOG oDlgAux Title "Dados Adicionais do Pedido"
@ 005,005 To 090,245 Title aVetTSA[nTipo][2]
@ 020,010 Get cDetMens Size 230,060 MEMO
@ 093,210 BMPBUTTON Type 01 Action Close(oDlgAux)

Activate Dialog oDlgAux Centered

Return(cDetMens)



Static Function FCarrMens()
************************************************************************************
* Carrega mensagens
*
***
Local nXi       := 0
Local nHandle   := 0
Local cArqUse   := ""
Local cPathArqs := GetNewpar("NM_PATHARQ","\Cond_Gerais\")
Local aRet      := {{},; // 01.*
                    {},; // 02.*
                    {},; // 03.*
                    {},; // 04.*
                    {},; // 05.*
                    {},; // 06.*
                    {},; // 07.*
                    {},; // 08.*
                    {},; // 09.*
                    {}}  // 10.*                                                                                                                        


For nXi := 1 To 10 
    If File(cPathArqs+"Arq_"+StrZero(nXi,3)+".txt")
       // Abre o arquivo
       nHandle := FT_FUse(cPathArqs+"Arq_"+StrZero(nXi,3)+".txt")
       If nHandle != -1 // Se houver erro de abertura abandona processamento
          
          FT_FGoTop() // Posiciona na primeria linha
          
          While !FT_FEOF() 
              Aadd(aRet[nXi],FT_FReadLn())
              FT_FSKIP()
          End
          FT_FUSE()// Fecha o Arquivo
       EndIf
    EndIf          
Next nXi


Aaad(aRet[01],OemToAnsi("CONDIÇÕES GERAIS DE FORNECIMENTO"))
Aaad(aRet[01],OemToAnsi("1 - PREÇO E FATURAMENTO"))
Aaad(aRet[01],OemToAnsi("1.1 - O preço total deste fornecimento com todos os impostos inclusos como indicado neste Pedido de Compra é fixo e irreajustável"))
Aaad(aRet[01],OemToAnsi("1.2 – É vedado ao FORNECEDOR a cobrança via boleto bancário das faturas ou de outros documentos de crédito oriundos deste "))
Aaad(aRet[01],OemToAnsi("fornecimento assim como a caução ou negociação  de quaisquer créditos a receber da TSA com base neste instrumento."))
Aaad(aRet[01],OemToAnsi("1.3 - Local da apresentação da cobrança: Conforme cabeçalho deste Pedido de Compra. Os dados para depósito bancário devem"))
Aaad(aRet[01],OemToAnsi("constar na nota  fiscal."))
Aaad(aRet[01],OemToAnsi("1.4 -  No caso de serviços, o faturamento das notas fiscais deve ocorrer até o dia 20 de cada mês. Caso seja necessário faturar depois"))
Aaad(aRet[01],OemToAnsi("desta data, utilizar a data do dia 1º do mês subseqüente. Somente serão aceitas notas fiscais de serviço na TSA que estejam dentro dessas datas."))
Aaad(aRet[01],OemToAnsi("1.5 - Para se habilitar ao recebimento do pagamento, deverá ser comprovado o recolhimento das obrigações devidas aos órgãos"))
Aaad(aRet[01],OemToAnsi("competentes dos valores relativos ao INSS das contribuições que são próprios e os depósitos referentes ao FGTS, na forma de lei, dos"))
Aaad(aRet[01],OemToAnsi("empregados utilizados na execução dos trabalhos, cuja relação deverá estar anexada a cada medição apresentada."))
Aaad(aRet[01],OemToAnsi("1.6 - A Nota fiscal de serviços deverá vir acompanhada, obrigatoriamente, dos seguintes documentos:"))
Aaad(aRet[01],OemToAnsi("1.6.1 - Relatório SEFIP"))

Aaad(aRet[01],OemToAnsi("(Sistema Empresa de Recolhimento do FGTS e Informações à Previdência Social) analítico, contendo todos os funcionários locados junto a obra deste contrato;"))
Aaad(aRet[01],OemToAnsi("1.6.2 - GPS (Guia da Previdência Social), comprovando o recolhimento do INSS, em valores coincidentes com os declarados na SEFI"))
Aaad(aRet[01],OemToAnsi("1.6.3 - GR FGTS (Guia de Recolhimento do FGTS), comprovando o recolhimento dos valores declarados na SEFI"))
Aaad(aRet[01],OemToAnsi("1.6.4 - Comprovação de pagamento dos salários mensais, dos profissionais que executarem serviços do escopo deste contrato"))
Aaad(aRet[01],OemToAnsi("1.6.5 - Comprovação de quitação das verbas rescisórias dos profissionais que executarem serviços do escopo deste contrato, e que"))
Aaad(aRet[01],OemToAnsi("venham a ser demitidos, caso aplicável"))
Aaad(aRet[01],OemToAnsi("1.6.6 - Comprovação de quitação da GRRF-FGTS (Guia de Recolhimernto das Recisões do FGTS), dos profissionais que executare"))
Aaad(aRet[01],OemToAnsi("serviços do escopo deste contrato, e que tenham sido demitidos, caso aplicável."))

Aaad(aRet[02],OemToAnsi("2 - PRAZO DE ENTREGA / TRANSPORTE / EMBALAGEM"))
Aaad(aRet[02],OemToAnsi("2.1 - Prazo de entrega: Um eventual atraso na entrega sujeitará o FORNECEDOR às penalidades previstas neste Pedido de Compra"))
Aaad(aRet[02],OemToAnsi("e em suas respectivas Condições Gerais de Fornecimento, devendo  o prazo de pagamento ser renegociado."))
Aaad(aRet[02],OemToAnsi("2.2 - Se o frete for por conta do FORNECEDOR (CIF), os materiais serão transportados por uma empresa de sua contratação cabendo"))
Aaad(aRet[02],OemToAnsi("ao FORNECEDOR arcar com todas as despesas do frete. A TSA deverá ser informada do nome da Transportadora empregada e do"))
Aaad(aRet[02],OemToAnsi("telefone de contato e do número do Conhecimento do Transporte. Deverá constar do corpo da Nota Fiscal a  responsabilidade pelo"))
Aaad(aRet[02],OemToAnsi("pagamento do frete."))
Aaad(aRet[02],OemToAnsi("2.3 - Se o frete for por conta da TSA (FOB), os materiais serão transportados por uma empresa de sua contratação cabendo a TSA"))
Aaad(aRet[02],OemToAnsi("arcar com todas as despesas do frete. A TSA deverá ser informada da disponibilidade para embarque com antecedência de 24 horas para que"))
Aaad(aRet[02],OemToAnsi("possa escolher e acionar a transportadora. Deverá constar do corpo da nota fiscal que a responsabilidade pelo pagamento do frete é da"))
Aaad(aRet[02],OemToAnsi("TSA (CNPJ 41.857.780/0001-78), evitando os transtornos da cobrança indevida."))
Aaad(aRet[02],OemToAnsi("2.4 - O FORNECEDOR somente poderá faturar e embarcar os materiais mediante autorização da TSA."))
Aaad(aRet[02],OemToAnsi("2.5 - O FORNECEDOR é responsável pelo fornecimento e pelo adequado acondicionamento do material visando a necessária proteção,"))
Aaad(aRet[02],OemToAnsi("sem qualquer ônus para a TSA,  de forma a evitar esforço, deformação ou avarias durante a operação de transporte e eventuais"))
Aaad(aRet[02],OemToAnsi("manuseios."))
Aaad(aRet[02],OemToAnsi("2.6 – A embalagem deverá ser apropriada para transporte rodoviário e deverá proteger os materiais contra impactos, poeira e umidade"))
Aaad(aRet[02],OemToAnsi("pelo período de até 60 (sessenta) dias."))
		

Aaad(aRet[03],OemToAnsi("3 - GARANTIA"))
Aaad(aRet[03],OemToAnsi("3.1 - Os materiais  fornecidos são  garantidos contra defeitos de fabricação pelo período mínimo de 18 (dezoito)  meses contados  após"))
Aaad(aRet[03],OemToAnsi("a entrega ou de 12 (doze) meses do início da operação (start-up) ficando o FORNECEDOR responsável pela reposição imediata  caso"))
Aaad(aRet[03],OemToAnsi("apresentem defeito, sem ônus para a TSA."))


Aaad(aRet[04],OemToAnsi("4 - MULTA"))
Aaad(aRet[04],OemToAnsi("4.1 - Na hipotese de rescisão, não cumprimento da data de entrega ou de outra obrigação citada na Ordem de Compra"))
Aaad(aRet[04],OemToAnsi("ou nestas Condições Gerais de Fornecimento, o FORNECEDOR ficará sujeito a  multa moratoria de 10% (dez por cento) do valor previsto para o"))
Aaad(aRet[04],OemToAnsi("fornecimento  com a atualização monetaria com base na variação IGPM / FGV verificada desde a data de emissão desta OC até a data"))
Aaad(aRet[04],OemToAnsi("do pagamento da multa. As multas porventura aplicadas serão consideradas dívidas liquidas e certas ficando a TSA autorizada a"))
Aaad(aRet[04],OemToAnsi("descontá-las dos pagamentos devidos ao FORNECEDOR ou ainda cobrá-las judicialmente."))


Aaad(aRet[05],OemToAnsi("5 - INSPEÇÃO E CERTIFICAÇÃO DOS MATERIAIS E PROCEDIMENTOS UTILIZADOS"))
Aaad(aRet[05],OemToAnsi("5.1 - A inspeção será visual, dimensional e funcional quando do recebimento  dos materiais na TSA de forma a verificar se "))
Aaad(aRet[05],OemToAnsi("o fornecimento em questão está em conformidade com esta Ordem de Compra mas não eximirá o FORNECEDOR da garantia prevista no"))
Aaad(aRet[05],OemToAnsi("item 5 acima."))
Aaad(aRet[05],OemToAnsi("5.2 - O FORNECEDOR deverá entregar à TSA, juntamente com a Nota Fiscal da venda , os Certificados de Qualidade do Material e"))
Aaad(aRet[05],OemToAnsi("testes, alem dos Manuais de Instalação, Operação e Manutenção"))


Aaad(aRet[06],OemToAnsi("6 - RESCISÃO"))
Aaad(aRet[06],OemToAnsi("6.1 - A presente Ordem de Compra poderá ser rescindida mediante aviso escrito, independentemente de comunicação judicial, em"))
Aaad(aRet[06],OemToAnsi("quaisquer dos seguintes casos:"))
Aaad(aRet[06],OemToAnsi("a)   Descumprimento de qualquer cláusula, condição ou disposição deste Contrato;"))
Aaad(aRet[06],OemToAnsi("b)   Falência, recuperação judicial, dissolução total e liquidação judicial ou extrajudicial requeridas ou homologadas;"))
Aaad(aRet[06],OemToAnsi("c)   Incapacidade técnica, negligência ou má fé do FORNECEDOR,  devidamente comprovada."))
Aaad(aRet[06],OemToAnsi("d)   Interrupção dos serviços pela ocorrência de casos fortuito ou de força maior."))
Aaad(aRet[06],OemToAnsi("6.2 – No caso de rescisão por inadimplência do Fornecedor, na forma do item 7.1 acima, este pagará a TSA multa e incorrerá nas"))
Aaad(aRet[06],OemToAnsi("penalidades contratuais constantes do item 6 desta Ordem de Compra."))

Aaad(aRet[07],OemToAnsi("7 - FORO"))
Aaad(aRet[07],OemToAnsi("Fica eleito o foro da Cidade e Comarca de Belo Horizonte / MG para dirimir as dúvidas vinculadas a este contrato, renunciando  as partes"))
Aaad(aRet[07],OemToAnsi("a qualquer outro por mais privilegiado que seja."))

Aaad(aRet[08],OemToAnsi("8 - CONFIRMAÇÃO DO PEDIDO"))
Aaad(aRet[08],OemToAnsi("O FORNECEDOR deve dar o aceite deste Pedido de Compra e das suas condições no prazo máximo de 01 (um) dia útil após o"))
Aaad(aRet[08],OemToAnsi("recebimento da mesma. Favor vistar todas as folhas."))


Aaad(aRet[09],OemToAnsi("9 - OBSERVAÇÕES PARA EMBARQUE E SUBSTITUIÇÃO TRIBUTÁRIA"))
Aaad(aRet[09],OemToAnsi("Como contribuintes do fisco de Minas Gerais, estamos sujeitos à Substituição Tributária prevista pela Legislação Mineira do ICMS. Caso"))
Aaad(aRet[09],OemToAnsi("a mercadoria constante neste Pedido de Compra esteja sujeito a este regime, o material não deve sair do estabelecimento de V.Sas. sem"))
Aaad(aRet[09],OemToAnsi("que tenhamos recebido cópia da nota fiscal emitida e encaminhado cópia do comprovante do recolhimento do tributo como devido para"))
Aaad(aRet[09],OemToAnsi("que este acompanhe o material durante o transporte; para tanto, deve a TSA, ser avisada para que proceda em conformidade com o"))
Aaad(aRet[09],OemToAnsi("estabelecido na Lei. Caso esta solicitação não seja observada, a TSA eximir-se-á da responsabilidade do pagamento das multas"))
Aaad(aRet[09],OemToAnsi("possivelmente lavradas bem como pelas decorrências da apreensão da mercadoria, alem  de todas outras cominações decorrentes."))
Aaad(aRet[09],OemToAnsi("Para evitar o acima explicitado, a mercadoria só deve ser embarcada após o recebimento da guia PAGA da Substituição Tributária e da"))
Aaad(aRet[09],OemToAnsi("autorização da TSA."))

Aaad(aRet[10],OemToAnsi("10 - OBSERVAÇÃO GERAL"))
Aaad(aRet[10],OemToAnsi("Se no vencimento da fatura não tenha sido constatado o seu pagamento, entrar em contato imediatamente com o Suprimentos da TSA -"))
Aaad(aRet[10],OemToAnsi("tel.: 31-3055-5000 ou pelo e-mail suprimentos@tsamg.com.br."))
*/
Return(aRet)