#include "rwmake.ch"
/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Programa  � LP59101  � Autor � Tiago Augusto Gomes   � Data � 05.07.01 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � RDMAKE para localizacao da Conta Contabil correta a ser    ���
���          � creditada o Valor de ISSQN.                                ���
�������������������������������������������������������������������������Ĵ��
��� Uso      � ESPECIFICO PARA EPC                                        ���
�������������������������������������������������������������������������Ĵ��
���           ATUALIZACOES SOFRIDAS DESDE A CONSTRUCAO INICIAL            ���
�������������������������������������������������������������������������Ĵ��
���PROGRAMADOR � DATA  � MOTIVO DA ALTERACAO                              ���
�������������������������������������������������������������������������Ĵ��
���            �       �                                                  ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

User Function LP59101()

SetPrvt("CCHEQUE,CPREFIXO,CTITULO,CCODCLI,CLOJCLI,CCONTAISS,NREC,")

cCheque    := SEF->EF_NUM
dbSelectArea("SEF")
nRec := Recno()
dbSetOrder(5)
If dbSeek(xFilial("SEF")+cCheque+"01")
   	If Alltrim(SEF->EF_FORNECE) == "MUNIC"
		cPrefixo := SEF->EF_PREFIXO	        // Recebe o Prefixo do T�tulo de ISSQN
		cTitulo  := SEF->EF_TITULO	     	// Recebe o Numero do T�tulo de ISSQN
		dbSelectArea("SE1")
		dbSetOrder(1)
		If dbSeek(xFilial("SE1")+cPrefixo+cTitulo)
			cCodCli := SE1->E1_CLIENTE
			cLojCli := SE1->E1_LOJA
    		// Descobrir a Conta Cont�bil de ISS no Cadastro de Clientes
    		DbSelectArea("SA1")
    		DbSetOrder(1)
    		If DbSeek(xFilial("SA1")+cCodCli+cLojCli)
   				cContaISS := AllTrim(SA1->A1_CONTISS)
    		EndIf
		  Else
   			cContaISS := "TRES"  // Criado para que o Sistema nao tente retornar um variavel inexistente
		EndIf      
	  Else
   		cContaISS := "DOIS"  // Criado para que o Sistema nao tente retornar um variavel inexistente
	Endif
  Else
   	cContaISS := "UM"  // Criado para que o Sistema nao tente retornar um variavel inexistente
Endif
DbSelectArea("SEF")
DbGoTo(nRec)
Return(cContaISS)     // Retorna a conta contabil que sera debitada.    		