#Include "Rwmake.ch"
#Include "TopConn.ch"


User Function GerArqVR()
************************************************************************************************************************
*
*
****
Local aPerg:={}
Local cPerg:="GERVRR"
Local cMens:="Este programa tem como Objetivo gerar o arquivo com os dados necessários para integração com o sistema de transporte CITBus"

AADD(aPerg,{cPerg,"Competencia    ?","C",06,0,"G","","","","","","",""})
AADD(aPerg,{cPerg,"Entrega dos Vales ?","D",08,0,"G","","","","","","",""})
AADD(aPerg,{cPerg,"Emissão da Nota Encomenda?","D",08,0,"G","","","","","","",""})
AADD(aPerg,{cPerg,"Emite Mens Para Desc. Folha?","N",1,0,"C","","","Sim","Não","","",""})
AADD(aPerg,{cPerg,"Cod. P/ VA","C",5,0,"G","","","","","","",""})
AADD(aPerg,{cPerg,"Cod. P/ VR","C",5,0,"G","","","","","","",""})
AADD(aPerg,{cPerg,"Pasta do Arquivo?","C",60,0,"G","!Empty(MV_PAR07)",""   ,"","","","",""})
AADD(aPerg,{cPerg,"Responsável ?","C",30,0,"G","!Empty(MV_PAR08)",""   ,"","","","",""})
AADD(aPerg,{cPerg,"Insc. Municipal?","C",15,0,"G","!Empty(MV_PAR09)",""   ,"","","","",""})
AADD(aPerg,{cPerg,"Filial de  ?"         ,"C",02,0,"G","","SM0","","","","",""})
AADD(aPerg,{cPerg,"Filial Até ?"         ,"C",02,0,"G","","SM0","","","","",""})
AADD(aPerg,{cPerg,"Tipo?"         ,"N",01,0,"C","","","VR","VA","","",""})
AADD(aPerg,{cPerg,"Cod. Empresa VR","C",6,0,"G","","","","","","",""})
AADD(aPerg,{cPerg,"Cod. Empresa VA","C",6,0,"G","","","","","","",""})
AADD(aPerg,{cPerg,"Situação da Folha"    ,"C",05,0,"G","fsituacao","","","","","",""})
AADD(aPerg,{cPerg,"Cod Vale De...?","C",03,0,"G","","","","","","",""})
AADD(aPerg,{cPerg,"Cod Vale Ate..?","C",03,0,"G","","","","","","",""})




Pergunte(cPerg,.F.)

BatchProcess("Gera Arquivo de Vale Refeição",cMens,'GERVRR',{|| Processa({|| GeraVR(.T.)},"Aguarde","Gerando Arquivo")})

Return()



Static function GeraVR()
*********************************************************************************************************************
*
*
******

Local cFile:=""
Local cEol:=Chr(13)+Chr(10)
Local cRegiao:=""
Local cGrupo :=""
Local cCodVale:=""
Local cCompet:=""
Local dDtEntr:=""
Local dDtEmissNE:=""
Local cMensFol  :=""
Local cCodEPC:=""
Local cCodVA :=""
Local cCodVR :=""
Local cDirFile:=""
Local cCodMat:="" 
Local aRegHomon:={}
Local cTxtHom:=""
Local aListCC:={}
Local aTpVlrTot:={}
Local aTpVlr:={}
Local nVlrTotal:=0
Local nTotItens:=0
Local nLin := 0
Local nXi := 0

//Grava osRegistros de Homonimos

Pergunte("GERVRR",.F.)

cCompet:=MV_PAR01
dDtEntr:=MV_PAR02
dDtEmissNE:=MV_PAR03
cMensFol  :=If(MV_PAR04==1,"S","N")
cCodVA    :=MV_PAR05
cCodVR    :=MV_PAR06
cDirFile  :=MV_PAR07
cResp     :=MV_PAR08
cInscMun  :=MV_PAR09
cFilDe    :=MV_PAR10
cFilAte   :=MV_PAR11
cTipoVL   :=If(MV_PAR12=1,'VR','VA')
cCodEPC   :=If(MV_PAR12=1,MV_PAR13,MV_PAR14)
cSitFol   :=MV_PAR15
cCodDe   :=MV_PAR16
cCodAte  :=MV_PAR17

cFileC :=Alltrim(MV_PAR07)+'\'+If(cEmpAnt=='01','EPC','TSA')+cTipoVL+Left(Dtos(dDataBase),6)+'.TXT'
If File(cFileC)
	If !Msgbox("Atenção, Este arquivo já Existe Deseja Substituílo?","ATENCAO","YESNO")
		Return()
	Endif
Endif
nFileC:=FCreate(cFileC,1)
If nFileC < 0 
	Msgbox("Erro ao Criar o Arquivo, Verifique se o Caminho foi digitado corretamente","ERRO")
	Return()
Endif
// Montando os locais do Arquivo
//Local de entrega
cLoc1:=""
dbSelectArea("SM0")
dbseek(cEmpAnt) 
cLoc1:="3"
cLoc1+=Replicate("0",8)+SM0->M0_CODIGO //Nome do Local
cLoc1+=Padr(Left(SM0->M0_NOME,40),40) //Nome do Local
cLoc1+=Padr(Left(SM0->M0_ENDCOB,35),35) // Logradouro
cLoc1+=Padr(Left(AllTrim(SM0->M0_COMPENT),5),5) //Numero
cLoc1+=Space(12)  //Complemento de Endereço
cLoc1+=Padr(Left(M0_BAIRCOB,20),20) //Bairro
cLoc1+=SM0->M0_CEPCOB  //CEP
cLoc1+=SM0->M0_ESTCOB  //ESTADO
cLoc1+=Padr(Left(cResp,30),30)
cLoc1+=SM0->M0_CGC
cLoc1+=Padr(Left(SM0->M0_INSC,15),15)
cLoc1+=Padr(Left(cInscMun,15),15)
//Registro 0
cTexto:="0"
cTexto+="01"
cTexto+=Replicate("0",6)
cTexto+='0'
cTexto+=SubStr(cCompet,3)
cTexto+=SubStr(Dtos(dDtEntr),3)
cTexto+="2"
cTexto+=SubStr(Dtos(dDatabase),3)
cTexto+='0001'
cTexto+=cMensFol
cTexto+=cCodEPC
cTexto+=Replicate("0",8)+cEmpAnt //Local de Entrega
cTexto+=Replicate("0",8)+cEmpAnt //Local Fiscal
cTexto+=Replicate("0",8)+cEmpAnt //Local Cobrança
cTexto+=Replicate("0",8)+cEmpAnt //Local Entrega da Fatura
cTexto+='1'
cTexto+=SubStr(Dtos(LastDay(Stod(cCompet+'01'))),3)
cTexto+=SubStr(Dtos(FirstDay(Stod(cCompet+'01'))),3)
                      
//Grava o registro
Fwrite(nFileC,cTexto+cEol)

dbSelectArea("SM0")
dbSeek(cEmpAnt+If(Empty(cFilDe),'',cFilDe))
While !Eof() .And. SM0->M0_CODIGO==cEmpAnt .And. SM0->M0_CODFIL<=cFilAte
	cFilAnt:=SM0->M0_CODFIL
	cTexto:=""
	
	dbSelectArea("SRA")
	dbSetOrder(1)
	dbSeek(Xfilial("SRA"))
	While !Eof() .And. RA_FILIAL==Xfilial("SRA")  
		If !SRA->RA_SITFOLH$cSitFol .Or. !Empty(SRA->RA_DEMISSA)
			dbSelectArea("SRA")
			dbSkip()
			Loop
		Endif
		cCodMat:=Padr(SubStr(SRA->RA_MAT,2),10)
		aTpVlr:={}
		dbSelectArea("SZQ")
		If dbSeek(xfilial("SZQ")+SRA->RA_MAT)
			While !Eof() .And. ZQ_FILIAL==Xfilial("SZQ") .And. ZQ_MAT==SRA->RA_MAT
				cCodVale:=Posicione("SZP",1,Xfilial("SZP")+SZQ->ZQ_CODVALE,"ZP_TIPO")
				If cCodVale==cTipoVL .And. SZQ->(ZQ_CUSEMP+ZQ_CUSFUN)>0 .And. SZQ->ZQ_CODVALE>=cCodDe .And. SZQ->ZQ_CODVALE<=cCodAte
					cCodVale:=If(cCodVale=='VA',cCodVA,cCodVR)
					nPos:=Ascan(aTpVlr,{|x| x[1]==cCodVale})
					If nPos==0
						Aadd(aTpVlr,{cCodVale,0,0})
						nPos:=Len(aTpVlr)
					Endif
					aTpVlr[nPos,2]+=SZQ->(ZQ_CUSEMP+ZQ_CUSFUN)
				Endif
				dbSelectArea("SZQ")
				dbSkip()
			EndDo
			If Len(aTpVlr)>=1
				//Gravação do Registro 1
				cTexto:="1"
				cTexto+=Padr(Left(SRA->RA_CC,10),10)
				cTexto+=cCodMat
				cTexto+=' '+Padr(Left(SRA->RA_NOME,29),29)
				cTexto+=cMensFol
				For nLin := 1 To Len(aTpVlr)
					cTexto+=aTpVlr[nLin,1]
					cTexto+="000001"
					cTexto+=StrZero((aTpVlr[nLin,2]*100),11)
					nVlrTotal+=aTpVlr[nLin,2]
					nTotItens++
					//Faz a Soma dos Itens Por Valor de tarifa
					cTarifa:=StrZero((aTpVlr[nLin,2]*100),11)
					nPosTot:=Ascan(aTpVlrTot,{|x| x[1]==cTarifa})
					If nPosTot==0
						Aadd(aTpVlrTot,{cTarifa,0,0})
						nPosTot:=Len(aTpVlrTot)					
					Endif
					aTpVlrTot[nPosTot,2]+=aTpVlr[nLin,2]
					aTpVlrTot[nPosTot,3]++
				Next nLin
				//Gera os demais 12 Itens
				For nLin:=Len(aTpVlr)+1 To 12
					cTexto+=Replicate('0',5)
					cTexto+=Replicate('0',6)
					cTexto+=Replicate('0',11)
				Next nLin
				//Campos para demitidos
				For nXi := 1 To 4
					cTexto+='00 '
				Next nXi
				//Grava o registro
				Fwrite(nFileC,cTexto+cEol)
				
				//Cria o Array com os Centros de Custos Utilizados
				nPos:=Ascan(aListCC,{|x| x[1]==SRA->RA_CC})
				If nPos==0
					Aadd(aListCC,{SRA->RA_CC,Left(Posicione("CTT",1,Xfilial("CTT")+SRA->RA_CC,"CTT_DESC01"),10)})
				Endif
				cTxtHom:="6"
				cTxtHom+=cCodMat
				cTxtHom+=Padr(Left(SRA->RA_ENDEREC,35),35)
				cTxtHom+="00000"
				cTxtHom+=Padr(Left(SRA->RA_COMPLEM,12),12)
				cTxtHom+=Padr(Left(SRA->RA_MUNICIP,20),20)
				cTxtHom+=SRA->RA_CEP
				cTxtHom+=SRA->RA_ESTADO
				cTxtHom+=Padr(Left(SRA->RA_TELEFON,11),11)
				cTxtHom+=Space(8)
				cTxtHom+=Dtos(SRA->RA_NASC)
				cTxtHom+=Padr(Left(Alltrim(SRA->RA_RG),15),15)
				cTxtHom+=Padr(Left(SRA->RA_CIC,11),11)
				cTxtHom+= Padr(Left(SRA->RA_PAI,30),30)  //Nome do Pai c 30
				cTxtHom+= Padr(Left(SRA->RA_MAE,30),30)  //Nome da Mãe c 30
				cTxtHom+= Padr(SRA->RA_CIC,11) // PIS C 11
				cTxtHom+= SRA->RA_SEXO                          // Sexo C 1
				cTxtHom+= SRA->RA_ESTRG                         // UF Emissão RG c 2
				cTxtHom+= Padr(Left(SRA->RA_EMAIL,25),25)       // e-mail C 25
				cTxtHom+= Padr(Left(Alltrim(SRA->RA_RGORG),5),5)//Orgão Emissor RG C 5
				cTxtHom+= Dtos(SRA->RA_DATARG)                  //Data Emissão RG n 8
				cTxtHom+= Padr(Left(SRA->RA_BAIRRO,20),20)      //Bairro c 20
				cTxtHom+='00' //Qtd Viagens Dia(Somente vt)
				cTxtHom+='00' //Qtd Viagens Dia(Somente vt)
				cTxtHom+='00' //Qtd Viagens Dia(Somente vt)
				cTxtHom+='00' //Qtd Viagens Dia(Somente vt)
				
				Aadd(aRegHomon,cTxtHom)
			Endif	
			dbSelectArea("SRA")
		Endif
		dbSelectArea("SRA")	
		dbSkip()
	EndDo
	dbSelectArea("SM0")
	dbSkip()
EndDo

//Registro 2

For nXi:=1 To Len(aTpVlrTot)
	cTexto:='2'
	cTexto+=If(cTipoVL=='VA',cCodVA,cCodVR)
	cTexto+=StrZero(aTpVlrTot[nXi,3],7)
	cTexto+=aTpVlrTot[nXi,1]
	cTexto+='0'
	cTexto+=aTpVlrTot[nXi,1]
	FWrite(nFileC,cTexto+cEol)
Next nXi



//Registro 3
FWrite(nFileC,cLoc1+cEol)

// Grava o Registro 4
For nLin:=1 to Len(aListCC)
	FWrite(nFileC,'4'+Padr(Left(aListCC[nLin,1],10),10)+Padr(Left(aListCC[nLin,2],10),10)+cEol)
Next nLin
//Grava os Registro de detalhamento dos Funcionários
For nLin:=1 to Len(aRegHomon)
	FWrite(nFileC,aRegHomon[nLin]+cEol)
Next nLin

//Registro 9 - Totalizador
cTexto:="9" //
cTexto+=StrZero(nTotItens,10)
cTexto+=Replicate('0',14)
cTexto+=Replicate('0',4)
cTexto+=StrZero(nVlrtotal*100,14)
cTexto+=StrZero((nVlrtotal*0.015)*100,14)
FWrite(nFileC,cTexto+cEol)

Fclose(nFileC)

If File(cFileC)
	nVlrtotal:=0
	cMens:=" Arquivo: "+cFileC+", Criado com sucesso!!!"+cEol
	
	For nXi:=1 To Len(aTpVlrTot)
		///cMens+="  Total "+aTpVlrTot[nXi,1]+":"+Alltrim(Str(aTpVlrTot[nXi,2],12,2))+cEol
		nVlrtotal+=aTpVlrTot[nXi,2]
	Next nXi 
	cMens+="  Valor Total:"+Alltrim(Str(nVlrtotal,12,2))
	Msgbox(cMens,"ATENÇÃO")	
Endif

Return()
