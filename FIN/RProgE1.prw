#Include 'RwMake.ch'

/*/{Protheus.doc} RProgE1
@author		Gilson Lucas Junior
@since		09/09/2019
@version	MP12
@build 		7.00.131227A - Apr 2 2018

@tipo Processo 
@area-responsavel Financeiro
@fonte-principal  RProgE1
@rotina-principal Rotina para reprogramação automatica de contas a receber
@descricao
Permite a troca da data de vencto ( em lote) dos titulos do contas a receber.
 
Manutenções pós Implantação
@data 
@analista 
@horas 
@solicitante  
@motivo 

/*/

User Function RProgE1()
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
Local cPerg        := "RProgE1"
Local aAreaOld     := GetArea()
Local oFont        := TFont():New( "Arial",,16,,.T.,,,,.T.,.F. )
Local oOk          := LoadBitMap(GetResources(),"LBOK")
Local oNo          := LoadBitMap(GetResources(),"LBNO")
Private dDtaProg     := Date()+1

U_PutSx1(cPerg,"01",OemToAnsi("Vencto Incial ?")     ,OemToAnsi("Vencto Incial ?")     ,OemToAnsi("Vencto Incial ?")     ,"mv_ch1","D",TamSx3("E1_VENCREA")[1],0,0,"G","","","",""    ,"mv_par01","","","","","","","","","","","","","","","","",{ OemToAnsi("Define a Vencto Inicial ")  ,OemToAnsi("do filtro.")}, {}, {} )
U_PutSx1(cPerg,"02",OemToAnsi("Vencto Final ?")      ,OemToAnsi("Vencto Final ?")      ,OemToAnsi("Vencto Final ?")      ,"mv_ch2","D",TamSx3("E1_VENCREA")[1],0,0,"G","","","",""    ,"mv_par02","","","","","","","","","","","","","","","","",{ OemToAnsi("Define a Vencto Final ")    ,OemToAnsi("do filtro.")}, {}, {} )
U_PutSx1(cPerg,"03",OemToAnsi("Numero Incial ?")     ,OemToAnsi("Numero Incial ?")     ,OemToAnsi("Numero Incial ?")     ,"mv_ch3","C",TamSx3("E1_NUM")[1]    ,0,0,"G","","","",""    ,"mv_par03","","","","","","","","","","","","","","","","",{ OemToAnsi("Define a numero Inicial ")  ,OemToAnsi("do filtro.")}, {}, {} )
U_PutSx1(cPerg,"04",OemToAnsi("Numero Final ?")      ,OemToAnsi("Numero Final ?")      ,OemToAnsi("Numero Final ?")      ,"mv_ch4","C",TamSx3("E1_NUM")[1]    ,0,0,"G","","","",""    ,"mv_par04","","","","","","","","","","","","","","","","",{ OemToAnsi("Define a numero Final ")    ,OemToAnsi("do filtro.")}, {}, {} )
U_PutSx1(cPerg,"05",OemToAnsi("Cliente Incial ?") ,OemToAnsi("Cliente Incial ?") ,OemToAnsi("Cliente Incial ?") ,"mv_ch5","C",TamSx3("E1_CLIENTE")[1],0,0,"G","","SA1","","" ,"mv_par05","","","","","","","","","","","","","","","","",{ OemToAnsi("Define o Cliente Inicial ")  ,OemToAnsi("do filtro.")}, {}, {} )
U_PutSx1(cPerg,"06",OemToAnsi("Cliente  Final ?") ,OemToAnsi("Cliente Final ?")  ,OemToAnsi("Cliente Final ?")  ,"mv_ch6","C",TamSx3("E1_CLIENTE")[1],0,0,"G","","SA1","","" ,"mv_par06","","","","","","","","","","","","","","","","",{ OemToAnsi("Define o Cliente Final ")    ,OemToAnsi("do filtro.")}, {}, {} )
U_PutSx1(cPerg,"07",OemToAnsi("Ordem ?")             ,OemToAnsi("Ordem ?")             ,OemToAnsi("Ordem ?")             ,"mv_ch7","N",01,0,0,"C","","","","","mv_par07","Numero","Numero","Numero","","Vencto Real","Vencto Real","Vencto Real","Nome","Nome","Nome","","","","","","",{ OemToAnsi("Define quais status serÃ£o Impressos")}, {}, {} )
U_PutSx1(cPerg,"08",OemToAnsi("Filial De ?")         ,OemToAnsi("Filial De ?")         ,OemToAnsi("Filial De ?")         ,"mv_ch8","C",02,0,0,"G","","","",""	,"mv_par08","","","","","","","","","","","","","","","","",{ OemToAnsi("Numero da filial Inicial")}		, {}, {} )
U_PutSx1(cPerg,"09",OemToAnsi("Filial Até ?")        ,OemToAnsi("Filial Até ?")        ,OemToAnsi("Filial Até ?")        ,"mv_ch9","C",02,0,0,"G","","","",""	,"mv_par09","","","","","","","","","","","","","","","","",{ OemToAnsi("Numero da filial Final")}		, {}, {} )

If Pergunte(cPerg,.T.)
   Do Case
      Case MV_PAR07  == 1 
           cExpOrder := "E1_NUM"
      Case MV_PAR07  == 2 
           cExpOrder := "E1_VENCREA"
      Case MV_PAR07  == 3 
           cExpOrder := "A1_NOME"     
   EndCase
   

   cAliasQry := GetNextAlias()
   BeginSql Alias cAliasQry
      COLUMN E1_VENCTO  AS DATE
      COLUMN E1_EMISSAO AS DATE
      COLUMN E1_VENCREA AS DATE
      SELECT A1_NOME,E1_PREFIXO,E1_VENCREA,E1_NUM,E1_NUMBCO,E1_PREFIXO,E1_PARCELA,E1_PORTADO,E1_PARCELA, E1_FILIAL,
             E1_CLIENTE,E1_LOJA,E1_VALOR,E1_VENCTO,E1_SALDO,E1_TIPO,E1_EMISSAO,SE1.R_E_C_N_O_ REGSE1
      FROM %table:SE1% SE1 , %table:SA1% SA1
      WHERE SE1.%NotDel% 
            AND SA1.%NotDel% 
/*            AND SE1.E1_FILIAL = %xFilial:SE1% 
            AND SA1.A1_FILIAL = %xFilial:SA1%   */
            AND E1_CLIENTE = A1_COD
            AND E1_LOJA    = A1_LOJA
            AND E1_VENCREA BETWEEN %Exp:Dtos(MV_PAR01)% AND %Exp:Dtos(MV_PAR02)%
            AND E1_NUM BETWEEN     %Exp:MV_PAR03% AND %Exp:MV_PAR04%
            AND E1_CLIENTE BETWEEN %Exp:MV_PAR05% AND %Exp:MV_PAR06%
            AND E1_FILIAL BETWEEN  %Exp:MV_PAR08% AND %Exp:MV_PAR09%
            AND E1_SALDO > %Exp:'0'%
      ORDER BY %Exp:cExpOrder%
   EndSql
   
   
   dbSelectArea(cAliasQry)
   (cAliasQry)->(dbGotop())
   
   While !(cAliasQry)->(Eof())
       Aadd(aDadTit,{.T.,;               
       				(cAliasQry)->E1_FILIAL,;
                    (cAliasQry)->E1_NUM,;
                    (cAliasQry)->E1_PARCELA,;
                    (cAliasQry)->E1_EMISSAO,;
                    (cAliasQry)->E1_VENCREA,;
                    Transform((cAliasQry)->E1_SALDO,"@E 99,999,999.99"),;
                    (cAliasQry)->E1_CLIENTE,;
                    (cAliasQry)->E1_LOJA,;
                    (cAliasQry)->A1_NOME,;
                    (cAliasQry)->REGSE1 })
       
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
      Aadd(aCabTit,OemToAnsi("Cliente"))
      Aadd(aCabTit,OemToAnsi("Loja"))
      Aadd(aCabTit,OemToAnsi("Nome"))
                                          
      oDlgTit := MSDialog():New(000,000,540,800,OemToAnsi('Reprogramacao de titulos'),,,,,,,,,.T.,,,)
      oDlgTit:lESCClose := .F.

      TGroup():New(035,005,060,390,"",oDlgTit,,,.T.,.T.)
      TSay():New(041,010,{|| OemToAnsi("Data Programada:") },oDlgTit,,oFont,,,,.T.,,,280,050)   
      TGet():New(040,090,{|u| if(PCount()>0,dDtaProg :=u,dDtaProg) }, oDlgTit, 080,10,,{|| NaoVazio() .And. (dDtaProg > dDatabase)  },,,oFont,,,.T.,,, {|| .T. },,,,,.F.,,"dDtaProg") 
      
      oSelTit := TWBrowse():New(065,005,390,195,,aCabTit,,oDlgTit,,,,,,,,,,,,.F.,,.T.,,.F.,,,)
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
         dbSelectArea("SE1")
         For nXi := 1 To Len(aDadTit)
             If aDadTit[nXi,1]
                SE1->(dbGoto(aDadTit[nXi,11]))
                If !SE1->(Eof())
                   If SE1->E1_EMISSAO > dDtaProg
                      If GetNewPar("NM_MSGEMI",.T.)
                         MsgBox(OemToAnsi("Titulo "+Alltrim(SE1->E1_NUM)+" nao pode ser reprogramado. Data de reprogramaÃ§Ã£o anterior a data de emissÃ£o."),;
                                OemtoAnsi("Atencao"),"STOP")
                      EndIf
                   Else
                      If RecLock("SE1",.F.)
                         Replace E1_VENCREA With DataValida(dDtaProg)
                                 //E1_VENCTO  With DataValida(dDtaProg)Alexandre CnTecnologia (Solicitado por fabio) apenas venc real deve ser reprogramado
                         SE1->(MsUnLock())
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



User Function PutSx1(cGrupo,cOrdem,cPergunt,cPerSpa,cPerEng,cVar,;
	cTipo ,nTamanho,nDecimal,nPresel,cGSC,cValid,;
	cF3, cGrpSxg,cPyme,;
	cVar01,cDef01,cDefSpa1,cDefEng1,cCnt01,;
	cDef02,cDefSpa2,cDefEng2,;
	cDef03,cDefSpa3,cDefEng3,;
	cDef04,cDefSpa4,cDefEng4,;
	cDef05,cDefSpa5,cDefEng5,;
	aHelpPor,aHelpEng,aHelpSpa,cHelp)

LOCAL aArea := GetArea()
Local cKey
Local lPort := .f.
Local lSpa  := .f.
Local lIngl := .f.

If .t. //GetVersao(.F.) < "12"

	cKey  := "P." + AllTrim( cGrupo ) + AllTrim( cOrdem ) + "."

	cPyme    := Iif( cPyme 		== Nil, " ", cPyme		)
	cF3      := Iif( cF3 		== NIl, " ", cF3		)
	cGrpSxg  := Iif( cGrpSxg	== Nil, " ", cGrpSxg	)
	cCnt01   := Iif( cCnt01		== Nil, "" , cCnt01 	)
	cHelp	 := Iif( cHelp		== Nil, "" , cHelp		)

	dbSelectArea( "SX1" )
	dbSetOrder( 1 )

	// Ajusta o tamanho do grupo. Ajuste emergencial para validação dos fontes.
	// RFC - 15/03/2007
	cGrupo := PadR( cGrupo , Len( SX1->X1_GRUPO ) , " " )

	If !( DbSeek( cGrupo + cOrdem ))

	    cPergunt:= If(! "?" $ cPergunt .And. ! Empty(cPergunt),Alltrim(cPergunt)+" ?",cPergunt)
		cPerSpa	:= If(! "?" $ cPerSpa  .And. ! Empty(cPerSpa) ,Alltrim(cPerSpa) +" ?",cPerSpa)
		cPerEng	:= If(! "?" $ cPerEng  .And. ! Empty(cPerEng) ,Alltrim(cPerEng) +" ?",cPerEng)

		Reclock( "SX1" , .T. )

		Replace X1_GRUPO   With cGrupo
		Replace X1_ORDEM   With cOrdem
		Replace X1_PERGUNT With cPergunt
		Replace X1_PERSPA  With cPerSpa
		Replace X1_PERENG  With cPerEng
		Replace X1_VARIAVL With cVar
		Replace X1_TIPO    With cTipo
		Replace X1_TAMANHO With nTamanho
		Replace X1_DECIMAL With nDecimal
		Replace X1_PRESEL  With nPresel
		Replace X1_GSC     With cGSC
		Replace X1_VALID   With cValid

		Replace X1_VAR01   With cVar01

		Replace X1_F3      With cF3
		Replace X1_GRPSXG  With cGrpSxg

		If Fieldpos("X1_PYME") > 0
			If cPyme != Nil
				Replace X1_PYME With cPyme
			Endif
		Endif

		Replace X1_CNT01   With cCnt01
		If cGSC == "C"			// Mult Escolha
			Replace X1_DEF01   With cDef01
			Replace X1_DEFSPA1 With cDefSpa1
			Replace X1_DEFENG1 With cDefEng1

			Replace X1_DEF02   With cDef02
			Replace X1_DEFSPA2 With cDefSpa2
			Replace X1_DEFENG2 With cDefEng2

			Replace X1_DEF03   With cDef03
			Replace X1_DEFSPA3 With cDefSpa3
			Replace X1_DEFENG3 With cDefEng3

			Replace X1_DEF04   With cDef04
			Replace X1_DEFSPA4 With cDefSpa4
			Replace X1_DEFENG4 With cDefEng4

			Replace X1_DEF05   With cDef05
			Replace X1_DEFSPA5 With cDefSpa5
			Replace X1_DEFENG5 With cDefEng5
		Endif

		Replace X1_HELP  With cHelp

		PutSX1Help(cKey,aHelpPor,aHelpEng,aHelpSpa)

		MsUnlock()
	Else

	   lPort := ! "?" $ X1_PERGUNT .And. ! Empty(SX1->X1_PERGUNT)
	   lSpa  := ! "?" $ X1_PERSPA  .And. ! Empty(SX1->X1_PERSPA)
	   lIngl := ! "?" $ X1_PERENG  .And. ! Empty(SX1->X1_PERENG)

	   If lPort .Or. lSpa .Or. lIngl
			RecLock("SX1",.F.)
			If lPort
	         SX1->X1_PERGUNT:= Alltrim(SX1->X1_PERGUNT)+" ?"
			EndIf
			If lSpa
				SX1->X1_PERSPA := Alltrim(SX1->X1_PERSPA) +" ?"
			EndIf
			If lIngl
				SX1->X1_PERENG := Alltrim(SX1->X1_PERENG) +" ?"
			EndIf
			SX1->(MsUnLock())
		EndIf
	Endif

	RestArea( aArea )
Endif
Return