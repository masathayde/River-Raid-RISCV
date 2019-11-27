# Cores devem ser repetidas 4 vezes na word
.eqv BANK_COLOR 0x10101010 										# Cor da costa, deve ser verde
.eqv RIVER_COLOR 0xb0b0b0b0 										# Cor do rio, azul
.eqv SCORE_COLOR 0x0b0b0b0b
.eqv FUEL_COLOR 0x00 											# Cor do combust�vel

.eqv MAX_BANK_SIZE 7											

.eqv TIMESTEP 40											# Em ms

.eqv VGAADDRESSINI0     0xFF000000
.eqv VGAADDRESSFIM0     0xFF012C00
.eqv VGAADDRESSINI1     0xFF100000
.eqv VGAADDRESSFIM1     0xFF112C00 
.eqv VGAFRAMESELECT	0xFF200604

.data
	# Tentar agrupar todos os words no come�o para n�o precisar usar .align
	gameTime: .word 0

	framePtr: .word 0
	
	
	gameLevel: .byte 0										# Dificuldade
	
	
	frameToShow: .byte 1
	scrollSpeed: .byte 9

	blockWriteOffset: .byte 0
	blockCurrent: .byte 0x07									# Cada parte de uma dos blocos vis�veis � representada por um byte
	blockPrevious: .byte 0
	
	lineDrawnCounter: .byte 0									# Contador do n�mero de linhas desenhado, para decidirmos se precisamos de um novo bloco
	
	pfWriteOffset: .byte 0
	pfReadStartOffset: .byte 160
	pfReadEndOffset: .byte 0
	playfield: .space 192										# 160 linhas s�o vis�veis ao mesmo tempo, 32 a mais para armazenar novo bloco
	
	
	.align 2
		
	objectPtrList: .space 24										# Somente 6 objetos por tela
	
	object0: .space 50
	# objectType: .byte
	# objectState: .byte			
	# objectXpos: .byte
	# objectYpos: .byte
	# objectXspeed: .byte
	# objectHeight: .byte
	# objectWidth: .byte
	# objectDirection: .byte
	# objectAnimationCounter: .byte
	# objectIsAnim: .byte
	# objectBitmapPtr: .word
	
.text

# Incluir SYSTEMv17 mais tarde
# Incluir explica��o sobre o byte do bloco e como � usado para gerar uma linha

# Setup inicial
Main:					la 		tp,exceptionHandling	# carrega em tp o endere�o base das rotinas do sistema ECALL
 					csrrw 		zero,5,tp 		# seta utvec (reg 5) para o endere�o tp
 					csrrsi 		zero,0,1 		# seta o bit de habilita��o de interrup��o em ustatus (reg 0)

	# Preparamos tudo que for necess�rio para come�ar o jogo.
	InitSetup:

					li		s0,	6					# i = 6
	InitSetup.genMap:		beq		s0,	zero,	InitSetup.genMap.end		# (while i > 0)
						
						la		a0,	blockCurrent			# Gera��o dos blocos no mapa	
						la		a1,	blockPrevious
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
						li		t2,	192
						remu		t1,	t1,	t2			# Wraparound
						sb		t1,	0(t0)
						
						
						addi		s0,	s0,	-1			# i--
						j		InitSetup.genMap
						
	InitSetup.genMap.end:
	
	
	InitSetup.end:
	
	# Loop principal do jogo
	# Pegamos o tempo no come�o de cada ciclo para calcularmos o tempo de sleep no final, com base no time step escolhido
	MainLoop:				nop # placeholder
	
						# Get Frame Start Time
						# Para o RARS
						la		t0,	gameTime			# Aqui salvaremos o tempo no come�o do ciclo
						li		a7,	30				# Chamamos o ecall time
						ecall						
						sw		a0,	0(t0)				# Salvamos em time
			
			
	# Fase de renderiza��o
	# Usa-se a t�cnica de double buffering para evitar o efeito de "piscamento"
	Render:					la		t0,	frameToShow			# Trocamos de frame
						la		t2,	framePtr			# Ponteiro para o frame no qual ser� desenhado o mapa
						lbu		t1,	0(t0)
						xori		t1,	t1,	1			# O uso de xor inverte o bit
						sb		t1,	0(t0)				# Guardamos o valor de volta em frameToShow
						li		t3,	VGAADDRESSINI0			# Inicialmente escolhemos o frame 0
						beq		t1,	zero,	Render.selectF0		# Mas � realmente o frame 0?
						li		t3,	VGAADDRESSINI1			# N�o, ent�o escolhe-se frame 1						
	Render.selectF0:			sw		t3,	0(t2)				# Salvar em framePtr
						
	
						la		a0,	playfield			# Carrega endere�o do mapa
						la		t0,	pfReadStartOffset		# Carrega posi��o de �nicio de leitura
						lbu		a1,	0(t0)
						la		t0,	pfReadEndOffset			# Carrega posi��o de final de leitura
						lbu		a2,	0(t0)
						la		t0,	framePtr			# Endere�o do frame a desenhar
						lw		a3,	0(t0)
						call		renderPlayfield
						
						la		t0,	frameToShow			# Terminamos de desenhar, ent�o mostramos o frame
						lbu		t1,	0(t0)
						li		t0,	VGAFRAMESELECT
						sb		t1,	0(t0)
	# Update					
						# Atualiza��o dos offsets
						la		t0,	pfReadStartOffset		# Pegando o offset atual
						lbu		t1,	0(t0)
						la		t2,	scrollSpeed			# Pegando velocidade de scroll
						lbu		t3,	0(t2)
						add		t1,	t1,	t3			# Atualizando o offset em si
						li		t4,	192				# Fazendo o wrap around (se o offset passar de 192, deve voltar ao come�o)
						remu		t1,	t1,	t4
						sb		t1,	0(t0)
						
						# Checagem para cria��o de bloco novo
						la		t0,	lineDrawnCounter
						lbu		t1,	(t0)
						la		t2,	scrollSpeed
						lbu		t3,	0(t2)
						add		t1,	t1,	t3
						li		t4,	32
						remu		t5,	t1,	t4			# Resetamos o contador, mas com o n�mero de linhas acima de 32
						sb		t5,	0(t0)				# Armazenamos na mem�ria o valor
						blt		t1,	t4,	NoNewBlock		# Se foram desenhadas menos de 32 linhas, nada a fazer
						
						la		a0,	blockCurrent			# Gera��o do bloco novo
						la		a1,	blockPrevious
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
						li		t2,	192
						remu		t1,	t1,	t2			# Wraparound
						sb		t1,	0(t0)						
	NoNewBlock:				nop
						
						
	# TESTE					
						la		t0, testObjY
						lw		t1, 0(t0)
						addi		t1,	t1,	9
						sw		t1, 0(t0)
	
						li		a0, 120
						la		t0, testObjY
						lw		a1, 0(t0)
						#li		a1, 140
						li		a2, 10
						li		a3, 8
						la		a4, testObj
						la		t0, framePtr
						lw		a5, 0(t0)
						call	drawObject
								
						
						
	
						# C�lculo de sleep time
	Wait:					nop
						la		t0,	gameTime			# Recuperamos o tempo salvo no come�o do ciclo
						lw		t1,	0(t0)
						####### RARS {			
						li		a7,	30				# Pegando o tempo novo
						ecall
						####### } RARS												
						sub		t1,	a0,	t1			# Calculamos quanto tempo se passou
						li		t2,	TIMESTEP			
						sub		t2,	t2,	t1			# Calculamos quanto tempo a mais precisamos esperar
						bge		t2,	zero,	Wait.noAdjust		# Caso tenha se passado mais tempo que o time step, corrigimos o valor de wait para zero
						li		t2,	0
	Wait.noAdjust:				mv		a0,	t2				# Usamos o ecall para esperar o tempo calculado at� o pr�ximo ciclo
						li		a7,	32
						ecall
						
						j		MainLoop				# Voltando ao �nicio
						
						
						# Fim do programa
						li		a7,	10				
						ecall	
						
			

# Criar bloco no pr�ximo espa�o de 32 linhas dispon�vel
# a0: Endere�o do bloco atual (que ser� substitu�do)
# a1: Endere�o para armazenar bloco atual ap�s substitui��o
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
					li		a7,	41					# Gerando o n�mero
					ecall
					add		t1,	s2,	s3				# a' deve estar em [0, a+b), para isso usamos a fun��o mod
					remu		s4,	a0,	t1				# a' = random mod (a+b)
					
	# A decis�o do segundo n�mero depende do valor do primeiro (borda esquerda). Precisamos ter certeza que n�o ser� criado um bloco imposs�vel de ser atravessado.
	
					ecall								# a7 n�o foi alterado, pegamos novo aleat�rio
								
	# F�rmula: b' = R mod (7 - max(a', a)) + m + 1
	# m = 0, se a' >= a ; m = a - a', se a' < a
					
					# a1 = max(a', a)
					mv		a1,	s4					# a1 = a'
					mv		a2,	zero					# a2 = m = 0
					bge		s4,	s3,	createBlock.noAdjust		# Se a' >= a, pulamos
					mv		a1,	s3					# a1 = a
					sub		a2,	s3,	s4				# m = a' - a
	createBlock.noAdjust:		li		t0,	7
					sub		t0,	t0,	a1				# t0 = 7 - max(a', a)
					remu		a0,	a0,	t0				# a0 = R mod (7 - max(a', a))
					add		a0,	a0,	a2				# a0 += m
					addi		a0,	a0,	1				# a0++ ; F�rmula completa
					
	# Hora de colocar os dois n�meros em um byte s�
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
					li		a5,	BANK_COLOR
					li		a6,	RIVER_COLOR
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
						li		a5,	SCORE_COLOR	
	renderPlayfield.drawBottom:		beq		t1,	zero,	renderPlayfield.drawBottom.end
							
							sw		a5,	0(a3)
							addi		a3,	a3,	4
							addi		t1,	t1,	-1
							j		renderPlayfield.drawBottom
						
	renderPlayfield.drawBottom.end:	ret
						

				
#############################
# Desenha um objeto na tela				
# a0: Coordenada X
# a1: Coordenada Y
# a2: Altura do objeto
# a3: Largura do objeto
# a4: Endere�o do bitmap do objeto
# a5: Endere�o do VGA
# a6: Desenhar invertido (1 ou 0)
# TODO : FAZER FLIP
############################

drawObject:				blt		a1,	zero,	drawObject.finish 	# Se Y < 0, objeto n�o � vis�vel
					li		t0,	160				# N�mero m�ximo de linhas vis�veis
					sub		t1,	a1,	a2			# t1 = coordenada do topo do objeto
					bgt		t1,	t0,	drawObject.finish	# Se o topo estiver acima de 160, objeto n�o � vis�vel

	drawObject.start:		beq		a2,	zero,	drawObject.finish		# while (height > 0 )
						
						# Calculando o endere�o no VGA
						li		t0,	320
						mul		t0,	a1,	t0			# Y*320
						add		t0,	t0,	a0			# t0 = Y*320 + X
						add		t0,	t0,	a5			# VGAStart + t0 � o endere�o
						
						mv		a6,	a3				# a6 = j = largura do objeto
	drawObject.drawLine:			beq		a6,	zero,	drawObject.drawLine.end # while (j > 0 )
							
							li		t5,	160
							bgtu		a1,	t5,	drawObject.noDraw # Fazemos o teste de visibilidade linha a linha para um desaparecimento suave
							
							lbu		t1,	0(a4)			# Pegamos o primeiro byte do bitmap do objeto
							sb		t1,	0(t0)			# Desenhamos na tela
	drawObject.noDraw:				addi		a4,	a4,	1		# Passamos para o pr�ximo byte
	
							addi		t0,	t0,	1		# Pr�ximo endere�o de pintura
							addi		a6,	a6,	-1		# j--
							j		drawObject.drawLine
	
	drawObject.drawLine.end:		addi		a1,	a1,	-1			# (Y--): Passamos para a pr�xima linha do objeto								
						addi		a2,	a2,	-1			# height--
						j		drawObject.start			# Se estiver como esperado, a4 j� deve estar com o endere�o certo
						
	drawObject.finish:		ret
	
			
#############################
# Gera um novo objeto				
# a0: Endere�o onde ser� salvo o objeto
# a1: Offset Y ( quantidade de linhas do bloco que j� foram desenhadas)
# a2: ID do bloco

# a5: Endere�o do Table com os endere�os das "formas" dos objetos
############################			

# Vamos fazer assim:
# 1) Rotina para decis�o de qual objeto ser� criado				
# Nessa rotina, decidimos se:
# a) Vamos criar Fuel ou n�o, baseado na dificuldade.
# b) Se n�o for Fuel, decidimos se � casa ou n�o, baseado na dificuldade
# c) Decidir qual inimigo colocar
# d) Decidir coordenada x ( + um offset ) onde colocar o objeto
# e) Decidir dire��o

# Poss�veis argumentos
# - Endere�o de um Table que salva ponteiros para a se��o de cada objeto (na qual est�o seus atributos)
# - Tamanho de um objeto, em bytes. Deve ser padr�o
# 

																																		
############################
# ROM Tables
############################

.data
.align 2
testObjY: .word -80
testObj: .byte 0xe0, 0xe0, 0xe0, 0xe0, 0xe0, 0xe0, 0xe0, 0xe0
	 .byte 0xe0, 0xe0, 0xe0, 0xe0, 0xe0, 0xe0, 0xe0, 0xe0
	 .byte 0xe0, 0xe0, 0xe0, 0xe0, 0xe0, 0xe0, 0xe0, 0xe0
	 .byte 0xe0, 0xe0, 0xe0, 0xe0, 0xe0, 0xe0, 0xe0, 0xe0
	 .byte 0xe0, 0xe0, 0xe0, 0xe0, 0xe0, 0xe0, 0xe0, 0xe0
	 .byte 0xe0, 0xe0, 0xe0, 0xe0, 0xe0, 0xe0, 0xe0, 0xe0
	 .byte 0xe0, 0xe0, 0xe0, 0xe0, 0xe0, 0xe0, 0xe0, 0xe0
	 .byte 0xe0, 0xe0, 0xe0, 0xe0, 0xe0, 0xe0, 0xe0, 0xe0
	 .byte 0xe0, 0xe0, 0xe0, 0xe0, 0xe0, 0xe0, 0xe0, 0xe0
	 .byte 0xe0, 0xe0, 0xe0, 0xe0, 0xe0, 0xe0, 0xe0, 0xe0
	 .byte 0xe0, 0xe0, 0xe0, 0xe0, 0xe0, 0xe0, 0xe0, 0xe0



#######################
# Includes
#######################

.include "SYSTEMv17.s"
