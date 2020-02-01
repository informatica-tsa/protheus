/* 
+---------+----------+------+----------------------------------+-------+---------+
|Programa |INPUTEOR  |Autor |                			         | Data  |         |	
+---------+----------+------+----------------------------------+-------+---------+
|Descricao| Cadastro de Orcamento                                                |
+--------------------------------------------------------------------------------+
|							Alteracoes feitas desde a criacao   				 |
+-------------+-----------+------------------------------------------------------+
|Programador  |Data       |Descricao											 |
+-------------+-----------+------------------------------------------------------+
|Crislei      |29/01/02	  |Incluida funcao para consultar o numero do contrato   |
+-------------+-----------+------------------------------------------------------+
|Crislei      |02/05/02	  |Gravacao do arquivo SZI                               |
+-------------+-----------+------------------------------------------------------+
|Crislei      |08/05/02	  |Tratamento na alteracao de orcamentos aprovados       |
+-------------+-----------+------------------------------------------------------+ 
|Crislei      |08/05/02	  |Copia de revisao                                      |
+-------------+-----------+------------------------------------------------------+ 
|Leo Alves    |02/01/06	  |Revisão do indice para montagem do Acols Table SZB    |
|             |           |Ordem do indice e montagem de chave alterada          |
+-------------+-----------+------------------------------------------------------+
*/

#include "rwmake.ch"
#include "Topconn.ch"

User Function INPUTEOR()
******************************************************************************************************************
*
*
*****
Local aPosObj   := {} 
Local aObjects  := {}                        
Local aSize     := MsAdvSize(.F.,.F.) 
Local nxI := 0 

Private lEmLote := Iif(Paramixb == 'L',.T.,.F.)

If Paramixb == 'L'
   Paramixb := 'I'
EndIf

aObjects := {} 
AAdd( aObjects, {  000,270, .T., .F. } )
AAdd( aObjects, {  000,040, .T., .T. } )
	
aInfo := { aSize[ 1 ], aSize[ 2 ], aSize[ 3 ], aSize[ 4 ], 3, 3 } 
aPosObj := MsObjSize( aInfo, aObjects ) 

SetPrvt("AARQINP,LREINDEX,NOPCX,CCCUSTO,CANO,CREVISAO")
SetPrvt("LEDIT,NSEQ,CCONTRAT,CTIPODES,NUSADO,AHEADER")
SetPrvt("NPOSDESC,ACOLS,NXI,CTITULO,AC,AR")
SetPrvt("ACGD,CLINHAOK,CTUDOOK,LRETMOD2,NPOSITE,NXJ")
SetPrvt("NPOSOR,")


aArqInp  := { Alias() , IndexOrd() , Recno() }
lReindex := .F.

Do Case
   Case (PARAMIXB $"I/A")
        nOpcx:=3   // 3 = PODE EDITAR O DADO
   Case (PARAMIXB $"V/E/C")
        nOpcx:=2   // 2 = PODE VISUALIZUR O DADO
EndCase


If PARAMIXB == "I"
   cCCusto  := Space(TamSx3("ZB_CCUSTO")[1])
   cRevisao := Left(Dtos(dDatabase),6)
   cAno     := Left(cRevisao,4)
   cReviCop := Space(TamSx3("ZB_REVISAO")[1]) //Revisao Copia
   cContrat := ""
   cTipoDes := ""
   cAnoRev  := Left(cRevisao,4)
Else
   cCCusto  := SZB->ZB_CCUSTO
   cAno     := SZB->ZB_ANO
   cRevisao := SZB->ZB_REVISAO
   FConsContr()
EndIf

IF PARAMIXB == "A"
   lEdit := .F.
Else
   lEdit := .T.
EndIf

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Montando aHeader                                             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

dbSelectArea("SX3")
dbSetOrder(1)
dbSeek("SZB")
nUsado:=0
aHeader:={}
While !Eof() .And. (x3_arquivo == "SZB")

   IF X3USO(x3_usado)                         .And. ;
      cNivel >= x3_nivel                      .And. ;
      Alltrim(SX3->X3_CAMPO) <> "ZB_CCUSTO"   .And. ;
      Alltrim(SX3->X3_CAMPO) <> "ZB_ANO"      .And. ;
      Alltrim(SX3->X3_CAMPO) <> "ZB_REVISAO"
      nUsado := nUsado + 1
      Aadd(aHeader,{ TRIM(x3_titulo), x3_campo, x3_picture, x3_tamanho, ;
           x3_decimal, ,  x3_usado, x3_tipo, x3_arquivo, x3_context, x3_F3 } )

    Endif
    dbSkip()
End

nPosDesc := aScan(aHeader,{|aAux| Upper(Alltrim(aAux[2])) == "ZB_DESCRI"})

If PARAMIXB == "I"
	If !MsgBox("Deseja Copiar alguma revisao anterior?","Copia Revisao","YESNO")
		aCols:=Array(1,nUsado+1)
		dbSelectArea("SX3")
		dbSeek("SZB")
		nUsado:=0
		While !Eof() .And. (X3_ARQUIVO == "SZB")
			IF X3USO(X3_USADO)                         .And. ;
				cNivel >= x3_nivel                      .And. ;
				Alltrim(SX3->X3_CAMPO) <> "ZB_CCUSTO"   .And. ;
				Alltrim(SX3->X3_CAMPO) <> "ZB_ANO"      .And. ;
				Alltrim(SX3->X3_CAMPO) <> "ZB_REVISAO"
				nUsado := nUsado + 1
				IF nOpcx == 3
					IF X3_TIPO == "C"
						aCols[1][nUsado] := SPACE(x3_tamanho)
					Elseif X3_TIPO == "N"
						aCols[1][nUsado] := 0
					Elseif X3_TIPO == "D"
						aCols[1][nUsado] := dDataBase
					Elseif X3_TIPO == "M"
						aCols[1][nUsado] := ""
					Else
						aCols[1][nUsado] := .F.
					Endif
				Endif
			Endif
			dbSkip()
		EndDo
		aCols[1][nUsado+1] := .F.
	Else
		If FTela()
			dbSelectArea("SZB")
			dbSetOrder(1)
			dbSeek(xFilial("SZB")+cCCusto+cAnoRev+cReviCop)
			
			aCols := {}
			
			While (! Eof())                            .And. ;
				(xFilial("SZB")  == SZB->ZB_Filial)  .And. ;
				(SZB->ZB_CCUSTO  == cCCusto  )       .And. ;
				(SZB->ZB_ANO     == cAnoRev)       .And. ;
				(SZB->ZB_REVISAO == cReviCop)
				Aadd(aCols,Array(Len(aHeader)+1))
				For nxI := 1 to Len(aHeader)
					aCols[Len(aCols),nxI] := FieldGet(FieldPos(aHeader[nxI,2]))
				Next
				aCols[Len(aCols),Len(aHeader)+1] := .F.
				dbSelectArea("SZB")
				dbSkip()
			EndDo
			
		Else	
			aCols:=Array(1,nUsado+1)
			dbSelectArea("SX3")
			dbSeek("SZB")
			nUsado:=0
			While !Eof() .And. (X3_ARQUIVO == "SZB")
				IF X3USO(X3_USADO)                         .And. ;
					cNivel >= x3_nivel                      .And. ;
					Alltrim(SX3->X3_CAMPO) <> "ZB_CCUSTO"   .And. ;
					Alltrim(SX3->X3_CAMPO) <> "ZB_ANO"      .And. ;
					Alltrim(SX3->X3_CAMPO) <> "ZB_REVISAO"
					nUsado := nUsado + 1
					IF nOpcx == 3
						IF X3_TIPO == "C"
							aCols[1][nUsado] := SPACE(x3_tamanho)
						Elseif X3_TIPO == "N"
							aCols[1][nUsado] := 0
						Elseif X3_TIPO == "D"
							aCols[1][nUsado] := dDataBase
						Elseif X3_TIPO == "M"
							aCols[1][nUsado] := ""
						Else
							aCols[1][nUsado] := .F.
						Endif
					Endif
				Endif
				dbSkip()
			EndDo
			aCols[1][nUsado+1] := .F.			
		Endif	
	EndIf
	
Else
	dbSelectArea("SZB")
	dbSetOrder(1)                                                                                                                                              
	dbSeek(xFilial("SZB")+cCCusto+cAno+cRevisao)
	
	//CRISLEI TOLEDO - 08/05/02 - TRATAMENTO DOS ORCAMENTOS APROVADOS
	If PARAMIXB == "A"
		If SZB->ZB_APROVA == "S"
			MsgBox("Esta Revisao nao pode ser alterada, pois ja foi aprovada","Alterar Orcamento","STOP")
			Return
		EndIf
	EndIf
	
	aCols := {}
		
	While (! Eof())                      .And. ;
	(xFilial("SZB")  == SZB->ZB_Filial)  .And. ;
	(SZB->ZB_CCUSTO  == cCCusto  )       .And. ;
	(SZB->ZB_ANO     == cAno     )       .And. ;
	(SZB->ZB_REVISAO == cRevisao)
			
	Aadd(aCols,Array(Len(aHeader)+1))
		For nXi := 1 to Len(aHeader)
			aCols[Len(aCols),nXi] := FieldGet(FieldPos(aHeader[nXi,2]))
		Next nXi
		aCols[Len(aCols),Len(aHeader)+1] := .F.
		dbSelectArea("SZB")
		dbSkip()
	EndDo
EndIf

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Variaveis do Cabecalho do Modelo 2                           ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
cTitulo:="Cadastro de Orcamento"

aC:={}
// aC[n,1] = Nome da Variavel Ex.:"cCliente"
// aC[n,2] = Array com coordenadas do Get [x,y], em Windows estao em PIXEL
// aC[n,3] = Titulo do Campo
// aC[n,4] = Picture
// aC[n,5] = Validacao
// aC[n,6] = F3
// aC[n,7] = Se campo e' editavel .t. se nao .f.

//AADD(aC,{"cCCusto" ,  {15,10},"SubConta"        ,"@!"                        ,"!Empty(cCCusto) .and. U_ValOrca() .And. if(cEmpAnt='02',.t.,U_ValRevi())","CTT",lEdit})
AADD(aC,{"cCCusto" ,  {15,10},"SubConta"        ,"@!"                        ,"!Empty(cCCusto) .and. U_ValOrca() .And. if(cEmpAnt <> '01',.t.,U_ValRevi())","CTT",lEdit})
AADD(aC,{"cRevisao", {15,180},"Revisao Ano/Mes ",PesqPict("SZB","ZB_REVISAO"),"U_ValRevi()",,.F.})
AADD(aC,{"cAno"    , {15,280},"Ano"             ,PesqPict("SZB","ZB_ANO")    ,"U_ValRevi()",,})

aR:={}
// aR[n,1] = Nome da Variavel Ex.:"cCliente"
// aR[n,2] = Array com coordenadas do Get [x,y], em Windows estao em PIXEL
// aR[n,3] = Titulo do Campo
// aR[n,4] = Picture
// aR[n,5] = Validacao
// aR[n,6] = F3
// aR[n,7] = Se campo e' editavel .t. se nao .f.

aCGD:={29,5,118,315}

cLinhaOk := "AllWaysTrue() .And. U_VlrImpEv()"
cTudoOk  := "AllWaysTrue() .And. U_VlrImpEv()"

lRetMod2 := Modelo2(cTitulo,aC,aR,aCGD,nOpcx,cLinhaOk,cTudoOk,       ,{||U_SZ3IncLin()},,,{aSize[7],000,aSize[6],aSize[5]})
//          Modelo2(cTitulo,aC,aR,aCGD,nOpcx,cLineOk ,cAllOk ,aGetsGD,bF4   ,cIniCpos,nMax,aCordW,lDelGetD)
If lRetMod2 .And. nOpcx <> 2
   Processa()
ElseIf lRetMod2 .And. PARAMIXB == "E"
   FDelete()
ElseIf lRetMod2 .And. PARAMIXB == "C"
	FAprova()
Endif

If lReindex
   dbSelectArea(aArqInp[1])
   dbSetOrder(aArqInp[2])
//   dbReIndex(aArqInp[1])
   dbGoTo(aArqInp[3])
EndIf

Return


Static Function Processa()
******************************************************************************
*
*
****

Local nxJ := 0
Local nXi := 0

nSeq := 1
nPosIte := aScan(aHeader,{|aAux| Upper(alltrim(aAux[2])) == "ZB_ITEMORC"})
nValrend:=0

dbSelectArea("SZB")
dbSetOrder(1)

For nXi := 1 To Len(aCols)
	If ! aCols[nXi,Len(aHeader)+1]
		If RecLoCk("SZB",! dbSeek(xFilial("SZB")+cCCusto+cAno+cRevisao+aCols[nXi,nPosIte]))
			For nxJ := 1 To Len(aHeader)
				nPosOr := FieldPos(aHeader[nxJ,2])
				FieldPut(nPosOr,aCols[nXi,nxJ])
			Next nXj
			If FieldGet(FieldPos("ZB_REVISAO")) <> cRevisao
				lReindex := .T.
			EndIf
			Replace ZB_FILIAL  With xFilial()
			Replace ZB_CCUSTO  With cCCusto
			Replace ZB_ANO     With cAno
			Replace ZB_REVISAO With cRevisao
			Replace ZB_ITEMORC With StrZero(nSeq,2)
//			IF cEmpAnt=='02' 
			IF cEmpAnt <> '01' 
				nValRend:=0
				If GdFieldGet("ZB_TIPO",nXi)=='E'
					nValrend:=U_CalcRend(GdFieldGet("ZB_GRUPGER",nXi),GdFieldGet("ZB_DESCRI",nXi),GdFieldGet("ZB_RENDI",nXi),nXi)	
					Replace ZB_RENDI With nValrend
				Endif
				If nValRend <= 0
					Replace ZB_RENDI With ZB_VLREVEN
				Endif	
			Endif			
			
			nSeq := nSeq + 1
			MsUnlock()
			FGravMes("A")
		EndIf
	Else /*Deletado*/
		If dbSeek(xFilial("SZB")+cCCusto+cAno+cRevisao+aCols[nXi,nPosIte])
			RecLock("SZB",.F.)
			dbDelete()
			MsUnlock()
			FGravMes("E")
		EndIf
	EndIf
Next nXi

Return        



Static Function FDelete()
/*************************************
 * Deleta registros dos arquivos SZB *
 *************************************/

dbSelectArea("SZB")
dbSetOrder(1)
dbSeek(xFilial("SZB")+cCCusto+cAno+cRevisao)

While (! Eof()) 		            	   .And. ;
      (xFilial("SZB")  == SZB->ZB_Filial)  .And. ;
      (SZB->ZB_CCUSTO  == cCCusto  )	   .And. ;
      (SZB->ZB_ANO     == cAno	   )	   .And. ;
      (SZB->ZB_REVISAO == cRevisao )
  
   RecLock("SZB",.F.)
   dbDelete()
   MsUnLock()
   FGravMes("E")
   dbSkip()
EndDo

MsUnLock()

Return
                         
       

Static Function FConsContr()
/*********************************
 * Consulta o numero do contrato *
 *********************************/


aArqAnt := {Alias(),IndexOrd(),Recno()}

dbSelectArea("SZ2")
dbSetOrder(3)
dbSeek(xFilial("SZ2")+Alltrim(cCCusto))

If !Eof()
	cContrat := SZ2->Z2_COD
EndIf

dbSelectArea(aArqAnt[1])
dbSetOrder(aArqAnt[2])
dbGoto(aArqAnt[3])

Return
       


Static Function FGravMes(cAcao)
/*********************************************************
 * Grava registros no arquivo de meses do Orcamento (SZI)*
 *********************************************************/

Local aArqSZB := { "SZB", IndexOrd(), Recno()}

Local cSZBMes   := ""
Local nQtdeHora := 0
Local nTotaHora := 0
Local cValrMes  := ""

Local nXA := 0

/*Apaga registros antigos*/
dbSelectArea("SZI")
dbSetOrder(1)
dbSeek(xFilial("SZI")+SZB->ZB_CCUSTO+SZB->ZB_ANO+SZB->ZB_REVISAO+SZB->ZB_ITEMORC)

While (! Eof()) 			               .And. ;
      (xFilial("SZI")  == SZI->ZI_Filial)  .And. ;
      (SZI->ZI_CCUSTO  == SZB->ZB_CCUSTO)  .And. ;
      (SZI->ZI_ANO     == SZB->ZB_ANO)     .And. ;
      (SZI->ZI_REVISAO == SZB->ZB_REVISAO) .And. ;
      (SZI->ZI_ITEMORC == SZB->ZB_ITEMORC)
   If RecLock("SZI",.F.)
   	dbDelete()
   	MsUnLock()
   	dbSkip()
   EndIf
EndDo

/*Grava novos registros*/
If cAcao <> "E"
	/*cria um registro para cada mes do arquivo SZB*/ 
	For nXA := 1 To 12
		cSZBMes  := "SZB->ZB_HRMES" + StrZero(nXA,2)
		cValrMes := "SZB->ZB_MES" + StrZero(nXA,2)
		If AllTrim(&cSZBMes) <> ":" .and. AllTrim(&cSZBMes) <> "" 
			If RecLock("SZI",.T.)
				Replace ZI_FILIAL  With xFilial("SZI")
				Replace ZI_CCUSTO  With SZB->ZB_CCUSTO
				Replace ZI_ANO     With SZB->ZB_ANO
				Replace ZI_GRUPGER With SZB->ZB_GRUPGER
				Replace ZI_REVISAO With SZB->ZB_REVISAO
				Replace ZI_ITEMORC With SZB->ZB_ITEMORC
				Replace ZI_DESCRI  With SZB->ZB_DESCRI /*Codigo do funcionario*/
				Replace ZI_DESC2   With SZB->ZB_DESC2
				Replace ZI_RENDI   With SZB->ZB_RENDI
				Replace ZI_MESANO  With StrZero(nXA,2)+"/"+SZB->ZB_ANO
				/*O usuario informara o numero de horas realizadas pelo 
				funcionario e nao o valor que ele recebera*/
				Replace ZI_HORAMES With &cSZBMes
				/*Transforma a qtde. de horas informadas em número*/
				nQtdeHora := ((Val(SubStr(AllTrim(SZI->ZI_HORAMES),1,3))*60) + (Val(SubStr(AllTrim(SZI->ZI_HORAMES),5,2))))/60
				/*Calculo das horas no mes*/
				nTotaHora := ExecBlock("CalcHora",.F.,.F.,{AllTrim(SZB->ZB_DESCRI),SZI->ZI_MESANO})
				/*Calculo do valor a ser pago ao funcionario*/
				Replace ZI_VALRMES With ((SZI->ZI_RENDI/nTotaHora)*nQtdeHora)
				
				dbSelectArea("SZI")
				MsUnLock()
				/*********************************************
				 *Grava o valor no SZB                       *
				 *dbSelectArea("SZB")                        *
				 *If RecLock("SZB",.F.)                      *
				 *	Replace &cValrMes With SZI->ZI_VALRMES   *
				 *  MsUnlock()                               *
				 *EndIf                                      *
				 *********************************************/
			EndIf
		EndIf
	Next
EndIf

dbSelectArea(aArqSZB[01])
dbSetOrder(aArqSZB[02])
dbGoTo(aArqSZB[03])

Return


/*INCLUIDO POR CRISLEI TOLEDO - 08/05/02 - CONTROLE DE APROVACAO DE ORCAMENTO*/
Static Function FAprova()
******************************************************************************
*
*
****

Local nXi := 0

If !MsgBox("Confirma Aprovacao deste Orcamento?","Pergunta","YESNO")
	Return
EndIf

nPosIte := aScan(aHeader,{|aAux| Upper(alltrim(aAux[2])) == "ZB_ITEMORC"})

dbSelectArea("SZB")
dbSetOrder(1)

For nXi := 1 To Len(aCols)
    dbSeek(xFilial("SZB")+cCCusto+cAno+cRevisao+aCols[nXi,nPosIte])
    If RecLoCk("SZB",.F.)
       Replace ZB_APROVA  With "S"
       MsUnlock()
	 EndIf
Next

Return


Static Function FTela()
***********************************************
* 
* 
****
Private lRet       := .F.
@ 000,000 To 230,250 Dialog oDlg Title "Copia Revisao"
@ 005,005 To 100,110  Title "Copia revisao"
@ 015,007 Say "SubConta:"
@ 015,050 GET cCCusto  PICTURE "@!" F3 "CTT" VALID U_ValOrca() .And. if(cEmpAnt $ '02|03|04',.t.,U_ValRevi()) SIZE 40,50
@ 030,007 Say "Copiar Revisao:"
@ 030,050 GET cReviCop PICTURE "@!" SIZE 20,30 Valid   if(cEmpAnt $ '02|03|04',.t.,VldRev())
@ 045,007 Say "Ano:"
@ 045,050 GET cAnoRev  PICTURE "@!" When (cEmpAnt $ '02|03|04') Valid   VldRev() .And. U_ValOrca() .And. if(cEmpAnt $ '02|03|04',.t.,U_ValRevi()) SIZE 20,30
@ 060,007 Say "Para Revisao:"
@ 060,050 GET cRevisao PICTURE "@!" When .f.  SIZE 20,30   
@ 075,007 Say "Ano:"
@ 075,050 GET cAno     PICTURE "@!" When (cEmpAnt $ '02|03|04',) Valid U_ValRevi() SIZE 20,30   
@ 100,020 BmpButton Type 01 Action (OkProc(),lRet:=.T.)
@ 100,060 BmpButton Type 02 Action  (Close(oDlg),lRet:=.F.)
Activate Dialog oDlg Center                

Return(lRet)



Static Function VldRev()
****************************************************************************************************************
*
*
*****
Local lRet:=.t.

//cAnoRev:=if(cEmpAnt<>'02',Left(cReviCop,4),cAnoRev)
cAnoRev:=if(cEmpAnt = '01',Left(cReviCop,4),cAnoRev)
dbSelectArea("SZB")
dbSetORder(1)
If !SZB->(dbSeek(Xfilial("SZB")+cCCusto+cAnoRev+cReviCop))
	MsgBox("Revisão de Origem Não encontrada !!","Validação")
	lRet:=.f.
Endif	

Return(lRet)



Static Function OkProc()
***********************************************
* 
* 
****
If AllTrim(cReviCop) <> "" .And. ;
   AllTrim(cCCusto)  <> "" .And. ;
   AllTrim(cAno)     <> "" .And. ;
   AllTrim(cRevisao) <> "" .And. ;
   AllTrim(cAnoRev)     <> ""
   	
   	cOk := .T.
	Close(oDlg)
Else
	MsgBox("Alguns dos campos nao foram preenchidos","Inconsistencia","STOP")
EndIf

Return



User Function CalcRend(cGrupo,cDescri,nRend,nPos)			
***************************************************************************************************************************************************
*
*
*****                                    
Local nReturn:=nRend
Local xVal:=0
If SZA->(dbSeek(Xfilial("SZA")+cGrupo))
	//Calcula o Valor do Evento
	If SZA->ZA_FOCLFU=='E' .And. SZD->(dbSeek(Xfilial("SZD")+Alltrim(cDescri)))
		If SZD->ZD_SALAFUN>0
			// Retirado a pedido da Renata em 21/09/06
			// Esta valor esta sendo multiplicado também no calculo do Fluxo
			nReturn:=(SZD->ZD_SALAFUN*SZA->ZA_FATOR)
			///Em 06/12/2006 - O sistema deve aplicar os fatores e a Planilha não deve calcular.
			///nReturn:=(SZD->ZD_SALAFUN)
		Else
			nReturn:=GdfieldGet("ZB_VLREVEN",If(nPos==Nil,n,nPos))
		endif
	Else
		If SZA->ZA_FOCLFU=='F' .And. GdFieldget("ZB_MATPJ",If(nPos==Nil,n,nPos))<>''
			xVal:=Posicione("SRA",1,'97'+GdFieldget("ZB_MATPJ",If(nPos==Nil,n,nPos)),"RA_SALARIO")
			If xVal>0
				nReturn:=xVal
			Endif
		Endif
	Endif
Endif

Return(nReturn)



User Function VlrImpEv()
***********************************************************************************************************************
*
*
***** 

Local nXA := 0 
Local cCmpMes := ""
Local lRet := .T.
Local nVlrImp := 0  
Local nXi := 0
Local nXy := 0

Private nTotEv := 0
                
nLinImp:=aScan(aCols,{|x| Alltrim(x[2]) == "000015" .And. !x[Len(aHeader)+1]})
//If cEmpAnt='02' 
If cEmpAnt <> '01' 
   
	If GdFieldget("ZB_TIPO")=='V'
		/// Valida o Valor total do Evento.
		nTotEv:=0
	   For nXA := 1 To 12
	   	nTotEv+=GdFieldGet("ZB_MES"+StrZero(nXA,2))
		Next nXa
		If GdFieldGet("ZB_VLREVEN") < nTotEv
			MsgBox("A Soma dos Eventos Mensais é Maior que o Valor Total.")
			lRet:=.f.
		Else
			//Grava o Saldo do Período
			GdFieldPut("ZB_SALDPER",(GdFieldGet("ZB_VLREVEN")-nTotEv))
		Endif
	Endif	
	
	If lRet .And. nLinImp>0 .And. (GdFieldget("ZB_TIPO")=='V' .OR. GdFieldget("ZB_GRUPGER")=='000015')
		For nXy := 1 To 12
			cCmpMes:="ZB_MES"+StrZero(nXy,2)
			nVlrImp:=0
			For nXi := 1 To Len(Acols)
				If nXi<>nLinImp .And. !GdDeleted(nXi) .And. GdFieldget("ZB_TIPO",nXi)=='V'
					dbSelectArea("SZ3")
					dbSetOrder(3)
					nAliq:=0  
					//cCod:=Alltrim(GdFieldget("ZB_DESCRI",nXi))+Replicate(" ",TamSx3("Z3_COD")[1]-Len(Alltrim(GdFieldget("ZB_DESCRI",nXi))))
					//cCod:= GdFieldget("ZB_DESCRI",nXi)
					If dbSeek(Xfilial("SZ3")+GdFieldget("ZB_DESCRI",nXi)+Left(cCCusto,5)) .And. !Empty(SZ3->Z3_CODALIQ)
						nAliq:=Posicione("SZS",1,Xfilial("SZS")+SZ3->Z3_CODALIQ,"ZS_ALIQ")
					Endif	
					nVlrImp+=GdFieldGet(cCmpMes,nXi)*(nAliq/100)
				Endif
			Next nXi 
			GdFieldPut(cCmpMes,nVlrImp,nLinImp)
		Next nXy	
	Endif
Endif
Return(lRet)



User Function SZ3IncLin()
************************************************************************************************************
*
*
*
*****
Local aRadio:={"Inserir Nova Linha","","Copiar Linha Atual"}
            

DEFINE MSDIALOG oDlgLin TITLE " Selecione a Opção:" FROM 05,05 To 14,25

@ 05,05 BUTTON ":: Inserir Linha ::" SIZE 70,10 ACTION (NewLin('1'),oDlgLin:End()) 
@ 20,05 BUTTON ":: Copiar Linha  ::" SIZE 70,10 ACTION (NewLin('2'),oDlgLin:End()) 
@ 35,05 BUTTON "::    S A I R    ::" SIZE 70,10 ACTION oDlgLin:End() 

ACTIVATE MSDIALOG oDlgLin

Return()



Static Function NewLin(nOpcSel)
**************************************************************************************************
*
*
******
Local nXi:=0
If nOpcSel=='1' //Cria uma nova Linha
	Aadd(aCols,Array(Len(aHeader)+1))
	For nXi:= 1 To Len(aHeader)
		aCols[Len(aCols),nXi]:= CriaVar(aHeader[nXi,2],.T.)
	Next nXi
	aCols[Len(Acols),Len(aHeader)+1] := .F.
	GdFieldGet("ZB_ITEMORC")
	GdFieldPut("ZB_ITEMORC",GdFieldGet("ZB_ITEMORC"),Len(Acols))			
	For nXi:=n to Len(Acols)-1
		GdFieldPut("ZB_ITEMORC",StrZero(Val(GdFieldGet("ZB_ITEMORC",nXi))+1,2),nXi)			
	Next nXi
	aCols:=Asort(aCols,,,{|x,y| x[1] < y[1]})
Else
	Aadd(aCols,Array(Len(aHeader)+1))
	For nxI := 1 to Len(aHeader)
		aCols[Len(Acols),nxI] := aCols[n,nXi]
	Next nXi
	aCols[Len(Acols),Len(aHeader)+1] := .F.
	GdFieldPut("ZB_ITEMORC",StrZero(Len(Acols),2),Len(Acols))
Endif




//Copia o Orçamento
User Function CopyOrc()
************************************************************************************************************************************************
*
*
******
Private cCCusto:=SZB->ZB_CCUSTO
Private cAnoDe:=SZB->ZB_ANO
Private cAnoPAra:=Space(4)

@ 000,000 To 200,250 Dialog oDlg Title "Copiar Ano/SubConta"
@ 005,005 To 075,110  Title "SubConta/Ano"
@ 015,007 Say "SubConta...:"
@ 015,050 GET cCCusto PICTURE "@!" F3 "CTT" VALID ExecBlock('ValOrca',.F.,.F.) SIZE 40,50
@ 030,007 Say "Ano de.....:"
@ 030,050 GET cAnoDe PICTURE "@9999" VALID Len(cAnoDe)==4 SIZE 20,30
@ 045,007 Say "Ano Destino:"
@ 045,050 GET cAnoPara PICTURE "@ 9999" Valid Len(cAnoPara)==4  .And. VldAno() SIZE 20,30
@ 080,010 BmpButton Type 01 Action (CopySZB(),oDlg:End())
@ 080,060 BmpButton Type 02 Action oDlg:End()
 Activate Dialog oDlg Center                

Return()



Static Function VldAno
***********************************************************************************************************************************************
*
*
******

Local cQuery:=""
Local lRet:=.t.

cQuery:=" SELECT Count(*) Itens FROM "+RetsqlName("SZB")+" WHERE ZB_CCUSTO='"+cCCusto+"' AND ZB_ANO='"+cAnoPara+"' AND D_E_L_E_T_<>'*' "
cQuery+=" AND ZB_FILIAL='"+Xfilial("SZB")+"'"
TcQuery cQuery Alias QSZB New

If QSZB->Itens>0
	MsgBox("Já existem registros deste centro de custo para o Ano informado","ERRO")
	lRet:=.f.
Endif
dbSelectArea("QSZB")
dbCloseArea()

Return(lRet)



Static function CopySZB()
********************************************************************************************************************************
*
*
********

Local aAreaAt:=GetArea()
Local cQuery:=""
Local aStru:={}
Local cUltRev:=""
Local nXi := 0

//Verifica qual é a Ultima Revisão
cQuery:=" SELECT Max(ZB_REVISAO) ULTREVISAO FROM "+RetsqlName("SZB")+" WHERE ZB_CCUSTO='"+cCCusto+"' AND ZB_ANO='"+cAnoPara+"' AND D_E_L_E_T_<>'*' "
cQuery+=" AND ZB_FILIAL='"+Xfilial("SZB")+"'"
TcQuery cQuery Alias QSZB New
cUltRev:=QSZB->ULTREVISAO
dbSelectArea("QSZB")
dbCloseArea()

cQuery:=" SELECT * FROM "+RetsqlName("SZB")
cQuery+=" WHERE ZB_CCUSTO='"+cCCusto+"' AND ZB_ANO='"+cAnoDe+"' AND D_E_L_E_T_<>'*' AND ZB_FILIAL='"+Xfilial("SZB")+"'"
TcQuery cQuery Alias QSZB New

dbSelectArea("SZB")
aStru:=dbStruct()
dbSelectArea("QSZB")

For nXi := 1 To Len(aStru)
	If Alltrim(aStru[2])$'N/D'
		TCSetField("QSZB", aStru[1], aStru[2], aStru[3],aStru[4])
	Endif
Next nXi

dbSelectArea("QSZB")
dbGotop()
aCols := {}
While !Eof()
	////RegToMemory("QSZB",.F.)
	dbSelectArea("SZB")    
	RecLock("SZB",.T.)
	For nXi:=1 To FCount()
		cCmp:='QSZB->'+SZB->(FieldName(nXi))
		FieldPut(nXi,&cCmp)
	Next nXi
	Replace ZB_ANO With cAnoPara
	//Para a Ultima revisão será copiado apenas o saldo do Evento
	If QSZB->ZB_TIPO=='V' .And. QSZB->ZB_REVISAO==cUltRev .And. QSZB->ZB_SALDPER > 0
		Replace  ZB_VLREVEN With QSZB->ZB_SALDPER,;
  					ZB_MES01   With 0 ,;
					ZB_MES02   With 0 ,;
					ZB_MES03   With 0 ,;
					ZB_MES04   With 0 ,;
					ZB_MES05   With 0 ,;
					ZB_MES06   With 0 ,;
					ZB_MES07   With 0 ,;
					ZB_MES08   With 0 ,;
					ZB_MES09   With 0 ,;
					ZB_MES10   With 0 ,;
					ZB_MES11   With 0 ,;
					ZB_MES12   With 0 ,;
					ZB_HRMES01 With "",;
					ZB_HRMES02 With "",;
					ZB_HRMES03 With "",;
					ZB_HRMES04 With "",;
					ZB_HRMES05 With "",;
					ZB_HRMES06 With "",;
					ZB_HRMES07 With "",;
					ZB_HRMES08 With "",;
					ZB_HRMES09 With "",;
					ZB_HRMES10 With "",;
					ZB_HRMES11 With "",;
					ZB_HRMES12 With ""
	Endif
	MsUnlock() 
	dbSelectArea("QSZB")
	dbSkip()
EndDo
dbSelectArea("QSZB")
dbCloseArea()
RestArea(aAreaAt)

cQuery:=" SELECT Count(*) Itens FROM "+RetsqlName("SZB")+" WHERE ZB_CCUSTO='"+cCCusto+"' AND ZB_ANO='"+cAnoPara+"' AND D_E_L_E_T_<>'*' "
cQuery+=" AND ZB_FILIAL='"+Xfilial("SZB")+"'"
TcQuery cQuery Alias QSZB New

If QSZB->Itens>0
	MsgBox("Copia Efetuada com Sucesso","ATENÇÃO")
Endif
dbSelectArea("QSZB")
dbCloseArea()

Return()

