/*//#########################################################################################
Project  : project
Module   : SIGAFIS
Source   : LXFISR03
Objective: Gerar dados das Notas fiscais
*///#########################################################################################

#INCLUDE 'TOTVS.CH'

/*/{Protheus.doc} LXFISR03

    Gerar dados das Notas fiscais saída

    @author  Igor Guimarães
    @example Example
    @param   [Parameter_Name],Parameter_type,Parameter_Description
    @return  Return
    @table   Tables
    @since   12-11-2021
/*/
User Function LXFISR03()

    Local lLogin        := Type("cEmpAnt") != "U"
    Local cFiltro       := ""
    Local cDatIni       := ""
    Local cDatFim       := ""
    Local cTMPSE1       := GetNextAlias()
    Local aArea         := GetArea()   //tabela que vai abrir o banco de dados
    Local cArquivo      := GetTempPath()+'LXFISR03.xml' //caminho e arquivo do excel que sera gravado
    Local oFWMsExcel                 //funcao do ADVPL que manipular dados do excel
    Local oExcel                     //objetos da funcao oFWMsExcel

    If !lLogin
        RPCSETENV("02","01")
    EndIf

    If !ValidPerg()
        Return()
    EndIf

    cDatIni       := DtoS(mv_par01)
    cDatFim       := DtoS(mv_par02)

    If mv_par03 == "1"
        cFiltro += " and E1_SALDO > 0 "
    ElseIf mv_par03 == "2"
        cFiltro += " and E1_SALDO = 0 "
    EndIf
    cFiltro	:= '%' + cFiltro + '%'

    BeginSql Alias cTMPSE1
        SELECT
            E1_PREFIXO,
            E1_NUM,
            E1_PARCELA,
            E1_TIPO,
            E1_NATUREZ,
            E1_CLIENTE,
            E1_LOJA,
            A1_NOME,
            E1_EMISSAO,
            E1_VENCREA,
            E1_VALOR,
            E1_SALDO,
            E1_BASEINS,
            E1_INSS,
            E1_BASECOF,
            E1_COFINS,
            E1_BASECSL,
            E1_CSLL,
            E1_BASEPIS,
            E1_PIS,
            E1_BASEISS,
            E1_ISS,
            E1_VRETISS,
            E1_VRETIRF,
            E1_VRETISS,
            A1_MUNISS,
            A1_EST,
            A1_COD_MUN,
            A1_MUN
        FROM
            %table:SE1% E1
        INNER JOIN %table:SA1% A1
        ON A1_COD = E1_CLIENTE
            AND A1_LOJA = E1_LOJA
        WHERE
            E1.D_E_L_E_T_ = ' '
            AND A1.D_E_L_E_T_ = ' ' %exp:cFiltro%
            AND E1_EMISSAO BETWEEN %exp:cDatIni% AND %exp:cDatFim%
            AND E1_TIPO NOT IN ('RA', 'NCC', 'PR')
    EndSql

    //Criando o objeto que irá gerar o conteúdo do Excel
    oFWMsExcel := FWMSExcel():New()

    //Aba 0 - Registros  - nome da tabela que vai abrir
    oFWMsExcel:AddworkSheet("Registros")

    //Criando a Tabela
    oFWMsExcel:AddTable("Registros","Notas Fiscais de Saída (SE1)")

    //montando as colunas

    oFWMsExcel:AddColumn("Registros","Notas Fiscais de Saída (SE1)","Prefixo",2,1) //E1_PREFIXO
    oFWMsExcel:AddColumn("Registros","Notas Fiscais de Saída (SE1)","Nota Fiscal",2,1) //E1_NUM
    oFWMsExcel:AddColumn("Registros","Notas Fiscais de Saída (SE1)","Parcela",2,1) //E1_PARCELA
    oFWMsExcel:AddColumn("Registros","Notas Fiscais de Saída (SE1)","Tipo",2,1) //E1_TIPO
    oFWMsExcel:AddColumn("Registros","Notas Fiscais de Saída (SE1)","Natureza",2,1)//E1_NATUREZ
    oFWMsExcel:AddColumn("Registros","Notas Fiscais de Saída (SE1)","Cliente",2,1)//E1_CLIENTE
    oFWMsExcel:AddColumn("Registros","Notas Fiscais de Saída (SE1)","Loja",2,1)//E1_LOJA
    oFWMsExcel:AddColumn("Registros","Notas Fiscais de Saída (SE1)","Nome",1,1)//A1_NOME
    oFWMsExcel:AddColumn("Registros","Notas Fiscais de Saída (SE1)","Data Emissão",2,1)//E1_EMISSAO
    oFWMsExcel:AddColumn("Registros","Notas Fiscais de Saída (SE1)","Vencimento",2,1)//E1_VENCREA
    oFWMsExcel:AddColumn("Registros","Notas Fiscais de Saída (SE1)","Valor",3,1)//E1_VALOR
    oFWMsExcel:AddColumn("Registros","Notas Fiscais de Saída (SE1)","Saldo",3,1)//E1_SALDO
    oFWMsExcel:AddColumn("Registros","Notas Fiscais de Saída (SE1)","Base INSS",3,1)//E1_BASEINS
    oFWMsExcel:AddColumn("Registros","Notas Fiscais de Saída (SE1)","Valor INSS",3,1)//E1_INSS
    oFWMsExcel:AddColumn("Registros","Notas Fiscais de Saída (SE1)","Base COFINS",3,1)//E1_BASECOF
    oFWMsExcel:AddColumn("Registros","Notas Fiscais de Saída (SE1)","Valor COFINS",3,1)//E1_COFINS
    oFWMsExcel:AddColumn("Registros","Notas Fiscais de Saída (SE1)","Base CSLL",3,1)//E1_BASECSL
    oFWMsExcel:AddColumn("Registros","Notas Fiscais de Saída (SE1)","Valor CSLL",3,1)//E1_CSLL
    oFWMsExcel:AddColumn("Registros","Notas Fiscais de Saída (SE1)","Base PIS",3,1)//E1_BASEPIS
    oFWMsExcel:AddColumn("Registros","Notas Fiscais de Saída (SE1)","Valor PIS",3,1)//E1_PIS
    oFWMsExcel:AddColumn("Registros","Notas Fiscais de Saída (SE1)","Base ISS",3,1)//E1_BASEISS
    oFWMsExcel:AddColumn("Registros","Notas Fiscais de Saída (SE1)","Valor ISS",3,1)//E1_ISS
    oFWMsExcel:AddColumn("Registros","Notas Fiscais de Saída (SE1)","Valor Det ISS",3,1)
    oFWMsExcel:AddColumn("Registros","Notas Fiscais de Saída (SE1)","Valor Det IRF",3,1)
    oFWMsExcel:AddColumn("Registros","Notas Fiscais de Saída (SE1)","Valor Det ISS",3,1)
    oFWMsExcel:AddColumn("Registros","Notas Fiscais de Saída (SE1)","Município ISS",2,1) //A1_MUNISS
    oFWMsExcel:AddColumn("Registros","Notas Fiscais de Saída (SE1)","Estado",2,1)//A1_EST
    oFWMsExcel:AddColumn("Registros","Notas Fiscais de Saída (SE1)","Código do Município",2,1)//A1_COD_MUN
    oFWMsExcel:AddColumn("Registros","Notas Fiscais de Saída (SE1)","Município",1,1)//A1_MUN

    While !(cTMPSE1)->(EoF())
        //MsProcTxt("Analisando registro " + cValToChar(nAtual) + " de " + cValToChar(nTotal) + "...")

        oFWMsExcel:AddRow("Registros","Notas Fiscais de Saída (SE1)",{;
            (cTMPSE1)->E1_PREFIXO,;
            (cTMPSE1)->E1_NUM,;
            (cTMPSE1)->E1_PARCELA,;
            (cTMPSE1)->E1_TIPO,;
            Alltrim((cTMPSE1)->E1_NATUREZ),;
            (cTMPSE1)->E1_CLIENTE,;
            (cTMPSE1)->E1_LOJA,;
            Alltrim((cTMPSE1)->A1_NOME),;
            dtoc(stod((cTMPSE1)->E1_EMISSAO)),;
            dtoc(stod((cTMPSE1)->E1_VENCREA)),;
            cValtoChar((cTMPSE1)->E1_VALOR),;
            cValtoChar((cTMPSE1)->E1_SALDO),;
            cValtoChar((cTMPSE1)->E1_BASEINS),;
            cValtoChar((cTMPSE1)->E1_INSS),;
            cValtoChar((cTMPSE1)->E1_BASECOF),;
            cValtoChar((cTMPSE1)->E1_COFINS),;
            cValtoChar((cTMPSE1)->E1_BASECSL),;
            cValtoChar((cTMPSE1)->E1_CSLL),;
            cValtoChar((cTMPSE1)->E1_BASEPIS),;
            cValtoChar((cTMPSE1)->E1_PIS),;
            cValtoChar((cTMPSE1)->E1_BASEISS),;
            cValtoChar((cTMPSE1)->E1_ISS),;
            cValtoChar((cTMPSE1)->E1_VRETISS),;
            cValtoChar((cTMPSE1)->E1_VRETIRF),;
            cValtoChar((cTMPSE1)->E1_VRETISS),;
            (cTMPSE1)->A1_MUNISS,;
            (cTMPSE1)->A1_EST,;
            (cTMPSE1)->A1_COD_MUN,;
            Alltrim((cTMPSE1)->A1_MUN) })
        (cTMPSE1)->(DbSkip())

    EndDo

    //Ativando o arquivo e gerando o xml
    oFWMsExcel:Activate()
    oFWMsExcel:GetXMLFile(cArquivo)
    //Abrindo o excel e abrindo o arquivo xml
    oExcel := MsExcel():New()          //Abre uma nova conexão com Excel
    oExcel:WorkBooks:Open(cArquivo)    //Abre uma planilha
    oExcel:SetVisible(.T.)             //Visualiza a planilha
    oExcel:Destroy()                   //Encerra o processo do gerenciador de tarefas
    APMsgAlert("Processo Finalizado!!!!")
    (cTMPSE1)->(DbCloseArea())
    RestArea(aArea)

Return()


/*/{Protheus.doc} ValidPerg

    Gera perguntas

    @author  Igor Guimarães
    @example Example
    @param   [Parameter_Name],Parameter_type,Parameter_Description
    @return  Return
    @table   Tables
    @since   12-11-2021
/*/

Static Function ValidPerg()

    Local aRet   := {}
    Local aPergs := {}
    Local lRet   := .F.

    aAdd( aPergs ,{1,"Data de : ", CTOD(SPACE(8)),"",".T.","",".T.",75,.T. })
    aAdd( aPergs ,{1,"Data até : ", CTOD(SPACE(8)),"",".T.","",".T.",75,.T. })
    aAdd( aPergs ,{2,"Situação","3",{"1=Abertos","2=Baixados","3=Todos"},75,"",.F.})
    lRet := ParamBox(aPergs ,"Notas Fiscais a Receber",aRet)
Return lRet
