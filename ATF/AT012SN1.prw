#INCLUDE "PROTHEUS.CH"
#INCLUDE "FWMVCDEF.CH"

User Function AT012SN1()

    Local oCposSN1 := PARAMIXB[1]
    Local cMsg0  := ""
    Local lRet := .F.

    cMsg0 := OemToAnsi("") + CRLF
    cMsg0 += oEmToAnsi("Executar o Ponto de Entrada [ AT012SN1 ] ?") + CRLF

    If MsgYesNo(cMsg0)

        aBotoes0  := {"OK"}  // Ate 5 botoes
        cTitulo0  := OemToAnsi("I N F O R M A Ç Ã O") // Titulo a ser apresentado

        cMens000  := OemToAnsi("") + CRLF
        cMens000  += OemToAnsi("Chamada do Ponto de Entrada [ AT012SN1 ] ")  + CRLF + CRLF
        cMens000  += oEmToAnsi("Para desenvolvimeto com MVC Acesse:") + CRLF
        cMens000  += oEmToAnsi("http://tdn.totvs.com/display/public/mp/FWFormModelStruct ") + CRLF
        cMens000  += OemToAnsi("") + CRLF
        cMens000  += OemToAnsi("Este teste permite a edicao do campos [N1_ALIQPIS] e [N1_ALIQCOF].") + CRLF

        cSubTitu  := OemToAnsi("Programa fonte padrao: [ "+Upper(AllTrim(FunName()))+" ].") // Sub titulo a ser apresentado
        nSize     := 3   // Tamanhos de 1 a 3
        lEdit     := .F.  // Permite a edicao do campo memo
        nTimeOut  := 6000  // Tempo de exibicao do aviso em segundos

        Aviso(cTitulo0,cMens000,aBotoes0,nSize,cSubTitu,/*nRotAutDefault*/,/*cBitmap*/,lEdit,nTimeOut,/*nOpcTimer*/)

        //-- Permite altera um campo especifico
        //MODEL_FIELD_WHEN  
        //remove para liberar o campo {|OMODEL| A012NOTA(OMODEL) }
        oCposSN1:SetProperty("N1_ALIQCOF"  , 8 , nil )
        oCposSN1:SetProperty("N1_ALIQPIS"  , 8 , nil )

        lRet := .T.

    EndIf

Return(lRet)
