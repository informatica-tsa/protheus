#Include "RwMake.ch"
#Include "Colors.ch"
#INCLUDE "topconn.ch"
/*
+-----------------------------------------------------------------------+
¦Programa  ¦ComGrf1    ¦ Autor ¦ Gilson Lucas          ¦Data ¦12.01.2016¦
+----------+------------------------------------------------------------¦
¦Descricao ¦Ordem de compra                                		   		¦
+----------+------------------------------------------------------------¦
¦ Uso      ¦ ESPECIFICO PARA A TSA                                      ¦
+-----------------------------------------------------------------------¦
¦           ATUALIZACOES SOFRIDAS DESDE A CONSTRUCAO INICIAL            ¦
+-----------------------------------------------------------------------¦
¦PROGRAMADOR ¦ DATA   ¦ MOTIVO DA ALTERACAO                             ¦
+------------+--------+-------------------------------------------------¦
¦            ¦        ¦                                                 ¦
+-----------------------------------------------------------------------+
*/

User Function ComGrf1()
*************************************************************************
*
**
Local cChvPed    := ""
Local cAliasTemp := ""
Local cPerg      := "PEDCOM"
Local lImpAuto   := Iif(Type("ParamIxb[2]") == "N",.T.,.F.)
Private nTotPed  := 0
Private cTitulo  :=OemToAnsi("Emissao dos Pedidos de Compras")

If lImpAuto
   dbSelectArea("SC7")
   SC7->(dbSetOrder(1))
   SC7->(dbGoto(ParamIxb[2])) 
   If !SC7->(Eof())
      // Forca o posicioanmento no primeiro item do pedido de compras
      SC7->(dbSeek(SC7->(C7_FILIAL+C7_NUM)))
      If !SC7->(Eof())
         /*
         MaFisEnd()
         MaFisIniPC(SC7->C7_NUM)
         nTotPed := MaFisRet(,"NF_TOTAL")
         */
         
         cChvPed := SC7->(C7_FILIAL+C7_NUM)
         While !SC7->(Eof()) .And. cChvPed == SC7->(C7_FILIAL+C7_NUM)
            nTotPed += SC7->(C7_TOTAL+C7_VALIPI+C7_ICMSRET)
            SC7->(dbSkip())
         End
         SC7->(dbSeek(cChvPed))
         
         
         cAliasTemp := "SC7"
         MsgRun(OemToAnsi("Aguarde, Gerando Relatorio..."),"",{|| CursorWait(), PCNCfg(lImpAuto,"SC7",SC7->(C7_FILIAL+C7_NUM)) ,CursorArrow()})
      EndIf
   EndIf
Else
   PutSx1(cPerg,"01",OemToAnsi("Pedido Inicial ?")  ,OemToAnsi("Pedido Inicial ?")  ,OemToAnsi("Pedido Inicial ?")  ,"mv_ch1","C",06,0,0,"G","","","","","mv_par01","","","","","","","","","","","","","","","","",{ OemToAnsi("Define o Pedido Inicial para Impressão")}, {}, {} )
   PutSx1(cPerg,"02",OemToAnsi("Pedido Final ?")    ,OemToAnsi("Pedido Final ?")    ,OemToAnsi("Pedido Final ?")    ,"mv_ch2","C",06,0,0,"G","","","","","mv_par02","","","","","","","","","","","","","","","","",{ OemToAnsi("Define o Pedido Final para Impressão")}, {}, {} )
   PutSx1(cPerg,"03",OemToAnsi("Emissão Inicial ?") ,OemToAnsi("Emissão Inicial ?") ,OemToAnsi("Emissão Inicial ?") ,"mv_ch3","D",08,0,0,"G","","","","","mv_par03","","","","","","","","","","","","","","","","",{ OemToAnsi("Define a Emissão Inicial para Impressão")}, {}, {} )
   PutSx1(cPerg,"04",OemToAnsi("Emissão Final ?")   ,OemToAnsi("Emissão Final ?")   ,OemToAnsi("Emissão Final ?")   ,"mv_ch4","D",08,0,0,"G","","","","","mv_par04","","","","","","","","","","","","","","","","",{ OemToAnsi("Define a Emissão Final para Impressão")}, {}, {} )
   If Pergunte(cPerg,.T.)
      cAliasTemp := GetNextAlias()  
      BeginSql Alias cAliasTemp //Inicio do Embedded SQL
         SELECT *  FROM %Table:SC7% SC7
         WHERE C7_FILIAL = %xFilial:SC7%
         AND SC7.%NotDel%
         AND C7_NUM     Between %Exp:MV_PAR01% And %Exp:MV_PAR02%
         AND C7_EMISSAO Between %Exp:Dtos(MV_PAR03)% And %Exp:Dtos(MV_PAR04)%
         ORDER C7_NUM+C7_ITEM
      EndSql
      aEval(SC7->(DbStruct()), {|e| If(e[2]!= "C", TCSetField(cAliasTemp, e[1], e[2],e[3],e[4]),Nil)})
      dbSelectArea(cAliasTemp)
      (cAliasTemp)->(dbGotop())
      MsgRun(OemToAnsi("Aguarde, Gerando Relatorio..."),"",{|| CursorWait(), PCNCfg(lImpAuto,cAliasTemp) ,CursorArrow()})   
   EndIf
EndIf



Return



Static Function PCNCfg(lImpAuto,cAliasTemp,cNumPed)
*********************************************************************************
* Cria Objetos para Relatorio Grafico
***
Local nXi       := 0
Local cPrefNum  := ""
Local nPgAtu    := 0
Local nLinha    := 0
Local nTotItens := 0
Local cCondPad  := ""
Local cTpFrete  := ""
Local nTotPg    := 0
Local aDadCab   := {}
Local nQuebDesc := 43 // Quebra da descricao do Produto
Local cChaveNew := "NEW"
Local cChaveOld := "OLD"
Local aItensPC  := {}
Local aAreaSC7  := SC7->(GetArea())
Local oPrint    := TMSPrinter():New( cTitulo )

Local cDetCondi := ""  //Condicoes    01
Local cDetPrazo := ""  //Prazo        02
Local cDetGaran := ""  //Garantia     03
Local cDetPreco := ""  //Preco        04
Local cDetInpec := ""  //Inspecao     05
Local cDetOutro := ""  //Outros       06
Local cDetLocal := ""  //Loc. Entr.  07
Local cDetConfi := ""  //Confirmacao  08
Local cDetFatur := ""  //Inst Faturam 09
Local cDetDocto := ""  //Documentos   10
Local cDetCot   := ""  // Numero da Cotacao


Local cCGerais  := ""
Local cEscopo   := ""
Local cMarcos   := ""
Local lPedLib   := .F.
Local lAtuTotal := .T.
Private oFontTit  := TFont():New("Courier New",21,21,,.T.,,,,.T.,.F.)
Private oFontPed  := TFont():New("Courier New",15,15,,.T.,,,,.T.,.F.)
Private oFontRos  := TFont():New("Courier New",11,11,,.T.,,,,.T.,.F.)
Private oFontCab  := TFont():New("Courier New",08,08,,.T.,,,,.T.,.F.)
Private oFontDad  := TFont():New("Courier New",09,09,,.F.,,,,.T.,.F.)
Private oFontDad2 := TFont():New("Courier New",08,08,,.F.,,,,.T.,.F.)
Private oFontIte  := TFont():New("Courier New",08,08,,.F.,,,,.T.,.F.)

oPrint:Setup()
oPrint:SetPortrait() // Seta como retrato
oPrint:SetPage(9) //Setar para A4

dbSelectArea("SB1")
SB1->(dbSetOrder(1)) // Filial+Codigo

dbSelectArea("SC8")
SC8->(dbSetOrder(1)) // Filial+Numero

dbSelectArea("SX5")
SX5->(dbSetOrder()) // Filial+Tabela+chave
If !Empty(nTotPed)
   lAtuTotal := .F.
EndIf

// Loop para Totalizar e saber a quantidade de paginas
While !(cAliasTemp)->(Eof()) .And. Iif(lImpAuto , (cAliasTemp)->(C7_FILIAL+C7_NUM) == cNumPed,.T.)
   SB1->(dbSeek(xFilial("SB1")+(cAliasTemp)->C7_PRODUTO))
   If lAtuTotal
      nTotPed   += (cAliasTemp)->C7_TOTAL
   EndIf
   lPedLib   := Iif((cAliasTemp)->C7_CONAPRO=="B",.F.,.T.)
   cCondPad  := (cAliasTemp)->C7_COND
   cTpFrete  := (cAliasTemp)->C7_TPFRETE
   cDetCondi := (cAliasTemp)->C7_DETCD  //Condicoes    01
   cDetPrazo := (cAliasTemp)->C7_DETPZ  //Prazo        02
   cDetGaran := (cAliasTemp)->C7_DETGR  //Garantia     03
   cDetPreco := (cAliasTemp)->C7_DETPR  //Preco        04
   cDetInpec := (cAliasTemp)->C7_DETIN  //Inspecao     05
   cDetOutro := (cAliasTemp)->C7_DETOU  //Outros       06
   cDetLocal := (cAliasTemp)->C7_DETLC  // Loc. Entr.  07
   cDetConfi := (cAliasTemp)->C7_DETCF  //Confirmacao  08
   cDetFatur := (cAliasTemp)->C7_DETFT  //Inst Faturam 09
   cDetDocto := (cAliasTemp)->C7_DETDC  //Documentos   10
   cDetCot   := (cAliasTemp)->C7_NUMCOT
   cCGerais  := (cAliasTemp)->C7_CONDGER
   cEscopo   := (cAliasTemp)->C7_ESCOPO 
   cMarcos   := (cAliasTemp)->C7_MARCOS 


   
   For nXi:=1 To MLCount(Alltrim((cAliasTemp)->C7_PRODUTO)+" - "+Alltrim((cAliasTemp)->C7_DESCRI),nQuebDesc)
       nTotItens++
   Next nXi
   // Adiciona informações necessarias para o cabec
   If Empty(aDadCab)
      If !SB1->(Eof())
         SX5->(dbseek(xFilial("SX5")+"02"+SB1->B1_TIPO))
         If !SX5->(Eof())
            If 'SERVI' $ Upper(SX5->X5_DESCRI)
               cPrefNum := "OS"
            Else
               cPrefNum := "OC"            
            EndIf
            AADD(aDadCab,cPrefNum+(CALIASTEMP)->C7_NUM) // Numero
            AADD(aDadCab,dtoc((CALIASTEMP)->C7_EMISSAO)) // Emissao
            AADD(aDadCab,(CALIASTEMP)->C7_ITEMCTA) // Item contabil
            AADD(aDadCab,(CALIASTEMP)->C7_NUMSC) // Numero da sc
            AADD(aDadCab,(CALIASTEMP)->C7_NUMCOT) // Cotacao
            SC8->(dbSeek(xFilial("SC6")+(CALIASTEMP)->C7_NUMCOT))
            If !SC8->(Eof())
               AADD(aDadCab,dtoc(SC8->C8_EMISSAO))
            Else
               AADD(aDadCab,'') 
            EndIf   
         EndIf
      EndIf   
   EndIf
   (cAliasTemp)->(dbSkip())
End



If Empty(aDadCab)
   AADD(aDadCab,'XX'+(CALIASTEMP)->C7_NUM) // Numero
   AADD(aDadCab,dtoc((CALIASTEMP)->C7_EMISSAO)) // Emissao
   AADD(aDadCab,(CALIASTEMP)->C7_ITEMCTA) // Item contabil
   AADD(aDadCab,(CALIASTEMP)->C7_NUMSC) // Numero da sc
   AADD(aDadCab,(CALIASTEMP)->C7_NUMCOT) // Cotacao
   AADD(aDadCab,'') 
EndIf



// Calcula o numero total de paginas.
//cCGerais := MemoRead( "\Cond_Gerais\Cond_gerais.txt")
nTotPg := Int((nTotItens / 22)) + Iif(Int((nTotItens / 22)) - (nTotItens / 22) == 0,0,1)
nTotPg += IIf((MLCount(cCGerais,250) / 55) - int(MLCount(cCGerais,250) / 55) == 0,int(MLCount(cCGerais,250) / 55),1+int(MLCount(cCGerais,250) / 55))
/* Condicoes gerais antigas
If !Empty(cDetCondi) .or. !Empty(cDetPrazo) 
   nTotPg++
Endif   
If !Empty(cDetGaran) .or. !Empty(cDetPreco)  .or. !Empty(cDetInpec)  .or. !Empty(cDetOutro)  .or. !Empty(cDetLocal)  .or. !Empty(cDetConfi)  .or. !Empty(cDetFatur)  .or. !Empty(cDetDocto)
   nTotPg++
EndIf
*/
// Restaura o posicionamento do SC7
RestArea(aAreaSC7)
If !lImpAuto
   (cAliasTemp)->(dbGotop())
EndIf
cCondPad := Posicione("SE4",1,xFilial("SE4")+cCondPad,"E4_DESCRI")

dbSelectArea("SB1")
SB1->(dbSetOrder(1))

dbSelectArea("SA2")
SA2->(dbSetOrder(1))
nPgAtu    := 0
nTotItens := 0
While !(cAliasTemp)->(Eof()) .And. Iif(lImpAuto , (cAliasTemp)->(C7_FILIAL+C7_NUM) == cNumPed,.T.)
   
   SA2->(dbSeek(xFilial("SA2")+(cAliasTemp)->(C7_FORNECE+C7_LOJA)))
   
   If cChaveOld # cChaveNew 
      aItensPC  := {}
      aDadosFor := {SA2->A2_COD,Alltrim(SA2->A2_COD)+"-"+Alltrim(SA2->A2_LOJA)+"|"+SA2->A2_NOME,SA2->A2_END,'',SA2->A2_CONTATO,SA2->A2_TEL,SA2->A2_EMAIL,Iif(Len(Alltrim(SA2->A2_CGC))==14,Transform(SA2->A2_CGC,"@R 99.999.999/9999-99"),Transform(SA2->A2_CGC,"@R 999.999.999-99"))}
      Cabec(@oPrint,@nLinha,cAliasTemp,aDadosFor,@nPgAtu,nTotPg,aDadCab) // Imprime o cabeçalho  
   EndIf
   SB1->(dbSeek(xFilial("SB1")+(cAliasTemp)->C7_PRODUTO))
   // Quebra a descrição do produto a cada xxx caracteres
   For nXi:=1 To MLCount(Alltrim((cAliasTemp)->C7_PRODUTO)+" - "+Alltrim((cAliasTemp)->C7_DESCRI),nQuebDesc,,.T.)
       If nXi == 1 // na Primeira linha fica as quantidades e valores
          nTotItens++
          Aadd(aItensPC,{(cAliasTemp)->C7_ITEM,;
                         Alltrim(Str((cAliasTemp)->C7_QUANT,14,0)) ,; // /*Alltrim(Transform((cAliasTemp)->C7_QUANT,"@E 99,999.99"))*/
                         (cAliasTemp)->C7_UM,;
                         Alltrim(MemoLine(Alltrim((cAliasTemp)->C7_PRODUTO)+" - "+Alltrim((cAliasTemp)->C7_DESCRI),nQuebDesc,nXi,,.t.)),;
                         SB1->B1_POSIPI,;
                         Alltrim(Str((cAliasTemp)->C7_ICMSRET,14,2)),;
                         Alltrim(Transform((cAliasTemp)->C7_PRECO,"@E 999,999.99")),;
                         '',;      
                         Alltrim(Transform((cAliasTemp)->C7_PICM,"@E 99.99")),;
                         Alltrim(Transform((cAliasTemp)->C7_IPI,"@E 99.99")),;
                         Alltrim(Transform((cAliasTemp)->(C7_TOTAL+C7_VALFRE+C7_VALEMB+C7_DESPESA+C7_SEGURO+C7_VALIPI+C7_ICMSRET)-(cAliasTemp)->C7_VLDESC,"@E 999,999.99")),;
                         (CALIASTEMP)->C7_DESTINA,;
                         (CALIASTEMP)->C7_DATPRF })

       Else
          nTotItens++
          Aadd(aItensPC,{'',;
                         '',;
                         '',;
                         Alltrim(MemoLine(Alltrim((cAliasTemp)->C7_PRODUTO)+" - "+Alltrim((cAliasTemp)->C7_DESCRI),nQuebDesc,nXi,,.t.)),;
                         '',;
                         '',;
                         '',;
                         '',;      
                         '',;
                         '',;
                         '',;
                         '',;
                         STOD('')})
       EndIf
   Next nXi

   cChaveOld := (cAliasTemp)->(C7_FILIAL+C7_NUM)
   (cAliasTemp)->(dbSkip())
   cChaveNew := (cAliasTemp)->(C7_FILIAL+C7_NUM)
   If (cChaveOld # cChaveNew)
      ItensPC(@oPrint,@nLinha,@aItensPC,cAliasTemp,aDadosFor,cChaveOld,aDadCab,@nPgAtu,nTotPg,cCondPad,lPedLib,cTpFrete,cDetCot,cEscopo,cMarcos)
   EndIf
End

If !lImpAuto
   dbSelectArea(cAliasTemp)
   (cAliasTemp)->(dbCloseArea())
EndIf

RodaPC(oPrint,@nLinha,cChaveOld,nTotPed,cCondPad,lPedLib,cCondPad,cTpFrete,cDetCot,cMarcos)

For nXi:=1 To MLCount(cCGerais,250)
    If nXi==1 .or. (nXi/56) - int( (nXi/56)) == 0
       Cabec(@oPrint,@nLinha,cAliasTemp,aDadosFor,@nPgAtu,nTotPg,aDadCab)
       oPrint:Box(nLinha,0050,nLinha+3055,2300) //Box Itens    
    EndIf
    If Left(MemoLine(cCGerais,250,nXi),1) == "#" // Linha de negrito
       oPrint:Say(nLinha,070,StrTran(MemoLine(cCGerais,250,nXi),"#",""),oFontRos,1000)
    Else
       oPrint:Say(nLinha,070,StrTran(MemoLine(cCGerais,250,nXi),"#",Space(1)),oFontDad2,1000)       
    EndIf
    nLinha += 50
Next nXi



/* COndicoes gerais)

// Show Obs:
If !Empty(cDetCondi) .or. !Empty(cDetPrazo) 
   Cabec(@oPrint,@nLinha,cAliasTemp,aDadosFor,@nPgAtu,nTotPg,aDadCab)
   oPrint:Box(nLinha,0050,nLinha+2300,2300) //Box Itens
   //nLinha += 50
   For nXi:=1 To MLCount(cDetCondi,250)
       If !Empty(MemoLine(cDetCondi,250,nXi))
          If nXi ==1
             oPrint:Say(nLinha,070,MemoLine(cDetCondi,250,nXi),oFontRos,1000)
          Else
             oPrint:Say(nLinha,070,MemoLine(cDetCondi,250,nXi),oFontDad2,1000)       
          EndIf
           nLinha += 50
      Endif    
   Next nXi
   nLinha += 25
   For nXi:=1 To MLCount(cDetPrazo,250)
       If !Empty(MemoLine(cDetPrazo,250,nXi))
          If nXi ==1
             oPrint:Say(nLinha,070,MemoLine(cDetPrazo,250,nXi),oFontRos,1000)
          Else
             oPrint:Say(nLinha,070,MemoLine(cDetPrazo,250,nXi),oFontDad2,1000)       
          EndIf
          nLinha += 50
       EndIf   
   Next nXi
EndIf

If !Empty(cDetGaran) .or. !Empty(cDetPreco)  .or. !Empty(cDetInpec)  .or. !Empty(cDetOutro)  .or. !Empty(cDetLocal)  .or. !Empty(cDetConfi)  .or. !Empty(cDetFatur)  .or. !Empty(cDetDocto)
   Cabec(@oPrint,@nLinha,cAliasTemp,aDadosFor,@nPgAtu,nTotPg,aDadCab)
   oPrint:Box(nLinha,0050,nLinha+2300,2300) //Box Itens
   //nLinha += 50
   For nXi:=1 To MLCount(cDetGaran,250)
       If !Empty(MemoLine(cDetGaran,250,nXi))
          If nXi ==1
             oPrint:Say(nLinha,070,MemoLine(cDetGaran,250,nXi),oFontRos,1000)
          Else
             oPrint:Say(nLinha,070,MemoLine(cDetGaran,250,nXi),oFontDad2,1000)       
          EndIf
           nLinha += 50
      Endif    
   Next nXi
   nLinha += 10
   
   For nXi:=1 To MLCount(cDetPreco,250)
       If !Empty(MemoLine(cDetPreco,250,nXi))
          If nXi ==1
             oPrint:Say(nLinha,070,MemoLine(cDetPreco,250,nXi),oFontRos,1000)
          Else
             oPrint:Say(nLinha,070,MemoLine(cDetPreco,250,nXi),oFontDad2,1000)       
          EndIf
          nLinha += 50
       EndIf   
   Next nXi
   nLinha += 10
   
   For nXi:=1 To MLCount(cDetInpec,250)
       If !Empty(MemoLine(cDetInpec,250,nXi))
          If nXi ==1
             oPrint:Say(nLinha,070,MemoLine(cDetInpec,250,nXi),oFontRos,1000)
          Else
             oPrint:Say(nLinha,070,MemoLine(cDetInpec,250,nXi),oFontDad2,1000)       
          EndIf
          nLinha += 50
       EndIf   
   Next nXi
   nLinha += 10
   
   For nXi:=1 To MLCount(cDetOutro,250)
       If !Empty(MemoLine(cDetOutro,250,nXi))
          If nXi ==1
             oPrint:Say(nLinha,070,MemoLine(cDetOutro,250,nXi),oFontRos,1000)
          Else
             oPrint:Say(nLinha,070,MemoLine(cDetOutro,250,nXi),oFontDad2,1000)       
          EndIf
          nLinha += 50
       EndIf   
   Next nXi
   nLinha += 10      
   
   
   For nXi:=1 To MLCount(cDetLocal,250)
       If !Empty(MemoLine(cDetLocal,250,nXi))
          If nXi ==1
             oPrint:Say(nLinha,070,MemoLine(cDetLocal,250,nXi),oFontRos,1000)
          Else
             oPrint:Say(nLinha,070,MemoLine(cDetLocal,250,nXi),oFontDad2,1000)       
          EndIf
          nLinha += 50
       EndIf   
   Next nXi
   nLinha += 10      
      
   
   For nXi:=1 To MLCount(cDetConfi,250)
       If !Empty(MemoLine(cDetConfi,250,nXi))
          If nXi ==1
             oPrint:Say(nLinha,070,MemoLine(cDetConfi,250,nXi),oFontRos,1000)
          Else
             oPrint:Say(nLinha,070,MemoLine(cDetConfi,250,nXi),oFontDad2,1000)       
          EndIf
          nLinha += 50
       EndIf   
   Next nXi
   nLinha += 10    
      
   
   For nXi:=1 To MLCount(cDetFatur,250)
       If !Empty(MemoLine(cDetFatur,250,nXi))
          If nXi ==1
             oPrint:Say(nLinha,070,MemoLine(cDetFatur,250,nXi),oFontRos,1000)
          Else
             oPrint:Say(nLinha,070,MemoLine(cDetFatur,250,nXi),oFontDad2,1000)       
          EndIf
          nLinha += 50
       EndIf   
   Next nXi
   nLinha += 10      

   
   For nXi:=1 To MLCount(cDetDocto,250)
       If !Empty(MemoLine(cDetDocto,250,nXi))
          If nXi ==1
             oPrint:Say(nLinha,070,MemoLine(cDetDocto,250,nXi),oFontRos,1000)
          Else
             oPrint:Say(nLinha,070,MemoLine(cDetDocto,250,nXi),oFontDad2,1000)       
          EndIf
          nLinha += 50
       EndIf   
   Next nXi
   nLinha += 10      
EndIf
*/
oPrint:Preview()

Return



Static Function Cabec(oPrint,nLinha,cAliasTemp,aDadosFor,nPgAtu,nTotPg,aDadCab)
*********************************************************************************
* 
***

Local nXi := 0
Local sEmp := "T"
Local sNameComp := GetNameCpr(SUBSTR(aDadCab[1],3,6))

DO CASE
	CASE cEmpAnt == "04"
		sEmp := "M"
	CASE cEmpAnt == "03"
		sEmp := "L"
	OTHERWISE
		sEmp := "T"
ENDCASE

oPrint:EndPage()
oPrint:StartPage() 		// Inicia uma nova pagina
nPgAtu++
aDadosFor := Iif(aDadosFor!=Nil,aDadosFor,{'NOME FORNECEDOR','ENDERECO','REPRESENTANTE','CONTATO','FONE','EMAIL',''})

If nPgAtu == 1
	oPrint:Box(0050,0050,750,2300) //Box cabecalho
    
    oPrint:Line(0750,0050,0810,0050) // Linha vertical borda descricao de forneceimento esquerda
    oPrint:Line(0750,2300,0810,2300) // Linha vertical borda descricao de forneceimento direta
        
	oPrint:Say(0075,0400,OemToAnsi("ORDEM DE COMPRA / SERVIÇO"),oFontTit,100)
	oPrint:Say(0075,1850,OemToAnsi("Pagina:")+StrZero(nPgAtu,2)+' de '+StrZero(nTotPg,2),oFontRos,100)
	oPrint:SayBitmap(210,1920,"\SYSTEM\lgrl"+cEmpAnt+".bmp",300,120)
	oPrint:Box(0150,0050,0152,2300) //Lina dupla separador horizontal Box cabecalho
	oPrint:Box(0050,1800,0750,1800) //Lina dupla separador vertical Box cabecalho
	
	oPrint:Say(0185,0070,Capital(SM0->M0_NOMECOM),oFontRos,100)
	oPrint:Say(0245,0070,Alltrim(Capital(SM0->M0_ENDCOB))+" - "+ Alltrim(Capital(SM0->M0_BAIRCOB))+" - "+ Alltrim(SM0->M0_CEPCOB),oFontRos,100)
	oPrint:Say(0295,0070,"Fone: "+SM0->M0_TEL+"      Fax: "+SM0->M0_FAX,oFontRos,100)
	oPrint:Say(0345,0070,OemToAnsi("CPNJ: ")+Iif(Len(Alltrim(SM0->M0_CGC))==14,Transform(SM0->M0_CGC,"@R 99.999.999/9999-99"),Transform(SM0->M0_CGC,"@R 999.999.999-99")),oFontRos,100)
	oPrint:Say(0345,0780,OemToAnsi("Inscrição Municipal: ")+SM0->M0_INSC,oFontRos,100)
	
	oPrint:Say(0395,0070,"Comprador: "+sNameComp+"  "+OemToAnsi("Email: ")+GetNewpar("NM_MAILEMP","suprimentos@tsamg.com.br"),oFontRos,100)
	oPrint:Say(0395,08000,OemToAnsi("Email Nota Fiscal: ")+GetNewpar("NM_MAILNF","tsamg@tsamg.com.br"),oFontRos,100)
	oPrint:Box(0445,0050,0447,1800)// Linha serador fornecedor
	
	oPrint:Say(0450,0070,OemToAnsi("DADOS FORNECEDOR:"),oFontRos,100)
	
	oPrint:Say(0500,0070,OemToAnsi("Razão Social:"),oFontRos,100)
	oPrint:Say(0505,0400,aDadosFor[2],oFontDad,100)
	
	oPrint:Say(0550,0070,OemToAnsi("Endereço:"),oFontRos,100)
	oPrint:Say(0555,0310,aDadosFor[3],oFontDad,100)
	
	oPrint:Say(0600,0070,OemToAnsi("Fone/Fax:"),oFontRos,100)
	oPrint:Say(0605,0350,aDadosFor[6],oFontDad,100)
	
	oPrint:Say(0650,0070,OemToAnsi("CNPJ:"),oFontRos,100)
	oPrint:Say(0655,0350,aDadosFor[8],oFontDad,100)
	
	oPrint:Say(0700,0070,OemToAnsi("Pessoa Contato:"),oFontRos,100)
	oPrint:Say(0705,0420,aDadosFor[5],oFontDad,100)
	
	oPrint:Say(0700,0900,OemToAnsi("E-mail:"),oFontRos,100)
	oPrint:Say(0705,1060,aDadosFor[7],oFontDad,100)
	
	
	//Quadro logo e informações pedido
	oPrint:Line(0400,1800,0400,2300)
	oPrint:FillRect({0402,1805,0500,2300},Tbrush():New(,CLR_HGRAY) )
	oPrint:Say(0400,1810,OemToAnsi("No TSA: ")+aDadCab[1],oFontRos,100) // se descricao do tipo do sb1 contido servico OS+C7NUM,OC+C7NUM
	
	oPrint:Line(0450,1800,0450,2300)
	oPrint:Say(0450,1810,OemToAnsi("DATA: ")+aDadCab[2],oFontRos,100)// C7_EMISSAO
	
	oPrint:Line(0500,1800,0500,2300)
	oPrint:Say(0500,1810,OemToAnsi("FILIAL/PROJETO: ")+cFilAnt+"/"+sEmp+aDadCab[3],oFontCab,100)//C7_ITEMCTA CTD->CTD_DESC01
	
	oPrint:Line(0550,1800,0550,2300)
	oPrint:Say(0550,1810,OemToAnsi("No SC: ")+aDadCab[4],oFontCab,100)//C7_ITEMCTA
	
	oPrint:Line(0600,1800,0600,2300)
	oPrint:Say(0600,1810,OemToAnsi("No PROPOSTA: ")+aDadCab[5],oFontCab,100)//
	
	oPrint:Line(0650,1800,0650,2300)
	oPrint:Say(0650,1810,OemToAnsi("DATA PROPOSTA: ")+aDadCab[6],oFontCab,100)
	
	oPrint:Line(0700,1800,0700,2300)
	oPrint:Say(0700,1810,"OS("+Iif(Left(aDadCab[1],2)=="OS"," X ","   ")+")   OC("+Iif(Left(aDadCab[1],2)=="OC"," X ","   ")+")",oFontRos,100)
	
	nLinha := 0810
Else
	oPrint:Box(0050,0050,250,2300) //Box cabecalho
	oPrint:Box(0150,0050,0152,2300) //Lina dupla separador horizontal Box cabecalho
	oPrint:Say(0075,0400,OemToAnsi("ORDEM DE COMPRA / SERVIÇO"),oFontTit,100)
	oPrint:Say(0075,1850,OemToAnsi("Pagina:")+StrZero(nPgAtu,2)+' de '+StrZero(nTotPg,2),oFontRos,100)

	oPrint:Say(0185,0070,OemToAnsi("OS/OC: ")+aDadCab[1],oFontRos,100)
	oPrint:Say(0185,0650,OemToAnsi("No SC: ")+aDadCab[4],oFontRos,100)
	oPrint:Say(0185,1200,OemToAnsi("DATA: ")+aDadCab[2],oFontRos,100)
	oPrint:Say(0185,1850,OemToAnsi("FILIAL/PROJETO: ")+cFilAnt+"/"+sEmp+aDadCab[3],oFontCab,100)
		
		
	nLinha := 310
EndIf

Return



Static Function ItensPC(oPrint,nLinha,aItensPC,cAliasTemp,aDadosFor,cChaveOld,aDadCab,nPgAtu,nTotPg,cCondPad,lPedLib,cTpFrete,cDetCot,cEscopo,cMarcos)
*********************************************************************************
* 
***        

Local aAuxi   := {}
Local nAjuste := 0
Local nXi := 0

oPrint:Box(nLinha,0050,nLinha+1150,2300) //Box Itens
// Titulos das colunas dos itens
oPrint:Say(nLinha-50,0060   ,OemToAnsi("A- DESCRIÇÃO DO FORNECIMENTO"),oFontCab,100)

oPrint:Say(nLinha,0055   ,OemToAnsi("ITEM"),oFontCab,100)
oPrint:Say(nLinha,0155   ,OemToAnsi("QTDE"),oFontCab,100)
oPrint:Say(nLinha,0260   ,OemToAnsi("UND"),oFontCab,100)
oPrint:Say(nLinha,0330   ,OemToAnsi("Descrição do Fornecimento (prod./serviço)"),oFontCab,100)
oPrint:Say(nLinha,1180   ,OemToAnsi("C.Fiscal"),oFontCab,100) 
oPrint:Say(nLinha,1380   ,OemToAnsi("Pr.Unit."),oFontCab,100)// Daqui para baixo
oPrint:Say(nLinha,1695   ,OemToAnsi("Impostos"),oFontCab,100)
oPrint:Say(nLinha+50,1540,OemToAnsi("ICMS R."),oFontIte,100)
oPrint:Say(nLinha+50,1685,OemToAnsi("ICMS"),oFontIte,100)
oPrint:Say(nLinha+50,1780,OemToAnsi("IPI"),oFontIte,100)
oPrint:Say(nLinha+50,1880,OemToAnsi("%"),oFontIte,100)
oPrint:Say(nLinha,1930   ,OemToAnsi("Pr Final"),oFontCab,100)
oPrint:Say(nLinha,2120   ,OemToAnsi("Prazo Entr"),oFontCab,100)


// Linhas Verticais
oPrint:Line(nLinha,0140,nLinha+1150,0140)
oPrint:Line(nLinha,0240,nLinha+1150,0240)
oPrint:Line(nLinha,0320,nLinha+1150,0320)
oPrint:Line(nLinha,1170,nLinha+1150,1170)
oPrint:Line(nLinha,1340,nLinha+1150,1340) // Daqui para baixo
oPrint:Line(nLinha,1530,nLinha+1150,1530)
oPrint:Line(nLinha+50,1670,nLinha+1150,1670)
oPrint:Line(nLinha+50,1770,nLinha+1150,1770)
oPrint:Line(nLinha+50,1870,nLinha+1150,1870)
oPrint:Line(nLinha,1910,nLinha+1150,1910)
oPrint:Line(nLinha,2100,nLinha+1150,2100)
/*
oPrint:Line(nLinha,0170,nLinha+1150,0170)
oPrint:Line(nLinha,0300,nLinha+1150,0300)
oPrint:Line(nLinha,0410,nLinha+1150,0410)
oPrint:Line(nLinha,1260,nLinha+1150,1260)
oPrint:Line(nLinha,1480,nLinha+1150,1480)
oPrint:Line(nLinha,1670,nLinha+1150,1670)
oPrint:Line(nLinha+50,1810,nLinha+1150,1810)
oPrint:Line(nLinha+50,1910,nLinha+1150,1910)
oPrint:Line(nLinha+50,2010,nLinha+1150,2010)
oPrint:Line(nLinha,2040,nLinha+1150,2040)
*/


// Linhas Horizontais
For nXi := 1 To 21
    nLinha += 50
    If Len(aItensPC) >= nXi
       oPrint:Say(nLinha+50,0060   ,aItensPC[nXi][01],oFontIte,100)
       oPrint:Say(nLinha+50,0155   ,aItensPC[nXi][02],oFontIte,100)
       oPrint:Say(nLinha+50,0260   ,aItensPC[nXi][03],oFontIte,100)
       oPrint:Say(nLinha+50,0330   ,aItensPC[nXi][04],oFontIte,100)
       oPrint:Say(nLinha+50,1180   ,aItensPC[nXi][05],oFontIte,100)
       oPrint:Say(nLinha+50,1380   ,aItensPC[nXi][07],oFontIte,100)
       oPrint:Say(nLinha+50,1540   ,aItensPC[nXi][06],oFontIte,100)
       oPrint:Say(nLinha+50,1685   ,aItensPC[nXi][09],oFontIte,100)
       oPrint:Say(nLinha+50,1780   ,aItensPC[nXi][10],oFontIte,100)
       oPrint:Say(nLinha+50,1880   ,'%',oFontIte,100)
       oPrint:Say(nLinha+50,1930   ,aItensPC[nXi][11],oFontIte,100)
       oPrint:Say(nLinha+50,2120   ,dtoc(aItensPC[nXi][13]),oFontIte,100)
       
    EndIf
/*
oPrint:Say(nLinha,0060   ,OemToAnsi("ITEM"),oFontCab,100)
oPrint:Say(nLinha,0155   ,OemToAnsi("QTDE"),oFontCab,100)
oPrint:Say(nLinha,0260   ,OemToAnsi("UND"),oFontCab,100)
oPrint:Say(nLinha,0330   ,OemToAnsi("Descrição do Fornecimento (prod./serviço)"),oFontCab,100)
oPrint:Say(nLinha,1180   ,OemToAnsi("C.Fiscal"),oFontCab,100) 
oPrint:Say(nLinha,1380   ,OemToAnsi("Pr.Unit."),oFontCab,100)// Daqui para baixo
oPrint:Say(nLinha,1695   ,OemToAnsi("Impostos"),oFontCab,100)
oPrint:Say(nLinha+50,1540,OemToAnsi("ICMS R."),oFontIte,100)
oPrint:Say(nLinha+50,1685,OemToAnsi("ICMS"),oFontIte,100)
oPrint:Say(nLinha+50,1780,OemToAnsi("IPI"),oFontIte,100)
oPrint:Say(nLinha+50,1880,OemToAnsi("%"),oFontIte,100)
oPrint:Say(nLinha,1930   ,OemToAnsi("Pr Final"),oFontCab,100)*/

    oPrint:Line(nLinha,050,nLinha,2300)
Next nXi         

nLinha += 100
oPrint:Box(nLinha ,0050,nLinha+230,2300) //Box Itens
oPrint:Box(nLinha+50,0050,nLinha+52,2300) //Lina dupla separador horizontal Box cabecalho



//oPrint:Line(nLinha,0450,nLinha+230,0450) // Linha vertical
//oPrint:Line(nLinha,1570,nLinha+230,1570) // Linha vertical
oPrint:Line(nLinha,1850,nLinha+230,1850) // Linha vertical
nLinha += 010
oPrint:Say(nLinha,0060   ,OemToAnsi("B-ESCOPO"),oFontCab,100)

nAuxi := 0
nAuxi  += 50
For nXi:=1 To MLCount(cEscopo,100)
    oPrint:Say(nLinha+nAuxi,070,StrTran(MemoLine(cEscopo,100,nXi),"#",Space(1)),oFontDad2,1000)       
    nAuxi  += 40
    If nXi >= 4
       Exit
    EndIf
Next nXi

//oPrint:Say(nLinha,0460   ,OemToAnsi("Conforme descrito acima."),oFontIte,100)
oPrint:Say(nLinha,1860   ,OemToAnsi("DESTINAÇÃO DA COMPRA"),oFontCab,100)
nLinha += 050

//oPrint:Say(nLinha,1660   ,OemToAnsi("COMPRA"),oFontCab,100)
oPrint:Say(nLinha,1960   ,OemToAnsi("("+Iif(aItensPC[1][12]=='1',' S ','  ')+") Revenda"),oFontIte,100)
nLinha += 050
oPrint:Say(nLinha,1960   ,OemToAnsi("("+Iif(aItensPC[1][12]=='2',' S ','  ')+") Uso e consumo" ),oFontIte,100) 

nLinha += 050
oPrint:Say(nLinha,1960   ,OemToAnsi("("+Iif(aItensPC[1][12]=='3',' S ','  ')+") Industrializ." ),oFontIte,100) 

nLinha += 100
	

If Len(aItensPC) > 21    
   If(Type(cMarcos)== "U",cMarcos := "",)//##### THIAGO #### VERIFICA SE A VARIAVEL EXISTE, SENÃO CRIA VAZIO ####
   RodaPC(oPrint,@nLinha,cChaveOld,nTotPed,cCondPad,lPedLib,cCondPad,cTpFrete,cDetCot,cMarcos)
   For nXi := 22 To Len(aItensPC)
       Aadd(aAuxi,aItensPC[nXi])
   Next nXi
   
   aItensPC := aAuxi
   Cabec(@oPrint,@nLinha,cAliasTemp,aDadosFor,@nPgAtu,nTotPg,aDadCab)    
 //ItensPC(@oPrint,@nLinha,@aItensPC,cAliasTemp,aDadosFor,cChaveOld,aDadCab,cCondPad,lPedLib,cTpFrete)   
   ItensPC(@oPrint,@nLinha,@aItensPC,cAliasTemp,aDadosFor,cChaveOld,aDadCab,@nPgAtu,nTotPg,cCondPad,lPedLib,cTpFrete,cDetCot,cEscopo,cMarcos)
 //RodaPC(oPrint,@nLinha,cChaveOld,nTotPed,cCondPad,lPedLib,cCondPad,cTpFrete,cDetCot,cMarcos)  ##### THIAGO #### IMPRIMINDO DUPLICADO ÚLTIMA PAGINA DO RELATORIO ####
EndIf

Return



Static Function RodaPC(oPrint,nLinha,cNumPed,nTotPed,cCondPad,lPedLib,cCondPad,cTpFrete,cDetCot,cMarcos)
*********************************************************************************
* 
***

Local aAssina    := {}
Local cPrzEntreg := ""
Local cPrzIniFim := ""
Local nXi := 0
                  
dbSelectArea("SC8")
SC8->(dbSetOrder(1))//C8_FILIAL+C8_NUM+C8_FORNECE+C8_LOJA
SC8->(dbSeek(xFilial("SC8")+cDetCot+SA2->(A2_COD+A2_LOJA)))
If !SC8->(Eof())
   If !Empty(SC8->C8_PRAZO)
      cPrzEntreg := Alltrim(Str(SC8->C8_PRAZO)) + " Dia(s)"
   Else
      cPrzEntreg := "Imediato"
   EndIf   
   If !Empty(SC8->C8_PRAZINI) .And. !Empty(SC8->C8_PRAZFIM)
      cPrzIniFim := dtoc(SC8->C8_PRAZINI)+ " a "+dtoc(SC8->C8_PRAZFIM)
   Else
      cPrzIniFim := "___/___/______ a ___/___/______ "
   EndIf   
   
   
Else
   cPrzEntreg := "Imediato"
EndIf

oPrint:Box(nLinha,0050,nLinha+450,2300) //Box Rodape

oPrint:Say(nLinha,0060 ,OemToAnsi("C- CONDIÇÕES COMERCIAIS"),oFontCab,100)
//nLinha += 50
//oPrint:Say(nLinha,0060 ,OemToAnsi("ESCOPO DO FORNECEDOR"),oFontCab,100)
//oPrint:Line(nLinha,050,nLinha,2300)
nLinha += 50
oPrint:Line(nLinha,050,nLinha,2300)

oPrint:Say(nLinha,0060 ,OemToAnsi("C.1 Valor Total:"),oFontCab,100)
oPrint:Line(nLinha,0380,nLinha+050,0380) // Linha vertical

oPrint:Say(nLinha,0400 ,Transform(nTotPed,"@E 99,999,999.99"),oFontCab,100)
oPrint:Line(nLinha,0800,nLinha+050,0800) // Linha vertical
oPrint:Say(nLinha,0820 ,Capital(Extenso(nTotPed)),oFontCab,100)

nLinha += 50

oPrint:Line(nLinha,050,nLinha,2300)
oPrint:Line(nLinha,1200,nLinha+050,1200) // Linha vertical
oPrint:Say(nLinha,0060 ,OemToAnsi("C.2 PRAZO (Dias úteis ou corridos/Data):  "+cPrzEntreg),oFontCab,100)

oPrint:Say(nLinha,1250 ,OemToAnsi("C.3 Prazo "+cPrzIniFim),oFontCab,100)



nLinha += 50
oPrint:Line(nLinha,050,nLinha,2300)
oPrint:Line(nLinha,1200,nLinha+050,1200) // Linha vertical
oPrint:Say(nLinha,0060 ,OemToAnsi("C.4 COND. DE PAGAMENTO: ")+cCondPad,oFontCab,100) 
oPrint:Say(nLinha,1250 ,OemToAnsi("C.5 COND. DE FRETE: ")+Iif(cTpFrete=="C","CIF","FOB"),oFontCab,100) 
nLinha += 50
oPrint:Line(nLinha,050,nLinha,2300)
oPrint:Say(nLinha,0060 ,OemToAnsi("C.6 Marcos contratuais: "),oFontCab,100) 

nAuxi := 0
nAuxi  += 40

For nXi := 1 To MLCount(cMarcos,150)
    oPrint:Say(nLinha+nAuxi,070,StrTran(MemoLine(cMarcos,150,nXi),"#",Space(1)),oFontDad2,1000)       
    nAuxi  += 40
    If nXi >= 4
       Exit
    EndIf
Next nXi


nLinha += 50
//oPrint:Say(nLinha,0060 ,OemToAnsi("Os materiais somente poderão ser faturados e embarcados mediante autorização da TSA."),oFontIte,100)
nLinha += 50
//oPrint:Say(nLinha,0060 ,OemToAnsi("O pgto da nota fiscal será realizado via deposito bancario. Não será aceito a emissão de boleto."),oFontIte,100)
nLinha += 50
//oPrint:Say(nLinha,0060    ,OemToAnsi('No Campo "Observação Adicionais" da nota fiscal,deverá constar o número desta Ordem de Compra.'),oFontIte,100)


/*
oPrint:Say(nLinha,1700 ,OemToAnsi("ACEITE DO PEDIDO"),oFontCab,100) 

nLinha += 50
oPrint:Line(nLinha,050,nLinha,1200)
oPrint:Say(nLinha,0060 ,OemToAnsi("PRAZO DE ENTREGA(Dias (úteis/corridos) - Data):  Imediato"),oFontCab,100)


nLinha += 50
oPrint:Say(nLinha,0060 ,OemToAnsi("CONDIÇÃO DE ENTREGA:  CIF"),oFontCab,100)
oPrint:Line(nLinha,050,nLinha,1200)

nLinha += 50
oPrint:Line(nLinha,050,nLinha,1200)
oPrint:Say(nLinha,0060 ,OemToAnsi("OBSERVAÇÕES:"),oFontCab,100)
oPrint:Say(nLinha,0300 ,OemToAnsi("Substituição tributaria inclusa"),oFontIte,100)




nLinha += 50



nLinha += 50
oPrint:Say(nLinha,0060 ,OemToAnsi("O pgto da NF será realizado via deposito bancario."),oFontIte,100)

nLinha += 50
oPrint:Say(nLinha,0060    ,OemToAnsi('No Campo "Observação Adicionais" da nota fiscal,deverá '),oFontIte,100)
oPrint:Say(nLinha+50,0060 ,OemToAnsi('constar o número desta Ordem de Compra.'),oFontIte,100)

*/
nLinha += 100
// Linhas verticais
oPrint:Box( nLinha,0050,nLinha+400,2300) //Box de assinatura
oPrint:Line(nLinha,0388,nLinha+400,0388) // Linha vertical
oPrint:Line(nLinha,0786,nLinha+400,0786) // Linha vertical
oPrint:Line(nLinha,1195,nLinha+400,1195) // Linha vertical
oPrint:Line(nLinha,1603,nLinha+400,1603) // Linha vertical
oPrint:Line(nLinha,1970,nLinha+400,1970) // Linha vertical

aAssina := GetAssina(cNumPed,lPedLib)
oPrint:Box(nLinha-50,0050,nLinha-52,2300) //Lina dupla separador horizontal Box cabecalho
oPrint:Say(nLinha-35,0060 ,OemToAnsi("D- APROVAÇÃO"),oFontCab,100) 

For nXi := 1 To Len(aAssina)
    Do Case
       Case nXi == 1
            oPrint:Say(nLinha+030,0065,aAssina[nXi,1],oFontDad2,100)
            oPrint:Say(nLinha+130,0065,OemToAnsi("DATA: ")+Dtoc(aAssina[nXi,3]),oFontDad2,100)
            oPrint:Say(nLinha+230,0065,left(aAssina[nXi,4],19),oFontDad2,120)            
            oPrint:SayBitmap(nLinha+260,0065,aAssina[nXi,2],300,120)
       Case nXi == 2
            If aAssina[nXi,1]== "NãO SE APLICA"  .or. aAssina[nXi,1]=='Não Aprovado'
               oPrint:Say(nLinha+030,0400,aAssina[nXi,1],oFontDad2,100)
            Else
               oPrint:Say(nLinha+030,0400,aAssina[nXi,1],oFontDad2,120)
            EndIf
            oPrint:Say(nLinha+130,0406,OemToAnsi("DATA: ")+Dtoc(aAssina[nXi,3]),oFontDad2,100)
            oPrint:Say(nLinha+230,0400,left(aAssina[nXi,4],19),oFontDad2,120)            
            oPrint:SayBitmap(nLinha+260,0406,aAssina[nXi,2],300,120)
       Case nXi == 3
            If aAssina[nXi,1] == "NãO SE APLICA"  .or. aAssina[nXi,1]== 'Não Aprovado'
               oPrint:Say(nLinha+030,0810,aAssina[nXi,1],oFontDad2,120)           
            Else   
               oPrint:Say(nLinha+005,0810,Left(aAssina[nXi,1],10),oFontDad2,120)
               oPrint:Say(nLinha+055,0810,Alltrim(SubStr(aAssina[nXi,1],11,Len(aAssina[nXi,1]))),oFontDad2,100)
            EndIf
            
            oPrint:Say(nLinha+130,0810,OemToAnsi("DATA: ")+Dtoc(aAssina[nXi,3]),oFontDad2,120)            
            oPrint:Say(nLinha+230,0820,Left(aAssina[nXi,4],19),oFontDad2,120)
            oPrint:SayBitmap(nLinha+260,0820,aAssina[nXi,2],300,120)
       Case nXi == 4
            If aAssina[nXi,1] == "NãO SE APLICA"  .or. aAssina[nXi,1]=='Não Aprovado'
               oPrint:Say(nLinha+030,1230,aAssina[nXi,1],oFontDad2,120)           
            Else   
               oPrint:Say(nLinha+005,1230,Left(aAssina[nXi,1],10),oFontDad2,120)
               oPrint:Say(nLinha+055,1230,Alltrim(SubStr(aAssina[nXi,1],11,Len(aAssina[nXi,1]))),oFontDad2,120)
            EndIf
            oPrint:Say(nLinha+130,1233,OemToAnsi("DATA: ")+Dtoc(aAssina[nXi,3]),oFontDad2,120)                        
            oPrint:Say(nLinha+230,1230,Left(aAssina[nXi,4],19),oFontDad2,120)           
            oPrint:SayBitmap(nLinha+260,1230,aAssina[nXi,2],300,120)
       Case nXi == 5
            If aAssina[nXi,1]== "NãO SE APLICA"  .or. aAssina[nXi,1]=='Não Aprovado'
               oPrint:Say(nLinha+030,1630,aAssina[nXi,1],oFontDad2,120)
            Else
               oPrint:Say(nLinha+005,1630,Left(aAssina[nXi,1],12),oFontDad2,120)
               oPrint:Say(nLinha+055,1630,Alltrim(SubStr(aAssina[nXi,1],13,Len(aAssina[nXi,1]))),oFontDad2,120)
            EndIf
            oPrint:Say(nLinha+130,1633,OemToAnsi("DATA: ")+Dtoc(aAssina[nXi,3]),oFontDad2,120)
            oPrint:Say(nLinha+230,1630,Left(aAssina[nXi,4],19),oFontDad2,120)           
            oPrint:SayBitmap(nLinha+260,1633,aAssina[nXi,2],300,120)
       Case nXi == 6
            If aAssina[nXi,1]== "NãO SE APLICA"  .or. aAssina[nXi,1]=='Não Aprovado'
               oPrint:Say(nLinha+030,1980,aAssina[nXi,1],oFontDad2,120)
            Else
               oPrint:Say(nLinha+005,1980,Left(aAssina[nXi,1],09),oFontDad2,120)
               oPrint:Say(nLinha+055,1980,Alltrim(SubStr(aAssina[nXi,1],10,Len(aAssina[nXi,1]))),oFontDad2,120)
            EndIf
            oPrint:Say(nLinha+130,1982,OemToAnsi("DATA: ")+Dtoc(aAssina[nXi,3]),oFontDad2,120)
            oPrint:Say(nLinha+230,1980,Left(aAssina[nXi,4],19),oFontDad2,120)           
            oPrint:SayBitmap(nLinha+260,1980,aAssina[nXi,2],300,120)
    End
Next nXi    
nLinha += 100


oPrint:Line(nLinha,050,nLinha,2300)
nLinha += 070
oPrint:Line(nLinha,050,nLinha,2300)
nLinha += 100
oPrint:Line(nLinha,050,nLinha,2300)

nLinha += 175
oPrint:Box( nLinha,0050,nLinha+250,2300) //Box de Aceite

oPrint:Say(nLinha,0060,OemToAnsi("E- ACEITE DO PEDIDO"),oFontCab,100) 
nLinha += 50
oPrint:Box(nLinha-5,0050,nLinha-6,2300) //Lina dupla separador horizontal Box cabecalho
oPrint:Say(nLinha,0060 ,OemToAnsi("Confirmamos o aceite integral deste pedido em concordância com todas as condições gerais de fornecimento."),oFontIte,100)
nLinha += 50
oPrint:Say(nLinha,0060 ,OemToAnsi("Data de aceite do pedido: _____/_____/_________"),oFontIte,100)
nLinha += 50
oPrint:Say(nLinha,0060 ,OemToAnsi("Assinatura:_______________________________________________________"),oFontIte,100)
nLinha += 50
oPrint:Say(nLinha,0060 ,OemToAnsi("O pagamento de nota fiscal somente será liebrado mediante o recebimento do aceite deste pedido."),oFontIte,100)


Return



Static Function GetAssina(cNumPed,lPedLib)
*************************************************************************
*
**
Local nNivel    := 1
Local aRetAss   := {}
Local cAliasSCR := ""
Local cIdUsrOld := PswID()
Local aAreaOld  := GetArea()
Local cPathAssi := GetNewPar("NM_ASSINA","\assinatura\")

If lPedLib
   Aadd(aRetAss,{'NãO SE APLICA',cPathAssi+"NAOSEAPLICA.bmp",STOD(""),""}) //01 Titulo,02 Imagem,03 Data da Lib,04 Nome - Nivel 1
   Aadd(aRetAss,{'NãO SE APLICA',cPathAssi+"NAOSEAPLICA.bmp",STOD(""),""}) //01 Titulo,02 Imagem,03 Data da Lib,04 Nome - Nivel 2
   Aadd(aRetAss,{'NãO SE APLICA',cPathAssi+"NAOSEAPLICA.bmp",STOD(""),""}) //01 Titulo,02 Imagem,03 Data da Lib,04 Nome - Nivel 3
   Aadd(aRetAss,{'NãO SE APLICA',cPathAssi+"NAOSEAPLICA.bmp",STOD(""),""}) //01 Titulo,02 Imagem,03 Data da Lib,04 Nome - Nivel 4
   Aadd(aRetAss,{'NãO SE APLICA',cPathAssi+"NAOSEAPLICA.bmp",STOD(""),""}) //01 Titulo,02 Imagem,03 Data da Lib,04 Nome - Nivel 5
   Aadd(aRetAss,{'NãO SE APLICA',cPathAssi+"NAOSEAPLICA.bmp",STOD(""),""}) //01 Titulo,02 Imagem,03 Data da Lib,04 Nome - Nivel 6
Else
   Aadd(aRetAss,{'Não Aprovado',cPathAssi+"ASS_NAO_ENC.bmp",STOD(""),""}) //01 Titulo,02 Imagem,03 Data da Lib,04 Nome - Nivel 1
   Aadd(aRetAss,{'Não Aprovado',cPathAssi+"ASS_NAO_ENC.bmp",STOD(""),""}) //01 Titulo,02 Imagem,03 Data da Lib,04 Nome - Nivel 2
   Aadd(aRetAss,{'Não Aprovado',cPathAssi+"ASS_NAO_ENC.bmp",STOD(""),""}) //01 Titulo,02 Imagem,03 Data da Lib,04 Nome - Nivel 3
   Aadd(aRetAss,{'Não Aprovado',cPathAssi+"ASS_NAO_ENC.bmp",STOD(""),""}) //01 Titulo,02 Imagem,03 Data da Lib,04 Nome - Nivel 4
   Aadd(aRetAss,{'Não Aprovado',cPathAssi+"ASS_NAO_ENC.bmp",STOD(""),""}) //01 Titulo,02 Imagem,03 Data da Lib,04 Nome - Nivel 5
   Aadd(aRetAss,{'Não Aprovado',cPathAssi+"ASS_NAO_ENC.bmp",STOD(""),""}) //01 Titulo,02 Imagem,03 Data da Lib,04 Nome - Nivel 6
EndIf

cAliasSCR := GetNextAlias()  
BeginSql Alias cAliasSCR //Inicio do Embedded SQL   
   COLUMN  CR_DATALIB AS DATE
   SELECT CR_NIVEL,CR_USERLIB,CR_DATALIB FROM %Table:SCR% SCR
       WHERE SCR.%NotDel%
             AND CR_FILIAL+CR_NUM = %Exp:cNumPed%
             AND CR_LIBAPRO != %Exp:''%
   ORDER BY CR_NIVEL
EndSql

PswOrder(1)

dbSelectArea(cAliasSCR)
(cAliasSCR)->(dbGotop())
While !(cAliasSCR)->(Eof())
   PswSeek(AllTrim((cAliasSCR)->CR_USERLIB),.T.)
   Do Case
      Case (cAliasSCR)->CR_NIVEL == '01' 
           aRetAss[1,1] :=  OemToAnsi("CAF") // Titulo
           aRetAss[1,2] :=  Iif(File(cPathAssi+Alltrim((cAliasSCR)->CR_USERLIB)+".bmp"),cPathAssi+Alltrim((cAliasSCR)->CR_USERLIB)+".bmp",cPathAssi+"ASS_NAO_ENC.bmp") // Nome da Imagem
           aRetAss[1,3] :=  (cAliasSCR)->CR_DATALIB // Data da liberacao
           aRetAss[1,4] :=  Left(PswRet(1)[1][4],21) // Nome do Usuario
      Case (cAliasSCR)->CR_NIVEL == '02'
           aRetAss[2,1] :=  OemToAnsi("GERENTE") 
           aRetAss[2,2] :=  Iif(File(cPathAssi+Alltrim((cAliasSCR)->CR_USERLIB)+".bmp"),cPathAssi+Alltrim((cAliasSCR)->CR_USERLIB)+".bmp",cPathAssi+"ASS_NAO_ENC.bmp") // Nome da Imagem
           aRetAss[2,3] :=  (cAliasSCR)->CR_DATALIB // Data da liberacao
           aRetAss[2,4] :=  Left(PswRet(1)[1][4],21) // Nome do Usuario
      Case (cAliasSCR)->CR_NIVEL == '03' 
           aRetAss[3,1] :=  OemToAnsi("DIRETORIA ADM-FINANCEIRA") // Titulo
           aRetAss[3,2] :=  Iif(File(cPathAssi+Alltrim((cAliasSCR)->CR_USERLIB)+".bmp"),cPathAssi+Alltrim((cAliasSCR)->CR_USERLIB)+".bmp",cPathAssi+"ASS_NAO_ENC.bmp") // Nome da Imagem
           aRetAss[3,3] :=  (cAliasSCR)->CR_DATALIB // Data da liberacao
           aRetAss[3,4] :=  Left(PswRet(1)[1][4],21) // Nome do Usuario
      Case (cAliasSCR)->CR_NIVEL == '04' 
           aRetAss[4,1] :=  OemToAnsi("GERENTE DE AREA") // Titulo
           aRetAss[4,2] :=  Iif(File(cPathAssi+Alltrim((cAliasSCR)->CR_USERLIB)+".bmp"),cPathAssi+Alltrim((cAliasSCR)->CR_USERLIB)+".bmp",cPathAssi+"ASS_NAO_ENC.bmp") // Nome da Imagem
           aRetAss[4,3] :=  (cAliasSCR)->CR_DATALIB // Data da liberacao
           aRetAss[4,4] :=  Left(PswRet(1)[1][4],21) // Nome do Usuario

      Case (cAliasSCR)->CR_NIVEL == '05' 
           aRetAss[5,1] :=  OemToAnsi("DIRETORIA DE ENGENHARIA") // Titulo
           aRetAss[5,2] :=  Iif(File(cPathAssi+Alltrim((cAliasSCR)->CR_USERLIB)+".bmp"),cPathAssi+Alltrim((cAliasSCR)->CR_USERLIB)+".bmp",cPathAssi+"ASS_NAO_ENC.bmp") // Nome da Imagem
           aRetAss[5,3] :=  (cAliasSCR)->CR_DATALIB // Data da liberacao
           aRetAss[5,4] :=  Left(PswRet(1)[1][4],21) // Nome do Usuario
      Case (cAliasSCR)->CR_NIVEL == '06' 
           aRetAss[6,1] :=  OemToAnsi("DIRETORIA PRESIDENTE") // Titulo
           aRetAss[6,2] :=  Iif(File(cPathAssi+Alltrim((cAliasSCR)->CR_USERLIB)+".bmp"),cPathAssi+Alltrim((cAliasSCR)->CR_USERLIB)+".bmp",cPathAssi+"ASS_NAO_ENC.bmp") // Nome da Imagem
           aRetAss[6,3] :=  (cAliasSCR)->CR_DATALIB // Data da liberacao
           aRetAss[6,4] :=  Left(PswRet(1)[1][4],21) // Nome do Usuario
   EndCase

   (cAliasSCR)->(dbSkip())
End
dbSelectArea(cAliasSCR)
(cAliasSCR)->(dbCloseArea())

PswSeek(cIdUsrOld,.T.)

RestArea(aAreaOld)
Return(aRetAss)

Static Function GetNameCpr(cNumPed)
	sComp := ""
	
	cQuery:="SELECT DISTINCT SC7.C7_FILIAL,SC7.C7_NUM,C1_CODCOMP, Y1_EMAIL, SC7.R_E_C_N_O_ FROM "+RetSqlName("SC1")+" AS SC1 "
	cQuery+=" INNER JOIN "+RetSqlName("SY1")+" AS SY1 ON SC1.C1_CODCOMP = SY1.Y1_COD"
	cQuery+=" INNER JOIN "+RetSqlName("SC7")+" AS SC7 ON SC7.C7_NUMSC = SC1.C1_NUM AND SC1.C1_FILIAL = SC7.C7_FILIAL" 
	cQuery+=" WHERE SY1.D_E_L_E_T_ = '' AND SC1.D_E_L_E_T_ = '' AND SC7.D_E_L_E_T_ = '' AND SC7.C7_NUM = '"+cNumPed+"'" 
	
	TCQUERY cQuery ALIAS "CPR" New
	dbSelectArea("CPR")
	
	if !Eof()	
		aArray := StrToKarr( CPR->Y1_EMAIL , '@')
		aArray := StrToKarr( aArray[1] , '.')
		sComp := Capital(aArray[1])+" "+Capital(aArray[2])
	EndIf
	
	dbSelectArea("CPR")
	dbCloseArea()
	
Return(sComp)
