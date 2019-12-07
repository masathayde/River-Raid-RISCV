.text
#############################
# Desenha o jogador na tela				
# a0: Coordenada X
# a1: Coordenada Y
# a2: Altura do jogador
# a3: Largura do jogador
# a4: Endereço do bitmap do jogador
# a5: Endereço do VGA
# a6: Desenhar invertido (1 ou 0)
# a7: Endereço da variável de colisão
############################
# Uma cópia da rotina drawObject, com modificações
# Por exemplo, não há checagem de visibilidade, porque, a princípio, o jogador está sempre visível
# Draw player and Check collision
# Usa .eqv definidos fora da função
drawPlayerChkC:				addi		sp,	sp,	-4
					sw		s0,	0(sp)			

	drawPlayerChkC.start:		beq		a2,	zero,	drawPlayerChkC.finish				# while (height > 0 )
						
						# Calculando o endereço no VGA
						li		t0,	320
						mul		t0,	a1,	t0				# Y*320
						add		t0,	t0,	a0				# t0 = Y*320 + X
						add		t0,	t0,	a5				# VGAStart + t0 é o endereço		
						
						mv		t6,	a3					# t6 = j = largura do objeto
						beq		a6,	zero, drawPlayerChkC.drawLine		# Se for para inverter o sprite, executamos as próximas instruções
						add		a4,	a4,	a3				# Pegamos o endereço do final da linha
						addi		a4,	a4,	-1
						j		drawPlayerChkC.drawLineF			# Pulamos para o loop de desenho invertido de linha					
	drawPlayerChkC.drawLine:		beq		t6,	zero,	drawPlayerChkC.drawLine.end 	# while (j > 0 )
							
							# CHECAGEM DE COLISÃO	
							lbu		t1,	0(a4)				# Pegamos o primeiro byte do bitmap do objeto
							li		t5,	RVCL				# Cor do rio (nessa rotina, ignoramos os bytes com essa cor para o propósito de colisão
							beq		t1,	t5,	drawPlayerChkC.noDraw 	# Assim, ignoramos o teste de colisão
							lbu		t4,	0(t0)				# Recebe a cor do background naquele ponto
							beq		t4,	t5,	drawPlayerChkC.noColl 	# Se é rio, não fazemos nada
							li		t5,	EXPL
							beq		t4,	t5,	drawPlayerChkC.noColl 	# Se for explosão, também não fazemos nada
							li		t5,	FUEL
							bne		t4,	t5,	drawPlayerChkC.chkLeuf 	# Checamos se é combústivel
							li		s0,	2				# Guardamos o tipo de colisão em s0
							j		drawPlayerChkC.noColl			# Procedendo ao desenho
	drawPlayerChkC.chkLeuf:				li		t5,	LEUF
							bne		t4,	t5,	drawPlayerChkC.boom	# Checamos se é combústivel ruim
							li		s0,	3				# Guardamos em s0
							j		drawPlayerChkC.noColl			# Procedendo ao desenho
	drawPlayerChkC.boom:				li		s0,	1				# Se não for nenhuma dos casos anteriores, então é colisão fatal
							j		drawPlayerChkC.finish			# Cancelamos o desenho aqui mesmo						
															
	drawPlayerChkC.noColl:				sb		t1,	0(t0)				# Desenhamos na tela
	drawPlayerChkC.noDraw:				addi		a4,	a4,	1			# Passamos para o próximo byte
	
							addi		t0,	t0,	1			# Próximo endereço de pintura
							addi		t6,	t6,	-1			# j--
							j		drawPlayerChkC.drawLine
							
	
	drawPlayerChkC.drawLineF:		beq		t6,	zero,	drawPlayerChkC.drawLineF.end # while (j > 0 )
							
							# CHECAGEM DE COLISÃO	
							lbu		t1,	0(a4)				# Pegamos o primeiro byte do bitmap do objeto
							li		t5,	RVCL				# Cor do rio (nessa rotina, ignoramos os bytes com essa cor para o propósito de colisão
							beq		t1,	t5,	drawPlayerChkC.noDrawF 	# Assim, ignoramos o teste de colisão
							lbu		t4,	0(t0)				# Recebe a cor do background naquele ponto
							beq		t4,	t5,	drawPlayerChkC.noCollF 	# Se é rio, não fazemos nada
							li		t5,	EXPL
							beq		t4,	t5,	drawPlayerChkC.noCollF 	# Se for explosão, também não fazemos nada
							li		t5,	FUEL
							bne		t4,	t5,	drawPlayerChkC.chkLeufF # Checamos se é combústivel
							li		s0,	2				# Guardamos o tipo de colisão em s0
							j		drawPlayerChkC.noCollF			# Procedendo ao desenho
	drawPlayerChkC.chkLeufF:			li		t5,	LEUF
							bne		t4,	t5,	drawPlayerChkC.boomF	# Checamos se é combústivel ruim
							li		s0,	3				# Guardamos em s0
							j		drawPlayerChkC.noCollF			# Procedendo ao desenho
	drawPlayerChkC.boomF:				li		s0,	1				# Se não for nenhuma dos casos anteriores, então é colisão fatal
							j		drawPlayerChkC.finish			# Cancelamos o desenho aqui mesmo
							
	drawPlayerChkC.noCollF:				sb		t1,	0(t0)			# Desenhamos na tela
	drawPlayerChkC.noDrawF:				addi		a4,	a4,	-1		# Passamos para o próximo byte
	
							addi		t0,	t0,	1		# Próximo endereço de pintura
							addi		t6,	t6,	-1		# j--
							j		drawPlayerChkC.drawLineF						
																			
	
	drawPlayerChkC.drawLineF.end:		add		a4,	a4,	a3			# Ajustando o endereço do bitmap, após desenho de linha invertido
						addi		a4,	a4,	1
	drawPlayerChkC.drawLine.end:		addi		a1,	a1,	-1			# (Y--): Passamos para a próxima linha do objeto								
						addi		a2,	a2,	-1			# height--
						j		drawPlayerChkC.start			# Se estiver como esperado, a4 já deve estar com o endereço certo
						
	drawPlayerChkC.finish:		sb		s0,	0(a7)					# Salvamos o tipo de colisão no endereço
					lw		s0,	0(sp)
					addi		sp,	sp,	4
					ret

###########################################
# Tratamento de colisão do jogador			
# a0: Valor da colisão
# a1: Endereço da variável de combústivel
# Saídas:
# a0: Booleana que diz se houve crash
# a1: Som para tocar
###########################################
playerColHandler:			beq		a0,	zero,	playerColHandler.noCol		# Se não houve colisão, saímos
					li		t0,	1
					bne		a0,	t0,	playerColHandler.test2		# Colisão fatal
					li		a0,	1					# Booleana de crash
					li		a1,	1					# Som 1
					j		playerColHandler.end
					
	playerColHandler.test2:		li		t0,	2
					bne		a0,	t0,	playerColHandler.test3		# Colisão com combústivel
					
					la		t0,	fuelChargeRate				# Endereço de constante de recarga
					lbu		t1,	0(t0)
					lh		t2,	0(a1)					# Nível de combústivel atual
					add		t2,	t2,	t1				# Enchemos o tanque um pouco
					sh		t2,	0(a1)					# Salvando
					li		a0,	0					# Não é crash
					li		a1,	3					# Som 3	
					j		playerColHandler.end
					
	playerColHandler.test3:		li		t0,	3
					bne		a0,	t0,	playerColHandler.noCol		# Colisão com bad fuel
					la		t0,	fuelChargeRate				# Endereço de constante de recarga
					lbu		t1,	0(t0)
					lh		t2,	0(a1)					# Nível de combústivel atual
					sub		t2,	t2,	t1				# Drenamos o tanque um pouco
					sh		t2,	0(a1)					# Salvando
					li		a0,	0					# Não é crash
					li		a1,	4					# Som 4
					j		playerColHandler.end
	
	playerColHandler.noCol:		li		a0,	0
					li		a1,	0					# Não tocamos nenhum som	
	playerColHandler.end:		ret

#############################################
# Recebimento de input (RARS)
# a0: Endereço do controle do KB
# a1: Endereço do dado do KB
# a2: Valor da velocidade X
# a3: Endereço da PosX
# a4: Endereço da direção
# a5: Endereço do sprite padrão dp jogador
# a6: Endereço do sprite de virada do jogador
# a7: Endereço do espaço no qual é salvo o endereço do sprite atual
# Arg8: Endereço da velocidade de scroll da tela
# Arg9: Endereço da variável de criação de tiro
#############################################
getInputRars:				lw		t0,	0(a0)					# Pegamos o bit de controle
					andi		t0,	t0,	1				# Aplicando bitmask
					beq		t0,	zero,	getInputRars.noMove		# Se t0 == 0, não há input novo
					lw		t0,	0(a1)					# Há input novo, então o guardamos
					
					# Switch case
					li		t1,	M_LEFT
					bne		t0,	t1,	getInputRars.testRight		# Testamos se é a direção esquerda
					lhu		t2,	0(a3)					# Pegamos a posição X
					li		t1,	-1
					mul		t1,	t1,	a2				# Esquerda significa reduzir a coordenada X, então invertemos a velocidade
					add		t2,	t2,	t1				# Atualizamos a posição X
					sh		t2,	0(a3)					# Guardamos no endereço certo
					li		t1,	1					# 1 = esquerda
					sb		t1,	0(a4)					# Atualizamos a direção
					sw		a6,	0(a7)					# Atualizamos o sprite
					j		getInputRars.end				
					
	getInputRars.testRight:		li		t1,	M_RIGHT
					bne		t0,	t1,	getInputRars.testUp		# Testamos se é a direção direita
					lhu		t2,	0(a3)					# Pegamos a posição X
					add		t2,	t2,	a2				# Atualizamos a posição
					sh		t2,	0(a3)					# Guardamos no endereço certo
					li		t1,	0					# 0 = direita
					sb		t1,	0(a4)					# Atualizamos a direção
					sw		a6,	0(a7)					# Atualizamos o sprite
					j		getInputRars.end
					
	getInputRars.testUp:		li		t1,	M_UP
					bne		t0,	t1,	getInputRars.testDown		# Testamos se é cima
					la		t1,	scrollSpeedFast				# Pegamos o valor da velocidade no nível devagar
					lbu		t2,	0(t1)
					la		t1,	Arg8
					lw		t3,	0(t1)					# Pegamos o endereço onde está a velocidade de scroll da tela
					sb		t2,	0(t3)					# Atualizamos a velocidade
					sw		a5,	0(a7)
					j		getInputRars.end
					
	getInputRars.testDown:		li		t1,	M_DOWN
					bne		t0,	t1,	getInputRars.testFire		# Testamos se é baixo
					la		t1,	scrollSpeedSlow				# Pegamos o valor da velocidade no nível rápido
					lbu		t2,	0(t1)
					la		t1,	Arg8					# Pegamos o endereço onde está a velocidade de scroll da tela
					lw		t3,	0(t1)					#
					sb		t2,	0(t3)					# Atualizamos a velocidade
					sw		a5,	0(a7)
					j		getInputRars.end
					
	getInputRars.testFire:		li		t1,	M_FIRE
					bne		t0,	t1,	getInputRars.noMove		# Testamos se é tiro
					la		t1,	Arg9					
					lw		t2,	0(t1)					# Endereço da variável de criação de tiro
					li		t3,	1
					sb		t3,	0(t2)					# Colocamos 1 para pedir criação de tiro
					j		getInputRars.end
					
	getInputRars.noMove:		sw		a5,	0(a7)					# Como não houve movimento, o sprite padrão é usado
					la		t1,	Arg8					# Pegamos o endereço..
					lw		t2,	0(t1)					# ..do scroll vertical
					la		t3,	scrollSpeedNormal			# Pegamos o valor da velocidade padrão
					lbu		t4, 	0(t3)					# 
					sb		t4,	0(t2)					# Atualizamos (Isso é feito se não houver nenhum input novo)

	getInputRars.end:		ret
	
#############################################
# Recebimento de input (De1)
# a0: Endereço do eixo X
# a1: Endereço do eixo Y
# a2: Valor da velocidade X
# a3: Endereço da PosX
# a4: Endereço da direção
# a5: Endereço do sprite padrão dp jogador
# a6: Endereço do sprite de virada do jogador
# a7: Endereço do espaço no qual é salvo o endereço do sprite atual
# Arg8: Endereço da velocidade de scroll da tela
# Arg9: Endereço do sinal do botão do stick
# Arg10: Endereço da variável de criação de tiro
#############################################
getInputStick:				sw		a5,	0(a7)					# Começamos com o sprite padrão. Só será mudado se houver movimento
					la		t1,	Arg8					# Pegamos o endereço..
					lw		t2,	0(t1)					# ..do scroll vertical
					la		t3,	scrollSpeedNormal			# Pegamos o valor da velocidade padrão
					lbu		t4, 	0(t3)					# 
					sb		t4,	0(t2)					# Caso nada mude, sempre voltamos à velocidade padrão

					lw		t0,	0(a0)					# Pegamos o valor do eixo X
					lw		t1, 0(a1)					# Pegamos o valor do eixo Y
					
					
					li		t1,	400					# Valor do deadzone em direção a zero
					bge		t0,	t1,	getInputStick.testXp		# Se for maior, o jogador não está indo nessa direção
					# Vamos presumir que é a direita
					lhu		t2,	0(a3)					# Pegamos a posição X do jogador
					add		t2,	t2,	a2				# Atualizamos a posição
					sh		t2,	0(a3)					# Guardamos no endereço certo
					li		t1,	0					# 0 = direita
					sb		t1,	0(a4)					# Atualizamos a direção
					sw		a6,	0(a7)					# Atualizamos o sprite
					j		getInputStick.testYm
					
	getInputStick.testXp:		li		t1,	3695					# Valor do deadzone em direção a 1023	
					ble		t0,	t1,	getInputStick.testYm		# Se for menor, o jogador não está indo nessa direção
					# Vamos presumir esquerda
					lhu		t2,	0(a3)					# Pegamos a posição X do jogador
					li		t1,	-1
					mul		t1,	t1,	a2				# Esquerda significa reduzir a coordenada X, então invertemos a velocidade
					add		t2,	t2,	t1				# Atualizamos a posição X
					sh		t2,	0(a3)					# Guardamos no endereço certo
					li		t1,	1					# 1 = esquerda
					sb		t1,	0(a4)					# Atualizamos a direção
					sw		a6,	0(a7)					# Atualizamos o sprite
					
	getInputStick.testYm:		lw		t0,	0(a1)					# Pegamos o valor do eixo Y
					li		t1,	400					# Valor do deadzone em direção a zero
					bge		t0,	t1,	getInputStick.testYp		# Se for maior, não está indo nessa direção
					# Vamos presumir que é baixo
					la		t1,	scrollSpeedSlow				# Pegamos o valor da velocidade no nível rápido
					lbu		t2,	0(t1)
					la		t1,	Arg8					# Pegamos o endereço onde está a velocidade de scroll da tela
					lw		t3,	0(t1)					#
					sb		t2,	0(t3)					# Atualizamos a velocidade
					sw		a5,	0(a7)					# Usa o sprite padrão
					j		getInputStick.testButton
	
	getInputStick.testYp:		li		t1,	3695					# Deadzone em direção a 1023
					ble		t0,	t1,	getInputStick.testButton	# Se for menor, não está indo nessa direção
					la		t1,	scrollSpeedFast				# Pegamos o valor da velocidade no nível devagar
					lbu		t2,	0(t1)
					la		t1,	Arg8
					lw		t3,	0(t1)					# Pegamos o endereço onde está a velocidade de scroll da tela
					sb		t2,	0(t3)					# Atualizamos a velocidade
					sw		a5,	0(a7)					# Usa o sprite padrão
	
	getInputStick.testButton:	la		t0,	Arg9					# Pegamos o endereço do botão
					lw		t1,	0(t0)
					lw		t2,	0(t1)					# Pegamos o valor no endereço
					bne		t2,	zero,	getInputStick.end		# O botão é ativo em zero
					la		t1,	Arg10					
					lw		t2,	0(t1)					# Endereço da variável de criação de tiro
					li		t3,	1
					sb		t3,	0(t2)					# Colocamos 1 para pedir criação de tiro

	getInputStick.end:		ret
