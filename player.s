.text
#############################
# Desenha o jogador na tela				
# a0: Coordenada X
# a1: Coordenada Y
# a2: Altura do jogador
# a3: Largura do jogador
# a4: Endere�o do bitmap do jogador
# a5: Endere�o do VGA
# a6: Desenhar invertido (1 ou 0)
# a7: Endere�o da vari�vel de colis�o
############################
# Uma c�pia da rotina drawObject, com modifica��es
# Por exemplo, n�o h� checagem de visibilidade, porque, a princ�pio, o jogador est� sempre vis�vel
# Draw player and Check collision
# Usa .eqv definidos fora da fun��o
drawPlayerChkC:				addi		sp,	sp,	-4
					sw		s0,	0(sp)			

	drawPlayerChkC.start:		beq		a2,	zero,	drawPlayerChkC.finish				# while (height > 0 )
						
						# Calculando o endere�o no VGA
						li		t0,	320
						mul		t0,	a1,	t0				# Y*320
						add		t0,	t0,	a0				# t0 = Y*320 + X
						add		t0,	t0,	a5				# VGAStart + t0 � o endere�o		
						
						mv		t6,	a3					# t6 = j = largura do objeto
						beq		a6,	zero, drawPlayerChkC.drawLine		# Se for para inverter o sprite, executamos as pr�ximas instru��es
						add		a4,	a4,	a3				# Pegamos o endere�o do final da linha
						addi		a4,	a4,	-1
						j		drawPlayerChkC.drawLineF			# Pulamos para o loop de desenho invertido de linha					
	drawPlayerChkC.drawLine:		beq		t6,	zero,	drawPlayerChkC.drawLine.end 	# while (j > 0 )
							
							# CHECAGEM DE COLIS�O	
							lbu		t1,	0(a4)				# Pegamos o primeiro byte do bitmap do objeto
							li		t5,	RVCL				# Cor do rio (nessa rotina, ignoramos os bytes com essa cor para o prop�sito de colis�o
							beq		t1,	t5,	drawPlayerChkC.noDraw 	# Assim, ignoramos o teste de colis�o
							lbu		t4,	0(t0)				# Recebe a cor do background naquele ponto
							beq		t4,	t5,	drawPlayerChkC.noColl 	# Se � rio, n�o fazemos nada
							li		t5,	EXPL
							beq		t4,	t5,	drawPlayerChkC.noColl 	# Se for explos�o, tamb�m n�o fazemos nada
							li		t5,	FUEL
							bne		t4,	t5,	drawPlayerChkC.chkLeuf 	# Checamos se � comb�stivel
							li		s0,	2				# Guardamos o tipo de colis�o em s0
							j		drawPlayerChkC.noColl			# Procedendo ao desenho
	drawPlayerChkC.chkLeuf:				li		t5,	LEUF
							bne		t4,	t5,	drawPlayerChkC.boom	# Checamos se � comb�stivel ruim
							li		s0,	3				# Guardamos em s0
							j		drawPlayerChkC.noColl			# Procedendo ao desenho
	drawPlayerChkC.boom:				li		s0,	1				# Se n�o for nenhuma dos casos anteriores, ent�o � colis�o fatal
							j		drawPlayerChkC.finish			# Cancelamos o desenho aqui mesmo						
															
	drawPlayerChkC.noColl:				sb		t1,	0(t0)				# Desenhamos na tela
	drawPlayerChkC.noDraw:				addi		a4,	a4,	1			# Passamos para o pr�ximo byte
	
							addi		t0,	t0,	1			# Pr�ximo endere�o de pintura
							addi		t6,	t6,	-1			# j--
							j		drawPlayerChkC.drawLine
							
	
	drawPlayerChkC.drawLineF:		beq		t6,	zero,	drawPlayerChkC.drawLineF.end # while (j > 0 )
							
							# CHECAGEM DE COLIS�O	
							lbu		t1,	0(a4)				# Pegamos o primeiro byte do bitmap do objeto
							li		t5,	RVCL				# Cor do rio (nessa rotina, ignoramos os bytes com essa cor para o prop�sito de colis�o
							beq		t1,	t5,	drawPlayerChkC.noDrawF 	# Assim, ignoramos o teste de colis�o
							lbu		t4,	0(t0)				# Recebe a cor do background naquele ponto
							beq		t4,	t5,	drawPlayerChkC.noCollF 	# Se � rio, n�o fazemos nada
							li		t5,	EXPL
							beq		t4,	t5,	drawPlayerChkC.noCollF 	# Se for explos�o, tamb�m n�o fazemos nada
							li		t5,	FUEL
							bne		t4,	t5,	drawPlayerChkC.chkLeufF # Checamos se � comb�stivel
							li		s0,	2				# Guardamos o tipo de colis�o em s0
							j		drawPlayerChkC.noCollF			# Procedendo ao desenho
	drawPlayerChkC.chkLeufF:			li		t5,	LEUF
							bne		t4,	t5,	drawPlayerChkC.boomF	# Checamos se � comb�stivel ruim
							li		s0,	3				# Guardamos em s0
							j		drawPlayerChkC.noCollF			# Procedendo ao desenho
	drawPlayerChkC.boomF:				li		s0,	1				# Se n�o for nenhuma dos casos anteriores, ent�o � colis�o fatal
							j		drawPlayerChkC.finish			# Cancelamos o desenho aqui mesmo
							
	drawPlayerChkC.noCollF:				sb		t1,	0(t0)			# Desenhamos na tela
	drawPlayerChkC.noDrawF:				addi		a4,	a4,	-1		# Passamos para o pr�ximo byte
	
							addi		t0,	t0,	1		# Pr�ximo endere�o de pintura
							addi		t6,	t6,	-1		# j--
							j		drawPlayerChkC.drawLineF						
																			
	
	drawPlayerChkC.drawLineF.end:		add		a4,	a4,	a3			# Ajustando o endere�o do bitmap, ap�s desenho de linha invertido
						addi		a4,	a4,	1
	drawPlayerChkC.drawLine.end:		addi		a1,	a1,	-1			# (Y--): Passamos para a pr�xima linha do objeto								
						addi		a2,	a2,	-1			# height--
						j		drawPlayerChkC.start			# Se estiver como esperado, a4 j� deve estar com o endere�o certo
						
	drawPlayerChkC.finish:		sb		s0,	0(a7)					# Salvamos o tipo de colis�o no endere�o
					lw		s0,	0(sp)
					addi		sp,	sp,	4
					ret

###########################################
# Tratamento de colis�o do jogador			
# a0: Valor da colis�o
# a1: Endere�o da vari�vel de comb�stivel
# Sa�das:
# a0: Booleana que diz se houve crash
# a1: Som para tocar
###########################################
playerColHandler:			beq		a0,	zero,	playerColHandler.noCol		# Se n�o houve colis�o, sa�mos
					li		t0,	1
					bne		a0,	t0,	playerColHandler.test2		# Colis�o fatal
					li		a0,	1					# Booleana de crash
					li		a1,	1					# Som 1
					j		playerColHandler.end
					
	playerColHandler.test2:		li		t0,	2
					bne		a0,	t0,	playerColHandler.test3		# Colis�o com comb�stivel
					
					la		t0,	fuelChargeRate				# Endere�o de constante de recarga
					lbu		t1,	0(t0)
					lh		t2,	0(a1)					# N�vel de comb�stivel atual
					add		t2,	t2,	t1				# Enchemos o tanque um pouco
					sh		t2,	0(a1)					# Salvando
					li		a0,	0					# N�o � crash
					li		a1,	3					# Som 3	
					j		playerColHandler.end
					
	playerColHandler.test3:		li		t0,	3
					bne		a0,	t0,	playerColHandler.noCol		# Colis�o com bad fuel
					la		t0,	fuelChargeRate				# Endere�o de constante de recarga
					lbu		t1,	0(t0)
					lh		t2,	0(a1)					# N�vel de comb�stivel atual
					sub		t2,	t2,	t1				# Drenamos o tanque um pouco
					sh		t2,	0(a1)					# Salvando
					li		a0,	0					# N�o � crash
					li		a1,	4					# Som 4
					j		playerColHandler.end
	
	playerColHandler.noCol:		li		a0,	0
					li		a1,	0					# N�o tocamos nenhum som	
	playerColHandler.end:		ret

#############################################
# Recebimento de input (RARS)
# a0: Endere�o do controle do KB
# a1: Endere�o do dado do KB
# a2: Valor da velocidade X
# a3: Endere�o da PosX
# a4: Endere�o da dire��o
# a5: Endere�o do sprite padr�o dp jogador
# a6: Endere�o do sprite de virada do jogador
# a7: Endere�o do espa�o no qual � salvo o endere�o do sprite atual
# Arg8: Endere�o da velocidade de scroll da tela
# Arg9: Endere�o da vari�vel de cria��o de tiro
#############################################
getInputRars:				lw		t0,	0(a0)					# Pegamos o bit de controle
					andi		t0,	t0,	1				# Aplicando bitmask
					beq		t0,	zero,	getInputRars.noMove		# Se t0 == 0, n�o h� input novo
					lw		t0,	0(a1)					# H� input novo, ent�o o guardamos
					
					# Switch case
					li		t1,	M_LEFT
					bne		t0,	t1,	getInputRars.testRight		# Testamos se � a dire��o esquerda
					lhu		t2,	0(a3)					# Pegamos a posi��o X
					li		t1,	-1
					mul		t1,	t1,	a2				# Esquerda significa reduzir a coordenada X, ent�o invertemos a velocidade
					add		t2,	t2,	t1				# Atualizamos a posi��o X
					sh		t2,	0(a3)					# Guardamos no endere�o certo
					li		t1,	1					# 1 = esquerda
					sb		t1,	0(a4)					# Atualizamos a dire��o
					sw		a6,	0(a7)					# Atualizamos o sprite
					j		getInputRars.end				
					
	getInputRars.testRight:		li		t1,	M_RIGHT
					bne		t0,	t1,	getInputRars.testUp		# Testamos se � a dire��o direita
					lhu		t2,	0(a3)					# Pegamos a posi��o X
					add		t2,	t2,	a2				# Atualizamos a posi��o
					sh		t2,	0(a3)					# Guardamos no endere�o certo
					li		t1,	0					# 0 = direita
					sb		t1,	0(a4)					# Atualizamos a dire��o
					sw		a6,	0(a7)					# Atualizamos o sprite
					j		getInputRars.end
					
	getInputRars.testUp:		li		t1,	M_UP
					bne		t0,	t1,	getInputRars.testDown		# Testamos se � cima
					la		t1,	scrollSpeedFast				# Pegamos o valor da velocidade no n�vel devagar
					lbu		t2,	0(t1)
					la		t1,	Arg8
					lw		t3,	0(t1)					# Pegamos o endere�o onde est� a velocidade de scroll da tela
					sb		t2,	0(t3)					# Atualizamos a velocidade
					sw		a5,	0(a7)
					j		getInputRars.end
					
	getInputRars.testDown:		li		t1,	M_DOWN
					bne		t0,	t1,	getInputRars.testFire		# Testamos se � baixo
					la		t1,	scrollSpeedSlow				# Pegamos o valor da velocidade no n�vel r�pido
					lbu		t2,	0(t1)
					la		t1,	Arg8					# Pegamos o endere�o onde est� a velocidade de scroll da tela
					lw		t3,	0(t1)					#
					sb		t2,	0(t3)					# Atualizamos a velocidade
					sw		a5,	0(a7)
					j		getInputRars.end
					
	getInputRars.testFire:		li		t1,	M_FIRE
					bne		t0,	t1,	getInputRars.noMove		# Testamos se � tiro
					la		t1,	Arg9					
					lw		t2,	0(t1)					# Endere�o da vari�vel de cria��o de tiro
					li		t3,	1
					sb		t3,	0(t2)					# Colocamos 1 para pedir cria��o de tiro
					j		getInputRars.end
					
	getInputRars.noMove:		sw		a5,	0(a7)					# Como n�o houve movimento, o sprite padr�o � usado
					la		t1,	Arg8					# Pegamos o endere�o..
					lw		t2,	0(t1)					# ..do scroll vertical
					la		t3,	scrollSpeedNormal			# Pegamos o valor da velocidade padr�o
					lbu		t4, 	0(t3)					# 
					sb		t4,	0(t2)					# Atualizamos (Isso � feito se n�o houver nenhum input novo)

	getInputRars.end:		ret
	
#############################################
# Recebimento de input (De1)
# a0: Endere�o do eixo X
# a1: Endere�o do eixo Y
# a2: Valor da velocidade X
# a3: Endere�o da PosX
# a4: Endere�o da dire��o
# a5: Endere�o do sprite padr�o dp jogador
# a6: Endere�o do sprite de virada do jogador
# a7: Endere�o do espa�o no qual � salvo o endere�o do sprite atual
# Arg8: Endere�o da velocidade de scroll da tela
# Arg9: Endere�o do sinal do bot�o do stick
# Arg10: Endere�o da vari�vel de cria��o de tiro
#############################################
getInputStick:				sw		a5,	0(a7)					# Come�amos com o sprite padr�o. S� ser� mudado se houver movimento
					la		t1,	Arg8					# Pegamos o endere�o..
					lw		t2,	0(t1)					# ..do scroll vertical
					la		t3,	scrollSpeedNormal			# Pegamos o valor da velocidade padr�o
					lbu		t4, 	0(t3)					# 
					sb		t4,	0(t2)					# Caso nada mude, sempre voltamos � velocidade padr�o

					lw		t0,	0(a0)					# Pegamos o valor do eixo X
					lw		t1, 0(a1)					# Pegamos o valor do eixo Y
					
					
					li		t1,	400					# Valor do deadzone em dire��o a zero
					bge		t0,	t1,	getInputStick.testXp		# Se for maior, o jogador n�o est� indo nessa dire��o
					# Vamos presumir que � a direita
					lhu		t2,	0(a3)					# Pegamos a posi��o X do jogador
					add		t2,	t2,	a2				# Atualizamos a posi��o
					sh		t2,	0(a3)					# Guardamos no endere�o certo
					li		t1,	0					# 0 = direita
					sb		t1,	0(a4)					# Atualizamos a dire��o
					sw		a6,	0(a7)					# Atualizamos o sprite
					j		getInputStick.testYm
					
	getInputStick.testXp:		li		t1,	3695					# Valor do deadzone em dire��o a 1023	
					ble		t0,	t1,	getInputStick.testYm		# Se for menor, o jogador n�o est� indo nessa dire��o
					# Vamos presumir esquerda
					lhu		t2,	0(a3)					# Pegamos a posi��o X do jogador
					li		t1,	-1
					mul		t1,	t1,	a2				# Esquerda significa reduzir a coordenada X, ent�o invertemos a velocidade
					add		t2,	t2,	t1				# Atualizamos a posi��o X
					sh		t2,	0(a3)					# Guardamos no endere�o certo
					li		t1,	1					# 1 = esquerda
					sb		t1,	0(a4)					# Atualizamos a dire��o
					sw		a6,	0(a7)					# Atualizamos o sprite
					
	getInputStick.testYm:		lw		t0,	0(a1)					# Pegamos o valor do eixo Y
					li		t1,	400					# Valor do deadzone em dire��o a zero
					bge		t0,	t1,	getInputStick.testYp		# Se for maior, n�o est� indo nessa dire��o
					# Vamos presumir que � baixo
					la		t1,	scrollSpeedSlow				# Pegamos o valor da velocidade no n�vel r�pido
					lbu		t2,	0(t1)
					la		t1,	Arg8					# Pegamos o endere�o onde est� a velocidade de scroll da tela
					lw		t3,	0(t1)					#
					sb		t2,	0(t3)					# Atualizamos a velocidade
					sw		a5,	0(a7)					# Usa o sprite padr�o
					j		getInputStick.testButton
	
	getInputStick.testYp:		li		t1,	3695					# Deadzone em dire��o a 1023
					ble		t0,	t1,	getInputStick.testButton	# Se for menor, n�o est� indo nessa dire��o
					la		t1,	scrollSpeedFast				# Pegamos o valor da velocidade no n�vel devagar
					lbu		t2,	0(t1)
					la		t1,	Arg8
					lw		t3,	0(t1)					# Pegamos o endere�o onde est� a velocidade de scroll da tela
					sb		t2,	0(t3)					# Atualizamos a velocidade
					sw		a5,	0(a7)					# Usa o sprite padr�o
	
	getInputStick.testButton:	la		t0,	Arg9					# Pegamos o endere�o do bot�o
					lw		t1,	0(t0)
					lw		t2,	0(t1)					# Pegamos o valor no endere�o
					bne		t2,	zero,	getInputStick.end		# O bot�o � ativo em zero
					la		t1,	Arg10					
					lw		t2,	0(t1)					# Endere�o da vari�vel de cria��o de tiro
					li		t3,	1
					sb		t3,	0(t2)					# Colocamos 1 para pedir cria��o de tiro

	getInputStick.end:		ret
