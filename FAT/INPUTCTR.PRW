#include "rwmake.ch"        // incluido pelo assistente de conversao do AP5 IDE em 25/06/01
#include "TopConn.ch"

User Function INPUTCTR()        // incluido pelo assistente de conversao do AP5 IDE em 25/06/01

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Declaracao de variaveis utilizadas no programa atraves da funcao    ³
//³ SetPrvt, que criara somente as variaveis definidas pelo usuario,    ³
//³ identificando as variaveis publicas do sistema utilizadas no codigo ³
//³ Incluido pelo assistente de conversao do AP5 IDE                    ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Local aAreaSZ1   := SZ1->(GetArea())
SetPrvt("NOPCE,NOPCG,AHEADER,ACPOENCHOICE,ACOLS,N")
SetPrvt("NXI,CTITULO,CALIASEN,CALIASGE,CLINOK,CTUDOOK")
SetPrvt("CFIELDOK,LRET,CVARMACRO,CVALMACRO,CEMP,NPOS1")
SetPrvt("NPOS2,NSEQ,NXJ,NPOS,NAH,AARQ2")
SetPrvt("NPOS3,NSEQ2,NLASTKEY,AARQ3,ARADIO,NRADIO")
SetPrvt("NVLRADIT,NVRADIT,CNUM,")

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³ CONTRATO ³ Autor ³Eduardo Carraro        ³ Data ³ 09/11/99 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡ao ³ Cadastro de Itens e Aditivos de Contrato                   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Especifico para EPC/TSA                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Private aColsAux := {}

If PARAMIXB $ "AED" .and. SZ1->Z1_SITUAC $ "4/3/2"
   MsgStop("Contrato Bloqueado para Exclusao, Alteracao ou Aditivos!")
   RETURN
EndIf

If PARAMIXB == "E"
   dbSelectArea("SC5")
   dbOrderNickName("USUSC501") //dbSetOrder(6)
   If DbSeek(xFilial("SC5")+SZ1->Z1_COD)
      MsgStop("Este Contrato nao pode ser excluido, pois existe um pedido correspondente !")
      Return
   EndIf
EndIf

If PARAMIXB == "D"
   DefAditivo()
   Return
EndIf

FParam()

//-- Funcao para inicializar variaveis ambientais, caso seja alteracao
//-- ou inclusao;

RegToMemory("SZ1",(PARAMIXB=="I"))   // VAI NO SX3 E VER AS VARIAVEIS DO ALIAS
                                     // E SE O SEGUNDO PARAMETRO = .T. CRIA UM
                                     // REGISTRO EM BRANCO , = .F. VAI NO PRI-
                                     // MEIRO REGISTRO. CRIA VARMEM P/ TODOS OS
                                     // CAMPOS EM USO MENOS FILIAL.

FMonTela()

RestArea(aAreaSZ1)
RETURN

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³ Fparam   ³ Autor ³Eduardo Carraro        ³ Data ³ 16/11/99 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡ao ³ Definicao de Parametros                                    ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Especifico para EPC/TSA                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

// Substituido pelo assistente de conversao do AP5 IDE em 25/06/01 ==> FUNCTION FParam
Static FUNCTION FParam()

DO CASE
   CASE (PARAMIXB $ "I/A")
        nOpcE := 3   // 3 = PODE EDITAR O DADO
        nOpcG := 3
   CASE (PARAMIXB $ "V/E")
        nOpcE := 2   // 2 = PODE VISUALIZAR O DADO
        nOpcG := 2
ENDCASE

RETURN

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³ FMonTela ³ Autor ³Eduardo Carraro        ³ Data ³ 16/11/99 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡ao ³ Montagem da Tela Principal                                 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Especifico para EPC/TSA                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
// Substituido pelo assistente de conversao do AP5 IDE em 25/06/01 ==> FUNCTION FMonTela
Static FUNCTION FMonTela()
Local aPosObj   := {} 
Local aObjects  := {}                        
Local aSize     := MsAdvSize(.F.,.F.) 

aObjects := {} 
AAdd( aObjects, {  000,270, .T., .F. } )
AAdd( aObjects, {  000,040, .T., .T. } )
	
aInfo := { aSize[ 1 ], aSize[ 2 ], aSize[ 3 ], aSize[ 4 ], 3, 3 } 
aPosObj := MsObjSize( aInfo, aObjects ) 

aHeader := {}

dbSelectArea("SX3")
Sx3->(dbSetOrder(1))
dbSeek("SZ2")

While !Eof() .and. SX3->X3_ARQUIVO == "SZ2"
   If (X3USO(SX3->X3_USADO)) .And. (cNivel >= SX3->X3_NIVEL) .and. ;
      (Alltrim(X3_CAMPO) <> "Z2_FILIAL") .and. (Alltrim(X3_CAMPO) <> "Z2_COD")
      AADD(aHeader,{ALLTRIM(X3_TITULO),X3_CAMPO,X3_PICTURE,X3_TAMANHO,;
                    X3_DECIMAL,X3_VALID,X3_USADO,X3_TIPO,X3_ARQUIVO})
   EndIf
   dbSelectArea("SX3")
   DbSkip()
EndDo

aCpoEnchoice := {}

dbSelectArea("SX3")
dbSeek("SZ1")

While ! EOF() .and. SX3->X3_ARQUIVO == "SZ1"

   If (X3USO(SX3->X3_USADO)) .and. (cNivel >= SX3->X3_NIVEL) .and. ;
      (UPPER(Alltrim(X3_CAMPO)) <> "Z1_FILIAL")
      AADD(aCpoEnchoice,X3_CAMPO)
   EndIf
   dbSelectArea("SX3")
   DbSkip()
EndDo

aCols := {}
IF (PARAMIXB == "I")
   aCols := {Array(Len(aHeader) + 1)}
   n:=1
   FOR nxI := 1 to Len(aHeader)
      aCols[1,nxI] := CRIAVAR(aHeader[nxI,2])
   NEXT
   aCols[1,Len(aHeader)+1] := .F.
ELSE
   aCols := {}
   n:=1
   dbSelectArea("SZ2")
   dbSetOrder(1)
   dbSeek((xFilial("SZ2"))+SZ1->Z1_COD)

   While (! eof()) .and. (SZ2->Z2_Filial  == xFilial("SZ2") ) .and. (SZ2->Z2_COD == SZ1->Z1_COD)
      AADD(aCols,Array(Len(aHeader)+1))
      FOR nxI := 1 to LEN(aHeader)
         aCols[Len(aCols),nxI]:=FieldGet(FieldPos(aHeader[nxI,2]))
      NEXT
      aCols[Len(aCols),Len(aHeader)+1]:=.F.
      dbSelectArea("SZ2")
      dbSkip()
   EndDo
EndIf

IF Len(aCols) == 0
   n:=1
   aCols := {Array(Len(aHeader) + 1)}
   FOR nxI := 1 to Len(aHeader)
      aCols[1,nxI]:=CRIAVAR(aHeader[nxI,2])
   NEXT
   aCols[1,Len(aHeader)+1]:=.F.
ENDIF

cTitulo  := "Cadastro de Contratos"
cAliasEn := "SZ1"  // alias Enchoice
cAliasGe := "SZ2"  // alias GetDados
cLinOk   := "AllWaystrue()"  // apos cada linha quebrada, vefifica cLinOk (valida)
//cLinOk   := "ExecBlock('RegVaz01',.F.,.F.)"  // apos cada linha quebrada, vefifica cLinOk (valida)
cTudoOk  := "AllWaysTrue()"  // depois do clique Ok, verifica cTudoOk (valida)
cFieldOk := "AllWaysTrue()"

Lret := Modelo3(cTitulo,cAliasEn,cAliasGe,aCpoEnchoice,cLinOk,cTudoOk,nOpcE,nOpcG,cFieldOk,,999,,,,{aSize[7],000,aSize[6],aSize[5]})

If Lret
   Do Case
      Case PARAMIXB $ "I/A"
           FGravaArq()
				If PARAMIXB='A'
					//Envia um e-mail com as contas sem Cadastro de Produtos para a Medição dos PJs
			  		U_ItemSemProd()
				Endif
			  
      Case PARAMIXB == "E"
           FDelete()
      Case PARAMIXB == "V" .and. Z1_EVENTO =="S"
           MontaEven()
           CarreEven()
   Endcase
Endif


RETURN

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³ FDelete  ³ Autor ³Eduardo Carraro        ³ Data ³ 16/11/99 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡ao ³ Delecao de Itens/Eventos e Cadastro                        ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Especifico para EPC/TSA                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
// Substituido pelo assistente de conversao do AP5 IDE em 25/06/01 ==> FUNCTION FDelete
Static FUNCTION FDelete()

// Varer SZ1 e Deletar SZ2 e SZ3

dbSelectArea("SZ2")
dbSeek((xFilial("SZ2"))+M->Z1_COD)

While (! EOF()) .and. (SZ2->Z2_Filial == xFilial("SZ2")) .and. (SZ2->Z2_COD == M->Z1_COD)
   RecLock("SZ2",.F.)
   dbDelete()
   MsUnLock()
   dbSkip()
EndDo

//Deletando SZ3

dbSelectArea("SZ3")
dbSeek((xFilial("SZ3"))+M->Z1_COD)

While (! EOF()) .and. (SZ3->Z3_Filial == xFilial("SZ3")) .and. (SZ3->Z3_COD == M->Z1_COD)
   RecLock("SZ3",.F.)
   dbDelete()
   MsUnLock()
   dbSkip()
EndDo

dbSelectArea("SZ1")
dbSeek((xFilial("SZ1"))+M->Z1_COD)
RecLock("SZ1",.F.)
dbDelete()
MsUnLock()

RETURN

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³ FGRAVAARQ³ Autor ³Eduardo Carraro        ³ Data ³ 16/11/99 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡ao ³ Gravacao de Itens/Eventos e Cadastro                       ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Especifico para EPC/TSA                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
// Substituido pelo assistente de conversao do AP5 IDE em 25/06/01 ==> FUNCTION FGravaArq
Static FUNCTION FGravaArq()

//  Gravar dados no SZ1
//  Se nao existe append
//  Se existe replace

// Gravar dados no SZ2

dbSelectArea("SZ1")
dbSetOrder(1)
dbSeek(xFilial("SZ1")+M->Z1_COD)

RecLock("SZ1",Eof())
Replace Z1_FILIAL with xFilial("SZ1")
For nxi := 2 to FCount()
    cVarMacro := "M->"+Fieldname(nxi)
    cValMacro := &cVarMacro
    FieldPut(NXI,cValMacro)
Next
MsUnLock()


//Executa a Procedure que Carrega a Tabela SZX que contém Contrato X Atividades para lançamentos na FIP
if cEmpAnt='01' //Somente EPC
	TCSPExec(xProcedures("sp_GerSZX"),Alltrim(M->Z1_COD))		
Endif


If INCLUI    //Apenas na Inclusao
   DbSelectArea("SX5")
   DbSetOrder(1)
   cEmp:=IIf(SM0->M0_CODIGO=="03","LYNX",IIf(SM0->M0_CODIGO=="02","TSA","TSAMZ"))
   If DbSeek(xFilial("SX5")+"94"+cEmp)
      If RecLock("SX5",.F.)
         Replace X5_DESCRI  With SubStr(SZ1->Z1_COD,2,4)
         Replace X5_DESCSPA With SubStr(SZ1->Z1_COD,2,4)
         Replace X5_DESCENG With SubStr(SZ1->Z1_COD,2,4)
         MsUnlock()
      EndIF
   EndIF
EndIf

nPos1 := aScan(aHeader,{|aAux|alltrim(aAux[2]) == "Z2_SUBC"})
nPos2 := aScan(aHeader,{|aAux|alltrim(aAux[2]) == "Z2_OS"})

dbSelectArea("SZ2")
DbSetOrder(2) //Filial+Sub-Conta
nSeq := 1

For nxI := 1 To Len(aCols)
    If ! Empty(aCols[nxI,nPos2])
       dbSeek(xFilial("SZ2")+M->Z1_COD+aCols[nxI,nPos1])
       RecLock("SZ2",Eof())

       If !aCols[nxI,Len(aHeader)+1]
          For nxJ := 1 To Len(aHeader)
              nPos := FieldPos(aHeader[nxJ,2])
              FieldPut(nPos,aCols[nxI,nxJ])
          Next
          Replace  Z2_FILIAL   with  xFilial("SZ2")
          Replace  Z2_COD      With  M->Z1_COD
          Replace  Z2_SEQ      With  StrZero(nSeq,3)
          nSeq := nSeq + 1
          DbSelectArea("CTT") // Centro de Custos
          DbSetOrder(1)
          DbSeek(xFilial("CTT")+SZ2->Z2_SUBC)
          If RecLock("CTT",Eof())
             Replace CTT_FILIAL  With xFilial("CTT")
             Replace CTT_CUSTO   With SZ2->Z2_SUBC
//             Replace I3_MOEDA   With "1"
             Replace CTT_DESC01  With SZ2->Z2_DESC
             Replace CTT_SITUAC  With SZ2->Z2_SITUAC
             Replace CTT_CLASSE  With "2" //Analitico
             Replace CTT_ACITEM  With "1" //Sim
             Replace CTT_TIPOCC  With "S" //Custo Direto
             Replace CTT_BLOQ    With Iif(SZ2->Z2_SITUAC="0","2","1")
             Replace CTT_DTEXIS  With CTOD("01/01/1980")
             //O campo CTT_CLASSI devera ser atualizado apenas na inclusao do C.Custo /Item contabil
             If INCLUI
                Replace CTT_CLASSI  With "C" //Custo Direto
             EndIf
             MsUnlock()
          EndIf

          //Inclusao do Item Contabil para Cliente -- CRISLEI TOLEDO 16/02/06
          DbSelectArea("CTD") // Item Contabil
          DbSetOrder(1)
          DbSeek(xFilial("CTD")+"C"+SZ1->Z1_CODCLI+SZ1->Z1_LOJA)
          If RecLock("CTD",Eof())
             Replace CTD_FILIAL With xFilial("CTD") , ;
                     CTD_ITEM   With "C" + SZ1->Z1_CODCLI + SZ1->Z1_LOJA , ; 
                     CTD_DESC01 With SZ1->Z1_CLIENTE , ;
                     CTD_CLASSE With "1"            , ; 
                     CTD_TIPOIT With "C"            , ;
                     CTD_DTEXIS With CTOD("01/01/1980") , ;
                     CTD_BLOQ   With "2"                , ;                    
                     CTD_SITUAC With "0" , ;
                     CTD_CLASSI With "N"
             MsUnlock()
          EndIf
          
          //Inclusao do CNPJ do cliente como Item contabil
          dbSelectArea("SA1")
          dbSetOrder(1)
          dbSeek(xFilial("SA1")+SZ1->Z1_CODCLI + SZ1->Z1_LOJA)
          
          If !Eof()
    		 dbSelectArea("CTD") // Item Contabil
             dbSetOrder(1)
             dbSeek(xFilial("CTD")+SA1->A1_CGC)
             If Eof()
                RecLock("CTD",.T.)
                Replace CTD_FILIAL With xFilial("CTD") , ;
                        CTD_ITEM   With SA1->A1_CGC    , ; 
                        CTD_DESC01 With SA1->A1_NOME   , ;
                        CTD_CLASSE With "2"            , ; 
                        CTD_TIPOIT With "C"            , ;
                        CTD_DTEXIS With CTOD("01/01/1980") , ;
                        CTD_BLOQ   With "2"                , ;
                        CTD_SITUAC With "0"                , ;
                        CTD_CLASSI With "N"               
                MsUnlock()
             EndIf	
          EndIf 
          
          //Inclusao do Item Contabil para Contrato -- CRISLEI TOLEDO 16/02/06
          DbSelectArea("CTD") // Item Contabil
          DbSetOrder(1)
          DbSeek(xFilial("CTD")+"C"+SZ1->Z1_CODCLI+SZ1->Z1_LOJA+SZ1->Z1_COD)
          If RecLock("CTD",Eof())
             Replace CTD_FILIAL With xFilial("CTD")
             Replace CTD_ITEM   With "C" + SZ1->Z1_CODCLI + SZ1->Z1_LOJA + SZ1->Z1_COD
             Replace CTD_DESC01 With SZ1->Z1_NOME
             Replace CTD_CLASSE With "2"
             Replace CTD_TIPOIT With "C"
             Replace CTD_DTEXIS With CTOD("01/01/1980")
             Replace CTD_BLOQ   With "2"
             Replace CTD_ITSUP  With "C" + SZ1->Z1_CODCLI + SZ1->Z1_LOJA
             Replace CTD_SITUAC With "0"
             //O campo CTD_CLASSI devera ser atualizado apenas na inclusao do C.Custo /Item contabil
             If INCLUI 
                Replace CTD_CLASSI With "N"
             EndIf
             MsUnlock()
          EndIf
                    
          //Inclusao do Item Contabil para SubConta -- CRISLEI TOLEDO 16/02/06
          DbSelectArea("CTD") // Item Contabil
          DbSetOrder(1)
          DbSeek(xFilial("CTD")+SZ2->Z2_SUBC)
          If RecLock("CTD",Eof())
             Replace CTD_FILIAL With xFilial("CTD")
             Replace CTD_ITEM   With SZ2->Z2_SUBC
             Replace CTD_DESC01 With SZ2->Z2_DESC
             Replace CTD_CLASSE With "2"
             Replace CTD_TIPOIT With "S"
             Replace CTD_DTEXIS With CTOD("01/01/1980")
             Replace CTD_BLOQ   With Iif(SZ2->Z2_SITUAC="0","2","1")
             Replace CTD_SITUAC With SZ2->Z2_SITUAC
             If INCLUI
                Replace CTD_CLASSI With "C"
             EndIf
             MsUnlock()
          EndIf
          
          DbSelectArea("SZ2")
       Else
          If !Eof()
             RecLock("SZ2",.F.)
             dbDelete()
          EndIf
       EndIf
       MsUnLock()
    EndIf
Next
If Z1_EVENTO =="S"
   MontaEven()
   CarreEven()
EndIf
ConfirmSx8("SZ1")

RETURN

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³MontaEven   ³ Autor ³Eduardo Carraro      ³ Data ³ 16.11.99 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Monta aHeader e acols para multiline                       ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Especifico EPC/TSA                                         ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
// Substituido pelo assistente de conversao do AP5 IDE em 25/06/01 ==> Function MontaEven
Static Function MontaEven()

aHeader  := {}
aCols    := {}
DbSelectArea("SX3")
DbSetOrder(1)
DbSeek("SZ3")
While !Eof() .and. SX3->X3_ARQUIVO == "SZ3"

   If (X3USO (SX3->X3_USADO)) .And. (cNivel >= SX3->X3_NIVEL) .and. ;
      (!Alltrim(X3_CAMPO) $ "Z3_COD/Z3_SEQ/Z3_DTFATUR/Z3_VLFATUR/Z3_DTNF")///Z3_NOTA/Z3_SERIE/Z3_VLNF
      //(Alltrim(X3_CAMPO) <> "Z3_COD") .and. (Alltrim(X3_CAMPO) <> "Z3_SEQ")
      AADD(aHeader,{ALLTRIM(X3_TITULO),X3_CAMPO,X3_PICTURE,X3_TAMANHO,;
                    X3_DECIMAL,X3_VALID,X3_USADO,X3_TIPO,X3_ARQUIVO})
   EndIf
   dbSelectArea("SX3")
   DbSkip()
End
IF (PARAMIXB == "I")
   aCols := {Array(Len(aHeader) + 1)}
   FOR nxI := 1 to Len(aHeader)
      aCols[1,nxI] := CRIAVAR(aHeader[nxI,2])
   NEXT
   aCols[1,Len(aHeader)+1] := .F.
ELSE
   aCols := {}
   dbSelectArea("SZ3")
   dbSetOrder(1)
   dbSeek((xFilial("SZ3"))+SZ1->Z1_COD)
   While (! eof()) .and. (SZ3->Z3_Filial  == xFilial("SZ3") ) .and. (SZ3->Z3_COD == SZ1->Z1_COD)
      AADD(aCols,Array(Len(aHeader)+1))
      FOR nxI := 1 to LEN(aHeader)
         aCols[Len(aCols),nxI]:=FieldGet(FieldPos(aHeader[nxI,2]))
      NEXT
      aCols[Len(aCols),Len(aHeader)+1]:=.F.
      dbSelectArea("SZ3")
      dbSkip()
   EndDo
EndIf
IF Len(aCols) == 0
   aCols := {Array(Len(aHeader) + 1)}
   FOR nxI := 1 to Len(aHeader)
      aCols[1,nxI]:=CRIAVAR(aHeader[nxI,2])
   NEXT
   aCols[1,Len(aHeader)+1]:=.F.
ENDIF

aColsAux:=aClone(aCols)// por Daniel Moreira em 05.06.05

Return(.T.)

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³CarreEven   ³ Autor ³Eduardo Carraro      ³ Data ³ 16.11.99 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Carrega Multiline conforme aHeader e aCols ja montado      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Especifico EPC/TSA                                         ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
// Substituido pelo assistente de conversao do AP5 IDE em 25/06/01 ==> Function CarreEven
Static Function CarreEven()

DbSelectArea("SA1")
DbSetOrder(1)
DbSeek(xFilial("SA1")+SZ1->Z1_CODCLI)

@ 200,1 TO 400,540 DIALOG oDlg3 TITLE "Eventos do Contrato"
If PARAMIXB == "V"
   @ 6,5 TO 93,200 MULTILINE Object oMline
Else
   @ 6,5 TO 93,200 MULTILINE MODIFY DELETE VALID LineOk() Object oMline// Substituido pelo assistente de conversao do AP5 IDE em 25/06/01 ==>    @ 6,5 TO 93,200 MULTILINE MODIFY DELETE VALID Execute(LineOk)
EndIf
@ 10,205 SAY "Contrato: " + SZ1->Z1_COD         SIZE 100,07
@ 20,205 SAY "Cliente : " + SZ1->Z1_CODCLI      SIZE 100,07
@ 30,205 SAY "Fantasia: " + SZ1->Z1_NREDUZ      SIZE 100,07
@ 40,205 SAY "Emissao : " + DtoC(SZ1->Z1_DTINI) SIZE 100,07 
//Ainda pode 50 e 60
@ 85,210 BMPBUTTON TYPE 01 ACTION GravEven()// Substituido pelo assistente de conversao do AP5 IDE em 25/06/01 ==> @ 85,210 BMPBUTTON TYPE 01 ACTION Execute(GravEven)
@ 85,238 BMPBUTTON TYPE 02 ACTION CancEven()// Substituido pelo assistente de conversao do AP5 IDE em 25/06/01 ==> @ 85,238 BMPBUTTON TYPE 02 ACTION Execute(CancEven)

oMline:nMax:=9999

ACTIVATE DIALOG oDlg3 CENTERED

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³LineOk    ³ Autor ³ Eduardo Carraro       ³ Data ³ 16.11.99 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³Validacao da linha digitada na funcao MultiLine             ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/  
// Substituido pelo assistente de conversao do AP5 IDE em 25/06/01 ==> Function LineOk
Static Function LineOk()

lRet:=.T.
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ verifica se linha do acols foi preenchida            ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
//If ! CheckCols(n,aCols)
//   lRet:=.F.
//Endif
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ verifica se dados do acols foram preenchidos         ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
//For nAh:=1 To len(aCols)
//   If lRet .and. Empty(aCols[n,nAh]) .and. ! aCols[n,Len(aHeader)+1] //.and. !(aHeader[nAh,2] $ "Z3_DTFATUR/Z3_VLFATUR/Z3_NOTA/Z3_SERIE/Z3_DTNF/Z3_VLNF")
//      MsgStop("Nao Foram Informados Todos os Dados Necessarios!")
//      lRet:=.F.
//   EndIf
//Next

Return lRet

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³GravEven    ³ Autor ³Eduardo Carraro      ³ Data ³ 16.11.99 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Grava conteudo do multiline no SZ3                         ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Especifico EPC                                             ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
// Substituido pelo assistente de conversao do AP5 IDE em 25/06/01 ==> Function GravEven
Static Function GravEven()

If PARAMIXB =="V"
   Close(oDlg3)
   Return
EndIf
aArq2:={ Alias(), IndexOrd(), RecNo() }
DbSelectArea("SZ3")
DbSetOrder(2) //contrato+evento
nPos3  := aScan(aHeader,{|aAux|alltrim(aAux[2]) == "Z3_EVENTO"})
nPos3A := aScan(aHeader,{|aAux|alltrim(aAux[2]) == "Z3_EVENTO"})
nSeq2  := 1

// como o codigo do evento deve ser alterado, será realizado uma deleção de todo o acols e incluido
// novamente - por Daniel Moreira 05.05.06
For nXi := 1 To Len(aColsAux)
	If !Empty(aColsAux[nXi,nPos3A])			
		 dbSeek(xFilial("SZ3")+SZ1->Z1_COD+aColsAux[nXi,nPos3A])
		 If Empty(SZ3->Z3_DTNF)
	 		 Reclock("SZ3",.F.)
			 dbDelete()
			 MsUnlock()	
		 EndIf
	EndIf
Next

For nXi := 1 To Len(aCols)

    //If dbSeek(xFilial("SZ3")+SZ1->Z1_COD+aCols[nxI,nPos3])
    //If GdDeleted(nXi) .AND. Empty(SZ3->Z3_DTNF) //por Daniel Moreira 10.03.06       
    //	 Reclock("SZ3",.F.)
	 //	 dbDelete()
	 //	 MsUnlock()
	 //	 Loop
    //EndIf
    //EndIf
	 dbSeek(xFilial("SZ3")+SZ1->Z1_COD+aCols[nxI,nPos3])
    If ! aCols[nxI,Len(aHeader)+1] .and. ! Empty(aCols[nXi,nPos3])
       //dbSeek(xFilial("SZ3")+SZ1->Z1_COD+aCols[nxI,nPos3])
       RecLock("SZ3",Eof())
       For nxJ := 1 To Len(aHeader)
           nPos := FieldPos(aHeader[nxJ,2])
           FieldPut(nPos,aCols[nxI,nxJ])
       Next
       Replace  Z3_FILIAL   with  xFilial("SZ3")
       Replace  Z3_COD      With  SZ1->Z1_COD
       Replace  Z3_SEQ      With  StrZero(nSeq2,3)
       Replace  Z3_CONTA    With  GDFieldGet("Z3_CONTA",nXi)//SZ1->Z1_CONTA
       nSeq2 := nSeq2 + 1
    EndIf
    MsUnlock()
Next
DbSelectArea(aArq2[1])
DbSetOrder(aArq2[2])
DbGoTo(aArq2[3])
Close(oDlg3)

Return

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³CancEven    ³ Autor ³Eduardo Carraro      ³ Data ³ 16.11.99 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Cancela conteudo do Multiline                              ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Especifico EPC                                             ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

// Substituido pelo assistente de conversao do AP5 IDE em 25/06/01 ==> Function CancEven
Static Function CancEven()

Close(oDlg3)

nLastkey := 27

Return

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³DefAditivo  ³ Autor ³Eduardo Carraro      ³ Data ³ 18.11.99 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Define o que fazer nos Aditivos (Dialog)                   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Especifico EPC                                             ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
// Substituido pelo assistente de conversao do AP5 IDE em 25/06/01 ==> Function DefAditivo
Static Function DefAditivo()

aArq3:={ Alias(), IndexOrd(), RecNo() }
aRadio := {"Incluir", "Cancelar","Visualizar"}
nRadio := 1
@ 0,0 TO 130,200 DIALOG oDlg4 TITLE "Aditivos"
@ 02,05 TO 45,95 TITLE "Aditivos do Contrato"
@ 13,10 RADIO aRadio VAR nRadio
@ 50,38 BMPBUTTON TYPE 01 ACTION DefineAct()// Substituido pelo assistente de conversao do AP5 IDE em 25/06/01 ==> @ 50,38 BMPBUTTON TYPE 01 ACTION Execute(DefineAct)
@ 50,66 BMPBUTTON TYPE 02 ACTION CancelAct()// Substituido pelo assistente de conversao do AP5 IDE em 25/06/01 ==> @ 50,66 BMPBUTTON TYPE 02 ACTION Execute(CancelAct)
ACTIVATE DIALOG oDlg4 CENTER

DbSelectArea(aArq3[1])
DbSetOrder(aArq3[2])
DbGoTo(aArq3[3])

Return

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ DefineAct  ³ Autor ³Eduardo Carraro      ³ Data ³ 18.11.99 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Define Acoes                                               ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Especifico EPC                                             ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

// Substituido pelo assistente de conversao do AP5 IDE em 25/06/01 ==> Function DefineAct
Static Function DefineAct()

Do Case
   Case nRadio == 1 //Incluir
        Close(oDlg4)
        IncAditiv()
   Case nRadio == 2 //Cancelar
        Close(oDlg4)
        CancAditiv()
   Case nRadio == 3 //Visualizar
        Close(oDlg4)
        VerAditiv()
EndCase

Return

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ CancelAct  ³ Autor ³Eduardo Carraro      ³ Data ³ 18.11.99 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Define Acoes                                               ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Especifico EPC                                             ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
// Substituido pelo assistente de conversao do AP5 IDE em 25/06/01 ==> Function CancelAct
Static Function CancelAct()

Close(oDlg4)

nLastkey := 27

Return

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ IncAditiv  ³ Autor ³Eduardo Carraro      ³ Data ³ 18.11.99 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Incluir Aditivos                                           ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Especifico EPC                                             ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
// Substituido pelo assistente de conversao do AP5 IDE em 25/06/01 ==> Function IncAditiv
Static Function IncAditiv()

If ! Empty(SZ1->Z1_VRADIT3) .and. ! Empty(SZ1->Z1_VRADIT2) .and. ! Empty(SZ1->Z1_VRADIT1)  //Ja foram utilizados todos os aditivos disponiveis
   MsgBox("Nao existe(m) aditivo(s) disponivel(eis) para este contrato !","Erro!!!","STOP")
   Return
EndIf
nVlrAdit := 0

@ 0,0 TO 130,230 DIALOG oDlg1 TITLE "Inclusao de Aditivos"

@ 05,05 TO 40,110 TITLE " Dados "

@ 20,08 Say "Valor Aditivo :"
@ 20,40 GET nVlrAdit Picture "@E 999,999,999.99"  SIZE 060,07      //VALID FValPed()// Substituido pelo assistente de conversao do AP5 IDE em 25/06/01 ==> @ 20,40 GET nVlrAdit Picture "@E 999,999,999.99"       //VALID Execute(FValPed)

@ 50,055 BMPBUTTON TYPE 01 ACTION Conf1()// Substituido pelo assistente de conversao do AP5 IDE em 25/06/01 ==> @ 50,055 BMPBUTTON TYPE 01 ACTION Execute(Conf1)
@ 50,083 BMPBUTTON TYPE 02 ACTION Canc1()// Substituido pelo assistente de conversao do AP5 IDE em 25/06/01 ==> @ 50,083 BMPBUTTON TYPE 02 ACTION Execute(Canc1)
ACTIVATE DIALOG oDlg1 CENTER
Return

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³ Conf1    ³ Autor ³Eduardo Carraro        ³ Data ³ 18/11/99 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡ao ³ Tratamento do botao de confirmacao das perguntas           ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Especifico para EPC                                        ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
// Substituido pelo assistente de conversao do AP5 IDE em 25/06/01 ==> Function Conf1
Static Function Conf1()

Close(oDlg1)

GravaAdit()

Return

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³ Canc1    ³ Autor ³Eduardo Carraro        ³ Data ³ 18/11/99 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡ao ³ Tratamento do botao de cancelamento das perguntas          ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Especifico para EPC                                        ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
// Substituido pelo assistente de conversao do AP5 IDE em 25/06/01 ==> Function Canc1
Static Function Canc1()

Close(oDlg1)
nLastkey := 27

Return

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³ GravaAdit³ Autor ³Eduardo Carraro        ³ Data ³ 18/11/99 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡ao ³ Grava Aditivos                                             ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Especifico para EPC                                        ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
// Substituido pelo assistente de conversao do AP5 IDE em 25/06/01 ==> Function GravaAdit
Static Function GravaAdit()

Do Case
   Case Empty(SZ1->Z1_VRADIT1)
        RecLock("SZ1",.F.)
        Replace Z1_VRADIT1 With nVlrAdit
        Replace Z1_VRPREV1 With (Z1_VRPREV + nVlrAdit)
        Replace Z1_VRSAL1  With (Z1_VRSAL + nVlrAdit)
        MsUnlock()
   Case Empty(SZ1->Z1_VRADIT2)
        RecLock("SZ1",.F.)
        Replace Z1_VRADIT2 With nVlrAdit
        Replace Z1_VRPREV2 With (Z1_VRPREV1 + nVlrAdit)
        Replace Z1_VRSAL2  With (Z1_VRSAL1 + nVlrAdit)
        MsUnlock()
   Case Empty(SZ1->Z1_VRADIT3)
        RecLock("SZ1",.F.)
        Replace Z1_VRADIT3 With nVlrAdit
        Replace Z1_VRPREV3 With (Z1_VRPREV2 + nVlrAdit)
        Replace Z1_VRSAL3  With (Z1_VRSAL2 + nVlrAdit)
        MsUnlock()
EndCase

If Z1_EVENTO =="S"
   MontaEven()
   CarreEven()
EndIf

Return

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ CancAditiv ³ Autor ³Eduardo Carraro      ³ Data ³ 18.11.99 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Cancelamento Aditivos                                      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Especifico EPC                                             ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
// Substituido pelo assistente de conversao do AP5 IDE em 25/06/01 ==> Function CancAditiv
Static Function CancAditiv()

If Empty(SZ1->Z1_VRADIT3) .and. Empty(SZ1->Z1_VRADIT2) .and. Empty(SZ1->Z1_VRADIT1)  //Nao foram utilizados os aditivos disponiveis
   MsgBox("Nao existe(m) aditivo(s) anexado(s) a este contrato !","Erro!!!","STOP")
   Return
EndIf
//Rotina de Definicao do Ultimo Aditivo
nVrAdit:=0
cNum:=Space(01)
Do Case
   Case ! Empty(Z1_VRADIT3)
      nVrAdit:=Z1_VRADIT3
      cNum:="3"
   Case ! Empty(Z1_VRADIT2)
      nVrAdit:=Z1_VRADIT2
      cNum:="2"
   Case ! Empty(Z1_VRADIT1)
      nVrAdit:=Z1_VRADIT1
      cNum:="1"
EndCase

@ 0,0 TO 130,230 DIALOG oDlg5 TITLE "Cancelamento de Aditivo"

@ 05,05 TO 40,110 TITLE " Dados do Aditivo " + cNum + " " 

@ 20,08 Say "Valor Aditivo :"
@ 20,40 Say nVrAdit Picture "@E 999,999,999.99" SIZE 060,07

@ 50,055 BMPBUTTON TYPE 01 ACTION ConfCanc()// Substituido pelo assistente de conversao do AP5 IDE em 25/06/01 ==> @ 50,055 BMPBUTTON TYPE 01 ACTION Execute(ConfCanc)
@ 50,083 BMPBUTTON TYPE 02 ACTION CancCanc()// Substituido pelo assistente de conversao do AP5 IDE em 25/06/01 ==> @ 50,083 BMPBUTTON TYPE 02 ACTION Execute(CancCanc)
ACTIVATE DIALOG oDlg5 CENTER
nVrAdit:=0
cNum:=Space(01)

Return

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³ ConfCanc ³ Autor ³Eduardo Carraro        ³ Data ³ 18/11/99 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡ao ³ Tratamento do botao de confirmacao das perguntas           ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Especifico para EPC                                        ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
// Substituido pelo assistente de conversao do AP5 IDE em 25/06/01 ==> Function ConfCanc
Static Function ConfCanc()

Close(oDlg5)

If RecLock("SZ1",.f.)
   Do Case
      Case ! Empty(Z1_VRADIT3)
          Replace Z1_VRADIT3 With 0
          Replace Z1_VRPREV3 With 0
          Replace Z1_VRSAL3  With 0
      Case ! Empty(Z1_VRADIT2)
          Replace Z1_VRADIT2 With 0
          Replace Z1_VRPREV2 With 0
          Replace Z1_VRSAL2  With 0
      Case ! Empty(Z1_VRADIT1)
          Replace Z1_VRADIT1 With 0
          Replace Z1_VRPREV1 With 0
          Replace Z1_VRSAL1  With 0
   EndCase
   MsgBox("Cancelamento de Aditivo Executado com Exito !","Informacao","INFO")
Else
   MsgBox("Cancelamento de Aditivo Nao Foi Executado com Exito, Procure Pelo Administrador !","Erro !!!","STOP")
EndIf

Return

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³ CancCanc ³ Autor ³Eduardo Carraro        ³ Data ³ 18/11/99 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡ao ³ Tratamento do botao de cancelamento das perguntas          ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Especifico para EPC                                        ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
// Substituido pelo assistente de conversao do AP5 IDE em 25/06/01 ==> Function CancCanc
Static Function CancCanc()

Close(oDlg5)

nLastkey := 27

Return

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ VerAditiv  ³ Autor ³Eduardo Carraro      ³ Data ³ 18.11.99 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Visualizacao dos Aditivos                                  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Especifico EPC                                             ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
// Substituido pelo assistente de conversao do AP5 IDE em 25/06/01 ==> Function VerAditiv
Static Function VerAditiv()

If Empty(SZ1->Z1_VRADIT3) .and. Empty(SZ1->Z1_VRADIT2) .and. Empty(SZ1->Z1_VRADIT1)  //Nao foram utilizados os aditivos disponiveis
   MsgBox("Nao existe(m) aditivo(s) anexado(s) a este contrato !","Erro!!!","STOP")
   Return
EndIf

@ 0,0 TO 300,450 DIALOG oDlg7 TITLE "Visualizacao de Aditivos"
@ 05,05 TO 60,110 TITLE " Aditivo 1 "
@ 20,08 Say "Valor : " + TransForm(Z1_VRADIT1,"@E 999,999,999.99") SIZE 100,07
@ 30,08 Say "Previsao : " + TransForm(Z1_VRPREV1,"@E 999,999,999.99") SIZE 100,07
@ 40,08 Say "Saldo : " + TransForm(Z1_VRSAL1,"@E 999,999,999.99") SIZE 100,07
@ 05,115 TO 60,220 TITLE " Aditivo 2 "
@ 20,118 Say "Valor : " + TransForm(Z1_VRADIT2,"@E 999,999,999.99") SIZE 100,07
@ 30,118 Say "Previsao : " + TransForm(Z1_VRPREV2,"@E 999,999,999.99") SIZE 100,07
@ 40,118 Say "Saldo : " + TransForm(Z1_VRSAL2,"@E 999,999,999.99") SIZE 100,07
@ 65,05 TO 120,110 TITLE " Aditivo 3 "
@ 80,08 Say "Valor : " + TransForm(Z1_VRADIT2,"@E 999,999,999.99") SIZE 100,07
@ 90,08 Say "Previsao : " + TransForm(Z1_VRPREV2,"@E 999,999,999.99") SIZE 100,07
@ 100,08 Say "Saldo : " + TransForm(Z1_VRSAL2,"@E 999,999,999.99") SIZE 100,07
@ 65,115 TO 120,220 TITLE " Contrato "
@ 80,118 Say "Contrato : " + Z1_COD  SIZE 100,07
@ 90,118 Say "Cliente : " + Z1_NREDUZ SIZE 100,07
@100,118 Say "Total Aditivos : " + TransForm(Z1_VRADIT1+Z1_VRADIT2+Z1_VRADIT3,"@E 999,999,999.99") SIZE 100,07
@ 130,190 BMPBUTTON TYPE 01 ACTION Close(oDlg7)
ACTIVATE DIALOG oDlg7 CENTER

Return
