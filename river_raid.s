# Cores devem ser repetidas 4 vezes na word
.eqv BANK_COLOR_4 0x10101010 										# Cor da costa, deve ser verde
.eqv RIVER_COLOR_4 0xb0b0b0b0 										# Cor do rio, azul
.eqv SCORE_COLOR_4 0x0b0b0b0b

# As cores são essenciais para os testes de colisão e precisam ser diferentes (talvez)
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
.eqv SHOT 0xFF # Shot color

.eqv M_LEFT 97 # a
.eqv M_RIGHT 100 # d
.eqv M_UP 119 # w
.eqv M_DOWN 115 # s
.eqv M_FIRE 101 # e

.eqv MAX_BANK_SIZE 7
.eqv MAX_DIFFICULTY 10											
.eqv PLAYER_MAX_MISSILE 20   # Número máximo de tiros na tela
.eqv PLAYER_MISSILE DELAY 15 # Quanto tempo deve-se esperar para poder atirar de novo (em ciclos)
.eqv PLAYER_SPEED_X 2 # Quantos pixels o jogador se move por ciclo quando é controlado
.eqv PLAYER_HEIGHT 20 # Medidas do sprite, em pixels
.eqv PLAYER_WIDTH 20 

.eqv TIMESTEP 33 # Em ms

.eqv VGAADDRESSINI0     0xFF000000
.eqv VGAADDRESSFIM0     0xFF012C00
.eqv VGAADDRESSINI1     0xFF100000
.eqv VGAADDRESSFIM1     0xFF112C00 
.eqv VGAFRAMESELECT	0xFF200604

.data
	# Tentar agrupar todos os words no começo para não precisar usar .align
	Arg8: 	.word 0 # Caso seja necessário mais de 7 argumentos
	Arg9: 	.word 0 # Pois é
	Arg10: 	.word 0 # Ahan

#########################################################################################################################
#  _   _  ___  ______ _____  ___  _   _ _____ _____ _____  ____________ _____ _   _ _____ ___________  ___  _____ _____ 
# | | | |/ _ \ | ___ \_   _|/ _ \| | | |  ___|_   _/  ___| | ___ \ ___ \_   _| \ | /  __ \_   _| ___ \/ _ \|_   _/  ___|
# | | | / /_\ \| |_/ / | | / /_\ \ | | | |__   | | \ `--.  | |_/ / |_/ / | | |  \| | /  \/ | | | |_/ / /_\ \ | | \ `--. 
# | | | |  _  ||    /  | | |  _  | | | |  __|  | |  `--. \ |  __/|    /  | | | . ` | |     | | |  __/|  _  | | |  `--. \
# \ \_/ / | | || |\ \ _| |_| | | \ \_/ / |___ _| |_/\__/ / | |   | |\ \ _| |_| |\  | \__/\_| |_| |   | | | |_| |_/\__/ /
#  \___/\_| |_/\_| \_|\___/\_| |_/\___/\____/ \___/\____/  \_|   \_| \_|\___/\_| \_/\____/\___/\_|   \_| |_/\___/\____/ 
#########################################################################################################################                                                                                                                                                                                                                  	

	gameTime: .word 0
	framePtr: .word 0
	HiScore: .word 0
	gameLevel: .word 1				# Número de seções vencidas ( número de pontes geradas)
	difficulty: .byte 0				# Dificuldade atual
	maxDiffic: .byte 5				# Dificuldade máxima
	difficInterv: .byte 1				# Número de seções para que haja aumento de dificuldade
	
	
	
	
	frameToShow: .byte 1 # Frame do VGA selecionado										
	scrollSpeed: .byte 2 # Velocidade de scroll vertical atual
	
	scrollSpeedNormal: .byte 2 # Velocidade de scroll vertical padrão
	scrollSpeedFast: .byte 4 # Velocidade de scroll vertical rápida
	scrollSpeedSlow: .byte 1 # Velocidade devagar

	blockWriteOffset: .byte 0
	blockCurrent: .byte 0x07 # Cada parte de uma dos blocos visíveis é representada por um byte
	blockPrevious: .byte 0
	blockCounter: .byte 0 # Número de blocos criados
	
	lineDrawnCounter: .byte 0 # Contador do número de linhas desenhado, para decidirmos se precisamos de um novo bloco

######################################################################################################################	
#  _   _  ___  ______ _____  ___  _   _ _____ _____ _____  ______ _____     ___  _____ _____   ___ ______ ___________ 
# | | | |/ _ \ | ___ \_   _|/ _ \| | | |  ___|_   _/  ___| |  _  \  _  |   |_  ||  _  |  __ \ / _ \|  _  \  _  | ___ \
# | | | / /_\ \| |_/ / | | / /_\ \ | | | |__   | | \ `--.  | | | | | | |     | || | | | |  \// /_\ \ | | | | | | |_/ /
# | | | |  _  ||    /  | | |  _  | | | |  __|  | |  `--. \ | | | | | | |     | || | | | | __ |  _  | | | | | | |    / 
# \ \_/ / | | || |\ \ _| |_| | | \ \_/ / |___ _| |_/\__/ / | |/ /\ \_/ / /\__/ /\ \_/ / |_\ \| | | | |/ /\ \_/ / |\ \ 
#  \___/\_| |_/\_| \_|\___/\_| |_/\___/\____/ \___/\____/  |___/  \___/  \____/  \___/ \____/\_| |_/___/  \___/\_| \_|
#######################################################################################################################
	.align 2
	playerCrrSpr: .word 0 # Endereço do sprite atual do avião
	playerScore: .word 0 # Pontuação atual
	playerPosX: .half 120
	playerLives: .byte 4
	playerPosY: .byte 155 # Normalmente, não deve mudar
	playerDirection: .byte 0 # Usado para decidir se haverá flip no sprite
	playerFuel: .byte 10
	playerShotCount: .byte 0 # Contador de tiros
	playerCollision: .byte 0 # 0 - sem colisão; 1 - colisão com algo que destrói ; 2 - colisão com fuel ; 3 - colisão com bad fuel
	playerSpeedX: .byte 4 # Velocidade em pixels/frame
	playerShotCD: .byte 0 # Número de frames a esperar para atirar de novo
                                                                                                      
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
	playfield: .space 192										# 160 linhas são visíveis ao mesmo tempo, 32 a mais para armazenar novo bloco

##############################################	
# ___________   ___ _____ _____ _____ _____ 
# |  _  | ___ \ |_  |  ___|_   _|  _  /  ___|
# | | | | |_/ /   | | |__   | | | | | \ `--. 
# | | | | ___ \   | |  __|  | | | | | |`--. \
# \ \_/ / |_/ /\__/ / |___  | | \ \_/ /\__/ /
#  \___/\____/\____/\____/  \_/  \___/\____/ 
##############################################                                                                                     		
	.align 2
	objectPtrList: .word object0, object1, object2, object3, object4, object5
	# Desatualizado
	# 00 objectBitmapPtr0: .word # endereço do frame 0
	# 04 objectBitmapPtr1: .word # endereço do frame 1
	# 08 objectCollision: .word # endereço da rotina de colisão
	# 12 objectAction: .word # endereço de rotina especial
	# 14 objectType: .byte
	# 15 objectIsAnim: .byte		
	# 16 objectXpos: .half
	# 18 objectYpos: .byte
	# 19 objectXspeed: .byte
	# 20 objectHeight: .byte
	# 21 objectWidth: .byte
	# 22 objectDirection: .byte
	# 23 objectAnimationCounter: .byte # Contador de frames de animação
	# 24 objectAnimationTime: .byte # Números de frames até que seja executado a rotina em objectAction
	.align 2
	object0: .space 32
	object1: .space 32
	object2: .space 32
	object3: .space 32
	object4: .space 32
	object5: .space 32
	objectListWriteIdx: .byte 0	# Índice do vetor de objetos onde será escrito o próximo
	
	# shotBitmap: .word
	# shotXcoord: .half
	# shotYcoord: .half
	# shotYspeed: .byte
	# shotHeight: .byte
	# shotWidth: .byte
	# shotExists: .byte
	shotCreate: .byte 0		# Se for 1 no frame atual, criamos um tiro novo
	shotWriteIdx: .byte 0		# Índice para escrita
	.align 2
	shotVector: .space 400		# Espaço para 20 tiros
	
	
.text

# Setup inicial
Main:					la 		tp,exceptionHandling	# carrega em tp o endereço base das rotinas do sistema ECALL
 					csrrw 		zero,5,tp 		# seta utvec (reg 5) para o endereço tp
 					csrrsi 		zero,0,1 		# seta o bit de habilitação de interrupção em ustatus (reg 0)
 					

# .d8888b.  8888888888 88888888888 888     888 8888888b.       8888888 888b    888 8888888 .d8888b. 8888888        d8888 888      
# d88P  Y88b 888            888     888     888 888   Y88b        888   8888b   888   888  d88P  Y88b  888         d88888 888      
# Y88b.      888            888     888     888 888    888        888   88888b  888   888  888    888  888        d88P888 888      
#  "Y888b.   8888888        888     888     888 888   d88P        888   888Y88b 888   888  888         888       d88P 888 888      
#     "Y88b. 888            888     888     888 8888888P"         888   888 Y88b888   888  888         888      d88P  888 888      
#       "888 888            888     888     888 888               888   888  Y88888   888  888    888  888     d88P   888 888      
# Y88b  d88P 888            888     Y88b. .d88P 888               888   888   Y8888   888  Y88b  d88P  888    d8888888888 888      
#  "Y8888P"  8888888888     888      "Y88888P"  888             8888888 888    Y888 8888888 "Y8888P" 8888888 d88P     888 88888888 

	InitSetup:			
# ______ _____ _____ _____ _____ 
# | ___ \  ___/  ___|  ___|_   _|
# | |_/ / |__ \ `--.| |__   | |  
# |    /|  __| `--. \  __|  | |  
# | |\ \| |___/\__/ / |___  | |  
# \_| \_\____/\____/\____/  \_/  
#	
#	Resetando todos as variáveis..					
					la		t0,	playerCrrSpr				
					la		t1,	Plyr_0					# Sprite do jogador padrão
					sw		t1,	0(t0)					# Salvando no espaço correto
					
					
					la		t0,	objectListWriteIdx			# Resetando o índice da lista de objetos
					li		t1,	0
					sb		t1,	0(t0)
					
					la		t0,	object0					# Colocando zero em todos os objetos para indicar que não foram criados ainda
					sw		zero,	0(t0)
					la		t1,	object1
					sw		zero,	0(t1)
					la		t2,	object2
					sw		zero,	0(t2)
					la		t3,	object3
					sw		zero,	0(t3)
					la		t4,	object4
					sw		zero,	0(t4)
					la		t5,	object5
					sw		zero,	0(t5)
					
					


	# Os primeiros blocos são sempre neutros #
					li		s0,	5					# i = 5
	InitSetup.genMap.0:		beq		s0,	zero,	InitSetup.genMap.0.end		# (while i > 0)
						
						la		t0,	blockCurrent
						li		t1,	0x07				# Um bloco sem ilha e com a maior largura possível
						sb		t1,	0(t0)				# Salvamos no endereço do bloco atual
		
						la		a0,	playfield
						la		t0,	pfWriteOffset
						lbu		a1,	0(t0)
						la		t0,	blockCurrent
						lbu		a2,	0(t0)
						call		writeBlockToPlayfield			# Salvando no playfield
						
						la		t0,	pfWriteOffset			# Atualizamos o offset de escrita
						lbu		t1,	0(t0)
						addi		t1,	t1,	32
						li		t2,	192
						remu		t1,	t1,	t2			# Wraparound
						sb		t1,	0(t0)
						
						la		t0,	blockCounter
						lbu		t1,	0(t0)				# Atualizamos o número de blocos escritos
						addi		t1,	t1,	1
						sb		t1,	0(t0)
						
						
						addi		s0,	s0,	-1			# i--
						j		InitSetup.genMap.0
						
	InitSetup.genMap.0.end:		la		a0,	blockCurrent			# Geração do bloco novo
					la		a1,	blockPrevious
					la		t0,	DifficultyTable			# Endereço da tabela de dificuldade
					la		t1,	DifficultyOffset		# Endereço do offset a ser aplicado na tabela
					la		t2,	difficulty			# Endereço da dificuldade
					lbu		t3,	0(t2)				# Pegamos o valor da dificuldade
					lbu		t4,	0(t1)				# Pegando o offset
					mul		t3,	t3,	t4			# Multiplicando dificuldade por offset para acharmos a posição na tabela
					add		t0,	t0,	t3			# Encontramos o endereço da posição correspondente à dificuldade atual
					lbu		a2,	0(t0)				# Quantidade de blocos máxima de terra, partindo da ponta
					lbu		a3,	1(t0)				# Quantidade de blocos mínima de rio
					lbu		a4,	2(t0)				# Largura mínima de abertura
						
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
					
					la		t0,	blockCounter
					lbu		t1,	0(t0)				# Atualizamos o número de blocos escritos
					addi		t1,	t1,	1
					sb		t1,	0(t0)
						
	InitSetup.genMap.end:
	
	
	InitSetup.end:
############################################################
#  _____   ___  ___  ___ _____   _     _____  ___________ 
# |  __ \ / _ \ |  \/  ||  ___| | |   |  _  ||  _  | ___ \
# | |  \// /_\ \| .  . || |__   | |   | | | || | | | |_/ /
# | | __ |  _  || |\/| ||  __|  | |   | | | || | | |  __/ 
# | |_\ \| | | || |  | || |___  | |___\ \_/ /\ \_/ / |    
#  \____/\_| |_/\_|  |_/\____/  \_____/\___/  \___/\_|    
############################################################

	# Loop principal do jogo
	# Pegamos o tempo no começo de cada ciclo para calcularmos o tempo de sleep no final, com base no time step escolhido
	MainLoop:
	
						# Get Frame Start Time
						# Para o RARS
						la		t0,	gameTime			# Aqui salvaremos o tempo no começo do ciclo
						li		a7,	30				# Chamamos o ecall time
						ecall						
						sw		a0,	0(t0)				# Salvamos em time
			

################################################
# ______ _____ _____ _____ _   _  _   _ _____ 
# |  _  \  ___/  ___|  ___| \ | || | | |  _  |
# | | | | |__ \ `--.| |__ |  \| || |_| | | | |
# | | | |  __| `--. \  __|| . ` ||  _  | | | |
# | |/ /| |___/\__/ / |___| |\  || | | \ \_/ /
# |___/ \____/\____/\____/\_| \_/\_| |_/\___/ 
################################################
	# Fase de renderização
	# Usa-se a técnica de double buffering para evitar o efeito de "piscamento"
	Render:					la		t0,	frameToShow			# Trocamos de frame
						la		t2,	framePtr			# Ponteiro para o frame no qual será desenhado o mapa
						lbu		t1,	0(t0)
						xori		t1,	t1,	1			# O uso de xor inverte o bit
						sb		t1,	0(t0)				# Guardamos o valor de volta em frameToShow
						li		t3,	VGAADDRESSINI0			# Inicialmente escolhemos o frame 0
						beq		t1,	zero,	Render.selectF0		# Mas é realmente o frame 0?
						li		t3,	VGAADDRESSINI1			# Não, então escolhe-se frame 1						
	Render.selectF0:			sw		t3,	0(t2)				# Salvar em framePtr
						
	
						la		a0,	playfield			# Carrega endereço do mapa
						la		t0,	pfReadStartOffset		# Carrega posição de ínicio de leitura
						lbu		a1,	0(t0)
						la		t0,	pfReadEndOffset			# Carrega posição de final de leitura
						lbu		a2,	0(t0)
						la		t0,	framePtr			# Endereço do frame a desenhar
						lw		a3,	0(t0)
						call		renderPlayfield
						
	######################
	# DESENHO DE OBJETOS #
	######################
	# Nota: Também faz detecção de colisão
						li		s0,	0				# s0 = i
						li		s1,	6
						la		s2,	object0				# Endereço do primeiro objeto
						la		t0,	objectSize			
						lbu		s3,	0(t0)				# Tamanho dos objetos, para cálculo de offset
	Render.drawObjects:			beq		s0,	s1,	Render.drawObjects.end	# Para cada um dos objetos
						
							lw		t0,	0(s2)
							beq		t0,	zero,	Render.drawObjects.empty # Não desenhamos se ainda não foi escrito
							
							lhu		a0,	16(s2)			# Coordenada X aqui
							lh		a1,	18(s2)			# Coordenada Y aqui
							lbu		a2,	23(s2)			# Altura do objeto
							lbu		a3,	24(s2)			# Largura do objeto
							lw		a4,	0(s2)			# Endereço do bitmap do objeto
							lbu		a6,	25(s2)			# Direção do objeto
							la		t0,	framePtr
							lw		a5,	0(t0)			# Endereço do VGA
							call		drawObject
	Render.drawObjects.empty:			addi		s0,	s0,	1		# ++i
							add		s2,	s2,	s3		# Object[] + 1
							j		Render.drawObjects
	Render.drawObjects.end:
						
	####################
	# DESENHO DE TIROS #		
	####################
						li		s0,	0				# i = 0
						la		t0,	shotMax
						lbu		s6,	0(t0)				# Número máximo de tiros
						la		s1,	shotVector			# Vetor de tiros
						la		t1,	shotSize
						lbu		s2,	0(t1)				# Número do tamanho de cada espaço do vetor, para calcular offset
	Render.shot.L:				beq		s0,	s6,	Render.shot.end 		# Iteramos no vetor de tiro
						
							lbu		t0,	11(s1)			# Verificamos se o tiro existe
							beq		t0,	x0,	Render.shot.L.next # Se não existir, pulamos para o próximo
							lh		a0,	4(s1)			# Coordenada X
							lh		a1,	6(s1)			# Coordenada Y
							lbu		a2,	9(s1)			# Altura
							lbu		a3,	10(s1)			# Largura
							lw		a4,	0(s1)			# Endereço da imagem
							la		t0,	framePtr
							lw		a5,	0(t0)			# Endereço do VGA
							addi		a6,	s1,	12		# Booleana de colisão
							call		drawShot																		
	Render.shot.L.next:				addi		s0,	s0,	1		# i++
							add		s1,	s1,	s2		# V[]++
							j		Render.shot.L
	Render.shot.end:		
							
########################################
#  _   _____________  ___ _____ _____ 
# | | | | ___ \  _  \/ _ \_   _|  ___|
# | | | | |_/ / | | / /_\ \| | | |__  
# | | | |  __/| | | |  _  || | |  __| 
# | |_| | |   | |/ /| | | || | | |___ 
#  \___/\_|   |___/ \_| |_/\_/ \____/ 
########################################        

	########################
	# ATUALIZAÇÃO DE TIROS #
	########################
	
						la		t0,	shotCreate			# Verificamos se temos que criar um tiro
						lbu		t1,	0(t0)
						beq		t1,	zero,	Update.shotMovement	# Caso não, vamos para as rotinas de colisão
						la		t0,	playerShotCount
						lb		t1,	0(t0)				# Vemos quantos tiros foram criados
						la		t0,	shotMax
						lbu		t2,	0(t0)				# Pegamos a quantidade máxima para comparação
						bge		t1,	t2,	Update.shotMovement	# Se chegou ao número máximo, não criamos um novo tiro
						la		a0,	shotVector			# Endereço do vetor de tiros
						la		a1,	shotFormat			# Modelo do objeto tiro
						la		t0,	shotSize
						lbu		a2,	0(t0)				# Tamanho em bytes
						la		t0,	shotWriteIdx
						lbu		a3,	0(t0)				# Índice para escrita
						la		t1,	playerPosX
						lh		a4,	0(t1)				# Posição X do jogador no momento
						la		t0,	shotXoffset
						lbu		a5,	0(t0)				# Offset X de ajuste
						call		createShot
						
						la		t0,	shotWriteIdx			# Atualizando o índice de escrita
						lbu		t1,	0(t0)
						addi		t1,	t1,	1
						li		t2,	20				# Tamanho do vetor de tiros
						remu		t1,	t1,	t2			# Colocamos o índice dentro do limite
						sb		t1,	0(t0)				# Escrito no endereço
						la		t0,	playerShotCount			# Atualizando número de tiros
						lbu		t2,	0(t0)
						addi		t2,	t2,	1			# +1
						sb		t2,	0(t0)				# Gravando no endereço
						la		t1,	shotCreate
						sb		zero,	0(t1)				# Retornamos a booleana de criação para 0
									
						
	Update.shotMovement:			li		s0,	0				# i = 0
						la		t0,	shotMax
						lbu		s6,	0(t0)				# Número máximo de tiros
						la		s1,	shotVector			# Vetor de tiros
						la		t1,	shotSize
						lbu		s2,	0(t1)				# Número do tamanho de cada espaço do vetor, para calcular offset
	Update.shotMovement.L:			beq		s0,	s6,	Update.shotMovement.end # Iteramos no vetor de tiro
						
							lbu		t0,	11(s1)			# Verificamos se o tiro existe
							beq		t0,	x0,	Update.shotMovement.L.next # Se não existir, pulamos para o próximo
							addi		a0,	s1,	12		# Endereço da booleana de colisão
							addi		a1,	s1,	11		# Endereço da booleana de existência
							la		a2,	playerShotCount		# Endereço com o número de tiros
							call		shotColHandler			# Tratamento de colisão							
							mv		a0,	s1
							call		moveShot					
	Update.shotMovement.L.next:			addi		s0,	s0,	1		# i++
							add		s1,	s1,	s2		# V[]++
							j		Update.shotMovement.L
	Update.shotMovement.end:
	
	


	###########################
	# ATUALIZAÇÃO DOS OBJETOS #
	###########################
						li		s0,	0				# s0 = i
						li		s1,	6
						la		s2,	object0				# Endereço do primeiro objeto
						la		t0,	objectSize			
						lbu		s3,	0(t0)				# Tamanho dos objetos, para cálculo de offset
	Update.objectUpdate:			beq		s0,	s1,	Update.objectUpdate.end # Para cada um dos objetos
	
						#############
						# MOVIMENTO #
						#############
						
							lw		t0,	0(s2)
							beq		t0,	zero,	Update.objectUpdate.nope # Se estiver vazio, não pulamos para o próximo
							la		t0,	scrollSpeed		# Velocidade de scroll vertical
							lbu		t1,	0(t0)			# Pegamos para atualizar a posição de todos os objetos
							lh		t2,	18(s2)			# Coordenada Y
							add		t2,	t2,	t1
							sh		t2,	18(s2)			# Atualizado
							
							lbu		a2,	22(s2)			# Velocidade X
							beq		a2,	zero,	Update.objectUpdate.animate # Se velocidade for nula, ignoramos a rotina de movimentação no eixo X
							lh		a0,	16(s2)			# Coordenada X
							lh		a1,	18(s2)			# Coordenada Y
							lbu		a3,	25(s2)			# Direção
							lbu		a4,	24(s2)			# Largura
							la		t0,	framePtr
							lw		a5,	0(t0)			# Endereço do VGA
							lbu		a6,	20(s2)			# Tipo do objeto
							call		moveObjectX
							sh		a0,	16(s2)			# Novo X
							sb		a1,	25(s2)			# Nova direção
							
						############
						# ANIMAÇÃO #
						############
							
	Update.objectUpdate.animate:			mv		a0,	s2			# Endereço do frame 0
							addi		a1,	s2,	4		# Endereço do frame 1
							lbu		a2,	26(s2)			# Contador de frames
							lbu		a3,	27(s2)			# Número limite do contador
							call		animateObject
							sb		a2,	26(s2)			# Atualizando o contador	
	
	
	Update.objectUpdate.nope:			addi		s0,	s0,	1		# ++i
							add		s2,	s2,	s3		# Object[] + 1
							j		Update.objectUpdate
	Update.objectUpdate.end:
	
	
						
	######################################
        # ATUALIZAÇÃO DOS OFFSETS DE LEITURA #
	######################################
						la		t0,	pfReadStartOffset		# Pegando o offset atual
						lbu		t1,	0(t0)
						la		t2,	scrollSpeed			# Pegando velocidade de scroll
						lbu		t3,	0(t2)
						add		t1,	t1,	t3			# Atualizando o offset em si
						li		t4,	192				# Fazendo o wrap around (se o offset passar de 192, deve voltar ao começo)
						remu		t1,	t1,	t4
						sb		t1,	0(t0)				
						
##############################################################						
#  _   _ _____  _   _  _____  ______ _     _____ _____ _____ 
# | \ | |  _  || | | ||  _  | | ___ \ |   |  _  /  __ \  _  |
# |  \| | | | || | | || | | | | |_/ / |   | | | | /  \/ | | |
# | . ` | | | || | | || | | | | ___ \ |   | | | | |   | | | |
# | |\  \ \_/ /\ \_/ /\ \_/ / | |_/ / |___\ \_/ / \__/\ \_/ /
# \_| \_/\___/  \___/  \___/  \____/\_____/\___/ \____/\___/ 
##############################################################                                                       
                                                           
						# Checagem para criação de bloco novo
	Update.genNewBlock:			la		t0,	lineDrawnCounter
						lbu		t1,	(t0)
						la		t2,	scrollSpeed
						lbu		t3,	0(t2)
						add		t1,	t1,	t3
						li		t4,	32
						remu		t5,	t1,	t4			# Resetamos o contador, mas com o número de linhas acima de 32
						sb		t5,	0(t0)				# Armazenamos na memória o valor
						blt		t1,	t4,	NoNewBlock		# Se foram desenhadas menos de 32 linhas, nada a fazer
						
						la		t0,	blockCounter
						lbu		t1,	0(t0)				# Vemos quantos blocos foram gerados
						li		t2,	14				
						beq		t1,	t2,	Update.genPreBridge	# Se estivermos criando o bloco 15, queremos que seja o mais largo possível
						li		t2,	15
						bne		t1,	t2,	Update.normalBlock	# Se não estivermos criando o bloco 16, precisa ser ponte
						la		t0,	blockCurrent			# É hora de criar uma ponte
						la		t1,	blockPrevious
						li		t2,	0x52				# Bloco do tamanho certo para a ponte
						lbu		t3,	0(t0)				# Pegamos o bloco atual para salvar em blockPrevious
						sb		t3,	0(t1)				# Salvando em Previous
						sb		t2,	0(t0)				# Salvando o bloco novo em Current
						
						# Criando ponte
						# Como a ponte fica sempre na mesma posição, não usaremos rotinas aleatórias
						# Em vez disso, usaremos os valores fixos da memória, com um pequeno ajuste em Y
						# Então precisamos de um simples memcpy
						la		t6,	objectPtrList			# Lista de ponteiros para objetos 0 a 6
						la		t0,	objectListWriteIdx		# Endereço onde está o número do índice onde será salvo o objeto						
						lbu		t1,	0(t0)				# Pegamos esse valor
						li		t2,	4				# Offset de word
						mul		t3,	t1,	t2			# Cálculo do offset
						add		t6,	t6,	t3			# Aplicando offset
						lw		a0,	0(t6)				# Endereço de escrita do objeto certo
						mv		s0,	a0				# Salvando para depois
						la		t0,	objectFuel			# Endereço da tabela
						la		t1,	objectBridgeOffset		# Offset da ponte
						lbu		t2,	0(t1)				# Carregando esse valor
						la		t3,	objectSize
						lbu		t4,	0(t3)				# Tamanho do objeto
						mul		t2,	t4,	t2			# Cálculo do offset
						add		a1,	t0,	t2			# Aplicando offset
						mv		a2,	t4				# Colocando quantidade de bytes que vamos copiar
						call		memcpy
						la		t0,	lineDrawnCounter
						lbu		t1, 	0(t0)				# Pegando valor de linhas escritas do bloco novo para ajustar coordenada Y da ponte
						lh		t2,	18(s0)				# Pegando coordenada Y
						add		t2,	t2,	t1			# Ajustando Y
						sh		t2,	18(s0)
						j		Update.objectListUpdate
						
						# Game level update
						la		t1,	gameLevel			# Como geramos uma ponte, incrementamos o nível do jogo
						lw		t0,	0(t1)				# O nível do jogo é usado na decisão de dificuldade
						addi		t0,	t0,	1
						sw		t0,	0(t1)
						# Atualização da dificuldade
						la		t0,	gameLevel			# Pegamos o nível do jogo
						lw		t1,	0(t0)
						la		t2,	difficInterv			# Pegamos o intervalo de dificuldade
						lbu		t3,	0(t2)				
						remu		t1,	t1,	t3			# Se o resultado da operação mod = 0, então atualizamos a dificuldade
						bne		t1,	zero,	Update.write2Playfield	# Se não, nada fazemos
						la		t0,	difficulty
						lbu		t1,	0(t0)				# Carregando o valor da dificuldade
						addi		t1,	t1,	1			# Incrementando
						la		t2,	maxDiffic
						lbu		t3,	0(t2)				# Carregando valor da dificuldade máxima
						blt		t1,	t3,	Update.notMaxDiffic	# Se o valor da nova dificuldade for maior que o máximo, ajustamos-o
						mv		t1,	t3				# Chegando à dificuldade máxima, o jogo permanece nela
	Update.notMaxDiffic:			sb		t1,	0(t0)				# Dificuldade atualizada
						j		Update.write2Playfield			
						
	Update.genPreBridge:			la		t0,	blockCurrent
						la		t1,	blockPrevious
						li		t2,	0x07				# Bloco mais largo possível
						lbu		t3,	0(t0)				# Pegamos o bloco atual para salvar em blockPrevious
						sb		t3,	0(t1)				# Salvando em Previous
						sb		t2,	0(t0)				# Salvando o bloco novo em Current
						j		Update.genObject			# Seguimos para a criação do objeto
						
	Update.normalBlock:			la		a0,	blockCurrent			# Geração do bloco novo
						la		a1,	blockPrevious
						la		t0,	DifficultyTable			# Endereço da tabela de dificuldade
						la		t1,	DifficultyOffset		# Endereço do offset a ser aplicado na tabela
						la		t2,	difficulty			# Endereço do valor da dificuldade atual
						lbu		t3,	0(t2)				# Pegamos o valor da dificuldade
						lbu		t4,	0(t1)				# Pegando o offset
						mul		t3,	t3,	t4			# Multiplicando dificuldade por offset para acharmos a posição na tabela
						add		t0,	t0,	t3			# Encontramos o endereço da posição correspondente à dificuldade atual
						lbu		a2,	0(t0)				# Quantidade de blocos máxima de terra, partindo da ponta
						lbu		a3,	1(t0)				# Quantidade de blocos mínima de rio
						lbu		a4,	2(t0)				# Largura mínima de abertura
						lbu		s0,	3(t0)				# Probabilidade	de fuel, para a próxima rotina
						lbu		s1,	4(t0)				# Índice máximo dos inimigos, para a próxima rotina
						call		createBlock
						#############################
						# Geração do próximo objeto #
						#############################
	Update.genObject:			la		t6,	objectPtrList			# Lista de ponteiros para objetos 0 a 6
						la		t0,	objectListWriteIdx		# Endereço onde está o número do índice onde será salvo o objeto						
						lbu		t1,	0(t0)				# Pegamos esse valor
						li		t2,	4				# Offset de word
						mul		t3,	t1,	t2			# Cálculo do offset
						add		t6,	t6,	t3			# Aplicando offset
						lw		a0,	0(t6)				# Endereço de escrita do objeto certo
						mv		s7,	a0				# Salvando valor para a rotina placeObject
						addi		a1,	a0,	25			# Número mágico que indica em que endereço está a variável de direção
						la		a2,	objectFuel			# Endereço da tabela de objetos (o primeiro elemento é fuel)
						la		t1,	objectSize
						lbu		a3,	0(t1)				# Tamanho do objeto
						mv		a4,	s0				# Probabilidade guardada antes de createBlock
						mv		a5,	s1				# Outro número pego antes de createBlock
						call		generateObject
						
						la		t0,	blockCurrent
						lbu		a0,	0(t0)				# Id do bloco atual
						la		t2,	lineDrawnCounter		
						lbu		a2,	0(t2)				# Número de linhas desenhadas do novo bloco
						li		a1,	20				# Até agora, todos os objetos criados aqui tem largura 20
						call		placeObject
						
						addi		t0,	s7,	16			# Endereço de escrita salvo antes de generateObject, com offset..
						sh		a0,	0(t0)				# ..para acharmos o endereço de objectPosX
						addi		t1,	s7,	18			# Endereço de PosY
						sh		a1,	0(t1)	
						
	Update.objectListUpdate:		la		t0,	objectListWriteIdx		# Atualizando índice para usarmos o próximo espaço no vetor de objetos
						lbu		t1,	0(t0)
						addi		t1,	t1,	1
						li		t2,	6
						remu		t1,	t1,	t2			# Índice dever estar sempre em [0,6]
						sb		t1,	0(t0)				# Atualizado
						
		
	Update.write2Playfield:			la		a0,	playfield
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
						la		t0,	blockCounter
						lbu		t1,	0(t0)				# Atualizamos o número de blocos escritos
						addi		t1,	t1,	1
						li		t2,	16				# Número de blocos por sessão
						remu		t1,	t1,	t2			# Fazemos o mod para resetar o contador
						sb		t1,	0(t0)
						
						
																		
	NoNewBlock:				nop
	
###############################################################################################						
# ______      _   _                       _           ___                       _            
# | ___ \    | | (_)                     | |         |_  |                     | |           
# | |_/ /___ | |_ _ _ __   __ _ ___    __| | ___       | | ___   __ _  __ _  __| | ___  _ __ 
# |    // _ \| __| | '_ \ / _` / __|  / _` |/ _ \      | |/ _ \ / _` |/ _` |/ _` |/ _ \| '__|
# | |\ \ (_) | |_| | | | | (_| \__ \ | (_| | (_) | /\__/ / (_) | (_| | (_| | (_| | (_) | |   
# \_| \_\___/ \__|_|_| |_|\__,_|___/  \__,_|\___/  \____/ \___/ \__, |\__,_|\__,_|\___/|_|   
#                                                                __/ |                       
#                                                               |___/                        
###############################################################################################
	#### RECEBIMENTO DE INPUT ####
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
						la		t0,	Arg9
						la		t1,	shotCreate
						sw		t1,	0(t0)
						call		getInputRars
						
						
						li		a0,	0xFF200200
						li		a1,	0xFF200204
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
						la		t0, Arg9
						li		t1,	0xFF20021C
						sw		t1, 0(t0)
						#call		getInputStick
	
	######################
	# ESPERA PARA ATIRAR #				
	######################		
	
						la		s0,	shotCreate			# Endereço da variável de criação de tiro
						la		s1,	playerShotCD			# Endereço do contador de espera
						lbu		t0,	0(s0)				# Vemos se há tiro para criar
						lb		t1,	0(s1)				# Pegamos o contador
						beq		t0,	zero,	Player.CD.end		# Se for 1, temos que avaliar se o tiro pode ser criado ou se precisamos esperar
						beq		t1,	zero,	Player.CD.addCD		# Se o contador de espera estiver em zero, sem problemas		
						li		t0,	0
						sb		t0,	0(s0)				# Se não, cancelamos o tiro
						j		Player.CD.end
	Player.CD.addCD:			la		s2,	shotDelay			# Houve tiro, então temos que começar o período de espera
						lbu		t1,	0(s2)				# Pegamos o valor de espera da ROM													
						j		Player.CD.end.noAdjust																	
	Player.CD.end:				addi		t1,	t1,	-1			# Passou-se um frame, então diminuimos em 1
						bge		t1,	zero,	Player.CD.end.noAdjust	# Se for maior que zero, está OK
						li		t1,	0				# Se não, ajustamos
	Player.CD.end.noAdjust:			sb		t1,	0(s1)				# Guardamos o valor
	
	#####################
	# DESENHO E COLISÃO #
	#####################
	Player.render:				la		t0,	playerPosX			# Carregando X do jogador
						lhu		a0,	0(t0)
						la		t0,	playerPosY			# Carregando Y do jogador
						lbu		a1,	0(t0)
						li		a2,	PLAYER_HEIGHT			# Carregando altura do sprite
						li		a3,	PLAYER_WIDTH			# Carregando largura
						la		t0,	playerCrrSpr
						lw		a4,	0(t0)				# Pegando bitmap atual (normal ou virando para um lado)
						la		t0, 	framePtr			# Pegando endereço do VGA atual
						lw		a5, 	0(t0)
						la		t0,	playerDirection			# Carregando direção
						lbu		a6,	0(t0)
						la		a7,	playerCollision			# Endereço onde será salvo o byte de colisão
						call		drawPlayerChkC												
																		

#  _____                         _       ______                        
# |_   _|                       | |      |  ___|                       
#   | |_ __ ___   ___ __ _    __| | ___  | |_ _ __ __ _ _ __ ___   ___ 
#   | | '__/ _ \ / __/ _` |  / _` |/ _ \ |  _| '__/ _` | '_ ` _ \ / _ \
#   | | | | (_) | (_| (_| | | (_| |  __/ | | | | | (_| | | | | | |  __/
#   \_/_|  \___/ \___\__,_|  \__,_|\___| \_| |_|  \__,_|_| |_| |_|\___|
                                                                     
                                                                      
	
						la		t0,	frameToShow			# Terminamos de desenhar, então mostramos o frame
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
						la		t0,	gameTime			# Recuperamos o tempo salvo no começo do ciclo
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
	Wait.noAdjust:				mv		a0,	t2				# Usamos o ecall para esperar o tempo calculado até o próximo ciclo
						li		a7,	32
						ecall
						
						j		MainLoop				# Voltando ao ínicio
						
						
						# Fim do programa
						li		a7,	10				
						ecall	
						
			

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
						

				
#############################
# Desenha um objeto na tela				
# a0: Coordenada X
# a1: Coordenada Y
# a2: Altura do objeto
# a3: Largura do objeto
# a4: Endereço do bitmap do objeto
# a5: Endereço do VGA
# a6: Desenhar invertido (1 ou 0)
# TODO: Hit detection
############################

drawObject:				blt		a1,	zero,	drawObject.finish 	# Se Y < 0, objeto não é visível
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
							sb		t1,	0(t0)			# Desenhamos na tela
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
							sb		t1,	0(t0)			# Desenhamos na tela
	drawObject.noDrawF:				addi		a4,	a4,	-1		# Passamos para o próximo byte
	
							addi		t0,	t0,	1		# Próximo endereço de pintura
							addi		t6,	t6,	-1		# j--
							j		drawObject.drawLineF						
																			
	
	drawObject.drawLineF.end:		add		a4,	a4,	a3			# Ajustando o endereço do bitmap, após desenho de linha invertido
						addi		a4,	a4,	1
	drawObject.drawLine.end:		addi		a1,	a1,	-1			# (Y--): Passamos para a próxima linha do objeto								
						addi		a2,	a2,	-1			# height--
						j		drawObject.start			# Se estiver como esperado, a4 já deve estar com o endereço certo
						
	drawObject.finish:		ret
	
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
					# Aqui colocaremos o caso de tiro

	getInputStick.end:		ret
			
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
					li		a1,	-6					# Y inicial padrão para um objeto novo ("fora da tela")
					add		a1,	a1,	a2				# Ajuste necessário, sem ele o objetos novos seram colocados em posições erradas
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
# a0: Endereço do frame 0
# a1: Endereço do frame 1
# a2: Contador de frames para troca
# a3: Número para a troca
# Saídas:
# a2: Contador de frames atualizado
# Também altera o conteúdo dos endereços a0 e a1
############################

animateObject:				beq		a3,	zero,	animateObject.end			# Se não for um objeto animado, não é feita a rotina
					addi		a2,	a2,	1
					bne		a2,	a3,	animateObject.end			# Se a2 != a3, ainda não é hora de atualizar o frame
					lw		t0,	0(a0)						# Salvamos o endereço do frame anterior em t0 temporariamente
					lw		t1,	0(a1)						# Pegamos o endereço do frame novo para sobreescrever
					sw		t1,	0(a0)						# Trocado
					sw		t0,	0(a1)						# Trocado também
					li		a2,	0						# Resetamos o contador						
	animateObject.end:		ret


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

###############################
# - Memcpy -
# Entradas.
# a0 : Endereço de destino ;; a1 : Endereço de origem ;; a2 : Tamanho em bytes
# Saídas.
# a0 : Endereço de destino
###############################
memcpy:					mv 		t0,	zero
	memcpy.L1:			beq		t0,	a2,	memcpy.L1.end
		
						lbu		t1,	(a1)
						sb		t1,	(a0)
						addi		t0, 	t0,	1
						addi		a0,	a0,	1
						addi		a1,	a1,	1
						j		memcpy.L1
							
	memcpy.L1.end:			ret

																																		
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
	 
# Bridge (80w 12h)
Bridg_f0:.byte BRDG, BRDG, BRDG, BRDG, BRDG, BRDG, BRDG, BRDG, BRDG, BRDG, BRDG, BRDG, BRDG, BRDG, BRDG, BRDG, BRDG, BRDG, BRDG, BRDG, BRDG, BRDG, BRDG, BRDG, BRDG, BRDG, BRDG, BRDG, BRDG, BRDG, BRDG, BRDG, BRDG, BRDG, BRDG, BRDG, BRDG, BRDG, BRDG, BRDG, BRDG, BRDG, BRDG, BRDG, BRDG, BRDG, BRDG, BRDG, BRDG, BRDG, BRDG, BRDG, BRDG, BRDG, BRDG, BRDG, BRDG, BRDG, BRDG, BRDG, BRDG, BRDG, BRDG, BRDG, BRDG, BRDG, BRDG, BRDG, BRDG, BRDG, BRDG, BRDG, BRDG, BRDG, BRDG, BRDG, BRDG, BRDG, BRDG, BRDG 
	 .byte BRDG, BRDG, BRDG, BRDG, BRDG, BRDG, BRDG, BRDG, BRDG, BRDG, BRDG, BRDG, BRDG, BRDG, BRDG, BRDG, BRDG, BRDG, BRDG, BRDG, BRDG, BRDG, BRDG, BRDG, BRDG, BRDG, BRDG, BRDG, BRDG, BRDG, BRDG, BRDG, BRDG, BRDG, BRDG, BRDG, BRDG, BRDG, BRDG, BRDG, BRDG, BRDG, BRDG, BRDG, BRDG, BRDG, BRDG, BRDG, BRDG, BRDG, BRDG, BRDG, BRDG, BRDG, BRDG, BRDG, BRDG, BRDG, BRDG, BRDG, BRDG, BRDG, BRDG, BRDG, BRDG, BRDG, BRDG, BRDG, BRDG, BRDG, BRDG, BRDG, BRDG, BRDG, BRDG, BRDG, BRDG, BRDG, BRDG, BRDG
	 .byte BRDG, BRDG, BRDG, BRDG, BRDG, BRDG, BRDG, BRDG, BRDG, BRDG, BRDG, BRDG, BRDG, BRDG, BRDG, BRDG, BRDG, BRDG, BRDG, BRDG, BRDG, BRDG, BRDG, BRDG, BRDG, BRDG, BRDG, BRDG, BRDG, BRDG, BRDG, BRDG, BRDG, BRDG, BRDG, BRDG, BRDG, BRDG, BRDG, BRDG, BRDG, BRDG, BRDG, BRDG, BRDG, BRDG, BRDG, BRDG, BRDG, BRDG, BRDG, BRDG, BRDG, BRDG, BRDG, BRDG, BRDG, BRDG, BRDG, BRDG, BRDG, BRDG, BRDG, BRDG, BRDG, BRDG, BRDG, BRDG, BRDG, BRDG, BRDG, BRDG, BRDG, BRDG, BRDG, BRDG, BRDG, BRDG, BRDG, BRDG
	 .byte BRDG, BRDG, BRDG, BRDG, BRDG, BRDG, BRDG, BRDG, BRDG, BRDG, BRDG, BRDG, BRDG, BRDG, BRDG, BRDG, BRDG, BRDG, BRDG, BRDG, BRDG, BRDG, BRDG, BRDG, BRDG, BRDG, BRDG, BRDG, BRDG, BRDG, BRDG, BRDG, BRDG, BRDG, BRDG, BRDG, BRDG, BRDG, BRDG, BRDG, BRDG, BRDG, BRDG, BRDG, BRDG, BRDG, BRDG, BRDG, BRDG, BRDG, BRDG, BRDG, BRDG, BRDG, BRDG, BRDG, BRDG, BRDG, BRDG, BRDG, BRDG, BRDG, BRDG, BRDG, BRDG, BRDG, BRDG, BRDG, BRDG, BRDG, BRDG, BRDG, BRDG, BRDG, BRDG, BRDG, BRDG, BRDG, BRDG, BRDG
	 .byte BRDG, BRDG, BRDG, BRDG, BRDG, BRDG, BRDG, BRDG, BRDG, BRDG, BRDG, BRDG, BRDG, BRDG, BRDG, BRDG, BRDG, BRDG, BRDG, BRDG, BRDG, BRDG, BRDG, BRDG, BRDG, BRDG, BRDG, BRDG, BRDG, BRDG, BRDG, BRDG, BRDG, BRDG, BRDG, BRDG, BRDG, BRDG, BRDG, BRDG, BRDG, BRDG, BRDG, BRDG, BRDG, BRDG, BRDG, BRDG, BRDG, BRDG, BRDG, BRDG, BRDG, BRDG, BRDG, BRDG, BRDG, BRDG, BRDG, BRDG, BRDG, BRDG, BRDG, BRDG, BRDG, BRDG, BRDG, BRDG, BRDG, BRDG, BRDG, BRDG, BRDG, BRDG, BRDG, BRDG, BRDG, BRDG, BRDG, BRDG
	 .byte BRDG, BRDG, BRDG, BRDG, BRDG, BRDG, BRDG, BRDG, BRDG, BRDG, BRDG, BRDG, BRDG, BRDG, BRDG, BRDG, BRDG, BRDG, BRDG, BRDG, BRDG, BRDG, BRDG, BRDG, BRDG, BRDG, BRDG, BRDG, BRDG, BRDG, BRDG, BRDG, BRDG, BRDG, BRDG, BRDG, BRDG, BRDG, BRDG, BRDG, BRDG, BRDG, BRDG, BRDG, BRDG, BRDG, BRDG, BRDG, BRDG, BRDG, BRDG, BRDG, BRDG, BRDG, BRDG, BRDG, BRDG, BRDG, BRDG, BRDG, BRDG, BRDG, BRDG, BRDG, BRDG, BRDG, BRDG, BRDG, BRDG, BRDG, BRDG, BRDG, BRDG, BRDG, BRDG, BRDG, BRDG, BRDG, BRDG, BRDG
	 .byte BRDG, BRDG, BRDG, BRDG, BRDG, BRDG, BRDG, BRDG, BRDG, BRDG, BRDG, BRDG, BRDG, BRDG, BRDG, BRDG, BRDG, BRDG, BRDG, BRDG, BRDG, BRDG, BRDG, BRDG, BRDG, BRDG, BRDG, BRDG, BRDG, BRDG, BRDG, BRDG, BRDG, BRDG, BRDG, BRDG, BRDG, BRDG, BRDG, BRDG, BRDG, BRDG, BRDG, BRDG, BRDG, BRDG, BRDG, BRDG, BRDG, BRDG, BRDG, BRDG, BRDG, BRDG, BRDG, BRDG, BRDG, BRDG, BRDG, BRDG, BRDG, BRDG, BRDG, BRDG, BRDG, BRDG, BRDG, BRDG, BRDG, BRDG, BRDG, BRDG, BRDG, BRDG, BRDG, BRDG, BRDG, BRDG, BRDG, BRDG
	 .byte BRDG, BRDG, BRDG, BRDG, BRDG, BRDG, BRDG, BRDG, BRDG, BRDG, BRDG, BRDG, BRDG, BRDG, BRDG, BRDG, BRDG, BRDG, BRDG, BRDG, BRDG, BRDG, BRDG, BRDG, BRDG, BRDG, BRDG, BRDG, BRDG, BRDG, BRDG, BRDG, BRDG, BRDG, BRDG, BRDG, BRDG, BRDG, BRDG, BRDG, BRDG, BRDG, BRDG, BRDG, BRDG, BRDG, BRDG, BRDG, BRDG, BRDG, BRDG, BRDG, BRDG, BRDG, BRDG, BRDG, BRDG, BRDG, BRDG, BRDG, BRDG, BRDG, BRDG, BRDG, BRDG, BRDG, BRDG, BRDG, BRDG, BRDG, BRDG, BRDG, BRDG, BRDG, BRDG, BRDG, BRDG, BRDG, BRDG, BRDG
	 .byte BRDG, BRDG, BRDG, BRDG, BRDG, BRDG, BRDG, BRDG, BRDG, BRDG, BRDG, BRDG, BRDG, BRDG, BRDG, BRDG, BRDG, BRDG, BRDG, BRDG, BRDG, BRDG, BRDG, BRDG, BRDG, BRDG, BRDG, BRDG, BRDG, BRDG, BRDG, BRDG, BRDG, BRDG, BRDG, BRDG, BRDG, BRDG, BRDG, BRDG, BRDG, BRDG, BRDG, BRDG, BRDG, BRDG, BRDG, BRDG, BRDG, BRDG, BRDG, BRDG, BRDG, BRDG, BRDG, BRDG, BRDG, BRDG, BRDG, BRDG, BRDG, BRDG, BRDG, BRDG, BRDG, BRDG, BRDG, BRDG, BRDG, BRDG, BRDG, BRDG, BRDG, BRDG, BRDG, BRDG, BRDG, BRDG, BRDG, BRDG
	 .byte BRDG, BRDG, BRDG, BRDG, BRDG, BRDG, BRDG, BRDG, BRDG, BRDG, BRDG, BRDG, BRDG, BRDG, BRDG, BRDG, BRDG, BRDG, BRDG, BRDG, BRDG, BRDG, BRDG, BRDG, BRDG, BRDG, BRDG, BRDG, BRDG, BRDG, BRDG, BRDG, BRDG, BRDG, BRDG, BRDG, BRDG, BRDG, BRDG, BRDG, BRDG, BRDG, BRDG, BRDG, BRDG, BRDG, BRDG, BRDG, BRDG, BRDG, BRDG, BRDG, BRDG, BRDG, BRDG, BRDG, BRDG, BRDG, BRDG, BRDG, BRDG, BRDG, BRDG, BRDG, BRDG, BRDG, BRDG, BRDG, BRDG, BRDG, BRDG, BRDG, BRDG, BRDG, BRDG, BRDG, BRDG, BRDG, BRDG, BRDG
	 .byte BRDG, BRDG, BRDG, BRDG, BRDG, BRDG, BRDG, BRDG, BRDG, BRDG, BRDG, BRDG, BRDG, BRDG, BRDG, BRDG, BRDG, BRDG, BRDG, BRDG, BRDG, BRDG, BRDG, BRDG, BRDG, BRDG, BRDG, BRDG, BRDG, BRDG, BRDG, BRDG, BRDG, BRDG, BRDG, BRDG, BRDG, BRDG, BRDG, BRDG, BRDG, BRDG, BRDG, BRDG, BRDG, BRDG, BRDG, BRDG, BRDG, BRDG, BRDG, BRDG, BRDG, BRDG, BRDG, BRDG, BRDG, BRDG, BRDG, BRDG, BRDG, BRDG, BRDG, BRDG, BRDG, BRDG, BRDG, BRDG, BRDG, BRDG, BRDG, BRDG, BRDG, BRDG, BRDG, BRDG, BRDG, BRDG, BRDG, BRDG
	 .byte BRDG, BRDG, BRDG, BRDG, BRDG, BRDG, BRDG, BRDG, BRDG, BRDG, BRDG, BRDG, BRDG, BRDG, BRDG, BRDG, BRDG, BRDG, BRDG, BRDG, BRDG, BRDG, BRDG, BRDG, BRDG, BRDG, BRDG, BRDG, BRDG, BRDG, BRDG, BRDG, BRDG, BRDG, BRDG, BRDG, BRDG, BRDG, BRDG, BRDG, BRDG, BRDG, BRDG, BRDG, BRDG, BRDG, BRDG, BRDG, BRDG, BRDG, BRDG, BRDG, BRDG, BRDG, BRDG, BRDG, BRDG, BRDG, BRDG, BRDG, BRDG, BRDG, BRDG, BRDG, BRDG, BRDG, BRDG, BRDG, BRDG, BRDG, BRDG, BRDG, BRDG, BRDG, BRDG, BRDG, BRDG, BRDG, BRDG, BRDG
	 
	 
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
                 
########################
# Tabela de dificuldade
# Byte 00: Quantidade de blocos máxima de terra, partindo da ponta
# Byte 01: Quantidade de blocos mínima de rio
# Byte 02: Largura mínima de abertura
# Byte 03: Probabilidade de gerar combústivel (1/x) (Na rotina, se o número aleatório Mod x == 0, é fuel)
# Byte 04: Índice máximo dos inimigos que podem aparecer (+1)
########################
DifficultyOffset:	.byte 5
DifficultyTable:	.byte 6, 1, 1, 12, 4 # Dificuldade 0
	  		.byte 2, 5, 2, 4, 2 # Dificuldade 1
	  		.byte 4, 3, 2, 6, 3 # Dificuldade 2
	  		.byte 5, 2, 2, 7, 4 # Dificuldade 3
	  	
	  		.byte 6, 1, 1, 12,4 # Doomguy_ouch.png


#########################
# Objetos
#########################
objectSize: 	.byte 32 # Tamanho de um objeto em bytes

.align 2
# 00 - Fuel
objectFuel: 	.word Fuel_f0		# 00 objectBitmapPtr0: .word # endereço do frame 0	
		.word Fuel_f0		# 04 objectBitmapPtr1: .word # endereço do frame 1	
		.word 0			# 08 objectCollision: .word # endereço da rotina de colisão	
		.word 0			# 12 objectAction: .word # endereço de rotina especial	
		.half 0			# 16 objectXpos: .half
		.half 0			# 18 objectYpos: .half			
		.byte 0			# 20 objectType: .byte	
		.byte 0			# 21 objectIsAnim: .byte
		.byte 0			# 22 objectXspeed: .byte	
		.byte 20		# 23 objectHeight: .byte	
		.byte 20		# 24 objectWidth: .byte	
		.byte 0			# 25 objectDirection: .byte	
		.byte 0			# 26 objectAnimationCounter: .byte	
		.byte 0			# 27 objectAnimationTime: .byte	
		.byte 0			# 28 objectCollided: .byte # booleana de colisão	
		.space 3

.align 2
# 01 - Helicopter
objectHeli:	.word Heli_f0		# 00 objectBitmapPtr0: .word # endereço do frame 0	
		.word Heli_f1		# 04 objectBitmapPtr1: .word # endereço do frame 1	
		.word 0			# 08 objectCollision: .word # endereço da rotina de colisão	
		.word 0			# 12 objectAction: .word # endereço de rotina especial	
		.half 0			# 16 objectXpos: .half
		.half 0			# 18 objectYpos: .half			
		.byte 1			# 20 objectType: .byte	
		.byte 1			# 21 objectIsAnim: .byte
		.byte 3			# 22 objectXspeed: .byte	
		.byte 20		# 23 objectHeight: .byte	
		.byte 20		# 24 objectWidth: .byte	
		.byte 0			# 25 objectDirection: .byte	
		.byte 0			# 26 objectAnimationCounter: .byte	
		.byte 1			# 27 objectAnimationTime: .byte	
		.byte 0			# 28 objectCollided: .byte # booleana de colisão	
		.space 3

.align 2
# 02 - Ship
objectShip:	.word Ship_f0		# 00 objectBitmapPtr0: .word # endereço do frame 0	
		.word Ship_f0		# 04 objectBitmapPtr1: .word # endereço do frame 1	
		.word 0			# 08 objectCollision: .word # endereço da rotina de colisão	
		.word 0			# 12 objectAction: .word # endereço de rotina especial	
		.half 0			# 16 objectXpos: .half
		.half 0			# 18 objectYpos: .half			
		.byte 2			# 20 objectType: .byte	
		.byte 0			# 21 objectIsAnim: .byte
		.byte 2			# 22 objectXspeed: .byte	
		.byte 20		# 23 objectHeight: .byte	
		.byte 20		# 24 objectWidth: .byte	
		.byte 0			# 25 objectDirection: .byte	
		.byte 0			# 26 objectAnimationCounter: .byte	
		.byte 0			# 27 objectAnimationTime: .byte	
		.byte 0			# 28 objectCollided: .byte # booleana de colisão	
		.space 3

.align 2
# 03 - Plane
objectPlane: 	.word Plane_f0		# 00 objectBitmapPtr0: .word # endereço do frame 0	
		.word Plane_f0		# 04 objectBitmapPtr1: .word # endereço do frame 1	
		.word 0			# 08 objectCollision: .word # endereço da rotina de colisão	
		.word 0			# 12 objectAction: .word # endereço de rotina especial	
		.half 0			# 16 objectXpos: .half
		.half 0			# 18 objectYpos: .half			
		.byte 3			# 20 objectType: .byte	
		.byte 0			# 21 objectIsAnim: .byte
		.byte 12		# 22 objectXspeed: .byte	
		.byte 20		# 23 objectHeight: .byte	
		.byte 20		# 24 objectWidth: .byte	
		.byte 0			# 25 objectDirection: .byte	
		.byte 0			# 26 objectAnimationCounter: .byte	
		.byte 0			# 27 objectAnimationTime: .byte	
		.byte 0			# 28 objectCollided: .byte # booleana de colisão	
		.space 3

.align 2
# 04 - Bad fuel
objectLeuf:	.word Leuf_f0		# 00 objectBitmapPtr0: .word # endereço do frame 0	
		.word Leuf_f0		# 04 objectBitmapPtr1: .word # endereço do frame 1	
		.word 0			# 08 objectCollision: .word # endereço da rotina de colisão	
		.word 0			# 12 objectAction: .word # endereço de rotina especial	
		.half 0			# 16 objectXpos: .half
		.half 0			# 18 objectYpos: .half			
		.byte 4			# 20 objectType: .byte	
		.byte 0			# 21 objectIsAnim: .byte
		.byte 0			# 22 objectXspeed: .byte	
		.byte 20		# 23 objectHeight: .byte	
		.byte 20		# 24 objectWidth: .byte	
		.byte 0			# 25 objectDirection: .byte	
		.byte 0			# 26 objectAnimationCounter: .byte	
		.byte 0			# 27 objectAnimationTime: .byte	
		.byte 0			# 28 objectCollided: .byte # booleana de colisão	
		.space 3

.align 2
# 97 - Explosion
objectExplo:    .word Leuf_f0		# 00 objectBitmapPtr0: .word # endereço do frame 0	
		.word Leuf_f0		# 04 objectBitmapPtr1: .word # endereço do frame 1	
		.word 0			# 08 objectCollision: .word # endereço da rotina de colisão	
		.word 0			# 12 objectAction: .word # endereço de rotina especial	
		.half 0			# 16 objectXpos: .half
		.half 0			# 18 objectYpos: .half			
		.byte 97		# 20 objectType: .byte	
		.byte 0			# 21 objectIsAnim: .byte
		.byte 0			# 22 objectXspeed: .byte	
		.byte 20		# 23 objectHeight: .byte	
		.byte 20		# 24 objectWidth: .byte	
		.byte 0			# 25 objectDirection: .byte	
		.byte 0			# 26 objectAnimationCounter: .byte	
		.byte 0			# 27 objectAnimationTime: .byte	
		.byte 0			# 28 objectCollided: .byte # booleana de colisão	
		.space 3

.align 2
# 98 - Empty
objectEmpty:	.word Leuf_f0		# 00 objectBitmapPtr0: .word # endereço do frame 0	
		.word Leuf_f0		# 04 objectBitmapPtr1: .word # endereço do frame 1	
		.word 0			# 08 objectCollision: .word # endereço da rotina de colisão	
		.word 0			# 12 objectAction: .word # endereço de rotina especial	
		.half 0			# 16 objectXpos: .half
		.half 0			# 18 objectYpos: .half			
		.byte 98		# 20 objectType: .byte	
		.byte 0			# 21 objectIsAnim: .byte
		.byte 0			# 22 objectXspeed: .byte	
		.byte 20		# 23 objectHeight: .byte	
		.byte 20		# 24 objectWidth: .byte	
		.byte 0			# 25 objectDirection: .byte	
		.byte 0			# 26 objectAnimationCounter: .byte	
		.byte 0			# 27 objectAnimationTime: .byte	
		.byte 0			# 28 objectCollided: .byte # booleana de colisão	
		.space 3

.align 2
# 99 - Bridge
objectBridge:	.word Bridg_f0		# 00 objectBitmapPtr0: .word # endereço do frame 0	
		.word Bridg_f0		# 04 objectBitmapPtr1: .word # endereço do frame 1	
		.word 0			# 08 objectCollision: .word # endereço da rotina de colisão	
		.word 0			# 12 objectAction: .word # endereço de rotina especial	
		.half 120		# 16 objectXpos: .half
		.half -6		# 18 objectYpos: .half			
		.byte 99		# 20 objectType: .byte	
		.byte 0			# 21 objectIsAnim: .byte
		.byte 0			# 22 objectXspeed: .byte	
		.byte 12		# 23 objectHeight: .byte	
		.byte 80		# 24 objectWidth: .byte	
		.byte 0			# 25 objectDirection: .byte	
		.byte 0			# 26 objectAnimationCounter: .byte	
		.byte 0			# 27 objectAnimationTime: .byte	
		.byte 0			# 28 objectCollided: .byte # booleana de colisão	
		.space 3

objectBridgeOffset: .byte 7

# Tiro
shotSize: 	.byte 20		# Tamanho de um tiro em bytes
shotMax:	.byte 20		# Número máximo de tiros
shotDelay:	.byte 2			# Número de frames que é preciso esperar para atirar de novo
shotXoffset:	.byte 9			# Aplicado para que o tiro saia do centro do player
.align 2
shotFormat:	.word Shot_f0		# 00 Endereço do bitmap da imagem
		.half 0			# 04 Coordenada X
		.half 145		# 06 Coordenada Y
		.byte -12		# 08 Velocidade Y (Negativa, porque vai para o topo)
		.byte 6			# 09 Altura da imagem
		.byte 2			# 10 Largura da imagem
		.byte 1			# 11 Booleana de existência
		.byte 0			# 12 Booleana de colisão		

Shot_f0:	.byte SHOT, SHOT 
		.byte SHOT, SHOT
		.byte SHOT, SHOT 
		.byte SHOT, SHOT
		.byte SHOT, SHOT
		.byte SHOT, SHOT	
	

#######################
# Includes
#######################

.include "SYSTEMv17.s"
