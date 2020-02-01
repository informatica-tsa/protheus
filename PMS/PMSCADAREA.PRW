#Include "Rwmake.ch" 

User Function PMSCADAREA()
/****************************************************************************************************
* Cadastro de Areas e Sub-áreas
*
*******/


cCadastro:="Cadastro Areas / Sub-Areas"
aRotina:={{"Pesquisar" ,"AxPesqui",0,1},;
          {"Visualizar",'U_InputArea',0,2},;
          {"Incluir"   ,'U_InputArea',0,3},;
          {"Alterar"   ,'U_InputArea',0,4},;
          {"Excluir"   ,'U_InputArea',0,5}}

dbSelectArea("ZZ3") 
dbSetOrder(1)       

mBrowse(06,08,22,71,"ZZ3")

Return()


User Function InputArea(cAlias,nRecno,nOpcx)
****************************************************************************************************
* Monta a tela de Manutenção
*
*****

Local cTitulo:="Cadastro de Area / Sub-Area"
Local aC:={}
Local aR:={}
Local nxI := 0

Private aHeader:={}
Private aCols:={}

aCGD:={70,5,250,350}
aCordW:={200,200,400,800}

cLinhaOk := "AllWaysTrue()"
cTudoOk  := "AllWaysTrue()"

AADD(aC,{"M->ZZ3_PROJET" ,{16,010},"Projeto:" ,"@!",'!Empty(M->ZZ3_PROJET) .AND. ExistCpo("AF8")',"AF8",nOpcx==3})
AADD(aC,{"M->ZZ3_AREA"   ,{36,010},"Area..:" ,"@!",'U_ValidArea()' ,"",nOpcx==3})
AADD(aC,{"M->ZZ3_DSAREA" ,{36,150},"Desc. Area.:" ,"@!",'.T.' ,"",nOpcx==3})

dbSelectArea("ZZ3")
RegToMemory("ZZ3",(nOpcx==3))

dbSelectArea("SX3")
dbSeek("ZZ3")
While !Eof() .And. (X3_ARQUIVO == "ZZ3")
	IF X3USO(X3_USADO) .And. cNivel >= x3_nivel .And. Ascan(ac,{|x| Substr(Alltrim(x[1]),4)==Alltrim(X3_CAMPO)})=0

		AADD(aHeader,{ALLTRIM(X3_TITULO),X3_CAMPO,X3_PICTURE,X3_TAMANHO,;
                    X3_DECIMAL,X3_VALID,X3_USADO,X3_TIPO,X3_ARQUIVO})	
	Endif	
	dbSelectArea("SX3")
	dbSkip()
EndDo
dbSelectArea("ZZ3")
dbSetOrder(1)
dbSeek(xFilial("ZZ3")+M->ZZ3_PROJET+M->ZZ3_AREA)
While !Eof() .and. ZZ3->ZZ3_FILIAL== xFilial("ZZ3")  .and. ZZ3->ZZ3_PROJET == M->ZZ3_PROJET .And. ZZ3->ZZ3_AREA==M->ZZ3_AREA
	AADD(aCols,Array(Len(aHeader)+1))
	For nxI := 1 To Len(aHeader)
		aCols[Len(aCols),nxI]:=FieldGet(FieldPos(aHeader[nxI,2]))
	Next nxI
	aCols[Len(aCols),Len(aHeader)+1]:=.F.
	dbSelectArea("ZZ3")
	dbSkip()
EndDo

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
	GravaZZ3(nOpcx)
Endif  

Return()



Static Function GravaZZ3(nOpcx)
****************************************************************************************
* Grava os Dados
*
****
Local nGrvSZT := 0
Local nHead := 0
Local nGrvZZ3 := 0

Private cCampo:=""

dbSelectArea("ZZ3")
dbSetOrder(1)

If nOpcx<>5
	//CQuery:=" DELETE "+RetSqlName("ZZ3")+" Where ZZ3_PROJET='"+M->ZZ3_PROJET+"' AND ZZ3_AREA='"+M->ZZ3_AREA+"'"
	//TcSqlExec(cQuery)
	
	For nGrvZZ3 := 1 To Len(Acols)

		If !GdDeleted(nGrvZZ3)
			dbSelectArea("ZZ3")
			dbSetOrder(1)			
			If Reclock("ZZ3",!dbSeek(Xfilial("ZZ3")+M->ZZ3_PROJET+M->ZZ3_AREA+GdFieldGet("ZZ3_SBAREA",nGrvZZ3)))
				//Grava os campos chaves

				For nHead := 1 To Len(aHeader)
					cCampo:="ZZ3->"+aHeader[nHead,2]
					&cCampo:=GdFieldget(aHeader[nHead,2],nGrvZZ3)
				Next nHead

				Replace  ZZ3_FILIAL With xFilial("ZZ3"),;
				         ZZ3_PROJET With M->ZZ3_PROJET,;
   				   	ZZ3_AREA   With M->ZZ3_AREA,  ;
   				   	ZZ3_DSAREA With M->ZZ3_DSAREA 
			Endif	
			MsUnlock()
		Else 
			If dbSeek(xFilial("ZZ3")+M->ZZ3_PROJET+M->ZZ3_AREA+GdFieldGet("ZZ3_SBAREA",nGrvZZ3))
				Reclock("ZZ3",.F.)
				dbDelete()        
				MsUnlock()
			Endif
		Endif
	Next nGrvZZ3
Else  
	dbSelectArea("ZZ3")
	If dbSeek(Xfilial("ZZ3")+M->ZZ3_PROJET+M->ZZ3_AREA)
		While !Eof() .And. xFilial("ZZ3")==ZZ3->ZZ3_FILIAL .And. M->ZZ3_PROJET=ZZ3->ZZ3_PROJET .And. M->ZZ3_AREA==ZZ3->ZZ3_AREA
			Reclock("ZZ3",.F.)
			dbDelete()
			MsUnlock()
			dbSkip()
		EndDo
	Endif
Endif

Return()


User Function ValidArea()
*****************************************************************************************************************
*
*****

lRet := .T.

dbSelectArea("ZZ3")
If dbSeek(Xfilial("ZZ3")+M->ZZ3_PROJET+M->ZZ3_AREA)
   MsgBox(OemToAnsi("Esta area já se encontra cadastrada para este projeto! " + CHR(13) + "Digite outro código de área ou selecione a opção ALTERAR"),"Atenção","STOP")
   lRet := .F.
EndIf

Return(lRet)