#INCLUDE "totvs.ch"
#INCLUDE "protheus.ch"
#Include "TopConn.ch"
#INCLUDE "rwmake.ch"
#include 'fileio.ch

//-------------------------------------------------------------------
/* {Protheus.doc} AJUSTULMES
Essa rotina ajusta os parametros MV_ULMES das filiais de acordo com a Tabela SB9

@protected TSA
@author    Thiago Santos
@since     07/01/2022

Alteracoes Realizadas desde a Estruturacao Inicial
Data       Programador     Motivo
/*/
//-------------------------------------------------------------------

User Function TESTETABLE(cString1)

    Local cTabela := ""
    Local cContexto := ""

    MSGINFO( "Essa rotina localiza tabelas e campos baseado em regras de gatilhos", "Localiza tabelas" ) 
    
    If File("search_tables-"+cEmpAnt+".txt") 
        FErase("search_tables-"+cEmpAnt+".txt")
    EndIf
  
    nFile:=FCreate("search_tables-"+cEmpAnt+".txt")
    FWrite(nFile,"Usuário:"+cUserName+Chr(13)+Chr(10))
    FWrite(nFile,"Inicio do Ajuste:"+Dtoc(Date())+" - "+Time()+Chr(13)+Chr(10))




    DbSelectArea("SX7")
    DbSetOrder(1)
    dbGotop()
    
    While !SX7->(Eof()) // .and. alltrim(SX7->X7_REGRA) == cString1
        if Alltrim(SX7->X7_REGRA) == cString1

            
            IF RIGHT(LEFT(SX7->X7_CDOMIN,3),1) == '_'
                cTabela := "S"+LEFT(SX7->X7_CDOMIN,2)+cEmpAnt+"0"
            Else
                cTabela := LEFT(SX7->X7_CDOMIN,3)+cEmpAnt+"0"
            EndIf

            cContexto := Posicione("SX3",2,SX7->X7_CDOMIN,"X3_CONTEXT")
            if alltrim(cContexto) == "V"
                SX7->(dbSkip())
                loop
            Endif

            FWrite(nFile,cTabela+":"+alltrim(SX7->X7_CDOMIN)+Chr(13)+Chr(10))

        EndIf
        
        SX7->(dbSkip())
    End

    dbSelectArea("SX7")
	dbCloseArea()
    FClose(nFile)  
    MSGINFO( "Busca ealizada com sucesso! Arquivo de saida criado em system\search_tables-"+cEmpAnt+".txt", "Localiza tabelas" ) 

return

User Function AJUSTULMES() 
    Local cTemp := ""
    Local cQuery := "SELECT * FROM (SELECT TOP 1 B9_FILIAL,B9_DATA FROM "+RetSqlName("SB9")+" WHERE B9_FILIAL = '01' AND D_E_L_E_T_ = '' ORDER BY B9_DATA DESC) as t UNION ALL "
    cQuery	+= "SELECT * FROM (SELECT TOP 1 B9_FILIAL,B9_DATA FROM "+RetSqlName("SB9")+" WHERE B9_FILIAL = '02' AND D_E_L_E_T_ = '' ORDER BY B9_DATA DESC) as t UNION ALL "
    cQuery	+= "SELECT * FROM (SELECT TOP 1 B9_FILIAL,B9_DATA FROM "+RetSqlName("SB9")+" WHERE B9_FILIAL = '03' AND D_E_L_E_T_ = '' ORDER BY B9_DATA DESC) as t UNION ALL "
    cQuery	+= "SELECT * FROM (SELECT TOP 1 B9_FILIAL,B9_DATA FROM "+RetSqlName("SB9")+" WHERE B9_FILIAL = '04' AND D_E_L_E_T_ = '' ORDER BY B9_DATA DESC) as t UNION ALL "
    cQuery	+= "SELECT * FROM (SELECT TOP 1 B9_FILIAL,B9_DATA FROM "+RetSqlName("SB9")+" WHERE B9_FILIAL = '05' AND D_E_L_E_T_ = '' ORDER BY B9_DATA DESC) as t UNION ALL "
    cQuery	+= "SELECT * FROM (SELECT TOP 1 B9_FILIAL,B9_DATA FROM "+RetSqlName("SB9")+" WHERE B9_FILIAL = '06' AND D_E_L_E_T_ = '' ORDER BY B9_DATA DESC) as t UNION ALL "
    cQuery	+= "SELECT * FROM (SELECT TOP 1 B9_FILIAL,B9_DATA FROM "+RetSqlName("SB9")+" WHERE B9_FILIAL = '07' AND D_E_L_E_T_ = '' ORDER BY B9_DATA DESC) as t UNION ALL "
    cQuery	+= "SELECT * FROM (SELECT TOP 1 B9_FILIAL,B9_DATA FROM "+RetSqlName("SB9")+" WHERE B9_FILIAL = '20' AND D_E_L_E_T_ = '' ORDER BY B9_DATA DESC) as t UNION ALL "
    cQuery	+= "SELECT * FROM (SELECT TOP 1 B9_FILIAL,B9_DATA FROM "+RetSqlName("SB9")+" WHERE B9_FILIAL = '21' AND D_E_L_E_T_ = '' ORDER BY B9_DATA DESC) as t UNION ALL "
    cQuery	+= "SELECT * FROM (SELECT TOP 1 B9_FILIAL,B9_DATA FROM "+RetSqlName("SB9")+" WHERE B9_FILIAL = '22' AND D_E_L_E_T_ = '' ORDER BY B9_DATA DESC) as t UNION ALL "
    cQuery	+= "SELECT * FROM (SELECT TOP 1 B9_FILIAL,B9_DATA FROM "+RetSqlName("SB9")+" WHERE B9_FILIAL = '23' AND D_E_L_E_T_ = '' ORDER BY B9_DATA DESC) as t UNION ALL "
    cQuery	+= "SELECT * FROM (SELECT TOP 1 B9_FILIAL,B9_DATA FROM "+RetSqlName("SB9")+" WHERE B9_FILIAL = '24' AND D_E_L_E_T_ = '' ORDER BY B9_DATA DESC) as t UNION ALL "
    cQuery	+= "SELECT * FROM (SELECT TOP 1 B9_FILIAL,B9_DATA FROM "+RetSqlName("SB9")+" WHERE B9_FILIAL = '25' AND D_E_L_E_T_ = '' ORDER BY B9_DATA DESC) as t UNION ALL "
    cQuery	+= "SELECT * FROM (SELECT TOP 1 B9_FILIAL,B9_DATA FROM "+RetSqlName("SB9")+" WHERE B9_FILIAL = '26' AND D_E_L_E_T_ = '' ORDER BY B9_DATA DESC) as t UNION ALL "
    cQuery	+= "SELECT * FROM (SELECT TOP 1 B9_FILIAL,B9_DATA FROM "+RetSqlName("SB9")+" WHERE B9_FILIAL = '27' AND D_E_L_E_T_ = '' ORDER BY B9_DATA DESC) as t UNION ALL "
    cQuery	+= "SELECT * FROM (SELECT TOP 1 B9_FILIAL,B9_DATA FROM "+RetSqlName("SB9")+" WHERE B9_FILIAL = '28' AND D_E_L_E_T_ = '' ORDER BY B9_DATA DESC) as t UNION ALL "
    cQuery	+= "SELECT * FROM (SELECT TOP 1 B9_FILIAL,B9_DATA FROM "+RetSqlName("SB9")+" WHERE B9_FILIAL = '29' AND D_E_L_E_T_ = '' ORDER BY B9_DATA DESC) as t UNION ALL "
    cQuery	+= "SELECT * FROM (SELECT TOP 1 B9_FILIAL,B9_DATA FROM "+RetSqlName("SB9")+" WHERE B9_FILIAL = '30' AND D_E_L_E_T_ = '' ORDER BY B9_DATA DESC) as t UNION ALL "
    cQuery	+= "SELECT * FROM (SELECT TOP 1 B9_FILIAL,B9_DATA FROM "+RetSqlName("SB9")+" WHERE B9_FILIAL = '31' AND D_E_L_E_T_ = '' ORDER BY B9_DATA DESC) as t UNION ALL "
    cQuery	+= "SELECT * FROM (SELECT TOP 1 B9_FILIAL,B9_DATA FROM "+RetSqlName("SB9")+" WHERE B9_FILIAL = '32' AND D_E_L_E_T_ = '' ORDER BY B9_DATA DESC) as t UNION ALL "
    cQuery	+= "SELECT * FROM (SELECT TOP 1 B9_FILIAL,B9_DATA FROM "+RetSqlName("SB9")+" WHERE B9_FILIAL = '33' AND D_E_L_E_T_ = '' ORDER BY B9_DATA DESC) as t UNION ALL "
    cQuery	+= "SELECT * FROM (SELECT TOP 1 B9_FILIAL,B9_DATA FROM "+RetSqlName("SB9")+" WHERE B9_FILIAL = '34' AND D_E_L_E_T_ = '' ORDER BY B9_DATA DESC) as t UNION ALL "
    cQuery	+= "SELECT * FROM (SELECT TOP 1 B9_FILIAL,B9_DATA FROM "+RetSqlName("SB9")+" WHERE B9_FILIAL = '35' AND D_E_L_E_T_ = '' ORDER BY B9_DATA DESC) as t UNION ALL "
    cQuery	+= "SELECT * FROM (SELECT TOP 1 B9_FILIAL,B9_DATA FROM "+RetSqlName("SB9")+" WHERE B9_FILIAL = '36' AND D_E_L_E_T_ = '' ORDER BY B9_DATA DESC) as t"
	
    MSGINFO( "Essa rotina ajusta os parametros MV_ULMES das filiais de acordo com a Tabela SB9", "Ajuste de parâmetro" ) 
    
    If File("AjustaSb9-"+cEmpAnt+".txt") 
        FErase("AjustaSb9-"+cEmpAnt+".txt")
    EndIf

    nFile:=FCreate("AjustaSb9-"+cEmpAnt+".txt")
    FWrite(nFile,"Usuário:"+cUserName+Chr(13)+Chr(10))
    FWrite(nFile,"Inicio do Ajuste:"+Dtoc(Date())+" - "+Time()+Chr(13)+Chr(10))
    
	TcQuery cQuery Alias ZSB9 New
	dbSelectArea("ZSB9")

	While !ZSB9->(Eof())

        DbSelectArea("SX6")
        DbSetOrder(1) 

        If DbSeek(ZSB9->B9_FILIAL+"MV_ULMES")

            if Alltrim(SX6->X6_CONTEUD) != ZSB9->B9_DATA
                cTemp :=  Alltrim(SX6->X6_CONTEUD)
                RecLock("SX6",.F.)
                SX6->X6_CONTEUD := ZSB9->B9_DATA
                MsUnLock() 
                FWrite(nFile,ZSB9->B9_FILIAL+" : "+Alltrim(SX6->X6_CONTEUD)+"(Anterior:"+cTemp+")"+Chr(13)+Chr(10))
            else
                FWrite(nFile,ZSB9->B9_FILIAL+" : "+Alltrim(SX6->X6_CONTEUD)+"(Nao alterado)"+Chr(13)+Chr(10))
            EndIf
        
        EndIf
        

		ZSB9->(dbSkip())

	EndDo
	
	dbSelectArea("ZSB9")
	dbCloseArea()
    FClose(nFile)  
    MSGINFO( "Ajuste realizado com sucesso! Arquivo de saida criado em system\AjustaSb9-"+cEmpAnt+".txt", "Ajuste de parâmetro" ) 

Return .T.

