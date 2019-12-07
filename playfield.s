.text
############################################################
# Criar bloco no próximo espaço de 32 linhas disponível
# a0: Endereço do bloco atual (que será substituído)
# a1: Endereço para armazenar bloco atual após substituição
# a2: Número máximo de espaços de terra vindo da ponta
# a3: Número mínimo de espaços de rios
# a4: Largura mínima de abertura
############################################################
createBlock:				addi		sp,	sp,	-20				# Guardando registradores anteriores
					sw		s0,	0(sp)
					sw		s1,	4(sp)
					sw		s2,	8(sp)
					sw		s3,	12(sp)
					sw		s4,	16(sp)
					
					mv		s0,	a0					# Salvando os valores para não serem alterados na ecall de RNG
					mv		s1,	a1
									
					lbu		t6,	0(s0)					# Carregamos ID do bloco atual, para criarmos o próximo					
					li		t0,	0x0000000f				# Bitmask para separar os números correspondentes à largura do rio do bloco anterior
					and		s2,	t6,	t0				# Número de blocos de rio
					li		t0,	0x000000f0				# Agora isolando o valor de blocos de terra
					and 		s3,	t6,	t0				# Aplicação do bitmask
					srli		s3,	s3,	4				# Movendo os bits para a direita
					
					
	# Gerando o primeiro número aleatório
	# Agora precisamos levar a dificuldade em consideração na geração de blocos
	# a2 = número máximo de blocos de terra
	# a4 = número mínimo da abertura entre blocos
	# No algoritmo atual,  a largura mínima extra é sempre aplicada à esquerda		
					li		a7,	41					# Gerando o número
					ecall
					add		t1,	s2,	s3				# t1 = a+b
					blt		t1,	a2,	createBlock.minIsAB		# Vemos se a+b é menor que o número máximo
					mv		t1,	a2					# Se não for, trocamos por a2									# a' deve estar em [0, min(a+b, a2) ), para isso usamos a função mo
	createBlock.minIsAB:		sub		t1,	t1,	a4				# Levamos a largura mínima em consideração
					bgt		t1,	zero,	createBlock.ABisOK		# Caso o valor seja negativo após a operação anterior, haverá erro na próx. operação
					li		t1,	1					# Acertamos o valor de a+b, se for negativo
	createBlock.ABisOK:		remu		s4,	a0,	t1				# a' = random mod min(a+b,a2)					
	# A decisão do segundo número depende do valor do primeiro (borda esquerda). Precisamos ter certeza que não será criado um bloco impossível de ser atravessado.
					ecall								# a7 não foi alterado, pegamos novo aleatório
								
	# Fórmula: b' = R mod (7 - max(a', a)) + m + 1
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
					addi		a0,	a0,	1				# a0++ ; Fórmula completa
					add		t0,	t0,	t1				# Para calcular o valor máximo de espaços de rio possível: (7 - max(a', a)) + m
	# Considerando a dificuldade
	# a3: número mínimo de espaços de rio
					bge		a0,	a3,	createBlock.riverOK		# Se o valor aleatório calculado for maior que o mínimo permitido, OK
					mv		a0,	a3					# Se não, trocamos para o valor mínimo
					blt		a0,	t0,	createBlock.riverOK		# Mas também precisamos ter certeza que o valor mínimo não é maior que o máximo..
					mv		a0,	t0					# ..de espaços neste bloco
					
	# Hora de colocar os dois números em um byte só
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
# a0: Endereço do buffer do mapa
# a1: Offset de escrita
# a2: ID do novo bloco
#######################################				
writeBlockToPlayfield:			add		a0,	a0,	a1				# Adicionamos endereço ao offset, para acharmos o endereço de escrita
					li		t0,	0					# t0 = i = 0
					li		t1,	32					# Vamos escrever 32 linhas					
	writeBlockToPlayfield.L0:	beq		t0,	t1,	writeBlockToPlayfield.L0.end	# while (i < 32)
						
						sb		a2,	0(a0)				# Linha recebe o ID do bloco
						addi		a0,	a0,	1			# Próximo bloco
						addi		t0,	t0,	1			# i++
						j		writeBlockToPlayfield.L0
	writeBlockToPlayfield.L0.end:	ret
	

#####################################
# Desenha o mapa na tela
# a0: Endereço do buffer do mapa
# a1: Offset para começo da leitura
# a2: Offset para fim da leitura
# a3: Endereço do VGA
####################################
# Leitura acontece do endereço maior para o menor
# 160 linhas são desenhadas
renderPlayfield:			li		t0,	0					# i = 0
					li		t1,	160					# Número de linhas a desenhar					
					li		a5,	BANK_COLOR_4
					li		a6,	RIVER_COLOR_4
					add		a1,	a0,	a1				# Começamos a ler o mapa daqui
					add		a2,	a0,	a2				# Aqui terminamos				
	renderPlayfield.drawLine:	beq		t0,	t1,	renderPlayfield.drawLine.end	# while (i < 160)
						
						sw		a5,	0(a3)				# O primeiro segmento horizontal é sempre terra			
						sw		a5,	4(a3)
						sw		a5,	8(a3)
						sw		a5,	12(a3)
						sw		a5,	16(a3)
						addi		a3,	a3,	20			# Incrementamos o endereço da memória VGA
						
						lbu		t2,	0(a1)				# Pegando a ID da linha
						li		t3,	0x0000000f			# Bitmask para separar os números correspondentes à largura do rio
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
						li		t6,	7				# Número restante de terra é igual 7 - a - b
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
						mv		a7,	a3				# a7 : parte esquerda, fazendo o caminho de volta, do meio até a ponta esquerda da linha
						addi		a7,	a7,	-4
	renderPlayfield.mirrorLoop:		beq		t5,	t6,	renderPlayfield.drawLine.next # while ( j < 40)	
							
							lw		t4,	0(a7)
							sw		t4,	0(a3)
							addi		a7,	a7,	-4
							addi		a3,	a3,	4
							addi		t5,	t5,	1		# j++
							j		renderPlayfield.mirrorLoop
							
	renderPlayfield.drawLine.next:		addi		a1,	a1,	-1			# Próxima linha. Lembrando que as linhas são lidas de baixo pra cima
						bge		a1,	a0,	renderPlayfield.drawLine.noAdjust # Se sairmos do endereço do mapa, faz-se um "wrap-around" e volta-se ao fim do mapa
						addi		a1,	a0,	191			# Último endereço do mapa (última linha)
	renderPlayfield.drawLine.noAdjust:	addi		t0,	t0,	1											
						j		renderPlayfield.drawLine
			
	# Pintamos a parte inferior da tela, onde irão as informações do jogo																																																																																
	renderPlayfield.drawLine.end:		li		t1,	6400				# Número de pedaços a pintar
						li		a5,	SCORE_COLOR_4	
	renderPlayfield.drawBottom:		beq		t1,	zero,	renderPlayfield.drawBottom.end
							
							sw		a5,	0(a3)
							addi		a3,	a3,	4
							addi		t1,	t1,	-1
							j		renderPlayfield.drawBottom
						
	renderPlayfield.drawBottom.end:	ret