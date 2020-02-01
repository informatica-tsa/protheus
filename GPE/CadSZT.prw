#Include "Rwmake.ch" 

User Function CadSZT()
/****************************************************************************************************
* Cadastro de 
*
*******/
cCadastro:="Cadastro Plano"
aRotina:={{"Pesquisar" ,"AxPesqui",0,1},;
          {"Visualizar",'U_MODSZT',0,2},;
          {"Incluir"   ,'U_MODSZT',0,3},;
          {"Alterar"   ,'U_MODSZT',0,4},;
          {"Excluir"   ,'U_MODSZT',0,5}}

dbSelectArea("SZT") 
dbSetOrder(1)       

mBrowse(06,08,22,71,"SZT")

Return()


User Function MODSZT(cAlias,nRecno,nOpcx)
****************************************************************************************************
* Monta a tela de Manutenção
*
*****
Local cTitulo:="Regra de Plano P/ C.Custo"
Local aC:={}
Local aR:={}
Local nxI := 0
 
Private aHeader:={}
Private aCols:={}

aCGD:={70,5,250,350}
aCordW:={200,200,400,800}

cLinhaOk := "AllWaysTrue()"
cTudoOk  := "AllWaysTrue()"

AADD(aC,{"M->ZT_CCUSTO" ,{16,010},"C.Custo.:" ,"@!",'!Empty(M->ZT_CCUSTO) .AND. ExistCpo("CTT")',"CTT",nOpcx==3})
AADD(aC,{"M->ZT_PLANO"  ,{16,100},"Plano...:" ,"@!",'Vazio() .or. ExistCpo("SZR")',"Z3",nOpcx==3})

dbSelectArea("SZT")
RegToMemory("SZT",(nOpcx==3))

dbSelectArea("SX3")
dbSeek("SZT")
While !Eof() .And. (X3_ARQUIVO == "SZT")
	IF X3USO(X3_USADO) .And. cNivel >= x3_nivel .And. Ascan(ac,{|x| Substr(Alltrim(x[1]),4)==Alltrim(X3_CAMPO)})=0

		AADD(aHeader,{ALLTRIM(X3_TITULO),X3_CAMPO,X3_PICTURE,X3_TAMANHO,;
                    X3_DECIMAL,X3_VALID,X3_USADO,X3_TIPO,X3_ARQUIVO})	
	Endif	
	dbSelectArea("SX3")
	dbSkip()
EndDo
dbSelectArea("SZT")
dbSetOrder(1)
dbSeek(xFilial("SZT")+M->ZT_CCUSTO+M->ZT_PLANO)
While !Eof() .and. SZT->ZT_FILIAL== xFilial("SZT")  .and. SZT->ZT_CCUSTO == M->ZT_CCUSTO .And. SZT->ZT_PLANO==M->ZT_PLANO
	AADD(aCols,Array(Len(aHeader)+1))
	For nxI := 1 To Len(aHeader)
		aCols[Len(aCols),nxI]:=FieldGet(FieldPos(aHeader[nxI,2]))
	Next nxI
	aCols[Len(aCols),Len(aHeader)+1]:=.F.
	dbSelectArea("SZT")
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
	GravaSZT(nOpcx)
Endif  

Return()



Static Function GravaSZT(nOpcx)
****************************************************************************************
* Grava os Dados
*
****

Local nGrvSZT:=0
Local nHead := 0

Private cCampo:=""
dbSelectArea("SZT")
dbSetOrder(1)
If nOpcx<>5
	cQuery:=" DELETE "+RetSqlName("SZT")+" Where ZT_CCUSTO='"+M->ZT_CCUSTO+"' AND ZT_PLANO='"+M->ZT_PLANO+"'"
	TcSqlExec(cQuery)
	
	For nGrvSZT:=1 To Len(Acols)
		If !GdDeleted(nGrvSZT)
			dbSelectArea("SZT")
			dbSetOrder(1)		 
			Reclock("SZT",.T.)	
			//If Reclock("SZT",!dbSeek(Xfilial("SZT")+M->ZT_CCUSTO+M->ZT_PLANO+GdFieldGet("ZT_TIPOD",nGrvSZT)))
				//Grava os campos chaves
				For nHead := 1 To Len(aHeader)
					cCampo:="SZT->"+aHeader[nHead,2]
					&cCampo:=GdFieldget(aHeader[nHead,2],nGrvSZT)
				Next nHead
				Replace  ZT_CCUSTO With M->ZT_CCUSTO,;
   				   	 ZT_PLANO  With M->ZT_PLANO  
			//Endif	
			MsUnlock()
		Else 
			If dbSeek(Xfilial("SZT")+M->ZT_CCUSTO+M->ZT_PLANO+GdFieldGet("ZT_TIPOD",nGrvSZT))
				Reclock("SZT",.F.)
				dbDelete()        
				MsUnlock()
			Endif
		Endif
	Next nGrvSZT
Else  
	dbSelectArea("SZT")
	If dbSeek(Xfilial("SZT")+M->ZT_CCUSTO+M->ZT_PLANO)
		While !Eof() .And. Xfilial("SZT")==SZT->ZT_FILIAL .And. M->ZT_CCUSTO=SZT->ZT_CCUSTO .And. M->ZT_PLANO==SZT->ZT_PLANO
			Reclock("SZT",.F.)
			dbDelete()
			MsUnlock()
			dbSkip()
		EndDo
	Endif
Endif

Return()