# Cores devem ser repetidas 4 vezes na word
.eqv BANK_COLOR 0x10101010 										# Cor da costa, deve ser verde
.eqv RIVER_COLOR 0xb0b0b0b0 										# Cor do rio, azul
.eqv SCORE_COLOR 0x0b0b0b0b
.eqv FUEL_COLOR 0x00 											# Cor do combustível

.eqv MAX_LEFT_EDGE 8

.eqv VGAADDRESSINI0     0xFF000000
.eqv VGAADDRESSFIM0     0xFF012C00
.eqv VGAADDRESSINI1     0xFF100000
.eqv VGAADDRESSFIM1     0xFF112C00 

.data
	blockList: .space 6
	blockCurrent: .byte 0x71									# Cada parte de uma dos blocos visíveis é representada por um byte
	blockPrevious: .byte 0
	pfWriteOffset: .byte 0
	pfReadStartOffset: .byte 160
	pfReadEndOffset: .byte 0
	playfield: .space 192										# 160 linhas são visíveis ao mesmo tempo, 32 a mais para armazenar novo bloco
	
.text

# Incluir SYSTEMv17 mais tarde

# Setup inicial
demo:					la 		tp,exceptionHandling	# carrega em tp o endereço base das rotinas do sistema ECALL
 					csrrw 		zero,5,tp 	# seta utvec (reg 5) para o endereço tp
 					csrrsi 		zero,0,1 	# seta o bit de habilitação de interrupção em ustatus (reg 0)

					li		a7,	30					# Usamos o tempo como seed para o RNG
					ecall
					mv		s1,	a0


					li		s0,	6					# i = 6
	InitSetup.genMap:		beq		s0,	zero,	InitSetup.genMap.end		# (while i > 0)
						
						la		a0,	blockCurrent			
						la		a1,	blockPrevious	
						mv		a2,	s1
						call		createBlock
		
						la		a0,	playfield
						la		t0,	pfWriteOffset
						lbu		a1,	0(t0)
						la		t0,	blockCurrent
						lbu		a2,	0(t0)
						call		writeBlockToPlayfield
						
						la		t0,	pfWriteOffset			# Atualizamos o offset de escrita
						lbu		t1,	0(t0)
						addi		t1,	t1,	32
						sb		t1,	0(t0)
						
						addi		s0,	s0,	-1			# i--
						j		InitSetup.genMap
						
	InitSetup.genMap.end:			la		a0,	playfield
						la		t0,	pfReadStartOffset
						lbu		a1,	0(t0)
						la		t0,	pfReadEndOffset
						lbu		a2,	0(t0)
						li		a3,	VGAADDRESSINI0
						call		renderPlayfield
						
						li		a7,	10
						ecall	
						
			

# Criar bloco no próximo espaço de 32 linhas disponível
# a0: Endereço do bloco atual (que será substituído)
# a1: Endereço para armazenar bloco atual após substituição
# a2: Seed para RNG
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
					and		s2,	t6,	t0				# Borda direita anterior. Esse será o valor mínimo da distância esquerda atual
					li		t0,	0x000000f0				# Agora isolando o valor da borda esquerda
					and 		s3,	t6,	t0				# Aplicação do bitmask
					srli		s3,	s3,	4				# Movendo os bits para a direita
					li		t1,	MAX_LEFT_EDGE				# Preparando o valor máximo do número gerado
					sub		t1,	t1,	s2
					
					
	# Como não podemos escolher valor mínimo para o RNG (sempre é 0), colocaremos o valor máximo subtraído do mínimo. Ao final, somaremos o valor mínimo ao número aleatório,
	# conseguindo, assim, o intervalo que queríamos no começo.
	# Gerando o primeiro número aleatório
 					mv		a1,	a2 					# Setting up the seed
					li		a7,	40
					ecall					
					mv		a1,	t1					# Gerando o número
					li		a7,	42
					ecall
					mv		s4,	a0					# Salvando o número gerado e somando ao valor mínimo
					add		s4,	s4,	s2
					
	# A decisão do segundo número depende do valor do primeiro (borda esquerda). Precisamos ter certeza que não será criado um bloco impossível de ser atravessado.

					mv		a1,	s4					# Valor máximo da borda direita nova deve ser menor ou igual ao da esquerda
					ble		s4,	s3,	createBlock.noRestrict		# Se o novo valor da borda esquerda for menor ou igual, não há problemas
					mv		a1,	s3					# Caso não, o valor máximo da borda direita será o valor da borda esquerda anterior					
	createBlock.noRestrict:		ecall								# Já que a7 não foi alterado..
					
	# Hora de colocar os dois números em um byte só
					slli		s4,	s4,	4				# Colocamos a borda esquerda na parte superior do byte
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
					li		a5,	BANK_COLOR
					li		a6,	RIVER_COLOR
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
						
						# Pintando terra extra
						li		t5,	0				# j = 0
						li		t6,	MAX_LEFT_EDGE			# Vemos quantos blocos de terra precisamos pintar
						sub		t6,	t6,	t4			# Max_Edge - borda esquerda nos dá o número de blocos de terra
	renderPlayfield.drawLeftBank:		beq		t5,	t6,	renderPlayfield.drawRiver
						
							sw		a5,	0(a3)			# Pintando mais terra
							sw		a5,	4(a3)
							sw		a5,	8(a3)
							sw		a5,	12(a3)
							sw		a5,	16(a3)	
							addi		a3,	a3,	20
							addi		t5,	t5,	1		# j++
							j		renderPlayfield.drawLeftBank
							
	renderPlayfield.drawRiver:		li		t5,	0				# j = 0
						sub		t6,	t4,	t3			# Borda esquerda - Borda direita - 1 = número de blocos de rio
						addi		t6,	t6,	-1
	renderPlayfield.drawRiverLoop:		beq		t5,	t6,	renderPlayfield.drawIsle
	
							sw		a6,	0(a3)			# Pintando rio
							sw		a6,	4(a3)
							sw		a6,	8(a3)
							sw		a6,	12(a3)
							sw		a6,	16(a3)
							addi		a3,	a3,	20
							addi		t5,	t5,	1		# j++
							j		renderPlayfield.drawRiverLoop
							
	renderPlayfield.drawIsle:		li		t5,	0				# j = 0
						mv		t6,	t3				# Borda direita = número de blocos da ilha ?
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
	renderPlayfield.mirrorLoop:		beq		t5,	t6,	renderPlayfield.drawLine.next # while ( j < 160)	
							
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
						li		a5,	SCORE_COLOR	
	renderPlayfield.drawBottom:		beq		t1,	zero,	renderPlayfield.drawBottom.end
							
							sw		a5,	0(a3)
							addi		a3,	a3,	4
							addi		t1,	t1,	-1
							j		renderPlayfield.drawBottom
						
	renderPlayfield.drawBottom.end:		ret
						
						

#######################
# Includes
#######################

.include "SYSTEMv17.s"