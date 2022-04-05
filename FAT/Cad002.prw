#Include 'RwMake.ch'


/*
+-----------------------------------------------------------------------+
¦Programa  ¦           ¦ Autor ¦ Gilson Lucas          ¦Data ¦28.04.2009¦
+----------+------------------------------------------------------------¦
¦Descricao ¦Controle de Veiculos                           		   		¦
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
User Function Cad002                   
*************************************************************************
*Funcao principal
****
Local  aCores     := {}    
Private cCadastro := OemToAnsi("Controle de Veiculos")
Private aRotina   := { {"Pesquisar"  ,"AxPesqui",0,1} ,;
                       {"Visualizar" ,"AxVisual",0,2} ,;
                       {"Entrega"    ,"U_Prc002(3)",0,3},;
                       {OemToansi("Devolução" )  ,"U_Prc002(4)",0,4},;
                       {OemToansi("Alterar" )  ,"U_Prc002(8)",0,4},;
                       {"Faturar"    ,"U_Prc002(5)",0,5},;
                       {"Excluir"    ,"U_Prc002(6)",0,2},;
                       {"Imprimir"   ,"U_RELCAR()",0,2},;
                       {"Legenda"    ,"U_Prc002(7)",0,2}}
                                                           
             
Private lDataFim := .T.
Private cDelFunc := ".T." 
dbSelectArea("ZZ1")
ZZ1->(dbSetOrder(1))

Aadd(aCores,{'ZZ1->ZZ1_STATUS == "1"','BR_VERDE'})
Aadd(aCores,{'ZZ1->ZZ1_STATUS == "2"','BR_AMARELO'   })
Aadd(aCores,{'ZZ1->ZZ1_STATUS == "3"','BR_VERMELHO'})                     


dbSelectArea("ZZ1")
mBrowse( 6,1,22,75,"ZZ1",,,,,,aCores)


Return


User Function Prc002(nOpc)
*************************************************************************
*
****
Local   nXi       := 0    
Local   nPField   := 0
Local   aBlqCpo   := {}
Local   aCpos     := {}
Local   aCabec    := {}
Local   aDados    := {}
Local   cAliasTMP := ""
Local   aLegenda  := {}
//Local   nVlrDia   := GetNewPar("NM_VLRDIA",50)
Private aCols     := {}     
Private aHeader   := {}

lDataFim := .T.

dbSelectArea("SX3")
SX3->(dbSetOrder(1))
SX3->(dbSeek("ZZ1"))
While !SX3->(Eof()) .And. SX3->X3_ARQUIVO == "ZZ1"
    If X3USO(X3_USADO) .And. cNivel >= X3_NIVEL 
       If SX3->X3_TIPO # 'M' .And. SX3->X3_CAMPO # 'ZZ1_STATUS' 
          AADD(aHeader,{Alltrim(X3TITULO()), X3_CAMPO, X3_PICTURE,X3_TAMANHO, X3_DECIMAL, X3_VALID,X3_USADO,X3_TIPO,X3_ARQUIVO,X3_CONTEXT})
          Aadd(aCpos,SX3->X3_CAMPO)
       EndIf
    EndIf
    SX3->(dbSkip())
End
   
             
Do Case 
   Case nOpc == 3 // Inclusao
        aBlqCpo := {"ZZ1_DTAFIM","ZZ1_PROPER","ZZ1_DIARIA","ZZ1_SEQUEN","ZZ1_VALOR"}
        For nXi :=1 To Len(aBlqCpo)
            If (nPField := aScan(aHeader,{|x| Alltrim(x[2]) == aBlqCpo[nXi] })) #0
               ADEL(aHeader,nPField)
               ASIZE(aHeader,Len(aHeader)-1)
            EndIf
        Next nXi

        
        AADD(aCols,Array(Len(aHeader)+1))
        For nXi := 1 To Len(aHeader)
            aCols[1][nXi] := CriaVar(aHeader[nXi][2])
        Next nXi
        aCols[1][Len(aHeader)+1] := .F.
        Dial02(nOpc,aCpos)

   
   
   Case nOpc == 4 // Entregar
        aBlqCpo := {"ZZ1_SEQUEN"}
        For nXi :=1 To Len(aBlqCpo)
            If (nPField := aScan(aHeader,{|x| Alltrim(x[2]) == aBlqCpo[nXi] })) #0
               ADEL(aHeader,nPField)
               ASIZE(aHeader,Len(aHeader)-1)
            EndIf
        Next nXi
                                                          
        aCpos := {"ZZ1_DTAFIM","ZZ1_PROPER","ZZ1_DIARIA","ZZ1_VALOR"}
        dbSelectArea("ZZ1")
        ZZ1->(dbSetOrder(2))//ZZ1_FILIAL+ZZ1_STATUS
        ZZ1->(dbSeek(xFilial("ZZ1")+'1'))
        While !ZZ1->(Eof()) .AND. ZZ1->(ZZ1_FILIAL+ZZ1_STATUS) == xFilial("ZZ1")+'1'
           AADD(aCols,Array(Len(aHeader)+1))   
           For nXi := 1 To Len(aHeader)
               acols[Len(	aCols)][nxi] := ZZ1->(&(aHeader[nXi][2]))
           Next nXi
           aCols[Len(aCols)][Len(aHeader)+1] := .F.   
           ZZ1->(dbSkip())
        End
        
        If !Empty(aCols)
           Dial02(nOpc,aCpos)
        EndIf             

   Case nOpc == 5
        cAliasTMP := GetNextAlias()  
        BeginSql Alias cAliasTMP //Inicio do Embedded SQL
           SELECT ZZ1_PLACA,ZZ1_PROJET,ZZ1_PROJC,SUM(ZZ1_DIARIA) DIARIA , SUM(ZZ1_VALOR)  VALOR , LEFT(ZZ1_DTAFIM,6) ZZ1_DTAFIM,COUNT(*) TOTAL
           FROM %table:ZZ1% ZZ1
           WHERE ZZ1_STATUS = %Exp:'2'%
           AND ZZ1.%NotDel%
           AND ZZ1_FILIAL = %xFilial:ZZ1%
           AND ZZ1_DTAFIM != %Exp:''%
           GROUP BY ZZ1_PLACA,ZZ1_PROJET,ZZ1_PROJC,LEFT(ZZ1_DTAFIM,6)
           ORDER BY ZZ1_PLACA           
        EndSql                                
        
        dbSelectArea(cAliasTMP)
        (cAliasTMP)->(dbGoTop())
        (cAliasTMP)->(dbEval( {|| Aadd(aDados,{.T.,(cAliasTMP)->ZZ1_PLACA,(cAliasTMP)->ZZ1_PROJET,(cAliasTMP)->DIARIA,TransForm((cAliasTMP)->VALOR,"@E 99999.99"),Right((cAliasTMP)->ZZ1_DTAFIM,2)+'/'+SubStr((cAliasTMP)->ZZ1_DTAFIM,3,2) /*RIGHT(DTOC(STOD((cAliasTMP)->ZZ1_DTAFIM)),5)*/,(cAliasTMP)->TOTAL,(cAliasTMP)->ZZ1_PROJC}) } ))        

        dbSelectArea(cAliasTMP)
        (cAliasTMP)->(dbCloseArea())
        
        dbSelectArea("ZZ1")
                           
        If !Empty(aDados)
           aadd(aCabec,OemToansi(""))
           aadd(aCabec,OemToansi("PLaca"))
           aadd(aCabec,OemToansi("Projeto"))           
           aadd(aCabec,OemToansi("Diarias")) 
           aadd(aCabec,OemToansi("Valor")) 
           aadd(aCabec,OemToansi("Data Referencia")) 
           aadd(aCabec,OemToansi("No Locações"))
           View02(nOpc,aCabec,aDados)
        EndIf
   Case nOpc == 6 // Exclusao
        If ZZ1->ZZ1_STATUS == '3'
           cAliasTMP := GetNextAlias()  
           BeginSql Alias cAliasTMP //Inicio do Embedded SQL
              SELECT ZZ1_PLACA,ZZ1_PROJET,ZZ1_PROJC,SUM(ZZ1_DIARIA) DIARIA , SUM(ZZ1_VALOR)  VALOR , LEFT(ZZ1_DTAFIM,6) ZZ1_DTAFIM ,
              COUNT(*) TOTAL ,MAX(ZZ1_RCRED) ZZ1_RCRED, MAX(ZZ1_RDEB) ZZ1_RDEB
              FROM %table:ZZ1% ZZ1
              WHERE ZZ1_STATUS = %Exp:'3'%
              AND ZZ1.%NotDel%
              AND ZZ1_FILIAL = %xFilial:ZZ1%
              GROUP BY ZZ1_PLACA,ZZ1_PROJET,ZZ1_PROJC,LEFT(ZZ1_DTAFIM,6)
              ORDER BY ZZ1_PLACA           
           EndSql
           dbSelectArea(cAliasTMP)
           (cAliasTMP)->(dbGoTop())
           (cAliasTMP)->(dbEval( {|| Aadd(aDados,{.T.,(cAliasTMP)->ZZ1_PLACA,(cAliasTMP)->ZZ1_PROJET,(cAliasTMP)->DIARIA,TransForm((cAliasTMP)->VALOR,"@E 99999.99"),Right((cAliasTMP)->ZZ1_DTAFIM,2)+'/'+SubStr((cAliasTMP)->ZZ1_DTAFIM,3,2) /*RIGHT(DTOC(STOD((cAliasTMP)->ZZ1_DTAFIM)),5)*/,(cAliasTMP)->TOTAL,(cAliasTMP)->ZZ1_RCRED,(cAliasTMP)->ZZ1_RDEB,(cAliasTMP)->ZZ1_PROJC     }) } ))        

           dbSelectArea(cAliasTMP)
           (cAliasTMP)->(dbCloseArea())
        
           dbSelectArea("ZZ1")
                            
           If !Empty(aDados)
              aadd(aCabec,OemToansi(""))
              aadd(aCabec,OemToansi("PLaca"))
              aadd(aCabec,OemToansi("Projeto"))           
              aadd(aCabec,OemToansi("Diarias")) 
              aadd(aCabec,OemToansi("Valor")) 
              aadd(aCabec,OemToansi("Data Referencia")) 
              View02(nOpc,aCabec,aDados)
           EndIf
        Else // Retorna o Status ate excluir
           If ZZ1->ZZ1_STATUS == '2'
              If MsgBox("Deseja voltar o status da Locação?","Atencao","YESNO",2)
                 If RecLock("ZZ1",.F.)
                    Replace ZZ1_DTAFIM With CriaVar("ZZ1_DTAFIM",.F.,.F.),;
                            ZZ1_PROPER With CriaVar("ZZ1_PROPER",.F.,.F.),;
                            ZZ1_DIARIA With CriaVar("ZZ1_DIARIA",.F.,.F.),;
                            ZZ1_STATUS With '1' ,;
                            ZZ1_VALOR  With CriaVar("ZZ1_VALOR",.F.,.F.)
                    ZZ1->(MsUnLock())
                 EndIf
              EndIf
           Else
           
              If MsgBox("Deseja apagar a Locação ?","Atencao","YESNO",2) 
                 If RecLock("ZZ1",.F.)
                    ZZ1->(dbDelete())
                    ZZ1->(MsUnLock())
                 EndIf              
              EndIf
           EndIf
        EndIf
        
   Case nOpc == 7 // Legenda
        Aadd(aLegenda, {'BR_VERDE'    ,"Alocado"})
        Aadd(aLegenda, {'BR_AMARELO'  ,"Entregue"})
        Aadd(aLegenda, {'BR_VERMELHO' ,"Faturado" })
        BrwLegenda(cCadastro, "Legenda", aLegenda)


   Case nOpc == 8 // Alterar

      If ZZ1->ZZ1_STATUS == "2"
         lDataFim := .F.
         AxAltera("ZZ1",ZZ1->(Recno()),4,,,,,"AllwaysTrue()",,,/*aButtons*/)
      else
         MsgInfo(OemToansi("Somente registros entregues podem ser alterados. Confira o status do veículo!"), "Atenção!")
      EndIf

   Case nOpc == 9

            

Endcase
Return



Static Function Dial02(nOpcAux,aCpos)
*************************************************************************
* Tela de Manutençao
****
Local   oDlg 
Local   nXi       := 0
Local   nYi       := 0
Local   lClose    := .F.
Local   aObjects  := {}
Local   aPosObj   := {}
Local   aSize     := MsAdvSize(.t.,.f.,300) //(lEnchoiceBar,lTelaPadrao,ntamanho_linhas)
Local   aInfo     := {aSize[1],aSize[2],aSize[3],aSize[4],3,3}
Private oGdDados


//Define Objetos da Tela Principal
AADD(aObjects,{100,100,.T.,.T.})  //{TamX,TamY,DimX,DimY,lDimensaoXeY}
 
aPosObj:=MsObjSize(aInfo,aObjects)

//Monta Dialog
oDlg:=MSDialog():New(aSize[7],0,aSize[6],aSize[5],OemToAnsi("Cadastro de Sub-Grupos"),,,,,,,,,.t.)
oDlg:lEscClose:=.F. //Nao permite sair ao se pressionar a tecla ESC.
oDlg:lMaximized:=.T.

oGdDados := MSGetDados():New(aPosObj[1][1]+05,aPosObj[1][2]+5,aPosObj[1,3]-5,aPosObj[1,4]-5,nOpcAux,"AllWaysTrue()","AllWaysTrue()","",.T.,aCpos,1,,Iif(nOpcAux==3,999,Len(aCols)),,,,,oDlg)
oGdDados:CDELOK:=".f."
       

oDlg:Activate(,,, .T.,{||  }, ,{||  EnchoiceBar(oDlg,{|| lClose :=.T.,Iif(oGdDados:TudoOk(),oDlg:End(),lClose :=.F.)  },{|| lClose :=.F.,oDlg:End()}) })


If lClose
   Do Case 
      Case nOpcAux == 3
           For nXi := 1 To Len(aCols)
               If RecLock("ZZ1",.T.)
                  For nYi := 1 to Len(aHeader)
                      ZZ1->(&(aHeader[nYi][2])) :=  GdFieldGet(aHeader[nYi][2],nXi)
                  Next nYi          
          
                  Replace ZZ1_FILIAL With xFilial("ZZ1"),;
                          ZZ1_SEQUEN With GetSx8Num("ZZ1","ZZ1_SEQUEN"),;
                          ZZ1_STATUS With '1'
                  ZZ1->(MsUnLock())
                  ZZ1->(ConfirmSX8())
               EndIf
           Next nXi
      Case nOpcAux == 4
           dbSelectArea("ZZ1")
           ZZ1->(dbSetOrder(1)) //ZZ1_FILIAL+ZZ1_PLACA+ZZ1_STATUS
           
           For nXi := 1 To Len(aCols)
               If !Gddeleted(nXi)
                  ZZ1->(dbSeek(xFilial("ZZ1")+GdFieldGet("ZZ1_PLACA",nXi)+'1'))
                  If !ZZ1->(Eof())
                     If RecLock("ZZ1",.F.)
                        Replace ZZ1_DTAFIM With GdFieldGet("ZZ1_DTAFIM",nXi),;
                                ZZ1_PROPER With Iif(Empty(GdFieldGet("ZZ1_PROPER",nXi)),ctod(""),GdFieldGet("ZZ1_PROPER",nXi)),;
                                ZZ1_DIARIA With GdFieldGet("ZZ1_DIARIA",nXi),;
                                ZZ1_VALOR  With GdFieldGet("ZZ1_VALOR",nXi),;
                                ZZ1_STATUS With Iif(Empty(GdFieldGet("ZZ1_DTAFIM",nXi)),'1','2')
                        ZZ1->(MsUnLock())
                     EndIf
                     If !Empty(GdFieldGet("ZZ1_PROPER",nXi))
                        If RecLock("ZZ1",.T.)
                           For nYi := 1 to Len(aHeader)
                               If !aHeader[nYi][2] $ "ZZ1_DTAFIM|ZZ1_PROPER|ZZ1_DIARIA|ZZ1_DTAINI"
                                  ZZ1->(&(aHeader[nYi][2])) :=  GdFieldGet(aHeader[nYi][2],nXi)
                               EndIf
                           Next nYi          
          
                           Replace ZZ1_FILIAL With xFilial("ZZ1"),;
                                   ZZ1_SEQUEN With GetSx8Num("ZZ1","ZZ1_SEQUEN"),;
                                   ZZ1_STATUS With '1',;
                                   ZZ1_DTAINI With GdFieldGet("ZZ1_PROPER",nXi)
                           ZZ1->(MsUnLock())
                           ZZ1->(ConfirmSX8())
                        EndIf
                     EndIf
                  EndIf
               EndIf
           Next nXi 
   EndCase
EndIf

Return



User Function VldCd02(cValid)
*************************************************************************
* Validação Geral
****
Local nXi  := 0
Local lRet := .T.
Local nVlrDia   := GetNewPar("NM_VLRDIA",65)

Do Case
   Case cValid == 'PLACA'
        dbSelectArea("ZZ1")
        ZZ1->(dbSetOrder(1))
        ZZ1->(dbSeek(xFilial("ZZ1")+M->ZZ1_PLACA+'1'))
        If !ZZ1->(Eof())
           MsgBox(OemToAnsi("Veiculo já alocado em outro projeto"),OemToAnsi("Erro"),"STOP")
           lRet := .F.
        EndIf
        If lRet
           If (nXi := aScan(aCols,{|x| Alltrim(x[GdFieldPos("ZZ1_PLACA")]) == M->ZZ1_PLACA })) # 0
              If nXi # n                                                                             
                 MsgBox(OemToAnsi("Veiculo já alocado em outro projeto"),OemToAnsi("Erro"),"STOP")
                 lRet := .F.           
              EndIf
           EndIf
        EndIf            
   Case cValid == 'DATAFINAL'
        If GdfieldGet("ZZ1_DTAINI",n) > M->ZZ1_DTAFIM
           lRet := .F.
           MsgBox(OemToAnsi("Data Final Invalida"),OemToAnsi("Erro"),"STOP")
        EndIf

        If Month(M->ZZ1_DTAFIM) # Month(GdfieldGet("ZZ1_DTAINI",n))
           MsgBox(OemToAnsi("Data Invalida. Mes inicial diferente de mes final."),OemToAnsi("Erro"),"STOP")
           M->ZZ1_DTAFIM := LastDay(GdfieldGet("ZZ1_DTAINI",n))
           GdFieldPut("ZZ1_PROPER",M->ZZ1_DTAFIM  +1,n)        
        Else   
           GdFieldPut("ZZ1_PROPER",Criavar("ZZ1_PROPER",.F.,.F.),n)
        EndIf
        
        If lRet 
           GdFieldPut("ZZ1_DIARIA",(M->ZZ1_DTAFIM - GdfieldGet("ZZ1_DTAINI",n)),n)        
           If Empty(GdFieldGet("ZZ1_DIARIA",n))
              GdFieldPut("ZZ1_DIARIA",1,n)
           EndIf
           GdFieldPut("ZZ1_VALOR",GdFieldGet("ZZ1_DIARIA",n) * nVlrDia )
        EndIf
   Case cValid == 'PROXPER'
        If M->ZZ1_PROPER <= GdfieldGet("ZZ1_DTAFIM",n) 
           lRet := .F.
           MsgBox(OemToAnsi("Data Invalida. Proximo periodo n~ao pode ser menor ou igual a data final."),OemToAnsi("Erro"),"STOP")
        EndIf
   
EndCase

Return(lRet)



Static Function View02(nOpcAux,aCabec,aDados)
*************************************************************************
* Tela de Manutençao
****
Local   oDlg
Local   oFatura
Local   nXi       := 1
Local   cQuery    := ""
Local   lClose    := .F.
Local   aObjects  := {}
Local   aPosObj   := {}
Local   aSize     := MsAdvSize(.t.,.f.,300) //(lEnchoiceBar,lTelaPadrao,ntamanho_linhas)
Local   oOk       := LoadBitmap(GetResources(), "LBTIK_OCEAN.BMP")
Local   oNo       := LoadBitmap(GetResources(), "LBNO_OCEAN.BMP")
Local   aInfo     := {aSize[1],aSize[2],aSize[3],aSize[4]-40,3,3} //aSize[4] Ajustado para não ultrapassar tela




//Define Objetos da Tela Principal
AADD(aObjects,{100,100,.T.,.T.})  //{TamX,TamY,DimX,DimY,lDimensaoXeY}
 
aPosObj:=MsObjSize(aInfo,aObjects)

//Monta Dialog
oDlg:=MSDialog():New(aSize[7],0,aSize[6],aSize[5],OemToAnsi(""),,,,,,,,,.t.)
oDlg:lEscClose:=.F. //Nao permite sair ao se pressionar a tecla ESC.
oDlg:lMaximized:=.T.

oFatura:= TWBrowse():New(aPosObj[1][1]+05,aPosObj[1][2]+5,aPosObj[1,4]-5,aPosObj[1,3]-5,,aCabec,,oDlg,,,,,,,,,,,,.F.,,.T.,,.F.,,,)
oFatura:SetArray(aDados)
oFatura:BRCLICKED := {|| lEditCell( @aDados,oFatura, /*cPicture*/, 6 )}

oFatura:bLDblClick   := { || aDados[oFatura:nAt,1] := !aDados[oFatura:nAt,1] ,oFatura:DrawSelect() }
oFatura:bLine        := {|| {If(aDados[oFatura:nAt,1],oOk,oNo),aDados[oFatura:nAT][2],aDados[oFatura:nAT][3],aDados[oFatura:nAT][4],;
                            aDados[oFatura:nAT][5],aDados[oFatura:nAT][6],aDados[oFatura:nAT][7]}}
oFatura:bHeaderClick :=  {|oList,nCol| MarkAll(oFatura,aDados,nCol)}

oDlg:Activate(,,, .T.,{||  }, ,{||  EnchoiceBar(oDlg,{|| lClose :=.T.,oDlg:End() },{|| lClose :=.F.,oDlg:End()}) })

If lClose
   If nOpcAux == 5 // Faturamento
      For nXi := 1 To Len(aDados)
         If aDados[nXi][1]

            cQuery := "UPDATE " + RetSqlname("ZZ1") + " SET ZZ1_STATUS = '3' "
            cQuery += " WHERE ZZ1_FILIAL = '"+xFilial("ZZ1")+"'"
            cQuery += " AND ZZ1_PROJET =  '"+aDados[nXi][3]+"'"
            cQuery += " AND ZZ1_PROJC =  '"+aDados[nXi][8]+"'"
            cQuery += " AND D_E_L_E_T_ = ''"
            cQuery += " AND ZZ1_DTAFIM != '' " 
            cQuery += " AND ZZ1_PLACA = '"+aDados[nXi][2]+"'" 
            cQuery += " AND ZZ1_STATUS = '2'"

            TcSqlExec(cQuery)
            TcRefresh("ZZ1")             

         EndIf
      Next nXi
   ElseIf nOpcAux == 6  // Exlusao do faturamento
      dbSelectArea("SZ0")
      For nXi := 1 To Len(aDados)
          If aDados[nXi][1]
            
            cQuery := "UPDATE " + RetSqlname("ZZ1") + " SET ZZ1_STATUS = '2', ZZ1_RCRED = 0, ZZ1_RDEB = 0  "
            cQuery += " WHERE ZZ1_FILIAL = '"+xFilial("ZZ1")+"'"
            cQuery += " AND ZZ1_PROJET =  '"+aDados[nXi][3]+"'"
            cQuery += " AND ZZ1_PROJC =  '"+aDados[nXi][10]+"'"
            cQuery += " AND RIGHT(LEFT(ZZ1_DTAFIM,6),2)+'/'+SUBSTRING(ZZ1_DTAFIM,3,2) =  '"+aDados[nXi][6]+"'"
            cQuery += " AND D_E_L_E_T_ = ''"
            cQuery += " AND ZZ1_PLACA = '"+aDados[nXi][2]+"'" 
            cQuery += " AND ZZ1_STATUS = '3'"

            TcSqlExec(cQuery)
            TcRefresh("ZZ1")   

          EndIf
      Next nXi       
   EndIf
EndIf

Return



Static Function MarkAll(oQ,aDetalhes,nCol)
*************************************************************************
*
****
Local nXi := 0

If nCol == 1
   For nXi := 1 To Len(aDetalhes)
       aDetalhes[nXi][1] := !aDetalhes[nXi][1]
   Next nXi
   
   oQ:Refresh()
EndIf

Return


User Function GrVeiculos()

   Local nYi         := 0
   Local cCpoAtu     := ""
   Local aRegSZ0     := {}
   Local aAreaOld    := GetArea()
   Local cAliasTMP   := GetNextAlias() 

   //Remove todos os lancamentos de veiculo
   cQuery  := " DELETE "+RetSqlName("SZ0")
   cQuery  += " WHERE Z0_VEICULO = 'S' "
   TCSQLExec(cQuery)

   BeginSql Alias cAliasTMP //Inicio do Embedded SQL
      SELECT ZZ1_FILIAL,ZZ1_PLACA,ZZ1_PROJET,ZZ1_PROJC,SUM(ZZ1_DIARIA) DIARIA , SUM(ZZ1_VALOR)  VALOR , LEFT(ZZ1_DTAFIM,6) ZZ1_DTAFIM,COUNT(*) TOTAL
      FROM %table:ZZ1% ZZ1
      WHERE ZZ1_STATUS = %Exp:'3'%
      AND ZZ1.%NotDel%
     // AND LEFT(ZZ1_DTAFIM,6) >= '202204'
      GROUP BY ZZ1_FILIAL,ZZ1_PLACA,ZZ1_PROJET,ZZ1_PROJC,LEFT(ZZ1_DTAFIM,6)
      ORDER BY ZZ1_PLACA           
   EndSql                                

   dbSelectArea(cAliasTMP)
   (cAliasTMP)->(dbGoTop())
   
   While !(cAliasTMP)->(Eof())
      aRegSZ0   := {}
      If RecLock("SZ0",.T.)
         // Gera o Credito da Locação
         Replace Z0_FILIAL  With (cAliasTMP)->ZZ1_FILIAL,;
                  Z0_LINHA   With "00"  ,;
                  Z0_DATA    With Right((cAliasTMP)->ZZ1_DTAFIM,2)+'/'+SubStr((cAliasTMP)->ZZ1_DTAFIM,3,2),;
                  Z0_HIST    With 'RECEITA LOC VEICULO PRJ.: '+(cAliasTMP)->ZZ1_PROJC ,;
                  Z0_DTVENC  With Right((cAliasTMP)->ZZ1_DTAFIM,2)+'/'+SubStr((cAliasTMP)->ZZ1_DTAFIM,3,2) ,;
                  Z0_LOTE    With "009999" ,;
                  Z0_DOC     With (cAliasTMP)->ZZ1_PROJC  ,;
                  Z0_VALOR   With Val(TransForm((cAliasTMP)->VALOR,"@E 99999.99"))         ,;
                  Z0_DTCAIXA With Right((cAliasTMP)->ZZ1_DTAFIM,2)+'/'+SubStr((cAliasTMP)->ZZ1_DTAFIM,3,2)       ,;
                  Z0_DTREF   With Right((cAliasTMP)->ZZ1_DTAFIM,2)+'/'+SubStr((cAliasTMP)->ZZ1_DTAFIM,3,2)       ,;
                  Z0_CONTA   With "4113070001"        ,;
                  Z0_CC      With (cAliasTMP)->ZZ1_PROJC       ,;
                  Z0_SETORIG With Posicione("SZ2",3,Xfilial("cCusto")+(cAliasTMP)->ZZ1_PROJC,"Z2_SETOR")       ,;
                  Z0_DTLANC  with Lastday(ctod('01/'+Right((cAliasTMP)->ZZ1_DTAFIM,2)+'/'+SubStr((cAliasTMP)->ZZ1_DTAFIM,3,2))),;
                  Z0_RECEITA With Val(TransForm((cAliasTMP)->VALOR,"@E 99999.99")),;
                  Z0_SUBCTA  With (cAliasTMP)->ZZ1_PROJC,;
                  Z0_FATOR   With 1,;
                  Z0_DESGER  With 'RECEITAS DE SERVICOS(VEICULOS)',;
                  Z0_DESC01  With ' PLACA: '+(cAliasTMP)->ZZ1_PLACA+ " No diarias "+Alltrim(str((cAliasTMP)->DIARIA)),;
                  Z0_GRUPGER With '001001',;
                  Z0_VEICULO With 'S',;
                  Z0_SITUAC  With '0'
         SZ0->(MsUnlock())
         Aadd(aRegSZ0,SZ0->(Recno()))
      EndIf

      If RecLock("SZ0",.T.)
         // Gera o Debito da Locação
         Replace  Z0_FILIAL  With (cAliasTMP)->ZZ1_FILIAL,;
                  Z0_LINHA   With "00"  ,;
                  Z0_DATA    With Right((cAliasTMP)->ZZ1_DTAFIM,2)+'/'+SubStr((cAliasTMP)->ZZ1_DTAFIM,3,2),;
                  Z0_HIST    With 'CUSTO LOC VEICULO PRJ.: '+(cAliasTMP)->ZZ1_PROJET ,;
                  Z0_DTVENC  With Right((cAliasTMP)->ZZ1_DTAFIM,2)+'/'+SubStr((cAliasTMP)->ZZ1_DTAFIM,3,2) ,;
                  Z0_LOTE    With "009999" ,;
                  Z0_DOC     With (cAliasTMP)->ZZ1_PROJET  ,;
                  Z0_VALOR   With Val(TransForm((cAliasTMP)->VALOR,"@E 99999.99"))*-1         ,;
                  Z0_DTCAIXA With Right((cAliasTMP)->ZZ1_DTAFIM,2)+'/'+SubStr((cAliasTMP)->ZZ1_DTAFIM,3,2)       ,;
                  Z0_DTREF   With Right((cAliasTMP)->ZZ1_DTAFIM,2)+'/'+SubStr((cAliasTMP)->ZZ1_DTAFIM,3,2)       ,;
                  Z0_CONTA   With "4113070001"        ,;
                  Z0_CC      With (cAliasTMP)->ZZ1_PROJET       ,;
                  Z0_SETORIG With Posicione("SZ2",3,Xfilial("cCusto")+(cAliasTMP)->ZZ1_PROJET,"Z2_SETOR")       ,;
                  Z0_DTLANC  with Lastday(ctod('01/'+Right((cAliasTMP)->ZZ1_DTAFIM,2)+'/'+SubStr((cAliasTMP)->ZZ1_DTAFIM,3,2))),;
                  Z0_CUSTO   With Val(TransForm((cAliasTMP)->VALOR,"@E 99999.99"))*-1  ,;
                  Z0_SUBCTA  With (cAliasTMP)->ZZ1_PROJET,;
                  Z0_FATOR   With 1,;
                  Z0_DESGER  With 'DESPESAS COM VEICULOS',;
                  Z0_DESC01  With ' PLACA: '+(cAliasTMP)->ZZ1_PLACA+ " No diarias "+Alltrim(str((cAliasTMP)->DIARIA)),;
                  Z0_GRUPGER With '000029',;
                  Z0_VEICULO With 'S',;
                  Z0_SITUAC  With '0'
         SZ0->(MsUnlock())
         Aadd(aRegSZ0,SZ0->(Recno()))
      EndIf

      For nYi := 1 To 2

         cCpoAtu := Iif(nYi==1,'ZZ1_RCRED','ZZ1_RDEB')
         cQuery := "UPDATE " + RetSqlname("ZZ1") + " SET "+cCpoAtu+" = "+Str(aRegSZ0[nYi],15)
         cQuery += " WHERE ZZ1_FILIAL = '"+(cAliasTMP)->ZZ1_FILIAL+"'"
         cQuery += " AND ZZ1_PROJET =  '"+(cAliasTMP)->ZZ1_PROJET+"'"
         cQuery += " AND ZZ1_PROJC =  '"+(cAliasTMP)->ZZ1_PROJC+"'"
         cQuery += " AND D_E_L_E_T_ = ''"
         cQuery += " AND LEFT(ZZ1_DTAFIM,6) = '"+LEFT((cAliasTMP)->ZZ1_DTAFIM,6)+"' " 
         cQuery += " AND ZZ1_PLACA = '"+(cAliasTMP)->ZZ1_PLACA+"'" 
         cQuery += " AND ZZ1_STATUS = '3'"
         TcSqlExec(cQuery)
           
      Next nYi


      (cAliasTMP)->(dbSkip())
   End


   dbSelectArea(cAliasTMP)
   (cAliasTMP)->(dbCloseArea())
   RestArea(aAreaOld)

return
