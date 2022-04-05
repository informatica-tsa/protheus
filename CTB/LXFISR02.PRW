/*//#########################################################################################
Project  : project
Module   : module
Source   : LXFISR02
Objective: Fonte desenvolvido para trazer as notas ficas de entrada
*///#########################################################################################

#INCLUDE 'TOTVS.CH'


/*/{Protheus.doc} LXFISR02

    Description

    @author  Name
    @example Example
    @param   [Parameter_Name],Parameter_type,Parameter_Description
    @return  Return
    @table   Tables
    @since   03-11-2021
/*/

User Function LXFISR02()

    Local lLogin        := Type("cEmpAnt") != "U"
    Private cDatIni     := ""
    Private cDatFim     := ""

    If !lLogin
        RPCSETENV("02","01")
    EndIf

    If !ValidPerg()
        Return()
    EndIf
    cDatIni       := DtoS(mv_par01)
    cDatFim       := DtoS(mv_par02)

    //corpo do programa
    MsAguarde({|| fLXFISR02()}, "Aguarde...", "Processando Registros...")

return

//sub rotina

/*/{Protheus.doc} fLXFISR02

    Description

    @author  Name
    @example Example
    @param   [Parameter_Name],Parameter_type,Parameter_Description
    @return  Return
    @table   Tables
    @since   03-11-2021
/*/

Static  Function fLXFISR02()

    //declaracao de variaveis
    Local aArea       := GetArea()   //tabela que vai abrir o banco de dados
    Local oFWMsExcel                 //funcao do ADVPL que manipular dados do excel
    Local oExcel                     //objetos da funcao oFWMsExcel
    Local cArquivo    := GetTempPath()+'fLXFISR02.xml' //caminho e arquivo do excel que sera gravado
    Private cTMPSF1 := GetNextAlias()

    BeginSql Alias cTMPSF1
        SELECT
            D1_DOC NFE_ENTRADA,
            D1_EMISSAO AS DATA_EMISSAO,
            D1_DTDIGIT AS DATA_DIGIT,
            D1_FILIAL AS FILIAL,
            D1_ITEM AS ITEM,
            D1_COD AS COD_PRO,
            B1_DESC AS PRODUTO,
            D1_QUANT AS QUANTIDADE,
            D1_VUNIT AS VALOR_UN,
            D1_TOTAL AS VALOR_TOTAL,
            D1_IPI AS IPI,
            D1_VALICM AS ICMS,
            D1_TES AS TES,
            D1_CF AS CFOP,
            D1_CC AS CC,
            CTT_DESC01 AS CENTRO_CUSTO,
            D1_FORNECE AS COD_FOR,
            D1_LOJA AS LOJA,
            A2_NOME AS NOMEFORNECE,
            D1_PICM AS ALIQ_ICM,
            D1_CONTA AS CONTA,
            CT1_DESC01 AS NOME_CONTA,
            D1_CLASFIS AS CLASSIFICACAO,
            D1_BASIMP5 AS BASIMP5,
            D1_BASIMP6 AS BASIMP6,
            D1_VALIMP5 AS VALIMP5,
            D1_VALIMP6 AS VALIMP6
        FROM
            %table:SF1% F1
        INNER JOIN %table:SD1% D1
        ON D1.D_E_L_E_T_ = ''
            AND D1_FILIAL = F1_FILIAL
            AND D1_DOC = F1_DOC
            AND D1_SERIE = F1_SERIE
            AND D1_EMISSAO = F1_EMISSAO
            AND D1_FORNECE = F1_FORNECE
        LEFT JOIN %table:SA2% A2
        ON A2.D_E_L_E_T_ = ''
            AND A2_COD = F1_FORNECE
            AND A2_LOJA = F1_LOJA
        LEFT JOIN %table:SA1% A1
        ON A1.D_E_L_E_T_ = ''
            AND A1_COD = F1_FORNECE
            AND A1_LOJA = F1_LOJA
        INNER JOIN %table:SB1% B1
        ON B1.D_E_L_E_T_ = ''
            AND B1_COD = D1_COD
        LEFT JOIN %table:CTT% CTT
        ON CTT.D_E_L_E_T_ = ''
            AND D1_CC = CTT_CUSTO
        LEFT JOIN %table:CT1% CT1
        ON CT1.D_E_L_E_T_ = ''
            AND D1_CONTA = CT1_CONTA
        WHERE
            F1.D_E_L_E_T_ = ''
            AND D1_DTDIGIT BETWEEN %exp:cDatIni% AND %exp:cDatFim%
        ORDER BY
            F1_FILIAL,
            F1_EMISSAO,
            F1_DOC
    EndSql

    //Criando o objeto que irá gerar o conteúdo do Excel
    oFWMsExcel := FWMSExcel():New()

    //Aba 0 - Registros  - nome da tabela que vai abrir
    oFWMsExcel:AddworkSheet("Registros")

    //Criando a Tabela
    oFWMsExcel:AddTable("Registros","Notas Fiscais de Entrada (SD1)")

    //montando as colunas

    oFWMsExcel:AddColumn("Registros","Notas Fiscais de Entrada (SD1)","Nfe Entrada",1,1)
    oFWMsExcel:AddColumn("Registros","Notas Fiscais de Entrada (SD1)","Data Emissão",1,1)
    oFWMsExcel:AddColumn("Registros","Notas Fiscais de Entrada (SD1)","Data Digitação",1,1)
    oFWMsExcel:AddColumn("Registros","Notas Fiscais de Entrada (SD1)","Filial",1,1)
    oFWMsExcel:AddColumn("Registros","Notas Fiscais de Entrada (SD1)","Item",1,1)
    oFWMsExcel:AddColumn("Registros","Notas Fiscais de Entrada (SD1)","Codigo Produto",1,1)
    oFWMsExcel:AddColumn("Registros","Notas Fiscais de Entrada (SD1)","Produto",1,1)
    oFWMsExcel:AddColumn("Registros","Notas Fiscais de Entrada (SD1)","Quantidade",1,1)
    oFWMsExcel:AddColumn("Registros","Notas Fiscais de Entrada (SD1)","Valor Un",1,1)
    oFWMsExcel:AddColumn("Registros","Notas Fiscais de Entrada (SD1)","Valor Total",1,1)
    oFWMsExcel:AddColumn("Registros","Notas Fiscais de Entrada (SD1)","UPI",1,1)
    oFWMsExcel:AddColumn("Registros","Notas Fiscais de Entrada (SD1)","ICMS",1,1)
    oFWMsExcel:AddColumn("Registros","Notas Fiscais de Entrada (SD1)","TES",1,1)
    oFWMsExcel:AddColumn("Registros","Notas Fiscais de Entrada (SD1)","CFOP",1,1)
    oFWMsExcel:AddColumn("Registros","Notas Fiscais de Entrada (SD1)","CC",1,1)
    oFWMsExcel:AddColumn("Registros","Notas Fiscais de Entrada (SD1)","Descr. CC",1,1)
    oFWMsExcel:AddColumn("Registros","Notas Fiscais de Entrada (SD1)","Cod. For",1,1)
    oFWMsExcel:AddColumn("Registros","Notas Fiscais de Entrada (SD1)","Loja For",1,1)
    oFWMsExcel:AddColumn("Registros","Notas Fiscais de Entrada (SD1)","Fornecedor",1,1)
    oFWMsExcel:AddColumn("Registros","Notas Fiscais de Entrada (SD1)","Aliq ICM",1,1)
    oFWMsExcel:AddColumn("Registros","Notas Fiscais de Entrada (SD1)","cod Conta  ",1,1)
    oFWMsExcel:AddColumn("Registros","Notas Fiscais de Entrada (SD1)","Descr. Conta",1,1)
    oFWMsExcel:AddColumn("Registros","Notas Fiscais de Entrada (SD1)","Classificação",1,1)
    oFWMsExcel:AddColumn("Registros","Notas Fiscais de Entrada (SD1)","BASIMP5",1,1)
    oFWMsExcel:AddColumn("Registros","Notas Fiscais de Entrada (SD1)","BASIMP6",1,1)
    oFWMsExcel:AddColumn("Registros","Notas Fiscais de Entrada (SD1)","VALIMP5",1,1)
    oFWMsExcel:AddColumn("Registros","Notas Fiscais de Entrada (SD1)","VALIMP6",1,1)

    //Criando as Linhas... Enquanto não for fim da query

    While !(cTMPSF1)->(EoF())
        //MsProcTxt("Analisando registro " + cValToChar(nAtual) + " de " + cValToChar(nTotal) + "...")

        oFWMsExcel:AddRow("Registros","Notas Fiscais de Entrada (SD1)",{;
            (cTMPSF1)->NFE_ENTRADA,;
            dtoc(stod((cTMPSF1)->DATA_EMISSAO)),;
            dtoc(stod((cTMPSF1)->DATA_DIGIT)),;//8,; //88 admin RLFATP23()
            (cTMPSF1)->FILIAL,;//8,; //88 admin RLFATP23()
            (cTMPSF1)->ITEM,;
            Alltrim((cTMPSF1)->COD_PRO),;
            Alltrim((cTMPSF1)->PRODUTO),;
            (cTMPSF1)->QUANTIDADE,;
            (cTMPSF1)->VALOR_UN,;
            (cTMPSF1)->VALOR_TOTAL,;
            (cTMPSF1)->IPI,;
            (cTMPSF1)->ICMS,;
            (cTMPSF1)->TES,;
            (cTMPSF1)->CFOP,;
            (cTMPSF1)->CC,;
            (cTMPSF1)->CENTRO_CUSTO,;
            (cTMPSF1)->COD_FOR,;
            (cTMPSF1)->LOJA,;
            Alltrim((cTMPSF1)->NOMEFORNECE),;
            (cTMPSF1)->ALIQ_ICM,;
            (cTMPSF1)->CONTA,;
            Alltrim((cTMPSF1)->NOME_CONTA),;
            (cTMPSF1)->CLASSIFICACAO,;
            (cTMPSF1)->BASIMP5,;
            (cTMPSF1)->BASIMP6,;
            (cTMPSF1)->VALIMP5,;
            (cTMPSF1)->VALIMP6 })
        (cTMPSF1)->(DbSkip())

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
    //fechando a area de trabalho
    (cTMPSF1)->(DbCloseArea())
    RestArea(aArea)

Return


/*/{Protheus.doc} ValidPerg

    Description

    @author  Igor Guimarães
    @example Example
    @param   [Parameter_Name],Parameter_type,Parameter_Description
    @return  Return
    @table   Tables
    @since   01-11-2021
/*/

Static Function ValidPerg()

    Local aRet   := {}
    Local aPergs := {}
    Local lRet   := .F.

    aAdd( aPergs ,{1,"Data de : ", CTOD(SPACE(8)),"",".T.","",".T.",75,.T. })
    aAdd( aPergs ,{1,"Data até : ", CTOD(SPACE(8)),"",".T.","",".T.",75,.T. })
    lRet := ParamBox(aPergs ,"Notas Fiscais",aRet)
Return lRet