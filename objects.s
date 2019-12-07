.text
#############################
# Desenha um objeto na tela				
# a0: Coordenada X
# a1: Coordenada Y
# a2: Altura do objeto
# a3: Largura do objeto
# a4: Endere�o do bitmap do objeto
# a5: Endere�o do VGA
# a6: Desenhar invertido (1 ou 0)
# a7: Endere�o da booleana de colis�o
# Testa colis�o com tiros
############################

drawObject:				addi		sp,	sp,	-4
					sw		s0,	0(sp)
					li		s0,	0				# V�riavel que indica se j� houve colis�o, para n�o testarmos de novo se houver

					blt		a1,	zero,	drawObject.finish 	# Se Y < 0, objeto n�o � vis�vel
					li		t0,	160				# N�mero m�ximo de linhas vis�veis
					sub		t1,	a1,	a2			# t1 = coordenada do topo do objeto
					bgt		t1,	t0,	drawObject.finish	# Se o topo estiver acima de 160, objeto n�o � vis�vel

	drawObject.start:		beq		a2,	zero,	drawObject.finish		# while (height > 0 )
						
						# Calculando o endere�o no VGA
						li		t0,	320
						mul		t0,	a1,	t0			# Y*320
						add		t0,	t0,	a0			# t0 = Y*320 + X
						add		t0,	t0,	a5			# VGAStart + t0 � o endere�o		
						
						mv		t6,	a3				# t6 = j = largura do objeto
						beq		a6,	zero, drawObject.drawLine	# Se for para inverter o sprite, executamos as pr�ximas instru��es
						add		a4,	a4,	a3			# Pegamos o endere�o do final da linha
						addi		a4,	a4,	-1
						j		drawObject.drawLineF			# Pulamos para o loop de desenho invertido de linha					
	drawObject.drawLine:			beq		t6,	zero,	drawObject.drawLine.end # while (j > 0 )
							
							li		t5,	160
							bgtu		a1,	t5,	drawObject.noDraw # Fazemos o teste de visibilidade linha a linha para um desaparecimento suave
							
							lbu		t1,	0(a4)			# Pegamos o primeiro byte do bitmap do objeto
							li		t2,	RVCL			# Transpar�ncia
							beq		t1,	t2,	drawObject.noDraw # Se a cor for igual a do rio, ent�o n�o pintamos
							# Colis�o
							bne		s0,	zero,	drawObject.skipCol# Se j� tivermos feito colis�o, n�o fazemos de novo							
							lbu		t3,	0(t0)			# Pegamos a cor do pixel na tela														
							li		t2,	SHOT			# Cor do tiro
							bne		t3,	t2,	drawObject.skipCol # Se n�o for igual a cor do tiro, n�o houve colis�o
							li		s0,	1			# Houve colis�o
							sb		s0,	0(a7)			# Salvamos no endere�o de colis�o e n�o fazemos mais teste																																	
	drawObject.skipCol:				sb		t1,	0(t0)			# Desenhamos na tela
	drawObject.noDraw:				addi		a4,	a4,	1		# Passamos para o pr�ximo byte
	
							addi		t0,	t0,	1		# Pr�ximo endere�o de pintura
							addi		t6,	t6,	-1		# j--
							j		drawObject.drawLine
							
	
	drawObject.drawLineF:			beq		t6,	zero,	drawObject.drawLineF.end # while (j > 0 )
							
							li		t5,	160
							bgtu		a1,	t5,	drawObject.noDrawF # Fazemos o teste de visibilidade linha a linha para um desaparecimento suave
							
							lbu		t1,	0(a4)			# Pegamos o primeiro byte do bitmap do objeto
							li		t2,	RVCL			# Transpar�ncia
							beq		t1,	t2,	drawObject.noDrawF # Se a cor for igual a do rio, ent�o n�o pintamos
							# Colis�o
							bne		s0,	zero,	drawObject.skipColF# Se j� tivermos feito colis�o, n�o fazemos de novo							
							lbu		t3,	0(t0)			# Pegamos a cor do pixel na tela														
							li		t2,	SHOT			# Cor do tiro
							bne		t3,	t2,	drawObject.skipColF # Se n�o for igual a cor do tiro, n�o houve colis�o
							li		s0,	1			# Houve colis�o
							sb		s0,	0(a7)			# Salvamos no endere�o de colis�o e n�o fazemos mais teste																											
	drawObject.skipColF:				sb		t1,	0(t0)			# Desenhamos na tela
	drawObject.noDrawF:				addi		a4,	a4,	-1		# Passamos para o pr�ximo byte
	
							addi		t0,	t0,	1		# Pr�ximo endere�o de pintura
							addi		t6,	t6,	-1		# j--
							j		drawObject.drawLineF						
																			
	
	drawObject.drawLineF.end:		add		a4,	a4,	a3			# Ajustando o endere�o do bitmap, ap�s desenho de linha invertido
						addi		a4,	a4,	1
	drawObject.drawLine.end:		addi		a1,	a1,	-1			# (Y--): Passamos para a pr�xima linha do objeto								
						addi		a2,	a2,	-1			# height--
						j		drawObject.start			# Se estiver como esperado, a4 j� deve estar com o endere�o certo
						
	drawObject.finish:		lw		s0,	0(sp)
					addi		sp,	sp,	4
					ret


#############################
# Gera um novo objeto				
# a0: Endere�o onde ser� salvo o objeto
# a1: Endere�o onde ser� salva a dire��o do objeto
# a2: Endere�o do Table com os endere�os das "formas" dos objetos
# a3: Tamanho de um objeto (usado para c�lculo de offset)
# a4: Probabilidade de gerar comb�stivel
# a5: �ndice do tipos de inimigos poss�veis
############################			
# Vamos fazer assim:
# 1) Rotina para decis�o de qual objeto ser� criado				
# Nessa rotina, decidimos se:
# a) Vamos criar Fuel ou n�o, baseado na dificuldade.
# b) Se n�o for Fuel, decidimos se � casa ou n�o, baseado na dificuldade
# c) Decidir qual inimigo colocar
# d) Decidir coordenada x ( + um offset ) onde colocar o objeto (n�o)
# e) Decidir dire��o

generateObject:				addi		sp,	sp,	-28
					sw		ra,	0(sp)
					sw		s0,	4(sp)
					sw		s1,	8(sp)
					sw		s2,	12(sp)
					sw		s3,	16(sp)
					sw		s4,	20(sp)
					sw		s5,	24(sp)
				
					mv		s0,	a0					# Salvamos os argumentos, porque a rotina chamar� outra
					mv		s1,	a1
					mv		s2,	a2
					mv		s3,	a3
					mv		s4,	a4
					mv		s5,	a5
					
					li		a7,	41					# Gerando o n�mero aleat�rio para decidir se ser� comb�stivel
					ecall
					remu		a0,	a0,	s4				# Se o resultado for igual a 0, geramos comb�stivel
					beq		a0,	zero,	generateObject.fuel
					
					ecall								# N�o � comb�stivel, ent�o geramos um novo n�mero aleat�rio
					remu		t0,	a0,	s5				# Usamos mod para colocar o n�mero dentro do intervalo poss�vel de inimigos
					addi		t0,	t0,	1				# Para excluir o comb�stivel
					mul		t0,	t0,	s3				# C�lculo do offset
					add		t0,	t0,	s2				# Aplicando offset
					mv		a0,	s0					# Destino
					mv		a1,	t0					# Origem
					mv		a2,	s3					# Tamanho em bytes
					call		memcpy
					
					li		a7,	41					# Mais um n�mero aleat�rio para decidir a dire��o do objeto
					ecall
					li		t0,	2
					remu		t1,	a0,	t0				# Pertence a {0,1}
					sb		t1,	0(s1)					# Salvando no endere�o certo				
					j		generateObject.end		
					
	generateObject.fuel:		mv		a0,	s0					# Copiamos os dados padr�es do objeto para o endere�o final
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
# a2: Offset Y ( quantidade de linhas do bloco que j� foram desenhadas)
# a3: Coordenada Y desejada
# Sa�das:
# a0: Coordenada X escolhida
# a1: Coordenada Y escolhida
############################

placeObject:				srli		t0,	a0,	4				# Isolando valor da borda
					li		t1,	0x0000000f				# Bitmask para isolar o valor do rio
					and		t2,	a0,	t1				# Isolando valor do rio
					
					li		a7,	41
					ecall								# Gerando o n�mero aleat�rio
					remu		t3,	a0,	t2				# Opera��o mod para que seja um n�mero entre os blocos de rio
					add		t3,	t3,	t0				# Temos o bloco "x" escolhido
					ecall								# Outro n�mero aleat�rio para decidir qual lado da tela
					li		t2,	2
					remu		t2,	a0,	t2				# b = 0 ou 1
					
					# F�rmula da coordenada final
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
					#li		a1,	-6					# Y inicial padr�o para um objeto novo ("fora da tela")
					#add		a1,	a1,	a2				# Ajuste necess�rio, sem ele o objetos novos seram colocados em posi��es erradas
					add		a1,	a3,	a2				# Y desejada, ajustada com o offset
					ret

#############################
# Atualiza a coordenada X do objeto
# Entradas:			
# a0: Coordenada X
# a1: Coordenada Y
# a2: Velocidade X
# a3: Dire��o do objeto
# a4: Largura do objeto
# a5: Endere�o do VGA
# a6: Tipo do objeto
# Sa�das:
# a0: Nova coordenada X
# a1: Nova dire��o
############################
# Primeiro calculamos se o movimento � v�lido, depois movemos
moveObjectX:				blt		a1,	zero,	moveObjectX.noUpdate		# Se Y < 0, n�o movimentamos o objeto
					li		t0,	320					# Calculando o endere�o no VGA
					mul		t0,	a1,	t0				# Y*320
					add		t0,	t0,	a0				# t0 = Y*320 + X
					add		t0,	t0,	a5				# VGAStart + t0 � o endere�o
					li		t1,	3					# Tipo de objeto do avi�o
					beq		a6,	t1,	moveObjectX.noBankColl		# Tipo especial de movimento, n�o colide com a terra
					
					# Detec��o de terra
					# O pixel usado para detectar colis�o depende da dire��o
					bne		a3,	zero,	moveObjectX.faceLeft		# Se for direita, continuamos aqui
					add		t1,	t0,	a4				# Pegamos o pixel mais � direita
					add		t1,	t1,	a2				# Somamos � velocidade
					lbu		t3,	0(t1)					# Pegamos a cor
					li		t2,	BANK_COLOR				# Cor da terra
					beq		t3,	t2,	moveObjectX.changeDirection	# Se for terra mudamos de dire��o
					add		a0,	a0,	a2				# N�o � terra, ent�o � uma posi��o v�lida
					li		a1,	0					# Dire��o � a mesma
					j		moveObjectX.end
					
	moveObjectX.faceLeft:		sub		t1,	t0,	a2				# Movimento para a esquerda, ent�o a velocidade � negativa, e usa-se o pixel mais � esquerda
					li		t2,	BANK_COLOR
					lbu		t3,	0(t1)					# Pegamos a cor
					beq		t3,	t2,	moveObjectX.changeDirection	# Teste igual ao caso da direita
					sub		a0,	a0,	a2				# Movimento v�lido para a esquerda
					li		a1,	1
					j		moveObjectX.end
					
	moveObjectX.noBankColl:		li		t1,	-2					# Para o c�lculo da velocidade
					mul		t1,	t1,	a3				# Se for direita, a3 = 0 e velX > 0. Se a3 = 1, velX < 0
					addi		t1,	t1,	1				# F�rmula : (-2*a3 + 1)*velX
					mul		t1,	t1,	a2				# 					
					add		a0,	a0,	t1				# Atualizando posi��o X
					bge		a0,	zero,	moveObjectX.nBCnoAdjust		# Ajuste, para caso X fique negativo
					li		a0,	300					# Fazemos um wraparound, colocando X na outra ponta da tela				
	moveObjectX.nBCnoAdjust:	j		moveObjectX.noUpdate				# Mant�m a dire��o
	
	moveObjectX.changeDirection:	xori		a3,	a3,	1				# Invertemos a dire��o e n�o atualizamos a posi��o X
	moveObjectX.noUpdate:		mv		a1,	a3					# Retornamos a mesma dire��o		
	
	moveObjectX.end:		ret

#############################
# Troca o frame de anima��o de um objeto
# Entradas:			
# a0: Ponteiro para o endere�o do frame 0 (Deve ser o primeiro word do objeto)
# a1: Ponteiro para o endere�o do frame 1
# a2: Contador de frames para troca
# a3: N�mero para a troca
# a4: Endere�o de rotina especial
# Sa�das:
# a2: Contador de frames atualizado
# Tamb�m altera o conte�do dos endere�os a0 e a1
############################

animateObject:				addi		sp,	sp,	-8
					sw		ra,	0(sp)
					sw		s0,	4(sp)
					
					beq		a3,	zero,	animateObject.end			# Se n�o for um objeto animado, n�o � feita a rotina
					mv		s0,	a2
					addi		s0,	s0,	1
					bne		s0,	a3,	animateObject.end			# Se a2 != a3, ainda n�o � hora de atualizar o frame
					bne		a4,	zero,	animateObject.special			# Se houver uma rotina especial, iremos cham�-la					
					lw		t0,	0(a0)						# Salvamos o endere�o do frame anterior em t0 temporariamente
					lw		t1,	0(a1)						# Pegamos o endere�o do frame novo para sobreescrever
					sw		t1,	0(a0)						# Trocado
					sw		t0,	0(a1)						# Trocado tamb�m
					li		s0,	0						# Resetamos o contador
					j		animateObject.end						
	
	animateObject.special:		# Lembrando que a0 e a1 est�o inalterados e v�o ser usados na rotina a seguir
					jalr		ra,	a4,	0						# Vamos at� l�
	animateObject.end:		mv		a2,	s0							# Contador atualizado
					
					
					lw		ra,	0(sp)
					lw		s0,	4(sp)
					addi		sp,	sp,	8
					ret


#############################
# Tratamento de colis�o de objeto			
# a0: Endere�o do objeto a ser substitu�do
# a1: Endere�o de objeto para substitui��o
# a2: Tamanho do objeto em bytes
# a3: Endere�o da booleana de colis�o
# a4: Endere�o da posi��o X
# a5: Endere�o da posi��o Y
# a6: Endere�o do tipo de objeto
############################
objectColHandler:			addi		sp,	sp,	-24
					sw		ra,	0(sp)
					sw		s0,	4(sp)
					sw		s1,	8(sp)
					sw		s2,	12(sp)
					sw		s3,	16(sp)
					sw		s4,	20(sp)
					
					mv		s0,	a4						# Salvando o endere�o das posi��es para colocarmos o valor certo depois...
					mv		s1,	a5						# ..da substitui��o
					lbu		s4,	0(a6)						# Pegando tipo do objeto para checagem a seguir	
					lh		s2,	0(s0)						# Valor de X
					lh		s3,	0(s1)						# Valor de Y
					lbu		t0,	0(a3)						# Testamos se houve colis�o no frame
					beq		t0,	zero,	objectColHandler.end			# Se n�o houve, nada fazemos
					call		memcpy
					li		t0,	99						# Tipo da ponte
					bne		s4,	t0,	objectColHandler.noAdjust		# Se for ponte, ajustamos o X para que a explos�o apare�a centrada
					addi		s2,	s2,	30					# Offsetzinho										
	objectColHandler.noAdjust:	sh		s2,	0(s0)						# Colocando o valor de X correto							
					sh		s3,	0(s1)						# Colocando o valor de Y correto	
																																	# Todas os argumentos est�o em posi��o				
	objectColHandler.end:		lw		ra,	0(sp)
					lw		s0,	4(sp)
					lw		s1,	8(sp)
					lw		s2,	12(sp)
					lw		s3,	16(sp)
					lw		s4,	20(sp)
					addi		sp,	sp,	24
					ret
					
#############################
# Rotina especial para troca de explos�o por espa�o vazio				
# a0: Endere�o do objeto
############################
stopExplosion:				addi		sp,	sp,	-4
					sw		ra,	0(sp)
					la		a1,	objectEmpty				# Endere�o do objeto vazio
					li		a2,	32					# Tamanho do objeto. N�mero m�gico porque pregui�a
					call		memcpy
					lw		ra,	0(sp)
					addi		sp,	sp,	4
					ret
