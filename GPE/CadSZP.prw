#Include "Rwmake.ch" 

User Function CadSZP()
/****************************************************************************************************
* Cadastro de vale Refeição
*
*******/
cCadastro:="Cadastro de Vales Refeição"
aRotina:={{"Pesquisar" ,"AxPesqui",0,1},;
          {"Visualizar",'U_MODSZP',0,2},;
          {"Incluir"   ,'U_MODSZP',0,3},;
          {"Alterar"   ,'U_MODSZP',0,4},;
          {"Excluir"   ,'U_MODSZP',0,5}}

dbSelectArea("SZP") 
dbSetOrder(1)       

mBrowse(06,08,22,71,"SZP")

Return()


User Function MODSZP(cAlias,nRecno,nOpcx)
****************************************************************************************************
* Monta a tela de Manutenção
*
*****

Local cTitulo:="Cadastro de Vale Refeição"
Local aC:={}
Local aR:={}
Local nxI := 0

Private aHeader:={}
Private aCols:={}

aCGD:={70,5,250,350}
aCordW:={200,200,400,800}

cLinhaOk := "AllWaysTrue() .And. U_VldInterv()"
cTudoOk  := "AllWaysTrue() .And. U_VldInterv()"
RegToMemory("SZP",nOpcx==3)


AADD(aC,{"M->ZP_CODIGO" ,{16,010},"Codigo.....:"    ,"@!",,,.F.})
AADD(aC,{"M->ZP_DESCRIC",{16,070},"Descrição.....:" ,"@!",'!Empty(M->ZP_DESCRIC)',,.T.})
AADD(aC,{"M->ZP_TIPO"   ,{40,010},"Tipo de VT.:"    ,"@!",'ExistCpo("SX5","Z4"+M->ZP_TIPO)',"Z4",.T.})
AADD(aC,{"M->ZP_VUNIT"  ,{40,070},"Valor Unitário:" ,"@E 99999.99",'M->ZP_VUNIT>0',,.T.})

dbSelectArea("SX3")
dbSeek("SZP")
While !Eof() .And. (X3_ARQUIVO == "SZP")
	IF X3USO(X3_USADO) .And. cNivel >= x3_nivel .And. Ascan(ac,{|x| Substr(Alltrim(x[1]),4)==Alltrim(X3_CAMPO)})=0
		
		AADD(aHeader,{ALLTRIM(X3_TITULO),X3_CAMPO,X3_PICTURE,X3_TAMANHO,;
                    X3_DECIMAL,X3_VALID,X3_USADO,X3_TIPO,X3_ARQUIVO})	
	Endif	
	dbSelectArea("SX3")
	dbSkip()
EndDo
dbSelectArea("SZP")
dbSetOrder(1)
dbSeek(xFilial("SZP")+M->ZP_CODIGO)
While (! Eof()) .and. (SZP->ZP_FILIAL== xFilial("SZP") ) .and. (SZP->ZP_CODIGO == M->ZP_CODIGO)
	AADD(aCols,Array(Len(aHeader)+1))
	For nxI := 1 To Len(aHeader)
		aCols[Len(aCols),nxI]:=FieldGet(FieldPos(aHeader[nxI,2]))
	Next nxI
	aCols[Len(aCols),Len(aHeader)+1]:=.F.
	dbSelectArea("SZP")
	dbSkip()
EndDo
If Len(aCols)<=0
	aCols := {Array(Len(aHeader) + 1)}
	For nxI := 1 to Len(aHeader)
		aCols[1,nxI] := CRIAVAR(aHeader[nxI,2])
	Next
	aCols[1,Len(aHeader)+1] := .F.
Endif   

lRetMod2 := Modelo2(cTitulo,aC,aR,aCGD,nOpcx,cLinhaOk,cTudoOk,,,"M->ZP_ITEM++",,aCordW)
////Modelo2(cTitulo,aC,aR,aCGD,nOpcx,cLineOk,cAllOk,aGetsGD,bF4,cIniCpos,nMax,aCordW,lDelGetD)
If nOpcx=3 .And. lRetMod2
	ConfirmSx8()
Else	 
	RollBackSx8()
Endif
If lRetMod2 .And. nOpcx<>2
	GravaSZP(nOpcx)
Endif  

Return()



Static Function GravaSZP(nOpcx)
****************************************************************************************
* Grava os Dados
*
****

Local nGrvSZp:=0
Local nHead := 0
 
Private cCampo:=""

dbSelectArea("SZP")
dbSetOrder(1)
If nOpcx<>5
	For nGrvSZp:=1 To Len(Acols)
		If !GdDeleted(nGrvSZp)
			dbSelectArea("SZP")
			dbSetOrder(1)			
			If Reclock("SZP",!dbSeek(Xfilial("SZP")+M->ZP_CODIGO+M->ZP_ITEM))
				//Grava os campos chaves
                   Replace  ZP_CODIGO  With M->ZP_CODIGO,;
							ZP_TIPO    With M->ZP_TIPO  ,;
							ZP_DESCRIC With M->ZP_DESCRIC,;
							ZP_VUNIT   With M->ZP_VUNIT 
				For nHead := 1 To Len(aHeader)
					cCampo:="SZP->"+aHeader[nHead,2]
					&cCampo:=GdFieldget(aHeader[nHead,2],nGrvSZp)
				Next nHead
			Endif	
			MsUnlock()
		Else 
			If dbSeek(Xfilial("SZP")+M->ZP_CODIGO+GdFieldGet("ZP_ITEM",nGrvSZp))
				Reclock("SZP",.F.)
				dbDelete()        
				MsUnlock()
			Endif
		Endif
	Next nGrvSZp
Else  
	dbSelectArea("SZP")
	If dbSeek(Xfilial("SZP")+M->ZP_CODIGO)
		While !Eof() .And. Xfilial("SZP")==SZP->ZP_FILIAL .And. M->ZP_CODIGO=SZP->ZP_CODIGO
			Reclock("SZP",.F.)
			dbDelete()
			MsUnlock()
			dbSkip()
		EndDo
	Endif
Endif

Return()



User Function VldInterv()
***********************************************************************************************************************
*
*
****
Local nCont:=1
Local nLinx:=1
Local nValorDe:=0
Local nValorAte:=0
Local lRet:=.T.
/// Valida o Valor de
For nCont:=1 To Len(aCols)
	//Valida a Linha
	If !GdDeleted(nCont)
		nValorDe:=GDFieldGet("ZP_SALDE",nCont)	
		nValorAte:=GDFieldGet("ZP_SALATE",nCont)	
		For nLinx:=nCont To Len(aCols)
			If !GdDeleted(nLinx) .And. nLinx<>nCont
				If	nValorde  >= GDFieldGet("ZP_SALDE" ,nLinx) .Or.;
					nValorAte >= GDFieldGet("ZP_SALATE",nLinx) .Or.;
					nValorAte >= GDFieldGet("ZP_SALDE" ,nLinx)
					lRet:=.F.
				Endif
			Endif
		Next nLinx
	Endif
Next nCont

//Aviso ao usuário
If !lRet
	MsgBox("Erro nos intervalos de faixa salarial",".: ATENCAO :.","STOP")
Endif

Return(lRet)



