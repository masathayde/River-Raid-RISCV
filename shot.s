.text
#############################
# Cria um tiro				
# a0: Endere�o do vetor de tiros
# a1: Endere�o com o "formato" do tiro
# a2: Tamanho do objeto "tiro" em bytes
# a3: �ndice de escrita
# a4: Coordenada X inicial
# a5: Offset X para ajuste
############################		
createShot:				addi		sp,	sp,	-16
					sw		ra,	0(sp)
					sw		s0,	4(sp)
					sw		s1,	8(sp)
					sw		s2,	12(sp)
					
					mv		s0,	a4						# Salvando, porque ser� chamada uma sub rotina
					mv		s2,	a5
					mul		t0,	a2,	a3					# C�lculo do offset
					add		a0,	a0,	t0					# Aplicando
					mv		s1,	a0
					call		memcpy							# Os argumentos j� est�o prontos
					add		s0,	s0,	s2					# Fazemos ajuste da coordenada X
					sh		s0,	4(s1)						# Colocamos o valor da coordenada X			
					
					lw		s2,	12(sp)
					lw		s1,	8(sp)
					lw		s0,	4(sp)
					lw		ra,	0(sp)
					addi		sp,	sp,	16
					ret

#############################
# Atualiza posi��o do tiro			
# a0: Endere�o do tiro
############################
# Faz todas as altera��es na mem�ria principal
moveShot:				lh		t0,	6(a0)						# Coordenada Y do tiro
					lb		t1,	8(a0)						# Velocidade Y
					add		t0,	t0,	t1					# Atualizando posi��o
					sh		t0,	6(a0)						# Salvando
					ret

#############################
# Desenha um tiro na tela e detecta colis�o				
# a0: Coordenada X
# a1: Coordenada Y
# a2: Altura do tiro
# a3: Largura do tiro
# a4: Endere�o do bitmap do objeto
# a5: Endere�o do VGA
# a6: Endere�o da booleana de colis�o
############################
drawShot:				addi		sp,	sp,	-4
					sw		s0,	0(sp)
					li		s0,	0				# V�riavel que indica se j� houve colis�o, para n�o testarmos de novo se houver

					blt		a1,	zero,	drawShot.collided	# Se Y < 0, o tiro n�o � mais vis�vel, ent�o consideramos uma colis�o
					li		t0,	160				# N�mero m�ximo de linhas vis�veis
					sub		t1,	a1,	a2			# t1 = coordenada do topo do tiro
					bgt		t1,	t0,	drawShot.collided	# Se o topo estiver acima de 160, tiro n�o � vis�vel

	drawShot.start:			beq		a2,	zero,	drawShot.finish		# while (height > 0 )
						
						# Calculando o endere�o no VGA
						li		t0,	320
						mul		t0,	a1,	t0			# Y*320
						add		t0,	t0,	a0			# t0 = Y*320 + X
						add		t0,	t0,	a5			# VGAStart + t0 � o endere�o		
						
						mv		t6,	a3				# t6 = j = largura do objeto					
	drawShot.drawLine:			beq		t6,	zero,	drawShot.drawLine.end 	# while (j > 0 )
							
							li		t5,	160
							bgtu		a1,	t5,	drawShot.noDraw # Fazemos o teste de visibilidade linha a linha para um desaparecimento suave
							
							lbu		t1,	0(a4)			# Pegamos o primeiro byte do bitmap do objeto
							li		t2,	RVCL			# Transpar�ncia
							beq		t1,	t2,	drawShot.noDraw # Se a cor for igual a do rio, ent�o n�o pintamos
							# Colis�o
							bne		s0,	zero,	drawShot.skipCol# Se j� tivermos feito colis�o, n�o fazemos de novo		
							lbu		t3,	0(t0)			# Pegamos a cor do pixel na tela		
							beq		t3,	t2,	drawShot.skipCol# Se for igual ao rio, ent�o n�o h� colis�o
							li		s0,	1			# Houve colis�o
							sb		s0,	0(a6)			# Salvamos no endere�o de colis�o e n�o fazemos mais teste														
	drawShot.skipCol:				sb		t1,	0(t0)			# Desenhamos na tela
	drawShot.noDraw:				addi		a4,	a4,	1		# Passamos para o pr�ximo byte	
							addi		t0,	t0,	1		# Pr�ximo endere�o de pintura
							addi		t6,	t6,	-1		# j--
							j		drawShot.drawLine
							
	drawShot.drawLine.end:			addi		a1,	a1,	-1			# (Y--): Passamos para a pr�xima linha do objeto								
						addi		a2,	a2,	-1			# height--
						j		drawShot.start				# Se estiver como esperado, a4 j� deve estar com o endere�o certo
	
	drawShot.collided:		li		t0,	1					# Houve colis�o, ativamos a booleana
					sb		t0,	0(a6)					# Salvamos a colis�o
		
	drawShot.finish:		lw		s0,	0(sp)
					addi		sp,	sp,	4	
					ret				

#############################
# Tratamento de colis�o de um tiro				
# a0: Endere�o da booleana de colis�o
# a1: Endere�o da booleana de exist�ncia
# a2: Endere�o do n�mero de tiros
############################
shotColHandler:				lbu		t0,	0(a0)					# Pegamos a booleana de colis�o
					beq		t0,	zero,	shotColHandler.end		# Se for 0, n�o h� colis�o
					li		t0,	0
					sb		t0,	0(a1)					# Mudamos a booleana de exist�ncia, assim o tiro n�o ser� mais desenhado
					lb		t1,	0(a2)					# Pegamos o n�mero de tiros existente
					addi		t1,	t1,	-1				# Atualizamos
					bge		t1,	zero,	shotColHandler.store		# Se for maior que zero, est� adequado
					li		t1,	0					# Se for menor, corrigimos
	shotColHandler.store:		sb		t1,	0(a2)
	shotColHandler.end:		ret