//PROGRAMA PARA CRIACAO DO ITEM CONTABIL - CRISLEI TOLEDO 15/02/06

#include "rwmake.ch"
#include "topconn.ch"
#include "TbiConn.ch"
#include "Ap5mail.ch"

User Function EPCCTB01()

Local aArrEmpr := {"01","02"}
Local nxI := 0
 
For nxI := 1 To Len(aArrEmpr)

   PREPARE ENVIRONMENT EMPRESA aArrEmpr[nxI] FILIAL "01" TABLES "CTD","SA2","SZ1","SZ2"
     
   // cCabecalho := OemToAnsi("Atualização do Item Contabil - Fornecedores")
   // cMsgRegua  := "Processando..."
   // Processa( {|| PrcCtb01()} ,cCabecalho,cMsgRegua )

   PrcCtb01()
 
   // cCabecalho := OemToAnsi("Atualização do Item Contabil - Contratos Clientes")
   // cMsgRegua  := "Processando..."
   //Processa( {|| PrcCtb02()} ,cCabecalho,cMsgRegua )

   PrcCtb02()
 
   //cCabecalho := OemToAnsi("Atualização do Item Contabil - Municipios")
   //cMsgRegua  := "Processando..."
   //Processa( {|| PrcCtb03()} ,cCabecalho,cMsgRegua )

   PrcCtb03()

	If cEmpAnt=='01'
		//Envia um e-mail com as contas sem Cadastro de Produtos
		U_ItemSemProd()
	End
     
   RESET ENVIRONMENT

Next nxI
 
Return

 
 
 Static Function PrcCtb01()
 *****************************************************************************************************
 *
 *
 ****
 
 Local cItemCont := ""
   
dbSelectArea("SA2")
dbGoTop()

While !Eof()
   
   dbSelectArea("CTD")
   dbSetOrder(1)
   dbSeek(xFilial("CTD")+SA2->A2_COD+SA2->A2_LOJA)
   
   If Eof()
      cItemCont := SA2->A2_COD+SA2->A2_LOJA
      RecLock("CTD",.T.)
      Replace CTD_FILIAL With xFilial("CTD") , ;
              CTD_ITEM   With cItemcont      , ; 
              CTD_DESC01 With SA2->A2_NOME   , ;
              CTD_CLASSE With "2"            , ; 
              CTD_TIPOIT With "F"            , ;
              CTD_DTEXIS With CTOD("01/01/1980") , ;
              CTD_BLOQ   With '2'                , ;
              CTD_SITUAC With "0"
            
      MsUnlock("CTD")
   EndIf
   dbSelectArea("SA2")
   dbSkip()
End

Return


 Static Function PrcCtb02()
 *****************************************************************************************************
 * Criacao do Item Contabil para Contratos - Clientes
 *
 ****

dbSelectArea("SZ1")
dbSetOrder(1)
dbGoTop()

While !Eof()
     
   //Inclusao do Item Contabil para Cliente -- CRISLEI TOLEDO 16/02/06
   dbSelectArea("CTD") // Item Contabil
   dbSetOrder(1)
   dbSeek(xFilial("CTD")+"C"+SZ1->Z1_CODCLI+SZ1->Z1_LOJA)
   If Eof()
      RecLock("CTD",.T.)
      Replace CTD_FILIAL With xFilial("CTD") , ;
              CTD_ITEM   With "C" + SZ1->Z1_CODCLI + SZ1->Z1_LOJA , ; 
              CTD_DESC01 With SZ1->Z1_CLIENTE , ;
              CTD_CLASSE With "1"            , ; 
              CTD_TIPOIT With "C"            , ;
              CTD_DTEXIS With CTOD("01/01/1980") , ;
              CTD_BLOQ   With "2"                , ;
              CTD_SITUAC With "0"
      MsUnlock()
   EndIf

   //Inclusao do Item Contabil para Contrato -- CRISLEI TOLEDO 16/02/06
   dbSelectArea("CTD") // Item Contabil
   dbSetOrder(1)
   dbSeek(xFilial("CTD")+"C"+SZ1->Z1_CODCLI+SZ1->Z1_LOJA+SZ1->Z1_COD)
   If Eof()
      RecLock("CTD",.T.)
      Replace CTD_FILIAL With xFilial("CTD") , ;
              CTD_ITEM   With "C" + SZ1->Z1_CODCLI + SZ1->Z1_LOJA + SZ1->Z1_COD , ; 
              CTD_DESC01 With SZ1->Z1_NOME , ;
              CTD_CLASSE With "2"            , ; 
              CTD_TIPOIT With "C"            , ;
              CTD_DTEXIS With CTOD("01/01/1980") , ;
              CTD_BLOQ   With "2"                , ;
              CTD_ITSUP  With "C" + SZ1->Z1_CODCLI + SZ1->Z1_LOJA , ;
              CTD_SITUAC With "0"
      MsUnlock()
   EndIf

   dbSelectArea("SZ2")
   dbSetOrder(1)
   dbSeek(xFilial("SZ2")+SZ1->Z1_COD)
   
   While !Eof()                .And. ;
         Z2_COD = SZ1->Z1_COD
         
      //Inclusao do Item Contabil para SubConta -- CRISLEI TOLEDO 16/02/06
      dbSelectArea("CTD") // Item Contabil
      dbSetOrder(1)
      dbSeek(xFilial("CTD")+SZ2->Z2_SUBC)
      If Eof()
         RecLock("CTD",.T.)
         Replace CTD_FILIAL With xFilial("CTD") , ;
                 CTD_ITEM   With SZ2->Z2_SUBC   , ; 
                 CTD_DESC01 With SZ2->Z2_DESC   , ;
                 CTD_CLASSE With "2"            , ; 
                 CTD_TIPOIT With "S"            , ;
                 CTD_DTEXIS With CTOD("01/01/1980") , ;
                 CTD_BLOQ   With '2'                , ;
                 CTD_SITUAC With "0"
         MsUnlock()
      EndIf
      dbSelectArea("SZ2")
      dbSkip()
   End
   dbSelectArea("SZ1")
   dbSkip()
End  



Return


 Static Function PrcCtb03()
 *****************************************************************************************************
 *
 *
 ****
 
 Local cItemCont := ""
   
dbSelectArea("CT1")
dbSEtOrder(1)
dbSeek(xFilial("CT1")+'21230002')

While CT1->CT1_CONTA <= '21238000'
   
   dbSelectArea("CTD")
   dbSetOrder(1)
   dbSeek(xFilial("CTD")+CT1->CT1_CONTA)
   
   If Eof()
      cItemCont := CT1->CT1_CONTA
      RecLock("CTD",.T.)
      Replace CTD_FILIAL With xFilial("CTD") , ;
              CTD_ITEM   With cItemcont      , ; 
              CTD_DESC01 With CT1->CT1_DESC01 , ;
              CTD_CLASSE With "2"            , ; 
              CTD_TIPOIT With "M"            , ;
              CTD_DTEXIS With CTOD("01/01/1980") , ;
              CTD_BLOQ   With '2'                , ;
              CTD_SITUAC With "0"
            
      MsUnlock("CTD")
   EndIf
   dbSelectArea("CT1")
   dbSkip()
End

Return


User Function ItemSemProd()
*******************************************************************************************************************
*
*
******
Local cAccount  := GetMv("MV_WFACC") 
Local cCtaPass  := GetMv("MV_WFPASSW")
Local cCtaSmpt  := GetMv("MV_WFSMTP") 
Local cSendBy   := GetMv("MV_RESSUBC",,'')
Local cMens     :=""
Local cQuery    :="" 
Local cEol:=Chr(13)

cQuery:=" SELECT CTD.CTD_ITEM,CTD.CTD_DESC01,SZ2.Z2_SETOR,lEFT(CTT.CTT_DESC01,40) CTT_DESC01 "
cQuery+=" FROM "+RetSqlName("CTD")+" CTD "
cQuery+=" INNER JOIN "+RetSqlName("SZ2")+" SZ2 ON (SZ2.Z2_SUBC  =CTD.CTD_ITEM AND SZ2.D_E_L_E_T_<>'*') "
cQuery+=" INNER JOIN "+RetSqlName("CTT")+" CTT ON (CTT.CTT_CUSTO=SZ2.Z2_SETOR AND SZ2.D_E_L_E_T_<>'*') "
cQuery+=" WHERE CTD_PRODPJ='' AND CTD_TIPOIT='S'  AND "
cQuery+=" CTD_SITUAC='0' AND CTD_BLOQ<>'1' AND CTD_CLASSE='2' AND CTD.D_E_L_E_T_<>'*' "
cQuery+=" AND CTD_FILIAL='' "
cQuery+=" ORDER BY CTD_ITEM "


TcQuery cQuery Alias QCTD new
dbSelectArea("QCTD")
dbGotop()
If !Eof()
	
	Mens:=' <html> '+cEol
	cMens+='	<head>'+cEol
	cMens+='		<TITLE>Lista de SubContas Sem Código de Produtos para Medição PJ</TITLE>'+cEol
	cMens+='	</HEAD>'+cEol
	cMens+='	<Table border=2 cellspacing=0 bordercolor="black" width=800 >'+cEol
	cMens+='		<tr>'+cEol
	cMens+='			<td align="Left" colspan=3  bgColor="Red" >'+cEol
	cMens+='			<B> Segue abaixo a lista de SubContas(Item Contábil) Sem o Código de Produtos </B><br>'+cEol
	cMens+='  			utilizados na medição de PJs Empresa:'+IIf(cEmpAnt='01','EPC','TSA')+'<br>'
	cMens+='		</td>'+cEol
	cMens+='		</tr>'+cEol
	cMens+='			<td bgColor="Silver">SubConta </td>'+cEol
	cMens+='			<td bgColor="Silver">Descrição </td>'+cEol
	cMens+='			<td bgColor="Silver">Setor </td>'+cEol
	cMens+='		</tr>'+cEol
	dbSelectArea("QCTD")
	dbGotop()
	While !Eof()
		cMens+='		<tr>'+cEol	
		cMens+='			<td>'+QCTD->(CTD_ITEM)+'</td>'+cEol
		cMens+='			<td>'+QCTD->CTD_DESC01+'</td>'+cEol
		cMens+='			<td>'+QCTD->Z2_SETOR+'-'+CTT_DESC01+'</td>'+cEol
		cMens+='		</tr>'+cEol   
		dbSelectArea("QCTD")
		dbSkip()
	EndDo
	
	//Envia o e-mail para os responsáveis
	CONNECT SMTP SERVER cCtaSmpt ACCOUNT cAccount PASSWORD cCtaPass 

	SEND MAIL FROM  cSendBy TO  cSendBy SUBJECT 'Sub Contas Sem Cadastro de Produtos' BODY cMens 
	
	DISCONNECT SMTP SERVER
	
Endif

dbselectarea("QCTD")
dbCloseArea()

Return