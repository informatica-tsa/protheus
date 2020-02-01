/*
+---------+----------+------+----------------------------------+-------+---------+
|Programa |InputUt   |Autor | Crislei Toledo							| Data  | 06/05/02|	
+---------+----------+------+----------------------------------+-------+---------+
|Descricao| Cadastro de dias uteis                                               |
+--------------------------------------------------------------------------------+
|							Alteracoes feitas desde a criacao									|
+-------------+-----------+------------------------------------------------------+
|Programador  |Data       |Descricao															|
+-------------+-----------+------------------------------------------------------+
|				  |           |																		|
+-------------+-----------+------------------------------------------------------+
*/

#include "rwmake.ch"

User Function InputUt(PARAMIXB)

PRIVATE cParam := PARAMIXB

#DEFINE USADO CHR(0)+CHR(0)+CHR(1)

PRIVATE aArea   := {Alias(), IndexOrd(), RecNo()}
PRIVATE nOpcX   := 0

PRIVATE cMesAtu := StrZero(Month(Date()),2)+"/"+StrZero(Year(Date()),4)
PRIVATE cCodSet := Space(06)
PRIVATE cNomTec := Space(30)

RegToMemory("SZK",.F.)

Do Case
   Case cParam $ "I/A"       
        nOpcX := 3 //PODE EDITAR O DADO
   Case cParam $ "V/E"
        nOpcX := 2 //PODE VISUALIZAR O DADO
EndCase

If cParam $ "I"
	FTelaPrin()
Else
   cCodSet := SZK->ZK_CodCont
   cMesAtu := SZK->ZK_MesAno
   FModelo2()
EndIf

dbSelectArea("SZK")
dbClearFilter()
RetIndex("SZK")

DbSelectArea(aArea[1])
DbSetOrder(aArea[2])
DbGoTo(aArea[3])

Return


STATIC Function FTelaPrin()
**********************************************************************
* Confirmacao dos campos digitados
*
***

@ 0,0 TO 220,230 DIALOG oDlgZ TITLE "Cadastro Dias Uteis"

@ 005,05 TO 80,110 

@ 015,008 SAY "Mes/Ano"
@ 015,040 GET cMesAtu PICTURE "99/9999" VALID .T. SIZE 40,50 
@ 045,008 SAY "Setor  "
@ 045,040 GET cCodSet PICTURE "@!" VALID FValSet() F3 "SZ4"

@ 090,040 BMPBUTTON TYPE 01 ACTION FConfirm()
@ 090,080 BMPBUTTON TYPE 02 ACTION FCancela()
ACTIVATE DIALOG oDlgZ CENTER

Return


Static Function FValSet()
**********************************************************************
* Rotina de Validacao do Tecnico
*
***

If ! ExistCpo("SZ4",cCodSet)
	Return(.F.)
EndIf

If !ExistChav("SZK",cCodSet+cMesAtu)
	Return(.F.)
EndIf

Return(.T.)         


Static Function FConfirm()
**********************************************************************
* Confirmacao dos campos digitados
*
***

FModelo2()
cMesAtu := StrZero(Month(Date()),2)+"/"+StrZero(Year(Date()),4)
cCodSet := Space(06)

Return


Static Function FCancela()
**********************************************************************
* Cancelamento dos campos digitados
*
***

lPassou := .F.

Close(oDlgZ)

Return      


Static Function FModelo2()
**********************************************************************
* Rotina para chamado do modelo 2 para inclusao de dias uteis
*
*****

Local nxI := 0


dbSelectArea("SZK")

PRIVATE dDataInic := CTOD("")
PRIVATE dDataFina := CTOD("")
PRIVATE dDataAuxi := CTOD("")
PRIVATE nOpca   := 0
PRIVATE nUsado  := 8
PRIVATE aHeader := {}
PRIVATE aCols := {}

dDataInic := CTOD("01/"+cMesAtu)
dDataFina := LastDay(dDataInic)
dDataAuxi := dDataInic

//MONTANDO O AHEADER()
dbSelectArea("SX3")
dbSetOrder(1)
dbSeek("SZK")
nUsado:=0
aHeader:={}
While !Eof() .And. (x3_arquivo == "SZK")

   If X3USO(x3_usado)                         .And. ;
      cNivel >= x3_nivel                      .And. ;
      Alltrim(SX3->X3_CAMPO) <> "ZK_CODCONT"  .And. ;
      Alltrim(SX3->X3_CAMPO) <> "ZK_MESANO"

      nUsado := nUsado + 1
      Aadd(aHeader,{ TRIM(x3_titulo), x3_campo, x3_picture, x3_tamanho, ;
           x3_decimal, ,  x3_usado, x3_tipo, x3_arquivo, x3_context, x3_F3 } )
    Endif
    dbSkip()
End

//MONTANDO O ACOLS()
If cParam == "I"        
   nPosData := aScan(aHeader,{|aAux| Upper(Alltrim(aAux[2])) == "ZK_DATA"})        
   While dDataAuxi <= dDataFina      
   	If Dow(dDataAuxi) <> 1 .And. ;
   		Dow(dDataAuxi) <> 7
   		Aadd(aCols,Array(Len(aHeader)+1))
	   	For nxI := 1 to Len(aHeader)
   	       aCols[Len(aCols),nPosData] := dDataAuxi
      	Next
	   	aCols[Len(aCols),Len(aHeader)+1] := .F.
      EndIf
      dDataAuxi += 1
   End
   aCols[1][nUsado+1] := .F.
Else
   dbSelectArea("SZK")
   dbSetOrder(1)//SETOR+MES/ANO
   dbSeek(xFilial("SZK")+cCodSet+cMesAtu)

   aCols := {}

   While (! eof())                            .And. ;
         (xFilial("SZK")  == SZK->ZK_Filial)  .And. ;
         (SZK->ZK_CODCONT == cCodSet )			 .And. ;
         (SZK->ZK_MESANO  == cMesAtu )
         
      Aadd(aCols,Array(Len(aHeader)+1))
      For nxI := 1 to Len(aHeader)
         aCols[Len(aCols),nxI] := FieldGet(FieldPos(aHeader[nxI,2]))
      Next
      aCols[Len(aCols),Len(aHeader)+1] := .F.

      dbSelectArea("SZK")
      dbSkip()
   EndDo
EndIf

cTitulo := "Cadastro de Dias Uteis"

aC      := {}

// aC[n,1] = Nome da Variavel Ex.:"cCliente"
// aC[n,2] = Array com coordenadas do Get [x,y], em Windows estao em PIXEL
// aC[n,3] = Titulo do Campo
// aC[n,4] = Picture
// aC[n,5] = Validacao
// aC[n,6] = F3
// aC[n,7] = Se campo e' editavel .t. se nao .f.

AADD(aC,{"cCodSet",{15,010} ,"Setor"  ,"@!",,,.F.})
AADD(aC,{"cMesAtu",{35,010} ,"Mes/Ano","@!",,,.F.})

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

//AADD(aR,{"nVrParAnt",{125,050},"Valor Antigo" ,"@E 999,999.99",,,.F.})
//AADD(aR,{"nValrNego",{125,220},"Novo Valor"   ,"@E 999,999.99",,,.F.})

//旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴커
//� Array com coordenadas da GetDados no modelo2                 �
//읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴켸

aCGD:={60,5,120,315}

cLinhaOk := "ExecBlock('ValidDt',.F.,.F.)"
//cLinhaOk := "AllWaysTrue()"
cTudoOk  := "AllWaysTrue()"

/*
If ! cParam $ "E/V"
	cTudoOk  := "ExecBlock('AgendaOk',.F.,.F.)"
Else
	cTudoOk  := "AllWaysTrue()"
EndIf
*/

lRetMod2 := Modelo2(cTitulo,aC,aR,aCGD,nOpcx,cLinhaOk,cTudoOk)
// No Windows existe a funcao de apoio CallMOd2Obj() que retorna o
// objeto Getdados Corrente

If lRetMod2
   Do Case 
      Case cParam $ "I/A"
           FGravArq()
      Case cParam $ "E"
           FDelete()
   EndCase
EndIf 

Return


Static Function FDelete()
**********************************************************************
* Deleta registros do SZR
*
*****                    

dbSelectArea("SZK")   
dbSetOrder(1)
dbSeek(xFilial("SZK")+cCodSet+cMesAtu)  

While !Eof()                            .And. ;
      SZK->ZK_Filial  == xFilial("SZK") .And. ;
      SZK->ZK_CodCont == cCodSet        .And. ;
      SZK->ZK_MesAno  <= cMesAtu        
            
   RecLock("SZK",.F.)
   dbDelete()
   MsUnLock()
   dbSkip()
EndDo

Return              


Static Function FGravArq()
**********************************************************************
* Input de dados nos arquivos
*
*****

Local nxJ := 0
Local nxI := 0

nPos1 := aScan(aHeader,{|aAux| Upper(Alltrim(aAux[2])) == "ZK_DATA"})

For nxI := 1 To Len(aCols)

	dbSelectArea("SZK")
	dbSetOrder(1)
	dbSeek(xFilial("SZK")+cCodSet+cMesAtu+DTOS(aCols[nxI,nPos1]))
		
	If !aCols[nxI,Len(aHeader)+1]	  
		If RecLock("SZK",Eof())      
     	   For nxJ := 1 To Len(aHeader)
      	   nPos := FieldPos(aHeader[nxJ,2])
         	FieldPut(nPos,aCols[nxI,nxJ])
	      Next
        
   	   Replace ZK_Filial  With xFilial("SZK")
      	Replace ZK_CodCont With cCodSet
	      Replace ZK_MesAno  With cMesAtu
   	   MsUnlock()
	 	EndIf
	Else
   	If !Eof()
      	If RecLock("SZK",.F.)
      		dbDelete()
	      	MsUnlock()
   		EndIf
	   EndIf
	EndIf
Next 

Return