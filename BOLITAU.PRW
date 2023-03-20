#INCLUDE "RWMAKE.CH"
#include 'fivewin.ch'
#include 'topconn.ch'
//teste 01
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ BLITAU   ºAutor ³ Valtenio - Totvs    º Data ³  15/07/15   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ BOLETO BANCARIO ( Imprime o boleto ITAU ) 	              º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ COOPADUBO	                                              º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß

aParametros[1]   //Do Prefixo         
aParametros[2]   //At‚ o Prefixo      
aParametros[3]   //Do T¡tulo          
aParametros[4]   //At‚ o T¡tulo       
aParametros[5]   //Do Banco           
aParametros[6]   //At‚ o Banco        
aParametros[7]   //Do Cliente         
aParametros[8]   //At‚ o Cliente      
aParametros[9]   //Da Loja            
aParametros[10]  //At‚ a Loja         
aParametros[11]  //Do Vencimento      
aParametros[12]  //At‚ o Vencimento   
aParametros[13]  //Da Emiss„o         
aParametros[14]  //At‚ a Emiss„o      
aParametros[15]  //Selecionar T¡tulos 
aParametros[16]  //Do Bordero         
aParametros[17]  //At‚ o Bordero      

aParametros[18]	//Banco para transferencia, caso o título ainda não tenha sido transferido.
aParametros[19] //Agencia
aParametros[20] //Conta
aParametros[21] //Tipo de Cobrança, só serão aceitas 1-Simples ou 4-Vinculada/Registrada

aParametros[22] //Inibe a exibição da tela de seleção dos títulos.
aParametros[23] //Tipo de Impressão 1=Laser, 2=Deskjet (Passar como numerico)

*/

User Function BOLITAU()
//User Function BLITAU(_aTitulos1)

Local	cQuery		:= ''
Local	aArea 		:= GetArea()
Local	aAreaSE1	:= SE1->(GetArea())
Local	aAreaSX5	:= SX5->(GetArea())
		
Local	oBcoOrig    
Local   oCboBox
Local   aSituacoes  := {}
Local   cCapital    := Space(55)
Local 	cMvBcoBol	:= Space(20)
Local 	nI			:= 0
Local	nP			:= 0
Local aImpBol := {}

Private cSituaca    := Space(25)
Private cBcoOrig    := Space(3)
Private	cAgenOrig   := Space(5)
Private	cCtaOrig    := Space(10)
Private cNomeBco    := Space(40)
Private	lExec    	:= .F.
Private	nQtdReg		:= 0
Private	cPerg     	:= 'BLITAU'
Private	cArqTemp	:= Criatrab(Nil,.F.)
Private	aCpoBro 	:= {}
Private	lInverte	:= .T.
Private	cMarca    	:= GetMark()
Private	lEnd		:= .f.
Private lPortador   := .f.
Private lSituacao   := .f.
Private _Quebra     := CHAR(13) + CHAR(10)
Private lInibeTela  := .f.
Private aParametros := {}
IF !Empty(aImpBol)
   aParametros:=aImpBol
ENDIF   

//DEFAULT aParametros := {}

		//AjustaSx1(cPerg)

		If Len(aParametros) = 0
			If	( !Pergunte(cPerg,.T.) )
			
			Return
			EndIf
		Else
			Pergunte(cPerg,.F.)
			//Carrega os parametros pelo array passado.	

			mv_par01 := aParametros[1]               //Do Prefixo         
			mv_par02 := aParametros[2]               //At‚ o Prefixo      
			mv_par03 := aParametros[3]               //Do T¡tulo          
			mv_par04 := aParametros[4]               //At‚ o T¡tulo       
			mv_par05 := aParametros[5]               //Do Banco           
			mv_par06 := aParametros[6]               //At‚ o Banco        
			mv_par07 := aParametros[7]               //Do Cliente         
			mv_par08 := aParametros[8]               //At‚ o Cliente      
			mv_par09 := aParametros[9]               //Da Loja            
			mv_par10 := aParametros[10]               //At‚ a Loja         
			mv_par11 := aParametros[11]               //Do Vencimento      
			mv_par12 := aParametros[12]               //At‚ o Vencimento   
			mv_par13 := aParametros[13]               //Da Emiss„o         
			mv_par14 := aParametros[14]               //At‚ a Emiss„o      
			mv_par15 := aParametros[15]               //Selecionar T¡tulos 
			mv_par16 := aParametros[16]               //Do Bordero         
			mv_par17 := aParametros[17]               //At‚ o Bordero      
			mv_par18 := aParametros[18]              ////Tipo de Impressão  
			mv_par19 := aParametros[19]              //Tipo de Titulo de
			mv_par20 := aParametros[20]              //Ate o Tipo de Titulo


			If Empty(cBcoOrig) //se o parametro banco estiver vazio, Seleciona o banco padrão para emissão. 
				
				cMvBcoBol := '341'//GetMV('MV_BCOBOL')
				
				If Empty(cMvBcoBol)				
					IW_MSGBOX('Banco padrão para transferência não informado! Verifique o Parâmetro MV_BCOBOL','Atenção', "STOP")
					Return						
				Else
					nP := 0
					For nI := 1 to Len(AllTrim(cMvBcoBol))
					    if !(Substr(cMvBcoBol,nI,1) $ '/|#!')
							Do Case 
								Case nP == 0
									cBcoOrig := AllTrim(cBcoOrig) + Substr(cMvBcoBol,nI,1)
								Case nP == 1
									cAgenOrig:= AllTrim(cAGenOrig) + Substr(cMvBcoBol,nI,1)
								Case nP == 2
									cCtaOrig := AllTrim(cCtaOrig) + Substr(cMvBcoBol,nI,1)
							EndCase
					    Else
					        nP++
					    EndIf	
					Next
				EndIf
				
				cQuery := "SELECT * "
				cQuery += "FROM "+ RetSQLName("SA6") + "  "
				cQuery += "WHERE  D_E_L_E_T_ != '*'   AND "
				cQuery += "		  A6_COD = '" + AllTrim(cBcoOrig) + "' AND " 
				cQuery += "		  A6_AGENCIA = '" + AllTrim(cAgenOrig) + "' AND " 
				cQuery += "		  A6_NUMCON = '" + AllTrim(cCtaOrig) + "' " 								
				
				If Select("BCO") > 0
					DBSelectArea("BCO")
					BCO->(DbCloseArea())
				EndIf
				TCQUERY cQuery NEW ALIAS "BCO"
				
				DBSelectArea("BCO")
				DBGoTop() 				
                
				if Empty("BCO")
					IW_MSGBOX('Banco padrão para transferência não Localizado! Verifique o Parâmetro MV_BCOBOL','Atenção', "STOP")
					Return						
				EndIf				     
			
				BCO->(DbCloseArea())
				
				DbSelectArea("SX5")   
				If (dbSeek(xFilial("SX5")+"07"+"4"))
					cSituaca:= "4"+' '+SX5->X5_DESCRI //Tipo de Cobrança ( 1 ou 4 )
				Else
					IW_MSGBOX('Situacao para transferencia nao localizado, verifique o parametro MV_SITBOL','Atenção', "STOP")
					Return										
				EndIf

			Else
				//cBcoOrig := aParametros[18]               //Banco de Transferencia
				//cAGenOrig:= aParametros[19]               //AGencia de Transferencia
				//cCtaOrig := aParametros[20]               //Conta de Transferencia
				
				DbSelectArea("SX5")   
				If (dbSeek(xFilial("SX5")+"07"+"4"))
					cSituaca:= "4"+' '+SX5->X5_DESCRI //Tipo de Cobrança ( 1 ou 4 )
				Else
					IW_MSGBOX('Situacao para transferencia nao localizado, verifique o parametro MV_SITBOL','Atenção', "STOP")
					Return										
				EndIf
			End			
		
			//Se não houver nenhum banco informado, não pode inibir a tela.
			If !Empty(cBcoOrig)
				lInibeTela := .F.
			Else
				lInibeTela := .F.
			EndIf
		
		EndIf
	
		//Seta se vai trazer os titulos selecinados ou nao.
		lInverte := ( mv_par15 = 1 )

		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Monta a tabela de situaçöes de Títulos                                                                                                                                  ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		dbSelectArea("SX5")
		dbSeek(xFilial('SX5')+"07")
		While SX5->X5_FILIAL+SX5->X5_tabela == xFilial('SX5')+"07"
		   cCapital := Capital(X5Descri())
		   AADD( aSituacoes , SubStr(SX5->X5_CHAVE,1,2)+OemToAnsi(SubStr(cCapital,1,20)))
		   dbSkip()
		EndDo

		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³Campos que serao mostrados no browse.³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		aCpoBro :=	{	{'E1_OK',,OemToAnsi(' '),' '},;
						{'E1_PREFIXO',,OemToAnsi('Prefixo'),'@!'},;
                   		{'E1_NUM',,OemToAnsi('Numero'),'@!'},; 
                   		{'E1_NUMBOR',,OemToAnsi('Num. Bordero'),'@!'},;
                   		{'E1_PARCELA',,OemToAnsi('Parcela'),'@!'},;
                   		{'E1_TIPO',,OemToAnsi('Tipo'),'@!'},;
                   		{'A1_COD',,OemToAnsi('Cliente'),'@!'},;
                   		{'A1_LOJA',,OemToAnsi('Loja'),'@!'},;
                   		{'A1_NOME',,OemToAnsi('Nome'),'@!'},;
                   		{'E1_NUMBCO',,OemToAnsi('Num. Banco'),'@!'},;
                   		{'E1_PORTADO',,OemToAnsi('Portador'),'@!'},;
                   		{'E1_AGEDEP',,OemToAnsi('Ag. Dep.'),'@!'},;
                   		{'E1_CONTA',,OemToAnsi('Conta'),'@!'}	}

		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³Monta a query com os registros a serem marcados.!³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		cQuery	:= "SELECT SE1.E1_OK, "
		cQuery	+= "SE1.E1_PREFIXO, "
		cQuery	+= "SE1.E1_NUM, "
		cQuery	+= "SE1.E1_NUMBOR, "
		cQuery	+= "SE1.E1_PARCELA, "
		cQuery	+= "SE1.E1_TIPO, "
		cQuery	+= "SA1.A1_COD, "		
		cQuery	+= "SA1.A1_LOJA, "
		cQuery	+= "SA1.A1_NOME, "
		cQuery	+= "SE1.E1_NUMBCO, "
		cQuery	+= "SE1.E1_PORTADO, "
		cQuery	+= "SE1.E1_AGEDEP, "
		cQuery	+= "SE1.E1_CONTA, "
		cQuery	+= "SA1.A1_INSCR, "
		cQuery	+= "SA1.A1_CGC "
		cQuery	+= "FROM " + RetSqlName('SE1') + ' SE1, ' + RetSqlName('SA1') + ' SA1 '
		cQuery	+= "WHERE SA1.A1_COD =  SE1.E1_CLIENTE "
		cQuery	+= "AND SA1.A1_LOJA = SE1.E1_LOJA "
		cQuery	+= "AND SE1.E1_FILIAL = '" + xFilial('SE1') + "' "
		cQuery	+= "AND SE1.E1_EMISSAO >= '" + Dtos(mv_par13) + "' "
		cQuery	+= "AND SE1.E1_EMISSAO <= '" + Dtos(mv_par14) + "' "
		cQuery	+= "AND SE1.E1_PREFIXO >= '" + mv_par01 + "' "
		cQuery	+= "AND SE1.E1_PREFIXO <= '" + mv_par02 + "' "
		cQuery	+= "AND SE1.E1_NUM >= '" + mv_par03 + "' "
		cQuery	+= "AND SE1.E1_NUM <= '" + mv_par04 + "' "
		cQuery	+= "AND SE1.E1_NUMBOR >= '" + mv_par16 + "' "
		cQuery	+= "AND SE1.E1_NUMBOR <= '" + mv_par17 + "' "
		cQuery	+= "AND SE1.E1_PORTADO >= '" + mv_par05 + "' "
		cQuery	+= "AND SE1.E1_PORTADO <= '" + mv_par06 + "' "
		cQuery	+= "AND SE1.E1_CLIENTE >= '" + mv_par07 + "' "
		cQuery	+= "AND SE1.E1_CLIENTE <= '" + mv_par08 + "' "
		cQuery	+= "AND SE1.E1_LOJA >= '" + mv_par09 + "' "
		cQuery	+= "AND SE1.E1_LOJA <= '" + mv_par10 + "' "
		cQuery	+= "AND SE1.E1_VENCTO >= '" + Dtos(mv_par11) + "' "
		cQuery	+= "AND SE1.E1_VENCTO <= '" + Dtos(mv_par12) + "' "
		cQuery	+= "AND SE1.E1_TIPO >= '" + mv_par19 + "' "
		cQuery	+= "AND SE1.E1_TIPO <= '" + mv_par20 + "' "
		cQuery	+= "AND SE1.E1_SALDO > 0 "
		cQuery	+= "AND SE1.D_E_L_E_T_ <> '*' "
		cQuery	+= "AND SA1.A1_FILIAL = '" + xFilial('SA1') + "' "
		cQuery	+= "AND SA1.D_E_L_E_T_ <> '*' "
		cQuery	+= "ORDER BY SA1.A1_FILIAL, SA1.A1_NOME, SE1.E1_PREFIXO, SE1.E1_NUM, SE1.E1_PARCELA, SE1.E1_TIPO "
		cQuery	:= ChangeQuery(cQuery)
		DbUseArea(.T.,"TOPCONN",TCGenQry(,,cQuery),'TRA',.F.) //DbUseArea(.T.,"TOPCONN",TCGenQry(,,cQuery),'TRA',.F.,.T.
		//Processa({||SqlToTrb(cQuery, aEstr, "TRA")}) // Cria arquivo temporario

		DbSelectArea('TRA')
		Count to nQtdReg
		TRA->(DbGoTop())

		Copy to &cArqTemp

		TRA->(DbCloseArea())

		DbUseArea(.t.,,cArqTemp,'TRA',Nil,.f.)
		TRA->(DbGoTop())

		cSituaca:= "1"
		        
		If !lInibeTela
			DEFINE MSDIALOG oDlg TITLE OemToAnsi('Seleção dos Títulos para impressão dos Boletos.') From 001,001 To 400,700 Of oMainWnd Pixel
		 	oMark:=MsSelect():New('TRA','E1_OK',,aCpoBro,@lInverte,@cMarca,{5,5,165,345})
		 	oMark:oBrowse:Refresh()
	       
			//@ 170, 010 SAY 'Banco/Agência/Conta para transferência' OF oDlg PIXEL 
			//@ 170, 185 SAY 'Situação' OF oDlg PIXEL 
			//@ 180, 010 MSGET oBcoOrig VAR cBcoOrig  Picture "@S3"  F3 "SA6" Valid {|| CarregaSa6(@cBcoOrig,@cAgenOrig,@cCtaOrig,.F.,,.F.), cNomeBco := If( AllTrim(cBcoOrig) <> '', Posicione('SA6',1,xFilial('SA6')+cBcoOrig+cAgenOrig+cCtaOrig,'A6_NOME') , '' ) }  SIZE 25, 08 OF oDlg PIXEL
			//@ 180, 039 MSGET cAgenOrig              Picture "@S5"           WHEN .F. Valid {|| CarregaSa6(@cBcoOrig,@cAgenOrig,@cCtaOrig,.F.,,.T.),.F.}                          SIZE 20, 08 OF oDlg PIXEL
			//@ 180, 068 MSGET cCtaOrig               Picture "@S10"          WHEN .F. Valid {|| If(CarregaSa6(@cBcoOrig,@cAgenOrig,@cCtaOrig,.F.,,.T.),.T.,oBcoOrig:SetFocus()),.F.} SIZE 45, 08 OF oDlg PIXEL
		  	//@ 180, 113 MSGET cNomeBco               WHEN {|| cNomeBco := If( AllTrim(cBcoOrig) <> '', Posicione('SA6',1,xFilial('SA6')+cBcoOrig+cAgenOrig+cCtaOrig,'A6_NOME') , '' ), .F. } SIZE 70,08 OF oDlg PIXEL
		  	@ 180, 185 COMBOBOX oCboBox VAR cSituaca ITEMS aSituacoes WHEN IF( Len(aParametros) >= 18 , AllTrim(aParametros[18])=='' , .T. ) Size 82,46 OF oDlg PIXEL
			
			DEFINE SBUTTON FROM 180, 280 TYPE 01 ACTION (If(TudoOK(oDlg),(lExec:=.T.,oDlg:End()),lExec:=.F.)) ENABLE Of oDlg
			DEFINE SBUTTON FROM 180, 310 TYPE 02 ACTION (lExec:=.F.,oDlg:End()) ENABLE Of oDlg
			ACTIVATE MSDIALOG oDlg CENTERED
		Else
		    lExec := .T.
		EndIf
	
		TRA->(DbGoTop())

		If	lExec
			Processa({ |lEnd| MontaRel()})
		EndIf

		TRA->(DbCloseArea())

		RetIndex("SE1")
		Ferase(cArqTemp+GetDbExtension())

		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³Retoma a area anterior ao processamento. !³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		RestArea(aAreaSX5)
		RestArea(aAreaSE1)
		RestArea(aArea)

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ MONTAREL ºAutor ³ Valtenio Moura      º Data ³  15/07/15   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ IMPRESSAO DO BOLETO LASER COM CODIGO DE BARRAS             º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Funcao Principal                                           º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDATA      ³ ANALISTA ³  MOTIVO                                         º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±º          ³          ³                                                 º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Static Function MontaRel()
Local	oPrint		
Local	nX			:= 0
Local	cNroDoc 	:= ' '
Local	cConvenio	:= ''
Local	cSeqCart	:= ''
Local	cCarteira	:= ''
Local	cCompCart   := ''
Local	cDigCta     := ''
Local	aDadosEmp	:= {SM0->M0_NOMECOM,; //[1]Nome da Empresa
						SM0->M0_ENDCOB,; //[2]Endereço
						AllTrim(SM0->M0_BAIRCOB)+', '+AllTrim(SM0->M0_CIDCOB)+', '+SM0->M0_ESTCOB ,; //[3]Complemento
						'CEP: '+Subs(SM0->M0_CEPCOB,1,5)+'-'+Subs(SM0->M0_CEPCOB,6,3),; //[4]CEP
						'PABX/FAX: '+SM0->M0_TEL,; //[5]Telefones
						'CNPJ: '+Subs(SM0->M0_CGC,1,2)+'.'+Subs(SM0->M0_CGC,3,3)+'.'+; //[6]
						Subs(SM0->M0_CGC,6,3)+'/'+Subs(SM0->M0_CGC,9,4)+'-'+; //[6]
						Subs(SM0->M0_CGC,13,2),; //[6]CGC
						'I.E.: '+Subs(SM0->M0_INSC,1,3)+'.'+Subs(SM0->M0_INSC,4,3)+'.'+; //[7]
						Subs(SM0->M0_INSC,7,3)+'.'+Subs(SM0->M0_INSC,10,3)}  //[7]I.E
Local	aDadosTit	:= {}
Local	aDadosBanco := {}
Local	aDatSacado  := {}
Local	aBolText    := {}
Local	nI          := 1
Local	aCB_RN_NN   := {}
Local	nVlrAbat	:= 0
Local	cQuery      := ''
Local	cSituant    := ''

Private	aDadosFat	:= {}	// Dados da Fatura

		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³Inicia o processo de impressao dos boletos. !³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		If (Len(aParametros) = 0) .OR. (Len(aParametros) <> 0)// .AND. (GetMV('MV_IMPBOL') <> '3')) 
			oPrint := TMSPrinter():New('Impressão de Boleto Bancário')
			oPrint:SetPortrait() // ou SetLandscape()
			oPrint:StartPage()   // Inicia uma nova página		
		EndIF
		
		TRA->(DbGoTop())
		ProcRegua(nQtdReg)

		While	TRA->( ! Eof() )

				If	( lEnd )
					If	MsgYesNo(OemToAnsi('Deseja abortar impressão ?'))
						Exit
						Return
					EndIf
				EndIf

				If	TRA->(Marked('E1_OK'))

					//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
					//³Posiciona no titulo que sera processado.!³
					//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
					DbSelectArea('SE1')
					SE1->(DbSetOrder(1))
					If	! SE1->(DbSeek(xFilial('SE1') + TRA->(E1_PREFIXO+E1_NUM+E1_PARCELA+E1_TIPO)))
						TRA->(DbSkip())
						Loop
					EndIf

					//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
					//³Verifica a carteira do titulo !³
					//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
					If	'341' == (SE1->E1_PORTADOR)// .or. ( (SE1->E1_PORTADOR <> cBcoOrig) .and. !Empty(cBcoOrig) ), cBcoOrig, SE1->E1_PORTADOR )
						//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
						//³BANCO ITAU       ³
						//³??? - SIMPLES    ³
						//³109 - REGISTRADO ³
						//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
						cCarteira	:= '175' //Iif( (IF( Empty(SE1->E1_SITUAC2) .or. ( (SE1->E1_SITUAC2 <> Substr(cSituaca,1,1)) .and. !Empty(cSituaca) ), Substr(cSituaca,1,1), SE1->E1_SITUAC2 )) == '1','000','109')						
					EndIf

					//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
					//³Posiciona na Arq de Parametros CNAB para ver se há informacoes      ³
					// Verifica se o Título já tem portador, senão pega o da transferencia.³
					//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
					DbSelectArea('SEE')
					SEE->(DbSetOrder(1))

					If Empty(SE1->E1_PORTADOR) .or. ( (SE1->E1_PORTADOR <> cBcoOrig) .and. !Empty(cBcoOrig) )
						IF !SEE->(DbSeek(xFilial('SEE')+SE1->(cBcoOrig+cAgenOrig+Padr(cCtaOrig,10,space(1))+padr(cCarteira,2,space(1))),.T.))
							IW_MSGBOX('Atenção, Bco/Ag/Cta [' + cBcoOrig + '/' + cAgenOrig +'/' + AllTrim(cCtaOrig) + '], da carteira ['+ cCarteira + '] Não possui parâmetros cadastrados !, Favor Veriricar!','Atenção', "STOP")
							Exit
							Return						
						EndIf
					Else
						IF !SEE->(DbSeek(xFilial('SEE')+SE1->(E1_PORTADO+E1_AGEDEP+E1_CONTA+"R01"),.T.))
							IW_MSGBOX('Atenção, Bco/Ag/Cta [' + SE1->E1_PORTADOR + '/' + SE1->E1_AGEDEP +'/' + AllTrim(SE1->E1_CONTA) + '], da carteira VMO ['+ cCarteira + '] Não possui parâmetros cadastrados !, Favor Veriricar!','Atenção', "STOP")
							Exit
							Return						
						EndIf
					EndIf					

					//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
					//³Verifica Faixa Inicial e Final de Impressão           ³
					//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
                    If (VAL(SEE->EE_FAXATU) < VAL(SEE->EE_FAXINI)) .OR. (VAL(SEE->EE_FAXATU) > VAL(SEE->EE_FAXFIM))
						IW_MSGBOX('Atenção, Bco/Ag/Cta [' + SE1->E1_PORTADOR + '/' + SE1->E1_AGEDEP +'/' + AllTrim(SE1->E1_CONTA) + '], da carteira ['+ cCarteira + '] esgotou a faixa de impressão!, Favor Veriricar!','Atenção', "STOP")
						Exit
						Return						                    
                    EndIf


					//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
					//³Transfere o titulo para o portador informado caso seja³
					//³necessário.                                           ³
					//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
					If Empty(SE1->E1_PORTADOR) .or. ( (SE1->E1_PORTADOR <> cBcoOrig) .and. !Empty(cBcoOrig) )
						cSituant := SE1->E1_SITUAC
						RecLock('SE1',.f.)
						Replace SE1->E1_PORTADO With cBcoOrig
						Replace SE1->E1_AGEDEP  With cAgenOrig
						Replace SE1->E1_CONTA   With cCtaOrig
						If SE1->E1_SITUAC <> Substr(cSituaca,1,1)
							Replace SE1->E1_SITUAC With Substr(cSituaca,1,1)
						Endif
						SE1->(MsUnlock())

						//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
						//³Grava a transferencia do titulo na tabela de titulos  ³
						//³enviados ao banco (                                   ³
						//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ					
						cQuery := "SET TRANSACTION ISOLATION LEVEL SERIALIZABLE "
						cQuery += "BEGIN TRAN "
						cQuery += "INSERT INTO " + RetSqlName('SEA')
						cQuery += "( EA_FILIAL, EA_PREFIXO, EA_NUM, EA_PARCELA, EA_PORTADO, EA_AGEDEP, EA_TIPO, EA_CART, EA_NUMCON, EA_SITUACA, EA_SITUANT, R_E_C_N_O_ )"
						cQuery += "SELECT "
						cQuery += "'" + xFilial('SEA') + "', "
						cQuery += "'" + SE1->E1_PREFIXO + "', "
						cQuery += "'" + SE1->E1_NUM + "', "
						cQuery += "'" + SE1->E1_PARCELA + "', "
						cQuery += "'" + SE1->E1_PORTADO + "', "
						cQuery += "'" + SE1->E1_AGEDEP + "', "
						cQuery += "'" + SE1->E1_TIPO + "', "
						cQuery += "'R', "
						cQuery += "'" + SE1->E1_CONTA + "', "
						cQuery += "'" + SE1->E1_SITUACA + "', "
						cQuery += "'" + cSituant + "', "
						cQuery += "(SELECT MAX(R_E_C_N_O_)+1 FROM " + RetSqlName('SEA') + "), "
						cQuery += "COMMIT "
						cQuery += "SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED "
						
						TcSQLExec( cQuery )
					End 

					//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
					//³Verifica se o sistema esta preparado ou nao para imprimir³
					//³dependendo do portador...                                ³
					//³Este RdMake Imprime boletos dos seguintes banco...       ³
					//³ Brasil, Bradesco, Itau, Real                            ³
					//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
					If	( ! SE1->E1_PORTADO $ '001/237/341/356' )// .or. ( ! SE1->E1_SITUAC2 $ '14' )
						Alert(OemToAnsi('O Titulo: '+SE1->E1_PREFIXO+SE1->E1_NUM+SE1->E1_PARCELA+SE1->E1_TIPO+', não está preparado para impressão. Verifique o Portador do titulo.'))
						TRA->(DbSkip())
						Loop
					EndIf

					//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
					//³Posiciona o SA6 (Bancos)³
					//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
					DbSelectArea('SA6')
					SA6->(DbSetOrder(1))
					SA6->(DbSeek(xFilial('SA6') + SE1->E1_PORTADO + SE1->E1_AGEDEP + SE1->E1_CONTA,.T.))

					//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
					//³Posiciona na Arq de Parametros CNAB³
					//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
					DbSelectArea('SEE')
					SEE->(DbSetOrder(1))
					SEE->(DbSeek(xFilial('SEE')+SE1->(E1_PORTADO+E1_AGEDEP+E1_CONTA+"R01"),.T.))
                    
					//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
					//³Aqui defino parte do nosso numero. Sao 8 digitos para identificar o titulo. ³
					//³Abaixo apenas uma sugestao                                                  ³
					//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
					If	( Empty(SE1->E1_NUMBCO) )

						Do Case
						   	Case SEE->EE_CODIGO $ '001/237'
								cConvenio	:= AllTrim(SEE->EE_CODEMP)
								cSeqCart	:= Padl(AllTrim(SEE->EE_FAXATU),12,'0')
							Case SEE->EE_CODIGO = '341'
								cConvenio	:= "175"//AllTrim(SEE->EE_SUBCTA)
								cSeqCart	:= Padl(AllTrim(SEE->EE_FAXATU),12,'0')							    
							Case SEE->EE_CODIGO = '356'
								cSeqCart	:= Padl(AllTrim(SEE->EE_FAXATU),12,'0')							    
						End Case

						//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
						//³Atualiza a tabela com o numero do proximo boleto. !³
						//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
						If RecLock('SEE',.F.)
						   Replace SEE->EE_FAXATU With Soma1(cSeqCart)
						   MsUnLock()
						Else
						   Help('',1,'REGNOIS')
						EndIf
						
						Do Case
						   	Case SEE->EE_CODIGO $ '001/237/341'
								cNroDoc		:= cConvenio + StrZero(Val(Substr(cSeqCart,8,6)),11-Len(cConvenio))
							Case SEE->EE_CODIGO = '356'
								cNroDoc		:= StrZero(Val(Substr(cSeqCart,8,6)),7)							
						End Do
					Else
						cNroDoc		:= SE1->E1_NUMBCO
					EndIf

					//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
					//³Se for banco do brasil, apos a carteira vai um complemento³
					//³ex: 17-019.                                               ³
					//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
					If SA6->A6_COD = '001'
					   cCompCart := '-019'
					Else
					   cCompCart := ''
					EndIf

					//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
					//³Se for banco Real o digito da conta e um calculo usando   ³
					//³modulo 10 composto de agencia+conta+nosso_numero          ³
					//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
					If SA6->A6_COD = '356'
					   cDigCta := U_DIGIT001( cNroDoc + SubStr(SA6->A6_AGENCIA,1,4) + StrZero(Val( SubStr(SA6->A6_NUMCON,1,If(At('-',SA6->A6_NUMCON) # 0,At('-',SA6->A6_NUMCON)-1,Len(AllTrim(SA6->A6_NUMCON))-1)) ),7) )
					Else
					   cDigCta := SubStr(SA6->A6_DVCTA,1,1)
					EndIf
					   
					// [1] Numero do Banco
					// [2] Nome do Banco
					// [3] Agencia
					// [4] Conta Corrente
					// [5] Digito da conta corrente
					// [6] Codigo da Carteira
					// [7] Logotipo do banco

					aDadosBanco  := {	SA6->A6_COD,;
										SA6->A6_NREDUZ,;
										SubStr(SA6->A6_AGENCIA,1,4),;
										SubStr(SA6->A6_NUMCON,1,5),;
										cDigCta,;
										cCarteira+cCompCart,;
										'itau.BMP'}

					//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
					//³Posiciona o SA1 (Cliente)³
					//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
					DbSelectArea('SA1')
					SA1->(DbSetOrder(1))
					SA1->(DbSeek(xFilial('SA1')+SE1->E1_CLIENTE+SE1->E1_LOJA,.T.))

					// [1] Razao Social
					// [2] Codigo
					// [3] Endereço 
					// [4] Cidade
					// [5] Estado
					// [6] CEP
					// [7] CGC
					// [8] PESSOA

					If	Empty(SA1->A1_ENDCOB)
						aDatSacado   := {AllTrim(SA1->A1_NOME),;
										AllTrim(SA1->A1_COD)+'-'+SA1->A1_LOJA,;
										AllTrim(SA1->A1_END)+'-'+AllTrim(SA1->A1_BAIRRO),;
										AllTrim(SA1->A1_MUN),;
										SA1->A1_EST,;
										SA1->A1_CEP,;
										SA1->A1_CGC,;
										SA1->A1_PESSOA}
					Else
						aDatSacado   := {AllTrim(SA1->A1_NOME),;
										AllTrim(SA1->A1_COD)+'-'+SA1->A1_LOJA,;
										AllTrim(SA1->A1_ENDCOB)+'-'+AllTrim(SA1->A1_BAIRROC),;
										AllTrim(SA1->A1_MUNC),;
										SA1->A1_ESTC,;
										SA1->A1_CEPC,;
										SA1->A1_CGC,;
										SA1->A1_PESSOA}
					EndIf

					//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
					//³Posiciona o SE1 (Contas a receber)³
					//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
					DbSelectArea('SE1')
					nVlrAbat := SomaAbat(SE1->E1_PREFIXO,SE1->E1_NUM,SE1->E1_PARCELA,'R',1,,SE1->E1_CLIENTE,SE1->E1_LOJA)
					DbSelectArea('SE1')


					//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
					//³Monta codigo de barras³
					//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
					If	( AllTrim(SE1->E1_PORTADOR) == '341' )		//ITAU
						aCB_RN_NN := xItaVerfBar(SE1->E1_PREFIXO,SE1->E1_NUM,SE1->E1_PARCELA,SE1->E1_TIPO,;
									 Subs(aDadosBanco[1],1,3),aDadosBanco[3],aDadosBanco[4],aDadosBanco[5]	,;
									 cNroDoc,(SE1->E1_SALDO - nVlrAbat),cCarteira,'9')											 									 
					EndIf

					// [01] Numero do titulo
					// [02] Data da emissão do titulo
					// [03] Data da emissão do boleto
					// [04] Data do vencimento
					// [05] Valor do titulo
					// [06] Nosso numero (Ver formula para calculo)
					// [07] Prefixo da NF
					// [08] Tipo do Titulo
					aDadosTit := {AllTrim(SE1->E1_NUM)+AllTrim(SE1->E1_PARCELA),;
								SE1->E1_EMISSAO,;
								dDataBase,;
								SE1->E1_VENCTO,;
								(SE1->E1_SALDO - nVlrAbat),;
								aCB_RN_NN[3],;
								SE1->E1_PREFIXO,;
								SE1->E1_TIPO}

					//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
					//³CARREGA AS INSTRUCOES A SEREM IMPRESSAS NO CORPO DO BOLETO!³
					//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
//					aBolText	:= {}  //Preencher as 7 posiçoes.
					
//					aAdd( aBolText, 'Após o vencimento cobrar multa de R$ ' + AllTrim(Transform((aDadosTit[5] * (GetNewPar('MV_MULTBOL',2.0)/100)),'@E 999,999,999.99')) )
					
//					aAdd( aBolText, 'e Juros de R$ ' + AllTrim(Transform((aDadosTit[5] * (GetNewPar('MV_JUROBOL',0.10)/100)),'@E 999,999,999.99')) + ' ao dia' )
					
//					aAdd( aBolText, ' ** PROTESTAR APÓS 10 DIAS DO VENCIMENTO **' )

					aBolText := {	"Atraso de pagamento",;
  									" * Juros de Mora de 3,5% ao mês ",;
									" * Calculo ",;
									" Valor pago ___________X R$(0,0011666 X ___) Dias ",;
									" * Multa moratória de 2% "}					
//					aAdd( aBolText, '' )
//					aAdd( aBolText, '' )
//					aAdd( aBolText, '' )
//					aAdd( aBolText, '' )
					
					//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
					//³Se for fatura, verifica os dados dos titulos integrantes. !³
					//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
					If	( AllTrim(SE1->E1_PREFIXO) == 'FAT' )
						aDadosFat := xVerFatura(SE1->E1_NUM)
					EndIf

					//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
					//³Grava Nosso Numero no Titulo                               ³
					//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
					DbSelectArea('SE1')
					If	RecLock('SE1',.f.)
						Replace SE1->E1_NUMBCO 	With aCB_RN_NN[3]   // Nosso numero (Ver formula para calculo)
						Replace SE1->E1_IDCNAB  With "0" + SE1->E1_NUM  //Chave para pesquisa 10 Caracteres.										
						MsUnlock()
					Else
						Help('',1,'REGNOIS')
					EndIf
			
					If (Len(aParametros) = 0) .OR. (Len(aParametros) <> 0 )//.AND. (GetMV('MV_IMPBOL') <> '3')) 					
						Impress(oPrint,aDadosEmp,aDadosTit,aDadosBanco,aDatSacado,aBolText,aCB_RN_NN)
												
					EndIF
					
					nX++

				EndIf

			IncProc()
			TRA->(DbSkip())
			nI++

		End

		If (Len(aParametros) = 0) .OR. (Len(aParametros) <> 0 )//.AND. (GetMV('MV_IMPBOL') <> '3')) 
			oPrint:EndPage()     // Finaliza a página
			oPrint:Preview()     // Visualiza antes de imprimir
		EndIF

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ Impress  ºAutor ³ Microsiga Software  º Data ³  15/07/15   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ IMPRESSAO DO BOLETO LASER CONFORME O BANCO..               º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Funcao Principal                                           º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDATA      ³ ANALISTA ³  MOTIVO                                         º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±º          ³          ³                                                 º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Static Function Impress(oPrint,aDadosEmp,aDadosTit,aDadosBanco,aDatSacado,aBolText,aCB_RN_NN)
Local	oBrush		:= TBrush():New(,4),;
		nLin		:= 0,;
		oFont8  	:= TFont():New('Arial',9,8,.T.,.F.,5,.T.,5,.T.,.F.),;
		oFont9  	:= TFont():New('Arial',9,9,.T.,.F.,5,.T.,5,.T.,.F.),;
		oFont11c	:= TFont():New('Courier New',9,11,.T.,.T.,5,.T.,5,.T.,.F.),;
		oFont11 	:= TFont():New('Arial',9,11,.T.,.T.,5,.T.,5,.T.,.F.),;
		oFont10 	:= TFont():New('Arial',9,10,.T.,.T.,5,.T.,5,.T.,.F.),;
		oFont14 	:= TFont():New('Arial',9,14,.T.,.T.,5,.T.,5,.T.,.F.),;
		oFont20 	:= TFont():New('Arial',9,20,.T.,.T.,5,.T.,5,.T.,.F.),;
		oFont21 	:= TFont():New('Arial',9,21,.T.,.T.,5,.T.,5,.T.,.F.),;
		oFont16n	:= TFont():New('Arial',9,16,.T.,.F.,5,.T.,5,.T.,.F.),;
		oFont15 	:= TFont():New('Arial',9,15,.T.,.T.,5,.T.,5,.T.,.F.),;
		oFont15n	:= TFont():New('Arial',9,15,.T.,.F.,5,.T.,5,.T.,.F.),;
		oFont14n	:= TFont():New('Arial',9,14,.T.,.F.,5,.T.,5,.T.,.F.),;
		oFont24 	:= TFont():New('Arial',9,24,.T.,.T.,5,.T.,5,.T.,.F.),;
		nI 			:= 0,;
		nQtdPrint	:= 0,;
		nLinhPrin	:= 1
		cDigBco     := ""

		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³Inicia uma nova pagina³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		oPrint:StartPage()

		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³C O M P R O V A N T E   D E   E N T R E G A³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		nRow1 := 0

		oPrint:Line(nRow1+0150,0500,nRow1+0070,0500) //- linha pra baixo
		oPrint:Line(nRow1+0150,0710,nRow1+0070,0710)

		//oPrint:FillRect({0150,1500,250,1900},oBrush)
		//oPrint:FillRect({0710,1800,0810,2300},oBrush)
		//oPrint:FillRect({0980,1800,1050,2300},oBrush)
		//oPrint:FillRect({2200,1800,2300,2300},oBrush)
		//oPrint:FillRect({2470,1800,2540,2300},oBrush)

	   oPrint:SayBitmap(060,0100,aDadosBanco[7],150,80)
	   //oPrint:Say(nRow1+0084,0165,aDadosBanco[2],oFont14n)	// [2] Nome do Banco
		
		Do Case
		   Case aDadosBanco[1] = '001'
		        cDigBco := '-9'
		   Case aDadosBanco[1] = '237'
		        cDigBco := '-2'
		   Case aDadosBanco[1] = '341'
		        cDigBco := '-7'
		   Case aDadosBanco[1] = '356'
		        cDigBco := '-5'
		End Case
		
		oPrint:Say(nRow1+0075,0513,aDadosBanco[1]+cDigBco,oFont21) // [1] Numero do Banco
		//oPrint:Say(nRow1+0075,0100,aDadosEmp[1] ,oFont21) // [1] Numero do Banco

		oPrint:Say(nRow1+0084,1900,'Comprovante de Entrega',oFont10)
		oPrint:Line(nRow1+0150,0100,nRow1+0150,2300)

		oPrint:Say(nRow1+0150,0100,'Beneficiário',oFont8)
oPrint:Say(nRow1+0180,0100,Substr(aDadosEmp[1],1,50),oFont9) // Nome + CNPJ
oPrint:Say(nRow1+0210,0100,Substr(aDadosEmp[2],1,28) + Alltrim(aDadosEmp[3]),oFont9) // End

		oPrint:Say(nRow1+0150,1060,'Agência/Código Beneficiário',oFont8)
		oPrint:Say(nRow1+0200,1060,aDadosBanco[3]+'/'+aDadosBanco[4]+'-'+aDadosBanco[5],oFont10)

		oPrint:Say(nRow1+0150,1510,'Nro.Documento',oFont8)
		oPrint:Say(nRow1+0200,1510,aDadosTit[7]+aDadosTit[1],oFont10) // Prefixo +Numero+Parcela

		oPrint:Say(nRow1+0250,100 ,'Pagador',oFont8)
		oPrint:Say(nRow1+0300,100 ,aDatSacado[1],oFont10) // Nome

		oPrint:Say(nRow1+0250,1060,'Vencimento',oFont8)
		oPrint:Say(nRow1+0300,1060,StrZero(Day(aDadosTit[4]),2) +'/'+ StrZero(Month(aDadosTit[4]),2) +'/'+ Right(Str(Year(aDadosTit[4])),4),oFont10)

		oPrint:Say(nRow1+0250,1510,'Valor do Documento',oFont8)
		oPrint:Say(nRow1+0300,1550,AllTrim(TransForm(aDadosTit[5],'@E 999,999,999.99')),oFont10)

		oPrint:Say(nRow1+0400,0100,'Recebi(emos) o bloqueto/título',oFont10)
		oPrint:Say(nRow1+0450,0100,'com as características acima.',oFont10)
		oPrint:Say(nRow1+0350,1060,'Carteira',oFont8)
		oPrint:Say(nRow1+0400,1060,aDadosBanco[6],oFont10)
		oPrint:Say(nRow1+0350,1410,'Nosso Numero',oFont8)

		If	( AllTrim(aDadosBanco[1]) == '001' )
			cString := AllTrim(SubStr(aDadosTit[6],1,6)+' '+SubStr(aDadosTit[6],7,5)+' - '+SubStr(aDadosTit[6],12,1))
		ElseIf	( AllTrim(aDadosBanco[1]) == '237' )
			cString := AllTrim(StrZero(Val(aDadosBanco[6]),2)) + '/' + AllTrim(SubStr(aDadosTit[6],1,11)) + '-' + SubStr(aDadosTit[6],12,1)
		ElseIf	( AllTrim(aDadosBanco[1]) == '341' )
			cString := AllTrim(SubStr(aDadosTit[6],1,3)) + '/' + AllTrim(SubStr(aDadosTit[6],4,8)) + '-' + SubStr(aDadosTit[6],12,1)
		ElseIf	( AllTrim(aDadosBanco[1]) == '356' )
			cString := AllTrim(aDadosTit[6]) 
		EndIf

		oPrint:Say(nRow1+0400,1410,cString,oFont10)
		oPrint:Say(nRow1+0450,1060,'Data',oFont8)
		oPrint:Say(nRow1+0450,1410,'Entregador',oFont8)

		oPrint:Line (nRow1+0250,0100,nRow1+0250,1900)
		oPrint:Line (nRow1+0350,0100,nRow1+0350,1900)
		oPrint:Line (nRow1+0450,1050,nRow1+0450,1900)
		oPrint:Line (nRow1+0550,0100,nRow1+0550,2300)

		oPrint:Line (nRow1+0550,1050,nRow1+0150,1050)
		oPrint:Line (nRow1+0550,1400,nRow1+0350,1400)
		oPrint:Line (nRow1+0350,1500,nRow1+0150,1500)
		oPrint:Line (nRow1+0550,1900,nRow1+0150,1900)

		oPrint:Say(nRow1+0165,1910,'(   ) Mudou-se',oFont8)
		oPrint:Say(nRow1+0205,1910,'(   ) Ausente',oFont8)
		oPrint:Say(nRow1+0245,1910,'(   ) Não existe nº indicado',oFont8)
		oPrint:Say(nRow1+0285,1910,'(   ) Recusado',oFont8)
		oPrint:Say(nRow1+0325,1910,'(   ) Não procurado',oFont8)
		oPrint:Say(nRow1+0365,1910,'(   ) Endereço insuficiente',oFont8)
		oPrint:Say(nRow1+0405,1910,'(   ) Desconhecido',oFont8)
		oPrint:Say(nRow1+0445,1910,'(   ) Falecido',oFont8)
		oPrint:Say(nRow1+0485,1910,'(   ) Outros(anotar no verso)',oFont8)

		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³R E C I B O    D O     S A C A D O³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		nRow2 := 0

		For nI := 100 to 2300 step 50
			oPrint:Line(nRow2+0580, nI,nRow2+0580, nI+30)
		Next nI

		oPrint:Line(nRow2+0710,0100,nRow2+0710,2300)
		oPrint:Line(nRow2+0710,0500,nRow2+0630,0500)
		oPrint:Line(nRow2+0710,0710,nRow2+0630,0710)

		oPrint:SayBitmap(0620,0100,aDadosBanco[7],150,80)
		//oPrint:Say(nRow2+0644,0165,aDadosBanco[2],oFont14n)		// [2] Nome do Banco

		oPrint:Say(nRow2+0635,0513,aDadosBanco[1]+cDigBco,oFont21)	// [1] Numero do Banco

		oPrint:Say(nRow2+0644,1800,'Recibo do Pagador',oFont10)

		oPrint:Line(nRow2+0810,0100,nRow2+0810,2300)
		oPrint:Line(nRow2+0910,0100,nRow2+0910,2300)
		oPrint:Line(nRow2+0980,0100,nRow2+0980,2300)
		oPrint:Line(nRow2+1050,0100,nRow2+1050,2300)

		oPrint:Line(nRow2+0910,0500,nRow2+1050,0500)
		oPrint:Line(nRow2+0980,0750,nRow2+1050,0750)
		oPrint:Line(nRow2+0910,1000,nRow2+1050,1000)
		oPrint:Line(nRow2+0910,1300,nRow2+0980,1300)
		oPrint:Line(nRow2+0910,1480,nRow2+1050,1480)

		oPrint:Say(nRow2+0710,0100,'Local de Pagamento',oFont8)
		oPrint:Say(nRow2+0725,0400,'QUALQUER BANCO ATE O VENCIMENTO',oFont10)
		oPrint:Say(nRow2+0765,0400,'APÓS O VENCIMENTO, SOMENTE NO '+aDadosBanco[2],oFont10)

		oPrint:Say(nRow2+0710,1810,'Vencimento',oFont8)
		cString	:= StrZero(Day(aDadosTit[4]),2) +'/'+ StrZero(Month(aDadosTit[4]),2) +'/'+ Right(Str(Year(aDadosTit[4])),4)
		nCol := 1810+(374-(len(cString)*22))
		oPrint:Say(nRow2+0750,nCol,cString,oFont11c)

		oPrint:Say(nRow2+0810,100 ,'Beneficiário',oFont8)
		oPrint:Say(nRow2+0840,100 ,aDadosEmp[1]+'  - '+aDadosEmp[6],oFont9) // Nome + CNPJ
		oPrint:Say(nRow2+0870,100 ,Substr(aDadosEmp[2],1,28) + Alltrim(aDadosEmp[3]),oFont9) // End

		oPrint:Say(nRow2+0810,1810,'Agência/Código Beneficiário',oFont8)
		cString := AllTrim(aDadosBanco[3]+'/'+aDadosBanco[4]+'-'+aDadosBanco[5])
		nCol := 1810+(374-(len(cString)*22))
		oPrint:Say(nRow2+0850,nCol,cString,oFont11c)

		oPrint:Say(nRow2+0910,100 ,'Data do Documento',oFont8)
		oPrint:Say(nRow2+0940,100, StrZero(Day(aDadosTit[2]),2) +'/'+ StrZero(Month(aDadosTit[2]),2) +'/'+ Right(Str(Year(aDadosTit[2])),4),oFont10)

		oPrint:Say(nRow2+0910,505 ,'Nro.Documento',oFont8)
		oPrint:Say(nRow2+0940,605 ,aDadosTit[7]+aDadosTit[1],oFont10) // Prefixo + Numero+Parcela

		oPrint:Say(nRow2+0910,1005,'Espécie Doc.',oFont8)
		oPrint:Say(nRow2+0940,1050,aDadosTit[8],oFont10) // Tipo do Titulo

		oPrint:Say(nRow2+0910,1305,'Aceite',oFont8)
		oPrint:Say(nRow2+0940,1400,'N',oFont10)

		oPrint:Say(nRow2+0910,1485,'Data do Processamento',oFont8)
		oPrint:Say(nRow2+0940,1550,StrZero(Day(aDadosTit[3]),2) +'/'+ StrZero(Month(aDadosTit[3]),2) +'/'+ Right(Str(Year(aDadosTit[3])),4),oFont10) // Data impressao
		oPrint:Say(nRow2+0910,1810,'Nosso Número',oFont8)

		If	( AllTrim(aDadosBanco[1]) == '001' )
			cString := AllTrim(SubStr(aDadosTit[6],1,6)+' '+SubStr(aDadosTit[6],7,5)+' - '+SubStr(aDadosTit[6],12,1))
		ElseIf	( AllTrim(aDadosBanco[1]) == '237' )
			cString := AllTrim(StrZero(Val(aDadosBanco[6]),2)) + '/' + AllTrim(SubStr(aDadosTit[6],1,11)) + '-' + SubStr(aDadosTit[6],12,1)
		ElseIf	( AllTrim(aDadosBanco[1]) == '341' )                 //Convenio                         //cSeq                     //digito
			cString := AllTrim(SubStr(aDadosTit[6],1,3)) + '/' + AllTrim(SubStr(aDadosTit[6],4,8)) + '-' + SubStr(aDadosTit[6],12,1)
		ElseIf	( AllTrim(aDadosBanco[1]) == '356' )
			cString := AllTrim(aDadosTit[6]) 
		EndIf

		oPrint:Say(nRow2+0940,1880,cString,oFont11c)

		oPrint:Say(nRow2+0980,0100,'Uso do Banco',oFont8)

		oPrint:Say(nRow2+0980,0505,'Carteira',oFont8)
		oPrint:Say(nRow2+1010,0555,aDadosBanco[6],oFont10)

		oPrint:Say(nRow2+0980,0755,'Espécie',oFont8)
		oPrint:Say(nRow2+1010,0805,'R$',oFont10)

		oPrint:Say(nRow2+0980,1005,'Quantidade',oFont8)
		oPrint:Say(nRow2+0980,1485,'Valor',oFont8)

		oPrint:Say(nRow2+0980,1810,'Valor do Documento',oFont8)
		cString := AllTrim(TransForm(aDadosTit[5],'@E 99,999,999.99'))
		nCol := 1810+(374-(len(cString)*22))
		oPrint:Say(nRow2+1010,nCol,cString ,oFont11c)

		oPrint:Line (nRow2+1080,120,nRow2+1080,1000)
		oPrint:Line (nRow2+1080,120,nRow2+1250,120)
		oPrint:Line (nRow2+1080,1000,nRow2+1250,1000)
		oPrint:Say(nRow2+1050,0100,'Instruções (Todas informações deste bloqueto são de exclusiva responsabilidade do beneficiário)',oFont8)
		oPrint:Say(nRow2+1090,0130,aBolText[1],oFont10)
		oPrint:Say(nRow2+1130,0130,aBolText[2],oFont10)
		oPrint:Say(nRow2+1170,0130,aBolText[3],oFont10)
		oPrint:Say(nRow2+1210,0130,aBolText[4],oFont10)
		oPrint:Say(nRow2+1250,0130,aBolText[5],oFont10)
		oPrint:Line (nRow2+1250,120,nRow2+1250,1000)
		oPrint:Line (nRow2+1250,120,nRow2+1290,120)
		oPrint:Line (nRow2+1250,1000,nRow2+1290,1000)
		oPrint:Line (nRow2+1290,120,nRow2+1290,1000)
                                   
		oPrint:Line (nRow2+1090,1050,nRow2+1280,1050)
		oPrint:Say  (nRow2+1090,1100 ,"* Pagamento somente em dinheiro ou "       ,oFont10)
		oPrint:Say  (nRow2+1130,1100 ,"  cheque à vista"                 			,oFont10)
		oPrint:Say  (nRow2+1170,1100 ,"OBS.: Não receber após atraso de 25 " 		,oFont10)
		oPrint:Say  (nRow2+1210,1100 ,"          dias "+DtoC(aDadosTit[4]+25)  	,oFont10)		



		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³Imprime os titulos que se refere a tal cobrança !³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		oPrint:Say(nRow2+1400,0100,'Referente aos documentos: ',oFont11)
		//oPrint:Say(nRow1+1400,1500,'Formas de Contato: ',oFont11)
		//oPrint:Say(nRow1+1410,1900, 'credito@petroluz.com.br   ou',oFont8) 
		//oPrint:Say(nRow1+1460,1900, '(0xx65) 2121-5700',oFont8) 


		If	( Len(aDadosFat) > 0 ) // FAT

			nLin := 1450 // Posicao da Linha
			nCol := 0100 // Posicao da Coluna
			For nx:=1 to Len(aDadosFat)
				nQtdPrint++
				oPrint:Say(nRow2+nLin,nCol,aDadosFat[nx][2]+ '-' +aDadosFat[nx][3]+', ',oFont9)
				nCol += 190
				If	( nQtdPrint == 9 )
					nLin += 050
					nCol := 100
					nQtdPrint := 0
					nLinhPrin++
				EndIf
				If	( nLinhPrin > 7 )
					Exit
				EndIf
			Next nx

		Else	// Outros

			nLin := 1450 // Posicao da Linha
			nCol := 0100 // Posicao da Coluna
					// [01] Numero do titulo
					// [02] Data da emissão do titulo
					// [03] Data da emissão do boleto
					// [04] Data do vencimento
					// [05] Valor do titulo
					// [06] Nosso numero (Ver formula para calculo)
					// [07] Prefixo da NF
					// [08] Tipo do Titulo
			oPrint:Say(nRow2+nLin,nCol,aDadosTit[7] +' - '+ aDadosTit[1],oFont9)

		EndIf	

		oPrint:Say(nRow2+1050,1810,'(-) Desconto/Abatimento',oFont8)
		oPrint:Say(nRow2+1120,1810,'(-) Outras Deduções',oFont8)
		oPrint:Say(nRow2+1190,1810,'(+) Mora/Multa',oFont8)
		oPrint:Say(nRow2+1260,1810,'(+) Outros Acréscimos',oFont8)
		oPrint:Say(nRow2+1330,1810,'(=) Valor Cobrado',oFont8)

		oPrint:Say(nRow2+1600,0100,'Pagador',oFont8)
		oPrint:Say(nRow2+1630,0400,aDatSacado[1]+' ('+aDatSacado[2]+')',oFont10)
		oPrint:Say(nRow2+1683,0400,aDatSacado[3],oFont10)
		oPrint:Say(nRow2+1736,0400,aDatSacado[6]+'    '+aDatSacado[4]+' - '+aDatSacado[5],oFont10) // CEP+Cidade+Estado

		If	( aDatSacado[8] = 'J' )
			oPrint:Say(nRow2+1789,400 ,'CNPJ: '+TransForm(aDatSacado[7],'@R 99.999.999/9999-99'),oFont10) // CGC
		Else
			oPrint:Say(nRow2+1789,400 ,'CPF: '+TransForm(aDatSacado[7],'@R 999.999.999-99'),oFont10) 	// CPF
		EndIf

		oPrint:Say(nRow2+1789,1850,SubStr(aDadosTit[6],1,3)+SubStr(aDadosTit[6],4),oFont10)

		oPrint:Say(nRow2+1805,0100,'Pagador/Avalista',oFont8)
		oPrint:Say(nRow2+1845,1500,'Autenticação Mecânica',oFont8)

		oPrint:Line(nRow2+0710,1800,nRow2+1400,1800)
		oPrint:Line(nRow2+1120,1800,nRow2+1120,2300)
		oPrint:Line(nRow2+1190,1800,nRow2+1190,2300)
		oPrint:Line(nRow2+1260,1800,nRow2+1260,2300)
		oPrint:Line(nRow2+1330,1800,nRow2+1330,2300)
		oPrint:Line(nRow2+1400,1800,nRow2+1400,2300)
		oPrint:Line(nRow2+1600,0100,nRow2+1600,2300)
		oPrint:Line(nRow2+1840,0100,nRow2+1840,2300)

		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³F I C H A     D E    C O M P E N S A C A O ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		nRow3 := 0

		For nI := 100 to 2300 step 50
			oPrint:Line(nRow3+2080, nI, nRow3+2080, nI+30)
		Next nI

		oPrint:Line(nRow3+2200,0100,nRow3+2200,2300)
		oPrint:Line(nRow3+2200,0500,nRow3+2120,0500)
		oPrint:Line(nRow3+2200,0710,nRow3+2120,0710)

		oPrint:SayBitmap(2110,0100,aDadosBanco[7],150,80)
		//oPrint:Say(nRow3+2134,0165,aDadosBanco[2],oFont14n) // [2] Nome do Banco

		oPrint:Say(nRow3+2125,0513,aDadosBanco[1]+cDigBco,oFont21) // [1]Numero do Banco

		oPrint:Say(nRow3+2134,0755,aCB_RN_NN[2],oFont15n) // Linha Digitavel do Codigo de Barras

		oPrint:Line(nRow3+2300,0100,nRow3+2300,2300)
		oPrint:Line(nRow3+2400,0100,nRow3+2400,2300)
		oPrint:Line(nRow3+2470,0100,nRow3+2470,2300)
		oPrint:Line(nRow3+2540,0100,nRow3+2540,2300)

		oPrint:Line(nRow3+2400,0500,nRow3+2540,0500)
		oPrint:Line(nRow3+2470,0750,nRow3+2540,0750)
		oPrint:Line(nRow3+2400,1000,nRow3+2540,1000)
		oPrint:Line(nRow3+2400,1300,nRow3+2570,1300)
		oPrint:Line(nRow3+2400,1480,nRow3+2540,1480)

		oPrint:Say(nRow3+2200,0100,'Local de Pagamento',oFont8)
		oPrint:Say(nRow3+2215,0400,'QUALQUER BANCO ATE O VENCIMENTO',oFont10)
		oPrint:Say(nRow3+2255,0400,'APÓS O VENCIMENTO, SOMENTE NO '+aDadosBanco[2],oFont10)

		oPrint:Say(nRow3+2200,1810,'Vencimento',oFont8)
		cString := StrZero(Day(aDadosTit[4]),2) +'/'+ StrZero(Month(aDadosTit[4]),2) +'/'+ Right(Str(Year(aDadosTit[4])),4)
		nCol    := 1810+(374-(len(cString)*22))
		oPrint:Say(nRow3+2240,nCol,cString,oFont11c)

		oPrint:Say(nRow3+2300,0100,'Beneficiário',oFont8)
		oPrint:Say(nRow3+2330,0100,aDadosEmp[1]+' - '+aDadosEmp[6],oFont9) // Nome + CNPJ
		oPrint:Say(nRow2+2370,0100,Substr(aDadosEmp[2],1,28) + Alltrim(aDadosEmp[3]),oFont9) // End

		oPrint:Say(nRow3+2300,1810,'Agência/Código Beneficiário',oFont8)
		cString := AllTrim(aDadosBanco[3]+'/'+aDadosBanco[4]+'-'+aDadosBanco[5])
		nCol 	:= 1810+(374-(len(cString)*22))
		oPrint:Say(nRow3+2340,nCol,cString ,oFont11c)

		oPrint:Say(nRow3+2400,100 ,'Data do Documento',oFont8)
		oPrint:Say (nRow3+2430,100, StrZero(Day(aDadosTit[2]),2) +'/'+ StrZero(Month(aDadosTit[2]),2) +'/'+ Right(Str(Year(aDadosTit[2])),4), oFont10)

		oPrint:Say(nRow3+2400,505 ,'Nro.Documento',oFont8)
		oPrint:Say(nRow3+2430,605 ,aDadosTit[7]+aDadosTit[1],oFont10) // Prefixo +Numero+Parcela

		oPrint:Say(nRow3+2400,1005,'Espécie Doc.',oFont8)
		oPrint:Say(nRow3+2430,1050,aDadosTit[8],oFont10) // Tipo do Titulo

		oPrint:Say(nRow3+2400,1305,'Aceite',oFont8)
		oPrint:Say(nRow3+2430,1400,'N',oFont10)

		oPrint:Say(nRow3+2400,1485,'Data do Processamento',oFont8)
		oPrint:Say(nRow3+2430,1550,StrZero(Day(aDadosTit[3]),2) +'/'+ StrZero(Month(aDadosTit[3]),2) +'/'+ Right(Str(Year(aDadosTit[3])),4),oFont10) // Data impressao

		oPrint:Say(nRow3+2400,1810,'Nosso Número',oFont8)

		If	( AllTrim(aDadosBanco[1]) == '001' )
			cString := AllTrim(SubStr(aDadosTit[6],1,6)+' '+SubStr(aDadosTit[6],7,5)+' - '+SubStr(aDadosTit[6],12,1))
		ElseIf	( AllTrim(aDadosBanco[1]) == '237' )
			cString := AllTrim(StrZero(Val(aDadosBanco[6]),2)) + '/' + AllTrim(SubStr(aDadosTit[6],1,11)) + '-' + SubStr(aDadosTit[6],12,1)
		ElseIf	( AllTrim(aDadosBanco[1]) == '341' )
			cString := AllTrim(SubStr(aDadosTit[6],1,3)) + '/' + AllTrim(SubStr(aDadosTit[6],4,8)) + '-' + SubStr(aDadosTit[6],12,1)
		ElseIf	( AllTrim(aDadosBanco[1]) == '356' )
			cString := AllTrim(aDadosTit[6]) 
		EndIf

		oPrint:Say(nRow3+2430,1880,cString,oFont11c)

		oPrint:Say(nRow3+2470,0100,'Uso do Banco',oFont8)

		oPrint:Say(nRow3+2470,0505,'Carteira',oFont8)
		oPrint:Say(nRow3+2500,0555,aDadosBanco[6],oFont10)

		oPrint:Say(nRow3+2470,0755,'Espécie',oFont8)
		oPrint:Say(nRow3+2500,0805,'R$',oFont10)

		oPrint:Say(nRow3+2470,1005,'Quantidade',oFont8)
		oPrint:Say(nRow3+2470,1485,'Valor',oFont8)

		oPrint:Say(nRow3+2470,1810,'Valor do Documento',oFont8)
		cString := AllTrim(TransForm(aDadosTit[5],'@E 99,999,999.99'))
		nCol 	:= 1810+(374-(len(cString)*22))
		oPrint:Say(nRow3+2500,nCol,cString,oFont11c)


		oPrint:Line (nRow3+2570,120,nRow3+2570,1000)
		oPrint:Line (nRow3+2570,120,nRow3+2740,120)
		oPrint:Line (nRow3+2570,1000,nRow3+2740,1000)
		oPrint:Say(nRow3+2540,0100,'Instruções (Todas informações deste bloqueto são de exclusiva responsabilidade do beneficiário)',oFont8)
		oPrint:Say(nRow3+2580,0130,aBolText[1],oFont10)
		oPrint:Say(nRow3+2620,0130,aBolText[2],oFont10)
		oPrint:Say(nRow3+2660,0130,aBolText[3],oFont10)
		oPrint:Say(nRow3+2700,0130,aBolText[4],oFont10)
		oPrint:Say(nRow3+2740,0130,aBolText[5],oFont10)

		oPrint:Line (nRow3+2740,120,nRow3+2740,1000)
		oPrint:Line (nRow3+2740,120,nRow3+2790,120)
		oPrint:Line (nRow3+2740,1000,nRow3+2790,1000)
		oPrint:Line (nRow3+2790,120,nRow3+2790,1000)

		oPrint:Line (nRow3+2580,1050,nRow3+2780,1050)
		oPrint:Say  (nRow3+2580,1100 ,"* Pagamento somente em dinheiro ou"                 			,oFont10)
		oPrint:Say  (nRow3+2620,1100 ,"  cheque à vista"                 			,oFont10)
		oPrint:Say  (nRow3+2660,1100 ,"OBS.: Não receber após atraso de 25 "		,oFont10)
		oPrint:Say  (nRow3+2700,1100 ,"          dias "+DtoC(aDadosTit[4]+25)  	,oFont10)		



		oPrint:Say(nRow3+2540,1810,'(-) Desconto/Abatimento',oFont8)
		oPrint:Say(nRow3+2610,1810,'(-) Outras Deduções',oFont8)
		oPrint:Say(nRow3+2680,1810,'(+) Mora/Multa',oFont8)
		oPrint:Say(nRow3+2750,1810,'(+) Outros Acréscimos',oFont8)
		oPrint:Say(nRow3+2820,1810,'(=) Valor Cobrado',oFont8)

		oPrint:Say(nRow3+2890,0100,'Pagador',oFont8)
		oPrint:Say(nRow3+2900,0400,aDatSacado[1]+' ('+aDatSacado[2]+')',oFont10)

		If	( aDatSacado[8] = 'J' )
			oPrint:Say(nRow3+2900,1750,'CNPJ: '+TransForm(aDatSacado[7],'@R 99.999.999/9999-99'),oFont10) // CGC
		Else
			oPrint:Say(nRow3+2900,1750,'CPF: '+TransForm(aDatSacado[7],'@R 999.999.999-99'),oFont10) 	// CPF
		EndIf

		oPrint:Say(nRow3+2953,0400,aDatSacado[3],oFont10)
		oPrint:Say(nRow3+3006,0400,aDatSacado[6]+'    '+aDatSacado[4]+' - '+aDatSacado[5],oFont10) // CEP+Cidade+Estado
		oPrint:Say(nRow3+3006,1750,SubStr(aDadosTit[6],1,3)+SubStr(aDadosTit[6],4),oFont10)

		oPrint:Say(nRow3+3015,0100,'Pagador/Avalista',oFont8)
		oPrint:Say(nRow3+3055,1500,'Autenticação Mecânica - Ficha de Compensação',oFont8)

		oPrint:Line(nRow3+2200,1800,nRow3+2890,1800)
		oPrint:Line(nRow3+2610,1800,nRow3+2610,2300)
		oPrint:Line(nRow3+2680,1800,nRow3+2680,2300)
		oPrint:Line(nRow3+2750,1800,nRow3+2750,2300)
		oPrint:Line(nRow3+2820,1800,nRow3+2820,2300)
		oPrint:Line(nRow3+2890,0100,nRow3+2890,2300)

		oPrint:Line(nRow3+3050,0100,nRow3+3050,2300)
		
		
		MSBAR("INT25",26.2,1.6,aCB_RN_NN[1],oPrint,.F.,,,,1.2,,,,.F.)    // IMPressao em Jato de Tinta HP 660
/*
		If MV_PAR18 = 2 //Impressão Deskjet
			MsBar('INT25',13.3,0.6,aCB_RN_NN[1],oPrint,.f.,,,0.0134,0.61,,,'A',.f.)
		Else
			MsBar('INT25',26.5,1.6,aCB_RN_NN[1],oPrint,.f.,,,0.0234,0.86,,,'A',.F.)
		EndIf	
	*/	
		//MSBAR("INT25",17.3,1.6,CB_RN_NN[1],oPrint,.F.,,,,1.8,,,,.F.)    // IMPressao em Jato de Tinta HP 660

		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³Finaliza a pagina³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		oPrint:EndPage()

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºFuncao    ³ xBBVerfBar ºAutor³Microsiga           º Data ³  15/07/15   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Verifica/Gera o Codigo de Barra ( Banco do Brasil )        º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ BOLETOS                                                    º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDATA      ³ ANALISTA ³ MOTIVO                                          º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±º          ³          ³                                                 º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Static Function xBBVerfBar(	cPrefixo,cNumero,cParcela,cTipo,;
							cBanco,cAgencia,cConta,cDacCC,;
							cNroDoc,nVlrTit,cCart,cMoeda)
Local	cNosso		:= '',;
		nNum		:= '',;
		cCampoL		:= '',;
		cFatorValor	:= '',;
		cLivre		:= '',;
		cDigBarra	:= '',;
		cBarra		:= '',;
		cParte1		:= '',;
		cDig1		:= '',;
		cParte2		:= '',;
		cDig2		:= '',;
		cParte3		:= '',;
		cDig3		:= '',;
		cParte4		:= '',;
		cParte5		:= '',;
		cDigital	:= '',;
		aRet		:= {}

		cAgencia	:= StrZero(Val(cAgencia),4)
		cNosso 		:= ''

		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³Formulacao do nosso numero³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		If	( Len(AllTrim(cNroDoc)) == 12 ) // Ja esta pronto nao precisa verificar digito
			nNum	:= SubStr(cNroDoc,1,11)
			cNosso	:= cNroDoc
		Else
			nNum	:= StrZero(Val(cNroDoc),11)
			cNosso	:= nNum + xBBCalcDigN(nNum)
		EndIf

		// Campo livre -  verificar a conta e carteira
		cCampoL := nNum + cAgencia + StrZero(Val(cConta),8) + cCart

		// Campo livre do codigo de barra - verificar a conta
		cFatorValor  := xFator()+StrZero(nVlrTit*100,10)

		cLivre := cBanco + cMoeda + cFatorValor + cCampoL

		// Campo do codigo de barra
		cDigBarra := U_Cal_5pBB(cLivre)
		cBarra    := SubStr(cLivre,1,4)+cDigBarra+SubStr(cLivre,5,40)

		// Composicao da linha digitavel
		cParte1  := cBanco+cMoeda
		cParte1  += SubStr(cCampoL,1,5)
		cDig1    := U_DIGIT001( cParte1 )
		cParte2  := SubStr(cCampoL,6,10)
		cDig2    := U_DIGIT001( cParte2 )
		cParte3  := SubStr(cCampoL,16,10)
		cDig3    := U_DIGIT001( cParte3 )
		cParte4  := ' '+cDigBarra+' '
		cParte5  := cFatorValor

		cDigital := SubStr(cParte1,1,5)+'.'+SubStr(cparte1,6,4)+cDig1+' '+;
					SubStr(cParte2,1,5)+'.'+SubStr(cparte2,6,5)+cDig2+' '+;
					SubStr(cParte3,1,5)+'.'+SubStr(cparte3,6,5)+cDig3+' '+;
					cParte4+;
					cParte5

		Aadd(aRet,cBarra)
		Aadd(aRet,cDigital)
		Aadd(aRet,cNosso)

Return aRet

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºFuncao    ³ xBraVerfBarºAutor³Microsiga           º Data ³  15/07/15   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Verifica/Gera o Codigo de Barra ( Bradesco )               º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ BOLETOS                                                    º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDATA      ³ ANALISTA ³ MOTIVO                                          º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±º          ³          ³                                                 º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Static Function xBraVerfBar(cPrefixo,cNumero,cParcela,cTipo,;
							cBanco,cAgencia,cConta,cDacCC,;
							cNroDoc,nVlrTit,cCart,cMoeda)
Local	cNosso		:= '',;
		nNum		:= '',;
		cCampoL		:= '',;
		cFatorValor	:= '',;
		cLivre		:= '',;
		cDigBarra	:= '',;
		cBarra		:= '',;
		cParte1		:= '',;
		cDig1		:= '',;
		cParte2		:= '',;
		cDig2		:= '',;
		cParte3		:= '',;
		cDig3		:= '',;
		cParte4		:= '',;
		cParte5		:= '',;
		cDigital	:= '',;
		aRet		:= {}

		cAgencia	:= StrZero(Val(cAgencia),4)
		cNosso 		:= ''

		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³Formulacao do nosso numero³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		If	( Len(AllTrim(cNroDoc)) == 12 ) // Ja esta pronto nao precisa verificar digito
			nNum	:= SubStr(cNroDoc,1,11)
			cNosso	:= cNroDoc
		Else
			nNum	:= StrZero(Val(cNroDoc),11)
			cNosso	:= nNum + xBraCalcDigN(StrZero(Val(cCart),2)+nNum)
		EndIf
		
		//ConOut('Nosso Numero s/ digito..:' + nNum)
		//ConOut('Nosso Numero c/ digito..:' + cNosso)

		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³Campo Livre -  Verificar a conta e carteira³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		// 01 a 04 - 04 - Agencia Cedente
		// 05 a 06 - 02 - Carteira
		// 07 a 17 - 11 - Nosso Numero sem o digito
		// 18 a 24 - 07 - Conta Corrente sem o digito
		// 25 a 25 - 01 - Zero
		cCampoL := cAgencia + StrZero(Val(cCart),2) + nNum + StrZero(Val(cConta),7) + '0'

	    //ConOut('Agencia..:' + cAgencia )
	    //ConOut('Carteira.:' + StrZero(val(cCart),2) )
	    //ConOut('Nosso Num s/digito.:' + nNum )
	    //ConOut('Conta Cedente..:' + StrZero(Val(cConta),7) )
	    //ConOut('Formado campo-livre..:' + cCampoL )

		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³Campo livre do codigo de barra - verificar a conta³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		cFatorValor  := xFator()+StrZero(nVlrTit*100,10)

		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³Monta o campo Livre:³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
        // 000000000111111111122222222223333333333444444444455555555556
        // 123456789012345678901234567890123456789012345678901234567890
		// 2379?XXXX$$$$$$$$$$LLLLLLLLLLLLLLLLLLLLLLLLL
		// x  xx         x          x           x
		cLivre := cBanco + cMoeda + cFatorValor + cCampoL
        
		//ConOut('Banco..:' + cBanco )
		//ConOut('Moeda..:' + cMoeda )
		//ConOut('Fator+Valor..:' + cFatorValor )
		//ConOut('Campo Livre..:' + cCampoL )

		//ConOut('Codigo para gerar o codigo de barras..:' + cLivre )

		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³Campo do codigo de barra³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		cDigBarra := U_Cal_5pBr(cLivre)
		cBarra    := SubStr(cLivre,1,4)+cDigBarra+SubStr(cLivre,5,43)
		
		//ConOut('Digito Calculado..:' + cDigBarra )
		//ConOut('Codigo Completo...:' + cBarra )

		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³Composicao da linha digitavel³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		cParte1  := cBanco + cMoeda + SubStr(cCampoL,1,5)
		cDig1    := U_DIGIT001( cParte1 )
		cParte2  := SubStr(cCampoL,6,10)
		cDig2    := U_DIGIT001( cParte2 )
		cParte3  := SubStr(cCampoL,16,10)
		cDig3    := U_DIGIT001( cParte3 )
		cParte4  := ' '+cDigBarra+' '
		cParte5  :=  cFatorValor

		cDigital := SubStr(cParte1,1,5)+'.'+SubStr(cParte1,6,4)+cDig1+' '+;
					SubStr(cParte2,1,5)+'.'+SubStr(cParte2,6,5)+cDig2+' '+;
					SubStr(cParte3,1,5)+'.'+SubStr(cParte3,6,6)+cDig3+;
					cParte4+;
					cParte5

		Aadd(aRet,cBarra)
		Aadd(aRet,cDigital)
		Aadd(aRet,cNosso)

Return aRet

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºFuncao    ³ xItaVerfBarºAutor³Microsiga           º Data ³  15/07/15   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Verifica/Gera o Codigo de Barra ( Bradesco )               º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ BOLETOS                                                    º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDATA      ³ ANALISTA ³ MOTIVO                                          º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±º          ³          ³                                                 º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Static Function xItaVerfBar(cPrefixo,cNumero,cParcela,cTipo,;
							cBanco,cAgencia,cConta,cDacCC,;
							cNroDoc,nVlrTit,cCart,cMoeda)
Local	cNosso		:= '',;
		nNum		:= '',;
		cCampoL		:= '',;
		cFatorValor	:= '',;
		cLivre		:= '',;
		cDigBarra	:= '',;
		cBarra		:= '',;
		cParte1		:= '',;
		cDig1		:= '',;
		cParte2		:= '',;
		cDig2		:= '',;
		cParte3		:= '',;
		cDig3		:= '',;
		cParte4		:= '',;
		cParte5		:= '',;
		cDigital	:= '',;
		aRet		:= {}

		cAgencia	:= StrZero(Val(cAgencia),4)
		cNosso 		:= ''

		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³Formulacao do nosso numero³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		If	( Len(AllTrim(cNroDoc)) == 12 ) // Ja esta pronto nao precisa verificar digito
			nNum	:= SubStr(cNroDoc,1,11)
			cNosso	:= cNroDoc
		Else
			nNum	:= StrZero(Val(cNroDoc),11)
			cNosso	:= nNum + U_DIGIT001(cAgencia+cConta+nNum)
		EndIf
		
		//ConOut('Nosso Numero s/ digito..:' + nNum)
		//ConOut('Nosso Numero c/ digito..:' + cNosso)

		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³Campo Livre -  ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		cCampoL := AllTrim(cNosso) + StrZer(Val(cAgencia),4) + StrZero(Val(cConta),5) + U_DIGIT001(cAgencia+cConta) + '000'

	    //ConOut('Agencia..:' + cAgencia )
	    //ConOut('Carteira.:' + StrZero(val(cCart),2) )
	    //ConOut('Nosso Num s/digito.:' + nNum )
	    //ConOut('Conta Cedente..:' + StrZero(Val(cConta),7) )
	    ConOut('Formado campo-livre..:' + cCampoL )

		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³Campo livre do codigo de barra - verificar a conta³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		cFatorValor  := xFator()+StrZero(nVlrTit*100,10)

		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³Monta o campo Livre:³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
        // 000000000111111111122222222223333333333444444444455555555556
        // 123456789012345678901234567890123456789012345678901234567890
		// 2379?XXXX$$$$$$$$$$LLLLLLLLLLLLLLLLLLLLLLLLL
		// x  xx         x          x           x
		cLivre := cBanco + cMoeda + cFatorValor + cCampoL
        
		//ConOut('Banco..:' + cBanco )
		//ConOut('Moeda..:' + cMoeda )
		ConOut('Fator+Valor..:' + cFatorValor )
		ConOut('Campo Livre..:' + cCampoL )

		//ConOut('Codigo para gerar o codigo de barras..:' + cLivre )

		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³Campo do codigo de barra³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		cDigBarra := U_Calc_5pIt(cLivre)
		cBarra    := SubStr(cLivre,1,4)+cDigBarra+SubStr(cLivre,5,43)
		
		ConOut('Digito Calculado..:' + cDigBarra )
		ConOut('Codigo Completo...:' + cBarra )

		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³Composicao da linha digitavel³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		cParte1  := cBanco + cMoeda + SubStr(cCampoL,1,5)
		cDig1    := U_DIGIT001( cParte1 )
		cParte2  := SubStr(cCampoL,6,10)
		cDig2    := U_DIGIT001( cParte2 )
		cParte3  := SubStr(cCampoL,16,10)
		cDig3    := U_DIGIT001( cParte3 )
		cParte4  := ' '+cDigBarra+' '
		cParte5  :=  cFatorValor

		cDigital := SubStr(cParte1,1,5)+'.'+SubStr(cParte1,6,4)+cDig1+' '+;
					SubStr(cParte2,1,5)+'.'+SubStr(cParte2,6,5)+cDig2+' '+;
					SubStr(cParte3,1,5)+'.'+SubStr(cParte3,6,6)+cDig3+;
					cParte4+;
					cParte5

		Aadd(aRet,cBarra)
		Aadd(aRet,cDigital)
		Aadd(aRet,cNosso)

Return aRet
           
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºFuncao    ³ xReaVerfBarºAutor³Microsiga           º Data ³  15/07/15   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Verifica/Gera o Codigo de Barra ( Real )                   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ BOLETOS                                                    º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDATA      ³ ANALISTA ³ MOTIVO                                          º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±º          ³          ³                                                 º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Static Function xReaVerfBar(cPrefixo,cNumero,cParcela,cTipo,;
							cBanco,cAgencia,cConta,cDacCC,;
							cNroDoc,nVlrTit,cCart,cMoeda)
Local	cNosso		:= '',;
		nNum		:= '',;
		cCampoL		:= '',;
		cFatorValor	:= '',;
		cLivre		:= '',;
		cDigBarra	:= '',;
		cBarra		:= '',;
		cParte1		:= '',;
		cDig1		:= '',;
		cParte2		:= '',;
		cDig2		:= '',;
		cParte3		:= '',;
		cDig3		:= '',;
		cParte4		:= '',;
		cParte5		:= '',;
		cDigital	:= '',;
		aRet		:= {}

		cAgencia	:= StrZero(Val(cAgencia),4)
		cNosso 		:= ''

		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³Formulacao do nosso numero³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		nNum	:= StrZero(Val(cNroDoc),7)
		cNosso	:= nNum
		
		//ConOut('Nosso Numero s/ digito..:' + nNum)
		//ConOut('Nosso Numero c/ digito..:' + cNosso)

		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³Campo Livre -  ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		cCampoL := StrZero(Val(cAgencia),4) + StrZero(Val(cConta),7) + U_DIGIT001( cNosso + cAgencia + StrZero(Val(cConta),7) ) + StrZero(Val(cNosso),13)

	    //ConOut('Agencia..:' + cAgencia )
	    //ConOut('Carteira.:' + StrZero(val(cCart),2) )
	    //ConOut('Nosso Num s/digito.:' + nNum )
	    //ConOut('Conta Cedente..:' + StrZero(Val(cConta),7) )
	    ConOut('Formado campo-livre..:' + cCampoL )

		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³Campo livre do codigo de barra - verificar a conta³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		cFatorValor  := xFator()+StrZero(nVlrTit*100,10)

		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³Monta o campo Livre:³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
        // 000000000111111111122222222223333333333444444444455555555556
        // 123456789012345678901234567890123456789012345678901234567890
		// 2379?XXXX$$$$$$$$$$LLLLLLLLLLLLLLLLLLLLLLLLL
		// x  xx         x          x           x
		cLivre := cBanco + cMoeda + cFatorValor + cCampoL
        
		//ConOut('Banco..:' + cBanco )
		//ConOut('Moeda..:' + cMoeda )
		ConOut('Fator+Valor..:' + cFatorValor )
		ConOut('Campo Livre..:' + cCampoL )

		//ConOut('Codigo para gerar o codigo de barras..:' + cLivre )

		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³Campo do codigo de barra³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		cDigBarra := U_Calc_5pRe(cLivre)
		cBarra    := SubStr(cLivre,1,4)+cDigBarra+SubStr(cLivre,5,43)
		
		ConOut('Digito Calculado..:' + cDigBarra )
		ConOut('Codigo Completo...:' + cBarra )

		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³Composicao da linha digitavel³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		cParte1  := cBanco + cMoeda + SubStr(cCampoL,1,5)
		cDig1    := U_DIGIT001( cParte1 )
		cParte2  := SubStr(cCampoL,6,10)
		cDig2    := U_DIGIT001( cParte2 )
		cParte3  := SubStr(cCampoL,16,10)
		cDig3    := U_DIGIT001( cParte3 )
		cParte4  := ' '+cDigBarra+' '
		cParte5  :=  cFatorValor

		cDigital := SubStr(cParte1,1,5)+'.'+SubStr(cParte1,6,4)+cDig1+' '+;
					SubStr(cParte2,1,5)+'.'+SubStr(cParte2,6,5)+cDig2+' '+;
					SubStr(cParte3,1,5)+'.'+SubStr(cParte3,6,6)+cDig3+;
					cParte4+;
					cParte5

		Aadd(aRet,cBarra)
		Aadd(aRet,cDigital)
		Aadd(aRet,cNosso)

Return aRet

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºFuncao    ³ xBBCalcDigNºAutor³Microsiga           º Data ³  15/07/15   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Para calculo do nosso numero do banco do brasil            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ BOLETOS                                                    º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDATA      ³ ANALISTA ³  MOTIVO                                         º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±º          ³          ³                                                 º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Static Function xBBCalcDigN(cVariavel)
Local	Auxi	:= 0,;
		SumDig	:= 0

		cbase	:= cVariavel
		lbase  	:= Len(cBase)
		base   	:= 9
		sumdig 	:= 0
		Auxi   	:= 0
		iDig   	:= lBase

		While	iDig >= 1

				If	( base == 1 )
					base := 9
				EndIf

				auxi   := Val(SubStr(cBase, idig, 1)) * base
				sumdig += auxi
				base--
				iDig--

		End

		auxi := mod(Sumdig,11)

		If	( auxi == 10 )
			auxi := 'X'
		Else
			auxi := str(auxi,1,0)
		EndIf

Return(auxi)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºFuncao    ³xBraCalcDigNºAutor³Microsiga           º Data ³  15/07/15   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Para calculo do nosso numero do Bradesco....               º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Funcao Principal                                           º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDATA      ³ ANALISTA ³  MOTIVO                                         º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±º          ³          ³                                                 º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Static Function xBraCalcDigN(cVariavel)
Local	Auxi	:= 0,;
		SumDig	:= 0

		cbase	:= cVariavel
		lbase  	:= Len(cBase)
		base   	:= 2
		sumdig 	:= 0
		Auxi   	:= 0
		iDig   	:= lBase

	    //ConOut('Vou Calcular o Digito de..:' + cBase )

		While	iDig >= 1

				If	( base == 8 )
					base := 2
				EndIf

				auxi   := Val(SubStr(cBase, idig, 1)) * base
				sumdig += auxi
				base++
				iDig--
		End

		//ConOut('Somado..:' + Str(sumdig) )

		auxi := 11 - mod(Sumdig,11)

		//ConOut('Digito inicial..:' + Str(auxi) )
		
		If	( auxi == 10 )
			auxi := 'P'
		ElseIf ( auxi == 11 )
		    auxi := '0'
		Else
			auxi := str(auxi,1,0)
		EndIf

Return(auxi)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºFuncao    ³ DIGIT001 ºAutor  ³Microsiga           º Data ³  15/07/15   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Para calculo usando modulo 10                              º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Funcao Principal                                           º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDATA      ³ ANALISTA ³ MOTIVO                                          º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±º          ³          ³                                                 º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function DIGIT001(cVariavel)
Local	Auxi 	:= 0,;
		sumdig 	:= 0

		cbase  := cVariavel
		lbase  := LEN(cBase)
		umdois := 2
		sumdig := 0
		Auxi   := 0
		iDig   := lBase

		While	 ( iDig >= 1 )
				
				auxi   := Val(SubStr(cBase, idig, 1)) * umdois
				sumdig := SumDig + If (auxi < 10, auxi, (auxi-9))  
				umdois := 3 - umdois
				iDig := iDig-1
		
		End

		cValor	:= AllTrim(padl(Alltrim(str(sumdig)),12,'0'))
		nDezena	:= Val(AllTrim(Str(Val(SubStr(cvalor,11,1))+1))+'0')
		auxi 	:= nDezena - sumdig

		If	( auxi >= 10 )
			auxi := 0
		EndIf

Return(str(auxi,1,0))

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºFuncao    ³ FATOR	ºAutor  ³Microsiga           º Data ³  15/07/15   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Calculo do FATOR de vencimento para linha digitavel.       º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Funcao Principal                                           º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDATA      ³ ANALISTA ³ MOTIVO                                          º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±º          ³          ³                                                 º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Static Function xFator()

		If	Len(AllTrim(SubStr(DTOC(SE1->E1_VENCTO),7,4))) = 4
			cData := SubStr(DTOC(SE1->E1_VENCTO),7,4)+SubStr(DTOC(SE1->E1_VENCTO),4,2)+SubStr(DTOC(SE1->E1_VENCTO),1,2)
		Else
			cData := '20'+SubStr(DTOC(SE1->E1_VENCTO),7,2)+SubStr(DTOC(SE1->E1_VENCTO),4,2)+SubStr(DTOC(SE1->E1_VENCTO),1,2)
		EndIf

		cFator := STR(1000+(STOD(cData)-STOD('20000703')),4)

Return(cFator)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºFuncao    ³ CAL_5pBºAutor  ³Microsiga           º Data ³  15/07/15   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Calculo do digito do nosso numero                          º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Funcao Principal                                           º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDATA      ³ ANALISTA ³  MOTIVO                                         º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±º          ³          ³                                                 º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function CAL_5pBB(cVariavel)
Local	Auxi	:= 0,;
		sumdig	:= 0

		cbase	:= cVariavel
		lbase	:= LEN(cBase)
		base 	:= 2
		sumdig	:= 0
		Auxi 	:= 0
		iDig  	:= lBase

		While	( iDig >= 1 )
				If	( base >= 10 )
					base := 2
				EndIf
				auxi   := Val(SubStr(cBase, idig, 1)) * base
				sumdig := SumDig+auxi
				base++
				iDig--
		End

		auxi := mod(sumdig,11)
		If	( auxi == 0 ) .or. ( auxi == 1 ) .or. ( auxi >= 10 )
			auxi := 1
		Else
			auxi := 11 - auxi
		EndIf

Return(Str(auxi,1,0))

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºFuncao    ³ CAL_5pBrºAutor  ³Microsiga           º Data ³  15/07/15   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Calculo do digito do nosso numero do Bradesco              º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Funcao Principal                                           º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDATA      ³ ANALISTA ³  MOTIVO                                         º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±º          ³          ³                                                 º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function CAL_5pBr(cVariavel)
Local	Auxi	:= 0,;
		sumdig	:= 0

		cbase	:= cVariavel
		lbase	:= LEN(cBase)
		base 	:= 2
		sumdig	:= 0
		Auxi 	:= 0
		iDig  	:= lBase

		While	( iDig >= 1 )
				If	( base >= 10 )
					base := 2
				EndIf
				auxi   := Val(SubStr(cBase, idig, 1)) * base
				sumdig := SumDig+auxi
				base++
				iDig--
		End

		auxi := mod(sumdig,11)

		If	( auxi == 0 ) .or. ( auxi == 1 ) .or. ( auxi > 9 )
			auxi := 1
		Else
			auxi := 11 - auxi
		EndIf

Return(Str(auxi,1,0))

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºFuncao    ³ CALC_5pItº Autor ³Microsiga           º Data ³  15/07/15   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Calculo do digito do nosso numero do Itau                  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Funcao Principal                                           º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDATA      ³ ANALISTA ³  MOTIVO                                         º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±º          ³          ³                                                 º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function CALC_5pIt(cVariavel)
Local	Auxi	:= 0,;
		sumdig	:= 0

		cbase	:= cVariavel
		lbase	:= LEN(cBase)
		base 	:= 2
		sumdig	:= 0
		Auxi 	:= 0
		iDig  	:= lBase

		While	( iDig >= 1 )
				If	( base >= 10 )
					base := 2
				EndIf
				auxi   := Val(SubStr(cBase, idig, 1)) * base
				sumdig := SumDig+auxi
				base++
				iDig--
		End

		auxi := mod(sumdig,11)

		If	( auxi == 0 ) .or. ( auxi == 1 ) .or. ( auxi > 9 )
			auxi := 1
		Else
			auxi := 11 - auxi
		EndIf

Return(Str(auxi,1,0))

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºFuncao    ³ CALC_5pReº Autor ³Microsiga           º Data ³  15/07/15   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Calculo do digito do nosso numero do Real                  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Funcao Principal                                           º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDATA      ³ ANALISTA ³  MOTIVO                                         º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±º          ³          ³                                                 º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function CALC_5pRe(cVariavel)
Local	Auxi	:= 0,;
		sumdig	:= 0

		cbase	:= cVariavel
		lbase	:= LEN(cBase)
		base 	:= 2
		sumdig	:= 0
		Auxi 	:= 0
		iDig  	:= lBase

		While	( iDig >= 1 )
				If	( base >= 10 )
					base := 2
				EndIf
				auxi   := Val(SubStr(cBase, idig, 1)) * base
				sumdig := SumDig+auxi
				base++
				iDig--
		End

		auxi := mod(sumdig,11)

		If	( auxi == 0 ) .or. ( auxi == 1 ) .or. ( auxi > 9 )
			auxi := 1
		Else
			auxi := 11 - auxi
		EndIf

Return(Str(auxi,1,0))

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ AjustaSX1ºAutor ³ Valtenio Moura      º Data ³  15/07/15   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Ajusta o SX1 - Arquivo de Perguntas..                      º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Funcao Principal                                           º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDATA      ³ ANALISTA ³ MOTIVO                                          º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±º          ³          ³                                                 º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Static Function AjustaSX1(cPerg)
Local	aRegs   := {},;
		_sAlias := Alias(),;
		nX

		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³Campos a serem grav. no SX1³
		//³aRegs[nx][01] - X1_GRUPO   ³
		//³aRegs[nx][02] - X1_ORDEM   ³
		//³aRegs[nx][03] - X1_PERGUNTE³
		//³aRegs[nx][04] - X1_PERSPA  ³
		//³aRegs[nx][05] - X1_PERENG  ³
		//³aRegs[nx][06] - X1_VARIAVL ³
		//³aRegs[nx][07] - X1_TIPO    ³
		//³aRegs[nx][08] - X1_TAMANHO ³
		//³aRegs[nx][09] - X1_DECIMAL ³
		//³aRegs[nx][10] - X1_PRESEL  ³
		//³aRegs[nx][11] - X1_GSC     ³
		//³aRegs[nx][12] - X1_VALID   ³
		//³aRegs[nx][13] - X1_VAR01   ³
		//³aRegs[nx][14] - X1_DEF01   ³
		//³aRegs[nx][15] - X1_DEF02   ³
		//³aRegs[nx][16] - X1_DEF03   ³
		//³aRegs[nx][17] - X1_F3      ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³Cria uma array, contendo todos os valores...³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		aAdd(aRegs,{cPerg,'01','Do Prefixo         ?','Do Prefixo         ?','Do Prefixo         ?','mv_ch1','C', 3,0,0,'G','','mv_par01','','','',''})
		aAdd(aRegs,{cPerg,'02','At‚ o Prefixo      ?','At‚ o Prefixo      ?','At‚ o Prefixo      ?','mv_ch2','C', 3,0,0,'G','','mv_par02','','','',''})
		aAdd(aRegs,{cPerg,'03','Do T¡tulo          ?','Do T¡tulo          ?','Do T¡tulo          ?','mv_ch3','C', 6,0,0,'G','','mv_par03','','','',''})
		aAdd(aRegs,{cPerg,'04','At‚ o T¡tulo       ?','At‚ o T¡tulo       ?','At‚ o T¡tulo       ?','mv_ch4','C', 6,0,0,'G','','mv_par04','','','',''})
		aAdd(aRegs,{cPerg,'05','Do Banco           ?','Do Banco           ?','Do Banco           ?','mv_ch5','C', 3,0,0,'G','','mv_par05','','','','SA6'})
		aAdd(aRegs,{cPerg,'06','At‚ o Banco        ?','At‚ o Banco        ?','At‚ o Banco        ?','mv_ch6','C', 3,0,0,'G','','mv_par06','','','','SA6'})
		aAdd(aRegs,{cPerg,'07','Do Cliente         ?','Do Cliente         ?','Do Cliente         ?','mv_ch7','C', 6,0,0,'G','','mv_par07','','','','CLI'})
		aAdd(aRegs,{cPerg,'08','At‚ o Cliente      ?','At‚ o Cliente      ?','At‚ o Cliente      ?','mv_ch8','C', 6,0,0,'G','','mv_par08','','','','CLI'})
		aAdd(aRegs,{cPerg,'09','Da Loja            ?','Da Loja            ?','Da Loja            ?','mv_ch9','C', 2,0,0,'G','','mv_par09','','','',''})
		aAdd(aRegs,{cPerg,'10','At‚ a Loja         ?','At‚ a Loja         ?','At‚ a Loja         ?','mv_cha','C', 2,0,0,'G','','mv_par10','','','',''})
		aAdd(aRegs,{cPerg,'11','Do Vencimento      ?','Do Vencimento      ?','Do Vencimento      ?','mv_chb','D', 8,0,0,'G','','mv_par11','','','',''})
		aAdd(aRegs,{cPerg,'12','At‚ o Vencimento   ?','At‚ o Vencimento   ?','At‚ o Vencimento   ?','mv_chc','D', 8,0,0,'G','','mv_par12','','','',''})
		aAdd(aRegs,{cPerg,'13','Da Emiss„o         ?','Da Emiss„o         ?','Da Emiss„o         ?','mv_chd','D', 8,0,0,'G','','mv_par13','','','',''})
		aAdd(aRegs,{cPerg,'14','At‚ a Emiss„o      ?','At‚ a Emiss„o      ?','At‚ a Emiss„o      ?','mv_che','D', 8,0,0,'G','','mv_par14','','','',''})
		aAdd(aRegs,{cPerg,'15','Selecionar T¡tulos ?','Selecionar T¡tulos ?','Selecionar T¡tulos ?','mv_chf','N', 1,0,1,'C','','mv_par15','Sim','N„o','',''})
		aAdd(aRegs,{cPerg,'16','Do Bordero         ?','Do Bordero         ?','Do Bordero         ?','mv_chg','C', 6,0,0,'G','','mv_par16','','','',''})
		aAdd(aRegs,{cPerg,'17','At‚ o Bordero      ?','At‚ o Bordero      ?','At‚ o Bordero      ?','mv_chh','C', 6,0,0,'G','','mv_par17','','','',''})
		aAdd(aRegs,{cPerg,'18','Tipo de Impressão  ?','Tipo de Impressão  ?','Tipo de Impressão  ?','mv_chi','N', 1,0,1,'C','','mv_par18','Laser','DeskJet','',''})		
		aAdd(aRegs,{cPerg,'19','Do Tipo de Título  ?','Do Tipo de Título  ?','Do Tipo de Título  ?','mv_chj','C', 3,0,0,'G','','mv_par19','','','','05'})		
		aAdd(aRegs,{cPerg,'20','Até Tipo de Título ?','Até Tipo de Título ?','Até Tipo de Título ?','mv_chk','C', 3,0,0,'G','','mv_par20','','','','05'})						
		
		DbSelectArea('SX1')
		SX1->(DbSetOrder(1))
	
		For nX:=1 to Len(aRegs)
			If	( !SX1->(DbSeek(aRegs[nx][01]+aRegs[nx][02])) )
				If	RecLock('SX1',.T.)
					Replace X1_GRUPO	With aRegs[nx][01]
					Replace X1_ORDEM   	With aRegs[nx][02]
					Replace X1_PERGUNTE	With aRegs[nx][03]
					Replace X1_PERSPA	With aRegs[nx][04]
					Replace X1_PERENG	With aRegs[nx][05]
					Replace X1_VARIAVL	With aRegs[nx][06]
					Replace X1_TIPO		With aRegs[nx][07]
					Replace X1_TAMANHO	With aRegs[nx][08]
					Replace X1_DECIMAL	With aRegs[nx][09]
					Replace X1_PRESEL	With aRegs[nx][10]
					Replace X1_GSC		With aRegs[nx][11]
					Replace X1_VALID	With aRegs[nx][12]
					Replace X1_VAR01	With aRegs[nx][13]
					Replace X1_DEF01	With aRegs[nx][14]
					Replace X1_DEF02	With aRegs[nx][15]
					Replace X1_DEF03	With aRegs[nx][16]
					Replace X1_F3   	With aRegs[nx][17]
					MsUnlock('SX1')
				Else
				    Help('',1,'')
				EndIf
/*			Else
				If	RecLock('SX1',.F.)
					Replace X1_GRUPO	With aRegs[nx][01]
					Replace X1_ORDEM   	With aRegs[nx][02]
					Replace X1_PERGUNTE	With aRegs[nx][03]
					Replace X1_PERSPA	With aRegs[nx][04]
					Replace X1_PERENG	With aRegs[nx][05]
					Replace X1_VARIAVL	With aRegs[nx][06]
					Replace X1_TIPO		With aRegs[nx][07]
					Replace X1_TAMANHO	With aRegs[nx][08]
					Replace X1_DECIMAL	With aRegs[nx][09]
					Replace X1_PRESEL	With aRegs[nx][10]
					Replace X1_GSC		With aRegs[nx][11]
					Replace X1_VALID	With aRegs[nx][12]
					Replace X1_VAR01	With aRegs[nx][13]
					Replace X1_DEF01	With aRegs[nx][14]
					Replace X1_DEF02	With aRegs[nx][15]
					Replace X1_DEF03	With aRegs[nx][16]
					Replace X1_F3   	With aRegs[nx][17]
					MsUnlock('SX1')
				Else
					Help('',1,'')
				EndIf	*/
			Endif
		Next nX
Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³xVerFaturaºAutor ³ Valtenio Moura      º Data ³  15/07/15   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Verifica os titulos integrantes das faturas. !!!           º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Funcao Principal                                           º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDATA      ³ ANALISTA ³  MOTIVO                                         º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±º          ³          ³                                                 º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Static Function xVerFatura(cNumFat)
Local	aReturn	:= {}

		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³Verifica, os Titulos Originais, da FATURA Impressa Acima...³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		cSELECT :=	'SE5.E5_PREFIXO, SE5.E5_NUMERO, SE5.E5_PARCELA, SE5.E5_VALOR, '+;
					'SE5.E5_VLDESCO, SE5.E5_VLJUROS, SE5.E5_VLMULTA '

		cFROM   :=	RetSqlName('SE5') + ' SE5 '

		cWHERE  :=	"SE5.E5_FILIAL   =   '" + xFilial('SE5') + "' AND "+;
					"SE5.E5_TIPODOC  =   '" + 'BA' + "' AND "+;
					"SE5.E5_DATA     BETWEEN '20050101' AND '20301231' AND "+;
					"SE5.E5_RECPAG   =   '" + 'R'   + "' AND "+;
					"SE5.E5_SITUACA  <>  '" + 'C'   + "' AND "+;
					"SE5.E5_MOTBX    =   '" + 'FAT' + "' AND "+;
					"SE5.E5_HISTOR   LIKE '%" + cNumFat + "%' AND "+;
					"SE5.D_E_L_E_T_  <>  '*' "

		cORDER  :=	"SE5.E5_FILIAL, SE5.E5_DATA, SE5.E5_PREFIXO, SE5.E5_NUMERO, SE5.E5_PARCELA "
		
        cQuery	:= ChangeQuery(	' SELECT ' + cSELECT + ;
        						' FROM '   + cFROM   + ;
        						' WHERE '  + cWHERE  + ;
        						' ORDER BY ' + cORDER  )

		TCQUERY cQuery NEW ALIAS 'TR5'

		DbSelectArea('TR5')
		TR5->(DbGoTop())

		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³Elementos da Array³
		//³1o - Emissao      ³
		//³2o - Prefixo      ³
		//³3o - Numero       ³
		//³4o - Parcela      ³
		//³5o - Valor        ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		While	TR5->( ! Eof() )
				aAdd(aReturn,{	'',;
								TR5->E5_PREFIXO,;
								TR5->E5_NUMERO,;
								TR5->E5_PARCELA,;
								TR5->E5_VALOR+TR5->E5_VLDESCO-(TR5->E5_VLJUROS+TR5->E5_VLMULTA)})
			TR5->(DbSkip())
		End

		TR5->(DbCloseArea())

Return aReturn




/*BEGINDOC
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Funcao para validar os dados digitados na tela de seleção com relação³
//³ao banco e agencia de transferencia e ao tipo de cobrança.           ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
ENDDOC*/

STATIC FUNCTION TudoOk(oDlg)

Local _lRet   := .T.
Local _Msg    := ''

	lPortador := .f.
	lSituacao := .f.

	TRA->(DbGoTop())
	
	//Define se vai precisar da obrigatoriedade de banco e Tipo de Cobrança
	While TRA->(!EOF())
	   IF TRA->(Marked('E1_OK')) .and. Empty(TRA->E1_PORTADOR)
	      lPortador := .t.
	   End
	   If TRA->(Marked('E1_OK'))// .and. !TRA->E1_SITUAC2 $ '1/4'
	      lSituacao := .t.
	   End
	   if lPortador .and. lSituacao
	      Exit
	   End
	   
	   TRA->(DbSkip())
	End
	
	If  lPortador .and. Empty(cBcoOrig)
	   	_lRet := .F.
	   	_Msg := 'Obrigatório informar o banco de transferência !'
	EndIf
	
	If lSituacao .and. Empty(cSituaca)
		_lRet := .F.
		_Msg  += _Quebra + 'Obrigatório informar a situação de Transferência !'
	EndIf
	
	If lSituacao .and. !Empty(cSituaca) .and. !Substr(cSituaca,1,1)$'1/4'
	   _lRet := .F.
	   _Msg  += _Quebra + 'Somente situações 1 ou 4 são permitidas !'
	EndIf

	If !Empty(cBcoOrig) .and. !Substr(cSituaca,1,1)$'1/4'
	   _lRet := .F.
	   _Msg  += _Quebra + 'Somente situações 1 ou 4 são permitidas !'
	EndIf
	
	If !Empty(_Msg)
		IW_MSGBOX(_Msg, 'Atenção', "STOP")
	EndIf
	
Return _lRet

