#Include "Rwmake.ch"  

User Function CadSZZJ()
/****************************************************************************************************
* Cadastro de 
*
*******/
cCadastro:="Cadastro Plano"
aRotina:= {{"Pesquisar" ,'AxPesqui',0,1},;
          {"Visualizar" ,'U_MODSZZ',0,2},;
          {"Incluir"    ,'U_MODSZZ',0,3},;
          {"Alterar"    ,'U_MODSZZ',0,4},;
          {"Excluir"    ,'U_MODSZZ',0,5}}

dbSelectArea("SZZ") 
dbSetOrder(1)       

mBrowse(06,08,22,71,"SZZ")

Return()


User Function MODSZZ(cAlias,nRecno,nOpcx)
****************************************************************************************************
* Monta a tela de Manutenção
*
*****

Local cTitulo:="Consulta Medição"
Local aR:={}
Local aC:={}
Local nxI := 0

Private aHeader:={}
Private aCols:={} 
Private acont:={}
Private nValRec:=0
 
aCGD:={44,5,118,315}
//aCGD:={70,5,250,350}
aCordW:={200,200,400,800}

cLinhaOk := "AllWaysTrue()"
cTudoOk  := "AllWaysTrue()"

AADD(aC,{"M->ZZ_PERIODO " ,{16,010},"Periodo.:"     ,,,,nOpcx==3})
AADD(aC,{"M->ZZ_MAT     " ,{16,100},"Matricula...:" ,,,,nOpcx==3})
AADD(aC,{"M->ZZ_PEDIDO  " ,{36,010},"Pedido..:"     ,,,,nOpcx==3})

dbSelectArea("SZZ")
RegToMemory("SZZ",(nOpcx==3))

dbSelectArea("SX3")
dbSeek("SZZ")
While !Eof() .And. (X3_ARQUIVO == "SZZ")
	IF X3USO(X3_USADO) .And. cNivel >= x3_nivel .And. Ascan(ac,{|x| Substr(Alltrim(x[1]),4)==Alltrim(X3_CAMPO)})=0

		AADD(aHeader,{ALLTRIM(X3_TITULO),X3_CAMPO,X3_PICTURE,X3_TAMANHO,;
                    X3_DECIMAL,X3_VALID,X3_USADO,X3_TIPO,X3_ARQUIVO,X3_CONTEXT	})	
	Endif	
	dbSelectArea("SX3")
	dbSkip()
EndDo 

//
dbSelectArea("SZZ")
dbSetOrder(1)
dbSeek(xFilial("SZZ")+M->ZZ_PERIODO+M->ZZ_MAT)
While !Eof() .and. SZZ->ZZ_FILIAL== xFilial("SZZ")  .and. SZZ->ZZ_MAT == M->ZZ_MAT .And. SZZ->ZZ_PERIODO=M->ZZ_PERIODO
	AADD(aCols,Array(Len(aHeader)+1))
	For nxI := 1 To Len(aHeader)
		aCols[Len(aCols),nxI]:=FieldGet(FieldPos(aHeader[nxI,2])) 
		nValRec:=(aCols[Len(aCols),nxI])	
	  	If(nxI == 3)
			nValRec:=nValRec+(aCols[Len(aCols),nxI])	
		EndIf	
	Next nxI
	aCols[Len(aCols),Len(aHeader)+1]:=.F.
	dbSelectArea("SZZ")
	dbSkip()
EndDo


//AADD(aR,{"nValRec"    ,{90,10},      ,"@E 999,999,999.99",,,nOpcx==3})
  

If Len(aCols)<=0
	aCols := {Array(Len(aHeader) + 1)}
	For nxI := 1 to Len(aHeader)
		aCols[1,nxI] := CRIAVAR(aHeader[nxI,2])
		
	Next
	aCols[1,Len(aHeader)+1] := .F.
Endif   



lRetMod2 := Modelo2(cTitulo,aC,aR,aCGD,nOpcx,cLinhaOk,cTudoOk,,,,,aCordW)

If nOpcx=3 .And. lRetMod2
	ConfirmSx8()
Else	 
	RollBackSx8()
Endif
If lRetMod2 .And. nOpcx<>2
	GravaSZZ(nOpcx)
Endif  

Return()



Static Function GravaSZZ(nOpcx)
****************************************************************************************
* Grava os Dados
*
****

Local nHead := 0
Local nGrvZZZ := 0
 
//Local nGrvSZZ:=0
Private cCampo:=""
dbSelectArea("SZZ")
dbSetOrder(1)

If nOpcx<>5
	
	For nGrvZZZ := 1 To Len(Acols)
		If !GdDeleted(nGrvZZZ)
			dbSelectArea("SZZ")
			dbSetOrder(1)			
			If Reclock("SZZ",!dbSeek(Xfilial("SZZ")+M->ZZ_PERIODO+M->ZZ_MAT))//+GdFieldGet("ZZ3_SBAREA",nGrvZZ3)))
				//Grava os campos chaves
				For nHead := 1 To Len(aHeader)
					cCampo:="SZZ->"+aHeader[nHead,2]
					&cCampo:=GdFieldget(aHeader[nHead,2],nGrvZZZ)
				Next nHead
				Replace  ZZ_FILIAL  With xFilial("SZZ"),;
				         ZZ_PERIODO With M->ZZ_PERIODO,;
				         ZZ_MAT     With M->ZZ_MAT,;
				         ZZ_FPCUSTO With M->ZZ_FPCUSTO,;
   				   	ZZ_QHORAS  With M->ZZ_QHORAS,  ;
				         ZZ_VALOR   With M->ZZ_VALOR,;
				         ZZ_MATLIB  With M->ZZ_MATLIB,;
				         ZZ_DTLIB   With M->ZZ_DTLIB
			Endif	
			MsUnlock()
		Else 
			If dbSeek(xFilial("SZZ")+M->ZZ_PERIODO+M->ZZ_MAT+GdFieldGet("ZZ_FIPCUSTO",nGrvZZZ))
				Reclock("SZZ",.F.)
				dbDelete()        
				MsUnlock()
			Endif
		Endif
	Next nGrvZZZ
Else  
	dbSelectArea("SZZ")
	If dbSeek(Xfilial("SZZ")+M->ZZ_PERIODO+M->ZZ_MAT)
		While !Eof() .And. xFilial("SZZ")==SZZ->ZZ_FILIAL .And. M->ZZ_PERIODO=SZZ->ZZ_PERIODO .And. M->ZZ_MAT==SZZ->ZZ_MAT
			Reclock("SZZ",.F.)
			dbDelete()
			MsUnlock()
			dbSkip()
		EndDo
	Endif
Endif

Return()