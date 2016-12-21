#INCLUDE "RWMAKE.CH"

User Function VALRPGTO()
/*
+-----------------------------------------------------------------------+
|Programa  | VALRPGTO  | Autor |                       | Data |   .  .  |
|----------+------------------------------------------------------------|
|Descricao |                                                            |
|----------+------------------------------------------------------------|
| Uso      | ESPECIFICO PARA MG Cinto.			                        |
|-----------------------------------------------------------------------|
|           ATUALIZACOES SOFRIDAS DESDE A CONSTRUCAO INICIAL            |
|-----------------------------------------------------------------------|
|PROGRAMADOR | DATA   | MOTIVO DA ALTERACAO                             |
|------------+--------+-------------------------------------------------|
|            |        |                                                 |
+-----------------------------------------------------------------------+
*/

Private nValor := 0 

	If SEA->EA_MODELO = "31"
		nValor = StrZero(Val(SubStr(SE2->E2_CODBAR,10,10)),15)
	Else
		nValor = StrZero(((((SE2->E2_SALDO+SE2->E2_ACRESC)-SE2->E2_DECRESC)-;
                           SomaAbat(SE2->E2_PREFIXO,SE2->E2_NUM,SE2->E2_PARCELA,;
                           "P",1,SE2->E2_VENCREA,SE2->E2_FORNECE,SE2->E2_LOJA))*100),;
                           15)
    Endif
    
Return(nValor)
