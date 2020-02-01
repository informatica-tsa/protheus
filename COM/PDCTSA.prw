#include "rwmake.ch"

/*
+------------+---------+--------------------------+--------+------------------+
| Programa   | PDCTSA  | Development by Carraro   |  Data  | 09/11/2001       |
+------------+---------+--------------------------+--------+------------------+
| Descricao  | Chamada do Pedido de Compras passando Parametros(Crystal)      |
|            | Baseado no relatorio da EPC PEDCOM.prw e PEDCOM.rpt            |
+------------+----------------------------------------------------------------+
| Uso        | Especifico                                                     |
+------------+----------------------------------------------------------------+
|                    Modificacoes Apos Desenvolvimento Inicial                |
+---------+-------------+-----------------------------------------------------+
|  Data   | Responsavel | Motivo                                              |
|         |             |                                                     |
+---------+-------------+-----------------------------------------------------+
*/

User Function PDCTSA()

Local cPedido
Local aAreaOld	:= GetArea()
Local lChamaRel:= .f.
Local cOrdem	:= "T-SC"
Local cSubCta	:= "Desconhecido"
Local cDescSub	:= "Desconhecido"
Local cContrato := "Desconhecido"
Local cDescCont := "Desconhecido"
Local nXy
Local cQuery:= ""
Local cCrysDa:= ""
Local cPerg := "PDCTSA"
Local nXi := 0

Private cDesc1:= cDesc2:= cDesc3:= cDesc4:= cDesc5:= ""

//Mata Registros das tabelas utilizadas
TCSQLEXEC("DELETE FROM " + RetSqlName("SZF"))
TCSQLEXEC("DELETE FROM " + RetSqlName("SZG"))
TCSQLEXEC("DELETE FROM " + RetSqlName("SZH"))

//Cria perguntas
AjustaSX1(cPerg)              

//Chamada dos parametros
If !Pergunte(cPerg, .T.)
	Return
EndIF

//cCrysDa:=MV_PAR07
cPedido:=MV_PAR01

MaFisEnd()
MaFisIniPC(cPedido)

//Montagem do Cabecalho do Pedido (SZF)
DbSelectArea("SC7")
DbSetOrder(1)
If DbSeek(xFilial("SC7")+cPedido)
   DbSelectArea("SZ2") //Procurar Nome Sub-Conta
   DbSetOrder(3) //Subcta
   If DbSeek(xFilial("SZ2")+SC7->C7_CC)
      cSubCta := SC7->C7_CC
      cDescSub:= SZ2->Z2_DESC   
      DbSelectArea("SZ1") //Procurar por Contrato
      DbSetOrder(1)
      If DbSeek(xFilial("SZ1")+SZ2->Z2_COD)
         cContrato:=SZ2->Z2_COD		 
		 cDescCont:=SZ1->Z1_CLIENTE //cDescCont:=SZ1->Z1_NOMINT
      EndIf
   EndIf

   //Busca solicitacao de compras
   DbSelectArea("SC1")
   DbSetOrder(1)
   DbSeek(xFilial("SC1")+SC7->C7_NUMSC+SC7->C7_ITEMSC)

   DbSelectArea("SZF")
   If RecLock("SZF",.t.)
      Replace ZF_FILIAL  With xFilial("SZF")
      Replace ZF_ORDEM   With cOrdem
      Replace ZF_GERENCI With SC7->C7_GERENCI
      Replace ZF_DISCIPL With SC7->C7_DISCIPL
      Replace ZF_EMISSAO With SC7->C7_EMISSAO
      Replace ZF_PEDIDO  With SC7->C7_NUM      
      Replace ZF_CONTRAT With cContrato
      Replace ZF_DESCONT with cDescCont //Criar
      Replace ZF_SUBCTA  With cSubCta
      Replace ZF_DESSUB  With cDescSub //Criar
      Replace ZF_ESCOPO  With SubStr(MemoTran(SC7->C7_DETES," "," "),1,512)      
      Replace ZF_FORNECE With SC7->C7_FORNECE
      Replace ZF_LOJA    With SC7->C7_LOJA
      Replace ZF_VALOR   With MaFisRet(,"NF_TOTAL")
      Replace ZF_NEPC    With SC7->C7_NEPC
      Replace ZF_ORDCOM  With SC7->C7_ORDCOM
      Replace ZF_CC      With SC7->C7_CC
      If GetMv("MV_MCONTAB") == "CON" //CONVERSAO SIGACON P/ SIGACTB
      	Replace ZF_DESCCC  With Posicione("SI3",1,xFilial("SI3")+SC7->C7_CC,"I3_DESC")
      else
      	Replace ZF_DESCCC  With Posicione("CTT",1,xFilial("CTT")+SC7->C7_CC,"CTT_DESC01")
      EndIf
		Replace ZF_DTENTRE With SC7->C7_DATPRF
		Replace ZF_TRANSP  With SC7->C7_TRANSP
		Replace ZF_COND    With SC7->C7_COND
		Replace ZF_TPFRETE With SC7->C7_TPFRETE
		Replace ZF_COMPCF  With SC7->C7_COMPCF
		Replace ZF_OBS     With SC7->C7_OBS
		Replace ZF_VLDESC  With MaFisRet(,"NF_DESCONTO")
		Replace ZF_RC      With SC1->C1_RC
    	Replace ZF_PROPOST With SC1->C1_PROPOST
    	Replace ZF_DTPROPO With SC1->C1_DTPROPO
		Replace ZF_VLEXTEN With Lower(Alltrim(Extenso(MaFisRet(,"NF_TOTAL"))))

     //Replace ZF_CRYSDA  With cCrysDa
     MsUnlock()
   EndIf
EndIf

nQtdItem:= 0
cItem:= ""
//Montagem de Descricao Detalhada do Produto (SZH)
DbSelectArea("SC7")
DbSetOrder(1)
If DbSeek(xFilial("SC7")+cPedido)
   While ! Eof() .and. xFilial("SC7") == C7_FILIAL .and. cPedido == C7_NUM
		nQtdItem++
		cItem:= SC7->C7_ITEM

      DbSelectArea("SB1")
      DbSetOrder(1)
      DbSeek(xFilial("SB1")+SC7->C7_PRODUTO)          
      DbSelectArea("SZH") //Itens do Pedido
      DbSetOrder(1) //Filial + Pedido + Item
      If RecLock("SZH", ! DbSeek(xFilial("SZH")+SC7->C7_NUM+SC7->C7_ITEM))
         Replace ZH_FILIAL  With xFilial("SZH")
         Replace ZH_PRODUTO With SC7->C7_PRODUTO
         Replace ZH_UM      With SC7->C7_UM
         Replace ZH_ITEM    With SC7->C7_ITEM
         Replace ZH_PEDIDO  With SC7->C7_NUM
         Replace ZH_QUANT   With SC7->C7_QUANT
         Replace ZH_PRECO   With SC7->C7_PRECO
         Replace ZH_TOTAL   With SC7->C7_TOTAL
         Replace ZH_IPI     With SC7->C7_IPI
         Replace ZH_ICMS    With SC7->C7_PICM //18 Alterado em 08/05/03
         Replace ZH_NEPC    With SC7->C7_NEPC
         Replace ZH_ITEMLM  With SC7->C7_ITEMLM
         Replace ZH_VALIPI  With SC7->C7_VALIPI //Alterado em 12/08/03
     	   Replace ZH_CC      With SC7->C7_CC

         /*If ! Empty(SB1->B1_DESCDET)
            Replace ZH_DESCDET With SubStr(MemoTran(SB1->B1_DESCDET," "," "),1,512)
            Replace ZH_DESCAUX With SubStr(MemoTran(SB1->B1_DESCDET," "," "),513,512)
         Else
            Replace ZH_DESCDET With SC7->C7_DESCRI
         EndIf
         */
         MsUnlock()
      EndIf
   
      If ! Empty(SB1->B1_DESCDET)
         cQuery := "UPDATE " + RetSqlName("SZH") 
         cQuery += " SET ZH_DESCDET = '" + OemToAnsi(StrTran(StrTran(StrTran(StrTran(StrTran(SubStr(MemoTran(SB1->B1_DESCDET," "," "),1,512),"'",'"'),OemToAnsi("ã"),OemToAnsi(Chr(132))),OemToAnsi("Ã"),OemToAnsi(Chr(142))),OemToAnsi("õ"),OemToAnsi(Chr(148))),OemToAnsi("Õ"),OemToAnsi(Chr(153)))) + "',"
         cQuery += " ZH_DESCAUX = '" + OemToAnsi(StrTran(StrTran(StrTran(StrTran(StrTran(SubStr(MemoTran(SB1->B1_DESCDET," "," "),513,512),"'",'"'),OemToAnsi("ã"),OemToAnsi(Chr(132))),OemToAnsi("Ã"),OemToAnsi(Chr(142))),OemToAnsi("õ"),OemToAnsi(Chr(148))),OemToAnsi("Õ"),OemToAnsi(Chr(153)))) + "'"
         cQuery += " WHERE ZH_PEDIDO = '" + SC7->C7_NUM + "'"
         cQuery += " AND ZH_ITEM = '" + SC7->C7_ITEM + "'"
         TCSQLEXEC(cQuery)
         TCRefresh(RetSqlName("SZH"))
      Else
         cQuery := "UPDATE " + RetSqlName("SZH")
         cQuery += " SET ZH_DESCDET = '" + SC7->C7_DESCRI + "'"
         cQuery += " WHERE ZH_PEDIDO = '" + SC7->C7_NUM + "'"
         cQuery += " AND ZH_ITEM = '" + SC7->C7_ITEM + "'"
         TCSQLEXEC(cQuery)
         TCRefresh(RetSqlName("SZH"))            
      EndIf
      
      DbSelectArea("SC7")
      DbSkip()
   End
EndIf   

//Inclui linhas em branco para posicionar o rodape no final da 1 pagina
If nQtdItem < 14
	For nXi := 1 To (14-nQtdItem)
		cItem:= SOMA1(cItem)
      DbSelectArea("SZH") //Itens do Pedido
      DbSetOrder(1) //Filial + Pedido + Item
      If RecLock("SZH", .T.)
         Replace ZH_FILIAL  With xFilial("SZH")
         Replace ZH_PEDIDO  With cPedido
         Replace ZH_ITEM    With cItem
         MsUnlock()
      EndIf
	Next nXi
EndIf

//Montagem de Detalhes do Pedido(SZG)
/*
1 = Condicoes Gerais
2 = Documentos
3 = Prazo de Entrega
4 = Precos e Condicoes de Pagamento/Faturamento
5 = Local de Entrega/Embalagem
6 = Garantia
7 = Instrucoes Faturamento
8 = Inspecao
9 = Contatos
10 = Confirmacao do Pedido
11 = Outros
*/  

DbSelectArea("SC7")
DbSetOrder(1)
If DbSeek(xFilial("SC7")+cPedido)
   lChamaRel:=.T.

   For nXi:=1 To 11
       If RecLock("SZG",.t.)
          Replace ZG_FILIAL With xFilial("SZG")          	     
          Replace ZG_PEDIDO With SC7->C7_NUM
          Do Case
             Case nxI == 10
		          Replace ZG_TIPO   With "A"
		       Case nxI == 11 
		       	 Replace ZG_TIPO   With "B"
		       Otherwise 
		          Replace ZG_TIPO   With Str(nXi,1)
		    EndCase
          MsUnlock()          
       EndIf   

/*
       Do Case
          Case nXi == 2 // 3 = Documentos
				fQuebDesc(SC7->C7_DETDC)
//        Case nXi ==  // 4 = Prazo de Entrega
//				fQuebDesc(SC7->C7_DETPZ)
          Case nXi == 3 // Precos e Condicoes de Pagamento/Faturamento
				fQuebDesc(SC7->C7_DETPR)
          Case nXi == 4 // Local de Entrega/Embalagem
				fQuebDesc(SC7->C7_DETLC)
          Case nXi == 5 // Garantia
				fQuebDesc(SC7->C7_DETGR)
          Case nXi == 6 // Instrucoes Faturamento
				fQuebDesc(SC7->C7_DETFT)
          Case nXi == 7 // Inspecao
				fQuebDesc(SC7->C7_DETIN)
          Case nXi == 8 // Condicoes Gerais
				fQuebDesc(SC7->C7_DETCD)
//          Case nXi == 9 // 10 = Contatos
//				fQuebDesc(SC7->C7_DETCT)
			 Case nXi == 9 // Outros
				fQuebDesc(SC7->C7_DETOU)
          Case nXi == 10 // 11 = Confirmacao do Pedido
				fQuebDesc(SC7->C7_DETCF)
       EndCase
*/

       Do Case
          Case nXi == 1 //
					FQuebDesc("")
          Case nXi == 2 // Condicoes Gerais
					FQuebDesc(SC7->C7_DETES)
          Case nXi == 3 //Documento
					FQuebDesc(SC7->C7_DETDC)
//          Case nXi ==  // 4 = Prazo de Entrega
//					FQuebDesc(SC7->C7_DETPZ)
          Case nXi == 4 // Precos e Condicoes de Pagamento/Faturamento
					FQuebDesc(SC7->C7_DETPR)
          Case nXi == 5 // Local de Entrega/Embalagem
					FQuebDesc(SC7->C7_DETLC)
          Case nXi == 6 // Garantia
					FQuebDesc(SC7->C7_DETGR)
          Case nXi == 7 // Instrucoes Faturamento
					FQuebDesc(SC7->C7_DETFT)
          Case nXi == 8 // Inspecao
					FQuebDesc(SC7->C7_DETIN)
//          Case nXi == 9 // 10 = Contatos
//					FQuebDesc(@cDesc1,@cDesc2,@cDesc3,@cDesc4,SC7->C7_DETCT)
          Case nXi == 9 // 11 = Confirmacao do Pedido
					FQuebDesc(SC7->C7_DETCD)
			 Case nXi == 10 // Foro
					FQuebDesc(SC7->C7_DETOU)
			 Case nXi == 11 // Outros
					FQuebDesc(SC7->C7_DETCF)
       EndCase
       
       For nXy:=1 To 5
			cVar := "cDesc"+Str(nXy,1)
            &cVar:=OemToAnsi(StrTran(StrTran(StrTran(StrTran(&cVar,OemToAnsi("ã"),OemToAnsi(Chr(132))),OemToAnsi("Ã"),OemToAnsi(Chr(142))),OemToAnsi("õ"),OemToAnsi(Chr(148))),OemToAnsi("Õ"),OemToAnsi(Chr(153))))
//            &cVar:=OemToAnsi(StrTran(StrTran(StrTran(StrTran(&cVar,OemToAnsi("ã"),OemToAnsi(Chr(198))),OemToAnsi("Ã"),OemToAnsi(Chr(199))),OemToAnsi("õ"),OemToAnsi(Chr(228))),OemToAnsi("Õ"),OemToAnsi(Chr(229))))

           Do Case
              Case nxI == 10
                cQuery := "UPDATE " + RetSqlName("SZG")
           		 cQuery += " SET ZG_DESC" + STR(nXy,1) + " = '" + &cVar + "'"
           		 cQuery += " WHERE ZG_TIPO = 'A'"
              Case nxI == 11
                cQuery := "UPDATE " + RetSqlName("SZG")
           		 cQuery += " SET ZG_DESC" + STR(nXy,1) + " = '" + &cVar + "'"
           		 cQuery += " WHERE ZG_TIPO = 'B'"
              OtherWise
                cQuery := "UPDATE " + RetSqlName("SZG")
           		 cQuery += " SET ZG_DESC" + STR(nXy,1) + " = '" + &cVar + "'"
           		 cQuery += " WHERE ZG_TIPO = " + STR(nXi,1) 
       	   EndCase
       	   TCSQLEXEC(cQuery)
           TCRefresh(RetSqlName("SZG"))
       Next nXy
   Next nXi               
Else
   MsgBox("Atencao, O Pedido Solicitado Nao Foi Encontrado, Verifique no Cadastro!","Erro...","STOP")
EndIf

MaFisEnd()

//FAcerAcento()

If lChamaRel
   CallCrys("PDCTSA")
EndIf

//Restaurando Ambiente Inicial
RestArea(aAreaOld)

Return



Static Function fQuebDesc(cCampo)
*********************************************************************************
* Quebra descricao
*
***
Local nTam	 := 512
Local nXi 	 := 0
Local nPosIni:= 1

For nXi:= 1 To 5
	&("cDesc"+STR(nXi,1)):= StrTran(SubStr(MemoTran(cCampo," "," "),nPosIni, nTam),"'",'"')
	nPosIni+=nTam
Next nXi

Return



Static Function FAcerAcento()
*********************************************************************************
* Verifica e Acerta Acentos nao Identificados pela tabela Ascii
*
***

DbSelectArea("SZH")
DbGoTop()
While ! Eof()
    If AT(OemToAnsi(Chr(142)),ZH_DESCDET) > 0 .or. AT(OemToAnsi(Chr(132)),ZH_DESCDET) > 0 .or. AT(OemToAnsi(Chr(148)),ZH_DESCDET) > 0 .or. AT(OemToAnsi(Chr(153)),ZH_DESCDET) > 0 .or. AT(OemToAnsi(Chr(142)),ZH_DESCAUX) > 0 .or. AT(OemToAnsi(Chr(132)),ZH_DESCAUX) > 0 .or. AT(OemToAnsi(Chr(148)),ZH_DESCAUX) > 0 .or. AT(OemToAnsi(Chr(153)),ZH_DESCAUX) > 0
       If RecLock("SZH",.f.)
          Replace ZH_DESCDET With OemToAnsi(StrTran(StrTran(StrTran(StrTran(ZH_DESCDET,OemToAnsi(Chr(132)),OemToAnsi("ã")),OemToAnsi(Chr(142)),OemToAnsi("Ã")),OemToAnsi(Chr(148)),OemToAnsi("õ")),OemToAnsi(Chr(153)),OemToAnsi("Õ"))),;
                  ZH_DESCAUX With OemToAnsi(StrTran(StrTran(StrTran(StrTran(ZH_DESCAUX,OemToAnsi(Chr(132)),OemToAnsi("ã")),OemToAnsi(Chr(142)),OemToAnsi("Ã")),OemToAnsi(Chr(148)),OemToAnsi("õ")),OemToAnsi(Chr(153)),OemToAnsi("Õ")))
          MsUnlock()
        EndIf
    EndIf   
    DbSkip()       
End

Return



Static Function AjustaSX1(cPerg)
*************************************************************************************
* Ajusta o SX1
*
*PutSx1(cGrupo, cOrdem, cPergunta, cPerguntaSPA, cPerguntaEng, 
*cVariavel, cTipo, nTamanho, nDecimal, nPreSel, nGSC, 
*cValid, cF3, cGrupoSXG, cPyme, cVar01,
*cDef01, cDef01SPA, cDef01Eng, , cDef02, cDef02SPA, cDef02Eng,
*cDef03, cDef03SPA, cDef03Eng, cDef04, cDef04SPA, cDef04Eng, cDef05, cDef05SPA, cDef05Eng, 
*aHelpPor, aHelpEng, aHelpEsp)
*Exemplo c/ Opcoes:
*		"mv_chc", "N", 1, 0, 0, "C",
*		"Sim", "Si", "Yes", "", "Nao", "No", "No"
*Exemplo Data:
*		"mv_ch1", "D", 8, 0, 0, "G",;
*Validacao:
*     Eval( {||MV_Par02 >= MV_Par01 .AND. !EMPTY(MV_Par02)} )
*Help:
*		aHelpPor:= {"Mensagem1","Mensagem2","Mensagem3"}
***

Local aHelpPor	:= {}
Local cDesPerg	:= ""
                   
cDesPerg:= Padr("Pedido Compra",19)+"?"
aHelpPor:= {"Informe o número da pedido de compra."}
PutSx1(cPerg, "01", cDesPerg, cDesPerg, cDesPerg, "mv_ch1", "C", 06, 0, 0, "G",;
		 "", "", "", "", "mv_par01",;
		 "", "", "",   "",   "", "", "",   "", "", "",   "", "", "",   "", "", "",;
		 aHelpPor, aHelpPor, aHelpPor)

cDesPerg:= Padr("Suprimento",19)+"?"
aHelpPor:= {"Informe o nome do responsavel pelo Suprimento."}
PutSx1(cPerg, "02", cDesPerg, cDesPerg, cDesPerg, "mv_ch2", "C", 50, 0, 0, "G",;
		 "", "", "", "", "mv_par02",;
		 "", "", "",   "",   "", "", "",   "", "", "",   "", "", "",   "", "", "",;
		 aHelpPor, aHelpPor, aHelpPor)

cDesPerg:= Padr("Email Suprimento",19)+"?"
aHelpPor:= {"Informe o email do responsavel pelo Suprimento."}
PutSx1(cPerg, "03", cDesPerg, cDesPerg, cDesPerg, "mv_ch3", "C", 50, 0, 0, "G",;
		 "", "", "", "", "mv_par03",;
		 "", "", "",   "",   "", "", "",   "", "", "",   "", "", "",   "", "", "",;
		 aHelpPor, aHelpPor, aHelpPor)

cDesPerg:= Padr("Solicitante",19)+"?"
aHelpPor:= {"Informe o nome do Solicitante."}
PutSx1(cPerg, "04", cDesPerg, cDesPerg, cDesPerg, "mv_ch4", "C", 50, 0, 0, "G",;
		 "", "", "", "", "mv_par04",;
		 "", "", "",   "",   "", "", "",   "", "", "",   "", "", "",   "", "", "",;
		 aHelpPor, aHelpPor, aHelpPor)

cDesPerg:= Padr("Gerente Contrato",19)+"?"
aHelpPor:= {"Informe o nome do Gerente de Contrato."}
PutSx1(cPerg, "05", cDesPerg, cDesPerg, cDesPerg, "mv_ch5", "C", 50, 0, 0, "G",;
		 "", "", "", "", "mv_par05",;
		 "", "", "",   "",   "", "", "",   "", "", "",   "", "", "",   "", "", "",;
		 aHelpPor, aHelpPor, aHelpPor)

cDesPerg:= Padr("Gerente Operações",19)+"?"
aHelpPor:= {"Informe o nome do Gerente de Operacoes."}
PutSx1(cPerg, "06", cDesPerg, cDesPerg, cDesPerg, "mv_ch6", "C", 50, 0, 0, "G",;
		 "", "", "", "", "mv_par06",;
		 "", "", "",   "",   "", "", "",   "", "", "",   "", "", "",   "", "", "",;
		 aHelpPor, aHelpPor, aHelpPor)

cDesPerg:= Padr("Diretor Presidente",19)+"?"
aHelpPor:= {"Informe o nome do Diretor/Presidente."}
PutSx1(cPerg, "07", cDesPerg, cDesPerg, cDesPerg, "mv_ch7", "C", 50, 0, 0, "G",;
		 "", "", "", "", "mv_par07",;
		 "", "", "",   "",   "", "", "",   "", "", "",   "", "", "",   "", "", "",;
		 aHelpPor, aHelpPor, aHelpPor)

Return
