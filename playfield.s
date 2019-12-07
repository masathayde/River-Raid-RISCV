.text
############################################################
# Criar bloco no pr�ximo espa�o de 32 linhas dispon�vel
# a0: Endere�o do bloco atual (que ser� substitu�do)
# a1: Endere�o para armazenar bloco atual ap�s substitui��o
# a2: N�mero m�ximo de espa�os de terra vindo da ponta
# a3: N�mero m�nimo de espa�os de rios
# a4: Largura m�nima de abertura
############################################################
createBlock:				addi		sp,	sp,	-20				# Guardando registradores anteriores
					sw		s0,	0(sp)
					sw		s1,	4(sp)
					sw		s2,	8(sp)
					sw		s3,	12(sp)
					sw		s4,	16(sp)
					
					mv		s0,	a0					# Salvando os valores para n�o serem alterados na ecall de RNG
					mv		s1,	a1
									
					lbu		t6,	0(s0)					# Carregamos ID do bloco atual, para criarmos o pr�ximo					
					li		t0,	0x0000000f				# Bitmask para separar os n�meros correspondentes � largura do rio do bloco anterior
					and		s2,	t6,	t0				# N�mero de blocos de rio
					li		t0,	0x000000f0				# Agora isolando o valor de blocos de terra
					and 		s3,	t6,	t0				# Aplica��o do bitmask
					srli		s3,	s3,	4				# Movendo os bits para a direita
					
					
	# Gerando o primeiro n�mero aleat�rio
	# Agora precisamos levar a dificuldade em considera��o na gera��o de blocos
	# a2 = n�mero m�ximo de blocos de terra
	# a4 = n�mero m�nimo da abertura entre blocos
	# No algoritmo atual,  a largura m�nima extra � sempre aplicada � esquerda		
					li		a7,	41					# Gerando o n�mero
					ecall
					add		t1,	s2,	s3				# t1 = a+b
					blt		t1,	a2,	createBlock.minIsAB		# Vemos se a+b � menor que o n�mero m�ximo
					mv		t1,	a2					# Se n�o for, trocamos por a2									# a' deve estar em [0, min(a+b, a2) ), para isso usamos a fun��o mo
	createBlock.minIsAB:		sub		t1,	t1,	a4				# Levamos a largura m�nima em considera��o
					bgt		t1,	zero,	createBlock.ABisOK		# Caso o valor seja negativo ap�s a opera��o anterior, haver� erro na pr�x. opera��o
					li		t1,	1					# Acertamos o valor de a+b, se for negativo
	createBlock.ABisOK:		remu		s4,	a0,	t1				# a' = random mod min(a+b,a2)					
	# A decis�o do segundo n�mero depende do valor do primeiro (borda esquerda). Precisamos ter certeza que n�o ser� criado um bloco imposs�vel de ser atravessado.
					ecall								# a7 n�o foi alterado, pegamos novo aleat�rio
								
	# F�rmula: b' = R mod (7 - max(a', a)) + m + 1
	# m = 0, se a' >= a ; m = a - a', se a' < a
					
					# a1 = max(a', a)
					mv		a1,	s4					# a1 = a'
					mv		t1,	zero					# t1 = m = 0
					bge		s4,	s3,	createBlock.noAdjust		# Se a' >= a, pulamos
					mv		a1,	s3					# a1 = a
					sub		t1,	s3,	s4				# m = a' - a
	createBlock.noAdjust:		li		t0,	7
					sub		t0,	t0,	a1				# t0 = 7 - max(a', a)
					remu		a0,	a0,	t0				# a0 = R mod (7 - max(a', a))
					add		a0,	a0,	t1				# a0 += m
					addi		a0,	a0,	1				# a0++ ; F�rmula completa
					add		t0,	t0,	t1				# Para calcular o valor m�ximo de espa�os de rio poss�vel: (7 - max(a', a)) + m
	# Considerando a dificuldade
	# a3: n�mero m�nimo de espa�os de rio
					bge		a0,	a3,	createBlock.riverOK		# Se o valor aleat�rio calculado for maior que o m�nimo permitido, OK
					mv		a0,	a3					# Se n�o, trocamos para o valor m�nimo
					blt		a0,	t0,	createBlock.riverOK		# Mas tamb�m precisamos ter certeza que o valor m�nimo n�o � maior que o m�ximo..
					mv		a0,	t0					# ..de espa�os neste bloco
					
	# Hora de colocar os dois n�meros em um byte s�
	createBlock.riverOK:		slli		s4,	s4,	4				# Colocamos a borda esquerda na parte superior do byte
					or		a0,	a0,	s4				# Juntando os dois valores					
					sb		t6,	0(s1)					# Bloco atual se torna anterior
					sb		a0,	0(s0)					# Novo bloco gerado
					
					lw		s0,	0(sp)
					lw		s1,	4(sp)
					lw		s2,	8(sp)
					lw		s3,	12(sp)
					lw		s4,	16(sp)
					addi		sp,	sp,	20				# Desempilhar
					ret

########################################					
# Escreve o novo bloco no buffer do mapa
# a0: Endere�o do buffer do mapa
# a1: Offset de escrita
# a2: ID do novo bloco
#######################################				
writeBlockToPlayfield:			add		a0,	a0,	a1				# Adicionamos endere�o ao offset, para acharmos o endere�o de escrita
					li		t0,	0					# t0 = i = 0
					li		t1,	32					# Vamos escrever 32 linhas					
	writeBlockToPlayfield.L0:	beq		t0,	t1,	writeBlockToPlayfield.L0.end	# while (i < 32)
						
						sb		a2,	0(a0)				# Linha recebe o ID do bloco
						addi		a0,	a0,	1			# Pr�ximo bloco
						addi		t0,	t0,	1			# i++
						j		writeBlockToPlayfield.L0
	writeBlockToPlayfield.L0.end:	ret
	

#####################################
# Desenha o mapa na tela
# a0: Endere�o do buffer do mapa
# a1: Offset para come�o da leitura
# a2: Offset para fim da leitura
# a3: Endere�o do VGA
####################################
# Leitura acontece do endere�o maior para o menor
# 160 linhas s�o desenhadas
renderPlayfield:			li		t0,	0					# i = 0
					li		t1,	160					# N�mero de linhas a desenhar					
					li		a5,	BANK_COLOR_4
					li		a6,	RIVER_COLOR_4
					add		a1,	a0,	a1				# Come�amos a ler o mapa daqui
					add		a2,	a0,	a2				# Aqui terminamos				
	renderPlayfield.drawLine:	beq		t0,	t1,	renderPlayfield.drawLine.end	# while (i < 160)
						
						sw		a5,	0(a3)				# O primeiro segmento horizontal � sempre terra			
						sw		a5,	4(a3)
						sw		a5,	8(a3)
						sw		a5,	12(a3)
						sw		a5,	16(a3)
						addi		a3,	a3,	20			# Incrementamos o endere�o da mem�ria VGA
						
						lbu		t2,	0(a1)				# Pegando a ID da linha
						li		t3,	0x0000000f			# Bitmask para separar os n�meros correspondentes � largura do rio
						and		t3,	t2,	t3			# Borda direita 
						li		t4,	0x000000f0
						and		t4,	t2,	t4			# Borda esquerda
						srli		t4,	t4,	4
						
						# Pintando terra extra.
						li		t5,	0				# j = 0
	renderPlayfield.drawLeftBank:		beq		t5,	t4,	renderPlayfield.drawRiver
						
							sw		a5,	0(a3)			# Pintando mais terra
							sw		a5,	4(a3)
							sw		a5,	8(a3)
							sw		a5,	12(a3)
							sw		a5,	16(a3)	
							addi		a3,	a3,	20
							addi		t5,	t5,	1		# j++
							j		renderPlayfield.drawLeftBank
							
	renderPlayfield.drawRiver:		li		t5,	0				# j = 0
	renderPlayfield.drawRiverLoop:		beq		t5,	t3,	renderPlayfield.drawIsle
	
							sw		a6,	0(a3)			# Pintando rio
							sw		a6,	4(a3)
							sw		a6,	8(a3)
							sw		a6,	12(a3)
							sw		a6,	16(a3)
							addi		a3,	a3,	20
							addi		t5,	t5,	1		# j++
							j		renderPlayfield.drawRiverLoop
							
	renderPlayfield.drawIsle:		li		t5,	0				# j = 0
						li		t6,	7				# N�mero restante de terra � igual 7 - a - b
						sub		t6,	t6,	t3
						sub		t6,	t6,	t4
	renderPlayfield.drawIsleLoop:		beq		t5,	t6,	renderPlayfield.mirror
	
							sw		a5,	0(a3)			# Pintando mais terra
							sw		a5,	4(a3)
							sw		a5,	8(a3)
							sw		a5,	12(a3)
							sw		a5,	16(a3)
							addi		a3,	a3,	20
							addi		t5,	t5,	1		# j++
							j		renderPlayfield.drawIsleLoop
							
	renderPlayfield.mirror:			li		t5,	0
						li		t6,	40				# Agora espelhamos a parte esquerda (40 partes de 4 pixels)
						mv		a7,	a3				# a7 : parte esquerda, fazendo o caminho de volta, do meio at� a ponta esquerda da linha
						addi		a7,	a7,	-4
	renderPlayfield.mirrorLoop:		beq		t5,	t6,	renderPlayfield.drawLine.next # while ( j < 40)	
							
							lw		t4,	0(a7)
							sw		t4,	0(a3)
							addi		a7,	a7,	-4
							addi		a3,	a3,	4
							addi		t5,	t5,	1		# j++
							j		renderPlayfield.mirrorLoop
							
	renderPlayfield.drawLine.next:		addi		a1,	a1,	-1			# Pr�xima linha. Lembrando que as linhas s�o lidas de baixo pra cima
						bge		a1,	a0,	renderPlayfield.drawLine.noAdjust # Se sairmos do endere�o do mapa, faz-se um "wrap-around" e volta-se ao fim do mapa
						addi		a1,	a0,	191			# �ltimo endere�o do mapa (�ltima linha)
	renderPlayfield.drawLine.noAdjust:	addi		t0,	t0,	1											
						j		renderPlayfield.drawLine
			
	# Pintamos a parte inferior da tela, onde ir�o as informa��es do jogo																																																																																
	renderPlayfield.drawLine.end:		li		t1,	6400				# N�mero de peda�os a pintar
						li		a5,	SCORE_COLOR_4	
	renderPlayfield.drawBottom:		beq		t1,	zero,	renderPlayfield.drawBottom.end
							
							sw		a5,	0(a3)
							addi		a3,	a3,	4
							addi		t1,	t1,	-1
							j		renderPlayfield.drawBottom
						
	renderPlayfield.drawBottom.end:	ret