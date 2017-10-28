#INCLUDE "PROTHEUS.CH"
#include "topconn.ch"  
#include "Ap5mail.ch"  
                                                                          
/* 
 * @Descrição
 *			   	Permite realizar o rateio das horas na tabela FIPEPC de acordo com as verbas cadastradas
 *			   	Depende da consulta SZ2_CO que retorna o número do contrato formatado no formato 
 *			   	A0000-00-0000A       
 * @Alterado por: Leandro P J Monteiro 		leandro@cntecnologia.com.br		
 * @Alterações	17/07/2013 Alterado o fonte para permitir a inserção de novos registros no FIPEPC 
 * @Alterações  31/07/2013 Alterado para considerar horas fracionadas
 * @Alterações  25/10/2013 Alterado para chamar a Função RATFIP01.prw, que é unica entre os lançamentos
 * 				mensais (SRC) e lançamentos de Rescisão(SRR)
 * @Alterações  03/11/2016 Remoção de blocos não utilizados do PRW. ThiagoSantos
 ****************************************************************************************/
User Function GP090ALT
	
	// VERIFICA SE A MATRICULA EM EDIÇÃO POSSUIR VERBAR PARA RATEIO 
	U_RatFip01("RGB","FOL") 

Return
