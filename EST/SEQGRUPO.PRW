#include "rwmake.ch"        // incluido pelo assistente de conversao do AP5 IDE em 25/06/01
#include "topconn.ch"        // incluido pelo assistente de conversao do AP5 IDE em 25/06/01

User Function SEQGRUPO()        // incluido pelo assistente de conversao do AP5 IDE em 25/06/01

//旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴�
//� Declaracao de variaveis utilizadas no programa atraves da funcao    �
//� SetPrvt, que criara somente as variaveis definidas pelo usuario,    �
//� identificando as variaveis publicas do sistema utilizadas no codigo �
//� Incluido pelo assistente de conversao do AP5 IDE                    �
//읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴�

//SetPrvt("CINIGRUPO,NCONTADOR,CCONTADOR,")

/*/
複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複�
굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇�
굇旼컴컴컴컴컫컴컴컴컴컴쩡컴컴컴쩡컴컴컴컴컴컴컴컴컴컴컴쩡컴컴컫컴컴컴컴컴엽�
굇쿑un놹o    쿞EQGRUPO  � Autor � Luiz Carlos da Cruz   � Data � 05-10-98 낢�
굇쳐컴컴컴컴컵컴컴컴컴컴좔컴컴컴좔컴컴컴컴컴컴컴컴컴컴컴좔컴컴컨컴컴컴컴컴눙�
굇쿏escri눯o 쿘ontar um contador de c줰igo de produto do SB1, para cada   낢�
굇�          쿲rupo de material. Esses contadores, nesse rdmake, est�o na 낢�
굇�          퀃abela 98, do SX5.                                          낢�
굇쳐컴컴컴컴컵컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴눙�
굇쿢so       쿑un눯o disparada pelo gatilho 001 do B1_GRUPO.              낢�
굇쳐컴컴컴컴컨컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴눙�
굇�1) Criar uma tabela no SX5: na chave p뱑 o nome dos grupos e no conte�-낢�
굇�   do o sequencial de cada um. Nesse rdmake a tabela � 98;             낢�
굇�2) Tornar o B1_GRUPO obrigat줿io e anterior do B1_COD. Colocar o B1_COD낢�
굇�   inibido para digita눯o;                                             낢�
굇�3) Criar um gatilho do B1_GRUPO para o B1_COD, chamando esse rdmake;   낢�
굇�4) Este rdmake posiciona o SX5  na tabela 90, no grupo digitado e re-  낢�
굇�   torna o conte즔o acrescido de um.                                   낢�
굇�5) Colocar no diret줿io \SIGAADV o programa MATA010 que quando da con- 낢�
굇�   firma눯o da entrada do registro grava o sequencial na tabela 98.    낢�
굇�6) Notas: 6.1: as inclus�es no SB1, via F3, devem ser inibidas.        낢�
굇�          6.2: n�o poder�o ser digitados produtos de um mesmo grupo,   낢�
굇�               por mais de um usu쟲io, simultaneamente.                낢�
굇읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴袂�
굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇�
賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽�
*/
/*cInigrupo := Posicione("SBM",1,xFilial("SBM")+M->B1_GRUPO,"SBM->BM_GRUPO")                                
nContador:= val(cInigrupo)+1  
cContador:=" " 
cContador:=strzero(nContador,4)
cInigrupo:= alltrim(M->B1_GRUPO) + cContador*/

Local cGrupo := M->B1_GRUPO
Local cQuery := "" 
Local cIniGrupo := ""
Local cGrupoA := AllTrim(cGrupo)

If !Empty(cGrupo)
   cQuery := "SELECT MAX(CAST(SUBSTRING(B1_COD,"+Alltrim(Str(Len(cGrupoA)+1))+",LEN(B1_COD)) AS INTEGER))+1  AS MAXIMO FROM "+RetSqlName("SB1")+ " WHERE B1_GRUPO = '"+cGrupo+"' AND D_E_L_E_T_ <> '*'"

   TCQUERY cQuery ALIAS "QSB1" NEW

   cIniGrupo := QSB1->MAXIMO

   dbCloseArea("QSB1")

   cIniGrupo := StrZero(cIniGrupo,6)
   cIniGrupo := Alltrim(cGrupoA) + Alltrim(cIniGrupo)
EndIf

Return(cInigrupo)