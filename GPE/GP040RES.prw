/* 
 * @Descrição:	Ponto de Entrada Localizado após a gravação do cálculo da rescisão.
 *				Utilizado para chamar a rotina de rateio das horas.
 * @Data		25/10/2013
 * @Desenv		Leandro P J Monteiro - leandro@cntecnologia.com.br
 */
User Function GP040RES
	// Verifica se existe rateio de horas a ser realizado
	U_RatFip01("RGB","RES") 
Return