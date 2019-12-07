.text
#############################
# Cria um tiro				
# a0: Endereço do vetor de tiros
# a1: Endereço com o "formato" do tiro
# a2: Tamanho do objeto "tiro" em bytes
# a3: Índice de escrita
# a4: Coordenada X inicial
# a5: Offset X para ajuste
############################		
createShot:				addi		sp,	sp,	-16
					sw		ra,	0(sp)
					sw		s0,	4(sp)
					sw		s1,	8(sp)
					sw		s2,	12(sp)
					
					mv		s0,	a4						# Salvando, porque será chamada uma sub rotina
					mv		s2,	a5
					mul		t0,	a2,	a3					# Cálculo do offset
					add		a0,	a0,	t0					# Aplicando
					mv		s1,	a0
					call		memcpy							# Os argumentos já estão prontos
					add		s0,	s0,	s2					# Fazemos ajuste da coordenada X
					sh		s0,	4(s1)						# Colocamos o valor da coordenada X			
					
					lw		s2,	12(sp)
					lw		s1,	8(sp)
					lw		s0,	4(sp)
					lw		ra,	0(sp)
					addi		sp,	sp,	16
					ret

#############################
# Atualiza posição do tiro			
# a0: Endereço do tiro
############################
# Faz todas as alterações na memória principal
moveShot:				lh		t0,	6(a0)						# Coordenada Y do tiro
					lb		t1,	8(a0)						# Velocidade Y
					add		t0,	t0,	t1					# Atualizando posição
					sh		t0,	6(a0)						# Salvando
					ret

#############################
# Desenha um tiro na tela e detecta colisão				
# a0: Coordenada X
# a1: Coordenada Y
# a2: Altura do tiro
# a3: Largura do tiro
# a4: Endereço do bitmap do objeto
# a5: Endereço do VGA
# a6: Endereço da booleana de colisão
############################
drawShot:				addi		sp,	sp,	-4
					sw		s0,	0(sp)
					li		s0,	0				# Váriavel que indica se já houve colisão, para não testarmos de novo se houver

					blt		a1,	zero,	drawShot.collided	# Se Y < 0, o tiro não é mais visível, então consideramos uma colisão
					li		t0,	160				# Número máximo de linhas visíveis
					sub		t1,	a1,	a2			# t1 = coordenada do topo do tiro
					bgt		t1,	t0,	drawShot.collided	# Se o topo estiver acima de 160, tiro não é visível

	drawShot.start:			beq		a2,	zero,	drawShot.finish		# while (height > 0 )
						
						# Calculando o endereço no VGA
						li		t0,	320
						mul		t0,	a1,	t0			# Y*320
						add		t0,	t0,	a0			# t0 = Y*320 + X
						add		t0,	t0,	a5			# VGAStart + t0 é o endereço		
						
						mv		t6,	a3				# t6 = j = largura do objeto					
	drawShot.drawLine:			beq		t6,	zero,	drawShot.drawLine.end 	# while (j > 0 )
							
							li		t5,	160
							bgtu		a1,	t5,	drawShot.noDraw # Fazemos o teste de visibilidade linha a linha para um desaparecimento suave
							
							lbu		t1,	0(a4)			# Pegamos o primeiro byte do bitmap do objeto
							li		t2,	RVCL			# Transparência
							beq		t1,	t2,	drawShot.noDraw # Se a cor for igual a do rio, então não pintamos
							# Colisão
							bne		s0,	zero,	drawShot.skipCol# Se já tivermos feito colisão, não fazemos de novo		
							lbu		t3,	0(t0)			# Pegamos a cor do pixel na tela		
							beq		t3,	t2,	drawShot.skipCol# Se for igual ao rio, então não há colisão
							li		s0,	1			# Houve colisão
							sb		s0,	0(a6)			# Salvamos no endereço de colisão e não fazemos mais teste														
	drawShot.skipCol:				sb		t1,	0(t0)			# Desenhamos na tela
	drawShot.noDraw:				addi		a4,	a4,	1		# Passamos para o próximo byte	
							addi		t0,	t0,	1		# Próximo endereço de pintura
							addi		t6,	t6,	-1		# j--
							j		drawShot.drawLine
							
	drawShot.drawLine.end:			addi		a1,	a1,	-1			# (Y--): Passamos para a próxima linha do objeto								
						addi		a2,	a2,	-1			# height--
						j		drawShot.start				# Se estiver como esperado, a4 já deve estar com o endereço certo
	
	drawShot.collided:		li		t0,	1					# Houve colisão, ativamos a booleana
					sb		t0,	0(a6)					# Salvamos a colisão
		
	drawShot.finish:		lw		s0,	0(sp)
					addi		sp,	sp,	4	
					ret				

#############################
# Tratamento de colisão de um tiro				
# a0: Endereço da booleana de colisão
# a1: Endereço da booleana de existência
# a2: Endereço do número de tiros
############################
shotColHandler:				lbu		t0,	0(a0)					# Pegamos a booleana de colisão
					beq		t0,	zero,	shotColHandler.end		# Se for 0, não há colisão
					li		t0,	0
					sb		t0,	0(a1)					# Mudamos a booleana de existência, assim o tiro não será mais desenhado
					lb		t1,	0(a2)					# Pegamos o número de tiros existente
					addi		t1,	t1,	-1				# Atualizamos
					bge		t1,	zero,	shotColHandler.store		# Se for maior que zero, está adequado
					li		t1,	0					# Se for menor, corrigimos
	shotColHandler.store:		sb		t1,	0(a2)
	shotColHandler.end:		ret