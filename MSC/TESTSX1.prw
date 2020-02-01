#include "rwmake.ch"        // incluido pelo assistente de conversao do AP5 IDE em 25/06/01

User Function TESTSX1()        // incluido pelo assistente de conversao do AP5 IDE em 25/06/01

Local nxY := 0
Local nxZ := 0 

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Declaracao de variaveis utilizadas no programa atraves da funcao    ³
//³ SetPrvt, que criara somente as variaveis definidas pelo usuario,    ³
//³ identificando as variaveis publicas do sistema utilizadas no codigo ³
//³ Incluido pelo assistente de conversao do AP5 IDE                    ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

SetPrvt("CGRUPO,APERGUNTAS,NXZ,NXY,")

*****************************************************************************
* Testa de os parametros para o SX1 foram cadastrados.
* Caso contrario eles serao criados
* aPerguntas -> 1 - Grupo                  C  06  0
*               2 - Descricao da Pergunta  C  20  0
*               3 - Tipo                   C  01  0
*               4 - Tamanho                N  02  0
*               5 - Decimal                N  01  0
*               6 - Get/Choice             G/C
*               7 - Validacao              C  20  0
*               8 - F3                     C  03  0
*               9 ... 13 - Cont. da choice C  15  0
*********

cGrupo     := ParamIXB[1]
aPerguntas := ParamIXB[2]

dbSelectArea("SX1")

For nxZ := 1 To Len(aPerguntas)
    RecLock("SX1",!dbSeek(cGrupo+StrZero(nxZ,2)))
    Replace  X1_Grupo   With  cGrupo
    Replace  X1_Ordem   With  StrZero(nxZ,2)
    Replace  X1_Pergunt With  aPerguntas[nxZ,2]
    Replace  X1_Variavl With  "Mv_Ch"+IIf(nxZ <=9,AllTrim(Str(nxZ)),Chr(nxZ + 55))
    Replace  X1_Tipo    With  aPerguntas[nxZ,3]
    Replace  X1_Tamanho With  aPerguntas[nxZ,4]
    Replace  X1_Decimal With  aPerguntas[nxZ,5]
    Replace  X1_GSC     With  aPerguntas[nxZ,6]
    Replace  X1_Var01   With  "Mv_Par"+StrZero(nxZ,2)
    Replace  X1_Valid   With  aPerguntas[nxZ,7]
    Replace  X1_F3      With  aPerguntas[nxZ,8]
    If (aPerguntas[nxZ,6] == "C")
       For nxY := 9 To 13
           If (aPerguntas[nxZ,nxY] == "")
              Exit
           Else
              Do Case
                 Case ((nxY - 8) == 1)
                      Replace X1_Def01 With aPerguntas[nxZ,nxY]
                 Case ((nxY - 8) == 2)
                      Replace X1_Def02 With aPerguntas[nxZ,nxY]
                 Case ((nxY - 8) == 3)
                      Replace X1_Def03 With aPerguntas[nxZ,nxY]
                 Case ((nxY - 8) == 4)
                      Replace X1_Def04 With aPerguntas[nxZ,nxY]
                 Case ((nxY - 8) == 5)
                      Replace X1_Def05 With aPerguntas[nxZ,nxY]
              EndCase
           EndIf
       Next
    EndIf
    MsUnLock()
Next

Return

