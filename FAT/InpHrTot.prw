/*
+---------+----------+------+----------------------------------+-------+---------+
|Programa |INPHRTOT  |Autor | Crislei Toledo							| Data  | 07/05/02|	
+---------+----------+------+----------------------------------+-------+---------+
|Descricao| Cadastro de total de horas por setor											|
+--------------------------------------------------------------------------------+
|							Alteracoes feitas desde a criacao									|
+-------------+-----------+------------------------------------------------------+
|Programador  |Data       |Descricao															|
+-------------+-----------+------------------------------------------------------+
|				  |           |																		|
+-------------+-----------+------------------------------------------------------+
*/

#include "rwmake.ch"

User Function InpHrTot()

Local nxI := 0 

SetPrvt("AARQINP,LREINDEX,NOPCX,CCCUSTO,CANO,CREVISAO")
SetPrvt("LEDIT,NSEQ,CCONTRAT,CTIPODES,NUSADO,AHEADER")
SetPrvt("NPOSDESC,ACOLS,NXI,CTITULO,AC,AR")
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
   cSetor   := Space(06)
Else
   cSetor  := SZL->ZL_CODISET
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
dbSeek("SZL")
nUsado:=0
aHeader:={}

While !Eof() .And. (x3_arquivo == "SZL")

   IF X3USO(x3_usado)                         .And. ;
      cNivel >= x3_nivel                      .And. ;
      Alltrim(SX3->X3_CAMPO) <> "ZL_CODISET"
      nUsado := nUsado + 1
      Aadd(aHeader,{ TRIM(x3_titulo), x3_campo, x3_picture, x3_tamanho, ;
           x3_decimal, ,  x3_usado, x3_tipo, x3_arquivo, x3_context, x3_F3 } )

    Endif
    dbSkip()
End

nPosMes := aScan(aHeader,{|aAux| Upper(Alltrim(aAux[2])) == "ZL_MESANO"})

If PARAMIXB == "I"

   aCols:=Array(1,nUsado+1)
   dbSelectArea("SX3")
   dbSeek("SZL")
   nUsado:=0

   While !Eof() .And. (X3_ARQUIVO == "SZL")
      IF X3USO(X3_USADO)                         .And. ;
         cNivel >= x3_nivel                      .And. ;
         Alltrim(SX3->X3_CAMPO) <> "ZI_CODISET"
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
   dbSelectArea("SZL")
   dbSetOrder(1)
   dbSeek(xFilial("SZL")+cSetor)

   aCols := {}

   While (! eof())                            .And. ;
         (xFilial("SZL")  == SZL->ZL_Filial)  .And. ;
         (SZL->ZL_CODISET == cSetor   )
      Aadd(aCols,Array(Len(aHeader)+1))
      For nxI := 1 to Len(aHeader)
         aCols[Len(aCols),nxI] := FieldGet(FieldPos(aHeader[nxI,2]))
      Next
      aCols[Len(aCols),Len(aHeader)+1] := .F.

      dbSelectArea("SZL")
      dbSkip()
   EndDo
EndIf
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Variaveis do Cabecalho do Modelo 2                           ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Titulo da Janela                                             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
cTitulo:="Cadastro de Total de Horas por Setor"
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Array com descricao dos campos do Cabecalho do Modelo 2      ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
aC:={}
// aC[n,1] = Nome da Variavel Ex.:"cCliente"
// aC[n,2] = Array com coordenadas do Get [x,y], em Windows estao em PIXEL
// aC[n,3] = Titulo do Campo
// aC[n,4] = Picture
// aC[n,5] = Validacao
// aC[n,6] = F3
// aC[n,7] = Se campo e' editavel .t. se nao .f.

AADD(aC,{"cSetor",  {15,10} ,"Setor" ,"@!",".T.","SZ4",lEdit})

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Array com descricao dos campos do Rodape do Modelo 2         ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
aR:={}
// aR[n,1] = Nome da Variavel Ex.:"cCliente"
// aR[n,2] = Array com coordenadas do Get [x,y], em Windows estao em PIXEL
// aR[n,3] = Titulo do Campo
// aR[n,4] = Picture
// aR[n,5] = Validacao
// aR[n,6] = F3
// aR[n,7] = Se campo e' editavel .t. se nao .f.
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Array com coordenadas da GetDados no modelo2                 ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
aCGD:={29,5,118,315}
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Validacoes na GetDados da Modelo 2                           ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
cLinhaOk := "AllWaysTrue()"
cTudoOk  := "AllWaysTrue()"

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Chamada da Modelo2                                           ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
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
/*
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
		    //ALTERADO PRO CRISLEI TOLEDO - 02/05/02 - GRAVACAO ARQUIVO MESES ORCAMENTO (SZI)
		//    FGravMes("A")
		 EndIf
    Else
       If ! Eof()
          If RecLock("SZB",.F.)
          	 dbDelete()
          	 MsUnlock()
          EndIf
       EndIf       
       //ALTERADO PRO CRISLEI TOLEDO - 02/05/02 - GRAVACAO ARQUIVO MESES ORCAMENTO (SZI)//
      // FGravMes("E")
    EndIf    
Next
*/
Return


Static Function FDelete()
*****************************************************************************
* Deleta registros dos arquivos SZB
*
********
/*
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
 */
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
		  		Replace ZI_DESC2	 With SZB->ZB_DESC2
   			Replace ZI_RENDI	 With SZB->ZB_RENDI
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