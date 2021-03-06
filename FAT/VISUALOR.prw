/*
+---------+----------+------+----------------------------------+-------+---------+
|Programa |VISUALOR  |Autor | Crislei Toledo							| Data  | 02/05/02|	
+---------+----------+------+----------------------------------+-------+---------+
|									Especifico para EPC												|
+--------------------------------------------------------------------------------+
|							Alteracoes feitas desde a criacao									|
+-------------+-----------+------------------------------------------------------+
|Programador  |Data       |Descricao															|
|CLSILVA      |31/10/05	  |Alteracao SI3 para CTT           							|
+-------------+-----------+------------------------------------------------------+
*/

#include "rwmake.ch"

User Function VISUALOR()

Local nxI := 0

SetPrvt("AARQINP,LREINDEX,NOPCX,CCCUSTO,CANO,CREVISAO")
SetPrvt("LEDIT,NSEQ,CCONTRAT,CTIPODES,NUSADO,AHEADER")
SetPrvt("NPOSDESC,ACOLS,CTITULO,AC,AR")
SetPrvt("ACGD,CLINHAOK,CTUDOOK,LRETMOD2,NPOSITE,NXJ")
SetPrvt("NPOSOR,")

aArqInp  := { Alias() , IndexOrd() , Recno() }
lReindex := .F.

DO CASE
   CASE (PARAMIXB $"I/A")
        nOpcx:=3   // 3 = PODE EDITAR O DADO
   CASE (PARAMIXB $"V/E")
        nOpcx:=2   // 2 = PODE VISUALIZUR O DADO
ENDCASE

If PARAMIXB == "I"
   cCCusto  := Space(11)
   cAno     := Space(04)
   cMesAno  := Space(07)
   cRevisao := Space(TamSx3("ZB_REVISAO")[1])
   cContrat := ""
	cTipoDes := ""
Else
   cCCusto  := SZI->ZI_CCUSTO 
   cAno     := SZI->ZI_ANO
   cMesAno  := SZI->ZI_MESANO
   cRevisao := SZI->ZI_REVISAO
   FConsContr()//Alterado por Crislei Toledo - 29/01/02

EndIf

IF PARAMIXB == "A"
   lEdit := .F.
Else
   lEdit := .T.
EndIf

*???nSeq := 1

//cContrat := ""
//cTipoDes := ""

//旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴커
//� Montando aHeader                                             �
//읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴켸

dbSelectArea("SX3")
dbSetOrder(1)
dbSeek("SZI")
nUsado:=0
aHeader:={}
While !Eof() .And. (x3_arquivo == "SZI")

   IF X3USO(x3_usado)                         .And. ;
      cNivel >= x3_nivel                      .And. ;
      Alltrim(SX3->X3_CAMPO) <> "ZI_CCUSTO"   .And. ;
      Alltrim(SX3->X3_CAMPO) <> "ZI_ANO"      .And. ;
      Alltrim(SX3->X3_CAMPO) <> "ZI_MESANO"   .And. ;
      Alltrim(SX3->X3_CAMPO) <> "ZI_REVISAO"
      nUsado := nUsado + 1
      Aadd(aHeader,{ TRIM(x3_titulo), x3_campo, x3_picture, x3_tamanho, ;
           x3_decimal, ,  x3_usado, x3_tipo, x3_arquivo, x3_context, x3_F3 } )

    Endif
    dbSkip()
End

nPosDesc := aScan(aHeader,{|aAux| Upper(Alltrim(aAux[2])) == "ZI_DESCRI"})

If PARAMIXB == "I"
   aCols:=Array(1,nUsado+1)
   dbSelectArea("SX3")
   dbSeek("SZI")
   nUsado:=0
   While !Eof() .And. (X3_ARQUIVO == "SZI")
      IF X3USO(X3_USADO)                         .And. ;
         cNivel >= x3_nivel                      .And. ;
         Alltrim(SX3->X3_CAMPO) <> "ZI_CCUSTO"   .And. ;
         Alltrim(SX3->X3_CAMPO) <> "ZI_ANO"      .And. ;
         Alltrim(SX3->X3_CAMPO) <> "ZI_MESANO"   .And. ;
         Alltrim(SX3->X3_CAMPO) <> "ZI_REVISAO"
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
   dbSelectArea("SZI")
   dbSetOrder(2)
   dbSeek(xFilial("SZI")+cCCusto+cAno+cMesAno)

   aCols := {}

   While (! eof())                            .And. ;
         (xFilial("SZI")  == SZI->ZI_Filial)  .And. ;
         (SZI->ZI_CCUSTO  == cCCusto  )       .And. ;
         (SZI->ZI_ANO     == cAno     )       .And. ;
         (SZI->ZI_MESANO  == cMesAno  )         
      Aadd(aCols,Array(Len(aHeader)+1))
      For nxI := 1 to Len(aHeader)
         aCols[Len(aCols),nxI] := FieldGet(FieldPos(aHeader[nxI,2]))
      Next
      aCols[Len(aCols),Len(aHeader)+1] := .F.

      dbSelectArea("SZI")
      dbSkip()
   EndDo
EndIf
//旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴커
//� Variaveis do Cabecalho do Modelo 2                           �
//읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴켸
//旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴커
//� Titulo da Janela                                             �
//읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴켸
cTitulo:="Cadastro de Orcamento"
//旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴커
//� Array com descricao dos campos do Cabecalho do Modelo 2      �
//읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴켸
aC:={}
// aC[n,1] = Nome da Variavel Ex.:"cCliente"
// aC[n,2] = Array com coordenadas do Get [x,y], em Windows estao em PIXEL
// aC[n,3] = Titulo do Campo
// aC[n,4] = Picture
// aC[n,5] = Validacao
// aC[n,6] = F3
// aC[n,7] = Se campo e' editavel .t. se nao .f.

AADD(aC,{"cCCusto",  {15,10} ,"Centro Custo" ,"@!","ExecBlock('ValOrca',.F.,.F.)","CTT",lEdit})
AADD(aC,{"cMesAno",  {15,130},"Mes/Ano Orcam.","99/9999","",,lEdit})
AADD(aC,{"cRevisao", {15,220},"Revisao      ",PesqPict("SZB","ZB_REVISAO"),"ExecBlock('ValRevi',.F.,.F.)",,})

//旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴커
//� Array com descricao dos campos do Rodape do Modelo 2         �
//읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴켸
aR:={}
// aR[n,1] = Nome da Variavel Ex.:"cCliente"
// aR[n,2] = Array com coordenadas do Get [x,y], em Windows estao em PIXEL
// aR[n,3] = Titulo do Campo
// aR[n,4] = Picture
// aR[n,5] = Validacao
// aR[n,6] = F3
// aR[n,7] = Se campo e' editavel .t. se nao .f.
//旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴커
//� Array com coordenadas da GetDados no modelo2                 �
//읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴켸
aCGD:={29,5,118,315}
//旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴커
//� Validacoes na GetDados da Modelo 2                           �
//읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴켸
cLinhaOk := "AllWaysTrue()"
cTudoOk  := "AllWaysTrue()"

//旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴커
//� Chamada da Modelo2                                           �
//읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴켸
// lRetMod2 = .t. se confirmou
// lRetMod2 = .f. se cancelou
lRetMod2 := Modelo2(cTitulo,aC,aR,aCGD,nOpcx,cLinhaOk,cTudoOk)
// No Windows existe a funcao de apoio CallMOd2Obj() que retorna o
// objeto Getdados Corrente

If lRetMod2 .And. nOpcx <> 2
   Processa()
ElseIf lRetMod2 .And. PARAMIXB == "E"
   FDelete()
Endif

//If lReindex
   dbSelectArea(aArqInp[1])
   dbSetOrder(aArqInp[2])
   dbReIndex(aArqInp[1])
   dbGoTo(aArqInp[3])
//EndIf

Return


Static Function Processa()
******************************************************************************
*
*
****

Local nxJ := 0
Local nxI := 0

nSeq := 1
nPosIte := aScan(aHeader,{|aAux| Upper(alltrim(aAux[2])) == "ZB_ITEMORC"})

dbSelectArea("SZB")
dbSetOrder(1)

For nxI := 1 To Len(aCols)

    dbSeek(xFilial("SZB")+cCCusto+cAno+cRevisao+aCols[nxI,nPosIte])

    If ! aCols[nxI,Len(aHeader)+1]
	    If RecLock("SZB",Eof())
	       For nxJ := 1 To Len(aHeader)
   	        nPosOr := FieldPos(aHeader[nxJ,2])
	           FieldPut(nPosOr,aCols[nxI,nxJ])
   	    Next

	       If FieldGet(FieldPos("ZB_REVISAO")) <> cRevisao
   	       lReindex := .T.
       	 EndIf
	       Replace ZB_FILIAL  With xFilial()
   	    Replace ZB_CCUSTO  With cCCusto
      	 Replace ZB_ANO     With cAno
        	 Replace ZB_REVISAO With cRevisao
       	 Replace ZB_ITEMORC With StrZero(nSeq,2)
       	 nSeq := nSeq + 1
          MsUnlock()
		    /*ALTERADO PRO CRISLEI TOLEDO - 02/05/02 - GRAVACAO ARQUIVO MESES ORCAMENTO (SZI)*/
		//    FGravMes("A")
		 EndIf
    Else
       If ! Eof()
          If RecLock("SZB",.F.)
          	 dbDelete()
          	 MsUnlock()
          EndIf
       EndIf       
       /*ALTERADO PRO CRISLEI TOLEDO - 02/05/02 - GRAVACAO ARQUIVO MESES ORCAMENTO (SZI)*/
      // FGravMes("E")
    EndIf    
Next

Return


Static Function FDelete()
*****************************************************************************
* Deleta registros dos arquivos SZB
*
********

dbSelectArea("SZB")
dbSetOrder(1)
dbSeek(xFilial("SZB")+cCCusto+cAno+cRevisao)

While (! Eof()) 			   .And. ;
      (xFilial("SZB")  == SZB->ZB_Filial)  .And. ;
      (SZB->ZB_CCUSTO  == cCCusto  )	   .And. ;
      (SZB->ZB_ANO     == cAno	   )	   .And. ;
      (SZB->ZB_REVISAO == cRevisao )
   RecLock("SZB",.F.)
   dbDelete()
   MsUnLock()
   dbSkip()
EndDo

MsUnLock()

Return
                         
//Incluido por Crislei Toledo - 29/01/02
Static Function FConsContr()
*****************************************************************************
* Consulta o numero do contrato
*
********

aArqAnt := {Alias(),IndexOrd(),Recno()}

dbSelectArea("SZ2")
dbSetOrder(3)
dbSeek(xFilial("SZ2")+cCCusto)

If !Eof()
	cContrat := SZ2->Z2_COD
EndIf

dbSelectArea(aArqAnt[1])
dbSetOrder(aArqAnt[2])
dbGoto(aArqAnt[3])

Return

/*CRISLEI TOLEDO - 02/05/02 - GRAVACAO DO ARQUIVO MES ORCAMENTO (SZI)*/
Static Function FGravMes(cAcao)
*****************************************************************************
* Grava registros no arquivo de meses do Orcamento (SZI)
*
********

Local cSZBMes := ""
Local nXA := 0 

//Apaga registros antigos
dbSelectArea("SZI")
dbSetOrder(1)
dbSeek(xFilial("SZI")+SZB->ZB_CCUSTO+SZB->ZB_ANO+SZB->ZB_REVISAO+SZB->ZB_ITEMORC)

While (! Eof()) 			   .And. ;
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

//Grava novos registros
If cAcao <> "E"
	//cria um registro para cada mes do arquivo SZB
   For nXA := 1 To 12
   	cSZBMes := "SZB->ZB_MES" + StrZero(nXA,2)
   	If &cSZBMes <> 0
			If RecLock("SZI",.T.)
				Replace ZI_FILIAL  With xFilial("SZI")
				Replace ZI_CCUSTO  With SZB->ZB_CCUSTO
				Replace ZI_ANO     With SZB->ZB_ANO   			
				Replace ZI_REVISAO With SZB->ZB_REVISAO
				Replace ZI_ITEMORC With SZB->ZB_ITEMORC
				Replace ZI_DESCRI  With SZB->ZB_DESCRI
				Replace ZI_DESC2   With SZB->ZB_DESC2
				Replace ZI_RENDI   With SZB->ZB_RENDI
				Replace ZI_MESANO  With StrZero(nXA,2)+"/"+SZB->ZB_ANO
				Replace ZI_VALRMES With &cSZBMes
	   		//FALTA GRAVAR A QTDE DE HORAS (FUNCAO PARA CALCULAR DE ACORDO COM O CALENDARIO
   			//DO CONTRATO - IMPLEMENTACAO FUTURA
				MsUnLock()	
			EndIf
		EndIf
	Next
EndIf

Return