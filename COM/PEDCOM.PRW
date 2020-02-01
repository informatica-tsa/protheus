/*
+------------+---------+--------------------------+--------+------------------+
| Programa   | PEDCOM  | Development by Carraro   |  Data  | 09/11/2001       |
+------------+---------+--------------------------+--------+------------------+
| Descricao  | Chamada do Pedido de Compras passando Parametros(Crystal)      |
+------------+----------------------------------------------------------------+
| Uso        | Exclusivo EPC                                                  |
+------------+----------------------------------------------------------------+
|                    Modificacoes Apos Desenvolvimento Inicial                |
+---------+-------------+-----------------------------------------------------+
|  Data   | Responsavel | Motivo                                              |
+---------+-------------+-----------------------------------------------------+
| 08/05/03| Carraro     | Adequacao de Aliq. ICMS Conforme SC7                |
+---------+-------------+-----------------------------------------------------+
| 04/07/03| Carraro     | Adequacao a Estrutura de No EPC e Item LM           |
+---------+-------------+-----------------------------------------------------+
| 12/08/03| Crislei     | Gravacao do nome do cliente na descricao do contrato|
|         |             | e tratamento para gravacao dos tipos 'A' e 'B'em SZG|
+---------+-------------+-----------------------------------------------------+
| 12/08/03| Crislei     | Gravacao do campo ValIPI em SZH                     |
+---------+-------------+-----------------------------------------------------+
| 12/08/03| Crislei     | Gravacao do campo Descricao do item via replace, de-|
|         |             | vido a erros na query quando a descricao possui as- |
|         |             | pas simples na descricao.                           |
+---------+-------------+-----------------------------------------------------+
| 26/11/03| Carraro     | Retirada da customizacao do item anterior(Crislei)  |
|         |             | devido ao update ser dado por causa dos acentos, SUX!
+---------+-------------+-----------------------------------------------------+
*/
#INCLUDE "RWMAKE.CH"

User Function PEDCOM()

Local nXi := 0
Local cPedido
Local aArqs:={Alias(),IndexOrd(),Recno()}
Local lChamaRel:=.f.
Local cOrdem:="E" 
Local cSubCta:="Desconhecido"
Local cDescSub:="Desconhecido"
Local cContrato:="Desconhecido"
Local cDescCont:="Desconhecido"
Local cDesc1
Local cDesc2
Local cDesc3
Local nXy
Local cQuery
Local cCrysDa
//Mata Registros das tabelas utilizadas

TCSQLEXEC("DELETE FROM " + RetSqlName("SZF"))
TCSQLEXEC("DELETE FROM " + RetSqlName("SZG"))
TCSQLEXEC("DELETE FROM " + RetSqlName("SZH"))

//Chamada dos parametros
Pergunte("PEDCOM",.t.)
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
      //Replace ZF_CRYSDA  With cCrysDa
      MsUnlock()
   EndIf
EndIf
//Montagem de Descricao Detalhada do Produto (SZH)
DbSelectArea("SC7")
DbSetOrder(1)
If DbSeek(xFilial("SC7")+cPedido)
   While ! Eof() .and. xFilial("SC7") == C7_FILIAL .and. cPedido == C7_NUM
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
         cQuery += " ZH_DESCAUX = '" + OemToAnsi(StrTran(StrTran(StrTran(StrTran(StrTran(SubStr(MemoTran(SC7->C7_DESCRI," "," "),513,512),"'",'"'),OemToAnsi("ã"),OemToAnsi(Chr(132))),OemToAnsi("Ã"),OemToAnsi(Chr(142))),OemToAnsi("õ"),OemToAnsi(Chr(148))),OemToAnsi("Õ"),OemToAnsi(Chr(153)))) + "'"
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
   lChamaRel:=.t.
   For nXi := 1 To 11
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
       Do Case
          Case nXi == 1 // 2 = Condicoes Gerais
               cDesc1 := StrTran(SubStr(MemoTran(SC7->C7_DETCD," "," "),1,512),"'",'"')
               cDesc2 := StrTran(SubStr(MemoTran(SC7->C7_DETCD," "," "),513,512),"'",'"')
               cDesc3 := StrTran(SubStr(MemoTran(SC7->C7_DETCD," "," "),1024,512),"'",'"')
          Case nXi == 2 // 3 = Documentos
               cDesc1 := StrTran(SubStr(MemoTran(SC7->C7_DETDC," "," "),1,512),"'",'"')
               cDesc2 := StrTran(SubStr(MemoTran(SC7->C7_DETDC," "," "),513,512),"'",'"')
               cDesc3 := StrTran(SubStr(MemoTran(SC7->C7_DETDC," "," "),1024,512),"'",'"')
          Case nXi == 3 // 4 = Prazo de Entrega
               cDesc1 := StrTran(SubStr(MemoTran(SC7->C7_DETPZ," "," "),1,512),"'",'"')
               cDesc2 := StrTran(SubStr(MemoTran(SC7->C7_DETPZ," "," "),513,512),"'",'"')
               cDesc3 := StrTran(SubStr(MemoTran(SC7->C7_DETPZ," "," "),1024,512),"'",'"')
          Case nXi == 4 // 5 = Precos e Condicoes de Pagamento/Faturamento
               cDesc1 := StrTran(SubStr(MemoTran(SC7->C7_DETPR," "," "),1,512),"'",'"')
               cDesc2 := StrTran(SubStr(MemoTran(SC7->C7_DETPR," "," "),513,512),"'",'"')
               cDesc3 := StrTran(SubStr(MemoTran(SC7->C7_DETPR," "," "),1024,512),"'",'"')
          Case nXi == 5 // 6 = Local de Entrega/Embalagem
               cDesc1 := StrTran(SubStr(Memotran(SC7->C7_DETLC," "," "),1,512),"'",'"')
               cDesc2 := StrTran(SubStr(MemoTran(SC7->C7_DETLC," "," "),513,512),"'",'"')
               cDesc3 := StrTran(SubStr(MemoTran(SC7->C7_DETLC," "," "),1024,512),"'",'"')
          Case nXi == 6 // 7 = Garantia
               cDesc1 := StrTran(SubStr(MemoTran(SC7->C7_DETGR," "," "),1,512),"'",'"')
               cDesc2 := StrTran(SubStr(MemoTran(SC7->C7_DETGR," "," "),513,512),"'",'"')
               cDesc3 := StrTran(SubStr(MemoTran(SC7->C7_DETGR," "," "),1024,512),"'",'"')
          Case nXi == 7 // 8 = Instrucoes Faturamento
               cDesc1 := StrTran(SubStr(MemoTran(SC7->C7_DETFT," "," "),1,512),"'",'"')
               cDesc2 := StrTran(SubStr(MemoTran(SC7->C7_DETFT," "," "),513,512),"'",'"')
               cDesc3 := StrTran(SubStr(MemoTran(SC7->C7_DETFT," "," "),1024,512),"'",'"')
          Case nXi == 8 // 9 = Inspecao
               cDesc1 := StrTran(SubStr(MemoTran(SC7->C7_DETIN," "," "),1,512),"'",'"')
               cDesc2 := StrTran(SubStr(MemoTran(SC7->C7_DETIN," "," "),513,512),"'",'"')
               cDesc3 := StrTran(SubStr(MemoTran(SC7->C7_DETIN," "," "),1024,512),"'",'"')
          Case nXi == 9 // 10 = Contatos
               cDesc1 := StrTran(SubStr(MemoTran(SC7->C7_DETCT," "," "),1,512),"'",'"')
               cDesc2 := StrTran(SubStr(MemoTran(SC7->C7_DETCT," "," "),513,512),"'",'"')
               cDesc3 := StrTran(SubStr(MemoTran(SC7->C7_DETCT," "," "),1024,512),"'",'"')
          Case nXi == 10 // 11 = Confirmacao do Pedido
               cDesc1 := StrTran(SubStr(MemoTran(SC7->C7_DETCF," "," "),1,512),"'",'"')
               cDesc2 := StrTran(SubStr(MemoTran(SC7->C7_DETCF," "," "),513,512),"'",'"')
               cDesc3 := StrTran(SubStr(MemoTran(SC7->C7_DETCF," "," "),1024,512),"'",'"')
			Case nXi == 11 // 12 = Outros
               cDesc1 := StrTran(SubStr(MemoTran(SC7->C7_DETOU," "," "),1,512),"'",'"')
               cDesc2 := StrTran(SubStr(MemoTran(SC7->C7_DETOU," "," "),513,512),"'",'"')
               cDesc3 := StrTran(SubStr(MemoTran(SC7->C7_DETOU," "," "),1024,512),"'",'"')
       EndCase   
       For nXy:=1 To 3
           Do Case
              Case nXy == 1
                   cVar:=OemToAnsi(StrTran(StrTran(StrTran(StrTran(cDesc1,OemToAnsi("ã"),OemToAnsi(Chr(132))),OemToAnsi("Ã"),OemToAnsi(Chr(142))),OemToAnsi("õ"),OemToAnsi(Chr(148))),OemToAnsi("Õ"),OemToAnsi(Chr(153))))
              Case nXy == 2
                   cVar:=OemToAnsi(StrTran(StrTran(StrTran(StrTran(cDesc2,OemToAnsi("ã"),OemToAnsi(Chr(132))),OemToAnsi("Ã"),OemToAnsi(Chr(142))),OemToAnsi("õ"),OemToAnsi(Chr(148))),OemToAnsi("Õ"),OemToAnsi(Chr(153))))
              Case nXy == 3
                   cVar:=OemToAnsi(StrTran(StrTran(StrTran(StrTran(cDesc3,OemToAnsi("ã"),OemToAnsi(Chr(132))),OemToAnsi("Ã"),OemToAnsi(Chr(142))),OemToAnsi("õ"),OemToAnsi(Chr(148))),OemToAnsi("Õ"),OemToAnsi(Chr(153))))                                      
           EndCase
           Do Case
              Case nxI == 10
                 cQuery := "UPDATE " + RetSqlName("SZG")
           		 cQuery += " SET ZG_DESC" + STR(nXy,1) + " = '" + cVar + "'"
           		 cQuery += " WHERE ZG_TIPO = 'A'"
              Case nxI == 11
                 cQuery := "UPDATE " + RetSqlName("SZG")
           		 cQuery += " SET ZG_DESC" + STR(nXy,1) + " = '" + cVar + "'"
           		 cQuery += " WHERE ZG_TIPO = 'B'"
              OtherWise
                 cQuery := "UPDATE " + RetSqlName("SZG")
           		 cQuery += " SET ZG_DESC" + STR(nXy,1) + " = '" + cVar + "'"
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
   CallCrys("PEDCOM")
EndIf
//Restaurando Ambiente Inicial
DbSelectArea(aArqs[1])
DbSetOrder(aArqs[2])
DbGoTo(aArqs[3])

Return                                           

Static Function FAcerAcento()
*********************************************************************************
* Verifica e Acerta Acentos nao Identificados pela tabela Ascii
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