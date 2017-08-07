#Include 'RwMake.ch'
/*
+-----------------------------------------------------------------------+
¦Programa  ¦ReproAut   ¦ Autor ¦ Gilson Lucas          ¦Data ¦14.09.2012¦
+----------+------------------------------------------------------------¦
¦Descricao ¦Envio de E-mail no pedido de compra            		   		¦
+----------+------------------------------------------------------------¦
¦ Uso      ¦ ESPECIFICO PARA A TSA                                      ¦
+-----------------------------------------------------------------------¦
¦           ATUALIZACOES SOFRIDAS DESDE A CONSTRUCAO INICIAL            ¦
+-----------------------------------------------------------------------¦
¦PROGRAMADOR ¦ DATA   ¦ MOTIVO DA ALTERACAO                             ¦
+------------+--------+-------------------------------------------------¦
¦ Leandro M  ¦24/06/13¦ Inclusão pesquisa por filial                    ¦
¦            ¦        ¦                                                 ¦
+-----------------------------------------------------------------------+
*/
User Function ReproAut()
*************************************************************************
* Marcacao dos titulos
**
Local oDlgTit
Local oSelTit
Local nXi          := 0
Local nOpcX        := 0
Local aCabTit      := {}
Local aDadTit      := {}
Local cAliasQry    := ""
Local cExpOrder    := ""
Local cPerg        := "PROAUTO"
Local aAreaOld     := GetArea()
Local oFont        := TFont():New( "Arial",,16,,.T.,,,,.T.,.F. )
Local oOk          := LoadBitMap(GetResources(),"LBOK")
Local oNo          := LoadBitMap(GetResources(),"LBNO")
Private dDtaProg     := Date()+1

PutSx1(cPerg,"01",OemToAnsi("Vencto Incial ?")     ,OemToAnsi("Vencto Incial ?")     ,OemToAnsi("Vencto Incial ?")     ,"mv_ch1","D",TamSx3("E2_VENCREA")[1],0,0,"G","","","",""    ,"mv_par01","","","","","","","","","","","","","","","","",{ OemToAnsi("Define a Vencto Inicial ")  ,OemToAnsi("do filtro.")}, {}, {} )
PutSx1(cPerg,"02",OemToAnsi("Vencto Final ?")      ,OemToAnsi("Vencto Final ?")      ,OemToAnsi("Vencto Final ?")      ,"mv_ch2","D",TamSx3("E2_VENCREA")[1],0,0,"G","","","",""    ,"mv_par02","","","","","","","","","","","","","","","","",{ OemToAnsi("Define a Vencto Final ")    ,OemToAnsi("do filtro.")}, {}, {} )
PutSx1(cPerg,"03",OemToAnsi("Numero Incial ?")     ,OemToAnsi("Numero Incial ?")     ,OemToAnsi("Numero Incial ?")     ,"mv_ch3","C",TamSx3("E2_NUM")[1]    ,0,0,"G","","","",""    ,"mv_par03","","","","","","","","","","","","","","","","",{ OemToAnsi("Define a numero Inicial ")  ,OemToAnsi("do filtro.")}, {}, {} )
PutSx1(cPerg,"04",OemToAnsi("Numero Final ?")      ,OemToAnsi("Numero Final ?")      ,OemToAnsi("Numero Final ?")      ,"mv_ch4","C",TamSx3("E2_NUM")[1]    ,0,0,"G","","","",""    ,"mv_par04","","","","","","","","","","","","","","","","",{ OemToAnsi("Define a numero Final ")    ,OemToAnsi("do filtro.")}, {}, {} )
PutSx1(cPerg,"05",OemToAnsi("Fornecedor Incial ?") ,OemToAnsi("Fornecedor Incial ?") ,OemToAnsi("Fornecedor Incial ?") ,"mv_ch5","C",TamSx3("E2_FORNECE")[1],0,0,"G","","SA2","","" ,"mv_par05","","","","","","","","","","","","","","","","",{ OemToAnsi("Define o Fornecedor Inicial ")  ,OemToAnsi("do filtro.")}, {}, {} )
PutSx1(cPerg,"06",OemToAnsi("Fornecedor  Final ?") ,OemToAnsi("Fornecedor Final ?")  ,OemToAnsi("Fornecedor Final ?")  ,"mv_ch6","C",TamSx3("E2_FORNECE")[1],0,0,"G","","SA2","","" ,"mv_par06","","","","","","","","","","","","","","","","",{ OemToAnsi("Define o Fornecedor Final ")    ,OemToAnsi("do filtro.")}, {}, {} )
PutSx1(cPerg,"07",OemToAnsi("Ordem ?")             ,OemToAnsi("Ordem ?")             ,OemToAnsi("Ordem ?")             ,"mv_ch7","N",01,0,0,"C","","","","","mv_par07","Numero","Numero","Numero","","Vencto Real","Vencto Real","Vencto Real","Nome","Nome","Nome","","","","","","",{ OemToAnsi("Define quais status serão Impressos")}, {}, {} )
PutSx1(cPerg,"08",OemToAnsi("Filial De ?")         ,OemToAnsi("Filial De ?")         ,OemToAnsi("Filial De ?")         ,"mv_ch8","C",02,0,0,"G","","","",""	,"mv_par08","","","","","","","","","","","","","","","","",{ OemToAnsi("Numero da filial Inicial")}		, {}, {} )
PutSx1(cPerg,"09",OemToAnsi("Filial Até ?")        ,OemToAnsi("Filial Até ?")        ,OemToAnsi("Filial Até ?")        ,"mv_ch9","C",02,0,0,"G","","","",""	,"mv_par09","","","","","","","","","","","","","","","","",{ OemToAnsi("Numero da filial Final")}		, {}, {} )

If Pergunte(cPerg,.T.)
   Do Case
      Case MV_PAR07  == 1 
           cExpOrder := "E2_NUM"
      Case MV_PAR07  == 2 
           cExpOrder := "E2_VENCREA"
      Case MV_PAR07  == 3 
           cExpOrder := "A2_NOME"     
   EndCase
   

   cAliasQry := GetNextAlias()
   BeginSql Alias cAliasQry
      COLUMN E2_VENCTO  AS DATE
      COLUMN E2_EMISSAO AS DATE
      COLUMN E2_VENCREA AS DATE
      SELECT A2_NOME,E2_PREFIXO,E2_VENCREA,E2_NUM,E2_NUMBCO,E2_PREFIXO,E2_PARCELA,E2_PORTADO,E2_PARCELA, E2_FILIAL,
             E2_FORNECE,E2_LOJA,E2_VALOR,E2_VENCTO,E2_SALDO,E2_TIPO,E2_EMISSAO,SE2.R_E_C_N_O_ REGSE2
      FROM %table:SE2% SE2 , %table:SA2% SA2
      WHERE SE2.%NotDel% 
            AND SA2.%NotDel% 
/*            AND SE2.E2_FILIAL = %xFilial:SE2% 
            AND SA2.A2_FILIAL = %xFilial:SA2%   */
            AND E2_FORNECE = A2_COD
            AND E2_LOJA    = A2_LOJA
            AND E2_VENCREA BETWEEN %Exp:Dtos(MV_PAR01)% AND %Exp:Dtos(MV_PAR02)%
            AND E2_NUM BETWEEN     %Exp:MV_PAR03% AND %Exp:MV_PAR04%
            AND E2_FORNECE BETWEEN %Exp:MV_PAR05% AND %Exp:MV_PAR06%
            AND E2_FILIAL BETWEEN  %Exp:MV_PAR08% AND %Exp:MV_PAR09%
            AND E2_SALDO > %Exp:'0'%
      ORDER BY %Exp:cExpOrder%
   EndSql
   
   
   dbSelectArea(cAliasQry)
   (cAliasQry)->(dbGotop())
   
   While !(cAliasQry)->(Eof())
       Aadd(aDadTit,{.T.,;               
       				(cAliasQry)->E2_FILIAL,;
                    (cAliasQry)->E2_NUM,;
                    (cAliasQry)->E2_PARCELA,;
                    (cAliasQry)->E2_EMISSAO,;
                    (cAliasQry)->E2_VENCREA,;
                    Transform((cAliasQry)->E2_SALDO,"@E 99,999,999.99"),;
                    (cAliasQry)->E2_FORNECE,;
                    (cAliasQry)->E2_LOJA,;
                    (cAliasQry)->A2_NOME,;
                    (cAliasQry)->REGSE2 })
       
       (cAliasQry)->(dbSkip())
   End
   dbSelectArea(cAliasQry)
   (cAliasQry)->(dbCloseArea())
   
   
   If !Empty(aDadTit)
      Aadd(aCabTit,OemToAnsi(""))
      Aadd(aCabTit,OemToAnsi("Filial"))
      Aadd(aCabTit,OemToAnsi("Numero"))
      Aadd(aCabTit,OemToAnsi("Parcela"))      
      Aadd(aCabTit,OemToAnsi("Emissão"))      
      Aadd(aCabTit,OemToAnsi("Venc Real"))      
      Aadd(aCabTit,OemToAnsi("Saldo"))                  
      Aadd(aCabTit,OemToAnsi("Fornecedor"))
      Aadd(aCabTit,OemToAnsi("Loja"))
      Aadd(aCabTit,OemToAnsi("Nome"))
                                          
      oDlgTit := MSDialog():New(000,000,450,800,OemToAnsi('Reprogramacao de titulos'),,,,,,,,,.T.,,,)
      oDlgTit:lESCClose := .F.

      TGroup():New(015,005,040,390,"",oDlgTit,,,.T.,.T.)
      TSay():New(021,010,{|| OemToAnsi("Data Programada:") },oDlgTit,,oFont,,,,.T.,,,280,050)   
      TGet():New(020,090,{|u| if(PCount()>0,dDtaProg :=u,dDtaProg) }, oDlgTit, 080,10,,{|| NaoVazio() .And. (dDtaProg > dDatabase)  },,,oFont,,,.T.,,, {|| .T. },,,,,.F.,,"dDtaProg") 
      
      oSelTit := TWBrowse():New(035,005,390,175,,aCabTit,,oDlgTit,,,,,,,,,,,,.F.,,.T.,,.F.,,,)
      oSelTit:SetArray(aDadTit)
      oSelTit:bLDblClick   := { || aDadTit[oSelTit:nAt,1] := !aDadTit[oSelTit:nAt,1],oSelTit:DrawSelect()  }

      oSelTit:bHeaderClick :=  {|oList,nCol| MarkAll(@oSelTit,nCol,@aDadTit)}
      
      oSelTit:bLine        := {|| {If(aDadTit[oSelTit:nAt][01],oOk,oNo),;
                                      aDadTit[oSelTit:nAT][02],;
                                      aDadTit[oSelTit:nAT][03],;
                                      aDadTit[oSelTit:nAT][04],;
                                      aDadTit[oSelTit:nAT][05],;
                                      aDadTit[oSelTit:nAT][06],;
                                      aDadTit[oSelTit:nAT][07],;
                                      aDadTit[oSelTit:nAT][08],;
                                      aDadTit[oSelTit:nAT][09],;
                                      aDadTit[oSelTit:nAT][10]}}
      
      oDlgTit:Activate(,,, .T.,{|| !Empty(aScan( aDadTit,{ |x| x[1] == .T. })) },;
      ,{||  EnchoiceBar(oDlgTit,{|| nOpcX := 1 ,oDlgTit:End()  },{|| nOpcX := 0,oDlgTit:End()}) })
                                                                                                   
      
      If nOpcX == 1
         dbSelectArea("SE2")
         For nXi := 1 To Len(aDadTit)
             If aDadTit[nXi,1]
                SE2->(dbGoto(aDadTit[nXi,11]))
                If !SE2->(Eof())
                   If SE2->E2_EMISSAO > dDtaProg
                      If GetNewPar("NM_MSGEMI",.T.)
                         MsgBox(OemToAnsi("Titulo "+Alltrim(SE2->E2_NUM)+" nao pode ser reprogramado. Data de reprogramação anterior a data de emissão."),;
                                OemtoAnsi("Atencao"),"STOP")
                      EndIf
                   Else
                      If RecLock("SE2",.F.)
                         Replace E2_VENCREA With DataValida(dDtaProg)
                                 //E2_VENCTO  With DataValida(dDtaProg)Alexandre CnTecnologia (Solicitado por fabio) apenas venc real deve ser reprogramado
                         SE2->(MsUnLock())
                      EndIf
                   EndIf
                EndIf
             EndIf
         Next nXi
      EndIf
   EndIf
EndIf              

Return



Static Function MarkAll(oQ,nCol,aDadTit)
************************************************************************
* 
**  
Local nXi := 0

If nCol == 1
   For nXi := 1 To Len(aDadTit)
       aDadTit[nXi][1] := !aDadTit[nXi][1]
   Next nXi
   oQ:DrawSelect()
   oQ:Refresh()
EndIf

Return