#INCLUDE "rwmake.ch"

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �MT103IPC  � Autor � RODRIGO ALVES   � Data �  28/11/07   ���
�������������������������������������������������������������������������͹��
���Descricao � Programa feito para o SIGAPCO que Carrega os dados do     ���
���          � Pedido de Compras para a NF Entrada                        ���
�������������������������������������������������������������������������͹��
��� Alterado � 17/10/13 Leandro P J Monteiro 							  ���
��� 		 Mesclando orinal com arquivo existente na TSA, que carrega	  ���
��� 		 a descricao do produto que est� no pedido de compras		  ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/

User Function MT103IPC


//���������������������������������������������������������������������Ŀ
//� Declaracao de Variaveis                                             �
//�����������������������������������������������������������������������
	LOCAL n 
	LOCAL F

	nPos1 := aScan(aHeader,{|aAux|alltrim(aAux[2]) == "D1_COD"		})
	nPos2 := aScan(aHeader,{|aAux|alltrim(aAux[2]) == "D1_ESPECIF"	})
	nPos3 := aScan(aHeader,{|aAux|alltrim(aAux[2]) == "D1_PEDIDO"	})
	nPos4 := aScan(aHeader,{|aAux|alltrim(aAux[2]) == "D1_ITEMPC"	})
	nPos5 := aScan(aHeader,{|aAux|alltrim(aAux[2]) == "D1_XCO"		})
	nPos6 := aScan(aHeader,{|aAux|alltrim(aAux[2]) == "D1_XCLASSE"	})
	nPos7 := aScan(aHeader,{|aAux|alltrim(aAux[2]) == "D1_XOPER"	})
	nPos8 := aScan(aHeader,{|aAux|alltrim(aAux[2]) == "D1_XORCAME"	})
	nPos9 := aScan(aHeader,{|aAux|alltrim(aAux[2]) == "D1_CC"		})
	nPos10:= aScan(aHeader,{|aAux|alltrim(aAux[2]) == "D1_ORDEM"	})
	nPos11:= aScan(aHeader,{|aAux|alltrim(aAux[2]) == "D1_DESCRI"	})
	nPos12:= aScan(aHeader,{|aAux|alltrim(aAux[2]) == "D1_NFROTA"	}) 
	nPos13:= aScan(aHeader,{|aAux|alltrim(aAux[2]) == "D1_XPCO"		})
	nPos14:= aScan(aHeader,{|aAux|alltrim(aAux[2]) == "D1_XPCO1"	}) 
	nPos15:= aScan(aHeader,{|aAux|alltrim(aAux[2]) == "D1_DESCRIC"	}) 
	nPos16:= aScan(aHeader,{|aAux|alltrim(aAux[2]) == "D1_DTREF"	}) 

	n:=len(aCols)
	IF ALLTRIM(ACOLS[N,nPos1])<>""		
		ACOLS[N,nPos5 ]:=RETFIELD("SC7",1,XFILIAL("SC7")+ACOLS[N,nPos3]+ACOLS[N,nPos4],"C7_XCO"		)  
		ACOLS[N,nPos6 ]:=RETFIELD("SC7",1,XFILIAL("SC7")+ACOLS[N,nPos3]+ACOLS[N,nPos4],"C7_XCLASSE"	)  
		ACOLS[N,nPos7 ]:=RETFIELD("SC7",1,XFILIAL("SC7")+ACOLS[N,nPos3]+ACOLS[N,nPos4],"C7_XOPER"	)  
		ACOLS[N,nPos8 ]:=RETFIELD("SC7",1,XFILIAL("SC7")+ACOLS[N,nPos3]+ACOLS[N,nPos4],"C7_XORCAME"	)
		ACOLS[N,nPos9 ]:=RETFIELD("SC7",1,XFILIAL("SC7")+ACOLS[N,nPos3]+ACOLS[N,nPos4],"C7_CC"		) 
//		ACOLS[N,nPos10]:=RETFIELD("SC7",1,XFILIAL("SC7")+ACOLS[N,nPos3]+ACOLS[N,nPos4],"C7_ORDEM"	) 		
//		ACOLS[N,nPos11]:=RETFIELD("SC7",1,XFILIAL("SC7")+ACOLS[N,nPos3]+ACOLS[N,nPos4],"C7_DESCRI"	)
//		ACOLS[N,nPos11]:=RETFIELD("SC7",1,XFILIAL("SC7")+ACOLS[N,nPos3]+ACOLS[N,nPos4],"C7_ESPECIF"	)
//		ACOLS[N,nPos12]:=RETFIELD("SC7",1,XFILIAL("SC7")+ACOLS[N,nPos3]+ACOLS[N,nPos4],"C7_NFROTA"	)
		ACOLS[N,nPos13]:=RETFIELD("SC7",1,XFILIAL("SC7")+ACOLS[N,nPos3]+ACOLS[N,nPos4],"C7_XPCO"	)
		ACOLS[N,nPos14]:=RETFIELD("SC7",1,XFILIAL("SC7")+ACOLS[N,nPos3]+ACOLS[N,nPos4],"C7_XPCO1"	)
		ACOLS[N,nPos15]:=RETFIELD("SC7",1,XFILIAL("SC7")+ACOLS[N,nPos3]+ACOLS[N,nPos4],"C7_DESCRI"	)
		ACOLS[N,nPos16]:=RETFIELD("SC7",1,XFILIAL("SC7")+ACOLS[N,nPos3]+ACOLS[N,nPos4],"C7_DATPRF"	)
		IF ALLTRIM(ACOLS[N,nPos6])=="0" 
			ACOLS[N,nPos10]:=LEFT(RETFIELD("SC7",1,XFILIAL("SC7")+ACOLS[N,nPos3]+ACOLS[N,nPos4],"C7_OP"),6)
		ENDIF  
	ENDIF     
Return .T.
