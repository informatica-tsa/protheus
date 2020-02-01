#Include "Rwmake.ch"

User Function GerArqVT()
************************************************************************************************************************
*
*
****
Local aPerg:={}
Local cPerg:="GERVTR"
Local cMens:="Este programa tem como Objetivo gerar o arquivo com os dados necessários para integração com o sistema de transporte CITBus"

AADD(aPerg,{cPerg,"Matricula de    ?","C",06,0,"G","","SRA","","","","",""})
AADD(aPerg,{cPerg,"matricula Ate   ?","C",06,0,"G","","SRA","","","","",""})
AADD(aPerg,{cPerg,"Pasta do Arquivo?","C",60,0,"G","!Empty(MV_PAR03)",""   ,"","","","",""})
AADD(aPerg,{cPerg,"Região   ?"      ,"C",2,0 ,"G","","","","","","",""})



Pergunte(cPerg,.F.)

BatchProcess("Gera Arquivo de Vale Transporte",cMens,'GERVTR',{|| Processa({|| GeraVT(.T.)},"Aguarde","Gerando Arquivo")})

Return()



Static function GeraVT()
*********************************************************************************************************************
*
*
******

Local cMatDe:=""
Local cMatAte:=""
Local cFile:=""
Local cEol:=Chr(13)+Chr(10)
Local cRegiao:=""
Local cGrupo :=""
Local nXi := 0

Pergunte("GERVTR",.F.)

cMatDe :=MV_PAR01
cMatAte:=MV_PAR02
cFileC :=Alltrim(MV_PAR03)+"VTC"+Left(Dtos(dDataBase),6)+'.TXT'
cFileI :=AllTrim(MV_PAR03)+"VTI"+Left(Dtos(dDataBase),6)+'.TXT'
cRegiao:=MV_PAR04
cGrupo :=""
If File(cFileC)
	If !Msgbox("Atenção, Este arquivo já Existe Deseja Substituílo?","ATENCAO","YESNO")
		Return()
	Endif
Endif
nFileC:=FCreate(cFileC,1)
nFileI:=FCreate(cFileI,1)
If nFileC < 0 .Or. nFileI < 0
	Msgbox("Erro ao Criar o Arquivo, Verifique se o Caminho foi digitado corretamente","ERRO")
	Return()
Endif

dbSelectArea("SRA")
ProcRegua(RecCount())

dbSeek(Xfilial("SRA")+If(Empty(cMatDe),"",cMatDe))
While !Eof() .And. RA_MAT<=cMatAte
	IncProc("Funcionário:"+SRA->RA_MAT)
	cText01:=""
	cText02:=""
	nItens:=0
	If Empty(RA_DEMISSA) .Or. Month(RA_DEMISSA) >= Month(dDatabase)
		dbSelectArea("SR0") 
		dbSeek(Xfilial("SR0")+SRA->RA_MAT)
		While !Eof() .And. R0_MAT==SRA->RA_MAT
			dbSelectArea("SRN")	
			If SR0->R0_QDIACAL>0 .And. dbSeek(Xfilial("SRN")+SR0->R0_MEIO) .And. !Empty(SR0->R0_NUMCART) .And. Alltrim(SRN->RN_REGIAO)==Alltrim(cRegiao)				
				nItens++
				cGrupo:=StrZero((SR0->R0_QDIACAL/SR0->R0_QDIAINF),2)	
				cText01+=SRN->RN_CODTAR+StrZero(SRN->RN_VUNIATU,2)
				cText02+=PADR(SubsTr(SRA->RA_MAT,2),15," ")+cGrupo
				Fwrite(nFileI,cText02+cEol)
				cText02:=""
			Endif
			dbSelectArea("SR0")
			dbSkip()
		EndDo
	Endif	
	If nItens==0
		dbSelectArea("SRA")
		dbSkip()
		Loop
	Endif
	For nXi := nItens To 4
		cText01+=" 00"
	Next nXi
	Set Cent On
	dbSelectArea("SRA")
	cCargo:=Posicione("SRJ",1,Xfilial("SRJ")+SRA->RA_CODFUNC,"RJ_DESC")
	cSetorF:=Posicione("CTT",1,Xfilial("CTT")+SRA->RA_CC,"CTT_DESC01")
	cTexto:=PADR(Left(SRA->RA_NOME,50),50," ") //Nome
	cTexto+=PADR(SubsTr(SRA->RA_MAT,2),15," ")           //Matricula
	cTexto+=PADR(cCargo,50," ")
	cTexto+=Dtoc(SRA->RA_ADMISSA)
	cTexto+=Padr(Left(SRA->RA_ENDEREC,60),60," ")
	cTexto+=Padr(Left(SRA->RA_BAIRRO,40),40," ")
	cTexto+=Padr(Left(SRA->RA_MUNICIP,50),50," ")
	cTexto+=Padr(Left(SRA->RA_CEP,8),8," ")
	cTexto+=Padr(Left(SRA->RA_TELEFON,15),15," ")
	cTexto+=Padr(Left(cSetorF,50),50," ")
	cTexto+=cGrupo+cText01
	cTexto+=Dtoc(SRA->RA_DEMISSA)
	Fwrite(nFileC,cTexto+cEol)
	Set Cent OFF
	dbSelectArea("SRA")
	dbSkip()
EndDo
Fclose(nFileC)
Fclose(nFileI)

If File(cFileC)
	Msgbox("Arquivo: "+cFileC+", Criado com sucesso!!!","ATENÇÃO")	
Endif

Return()
