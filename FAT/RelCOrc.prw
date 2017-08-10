#Include "Rwmake.ch"
/*
+-----------+------------+----------------+---------------+--------+------------+
| Programa  | RelCOrc    | Desenvolvedor  | Mr. Carraro   | Data   | 10/09/02   |
+-----------+------------+----------------+---------------+--------+------------+
| Descricao | Controle Orcamentario                                             |
+-----------+-------------------------------------------------------------------+
| Uso       | Expecifico EPC/TSA                                                |
+-----------+-------------------------------------------------------------------+
|                   Modificacoes Apos Desenvolvimento Inicial                   |
+-------------+---------+-------------------------------------------------------+
|Desenvolvedor| Data    | Motivo                                                |
+-------------+---------+-------------------------------------------------------+
+-------------+---------+-------------------------------------------------------+
*/
User Function RelCOrc()

Local aPerg      := {}
Local cPerg    := "RLCORC"
Local cDesc1   := "Este Relatorio Apresenta, de forma estruturada, o Controle"
Local cDesc2   := "Orcamentario, obedecendo os parametros e Filtros de usuario."
Local cDesc3   := "Dica: Verifique antes da Emissao os Parametros do Relatorio."

Private nLimite  := 220
Private cString  := "SZ2"
Private cTamanho := "G"
Private cTitulo  := "Controle Orcamentario"
Private cCabec1  := ""
Private cCabec2  := ""
Private aReturn  := { "Zebrado", 1,"Administracao", 1, 2, 1, "",1 }
Private cNomeprog:= "RELCORC"
Private nLastKey := 0
Private WnRel    := cNomeProg
Private cArqTrab
Private cIndSZB  := CriaTrab(,.f.)
Private cIndSZ0  := CriaTrab(,.f.)
Private nLin     := 80
Private nPagina  := 1
Private cContIni
Private cContFim
Private cItemIni
Private cItemFim
Private cSetIni
Private cSetFim
Private cMesAno
Private cAreaIni
Private cAreaFim
Private dDataIni
Private cRevTNow
Private nMoedaConv
Private dDataConv 
Private cContab 

cContab:= GetMv("MV_MCONTAB") // TBH127 - JOAO CARLOS  - CONVERSAO SIGACON P/ SIGACTB
//Verifica as perguntas selecionadas

AADD(aPerg,{cPerg,"Contrato Inicial   ?","C",05,0,"G","","","","","","",""})
AADD(aPerg,{cPerg,"Contrato Final     ?","C",05,0,"G","","","","","","",""})
AADD(aPerg,{cPerg,"Item Custo Inicial ?","C",06,0,"G","","","","","","",""})
AADD(aPerg,{cPerg,"Item Custo Final   ?","C",06,0,"G","","","","","","",""})
AADD(aPerg,{cPerg,"Area Inicial       ?","C",02,0,"G","","","","","","",""})
AADD(aPerg,{cPerg,"Area Final         ?","C",02,0,"G","","","","","","",""})
AADD(aPerg,{cPerg,"Setor Inicial      ?","C",05,0,"G","","","","","","",""})
AADD(aPerg,{cPerg,"Setor Final        ?","C",05,0,"G","","","","","","",""})
AADD(aPerg,{cPerg,"Mes/Ano TimeNow    ?","C",04,0,"G","","","","","","",""})
AADD(aPerg,{cPerg,"Converter em Moeda ?","N",01,0,"C","","",GetMv("MV_MOEDA1"),GetMv("MV_MOEDA2"),GetMv("MV_MOEDA3"),GetMv("MV_MOEDA4"),GetMv("MV_MOEDA5")})
AADD(aPerg,{cPerg,"Converter na Data  ?","D",08,0,"G","","","","","","",""})
AADD(aPerg,{cPerg,"Tipo               ?","N",01,0,"C","","","Analítico","Sintético","","",""})
AADD(aPerg,{cPerg,"Imp Real. a partir ?","C",04,0,"G","","","","","","",""})


Pergunte(cPerg,.F.)

//Envia controle para a funcao SETPRINT

wnrel := SetPrint(cString,wnrel,cPerg,cTitulo,cDesc1,cDesc2,cDesc3,.F.,"",,cTamanho,,.F.)

If nLastKey == 27
   Return
Endif

SetDefault(aReturn,cString)

If nLastKey == 27
   Return
Endif

//Alias aos Parametros
cContIni:=MV_PAR01
cContFim:=MV_PAR02
cItemIni:=MV_PAR03
cItemFim:=MV_PAR04
cAreaIni:=MV_PAR05
cAreaFim:=MV_PAR06
cSetIni :=MV_PAR07
cSetFim :=MV_PAR08
cMesAno :=MV_PAR09
nMoedaConv:=MV_PAR10
dDataConv:=MV_PAR11
cInicImpr := MV_PAR13 // CRISLEI TOLEDO - 07/06/06 - MES/ANO PARA INICIO DA IMPRESSAO

dDataIni:=Ctod("01/" + SubStr(cMesAno,1,2) + "/" + SubStr(cMesAno,3,2))
cRevTNow:=StrZero((Val(SubStr(cMesAno,1,2))+(12*(Year(dDataIni)-2002)))+1,3)

Processa({|| FGravTrab()},"Aguarde... Preparando Arquivos..." )

If TRB->(RecCount()) # 0
   RptStatus({|| FImpRel()},"Aguarde... Imprimindo Relatorio...")
EndIf  

//Excluir Arquivos Temporarios
TRB->(DbCloseArea())
FErase(cArqTrab+".DBF")
FErase(cArqTrab+OrdBagExt())

RetIndex("SZB")
FErase(cIndSZB+OrdBagExt())

RetIndex("SZ0")
FErase(cIndSZ0+OrdBagExt())

Set Device To Screen
If aReturn[5] == 1
   Set Printer TO
   dbcommitAll()
   ourspool(wnrel)
Endif

MS_FLUSH()

Return


Static Function FGravTrab()
*************************************************************************************
* Realiza Criacao e Gravacao de Arquivos de Trabalho
***

Local cFilterUser := aReturn[7]
Local nVlrVProp := 0
Local nVlrCProp := 0
Local nVlrCPli  := 0
Local nVlrReaCC := 0
Local nVlrEstCC := 0
Local nVlrReaRC := 0
Local nVlrEstRC := 0
Local nXi
Local cRevPI

Processa({||FMontaArqs()},"Aguarde... Criando Arquivos de Trabalho...")

DbSelectArea("SZ2")
DbSetOrder(1)
Set SoftSeek On
DbSeek(xFilial("SZ2")+cContIni)
Set SoftSeek Off
ProcRegua(RecCount())
While ! Eof() .and. xFilial("SZ2") == Z2_FILIAL .and. Z2_COD <= cContFim
    IncProc("Aguarde... Processando Contrato " + SZ2->Z2_COD)
    //Considera filtro do usuario
    If ! Empty(cFilterUser) .and. ! &(cFilterUser)
       dbSkip()
       Loop
    Endif
    //Filtrando Setor
    If Z2_SETOR < cSetIni .or. Z2_SETOR > cSetFim
       dbSkip()
       Loop    
    EndIf
    //Filtrando Area
    If SubStr(Z2_SETOR,1,2) < cAreaIni .or. SubStr(Z2_SETOR,1,2) > cAreaFim
       dbSkip()
       Loop    
    EndIf    
        
    //Procurando por Proposta Inicial
    DbSelectArea("SZB")
    DbSeek(xFilial("SZB")+PadR(SZ2->Z2_SUBC,11)+"000")
    While ! Eof() .and. xFilial("SZB") == ZB_FILIAL .and. ZB_CCUSTO == PadR(SZ2->Z2_SUBC,11) .and. ZB_REVISAO == "000"        
        //Filtrando Item de Custos
        If ZB_GRUPGER < cItemIni .or. ZB_GRUPGER > cItemFim
           dbSkip()
           Loop    
        EndIf            
        //Procurar por Grupo Gerencial
        DbSelectArea("SZA")
        DbSetOrder(1)
        DbSeek(xFilial("SZA")+SZB->ZB_GRUPGER)
        
        DbSelectArea("SZB")
        If SZA->ZA_TIPORD == "R" //Receitas
           For nXi:=1 To 12        
               nVlrVProp += ( &("ZB_MES"+StrZero(nXi,2)) * SZA->ZA_FATOR )
           Next nXi            
        Else //Despesas
           For nXi:=1 To 12        
               nVlrCProp += ( &("ZB_MES"+StrZero(nXi,2)) * SZA->ZA_FATOR )
           Next nXi            
        EndIf
        DbSelectArea("SZB")
        DbSkip()
    End  
    //Fim da Procura Por Proposta
    
    //Procurando o Planejamento Inicial
    DbSelectArea("SZB")
    Set SoftSeek On
    DbSeek(xFilial("SZB")+PadR(SZ2->Z2_SUBC,11)+"001")
    Set SoftSeek Off
    cRevPI := SZB->ZB_REVISAO
    While ! Eof() .and. xFilial("SZB") == ZB_FILIAL .and. ZB_CCUSTO == PadR(SZ2->Z2_SUBC,11) .and. ZB_REVISAO == cRevPI
        //Filtrando Item de Custos
        If ZB_GRUPGER < cItemIni .or. ZB_GRUPGER > cItemFim
           dbSkip()
           Loop    
        EndIf        
        //Procurar por Grupo Gerencial
        DbSelectArea("SZA")
        DbSetOrder(1)
        DbSeek(xFilial("SZA")+SZB->ZB_GRUPGER)
        
        DbSelectArea("SZB")
        If SZA->ZA_TIPORD == "D" //Despesas
           For nXi:=1 To 12        
               nVlrCPli += ( &("ZB_MES"+StrZero(nXi,2)) * SZA->ZA_FATOR )
           Next nXi                    
        EndIf
        DbSelectArea("SZB")
        DbSkip()
    End  
    //Final Procura de Planejamento Inicial
    
    //Procurando por Custo Corrente(Time-Now)
    DbSelectArea("SZ0")
    DbSeek(xFilial("SZ0")+PadR(SZ2->Z2_SUBC,9))
    While ! Eof() .and. xFilial("SZ0") == Z0_FILIAL .and. Z0_CC == PadR(SZ2->Z2_SUBC,9)
        If cContab == 'CON' // TBH127
	        If Empty(Z0_CUSTO) //Somente Custos
	           DbSelectArea("SZ0")    
	           DbSkip()           
	           Loop
	        EndIf              
	        //Procurar por Grupo Gerencial

	        DbSelectArea("CT1")
	        DbSetOrder(1)
	        Dbseek(xFilial("CT1")+SZ0->Z0_CONTA)
	        
	        //Testar apenas se existir grupo
	        If Empty(CT1->CT1_GRUPO)
	           DbSelectArea("SZ0")    
	           DbSkip()           
	           Loop        
	        EndIf
	        
	        DbSelectArea("SZA")
	        DbSetOrder(1)
	        DbSeek(xFilial("SZA")+CT1->CT1_GRUPO)
	
	        DbSelectArea("SZ0")
	        If Z0_LINHA == "ZZ" .and. Z0_REVISAO == cRevTNow .and. (Right(Z0_DTREF,2)+Left(Z0_DTREF,2)) > ( Right(cMesAno,2) + Left(cMesAno,2))  //Estimado
	           nVlrEstCC += ( Abs(Z0_VALOR) * SZA->ZA_FATOR ) //ok
	        ElseIf Z0_LINHA # "ZZ" .and. Empty(Z0_REVISAO) .and. (Right(Z0_DTREF,2)+Left(Z0_DTREF,2)) <= ( Right(cMesAno,2) + Left(cMesAno,2)) //Realizado
	           //CRISLEI TOLEDO - 07/06/06 TESTA O MES/ANO INICIO DE IMPRESSAO DO RELATORIO
	           If !Empty(cInicImpr) 
	              If (Right(Z0_DTREF,2)+Left(Z0_DTREF,2)) >= ( Right(cInicImpr,2) + Left(cInicImpr,2))
                     nVlrReaCC += ( Abs(Z0_VALOR) * CT1->CT1_FATOR ) //ok
                  EndIf
               Else
                  nVlrReaCC += ( Abs(Z0_VALOR) * CT1->CT1_FATOR ) //ok
               EndIf
               //FIM CRISLEI TOLEDO - 07/06/06
	        EndIf
	        DbSelectArea("SZ0")
		Else
		  // Tratamento CTB
	        If Empty(Z0_CUSTO) //Somente Custos
	           DbSelectArea("SZ0")    
	           DbSkip()           
	           Loop
	        EndIf              
	        //Procurar por Grupo Gerencial

	        DbSelectArea("CT1")
	        DbSetOrder(1)
	        Dbseek(xFilial("CT1")+SZ0->Z0_CONTA)
	        
	        //Testar apenas se existir grupo
	        If Empty(CT1->CT1_GRUPO)
	           DbSelectArea("SZ0")    
	           DbSkip()           
	           Loop        
	        EndIf
	        
	        DbSelectArea("SZA")
	        DbSetOrder(1)
	        DbSeek(xFilial("SZA")+CT1->CT1_GRUPO)
	
	        DbSelectArea("SZ0")
	        If Z0_LINHA == "ZZ" .and. Z0_REVISAO == cRevTNow .and. (Right(Z0_DTREF,2)+Left(Z0_DTREF,2)) > ( Right(cMesAno,2) + Left(cMesAno,2))  //Estimado
	           nVlrEstCC += ( Abs(Z0_VALOR) * SZA->ZA_FATOR ) //ok
	        ElseIf Z0_LINHA # "ZZ" .and. Empty(Z0_REVISAO) .and. (Right(Z0_DTREF,2)+Left(Z0_DTREF,2)) <= ( Right(cMesAno,2) + Left(cMesAno,2)) //Realizado
   	           //CRISLEI TOLEDO - 07/06/06 TESTA O MES/ANO INICIO DE IMPRESSAO DO RELATORIO
	           If !Empty(cInicImpr) 
	              If (Right(Z0_DTREF,2)+Left(Z0_DTREF,2)) >= ( Right(cInicImpr,2) + Left(cInicImpr,2))
                     nVlrReaCC += ( Abs(Z0_VALOR) * CT1->CT1_FATOR ) //ok
                  EndIf
               Else
                  nVlrReaCC += ( Abs(Z0_VALOR) * CT1->CT1_FATOR ) //ok
               EndIf
               //FIM CRISLEI TOLEDO - 07/06/06
	        EndIf
	        DbSelectArea("SZ0")
		  
		  EndIf // TBH127 - JOAO CARLOS - 10/11/05 Fecha tratamento SIGACON p/ SIGACTB
		  
        DbSkip()
    End

    //Procurando por Receita Corrente
    DbSelectArea("SZ0")
    DbSeek(xFilial("SZ0")+PadR(SZ2->Z2_SUBC,9))
    While ! Eof() .and. xFilial("SZ0") == Z0_FILIAL .and. Z0_CC == PadR(SZ2->Z2_SUBC,9)
        If Empty(Z0_RECEITA) //Somente Receita
           DbSelectArea("SZ0")    
           DbSkip()           
           Loop
        EndIf
        //Procurar por Grupo Gerencial
        IF cContab == "CON"

	        DbSelectArea("CT1")
	        DbSetOrder(1)
	        Dbseek(xFilial("CT1")+SZ0->Z0_CONTA)
	        
	        //Testar apenas se existir grupo
	        If Empty(CT1->CT1_GRUPO)
	           DbSelectArea("SZ0")    
	           DbSkip()           
	           Loop        
	        EndIf
	        
	        DbSelectArea("SZA")
	        DbSetOrder(1)
	        DbSeek(xFilial("SZA")+CT1->CT1_GRUPO)
	
	        DbSelectArea("SZ0")
	        If Z0_LINHA == "ZZ" .and. Z0_REVISAO == cRevTNow .and. (Right(Z0_DTREF,2)+Left(Z0_DTREF,2)) > ( Right(cMesAno,2) + Left(cMesAno,2))  //Estimado
	           nVlrEstRC += ( Abs(Z0_VALOR) * SZA->ZA_FATOR )
	        ElseIf Z0_LINHA # "ZZ" .and. Empty(Z0_REVISAO) .and. (Right(Z0_DTREF,2)+Left(Z0_DTREF,2)) <= ( Right(cMesAno,2) + Left(cMesAno,2)) //Realizado	           
   	           //CRISLEI TOLEDO - 07/06/06 TESTA O MES/ANO INICIO DE IMPRESSAO DO RELATORIO
	           If !Empty(cInicImpr) 
	              If (Right(Z0_DTREF,2)+Left(Z0_DTREF,2)) >= ( Right(cInicImpr,2) + Left(cInicImpr,2))
                     nVlrReaRC += ( Abs(Z0_VALOR) * CT1->CT1_FATOR )
                  EndIf
               Else
                  nVlrReaRC += ( Abs(Z0_VALOR) * CT1->CT1_FATOR )
               EndIf
               //FIM CRISLEI TOLEDO - 07/06/06               	           
	        EndIf
	        DbSelectArea("SZ0")    
	        DbSkip()
        Else
	        DbSelectArea("CT1")
	        DbSetOrder(1)
	        Dbseek(xFilial("CT1")+SZ0->Z0_CONTA)
	        
	        //Testar apenas se existir grupo
	        If Empty(CT1->CT1_GRUPO)
	           DbSelectArea("SZ0")    
	           DbSkip()           
	           Loop        
	        EndIf
	        
	        DbSelectArea("SZA")
	        DbSetOrder(1)
	        DbSeek(xFilial("SZA")+CT1->CT1_GRUPO)
	
	        DbSelectArea("SZ0")
	        If Z0_LINHA == "ZZ" .and. Z0_REVISAO == cRevTNow .and. (Right(Z0_DTREF,2)+Left(Z0_DTREF,2)) > ( Right(cMesAno,2) + Left(cMesAno,2))  //Estimado
	           nVlrEstRC += ( Abs(Z0_VALOR) * SZA->ZA_FATOR )
	        ElseIf Z0_LINHA # "ZZ" .and. Empty(Z0_REVISAO) .and. (Right(Z0_DTREF,2)+Left(Z0_DTREF,2)) <= ( Right(cMesAno,2) + Left(cMesAno,2)) //Realizado
   	           //CRISLEI TOLEDO - 07/06/06 TESTA O MES/ANO INICIO DE IMPRESSAO DO RELATORIO
	           If !Empty(cInicImpr) 
	              If (Right(Z0_DTREF,2)+Left(Z0_DTREF,2)) >= ( Right(cInicImpr,2) + Left(cInicImpr,2))
                     nVlrReaRC += ( Abs(Z0_VALOR) * CT1->CT1_FATOR )
                  EndIf
               Else
                  nVlrReaRC += ( Abs(Z0_VALOR) * CT1->CT1_FATOR )
               EndIf
               //FIM CRISLEI TOLEDO - 07/06/06               	           	        
	        EndIf
	        DbSelectArea("SZ0")    
	        DbSkip()
        
	     EndIf
    End    

    //Gravacao dos Valores no Arquivo de Trabalho
    DbSelectArea("TRB")
    If MV_PAR12 == 1 //por Daniel Moreira 08.03.06
    	cChave:= SZ2->Z2_COD+SZ2->Z2_SUBC
    Else
	   cChave:= SZ2->Z2_COD
    EndIf    
    If DbSeek(cChave) //Procura por Contrato
       If RecLock("TRB",.f.)
          Replace VLRVPROP With VLRVPROP+nVlrVProp
          Replace VLRCPROP With VLRCPROP+nVlrCProp
          Replace VLRCPLI  With VLRCPLI+nVlrCPli
          Replace VLRREACC With VLRREACC+nVlrReaCC
          Replace VLRESTCC With VLRESTCC+nVlrEstCC
          Replace VLRREARC With VLRREARC+nVlrReaRC
          Replace VLRESTRC With VLRESTRC+nVlrEstRC
          MsUnlock()
       EndIf
    Else
       If RecLock("TRB",.t.)
          Replace CONTRATO With SZ2->Z2_COD
			 Replace SUBCONTA With IIF(MV_PAR12==1,SZ2->Z2_SUBC,"")
          Replace VLRVPROP With VLRVPROP+nVlrVProp
          Replace VLRCPROP With VLRCPROP+nVlrCProp
          Replace VLRCPLI  With VLRCPLI+nVlrCPli
          Replace VLRREACC With VLRREACC+nVlrReaCC
          Replace VLRESTCC With VLRESTCC+nVlrEstCC
          Replace VLRREARC With VLRREARC+nVlrReaRC
          Replace VLRESTRC With VLRESTRC+nVlrEstRC
          MsUnlock()
       EndIf    
    EndIf   
    //Zera Variaveis de Calculo
    nVlrVProp := 0
    nVlrCProp := 0
    nVlrCPli  := 0
    nVlrReaCC := 0
    nVlrEstCC := 0
    nVlrReaRC := 0
    nVlrEstRC := 0
    DbSelectArea("SZ2")
    DbSkip()
End

Return


Static Function FImpRel()
*************************************************************************************
* Imprime o Relatorio
***

Local lFirst:=.t.

Private nTotVend := 0
Private nTotCust := 0
Private nTotEstI := 0
Private nTotReal := 0
Private nTotEstC := 0
Private nTotEstC2 := 0
Private nTotEstF := 0
Private nTotReaC := 0
Private nTotEstPI := 0
Private nMBTotal:=0
Private nMBCorrente:=0
Private nMBLiq:=0

DbSelectArea("TRB")
DbGoTop()
SetRegua(RecCount())
While ! Eof() 
    IncRegua("Aguarde... Imprimindo Registro " + StrZero(RecNo(),3) + " de " + StrZero(RecCount(),3))
    //Teste de Cabecalho
    If nLin > 54
       FImpCabec(lFirst)
       lFirst:=.f.
    EndIf    
    //Posiciona o Contrato
    DbSelectArea("SZ1")
    DbSetOrder(1)
    DbSeek(xFilial("SZ1")+TRB->CONTRATO)    
        
    @ nLin,000 PSAY "|"
    @ nLin,001 PSAY TRB->CONTRATO+"-"+SubStr(SZ1->Z1_NOMINT,1,23)+"-"+TRB->SUBCONTA//28
    @ nLin,037 PSAY "|"
    @ nLin,038 PSAY TransForm(Round(xMoeda(TRB->VLRVPROP,1,nMoedaConv,dDataConv,2),0),"@E 9,999,999")
    @ nLin,047 PSAY "|"
    @ nLin,048 PSAY TransForm(Round(xMoeda(TRB->VLRCPROP,1,nMoedaConv,dDataConv,2),0),"@E 9,999,999")
    @ nLin,057 PSAY "|"
    @ nLin,058 PSAY TransForm((Round(xMoeda(TRB->VLRVPROP,1,nMoedaConv,dDataConv,2),0)-Round(xMoeda(TRB->VLRCPROP,1,nMoedaConv,dDataConv,2),0))/Round(xMoeda(TRB->VLRVPROP,1,nMoedaConv,dDataConv,2),0),"@E 999.99")
    @ nLin,064 PSAY "|"
    @ nLin,065 PSAY TransForm(0,"@E 9,999,999")
    @ nLin,074 PSAY "|"
    @ nLin,075 PSAY TransForm(0,"@E 9,999,999")
    @ nLin,084 PSAY "|"
    @ nLin,085 PSAY TransForm(0,"@E 999.99")
    @ nLin,091 PSAY "|"
    @ nLin,092 PSAY TransForm(Round(xMoeda(TRB->VLRVPROP,1,nMoedaConv,dDataConv,2),0),"@E 9,999,999")
    @ nLin,101 PSAY "|"
    @ nLin,102 PSAY TransForm(Round(xMoeda(TRB->VLRCPROP,1,nMoedaConv,dDataConv,2),0),"@E 9,999,999")
    @ nLin,111 PSAY "|"
    @ nLin,112 PSAY TransForm((Round(xMoeda(TRB->VLRVPROP,1,nMoedaConv,dDataConv,2),0)-Round(xMoeda(TRB->VLRCPROP,1,nMoedaConv,dDataConv,2),0))/Round(xMoeda(TRB->VLRVPROP,1,nMoedaConv,dDataConv,2),0),"@E 999.99")
    @ nLin,118 PSAY "|"
    @ nLin,119 PSAY TransForm(Round(xMoeda(TRB->VLRCPLI,1,nMoedaConv,dDataConv,2),0),"@E 9,999,999")
    @ nLin,128 PSAY "|"
    @ nLin,129 PSAY TransForm(((Round(xMoeda(TRB->VLRVPROP,1,nMoedaConv,dDataConv,2),0)-Round(xMoeda(TRB->VLRCPLI,1,nMoedaConv,dDataConv,2),0))/Round(xMoeda(TRB->VLRVPROP,1,nMoedaConv,dDataConv,2),0))*100,"@E 9999.99")
    @ nLin,136 PSAY "|"
    @ nLin,137 PSAY TransForm(Round(xMoeda(TRB->VLRREACC,1,nMoedaConv,dDataConv,2),0),"@E 9,999,999")
    @ nLin,146 PSAY "|"
    @ nLin,147 PSAY TransForm(Round(xMoeda(TRB->VLRESTCC,1,nMoedaConv,dDataConv,2),0),"@E 9,999,999")
    @ nLin,156 PSAY "|"
    @ nLin,157 PSAY TransForm(Round(xMoeda(TRB->VLRREACC,1,nMoedaConv,dDataConv,2),0)+Round(xMoeda(TRB->VLRESTCC,1,nMoedaConv,dDataConv,2),0),"@E 9,999,999")
    @ nLin,166 PSAY "|"
    @ nLin,167 PSAY TransForm((((Round(xMoeda(TRB->VLRREARC,1,nMoedaConv,dDataConv,2),0)+Round(xMoeda(TRB->VLRESTRC,1,nMoedaConv,dDataConv,2),0))-(Round(xMoeda(TRB->VLRREACC,1,nMoedaConv,dDataConv,2),0)+Round(xMoeda(TRB->VLRESTCC,1,nMoedaConv,dDataConv,2),0)))/(Round(xMoeda(TRB->VLRREARC,1,nMoedaConv,dDataConv,2),0)+Round(xMoeda(TRB->VLRESTRC,1,nMoedaConv,dDataConv,2),0)))*100,"@E 999.99")
    @ nLin,173 PSAY "|"
    @ nLin,174 PSAY TransForm(Round(xMoeda(TRB->VLRREACC,1,nMoedaConv,dDataConv,2),0)/(Round(xMoeda(TRB->VLRREACC,1,nMoedaConv,dDataConv,2),0)+Round(xMoeda(TRB->VLRESTCC,1,nMoedaConv,dDataConv,2),0)),"@E 999.99")
    @ nLin,180 PSAY "|"
    @ nLin,181 PSAY TransForm(Round(xMoeda(TRB->VLRREARC,1,nMoedaConv,dDataConv,2),0),"@E 9,999,999")
    @ nLin,190 PSAY "|"
    @ nLin,191 PSAY TransForm(Round(xMoeda(TRB->VLRESTRC,1,nMoedaConv,dDataConv,2),0),"@E 9,999,999")
    @ nLin,200 PSAY "|"
    @ nLin,201 PSAY TransForm(Round(xMoeda(TRB->VLRREARC,1,nMoedaConv,dDataConv,2),0)+Round(xMoeda(TRB->VLRESTRC,1,nMoedaConv,dDataConv,2),0),"@E 9,999,999")
    @ nLin,210 PSAY "|"
    @ nLin,211 PSAY TransForm((Round(xMoeda(TRB->VLRREARC,1,nMoedaConv,dDataConv,2),0)*100)/(Round(xMoeda(TRB->VLRREARC,1,nMoedaConv,dDataConv,2),0)+Round(xMoeda(TRB->VLRESTRC,1,nMoedaConv,dDataConv,2),0)),"@E 999.99")
    @ nLin,218 PSAY "|"
//    @ nLin,225 PSAY "|"					    
    nLin++
    @ nLin,000 PSAY "+------------------------------------+---------+---------+------+---------+---------+------+---------+---------+------+---------+-------+---------+---------+---------+------+------+---------+---------+---------+-------+"
    nLin++    
    //Totais Gerais
    nTotVend += Round(xMoeda(TRB->VLRVPROP,1,nMoedaConv,dDataConv,2),0)
    nTotCust += Round(xMoeda(TRB->VLRCPROP,1,nMoedaConv,dDataConv,2),0)
    nTotEstPI += Round(xMoeda(TRB->VLRCPLI,1,nMoedaConv,dDataConv,2),0)
    nTotReal += Round(xMoeda(TRB->VLRREACC,1,nMoedaConv,dDataConv,2),0)
    nTotEstC += Round(xMoeda(TRB->VLRESTCC,1,nMoedaConv,dDataConv,2),0)
    nTotEstF += (Round(xMoeda(TRB->VLRREACC,1,nMoedaConv,dDataConv,2),0)+Round(xMoeda(TRB->VLRESTCC,1,nMoedaConv,dDataConv,2),0))
    nTotReaC += Round(xMoeda(TRB->VLRREARC,1,nMoedaConv,dDataConv,2),0)
    nTotEstC2 += Round(xMoeda(TRB->VLRESTRC,1,nMoedaConv,dDataConv,2),0)
    nTotEsti += (Round(xMoeda(TRB->VLRREARC,1,nMoedaConv,dDataConv,2),0)+Round(xMoeda(TRB->VLRESTRC,1,nMoedaConv,dDataConv,2),0))
    
    DbSelectArea("TRB")
    DbSkip()
End    

FRodaPe()

Return


Static Function FMontaArqs()
*************************************************************************************
* Monta Arquivos
***

Local aStru := {}
ProcRegua(3)
Aadd(aStru,{"CONTRATO","C",05,0})
Aadd(aStru,{"SUBCONTA","C",05,0})//por Daniel Moreira 08.03.06
Aadd(aStru,{"VLRVPROP","N",14,2})
Aadd(aStru,{"VLRCPROP","N",14,2})
Aadd(aStru,{"VLRCPLI" ,"N",14,2})
Aadd(aStru,{"VLRREACC","N",14,2})
Aadd(aStru,{"VLRESTCC","N",14,2})
Aadd(aStru,{"VLRREARC","N",14,2})
Aadd(aStru,{"VLRESTRC","N",14,2})

cArqTrab := CriaTrab(aStru,.T.)
IncProc("Criando Arquivo de Trabalho...")
dbUseArea( .T.,, cArqTrab, "TRB",.F.,.F.)
IndRegua("TRB",cArqTrab,"CONTRATO+SUBCONTA",,,"Selecionando Registros...")

DbSelectArea("SZB")
IncProc("Criando Indice de Trabalho do SZB...")
IndRegua("SZB",cIndSZB,"ZB_FILIAL+ZB_CCUSTO+ZB_REVISAO+ZB_ANO",,,"Selecionando Registros...")

DbSelectArea("SZ0")
IncProc("Criando Indice de Trabalho do SZ0...")
IndRegua("SZ0",cIndSZ0,"Z0_FILIAL+Z0_CC+Z0_REVISAO",,,"Selecionando Registros...")

Return


Static Function FImpCabec(lFirst)
*************************************************************************************
* Impressao de Cabecalho
***

Local aMeses:={"JAN","FEV","MAR","ABR","MAI","JUN","JUL","AGO","SET","OUT","NOV","DEZ"}
If ! lFirst
   @ nLin,000 PSAY Chr(12) //Eject
EndIf

SetPrc(0,0)

@ 001,100 PSAY "CONTROLE ORCAMENTARIO"
@ 001,200 PSAY "Pagina : " + Alltrim(Str(nPagina++))
If MV_PAR12 == 1
	@ 002,000 PSAY PADC("GERAL POR SUBCONTA - ANALITICO",nLimite)
Else
	@ 002,000 PSAY PADC("GERAL POR CONTRATO - SINTETICO",nLimite)
EndIf
@ 003,000 PSAY "Gerente: "
If nMoedaConv # 1
   @ 003,190 PSAY "Valor " + Alltrim(GetMv("MV_SIMB"+Str(nMoedaConv,1))) + " :" + TransForm(xMoeda(1,nMoedaConv,1,dDataConv,4),"@E 99,999.99")
EndIf   
@ 004,000 PSAY "Atualizacao: " + aMeses[Val(SubStr(cMesAno,1,2))] + "/" + Str(Year(dDataIni),4)
If nMoedaConv # 1
   @ 005,150 PSAY "(Os valores apresentados estao cotados em " + GetMv("MV_MOEDA"+Str(nMoedaConv,1)) + " da data " + Dtoc(dDataConv) + ")"
EndIf   
@ 006,000 PSAY "+------------------------------------+--------------------------+--------------------------+--------------------------+-----------------+-------------------------------------------+-------------------------------------+"
@ 007,000 PSAY "|                                    |        PROPOSTA (A)      |     EXTRA-ESCOPO (B)     |  TOTAL VENDIDO (A+B)     | PLANEJ. INICIAL |               CUSTO CORRENTE              |           RECEITA CORRENTE          |"
@ 008,000 PSAY "|       ITENS DE CONTROLE            +---------+---------+------+---------+---------+------+---------+---------+------+---------+-------+---------+---------+---------+------+------+---------+---------+---------+-------+"
@ 009,000 PSAY "|                                    |         |         |MARGEM|         |         |MARGEM|         |         |MARGEM| ESTIMADO|MARGEM%|REALIZADO|ESTIMADO | ESTIMADO|MARGEM|CUSTO%|         |         |         |RECEITA|"
@ 010,000 PSAY "|                                    |  VENDIDO|    CUSTO| (%)  |  VENDIDO|    CUSTO| (%)  |  VENDIDO|    CUSTO| (%)  |  INICIAL|INICIAL| ATE DATA|P/ COMPL.| AO FINAL|TOTAL%|REALIZ|REALIZADA| ESTIMADO|  TOTAL  |REAL. %|"
@ 011,000 PSAY "+------------------------------------+---------+---------+------+---------+---------+------+---------+---------+------+---------+-------+---------+---------+---------+------+------+---------+---------+---------+-------+"

nLin:=12

Return


Static Function FRodape()
*************************************************************************************
* Impressao de Rodape
***

@ nLin,000 PSAY "|TOTAL EMPREENDIMENTO                |"
@ nLin,038 PSAY TransForm(nTotVend,"@E 9,999,999")
@ nLin,047 PSAY "|"
@ nLin,048 PSAY TransForm(nTotCust,"@E 9,999,999")
@ nLin,057 PSAY "|"
@ nLin,058 PSAY TransForm((nTotVend-nTotCust)/nTotVend,"@E 999.99")
@ nLin,064 PSAY "|"
@ nLin,065 PSAY TransForm(0,"@E 9,999,999")
@ nLin,074 PSAY "|"
@ nLin,075 PSAY TransForm(0,"@E 9,999,999")
@ nLin,084 PSAY "|"
@ nLin,085 PSAY TransForm(0,"@E 999.99")
@ nLin,091 PSAY "|"
@ nLin,092 PSAY TransForm(nTotVend,"@E 9,999,999")
@ nLin,101 PSAY "|"
@ nLin,102 PSAY TransForm(nTotCust,"@E 9,999,999")
@ nLin,111 PSAY "|"
@ nLin,112 PSAY TransForm((nTotVend-nTotCust)/nTotVend,"@E 999.99")
@ nLin,118 PSAY "|"
@ nLin,119 PSAY TransForm(nTotEstPI,"@E 9,999,999")
@ nLin,128 PSAY "|"
@ nLin,129 PSAY TransForm(((nTotVend-nTotEstPI)/nTotVend)*100,"@E 9999.99")
@ nLin,136 PSAY "|"
@ nLin,137 PSAY TransForm(nTotReal,"@E 9,999,999")
@ nLin,146 PSAY "|"
@ nLin,147 PSAY TransForm(nTotEstC,"@E 9,999,999")
@ nLin,156 PSAY "|"
@ nLin,157 PSAY TransForm(nTotEstF,"@E 9,999,999")
@ nLin,166 PSAY "|"
@ nLin,167 PSAY TransForm(((nTotEsti-nTotEstF)/nTotEsti)*100,"@E 999.99")
@ nLin,173 PSAY "|"
@ nLin,174 PSAY TransForm(nTotReal/nTotEstF,"@E 999.99")
@ nLin,180 PSAY "|"
@ nLin,181 PSAY TransForm(nTotReaC,"@E 9,999,999")
@ nLin,190 PSAY "|"
@ nLin,191 PSAY TransForm(nTotEstC2,"@E 9,999,999")
@ nLin,200 PSAY "|"
@ nLin,201 PSAY TransForm(nTotEsti,"@E 9,999,999")
@ nLin,210 PSAY "|"
@ nLin,211 PSAY TransForm((nTotReaC*100)/nTotEsti,"@E 999.99")
@ nLin++,218 PSAY "|"
//@ nLin++,225 PSAY "|"

@ nLin++,000 PSAY "+------------------------------------+---------+---------+------+---------+---------+------+---------+---------+------+---------+-------+---------+---------+---------+------+------+---------+---------+---------+-------+"
nLin++

//Teste de Cabecalho
If nLin > 48
   FImpCabec(.f.)
EndIf    

@ nLin++,000 PSAY "            Custo Inicial - Estimado ao Final                                Receita Corrente - Despesa Corrente                         Receita Total Vendida - Custo Inicial"
@ nLin++,000 PSAY "Desvio(%) = ---------------------------------     Margem Bruta Corrente(%) = -----------------------------------     Margem Inicial(%) = -------------------------------------       +=========================+==========+"
@ nLin,000 PSAY "                      Custo Inicial                                                     Receita Corrente                                         Receita Total Vendida               | Margem Bruta Total      |" 
@ nLin,210 PSAY TransForm(((nTotEsti-nTotEstF)/nTotEsti)*100,"@E 999.99")
@ nLin++,218 PSAY "|"
@ nLin++,000 PSAY "                                                                                                                                                                                     +-------------------------+----------+"
@ nLin,000 PSAY "                                                                                                                                                                                     | MB Corrente Estimada    |"
@ nLin,210 PSAY TransForm(((nTotEstC2-nTotEstC)/nTotEstC2)*100,"@E 999.99")
@ nLin++,218 PSAY "|"
@ nLin++,000 PSAY "                                                                                                                                                                                     +-------------------------+----------+"
@ nLin++,000 PSAY "                                                                                                                                                                                     | Margem Liquida          |          |"
@ nLin++,000 PSAY "                                                                                                                                                                                     +=========================+==========+"
  
Return                                                                                                                                                                                                   
/* Layout
CONTROLE ORCAMENTARIO
GERAL POR CONTRATO - SINTETICO
GERENTE:
ATUALIZACAO:
+------------------------------------+--------------------------+--------------------------+--------------------------+-----------------+-------------------------------------------+-------------------------------------+
|                                    |        PROPOSTA (A)      |     EXTRA-ESCOPO (B)     |  TOTAL VENDIDO (A+B)     | PLANEJ. INICIAL |               CUSTO CORRENTE              |           RECEITA CORRENTE          |
|       ITENS DE CONTROLE            +---------+---------+------+---------+---------+------+---------+---------+------+---------+-------+---------+---------+---------+------+------+---------+---------+---------+-------+
|                                    |         |         |      |         |         |      |         |         |      | ESTIMADO|MARGEM |REALIZADO|ESTIMADO | ESTIMADO|MARGEM|CUSTO |         |         |         |RECEITA|
|                                    |  VENDIDO|    CUSTO|MARGEM|  VENDIDO|    CUSTO|MARGEM|  VENDIDO|    CUSTO|MARGEM|  INICIAL|INICIAL| ATE DATA|P/ COMPL.| AO FINAL| TOTAL|REALIZ|REALIZADA| ESTIMADO|  TOTAL  |REALIZ.|
+------------------------------------+---------+---------+------+---------+---------+------+---------+---------+------+---------+-------+---------+---------+---------+------+------+---------+---------+---------+-------+
| T0160 - ACESITA - CIMENTO ITAMBE   |9,999,999|9,999,999|999,99|9,999,999|9,999,999|999,99|9,999,999|9,999,999|999,99|9,999,999| 999.99|9,999,999|9,999,999|9,999,999|999.99|999.99|9,999,999|9,999,999|9,999,999| 999.99|
          12345678901234567890123456
                                                                                                                                                                                     | Margem Liquida          |          |          
*/