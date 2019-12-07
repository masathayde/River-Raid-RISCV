.text
#############################
# Desenha um objeto na tela				
# a0: Coordenada X
# a1: Coordenada Y
# a2: Altura do objeto
# a3: Largura do objeto
# a4: Endereço do bitmap do objeto
# a5: Endereço do VGA
# a6: Desenhar invertido (1 ou 0)
# a7: Endereço da booleana de colisão
# Testa colisão com tiros
############################

drawObject:				addi		sp,	sp,	-4
					sw		s0,	0(sp)
					li		s0,	0				# Váriavel que indica se já houve colisão, para não testarmos de novo se houver

					blt		a1,	zero,	drawObject.finish 	# Se Y < 0, objeto não é visível
					li		t0,	160				# Número máximo de linhas visíveis
					sub		t1,	a1,	a2			# t1 = coordenada do topo do objeto
					bgt		t1,	t0,	drawObject.finish	# Se o topo estiver acima de 160, objeto não é visível

	drawObject.start:		beq		a2,	zero,	drawObject.finish		# while (height > 0 )
						
						# Calculando o endereço no VGA
						li		t0,	320
						mul		t0,	a1,	t0			# Y*320
						add		t0,	t0,	a0			# t0 = Y*320 + X
						add		t0,	t0,	a5			# VGAStart + t0 é o endereço		
						
						mv		t6,	a3				# t6 = j = largura do objeto
						beq		a6,	zero, drawObject.drawLine	# Se for para inverter o sprite, executamos as próximas instruções
						add		a4,	a4,	a3			# Pegamos o endereço do final da linha
						addi		a4,	a4,	-1
						j		drawObject.drawLineF			# Pulamos para o loop de desenho invertido de linha					
	drawObject.drawLine:			beq		t6,	zero,	drawObject.drawLine.end # while (j > 0 )
							
							li		t5,	160
							bgtu		a1,	t5,	drawObject.noDraw # Fazemos o teste de visibilidade linha a linha para um desaparecimento suave
							
							lbu		t1,	0(a4)			# Pegamos o primeiro byte do bitmap do objeto
							li		t2,	RVCL			# Transparência
							beq		t1,	t2,	drawObject.noDraw # Se a cor for igual a do rio, então não pintamos
							# Colisão
							bne		s0,	zero,	drawObject.skipCol# Se já tivermos feito colisão, não fazemos de novo							
							lbu		t3,	0(t0)			# Pegamos a cor do pixel na tela														
							li		t2,	SHOT			# Cor do tiro
							bne		t3,	t2,	drawObject.skipCol # Se não for igual a cor do tiro, não houve colisão
							li		s0,	1			# Houve colisão
							sb		s0,	0(a7)			# Salvamos no endereço de colisão e não fazemos mais teste																																	
	drawObject.skipCol:				sb		t1,	0(t0)			# Desenhamos na tela
	drawObject.noDraw:				addi		a4,	a4,	1		# Passamos para o próximo byte
	
							addi		t0,	t0,	1		# Próximo endereço de pintura
							addi		t6,	t6,	-1		# j--
							j		drawObject.drawLine
							
	
	drawObject.drawLineF:			beq		t6,	zero,	drawObject.drawLineF.end # while (j > 0 )
							
							li		t5,	160
							bgtu		a1,	t5,	drawObject.noDrawF # Fazemos o teste de visibilidade linha a linha para um desaparecimento suave
							
							lbu		t1,	0(a4)			# Pegamos o primeiro byte do bitmap do objeto
							li		t2,	RVCL			# Transparência
							beq		t1,	t2,	drawObject.noDrawF # Se a cor for igual a do rio, então não pintamos
							# Colisão
							bne		s0,	zero,	drawObject.skipColF# Se já tivermos feito colisão, não fazemos de novo							
							lbu		t3,	0(t0)			# Pegamos a cor do pixel na tela														
							li		t2,	SHOT			# Cor do tiro
							bne		t3,	t2,	drawObject.skipColF # Se não for igual a cor do tiro, não houve colisão
							li		s0,	1			# Houve colisão
							sb		s0,	0(a7)			# Salvamos no endereço de colisão e não fazemos mais teste																											
	drawObject.skipColF:				sb		t1,	0(t0)			# Desenhamos na tela
	drawObject.noDrawF:				addi		a4,	a4,	-1		# Passamos para o próximo byte
	
							addi		t0,	t0,	1		# Próximo endereço de pintura
							addi		t6,	t6,	-1		# j--
							j		drawObject.drawLineF						
																			
	
	drawObject.drawLineF.end:		add		a4,	a4,	a3			# Ajustando o endereço do bitmap, após desenho de linha invertido
						addi		a4,	a4,	1
	drawObject.drawLine.end:		addi		a1,	a1,	-1			# (Y--): Passamos para a próxima linha do objeto								
						addi		a2,	a2,	-1			# height--
						j		drawObject.start			# Se estiver como esperado, a4 já deve estar com o endereço certo
						
	drawObject.finish:		lw		s0,	0(sp)
					addi		sp,	sp,	4
					ret


#############################
# Gera um novo objeto				
# a0: Endereço onde será salvo o objeto
# a1: Endereço onde será salva a direção do objeto
# a2: Endereço do Table com os endereços das "formas" dos objetos
# a3: Tamanho de um objeto (usado para cálculo de offset)
# a4: Probabilidade de gerar combústivel
# a5: Índice do tipos de inimigos possíveis
############################			
# Vamos fazer assim:
# 1) Rotina para decisão de qual objeto será criado				
# Nessa rotina, decidimos se:
# a) Vamos criar Fuel ou não, baseado na dificuldade.
# b) Se não for Fuel, decidimos se é casa ou não, baseado na dificuldade
# c) Decidir qual inimigo colocar
# d) Decidir coordenada x ( + um offset ) onde colocar o objeto (não)
# e) Decidir direção

generateObject:				addi		sp,	sp,	-28
					sw		ra,	0(sp)
					sw		s0,	4(sp)
					sw		s1,	8(sp)
					sw		s2,	12(sp)
					sw		s3,	16(sp)
					sw		s4,	20(sp)
					sw		s5,	24(sp)
				
					mv		s0,	a0					# Salvamos os argumentos, porque a rotina chamará outra
					mv		s1,	a1
					mv		s2,	a2
					mv		s3,	a3
					mv		s4,	a4
					mv		s5,	a5
					
					li		a7,	41					# Gerando o número aleatório para decidir se será combústivel
					ecall
					remu		a0,	a0,	s4				# Se o resultado for igual a 0, geramos combústivel
					beq		a0,	zero,	generateObject.fuel
					
					ecall								# Não é combústivel, então geramos um novo número aleatório
					remu		t0,	a0,	s5				# Usamos mod para colocar o número dentro do intervalo possível de inimigos
					addi		t0,	t0,	1				# Para excluir o combústivel
					mul		t0,	t0,	s3				# Cálculo do offset
					add		t0,	t0,	s2				# Aplicando offset
					mv		a0,	s0					# Destino
					mv		a1,	t0					# Origem
					mv		a2,	s3					# Tamanho em bytes
					call		memcpy
					
					li		a7,	41					# Mais um número aleatório para decidir a direção do objeto
					ecall
					li		t0,	2
					remu		t1,	a0,	t0				# Pertence a {0,1}
					sb		t1,	0(s1)					# Salvando no endereço certo				
					j		generateObject.end		
					
	generateObject.fuel:		mv		a0,	s0					# Copiamos os dados padrões do objeto para o endereço final
					mv		a1,	s2
					mv		a2,	s3
					call		memcpy					
					
	generateObject.end:		lw		ra,	0(sp)
					lw		s0,	4(sp)
					lw		s1,	8(sp)
					lw		s2,	12(sp)
					lw		s3,	16(sp)
					lw		s4,	20(sp)
					lw		s5,	24(sp)
					addi		sp,	sp,	28
					ret

#############################
# Decide a coordenada X do objeto baseado no ID do bloco
# Entradas:			
# a0: ID do bloco
# a1: Largura do objeto
# a2: Offset Y ( quantidade de linhas do bloco que já foram desenhadas)
# a3: Coordenada Y desejada
# Saídas:
# a0: Coordenada X escolhida
# a1: Coordenada Y escolhida
############################

placeObject:				srli		t0,	a0,	4				# Isolando valor da borda
					li		t1,	0x0000000f				# Bitmask para isolar o valor do rio
					and		t2,	a0,	t1				# Isolando valor do rio
					
					li		a7,	41
					ecall								# Gerando o número aleatório
					remu		t3,	a0,	t2				# Operação mod para que seja um número entre os blocos de rio
					add		t3,	t3,	t0				# Temos o bloco "x" escolhido
					ecall								# Outro número aleatório para decidir qual lado da tela
					li		t2,	2
					remu		t2,	a0,	t2				# b = 0 ou 1
					
					# Fórmula da coordenada final
					# X = [13*b + (-2*b + 1)*x]*20 + 20
					# t3 = x, t2 = b
					li		t0,	-2					# -2
					mul		t0,	t0,	t2				# -2*b
					addi		t0,	t0,	1				# -2*b + 1
					mul		t0,	t0,	t3				# (-2*b + 1)*x
					li		t1,	13
					mul		t1,	t1,	t2				# 13*b
					add		t0,	t0,	t1				# [13*b + (-2*b + 1)*x]
					li		t4,	20
					mul		t0,	t0,	t4				# [13*b + (-2*b + 1)*x]*20
					add		t0,	t0,	t4				# [13*b + (-2*b + 1)*x]*20 + 20
					mv		a0,	t0					# Colocamos em a0 para retornar
					#li		a1,	-6					# Y inicial padrão para um objeto novo ("fora da tela")
					#add		a1,	a1,	a2				# Ajuste necessário, sem ele o objetos novos seram colocados em posições erradas
					add		a1,	a3,	a2				# Y desejada, ajustada com o offset
					ret

#############################
# Atualiza a coordenada X do objeto
# Entradas:			
# a0: Coordenada X
# a1: Coordenada Y
# a2: Velocidade X
# a3: Direção do objeto
# a4: Largura do objeto
# a5: Endereço do VGA
# a6: Tipo do objeto
# Saídas:
# a0: Nova coordenada X
# a1: Nova direção
############################
# Primeiro calculamos se o movimento é válido, depois movemos
moveObjectX:				blt		a1,	zero,	moveObjectX.noUpdate		# Se Y < 0, não movimentamos o objeto
					li		t0,	320					# Calculando o endereço no VGA
					mul		t0,	a1,	t0				# Y*320
					add		t0,	t0,	a0				# t0 = Y*320 + X
					add		t0,	t0,	a5				# VGAStart + t0 é o endereço
					li		t1,	3					# Tipo de objeto do avião
					beq		a6,	t1,	moveObjectX.noBankColl		# Tipo especial de movimento, não colide com a terra
					
					# Detecção de terra
					# O pixel usado para detectar colisão depende da direção
					bne		a3,	zero,	moveObjectX.faceLeft		# Se for direita, continuamos aqui
					add		t1,	t0,	a4				# Pegamos o pixel mais à direita
					add		t1,	t1,	a2				# Somamos à velocidade
					lbu		t3,	0(t1)					# Pegamos a cor
					li		t2,	BANK_COLOR				# Cor da terra
					beq		t3,	t2,	moveObjectX.changeDirection	# Se for terra mudamos de direção
					add		a0,	a0,	a2				# Não é terra, então é uma posição válida
					li		a1,	0					# Direção é a mesma
					j		moveObjectX.end
					
	moveObjectX.faceLeft:		sub		t1,	t0,	a2				# Movimento para a esquerda, então a velocidade é negativa, e usa-se o pixel mais à esquerda
					li		t2,	BANK_COLOR
					lbu		t3,	0(t1)					# Pegamos a cor
					beq		t3,	t2,	moveObjectX.changeDirection	# Teste igual ao caso da direita
					sub		a0,	a0,	a2				# Movimento válido para a esquerda
					li		a1,	1
					j		moveObjectX.end
					
	moveObjectX.noBankColl:		li		t1,	-2					# Para o cálculo da velocidade
					mul		t1,	t1,	a3				# Se for direita, a3 = 0 e velX > 0. Se a3 = 1, velX < 0
					addi		t1,	t1,	1				# Fórmula : (-2*a3 + 1)*velX
					mul		t1,	t1,	a2				# 					
					add		a0,	a0,	t1				# Atualizando posição X
					bge		a0,	zero,	moveObjectX.nBCnoAdjust		# Ajuste, para caso X fique negativo
					li		a0,	300					# Fazemos um wraparound, colocando X na outra ponta da tela				
	moveObjectX.nBCnoAdjust:	j		moveObjectX.noUpdate				# Mantém a direção
	
	moveObjectX.changeDirection:	xori		a3,	a3,	1				# Invertemos a direção e não atualizamos a posição X
	moveObjectX.noUpdate:		mv		a1,	a3					# Retornamos a mesma direção		
	
	moveObjectX.end:		ret

#############################
# Troca o frame de animação de um objeto
# Entradas:			
# a0: Ponteiro para o endereço do frame 0 (Deve ser o primeiro word do objeto)
# a1: Ponteiro para o endereço do frame 1
# a2: Contador de frames para troca
# a3: Número para a troca
# a4: Endereço de rotina especial
# Saídas:
# a2: Contador de frames atualizado
# Também altera o conteúdo dos endereços a0 e a1
############################

animateObject:				addi		sp,	sp,	-8
					sw		ra,	0(sp)
					sw		s0,	4(sp)
					
					beq		a3,	zero,	animateObject.end			# Se não for um objeto animado, não é feita a rotina
					mv		s0,	a2
					addi		s0,	s0,	1
					bne		s0,	a3,	animateObject.end			# Se a2 != a3, ainda não é hora de atualizar o frame
					bne		a4,	zero,	animateObject.special			# Se houver uma rotina especial, iremos chamá-la					
					lw		t0,	0(a0)						# Salvamos o endereço do frame anterior em t0 temporariamente
					lw		t1,	0(a1)						# Pegamos o endereço do frame novo para sobreescrever
					sw		t1,	0(a0)						# Trocado
					sw		t0,	0(a1)						# Trocado também
					li		s0,	0						# Resetamos o contador
					j		animateObject.end						
	
	animateObject.special:		# Lembrando que a0 e a1 estão inalterados e vão ser usados na rotina a seguir
					jalr		ra,	a4,	0						# Vamos até lá
	animateObject.end:		mv		a2,	s0							# Contador atualizado
					
					
					lw		ra,	0(sp)
					lw		s0,	4(sp)
					addi		sp,	sp,	8
					ret


#############################
# Tratamento de colisão de objeto			
# a0: Endereço do objeto a ser substituído
# a1: Endereço de objeto para substituição
# a2: Tamanho do objeto em bytes
# a3: Endereço da booleana de colisão
# a4: Endereço da posição X
# a5: Endereço da posição Y
# a6: Endereço do tipo de objeto
############################
objectColHandler:			addi		sp,	sp,	-24
					sw		ra,	0(sp)
					sw		s0,	4(sp)
					sw		s1,	8(sp)
					sw		s2,	12(sp)
					sw		s3,	16(sp)
					sw		s4,	20(sp)
					
					mv		s0,	a4						# Salvando o endereço das posições para colocarmos o valor certo depois...
					mv		s1,	a5						# ..da substituição
					lbu		s4,	0(a6)						# Pegando tipo do objeto para checagem a seguir	
					lh		s2,	0(s0)						# Valor de X
					lh		s3,	0(s1)						# Valor de Y
					lbu		t0,	0(a3)						# Testamos se houve colisão no frame
					beq		t0,	zero,	objectColHandler.end			# Se não houve, nada fazemos
					call		memcpy
					li		t0,	99						# Tipo da ponte
					bne		s4,	t0,	objectColHandler.noAdjust		# Se for ponte, ajustamos o X para que a explosão apareça centrada
					addi		s2,	s2,	30					# Offsetzinho										
	objectColHandler.noAdjust:	sh		s2,	0(s0)						# Colocando o valor de X correto							
					sh		s3,	0(s1)						# Colocando o valor de Y correto	
																																	# Todas os argumentos estão em posição				
	objectColHandler.end:		lw		ra,	0(sp)
					lw		s0,	4(sp)
					lw		s1,	8(sp)
					lw		s2,	12(sp)
					lw		s3,	16(sp)
					lw		s4,	20(sp)
					addi		sp,	sp,	24
					ret
					
#############################
# Rotina especial para troca de explosão por espaço vazio				
# a0: Endereço do objeto
############################
stopExplosion:				addi		sp,	sp,	-4
					sw		ra,	0(sp)
					la		a1,	objectEmpty				# Endereço do objeto vazio
					li		a2,	32					# Tamanho do objeto. Número mágico porque preguiça
					call		memcpy
					lw		ra,	0(sp)
					addi		sp,	sp,	4
					ret
