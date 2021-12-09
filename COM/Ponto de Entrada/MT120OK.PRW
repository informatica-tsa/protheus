#INCLUDE "PROTHEUS.CH"


 //-------------------------------------------------------------------
/* {Protheus.doc} MT120OK
Validações Específicas de Usuário
Após a confirmação dos itens da getdados e antes do rodapé da dialog do PC

@protected TSA
@author    Thiago V. dos Santos
@since     02/12/2021

Alteracoes Realizadas desde a Estruturacao Inicial
Data       Programador     Motivo
/*/
//-------------------------------------------------------------------

User Function MT120OK()

    Local aArea 	 := GetArea()
    Local lValido := .T.
    Local nX       := 0 

    nPos1   := aScan(aHeader,{|x|alltrim(x[2]) == "C7_XORCAME"})
    nPos2   := aScan(aHeader,{|x|alltrim(x[2]) == "C7_XCO"})
    nPos3   := aScan(aHeader,{|x|alltrim(x[2]) == "C7_XCLASSE"})
    nPos4   := aScan(aHeader,{|x|alltrim(x[2]) == "C7_XOPER"})
    nPos6   := aScan(aHeader,{|x|alltrim(x[2]) == "C7_XPCO"})
    nPos8   := aScan(aHeader,{|x|alltrim(x[2]) == "C7_XPCO1"})  
    nSc     := aScan(aHeader,{|x|alltrim(x[2]) == "C7_NUMSC"})
    nItemsc := aScan(aHeader,{|x|alltrim(x[2]) == "C7_ITEMSC"})  
    nOrigem := aScan(aHeader,{|x|alltrim(x[2]) == "C7_ORIGEM"}) 

    For nX :=1 To Len( aCols )     

        //VALIDAÇÕES PARA RODAR APENAS SE A ORIGEM FOR LIGAI E NAO ESTIVER VIA SMARTCLIENT nOrigem = 0
        If nOrigem != 0
            If ( Empty(aCols[nX,nSc]) .Or. Empty(aCols[nX,nItemsc]) .or. alltrim(aCols[nX,nOrigem]) != "LIGAI")
                exit
            EndIf
        Else
            exit
        EndIf


        dBSelectArea('SC1')
        dbSetOrder(1)
        dbSeek(xFilial("SC1")+ACOLS[nX,nSc]+ACOLS[nX,nItemsc])

        ACOLS[nX,nPos1]:=SC1->C1_XORCAME  
        ACOLS[nX,nPos2]:=SC1->C1_XCO
        ACOLS[nX,nPos3]:=SC1->C1_XCLASSE
        ACOLS[nX,nPos4]:=SC1->C1_XOPER
        ACOLS[nX,nPos6]:=SC1->C1_XPCO 
        ACOLS[nX,nPos8]:=SC1->C1_XPCO1
        
    Next nX

    RestArea(aArea)

Return(lValido)
