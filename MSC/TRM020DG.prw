/*
+-------------+---------+-------------+-------------------+-------+----------------------+
| Programa    | CADCARGO  | Programador | Thiago Santos   | Data  | 12/03/19             |
+-------------+---------+-------------+-------------------+-------+----------------------+
| Descricao   | Replica cadastro da SQ3 para SRJ                                         |
+-------------+--------------------------------------------------------------------------+
| Uso         | Ponto de entrada: Executado após a gravação do cargo                     |
+-------------+--------------------------------------------------------------------------+
|                          Modificacoes efetuadas no Programa                            |
+---------+-------------+----------------------------------------------------------------+
| Data    | Responsavel | Motivo                                                         |
+---------+-------------+----------------------------------------------------------------+
|         |             |                                                                |
+---------+-------------+----------------------------------------------------------------+
*/

#include "rwmake.ch"        
#Include "TopConn.ch"

User Function TRM020DG()

    
	Local aArea := GetArea()
	
	DbSelectArea("SRJ")
	
	If Altera
		DbSetOrder(1) // => RJ_FILIAL+RJ_FUNCAO
		If DbSeek(M->Q3_FILIAL+M->Q3_CARGO) 
			RecLock("SRJ", .F.)
			Replace	RJ_DESC   With M->Q3_DESCSUM
			MsUnlock()
		EndIf
	Else
	     If Inclui
				Reclock("SRJ",.T.)
				Replace 	RJ_FILIAL With M->Q3_FILIAL,;
							RJ_FUNCAO With M->Q3_CARGO,;
							RJ_DESC   With M->Q3_DESCSUM,;
							RJ_CARGO  With M->Q3_CARGO
				MsUnlock()
	     EndIf
	EndIf
	
	RestArea(aArea)
	
return


/*
User Function TESCRIA()

	Local aArea := GetArea()
	
	DbSelectArea("SRJ")
	DbSelectArea("SQ3")
	SQ3->(dbSetOrder(1))
	
	Do While SQ3->( !Eof())

		if(SUBSTR(SQ3->Q3_CARGO,1,1) $ '1_2_3_4_5_6_7_8_9_0' )
			SQ3->(dbSkip())
			Loop
		EndIf

		Reclock("SRJ",.T.)
		Replace 	RJ_FILIAL With SQ3->Q3_FILIAL,;
					RJ_FUNCAO With SQ3->Q3_CARGO,;
					RJ_DESC   With SQ3->Q3_DESCSUM,;
					RJ_CARGO  With SQ3->Q3_CARGO
		MsUnlock()
		SQ3->(dbSkip())
	
	End do
	
	msginfo("Executado com Sucesso!")	

	RestArea(aArea)
	
return*/


