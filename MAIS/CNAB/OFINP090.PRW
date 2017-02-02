#include "rwmake.ch"



//-------------------------------------------------------------------------------------------------------------------------------------------------
/*
Campos a serem criados:
CAMPO				TIPO		TAMANHO		
SE2->E2_REFEREN     Caracter	4        Código de recolhimento dos tributos
SE2->E2_PERAPUR		Data                 Período de apuração e competência
SE2->E2_LINDIG		Caracter    48       Linha digitável do codigo de barras do tributo e/ou contas de consumo
SE2->E2_ZIDFGTS		Caracter    16       Identificador do FGTS
SE2->E2_ZRENAVA		Caracter    9        Código do RENAVAM para pagamento de debitos com veículos
SE2->E2_ZUFIPVA		Caracter    2        UF do veiculo a ser pago o IPVA e DPVAT
SE2->E2_ZMUNIPV		Caracter    5        Municipio do Veiculos
SE2->E2_ZPLACA		Caracter    7        Placa do veiculo
SE2->E2_ZPGIPVA		Caracter    1        Tipo de pagamento do IPVA
SE2->E2_ZIDENTI		Caracter	14		 Número do CNPJ de recolhimento
SE2->E2_ZOUTENT		Valor		17		 Valor de outras entidades

Função criada para montar Seguimento N - Impostos

/*/
//-------------------------------------------------------------------------------------------------------------------------------------------------

User Function OFINP090()

Private cTributo 	:= ""

Private cTrb 		:= space(120)
Private _cSeuNum 	:= SE2->E2_IDCNAB

Do Case
	Case SEA->EA_MODELO = "17" //GPS - INSS
		cTrb := "01"+STRZERO(VAL(SE2->E2_REFEREN),4)+SUBSTR(DTOS(SE2->E2_PERAPUR),5,2)+SUBSTR(DTOS(SE2->E2_PERAPUR),1,4)
  		cTrb := cTrb+SUBSTR(SM0->M0_CGC,1,14) 
		cTrb := cTrb+STRZERO((SE2->(E2_SALDO-E2_SDDECRE))*100,14)
		cTrb := cTrb+STRZERO((SE2->E2_SDACRES)*100,14)+STRZERO((SE2->E2_SDACRES)*100,14)+STRZERO((SE2->(E2_SALDO+E2_SDACRES-E2_SDDECRE))*100,14)+Gravadata(SE2->E2_VENCREA,.F.,5)+ SPACE(58)+SM0->M0_NOMECOM                       
 
	Case SEA->EA_MODELO = "16" //DARF NORMAL
		cTrb := "02"+IF(EMPTY(SE2->E2_CODRET),STRZERO(VAL(SE2->E2_REFEREN),4), STRZERO(VAL(SE2->E2_CODRET),4))+"2"+SUBSTR(SM0->M0_CGC,1,14)
		cTrb := cTrb+GRAVADATA(SE2->E2_PERAPUR,.F.,5)+ SPACE(17)+STRZERO((SE2->E2_VALOR)*100,14)+STRZERO((SE2->(E2_MULTA+E2_ACRESC))*100,14)
    	cTrb := cTrb+STRZERO((SE2->E2_JUROS)*100,14)+STRZERO((SE2->(E2_SALDO+E2_ACRESC))*100,14)+GRAVADATA(SE2->E2_VENCREA,.F.,5)+GRAVADATA(SE2->E2_VENCREA,.F.,5)+SPACE(30)+SM0->M0_NOMECOM

	Case SEA->EA_MODELO = "35" //FGTS       
		cTrb := "11"+STRZERO(VAL(SE2->E2_REFEREN),4)+"1"+SUBSTR(SM0->M0_CGC,1,14)+SE2->(E2_LINDIG + E2_ZIDFGTS) + REPLICATE ("0",11) +SUBSTR(SM0->M0_NOMECOM,1,30)
		cTrb := cTrb+GRAVADATA(SE2->E2_VENCREA,.F.,5)+STRZERO((SE2->E2_VALOR)*100,14)+SPACE(30)

	Case SEA->EA_MODELO $ "25" //IPVA
		cTrb := "07"+SPACE(04)+"2"+SM0->M0_CGC+SUBSTR(dtos(SE2->E2_VENCREA),1,4)+STRZERO(VAL(SE2->E2_ZRENAVA),9)+SUBSTR(SE2->E2_ZUFIPVA,1,2)+SUBSTR(SE2->E2_ZMUNIPV,1,5)+SUBSTR(SE2->E2_ZPLACA,1,7)
		cTrb := cTrb+STRZERO(VAL(SE2->E2_ZPGIPVA),1)+STRZERO((SE2->(E2_VALOR + E2_ACRESC))*100,14)+STRZERO((SE2->E2_DECRESC)*100,14)+STRZERO((SE2->(E2_VALOR + E2_ACRESC))*100,14)
       	cTrb := cTrb+Gravadata(SE2->E2_VENCREA,.F.,5)+Gravadata(SE2->E2_VENCREA,.F.,5)+SPACE(41)+SM0->M0_NOMECOM

	Case SEA->EA_MODELO $ "27" //DPVAT
    	cTrb := "08"+SPACE(04)+"2"+SM0->M0_CGC+SUBSTR(dtos(SE2->E2_VENCREA),1,4)+STRZERO(VAL(SE2->E2_ZRENAVA),9)+SUBSTR(SE2->E2_ZUFIPVA,1,2)+SUBSTR(SE2->E2_ZMUNIPV,1,5)+SUBSTR(SE2->E2_ZPLACA,1,7)
		cTrb := cTrb+"0"+STRZERO((SE2->(E2_VALOR + E2_ACRESC))*100,14)+STRZERO((SE2->E2_DECRESC)*100,14)+STRZERO((SE2->(E2_VALOR + E2_ACRESC))*100,14)
        cTrb := cTrb+Gravadata(SE2->E2_VENCREA,.F.,5)+Gravadata(SE2->E2_VENCREA,.F.,5)+SPACE(41)+SM0->M0_NOMECOM

	EndCase

Return(cTrb)
 