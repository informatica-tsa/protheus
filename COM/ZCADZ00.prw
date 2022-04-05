#Include "Protheus.ch"
 
/*/{Protheus.doc} ZCADZ00
Função de cadastro da Tabela Z00
@author Thiago Santos
@since 28/03/2022
@version 1.0
/*/
 
User Function ZCADZ00()

    Local aArea    := GetArea()
    Local cDelOk   := ".T."
    Local cFunTOk  := ".T." 
 
    AxCadastro('Z00', 'Relacionar Gerente com Funcionario', cDelOk, cFunTOk)

    RestArea(aArea)

Return
