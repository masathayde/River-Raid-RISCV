# Cores devem ser repetidas 4 vezes na word
.eqv BANK_COLOR_4 0x10101010 										# Cor da costa, deve ser verde
.eqv RIVER_COLOR_4 0xb0b0b0b0 										# Cor do rio, azul
.eqv SCORE_COLOR_4 0x0b0b0b0b
.eqv FUEL_COLOR 0x00 											# Cor do combust�vel

# As cores s�o essenciais para os testes de colis�o e precisam ser diferentes
.eqv BANK_COLOR 0x10
.eqv RVCL 0xb0 # river color
.eqv SCORE_COLOR 0x0b
.eqv SHIP 0x05 # ship color
.eqv PLNE 0x90 # plane color
.eqv FUEL 0x26 # fuel color
.eqv LEUF 0x62 # bad fuel color
.eqv HOUS 0xFF # house color
.eqv TRNK 0xFF # tree trunk color
.eqv TREE 0xFF # tree leaves color
.eqv BRDG 0x00 # bridge color
.eqv EXPL 0xFF # explosion color
.eqv PLYR 0xFF # Player color

.eqv M_LEFT 97 # a
.eqv M_RIGHT 100 # d
.eqv M_UP 119 # w
.eqv M_DOWN 115 # s

.eqv MAX_BANK_SIZE 7
.eqv MAX_DIFFICULTY 10											
.eqv PLAYER_MAX_MISSILE 20   # N�mero m�ximo de tiros na tela
.eqv PLAYER_MISSILE DELAY 15 # Quanto tempo deve-se esperar para poder atirar de novo (em ciclos)
.eqv PLAYER_SPEED_X 2 # Quantos pixels o jogador se move por ciclo quando � controlado
.eqv PLAYER_HEIGHT 20 # Medidas do sprite, em pixels
.eqv PLAYER_WIDTH 20 

.eqv TIMESTEP 33											# Em ms

.eqv VGAADDRESSINI0     0xFF000000
.eqv VGAADDRESSFIM0     0xFF012C00
.eqv VGAADDRESSINI1     0xFF100000
.eqv VGAADDRESSFIM1     0xFF112C00 
.eqv VGAFRAMESELECT	0xFF200604

.data
	# Tentar agrupar todos os words no come�o para n�o precisar usar .align
	Arg8: .word 0 # Caso seja necess�rio mais de 7 argumentos
	Arg9: .word 0 # Pois �
	
	gameTime: .word 0
	framePtr: .word 0
	HiScore: .word 0
	gameLevel: .byte 0										# Dificuldade
	
	
	frameToShow: .byte 1 # Frame do VGA selecionado										
	scrollSpeed: .byte 2 # Velocidade de scroll vertical atual
	
	scrollSpeedNormal: .byte 2 # Velocidade de scroll vertical padr�o
	scrollSpeedFast: .byte 4 # Velocidade de scroll vertical r�pida
	scrollSpeedSlow: .byte 1 # Velocidade devagar

	blockWriteOffset: .byte 0
	blockCurrent: .byte 0x07									# Cada parte de uma dos blocos vis�veis � representada por um byte
	blockPrevious: .byte 0
	
	lineDrawnCounter: .byte 0									# Contador do n�mero de linhas desenhado, para decidirmos se precisamos de um novo bloco

######################################################################################################################	
#  _   _  ___  ______ _____  ___  _   _ _____ _____ _____  ______ _____     ___  _____ _____   ___ ______ ___________ 
# | | | |/ _ \ | ___ \_   _|/ _ \| | | |  ___|_   _/  ___| |  _  \  _  |   |_  ||  _  |  __ \ / _ \|  _  \  _  | ___ \
# | | | / /_\ \| |_/ / | | / /_\ \ | | | |__   | | \ `--.  | | | | | | |     | || | | | |  \// /_\ \ | | | | | | |_/ /
# | | | |  _  ||    /  | | |  _  | | | |  __|  | |  `--. \ | | | | | | |     | || | | | | __ |  _  | | | | | | |    / 
# \ \_/ / | | || |\ \ _| |_| | | \ \_/ / |___ _| |_/\__/ / | |/ /\ \_/ / /\__/ /\ \_/ / |_\ \| | | | |/ /\ \_/ / |\ \ 
#  \___/\_| |_/\_| \_|\___/\_| |_/\___/\____/ \___/\____/  |___/  \___/  \____/  \___/ \____/\_| |_/___/  \___/\_| \_|
#######################################################################################################################
	.align 2
	playerCrrSpr: .word 0 # Endere�o do sprite atual do avi�o
	playerScore: .word 0 # Pontua��o atual
	playerPosX: .half 120
	playerLives: .byte 4
	playerPosY: .byte 155 # Normalmente, n�o deve mudar
	playerDirection: .byte 0 # Usado para decidir se haver� flip no sprite
	playerFuel: .byte 10
	playerMissile: .byte 0 # Contador de tiros
	playerCollision: .byte 0 # 0 - sem colis�o; 1 - colis�o com algo que destr�i ; 2 - colis�o com fuel ; 3 - colis�o com bad fuel
	playerSpeedX: .byte 4 # Velocidade em pixels/frame
                                                                                                      
##########################################################                                                                                                                                                                                                                
# ______ _       _____   _______ _____ _____ _    ______ 
# | ___ \ |     / _ \ \ / /  ___|_   _|  ___| |   |  _  \
# | |_/ / |    / /_\ \ V /| |_    | | | |__ | |   | | | |
# |  __/| |    |  _  |\ / |  _|   | | |  __|| |   | | | |
# | |   | |____| | | || | | |    _| |_| |___| |___| |/ / 
# \_|   \_____/\_| |_/\_/ \_|    \___/\____/\_____/___/  
##########################################################                                                                                                               		
	pfWriteOffset: .byte 0
	pfReadStartOffset: .byte 160
	pfReadEndOffset: .byte 0
	playfield: .space 192										# 160 linhas s�o vis�veis ao mesmo tempo, 32 a mais para armazenar novo bloco
	
	
	.align 2
	objectPtrList: .space 24										# Somente 6 objetos por tela
	
	object0: .space 32
	# objectBitmapPtr: .word
	# objectAction: .word
	# objectType: .byte
	# objectState: .byte			
	# objectXpos: .half
	# objectYpos: .byte
	# objectXspeed: .byte
	# objectHeight: .byte
	# objectWidth: .byte
	# objectDirection: .byte
	# objectAnimationCounter: .byte
	# objectIsAnim: .byte
	# objectCollsion: .byte
	object1: .space 32
	object2: .space 32
	object3: .space 32
	object4: .space 32
	object5: .space 32
	
.text

# Incluir SYSTEMv17 mais tarde
# Incluir explica��o sobre o byte do bloco e como � usado para gerar uma linha

# Setup inicial
Main:					la 		tp,exceptionHandling	# carrega em tp o endere�o base das rotinas do sistema ECALL
 					csrrw 		zero,5,tp 		# seta utvec (reg 5) para o endere�o tp
 					csrrsi 		zero,0,1 		# seta o bit de habilita��o de interrup��o em ustatus (reg 0)

# .d8888b.  8888888888 88888888888 888     888 8888888b.       8888888 888b    888 8888888 .d8888b. 8888888        d8888 888      
# d88P  Y88b 888            888     888     888 888   Y88b        888   8888b   888   888  d88P  Y88b  888         d88888 888      
# Y88b.      888            888     888     888 888    888        888   88888b  888   888  888    888  888        d88P888 888      
#  "Y888b.   8888888        888     888     888 888   d88P        888   888Y88b 888   888  888         888       d88P 888 888      
#     "Y88b. 888            888     888     888 8888888P"         888   888 Y88b888   888  888         888      d88P  888 888      
#       "888 888            888     888     888 888               888   888  Y88888   888  888    888  888     d88P   888 888      
# Y88b  d88P 888            888     Y88b. .d88P 888               888   888   Y8888   888  Y88b  d88P  888    d8888888888 888      
#  "Y8888P"  8888888888     888      "Y88888P"  888             8888888 888    Y888 8888888 "Y8888P" 8888888 d88P     888 88888888 

	InitSetup:			
#	   ___  _____ _____   ___ ______ ___________ 
#	  |_  ||  _  |  __ \ / _ \|  _  \  _  | ___ \
#	    | || | | | |  \// /_\ \ | | | | | | |_/ /
#	    | || | | | | __ |  _  | | | | | | |    / 
#	/\__/ /\ \_/ / |_\ \| | | | |/ /\ \_/ / |\ \ 
#	\____/  \___/ \____/\_| |_/___/  \___/\_| \_|
#	
#	Resetando todos os dados					
					la		t0,	playerCrrSpr				
					la		t1,	Plyr_0					# Sprite do jogador padr�o
					sw		t1,	0(t0)					# Salvando no espa�o correto


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
						
						
#88888888888 8888888888 .d8888b. 88888888888 8888888888 
#    888     888       d88P  Y88b    888     888        
#    888     888       Y88b.         888     888        
#    888     8888888    "Y888b.      888     8888888    
#    888     888           "Y88b.    888     888        
#    888     888             "888    888     888        
#    888     888       Y88b  d88P    888     888        
#    888     8888888888 "Y8888P"     888     8888888888  Fonte: colossal
                                                       
                                                                                                         				
						la		t0, testObjY
						lw		t1, 0(t0)
						addi		t1, t1,	4
						sw		t1, 0(t0)
	
						li		a0, 120
						la		t0, testObjY
						lw		a1, 0(t0)
						#li		a1, 140
						li		a2, 20
						li		a3, 20
						la		a4, Plyr_1
						la		t0, framePtr
						lw		a5, 0(t0)
						li		a6, 0
						call	drawObject
	
						li		a0, 10
						la		t0, testObjY
						lw		a1, 0(t0)
						#li		a1, 140
						li		a2, 20
						li		a3, 20
						la		a4, Plyr_1
						la		t0, framePtr
						lw		a5, 0(t0)
						li		a6, 1
						call	drawObject
						
# ______      _   _                       _           ___                       _            
# | ___ \    | | (_)                     | |         |_  |                     | |           
# | |_/ /___ | |_ _ _ __   __ _ ___    __| | ___       | | ___   __ _  __ _  __| | ___  _ __ 
# |    // _ \| __| | '_ \ / _` / __|  / _` |/ _ \      | |/ _ \ / _` |/ _` |/ _` |/ _ \| '__|
# | |\ \ (_) | |_| | | | | (_| \__ \ | (_| | (_) | /\__/ / (_) | (_| | (_| | (_| | (_) | |   
# \_| \_\___/ \__|_|_| |_|\__,_|___/  \__,_|\___/  \____/ \___/ \__, |\__,_|\__,_|\___/|_|   
#                                                                __/ |                       
#                                                               |___/                        

	#### RECEBIMENTO DE INPUT ####
	# TESTE #
						li		a0,	0xFF200000
						li		a1,	0xFF200004
						la		t0,	playerSpeedX
						lbu		a2,	0(t0)
						la		a3,	playerPosX
						la		a4,	playerDirection
						la		a5,	Plyr_0
						la		a6,	Plyr_1
						la		a7,	playerCrrSpr
						la		t0,	Arg8
						la		t1,	scrollSpeed
						sw		t1,	0(t0)
						call		getInputRars
						
						

	#### DESENHO E COLIS�O ####
						la		t0,	playerPosX			# Carregando X do jogador
						lhu		a0,	0(t0)
						la		t0,	playerPosY			# Carregando Y do jogador
						lbu		a1,	0(t0)
						li		a2,	PLAYER_HEIGHT			# Carregando altura do sprite
						li		a3,	PLAYER_WIDTH			# Carregando largura
						la		t0,	playerCrrSpr
						lw		a4,	0(t0)				# Pegando bitmap atual (normal ou virando para um lado)
						la		t0, 	framePtr			# Pegando endere�o do VGA atual
						lw		a5, 	0(t0)
						la		t0,	playerDirection			# Carregando dire��o
						lbu		a6,	0(t0)
						la		a7,	playerCollision			# Endere�o onde ser� salvo o byte de colis�o
						call		drawPlayerChkC												
																		

#  _____                         _       ______                        
# |_   _|                       | |      |  ___|                       
#   | |_ __ ___   ___ __ _    __| | ___  | |_ _ __ __ _ _ __ ___   ___ 
#   | | '__/ _ \ / __/ _` |  / _` |/ _ \ |  _| '__/ _` | '_ ` _ \ / _ \
#   | | | | (_) | (_| (_| | | (_| |  __/ | | | | | (_| | | | | | |  __/
#   \_/_|  \___/ \___\__,_|  \__,_|\___| \_| |_|  \__,_|_| |_| |_|\___|
                                                                     
                                                                      
	
						la		t0,	frameToShow			# Terminamos de desenhar, ent�o mostramos o frame
						lbu		t1,	0(t0)
						li		t0,	VGAFRAMESELECT
						sb		t1,	0(t0)
						

#  _____       _            _             _        _____ _                   _____ _                
# /  __ \     | |          | |           | |      /  ___| |                 |_   _(_)               
# | /  \/ __ _| | ___ _   _| | ___     __| | ___  \ `--.| | ___  ___ _ __     | |  _ _ __ ___   ___ 
# | |    / _` | |/ __| | | | |/ _ \   / _` |/ _ \  `--. \ |/ _ \/ _ \ '_ \    | | | | '_ ` _ \ / _ \
# | \__/\ (_| | | (__| |_| | | (_) | | (_| |  __/ /\__/ / |  __/  __/ |_) |   | | | | | | | | |  __/
#  \____/\__,_|_|\___|\__,_|_|\___/   \__,_|\___| \____/|_|\___|\___| .__/    \_/ |_|_| |_| |_|\___|
#                                                                   | |                             
#                                                                   |_|                             

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
						

				
#############################
# Desenha um objeto na tela				
# a0: Coordenada X
# a1: Coordenada Y
# a2: Altura do objeto
# a3: Largura do objeto
# a4: Endere�o do bitmap do objeto
# a5: Endere�o do VGA
# a6: Desenhar invertido (1 ou 0)
# TODO: Hit detection
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
						
						mv		t6,	a3				# t6 = j = largura do objeto
						beq		a6,	zero, drawObject.drawLine	# Se for para inverter o sprite, executamos as pr�ximas instru��es
						add		a4,	a4,	a3			# Pegamos o endere�o do final da linha
						addi		a4,	a4,	-1
						j		drawObject.drawLineF			# Pulamos para o loop de desenho invertido de linha					
	drawObject.drawLine:			beq		t6,	zero,	drawObject.drawLine.end # while (j > 0 )
							
							li		t5,	160
							bgtu		a1,	t5,	drawObject.noDraw # Fazemos o teste de visibilidade linha a linha para um desaparecimento suave
							
							lbu		t1,	0(a4)			# Pegamos o primeiro byte do bitmap do objeto
							sb		t1,	0(t0)			# Desenhamos na tela
	drawObject.noDraw:				addi		a4,	a4,	1		# Passamos para o pr�ximo byte
	
							addi		t0,	t0,	1		# Pr�ximo endere�o de pintura
							addi		t6,	t6,	-1		# j--
							j		drawObject.drawLine
							
	
	drawObject.drawLineF:			beq		t6,	zero,	drawObject.drawLineF.end # while (j > 0 )
							
							li		t5,	160
							bgtu		a1,	t5,	drawObject.noDrawF # Fazemos o teste de visibilidade linha a linha para um desaparecimento suave
							
							lbu		t1,	0(a4)			# Pegamos o primeiro byte do bitmap do objeto
							sb		t1,	0(t0)			# Desenhamos na tela
	drawObject.noDrawF:				addi		a4,	a4,	-1		# Passamos para o pr�ximo byte
	
							addi		t0,	t0,	1		# Pr�ximo endere�o de pintura
							addi		t6,	t6,	-1		# j--
							j		drawObject.drawLineF						
																			
	
	drawObject.drawLineF.end:		add		a4,	a4,	a3			# Ajustando o endere�o do bitmap, ap�s desenho de linha invertido
						addi		a4,	a4,	1
	drawObject.drawLine.end:		addi		a1,	a1,	-1			# (Y--): Passamos para a pr�xima linha do objeto								
						addi		a2,	a2,	-1			# height--
						j		drawObject.start			# Se estiver como esperado, a4 j� deve estar com o endere�o certo
						
	drawObject.finish:		ret
	
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
							beq		t1,	t5,	drawPlayerChkC.noColl 	# Assim, ignoramos o teste de colis�o
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
							addi		a4,	a4,	1			# Passamos para o pr�ximo byte
	
							addi		t0,	t0,	1			# Pr�ximo endere�o de pintura
							addi		t6,	t6,	-1			# j--
							j		drawPlayerChkC.drawLine
							
	
	drawPlayerChkC.drawLineF:		beq		t6,	zero,	drawPlayerChkC.drawLineF.end # while (j > 0 )
							
							# CHECAGEM DE COLIS�O	
							lbu		t1,	0(a4)				# Pegamos o primeiro byte do bitmap do objeto
							li		t5,	RVCL				# Cor do rio (nessa rotina, ignoramos os bytes com essa cor para o prop�sito de colis�o
							beq		t1,	t5,	drawPlayerChkC.noCollF 	# Assim, ignoramos o teste de colis�o
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
							addi		a4,	a4,	-1		# Passamos para o pr�ximo byte
	
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
					bne		t0,	t1,	getInputRars.noMove		# Testamos se � baixo
					la		t1,	scrollSpeedSlow				# Pegamos o valor da velocidade no n�vel r�pido
					lbu		t2,	0(t1)
					la		t1,	Arg8					# Pegamos o endere�o onde est� a velocidade de scroll da tela
					lw		t3,	0(t1)					#
					sb		t2,	0(t3)					# Atualizamos a velocidade
					sw		a5,	0(a7)
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
#############################################
getInputStick:				sw		a5,	0(a7)					# Come�amos com o sprite padr�o. S� ser� mudado se houver movimento
					la		t1,	Arg8					# Pegamos o endere�o..
					lw		t2,	0(t1)					# ..do scroll vertical
					la		t3,	scrollSpeedNormal			# Pegamos o valor da velocidade padr�o
					lbu		t4, 	0(t3)					# 
					sb		t4,	0(t2)					# Caso nada mude, sempre voltamos � velocidade padr�o

					lw		t0,	0(a0)					# Pegamos o valor do eixo X
					# Talvez incluir teste para ver se o stick est� no meio e pular todas as instru��es?
					
					li		t1,	200					# Valor do deadzone em dire��o a zero
					bge		t0,	t1,	getInputStick.testXp		# Se for maior, o jogador n�o est� indo nessa dire��o
					# Vamos presumir que � a direita
					lhu		t2,	0(a3)					# Pegamos a posi��o X do jogador
					add		t2,	t2,	a2				# Atualizamos a posi��o
					sh		t2,	0(a3)					# Guardamos no endere�o certo
					li		t1,	0					# 0 = direita
					sb		t1,	0(a4)					# Atualizamos a dire��o
					sw		a6,	0(a7)					# Atualizamos o sprite
					j		getInputStick.testYm
					
	getInputStick.testXp:		li		t1,	823					# Valor do deadzone em dire��o a 1023	
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
					li		t1,	200					# Valor do deadzone em dire��o a zero
					bge		t0,	t1,	getInputStick.testYp		# Se for maior, n�o est� indo nessa dire��o
					# Vamos presumir que � baixo
					la		t1,	scrollSpeedSlow				# Pegamos o valor da velocidade no n�vel r�pido
					lbu		t2,	0(t1)
					la		t1,	Arg8					# Pegamos o endere�o onde est� a velocidade de scroll da tela
					lw		t3,	0(t1)					#
					sb		t2,	0(t3)					# Atualizamos a velocidade
					sw		a5,	0(a7)					# Usa o sprite padr�o
					j		getInputStick.testButton
	
	getInputStick.testYp:		li		t1,	823					# Deadzone em dire��o a 1023
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
					# Aqui colocaremos o caso de tiro

	getInputStick.end:		ret
			
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

																																		
##############################################################################################
#
# 8888888b.   .d88888b.  888b     d888      88888888888       888      888                   
# 888   Y88b d88P" "Y88b 8888b   d8888          888           888      888                   
# 888    888 888     888 88888b.d88888          888           888      888                   
# 888   d88P 888     888 888Y88888P888          888   8888b.  88888b.  888  .d88b.  .d8888b  
# 8888888P"  888     888 888 Y888P 888          888      "88b 888 "88b 888 d8P  Y8b 88K      
# 888 T88b   888     888 888  Y8P  888          888  .d888888 888  888 888 88888888 "Y8888b. 
# 888  T88b  Y88b. .d88P 888   "   888          888  888  888 888 d88P 888 Y8b.          X88 
# 888   T88b  "Y88888P"  888       888          888  "Y888888 88888P"  888  "Y8888   88888P'
#                                                                                                                                           
################################################################################################

.data
.align 2

# TEST
testObjY: .word -30
testObj: .byte RVCL, RVCL, RVCL, RVCL, RVCL, RVCL, RVCL, RVCL, RVCL, RVCL, RVCL, RVCL, RVCL, RVCL, RVCL, RVCL, RVCL, RVCL, RVCL, RVCL
	 .byte RVCL, RVCL, RVCL, RVCL, RVCL, RVCL, RVCL, RVCL, RVCL, RVCL, RVCL, RVCL, RVCL, RVCL, RVCL, RVCL, RVCL, RVCL, RVCL, RVCL
	 .byte RVCL, RVCL, RVCL, RVCL, RVCL, RVCL, RVCL, RVCL, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00
	 .byte RVCL, RVCL, RVCL, RVCL, RVCL, RVCL, RVCL, RVCL, RVCL, RVCL, RVCL, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, RVCL, RVCL, RVCL 
	 .byte RVCL, RVCL, RVCL, RVCL, RVCL, RVCL, RVCL, RVCL, RVCL, RVCL, RVCL, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, RVCL, RVCL, RVCL
	 .byte 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00
	 .byte 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00
	 .byte 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00
	 .byte 0x00, 0x00, RVCL, RVCL, RVCL, RVCL, RVCL, RVCL, RVCL, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00
	 .byte 0x00, 0x00, RVCL, RVCL, RVCL, RVCL, RVCL, RVCL, RVCL, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00
	 .byte 0x00, 0x00, RVCL, RVCL, RVCL, RVCL, RVCL, RVCL, RVCL, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00
	 .byte 0x00, 0x00, RVCL, RVCL, RVCL, RVCL, RVCL, RVCL, RVCL, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00
	 .byte RVCL, RVCL, RVCL, RVCL, RVCL, RVCL, RVCL, RVCL, RVCL, RVCL, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00
	 .byte RVCL, RVCL, RVCL, RVCL, RVCL, RVCL, RVCL, RVCL, RVCL, RVCL, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, RVCL
	 .byte RVCL, RVCL, RVCL, RVCL, RVCL, RVCL, RVCL, RVCL, RVCL, RVCL, RVCL, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, RVCL, RVCL
	 .byte RVCL, RVCL, RVCL, RVCL, RVCL, RVCL, RVCL, RVCL, RVCL, RVCL, RVCL, RVCL, RVCL, 0x00, 0x00, RVCL, RVCL, RVCL, RVCL, RVCL
	 .byte RVCL, RVCL, RVCL, RVCL, RVCL, RVCL, RVCL, RVCL, RVCL, RVCL, RVCL, RVCL, RVCL, 0x00, 0x00, RVCL, RVCL, RVCL, RVCL, RVCL
	 .byte RVCL, RVCL, RVCL, RVCL, RVCL, RVCL, RVCL, RVCL, RVCL, RVCL, RVCL, RVCL, RVCL, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00  
	 .byte RVCL, RVCL, RVCL, RVCL, RVCL, RVCL, RVCL, RVCL, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, RVCL, RVCL, RVCL, RVCL, RVCL 
	 .byte RVCL, RVCL, RVCL, RVCL, RVCL, RVCL, RVCL, RVCL, RVCL, RVCL, RVCL, RVCL, RVCL, RVCL, RVCL, RVCL, RVCL, RVCL, RVCL, RVCL


# Helicopter
Heli_f0: .byte RVCL, RVCL, RVCL, RVCL, RVCL, RVCL, RVCL, RVCL, RVCL, RVCL, RVCL, RVCL, RVCL, RVCL, RVCL, RVCL, RVCL, RVCL, RVCL, RVCL
	 .byte RVCL, RVCL, RVCL, RVCL, RVCL, RVCL, RVCL, RVCL, RVCL, RVCL, RVCL, RVCL, RVCL, RVCL, RVCL, RVCL, RVCL, RVCL, RVCL, RVCL
	 .byte RVCL, RVCL, RVCL, RVCL, RVCL, RVCL, RVCL, RVCL, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00
	 .byte RVCL, RVCL, RVCL, RVCL, RVCL, RVCL, RVCL, RVCL, RVCL, RVCL, RVCL, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, RVCL, RVCL, RVCL 
	 .byte RVCL, RVCL, RVCL, RVCL, RVCL, RVCL, RVCL, RVCL, RVCL, RVCL, RVCL, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, RVCL, RVCL, RVCL
	 .byte 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00
	 .byte 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00
	 .byte 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00
	 .byte 0x00, 0x00, RVCL, RVCL, RVCL, RVCL, RVCL, RVCL, RVCL, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00
	 .byte 0x00, 0x00, RVCL, RVCL, RVCL, RVCL, RVCL, RVCL, RVCL, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00
	 .byte 0x00, 0x00, RVCL, RVCL, RVCL, RVCL, RVCL, RVCL, RVCL, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00
	 .byte 0x00, 0x00, RVCL, RVCL, RVCL, RVCL, RVCL, RVCL, RVCL, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00
	 .byte RVCL, RVCL, RVCL, RVCL, RVCL, RVCL, RVCL, RVCL, RVCL, RVCL, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00
	 .byte RVCL, RVCL, RVCL, RVCL, RVCL, RVCL, RVCL, RVCL, RVCL, RVCL, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, RVCL
	 .byte RVCL, RVCL, RVCL, RVCL, RVCL, RVCL, RVCL, RVCL, RVCL, RVCL, RVCL, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, RVCL, RVCL
	 .byte RVCL, RVCL, RVCL, RVCL, RVCL, RVCL, RVCL, RVCL, RVCL, RVCL, RVCL, RVCL, RVCL, 0x00, 0x00, RVCL, RVCL, RVCL, RVCL, RVCL
	 .byte RVCL, RVCL, RVCL, RVCL, RVCL, RVCL, RVCL, RVCL, RVCL, RVCL, RVCL, RVCL, RVCL, 0x00, 0x00, RVCL, RVCL, RVCL, RVCL, RVCL
	 .byte RVCL, RVCL, RVCL, RVCL, RVCL, RVCL, RVCL, RVCL, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, RVCL, RVCL, RVCL, RVCL, RVCL 
	 .byte RVCL, RVCL, RVCL, RVCL, RVCL, RVCL, RVCL, RVCL, RVCL, RVCL, RVCL, RVCL, RVCL, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00
	 .byte RVCL, RVCL, RVCL, RVCL, RVCL, RVCL, RVCL, RVCL, RVCL, RVCL, RVCL, RVCL, RVCL, RVCL, RVCL, RVCL, RVCL, RVCL, RVCL, RVCL

Heli_f1: .byte RVCL, RVCL, RVCL, RVCL, RVCL, RVCL, RVCL, RVCL, RVCL, RVCL, RVCL, RVCL, RVCL, RVCL, RVCL, RVCL, RVCL, RVCL, RVCL, RVCL
	 .byte RVCL, RVCL, RVCL, RVCL, RVCL, RVCL, RVCL, RVCL, RVCL, RVCL, RVCL, RVCL, RVCL, RVCL, RVCL, RVCL, RVCL, RVCL, RVCL, RVCL
	 .byte RVCL, RVCL, RVCL, RVCL, RVCL, RVCL, RVCL, RVCL, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00
	 .byte RVCL, RVCL, RVCL, RVCL, RVCL, RVCL, RVCL, RVCL, RVCL, RVCL, RVCL, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, RVCL, RVCL, RVCL 
	 .byte RVCL, RVCL, RVCL, RVCL, RVCL, RVCL, RVCL, RVCL, RVCL, RVCL, RVCL, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, RVCL, RVCL, RVCL
	 .byte 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00
	 .byte 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00
	 .byte 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00
	 .byte 0x00, 0x00, RVCL, RVCL, RVCL, RVCL, RVCL, RVCL, RVCL, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00
	 .byte 0x00, 0x00, RVCL, RVCL, RVCL, RVCL, RVCL, RVCL, RVCL, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00
	 .byte 0x00, 0x00, RVCL, RVCL, RVCL, RVCL, RVCL, RVCL, RVCL, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00
	 .byte 0x00, 0x00, RVCL, RVCL, RVCL, RVCL, RVCL, RVCL, RVCL, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00
	 .byte RVCL, RVCL, RVCL, RVCL, RVCL, RVCL, RVCL, RVCL, RVCL, RVCL, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00
	 .byte RVCL, RVCL, RVCL, RVCL, RVCL, RVCL, RVCL, RVCL, RVCL, RVCL, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, RVCL
	 .byte RVCL, RVCL, RVCL, RVCL, RVCL, RVCL, RVCL, RVCL, RVCL, RVCL, RVCL, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, RVCL, RVCL
	 .byte RVCL, RVCL, RVCL, RVCL, RVCL, RVCL, RVCL, RVCL, RVCL, RVCL, RVCL, RVCL, RVCL, 0x00, 0x00, RVCL, RVCL, RVCL, RVCL, RVCL
	 .byte RVCL, RVCL, RVCL, RVCL, RVCL, RVCL, RVCL, RVCL, RVCL, RVCL, RVCL, RVCL, RVCL, 0x00, 0x00, RVCL, RVCL, RVCL, RVCL, RVCL
	 .byte RVCL, RVCL, RVCL, RVCL, RVCL, RVCL, RVCL, RVCL, RVCL, RVCL, RVCL, RVCL, RVCL, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00  
	 .byte RVCL, RVCL, RVCL, RVCL, RVCL, RVCL, RVCL, RVCL, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, RVCL, RVCL, RVCL, RVCL, RVCL 
	 .byte RVCL, RVCL, RVCL, RVCL, RVCL, RVCL, RVCL, RVCL, RVCL, RVCL, RVCL, RVCL, RVCL, RVCL, RVCL, RVCL, RVCL, RVCL, RVCL, RVCL
	 
# Ship
Ship_f0: .byte RVCL, RVCL, RVCL, RVCL, RVCL, RVCL, RVCL, SHIP, SHIP, SHIP, SHIP, SHIP, SHIP, SHIP, RVCL, RVCL, RVCL, RVCL, RVCL, RVCL
	 .byte RVCL, RVCL, RVCL, RVCL, SHIP, SHIP, SHIP, SHIP, SHIP, SHIP, SHIP, SHIP, SHIP, SHIP, SHIP, SHIP, SHIP, RVCL, RVCL, RVCL
	 .byte RVCL, RVCL, SHIP, SHIP, SHIP, SHIP, SHIP, SHIP, SHIP, SHIP, SHIP, SHIP, SHIP, SHIP, SHIP, SHIP, SHIP, SHIP, RVCL, RVCL
	 .byte RVCL, SHIP, SHIP, SHIP, SHIP, SHIP, SHIP, SHIP, SHIP, SHIP, SHIP, SHIP, SHIP, SHIP, SHIP, SHIP, SHIP, SHIP, SHIP, RVCL
	 .byte SHIP, SHIP, SHIP, SHIP, SHIP, SHIP, SHIP, SHIP, SHIP, SHIP, SHIP, SHIP, SHIP, SHIP, SHIP, SHIP, SHIP, SHIP, SHIP, SHIP   
	 .byte SHIP, SHIP, SHIP, SHIP, SHIP, SHIP, SHIP, SHIP, SHIP, SHIP, SHIP, SHIP, SHIP, SHIP, SHIP, SHIP, SHIP, SHIP, SHIP, SHIP
	 .byte SHIP, SHIP, SHIP, SHIP, SHIP, SHIP, SHIP, SHIP, SHIP, SHIP, SHIP, SHIP, SHIP, SHIP, SHIP, SHIP, SHIP, SHIP, RVCL, RVCL
	 .byte SHIP, SHIP, SHIP, SHIP, SHIP, SHIP, SHIP, SHIP, SHIP, SHIP, SHIP, SHIP, SHIP, SHIP, SHIP, SHIP, SHIP, SHIP, RVCL, RVCL
	 .byte RVCL, RVCL, SHIP, SHIP, SHIP, SHIP, SHIP, SHIP, SHIP, SHIP, SHIP, SHIP, RVCL, RVCL, RVCL, RVCL, RVCL, RVCL, RVCL, RVCL
	 .byte RVCL, RVCL, SHIP, SHIP, SHIP, SHIP, SHIP, SHIP, SHIP, SHIP, SHIP, RVCL, RVCL, RVCL, RVCL, RVCL, RVCL, RVCL, RVCL, RVCL #10
	 .byte RVCL, RVCL, RVCL, SHIP, SHIP, SHIP, SHIP, SHIP, SHIP, SHIP, SHIP, RVCL, RVCL, RVCL, RVCL, RVCL, RVCL, RVCL, RVCL, RVCL
	 .byte RVCL, RVCL, RVCL, SHIP, SHIP, SHIP, SHIP, SHIP, SHIP, SHIP, SHIP, RVCL, RVCL, RVCL, RVCL, RVCL, RVCL, RVCL, RVCL, RVCL
	 .byte RVCL, RVCL, RVCL, SHIP, SHIP, SHIP, RVCL, RVCL, RVCL, RVCL, RVCL, RVCL, RVCL, RVCL, RVCL, RVCL, RVCL, RVCL, RVCL, RVCL
	 .byte RVCL, RVCL, RVCL, SHIP, SHIP, SHIP, RVCL, RVCL, RVCL, RVCL, RVCL, RVCL, RVCL, RVCL, RVCL, RVCL, RVCL, RVCL, RVCL, RVCL
	 .byte RVCL, RVCL, RVCL, RVCL, RVCL, RVCL, RVCL, RVCL, RVCL, RVCL, RVCL, RVCL, RVCL, RVCL, RVCL, RVCL, RVCL, RVCL, RVCL, RVCL
	 .byte RVCL, RVCL, RVCL, RVCL, RVCL, RVCL, RVCL, RVCL, RVCL, RVCL, RVCL, RVCL, RVCL, RVCL, RVCL, RVCL, RVCL, RVCL, RVCL, RVCL
	 .byte RVCL, RVCL, RVCL, RVCL, RVCL, RVCL, RVCL, RVCL, RVCL, RVCL, RVCL, RVCL, RVCL, RVCL, RVCL, RVCL, RVCL, RVCL, RVCL, RVCL
	 .byte RVCL, RVCL, RVCL, RVCL, RVCL, RVCL, RVCL, RVCL, RVCL, RVCL, RVCL, RVCL, RVCL, RVCL, RVCL, RVCL, RVCL, RVCL, RVCL, RVCL
	 .byte RVCL, RVCL, RVCL, RVCL, RVCL, RVCL, RVCL, RVCL, RVCL, RVCL, RVCL, RVCL, RVCL, RVCL, RVCL, RVCL, RVCL, RVCL, RVCL, RVCL
	 .byte RVCL, RVCL, RVCL, RVCL, RVCL, RVCL, RVCL, RVCL, RVCL, RVCL, RVCL, RVCL, RVCL, RVCL, RVCL, RVCL, RVCL, RVCL, RVCL, RVCL

# Plane	 
Plane_f0:.byte RVCL, RVCL, RVCL, RVCL, RVCL, RVCL, RVCL, RVCL, RVCL, RVCL, RVCL, RVCL, RVCL, RVCL, RVCL, RVCL, RVCL, RVCL, RVCL, RVCL
	 .byte RVCL, RVCL, RVCL, RVCL, RVCL, RVCL, RVCL, RVCL, RVCL, RVCL, RVCL, RVCL, RVCL, RVCL, RVCL, RVCL, RVCL, RVCL, RVCL, RVCL
	 .byte RVCL, RVCL, RVCL, RVCL, RVCL, RVCL, RVCL, RVCL, RVCL, RVCL, RVCL, RVCL, RVCL, RVCL, RVCL, RVCL, RVCL, RVCL, RVCL, RVCL
	 .byte RVCL, RVCL, RVCL, RVCL, RVCL, RVCL, RVCL, RVCL, RVCL, RVCL, RVCL, RVCL, RVCL, RVCL, RVCL, RVCL, RVCL, RVCL, RVCL, RVCL
	 .byte RVCL, RVCL, RVCL, RVCL, RVCL, RVCL, RVCL, RVCL, RVCL, RVCL, RVCL, RVCL, RVCL, RVCL, RVCL, RVCL, RVCL, RVCL, RVCL, RVCL   
	 .byte RVCL, RVCL, RVCL, RVCL, RVCL, RVCL, RVCL, PLNE, PLNE, PLNE, PLNE, PLNE, PLNE, RVCL, RVCL, RVCL, RVCL, RVCL, RVCL, RVCL
	 .byte RVCL, RVCL, RVCL, RVCL, RVCL, PLNE, PLNE, PLNE, PLNE, PLNE, PLNE, PLNE, PLNE, PLNE, PLNE, RVCL, RVCL, RVCL, RVCL, RVCL
	 .byte PLNE, PLNE, PLNE, PLNE, PLNE, PLNE, PLNE, PLNE, PLNE, PLNE, PLNE, PLNE, PLNE, PLNE, PLNE, PLNE, PLNE, PLNE, PLNE, PLNE
	 .byte PLNE, PLNE, PLNE, PLNE, PLNE, PLNE, PLNE, PLNE, PLNE, PLNE, PLNE, PLNE, PLNE, PLNE, PLNE, PLNE, PLNE, PLNE, PLNE, PLNE
	 .byte PLNE, PLNE, PLNE, PLNE, RVCL, RVCL, RVCL, RVCL, RVCL, RVCL, RVCL, RVCL, PLNE, PLNE, PLNE, PLNE, PLNE, PLNE, RVCL, RVCL
	 .byte PLNE, PLNE, RVCL, RVCL, RVCL, RVCL, RVCL, RVCL, RVCL, RVCL, RVCL, RVCL, RVCL, RVCL, RVCL, RVCL, RVCL, RVCL, RVCL, RVCL
	 .byte PLNE, RVCL, RVCL, RVCL, RVCL, RVCL, RVCL, RVCL, RVCL, RVCL, RVCL, RVCL, RVCL, RVCL, RVCL, RVCL, RVCL, RVCL, RVCL, RVCL 
	 .byte RVCL, RVCL, RVCL, RVCL, RVCL, RVCL, RVCL, RVCL, RVCL, RVCL, RVCL, RVCL, RVCL, RVCL, RVCL, RVCL, RVCL, RVCL, RVCL, RVCL
	 .byte RVCL, RVCL, RVCL, RVCL, RVCL, RVCL, RVCL, RVCL, RVCL, RVCL, RVCL, RVCL, RVCL, RVCL, RVCL, RVCL, RVCL, RVCL, RVCL, RVCL
	 .byte RVCL, RVCL, RVCL, RVCL, RVCL, RVCL, RVCL, RVCL, RVCL, RVCL, RVCL, RVCL, RVCL, RVCL, RVCL, RVCL, RVCL, RVCL, RVCL, RVCL
	 .byte RVCL, RVCL, RVCL, RVCL, RVCL, RVCL, RVCL, RVCL, RVCL, RVCL, RVCL, RVCL, RVCL, RVCL, RVCL, RVCL, RVCL, RVCL, RVCL, RVCL
	 .byte RVCL, RVCL, RVCL, RVCL, RVCL, RVCL, RVCL, RVCL, RVCL, RVCL, RVCL, RVCL, RVCL, RVCL, RVCL, RVCL, RVCL, RVCL, RVCL, RVCL
	 .byte RVCL, RVCL, RVCL, RVCL, RVCL, RVCL, RVCL, RVCL, RVCL, RVCL, RVCL, RVCL, RVCL, RVCL, RVCL, RVCL, RVCL, RVCL, RVCL, RVCL
	 .byte RVCL, RVCL, RVCL, RVCL, RVCL, RVCL, RVCL, RVCL, RVCL, RVCL, RVCL, RVCL, RVCL, RVCL, RVCL, RVCL, RVCL, RVCL, RVCL, RVCL
	 .byte RVCL, RVCL, RVCL, RVCL, RVCL, RVCL, RVCL, RVCL, RVCL, RVCL, RVCL, RVCL, RVCL, RVCL, RVCL, RVCL, RVCL, RVCL, RVCL, RVCL
	 
# Fuel
Fuel_f0: .byte FUEL, FUEL, FUEL, FUEL, FUEL, FUEL, FUEL, FUEL, FUEL, FUEL, FUEL, FUEL, FUEL, FUEL, FUEL, FUEL, FUEL, FUEL, RVCL, RVCL
	 .byte FUEL, FUEL, FUEL, FUEL, FUEL, FUEL, FUEL, FUEL, FUEL, FUEL, FUEL, FUEL, FUEL, FUEL, FUEL, FUEL, FUEL, FUEL, RVCL, RVCL
	 .byte FUEL, FUEL, FUEL, FUEL, FUEL, FUEL, FUEL, FUEL, FUEL, FUEL, FUEL, FUEL, FUEL, FUEL, FUEL, FUEL, FUEL, FUEL, RVCL, RVCL
	 .byte FUEL, FUEL, FUEL, RVCL, RVCL, RVCL, FUEL, FUEL, FUEL, FUEL, FUEL, FUEL, FUEL, FUEL, FUEL, FUEL, FUEL, FUEL, RVCL, RVCL
	 .byte FUEL, FUEL, FUEL, RVCL, RVCL, RVCL, FUEL, FUEL, FUEL, FUEL, FUEL, FUEL, FUEL, FUEL, FUEL, FUEL, FUEL, FUEL, RVCL, RVCL
	 .byte FUEL, FUEL, FUEL, RVCL, RVCL, RVCL, FUEL, FUEL, FUEL, FUEL, FUEL, FUEL, FUEL, FUEL, FUEL, FUEL, FUEL, FUEL, RVCL, RVCL
	 .byte FUEL, FUEL, FUEL, RVCL, RVCL, RVCL, FUEL, FUEL, FUEL, FUEL, FUEL, FUEL, FUEL, FUEL, FUEL, FUEL, FUEL, FUEL, RVCL, RVCL
	 .byte FUEL, FUEL, FUEL, RVCL, RVCL, RVCL, FUEL, FUEL, FUEL, FUEL, FUEL, FUEL, FUEL, FUEL, FUEL, FUEL, FUEL, FUEL, RVCL, RVCL
	 .byte FUEL, FUEL, FUEL, RVCL, RVCL, RVCL, RVCL, RVCL, RVCL, RVCL, RVCL, RVCL, RVCL, RVCL, RVCL, FUEL, FUEL, FUEL, RVCL, RVCL
	 .byte FUEL, FUEL, FUEL, RVCL, RVCL, RVCL, FUEL, FUEL, FUEL, FUEL, FUEL, FUEL, FUEL, FUEL, FUEL, FUEL, FUEL, FUEL, RVCL, RVCL
	 .byte FUEL, FUEL, FUEL, RVCL, RVCL, RVCL, FUEL, FUEL, FUEL, FUEL, FUEL, FUEL, FUEL, FUEL, FUEL, FUEL, FUEL, FUEL, RVCL, RVCL
	 .byte FUEL, FUEL, FUEL, RVCL, RVCL, RVCL, FUEL, FUEL, FUEL, FUEL, FUEL, FUEL, FUEL, FUEL, FUEL, FUEL, FUEL, FUEL, RVCL, RVCL
	 .byte FUEL, FUEL, FUEL, RVCL, RVCL, RVCL, RVCL, RVCL, RVCL, RVCL, RVCL, RVCL, RVCL, RVCL, RVCL, RVCL, FUEL, FUEL, RVCL, RVCL
	 .byte FUEL, FUEL, FUEL, FUEL, FUEL, FUEL, FUEL, FUEL, FUEL, FUEL, FUEL, FUEL, FUEL, FUEL, FUEL, FUEL, FUEL, FUEL, RVCL, RVCL
	 .byte FUEL, FUEL, FUEL, FUEL, FUEL, FUEL, FUEL, FUEL, FUEL, FUEL, FUEL, FUEL, FUEL, FUEL, FUEL, FUEL, FUEL, FUEL, RVCL, RVCL
	 .byte FUEL, FUEL, FUEL, FUEL, FUEL, FUEL, FUEL, FUEL, FUEL, FUEL, FUEL, FUEL, FUEL, FUEL, FUEL, FUEL, FUEL, FUEL, RVCL, RVCL
	 .byte FUEL, FUEL, FUEL, FUEL, FUEL, FUEL, FUEL, FUEL, FUEL, FUEL, FUEL, FUEL, FUEL, FUEL, FUEL, FUEL, FUEL, FUEL, RVCL, RVCL
	 .byte FUEL, FUEL, FUEL, FUEL, FUEL, FUEL, FUEL, FUEL, FUEL, FUEL, FUEL, FUEL, FUEL, FUEL, FUEL, FUEL, FUEL, FUEL, RVCL, RVCL
	 .byte RVCL, FUEL, FUEL, FUEL, FUEL, FUEL, FUEL, FUEL, FUEL, FUEL, FUEL, FUEL, FUEL, FUEL, FUEL, FUEL, FUEL, RVCL, RVCL, RVCL
	 .byte RVCL, RVCL, FUEL, FUEL, FUEL, FUEL, FUEL, FUEL, FUEL, FUEL, FUEL, FUEL, FUEL, FUEL, FUEL, FUEL, RVCL, RVCL, RVCL, RVCL

# Bad fuel	 
Leuf_f0: .byte LEUF, LEUF, LEUF, LEUF, LEUF, LEUF, LEUF, LEUF, LEUF, LEUF, LEUF, LEUF, LEUF, LEUF, LEUF, LEUF, LEUF, LEUF, RVCL, RVCL
	 .byte LEUF, LEUF, LEUF, LEUF, LEUF, LEUF, LEUF, LEUF, LEUF, LEUF, LEUF, LEUF, LEUF, LEUF, LEUF, LEUF, LEUF, LEUF, RVCL, RVCL
	 .byte LEUF, LEUF, LEUF, LEUF, LEUF, LEUF, LEUF, LEUF, LEUF, LEUF, LEUF, LEUF, LEUF, LEUF, LEUF, LEUF, LEUF, LEUF, RVCL, RVCL
	 .byte LEUF, LEUF, LEUF, RVCL, RVCL, RVCL, LEUF, LEUF, LEUF, LEUF, LEUF, LEUF, LEUF, LEUF, LEUF, LEUF, LEUF, LEUF, RVCL, RVCL
	 .byte LEUF, LEUF, LEUF, RVCL, RVCL, RVCL, LEUF, LEUF, LEUF, LEUF, LEUF, LEUF, LEUF, LEUF, LEUF, LEUF, LEUF, LEUF, RVCL, RVCL
	 .byte LEUF, LEUF, LEUF, RVCL, RVCL, RVCL, LEUF, LEUF, LEUF, LEUF, LEUF, LEUF, LEUF, LEUF, LEUF, LEUF, LEUF, LEUF, RVCL, RVCL
	 .byte LEUF, LEUF, LEUF, RVCL, RVCL, RVCL, LEUF, LEUF, LEUF, LEUF, LEUF, LEUF, LEUF, LEUF, LEUF, LEUF, LEUF, LEUF, RVCL, RVCL
	 .byte LEUF, LEUF, LEUF, RVCL, RVCL, RVCL, LEUF, LEUF, LEUF, LEUF, LEUF, LEUF, LEUF, LEUF, LEUF, LEUF, LEUF, LEUF, RVCL, RVCL
	 .byte LEUF, LEUF, LEUF, RVCL, RVCL, RVCL, RVCL, RVCL, RVCL, RVCL, RVCL, RVCL, RVCL, RVCL, RVCL, LEUF, LEUF, LEUF, RVCL, RVCL
	 .byte LEUF, LEUF, LEUF, RVCL, RVCL, RVCL, LEUF, LEUF, LEUF, LEUF, LEUF, LEUF, LEUF, LEUF, LEUF, LEUF, LEUF, LEUF, RVCL, RVCL
	 .byte LEUF, LEUF, LEUF, RVCL, RVCL, RVCL, LEUF, LEUF, LEUF, LEUF, LEUF, LEUF, LEUF, LEUF, LEUF, LEUF, LEUF, LEUF, RVCL, RVCL
	 .byte LEUF, LEUF, LEUF, RVCL, RVCL, RVCL, LEUF, LEUF, LEUF, LEUF, LEUF, LEUF, LEUF, LEUF, LEUF, LEUF, LEUF, LEUF, RVCL, RVCL
	 .byte LEUF, LEUF, LEUF, RVCL, RVCL, RVCL, RVCL, RVCL, RVCL, RVCL, RVCL, RVCL, RVCL, RVCL, RVCL, RVCL, LEUF, LEUF, RVCL, RVCL
	 .byte LEUF, LEUF, LEUF, LEUF, LEUF, LEUF, LEUF, LEUF, LEUF, LEUF, LEUF, LEUF, LEUF, LEUF, LEUF, LEUF, LEUF, LEUF, RVCL, RVCL
	 .byte LEUF, LEUF, LEUF, LEUF, LEUF, LEUF, LEUF, LEUF, LEUF, LEUF, LEUF, LEUF, LEUF, LEUF, LEUF, LEUF, LEUF, LEUF, RVCL, RVCL
	 .byte LEUF, LEUF, LEUF, LEUF, LEUF, LEUF, LEUF, LEUF, LEUF, LEUF, LEUF, LEUF, LEUF, LEUF, LEUF, LEUF, LEUF, LEUF, RVCL, RVCL
	 .byte LEUF, LEUF, LEUF, LEUF, LEUF, LEUF, LEUF, LEUF, LEUF, LEUF, LEUF, LEUF, LEUF, LEUF, LEUF, LEUF, LEUF, LEUF, RVCL, RVCL
	 .byte LEUF, LEUF, LEUF, LEUF, LEUF, LEUF, LEUF, LEUF, LEUF, LEUF, LEUF, LEUF, LEUF, LEUF, LEUF, LEUF, LEUF, LEUF, RVCL, RVCL
	 .byte RVCL, LEUF, LEUF, LEUF, LEUF, LEUF, LEUF, LEUF, LEUF, LEUF, LEUF, LEUF, LEUF, LEUF, LEUF, LEUF, LEUF, RVCL, RVCL, RVCL
	 .byte RVCL, RVCL, LEUF, LEUF, LEUF, LEUF, LEUF, LEUF, LEUF, LEUF, LEUF, LEUF, LEUF, LEUF, LEUF, LEUF, RVCL, RVCL, RVCL, RVCL
	 
# Bridge (40w 12h)
Bridg_f0:.byte BRDG, BRDG, BRDG, BRDG, BRDG, BRDG, BRDG, BRDG, BRDG, BRDG, BRDG, BRDG, BRDG, BRDG, BRDG, BRDG, BRDG, BRDG, BRDG, BRDG, BRDG, BRDG, BRDG, BRDG, BRDG, BRDG, BRDG, BRDG, BRDG, BRDG, BRDG, BRDG, BRDG, BRDG, BRDG, BRDG, BRDG, BRDG, BRDG, BRDG 
	 .byte BRDG, BRDG, BRDG, BRDG, BRDG, BRDG, BRDG, BRDG, BRDG, BRDG, BRDG, BRDG, BRDG, BRDG, BRDG, BRDG, BRDG, BRDG, BRDG, BRDG, BRDG, BRDG, BRDG, BRDG, BRDG, BRDG, BRDG, BRDG, BRDG, BRDG, BRDG, BRDG, BRDG, BRDG, BRDG, BRDG, BRDG, BRDG, BRDG, BRDG
	 .byte BRDG, BRDG, BRDG, BRDG, BRDG, BRDG, BRDG, BRDG, BRDG, BRDG, BRDG, BRDG, BRDG, BRDG, BRDG, BRDG, BRDG, BRDG, BRDG, BRDG, BRDG, BRDG, BRDG, BRDG, BRDG, BRDG, BRDG, BRDG, BRDG, BRDG, BRDG, BRDG, BRDG, BRDG, BRDG, BRDG, BRDG, BRDG, BRDG, BRDG
	 .byte BRDG, BRDG, BRDG, BRDG, BRDG, BRDG, BRDG, BRDG, BRDG, BRDG, BRDG, BRDG, BRDG, BRDG, BRDG, BRDG, BRDG, BRDG, BRDG, BRDG, BRDG, BRDG, BRDG, BRDG, BRDG, BRDG, BRDG, BRDG, BRDG, BRDG, BRDG, BRDG, BRDG, BRDG, BRDG, BRDG, BRDG, BRDG, BRDG, BRDG
	 .byte BRDG, BRDG, BRDG, BRDG, BRDG, BRDG, BRDG, BRDG, BRDG, BRDG, BRDG, BRDG, BRDG, BRDG, BRDG, BRDG, BRDG, BRDG, BRDG, BRDG, BRDG, BRDG, BRDG, BRDG, BRDG, BRDG, BRDG, BRDG, BRDG, BRDG, BRDG, BRDG, BRDG, BRDG, BRDG, BRDG, BRDG, BRDG, BRDG, BRDG
	 .byte BRDG, BRDG, BRDG, BRDG, BRDG, BRDG, BRDG, BRDG, BRDG, BRDG, BRDG, BRDG, BRDG, BRDG, BRDG, BRDG, BRDG, BRDG, BRDG, BRDG, BRDG, BRDG, BRDG, BRDG, BRDG, BRDG, BRDG, BRDG, BRDG, BRDG, BRDG, BRDG, BRDG, BRDG, BRDG, BRDG, BRDG, BRDG, BRDG, BRDG
	 .byte BRDG, BRDG, BRDG, BRDG, BRDG, BRDG, BRDG, BRDG, BRDG, BRDG, BRDG, BRDG, BRDG, BRDG, BRDG, BRDG, BRDG, BRDG, BRDG, BRDG, BRDG, BRDG, BRDG, BRDG, BRDG, BRDG, BRDG, BRDG, BRDG, BRDG, BRDG, BRDG, BRDG, BRDG, BRDG, BRDG, BRDG, BRDG, BRDG, BRDG
	 .byte BRDG, BRDG, BRDG, BRDG, BRDG, BRDG, BRDG, BRDG, BRDG, BRDG, BRDG, BRDG, BRDG, BRDG, BRDG, BRDG, BRDG, BRDG, BRDG, BRDG, BRDG, BRDG, BRDG, BRDG, BRDG, BRDG, BRDG, BRDG, BRDG, BRDG, BRDG, BRDG, BRDG, BRDG, BRDG, BRDG, BRDG, BRDG, BRDG, BRDG
	 .byte BRDG, BRDG, BRDG, BRDG, BRDG, BRDG, BRDG, BRDG, BRDG, BRDG, BRDG, BRDG, BRDG, BRDG, BRDG, BRDG, BRDG, BRDG, BRDG, BRDG, BRDG, BRDG, BRDG, BRDG, BRDG, BRDG, BRDG, BRDG, BRDG, BRDG, BRDG, BRDG, BRDG, BRDG, BRDG, BRDG, BRDG, BRDG, BRDG, BRDG
	 .byte BRDG, BRDG, BRDG, BRDG, BRDG, BRDG, BRDG, BRDG, BRDG, BRDG, BRDG, BRDG, BRDG, BRDG, BRDG, BRDG, BRDG, BRDG, BRDG, BRDG, BRDG, BRDG, BRDG, BRDG, BRDG, BRDG, BRDG, BRDG, BRDG, BRDG, BRDG, BRDG, BRDG, BRDG, BRDG, BRDG, BRDG, BRDG, BRDG, BRDG
	 .byte BRDG, BRDG, BRDG, BRDG, BRDG, BRDG, BRDG, BRDG, BRDG, BRDG, BRDG, BRDG, BRDG, BRDG, BRDG, BRDG, BRDG, BRDG, BRDG, BRDG, BRDG, BRDG, BRDG, BRDG, BRDG, BRDG, BRDG, BRDG, BRDG, BRDG, BRDG, BRDG, BRDG, BRDG, BRDG, BRDG, BRDG, BRDG, BRDG, BRDG
	 .byte BRDG, BRDG, BRDG, BRDG, BRDG, BRDG, BRDG, BRDG, BRDG, BRDG, BRDG, BRDG, BRDG, BRDG, BRDG, BRDG, BRDG, BRDG, BRDG, BRDG, BRDG, BRDG, BRDG, BRDG, BRDG, BRDG, BRDG, BRDG, BRDG, BRDG, BRDG, BRDG, BRDG, BRDG, BRDG, BRDG, BRDG, BRDG, BRDG, BRDG
	 
	 
# Player
Plyr_0:  .byte RVCL, RVCL, RVCL, RVCL, RVCL, RVCL, RVCL, RVCL, RVCL, RVCL, RVCL, RVCL, RVCL, RVCL, RVCL, RVCL, RVCL, RVCL, RVCL, RVCL
         .byte RVCL, RVCL, RVCL, RVCL, RVCL, RVCL, RVCL, RVCL, RVCL, RVCL, RVCL, RVCL, RVCL, RVCL, RVCL, RVCL, RVCL, RVCL, RVCL, RVCL
         .byte RVCL, RVCL, RVCL, RVCL, RVCL, RVCL, RVCL, RVCL, RVCL, RVCL, RVCL, RVCL, RVCL, RVCL, RVCL, RVCL, RVCL, RVCL, RVCL, RVCL
         .byte RVCL, RVCL, RVCL, RVCL, RVCL, RVCL, RVCL, RVCL, RVCL, RVCL, RVCL, RVCL, RVCL, RVCL, RVCL, RVCL, RVCL, RVCL, RVCL, RVCL
         .byte RVCL, RVCL, RVCL, RVCL, RVCL, PLYR, PLYR, RVCL, RVCL, PLYR, PLYR, RVCL, RVCL, PLYR, PLYR, RVCL, RVCL, RVCL, RVCL, RVCL #5
         .byte RVCL, RVCL, RVCL, RVCL, RVCL, PLYR, PLYR, PLYR, PLYR, PLYR, PLYR, PLYR, PLYR, PLYR, PLYR, RVCL, RVCL, RVCL, RVCL, RVCL
         .byte RVCL, RVCL, RVCL, RVCL, RVCL, RVCL, RVCL, PLYR, PLYR, PLYR, PLYR, PLYR, PLYR, RVCL, RVCL, RVCL, RVCL, RVCL, RVCL, RVCL
         .byte RVCL, RVCL, RVCL, RVCL, RVCL, RVCL, RVCL, RVCL, RVCL, PLYR, PLYR, RVCL, RVCL, RVCL, RVCL, RVCL, RVCL, RVCL, RVCL, RVCL
         .byte RVCL, RVCL, RVCL, PLYR, PLYR, RVCL, RVCL, RVCL, RVCL, PLYR, PLYR, RVCL, RVCL, RVCL, RVCL, PLYR, PLYR, RVCL, RVCL, RVCL
         .byte RVCL, RVCL, RVCL, PLYR, PLYR, PLYR, RVCL, RVCL, RVCL, PLYR, PLYR, RVCL, RVCL, RVCL, PLYR, PLYR, PLYR, RVCL, RVCL, RVCL #10X
         .byte RVCL, RVCL, RVCL, RVCL, PLYR, PLYR, PLYR, PLYR, PLYR, PLYR, PLYR, PLYR, PLYR, PLYR, PLYR, PLYR, RVCL, RVCL, RVCL, RVCL 
         .byte RVCL, RVCL, RVCL, RVCL, RVCL, PLYR, PLYR, PLYR, PLYR, PLYR, PLYR, PLYR, PLYR, PLYR, PLYR, RVCL, RVCL, RVCL, RVCL, RVCL 
         .byte RVCL, RVCL, RVCL, RVCL, RVCL, RVCL, RVCL, PLYR, PLYR, PLYR, PLYR, PLYR, PLYR, RVCL, RVCL, RVCL, RVCL, RVCL, RVCL, RVCL #13 
         .byte RVCL, RVCL, RVCL, RVCL, RVCL, RVCL, RVCL, RVCL, RVCL, PLYR, PLYR, RVCL, RVCL, RVCL, RVCL, RVCL, RVCL, RVCL, RVCL, RVCL
         .byte RVCL, RVCL, RVCL, RVCL, RVCL, RVCL, RVCL, RVCL, RVCL, PLYR, PLYR, RVCL, RVCL, RVCL, RVCL, RVCL, RVCL, RVCL, RVCL, RVCL #15
         .byte RVCL, RVCL, RVCL, RVCL, RVCL, RVCL, RVCL, RVCL, RVCL, PLYR, PLYR, RVCL, RVCL, RVCL, RVCL, RVCL, RVCL, RVCL, RVCL, RVCL
         .byte RVCL, RVCL, RVCL, RVCL, RVCL, RVCL, RVCL, RVCL, RVCL, PLYR, PLYR, RVCL, RVCL, RVCL, RVCL, RVCL, RVCL, RVCL, RVCL, RVCL
         .byte RVCL, RVCL, RVCL, RVCL, RVCL, RVCL, RVCL, RVCL, RVCL, RVCL, RVCL, RVCL, RVCL, RVCL, RVCL, RVCL, RVCL, RVCL, RVCL, RVCL
         .byte RVCL, RVCL, RVCL, RVCL, RVCL, RVCL, RVCL, RVCL, RVCL, RVCL, RVCL, RVCL, RVCL, RVCL, RVCL, RVCL, RVCL, RVCL, RVCL, RVCL
         .byte RVCL, RVCL, RVCL, RVCL, RVCL, RVCL, RVCL, RVCL, RVCL, RVCL, RVCL, RVCL, RVCL, RVCL, RVCL, RVCL, RVCL, RVCL, RVCL, RVCL #20
         
Plyr_1:  .byte RVCL, RVCL, RVCL, RVCL, RVCL, RVCL, RVCL, RVCL, RVCL, RVCL, RVCL, RVCL, RVCL, RVCL, RVCL, RVCL, RVCL, RVCL, RVCL, RVCL
         .byte RVCL, RVCL, RVCL, RVCL, RVCL, RVCL, RVCL, RVCL, RVCL, RVCL, RVCL, RVCL, RVCL, RVCL, RVCL, RVCL, RVCL, RVCL, RVCL, RVCL
         .byte RVCL, RVCL, RVCL, RVCL, RVCL, RVCL, RVCL, RVCL, RVCL, RVCL, RVCL, RVCL, RVCL, RVCL, RVCL, RVCL, RVCL, RVCL, RVCL, RVCL
         .byte RVCL, RVCL, RVCL, RVCL, RVCL, RVCL, RVCL, RVCL, RVCL, RVCL, RVCL, RVCL, RVCL, PLYR, PLYR, RVCL, RVCL, RVCL, RVCL, RVCL #4
         .byte RVCL, RVCL, RVCL, RVCL, RVCL, PLYR, PLYR, RVCL, RVCL, PLYR, PLYR, PLYR, PLYR, PLYR, PLYR, RVCL, RVCL, RVCL, RVCL, RVCL #5
         .byte RVCL, RVCL, RVCL, RVCL, RVCL, PLYR, PLYR, PLYR, PLYR, PLYR, PLYR, PLYR, PLYR, RVCL, RVCL, RVCL, RVCL, RVCL, RVCL, RVCL
         .byte RVCL, RVCL, RVCL, RVCL, RVCL, RVCL, RVCL, RVCL, PLYR, PLYR, PLYR, PLYR, PLYR, RVCL, RVCL, RVCL, RVCL, RVCL, RVCL, RVCL
         .byte RVCL, RVCL, RVCL, RVCL, RVCL, RVCL, RVCL, RVCL, RVCL, PLYR, PLYR, RVCL, RVCL, RVCL, RVCL, PLYR, PLYR, RVCL, RVCL, RVCL
         .byte RVCL, RVCL, RVCL, PLYR, PLYR, RVCL, RVCL, RVCL, RVCL, PLYR, PLYR, RVCL, RVCL, RVCL, PLYR, PLYR, PLYR, RVCL, RVCL, RVCL
         .byte RVCL, RVCL, RVCL, PLYR, PLYR, PLYR, RVCL, RVCL, RVCL, PLYR, PLYR, PLYR, PLYR, PLYR, PLYR, PLYR, RVCL, RVCL, RVCL, RVCL #10
         .byte RVCL, RVCL, RVCL, RVCL, PLYR, PLYR, PLYR, PLYR, PLYR, PLYR, PLYR, PLYR, PLYR, PLYR, PLYR, RVCL, RVCL, RVCL, RVCL, RVCL 
         .byte RVCL, RVCL, RVCL, RVCL, RVCL, PLYR, PLYR, PLYR, PLYR, PLYR, PLYR, PLYR, PLYR, RVCL, RVCL, RVCL, RVCL, RVCL, RVCL, RVCL #12
         .byte RVCL, RVCL, RVCL, RVCL, RVCL, RVCL, RVCL, PLYR, PLYR, PLYR, PLYR, RVCL, RVCL, RVCL, RVCL, RVCL, RVCL, RVCL, RVCL, RVCL
         .byte RVCL, RVCL, RVCL, RVCL, RVCL, RVCL, RVCL, RVCL, RVCL, PLYR, PLYR, RVCL, RVCL, RVCL, RVCL, RVCL, RVCL, RVCL, RVCL, RVCL
         .byte RVCL, RVCL, RVCL, RVCL, RVCL, RVCL, RVCL, RVCL, RVCL, PLYR, PLYR, RVCL, RVCL, RVCL, RVCL, RVCL, RVCL, RVCL, RVCL, RVCL #15   
         .byte RVCL, RVCL, RVCL, RVCL, RVCL, RVCL, RVCL, RVCL, RVCL, PLYR, PLYR, RVCL, RVCL, RVCL, RVCL, RVCL, RVCL, RVCL, RVCL, RVCL
         .byte RVCL, RVCL, RVCL, RVCL, RVCL, RVCL, RVCL, RVCL, RVCL, PLYR, PLYR, RVCL, RVCL, RVCL, RVCL, RVCL, RVCL, RVCL, RVCL, RVCL #17
         .byte RVCL, RVCL, RVCL, RVCL, RVCL, RVCL, RVCL, RVCL, RVCL, RVCL, RVCL, RVCL, RVCL, RVCL, RVCL, RVCL, RVCL, RVCL, RVCL, RVCL
         .byte RVCL, RVCL, RVCL, RVCL, RVCL, RVCL, RVCL, RVCL, RVCL, RVCL, RVCL, RVCL, RVCL, RVCL, RVCL, RVCL, RVCL, RVCL, RVCL, RVCL
         .byte RVCL, RVCL, RVCL, RVCL, RVCL, RVCL, RVCL, RVCL, RVCL, RVCL, RVCL, RVCL, RVCL, RVCL, RVCL, RVCL, RVCL, RVCL, RVCL, RVCL #20
                 

#######################
# Includes
#######################

.include "SYSTEMv17.s"
