# Cores devem ser repetidas 4 vezes na word
.eqv BANK_COLOR_4 0x10101010 										# Cor da costa, deve ser verde
.eqv RIVER_COLOR_4 0xb0b0b0b0 										# Cor do rio, azul
.eqv SCORE_COLOR_4 0x0b0b0b0b

# As cores s�o essenciais para os testes de colis�o e precisam ser diferentes (talvez)
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
.eqv PLAYER_MAX_MISSILE 20   # N�mero m�ximo de tiros na tela
.eqv PLAYER_MISSILE DELAY 15 # Quanto tempo deve-se esperar para poder atirar de novo (em ciclos)
.eqv PLAYER_SPEED_X 2 # Quantos pixels o jogador se move por ciclo quando � controlado
.eqv PLAYER_HEIGHT 20 # Medidas do sprite, em pixels
.eqv PLAYER_WIDTH 20 

.eqv TIMESTEP 33 # Em ms

.eqv VGAADDRESSINI0     0xFF000000
.eqv VGAADDRESSFIM0     0xFF012C00
.eqv VGAADDRESSINI1     0xFF100000
.eqv VGAADDRESSFIM1     0xFF112C00 
.eqv VGAFRAMESELECT	0xFF200604

.data
	# Tentar agrupar todos os words no come�o para n�o precisar usar .align
	Arg8: 	.word 0 # Caso seja necess�rio mais de 7 argumentos
	Arg9: 	.word 0 # Pois �
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
	gameLevel: .word 1				# N�mero de se��es vencidas ( n�mero de pontes geradas)
	difficulty: .byte 0				# Dificuldade atual
	maxDiffic: .byte 5				# Dificuldade m�xima
	difficInterv: .byte 1				# N�mero de se��es para que haja aumento de dificuldade
	
	
	
	
	frameToShow: .byte 1 # Frame do VGA selecionado										
	scrollSpeed: .byte 2 # Velocidade de scroll vertical atual
	
	scrollSpeedNormal: .byte 2 # Velocidade de scroll vertical padr�o
	scrollSpeedFast: .byte 4 # Velocidade de scroll vertical r�pida
	scrollSpeedSlow: .byte 1 # Velocidade devagar

	blockWriteOffset: .byte 0
	blockCurrent: .byte 0x07 # Cada parte de uma dos blocos vis�veis � representada por um byte
	blockPrevious: .byte 0
	blockCounter: .byte 0 # N�mero de blocos criados
	
	lineDrawnCounter: .byte 0 # Contador do n�mero de linhas desenhado, para decidirmos se precisamos de um novo bloco

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
	playerShotCount: .byte 0 # Contador de tiros
	playerCollision: .byte 0 # 0 - sem colis�o; 1 - colis�o com algo que destr�i ; 2 - colis�o com fuel ; 3 - colis�o com bad fuel
	playerSpeedX: .byte 4 # Velocidade em pixels/frame
	playerShotCD: .byte 0 # N�mero de frames a esperar para atirar de novo
                                                                                                      
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
	# 00 objectBitmapPtr0: .word # endere�o do frame 0
	# 04 objectBitmapPtr1: .word # endere�o do frame 1
	# 08 objectCollision: .word # endere�o da rotina de colis�o
	# 12 objectAction: .word # endere�o de rotina especial
	# 14 objectType: .byte
	# 15 objectIsAnim: .byte		
	# 16 objectXpos: .half
	# 18 objectYpos: .byte
	# 19 objectXspeed: .byte
	# 20 objectHeight: .byte
	# 21 objectWidth: .byte
	# 22 objectDirection: .byte
	# 23 objectAnimationCounter: .byte # Contador de frames de anima��o
	# 24 objectAnimationTime: .byte # N�meros de frames at� que seja executado a rotina em objectAction
	.align 2
	object0: .space 32
	object1: .space 32
	object2: .space 32
	object3: .space 32
	object4: .space 32
	object5: .space 32
	objectListWriteIdx: .byte 0	# �ndice do vetor de objetos onde ser� escrito o pr�ximo
	
	# shotBitmap: .word
	# shotXcoord: .half
	# shotYcoord: .half
	# shotYspeed: .byte
	# shotHeight: .byte
	# shotWidth: .byte
	# shotExists: .byte
	shotCreate: .byte 0		# Se for 1 no frame atual, criamos um tiro novo
	shotWriteIdx: .byte 0		# �ndice para escrita
	.align 2
	shotVector: .space 400		# Espa�o para 20 tiros
	
	
.text

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
# ______ _____ _____ _____ _____ 
# | ___ \  ___/  ___|  ___|_   _|
# | |_/ / |__ \ `--.| |__   | |  
# |    /|  __| `--. \  __|  | |  
# | |\ \| |___/\__/ / |___  | |  
# \_| \_\____/\____/\____/  \_/  
#	
#	Resetando todos as vari�veis..					
					la		t0,	playerCrrSpr				
					la		t1,	Plyr_0					# Sprite do jogador padr�o
					sw		t1,	0(t0)					# Salvando no espa�o correto
					
					
					la		t0,	objectListWriteIdx			# Resetando o �ndice da lista de objetos
					li		t1,	0
					sb		t1,	0(t0)
					
					la		t0,	object0					# Colocando zero em todos os objetos para indicar que n�o foram criados ainda
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
					
					


	# Os primeiros blocos s�o sempre neutros #
					li		s0,	5					# i = 5
	InitSetup.genMap.0:		beq		s0,	zero,	InitSetup.genMap.0.end		# (while i > 0)
						
						la		t0,	blockCurrent
						li		t1,	0x07				# Um bloco sem ilha e com a maior largura poss�vel
						sb		t1,	0(t0)				# Salvamos no endere�o do bloco atual
		
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
						lbu		t1,	0(t0)				# Atualizamos o n�mero de blocos escritos
						addi		t1,	t1,	1
						sb		t1,	0(t0)
						
						
						addi		s0,	s0,	-1			# i--
						j		InitSetup.genMap.0
						
	InitSetup.genMap.0.end:		la		a0,	blockCurrent			# Gera��o do bloco novo
					la		a1,	blockPrevious
					la		t0,	DifficultyTable			# Endere�o da tabela de dificuldade
					la		t1,	DifficultyOffset		# Endere�o do offset a ser aplicado na tabela
					la		t2,	difficulty			# Endere�o da dificuldade
					lbu		t3,	0(t2)				# Pegamos o valor da dificuldade
					lbu		t4,	0(t1)				# Pegando o offset
					mul		t3,	t3,	t4			# Multiplicando dificuldade por offset para acharmos a posi��o na tabela
					add		t0,	t0,	t3			# Encontramos o endere�o da posi��o correspondente � dificuldade atual
					lbu		a2,	0(t0)				# Quantidade de blocos m�xima de terra, partindo da ponta
					lbu		a3,	1(t0)				# Quantidade de blocos m�nima de rio
					lbu		a4,	2(t0)				# Largura m�nima de abertura
						
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
					lbu		t1,	0(t0)				# Atualizamos o n�mero de blocos escritos
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
	# Pegamos o tempo no come�o de cada ciclo para calcularmos o tempo de sleep no final, com base no time step escolhido
	MainLoop:
	
						# Get Frame Start Time
						# Para o RARS
						la		t0,	gameTime			# Aqui salvaremos o tempo no come�o do ciclo
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
						
	######################
	# DESENHO DE OBJETOS #
	######################
	# Nota: Tamb�m faz detec��o de colis�o
						li		s0,	0				# s0 = i
						li		s1,	6
						la		s2,	object0				# Endere�o do primeiro objeto
						la		t0,	objectSize			
						lbu		s3,	0(t0)				# Tamanho dos objetos, para c�lculo de offset
	Render.drawObjects:			beq		s0,	s1,	Render.drawObjects.end	# Para cada um dos objetos
						
							lw		t0,	0(s2)
							beq		t0,	zero,	Render.drawObjects.empty # N�o desenhamos se ainda n�o foi escrito
							
							lhu		a0,	16(s2)			# Coordenada X aqui
							lh		a1,	18(s2)			# Coordenada Y aqui
							lbu		a2,	23(s2)			# Altura do objeto
							lbu		a3,	24(s2)			# Largura do objeto
							lw		a4,	0(s2)			# Endere�o do bitmap do objeto
							lbu		a6,	25(s2)			# Dire��o do objeto
							la		t0,	framePtr
							lw		a5,	0(t0)			# Endere�o do VGA
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
						lbu		s6,	0(t0)				# N�mero m�ximo de tiros
						la		s1,	shotVector			# Vetor de tiros
						la		t1,	shotSize
						lbu		s2,	0(t1)				# N�mero do tamanho de cada espa�o do vetor, para calcular offset
	Render.shot.L:				beq		s0,	s6,	Render.shot.end 		# Iteramos no vetor de tiro
						
							lbu		t0,	11(s1)			# Verificamos se o tiro existe
							beq		t0,	x0,	Render.shot.L.next # Se n�o existir, pulamos para o pr�ximo
							lh		a0,	4(s1)			# Coordenada X
							lh		a1,	6(s1)			# Coordenada Y
							lbu		a2,	9(s1)			# Altura
							lbu		a3,	10(s1)			# Largura
							lw		a4,	0(s1)			# Endere�o da imagem
							la		t0,	framePtr
							lw		a5,	0(t0)			# Endere�o do VGA
							addi		a6,	s1,	12		# Booleana de colis�o
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
	# ATUALIZA��O DE TIROS #
	########################
	
						la		t0,	shotCreate			# Verificamos se temos que criar um tiro
						lbu		t1,	0(t0)
						beq		t1,	zero,	Update.shotMovement	# Caso n�o, vamos para as rotinas de colis�o
						la		t0,	playerShotCount
						lb		t1,	0(t0)				# Vemos quantos tiros foram criados
						la		t0,	shotMax
						lbu		t2,	0(t0)				# Pegamos a quantidade m�xima para compara��o
						bge		t1,	t2,	Update.shotMovement	# Se chegou ao n�mero m�ximo, n�o criamos um novo tiro
						la		a0,	shotVector			# Endere�o do vetor de tiros
						la		a1,	shotFormat			# Modelo do objeto tiro
						la		t0,	shotSize
						lbu		a2,	0(t0)				# Tamanho em bytes
						la		t0,	shotWriteIdx
						lbu		a3,	0(t0)				# �ndice para escrita
						la		t1,	playerPosX
						lh		a4,	0(t1)				# Posi��o X do jogador no momento
						la		t0,	shotXoffset
						lbu		a5,	0(t0)				# Offset X de ajuste
						call		createShot
						
						la		t0,	shotWriteIdx			# Atualizando o �ndice de escrita
						lbu		t1,	0(t0)
						addi		t1,	t1,	1
						li		t2,	20				# Tamanho do vetor de tiros
						remu		t1,	t1,	t2			# Colocamos o �ndice dentro do limite
						sb		t1,	0(t0)				# Escrito no endere�o
						la		t0,	playerShotCount			# Atualizando n�mero de tiros
						lbu		t2,	0(t0)
						addi		t2,	t2,	1			# +1
						sb		t2,	0(t0)				# Gravando no endere�o
						la		t1,	shotCreate
						sb		zero,	0(t1)				# Retornamos a booleana de cria��o para 0
									
						
	Update.shotMovement:			li		s0,	0				# i = 0
						la		t0,	shotMax
						lbu		s6,	0(t0)				# N�mero m�ximo de tiros
						la		s1,	shotVector			# Vetor de tiros
						la		t1,	shotSize
						lbu		s2,	0(t1)				# N�mero do tamanho de cada espa�o do vetor, para calcular offset
	Update.shotMovement.L:			beq		s0,	s6,	Update.shotMovement.end # Iteramos no vetor de tiro
						
							lbu		t0,	11(s1)			# Verificamos se o tiro existe
							beq		t0,	x0,	Update.shotMovement.L.next # Se n�o existir, pulamos para o pr�ximo
							addi		a0,	s1,	12		# Endere�o da booleana de colis�o
							addi		a1,	s1,	11		# Endere�o da booleana de exist�ncia
							la		a2,	playerShotCount		# Endere�o com o n�mero de tiros
							call		shotColHandler			# Tratamento de colis�o							
							mv		a0,	s1
							call		moveShot					
	Update.shotMovement.L.next:			addi		s0,	s0,	1		# i++
							add		s1,	s1,	s2		# V[]++
							j		Update.shotMovement.L
	Update.shotMovement.end:
	
	


	###########################
	# ATUALIZA��O DOS OBJETOS #
	###########################
						li		s0,	0				# s0 = i
						li		s1,	6
						la		s2,	object0				# Endere�o do primeiro objeto
						la		t0,	objectSize			
						lbu		s3,	0(t0)				# Tamanho dos objetos, para c�lculo de offset
	Update.objectUpdate:			beq		s0,	s1,	Update.objectUpdate.end # Para cada um dos objetos
	
						#############
						# MOVIMENTO #
						#############
						
							lw		t0,	0(s2)
							beq		t0,	zero,	Update.objectUpdate.nope # Se estiver vazio, n�o pulamos para o pr�ximo
							la		t0,	scrollSpeed		# Velocidade de scroll vertical
							lbu		t1,	0(t0)			# Pegamos para atualizar a posi��o de todos os objetos
							lh		t2,	18(s2)			# Coordenada Y
							add		t2,	t2,	t1
							sh		t2,	18(s2)			# Atualizado
							
							lbu		a2,	22(s2)			# Velocidade X
							beq		a2,	zero,	Update.objectUpdate.animate # Se velocidade for nula, ignoramos a rotina de movimenta��o no eixo X
							lh		a0,	16(s2)			# Coordenada X
							lh		a1,	18(s2)			# Coordenada Y
							lbu		a3,	25(s2)			# Dire��o
							lbu		a4,	24(s2)			# Largura
							la		t0,	framePtr
							lw		a5,	0(t0)			# Endere�o do VGA
							lbu		a6,	20(s2)			# Tipo do objeto
							call		moveObjectX
							sh		a0,	16(s2)			# Novo X
							sb		a1,	25(s2)			# Nova dire��o
							
						############
						# ANIMA��O #
						############
							
	Update.objectUpdate.animate:			mv		a0,	s2			# Endere�o do frame 0
							addi		a1,	s2,	4		# Endere�o do frame 1
							lbu		a2,	26(s2)			# Contador de frames
							lbu		a3,	27(s2)			# N�mero limite do contador
							call		animateObject
							sb		a2,	26(s2)			# Atualizando o contador	
	
	
	Update.objectUpdate.nope:			addi		s0,	s0,	1		# ++i
							add		s2,	s2,	s3		# Object[] + 1
							j		Update.objectUpdate
	Update.objectUpdate.end:
	
	
						
	######################################
        # ATUALIZA��O DOS OFFSETS DE LEITURA #
	######################################
						la		t0,	pfReadStartOffset		# Pegando o offset atual
						lbu		t1,	0(t0)
						la		t2,	scrollSpeed			# Pegando velocidade de scroll
						lbu		t3,	0(t2)
						add		t1,	t1,	t3			# Atualizando o offset em si
						li		t4,	192				# Fazendo o wrap around (se o offset passar de 192, deve voltar ao come�o)
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
                                                           
						# Checagem para cria��o de bloco novo
	Update.genNewBlock:			la		t0,	lineDrawnCounter
						lbu		t1,	(t0)
						la		t2,	scrollSpeed
						lbu		t3,	0(t2)
						add		t1,	t1,	t3
						li		t4,	32
						remu		t5,	t1,	t4			# Resetamos o contador, mas com o n�mero de linhas acima de 32
						sb		t5,	0(t0)				# Armazenamos na mem�ria o valor
						blt		t1,	t4,	NoNewBlock		# Se foram desenhadas menos de 32 linhas, nada a fazer
						
						la		t0,	blockCounter
						lbu		t1,	0(t0)				# Vemos quantos blocos foram gerados
						li		t2,	14				
						beq		t1,	t2,	Update.genPreBridge	# Se estivermos criando o bloco 15, queremos que seja o mais largo poss�vel
						li		t2,	15
						bne		t1,	t2,	Update.normalBlock	# Se n�o estivermos criando o bloco 16, precisa ser ponte
						la		t0,	blockCurrent			# � hora de criar uma ponte
						la		t1,	blockPrevious
						li		t2,	0x52				# Bloco do tamanho certo para a ponte
						lbu		t3,	0(t0)				# Pegamos o bloco atual para salvar em blockPrevious
						sb		t3,	0(t1)				# Salvando em Previous
						sb		t2,	0(t0)				# Salvando o bloco novo em Current
						
						# Criando ponte
						# Como a ponte fica sempre na mesma posi��o, n�o usaremos rotinas aleat�rias
						# Em vez disso, usaremos os valores fixos da mem�ria, com um pequeno ajuste em Y
						# Ent�o precisamos de um simples memcpy
						la		t6,	objectPtrList			# Lista de ponteiros para objetos 0 a 6
						la		t0,	objectListWriteIdx		# Endere�o onde est� o n�mero do �ndice onde ser� salvo o objeto						
						lbu		t1,	0(t0)				# Pegamos esse valor
						li		t2,	4				# Offset de word
						mul		t3,	t1,	t2			# C�lculo do offset
						add		t6,	t6,	t3			# Aplicando offset
						lw		a0,	0(t6)				# Endere�o de escrita do objeto certo
						mv		s0,	a0				# Salvando para depois
						la		t0,	objectFuel			# Endere�o da tabela
						la		t1,	objectBridgeOffset		# Offset da ponte
						lbu		t2,	0(t1)				# Carregando esse valor
						la		t3,	objectSize
						lbu		t4,	0(t3)				# Tamanho do objeto
						mul		t2,	t4,	t2			# C�lculo do offset
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
						la		t1,	gameLevel			# Como geramos uma ponte, incrementamos o n�vel do jogo
						lw		t0,	0(t1)				# O n�vel do jogo � usado na decis�o de dificuldade
						addi		t0,	t0,	1
						sw		t0,	0(t1)
						# Atualiza��o da dificuldade
						la		t0,	gameLevel			# Pegamos o n�vel do jogo
						lw		t1,	0(t0)
						la		t2,	difficInterv			# Pegamos o intervalo de dificuldade
						lbu		t3,	0(t2)				
						remu		t1,	t1,	t3			# Se o resultado da opera��o mod = 0, ent�o atualizamos a dificuldade
						bne		t1,	zero,	Update.write2Playfield	# Se n�o, nada fazemos
						la		t0,	difficulty
						lbu		t1,	0(t0)				# Carregando o valor da dificuldade
						addi		t1,	t1,	1			# Incrementando
						la		t2,	maxDiffic
						lbu		t3,	0(t2)				# Carregando valor da dificuldade m�xima
						blt		t1,	t3,	Update.notMaxDiffic	# Se o valor da nova dificuldade for maior que o m�ximo, ajustamos-o
						mv		t1,	t3				# Chegando � dificuldade m�xima, o jogo permanece nela
	Update.notMaxDiffic:			sb		t1,	0(t0)				# Dificuldade atualizada
						j		Update.write2Playfield			
						
	Update.genPreBridge:			la		t0,	blockCurrent
						la		t1,	blockPrevious
						li		t2,	0x07				# Bloco mais largo poss�vel
						lbu		t3,	0(t0)				# Pegamos o bloco atual para salvar em blockPrevious
						sb		t3,	0(t1)				# Salvando em Previous
						sb		t2,	0(t0)				# Salvando o bloco novo em Current
						j		Update.genObject			# Seguimos para a cria��o do objeto
						
	Update.normalBlock:			la		a0,	blockCurrent			# Gera��o do bloco novo
						la		a1,	blockPrevious
						la		t0,	DifficultyTable			# Endere�o da tabela de dificuldade
						la		t1,	DifficultyOffset		# Endere�o do offset a ser aplicado na tabela
						la		t2,	difficulty			# Endere�o do valor da dificuldade atual
						lbu		t3,	0(t2)				# Pegamos o valor da dificuldade
						lbu		t4,	0(t1)				# Pegando o offset
						mul		t3,	t3,	t4			# Multiplicando dificuldade por offset para acharmos a posi��o na tabela
						add		t0,	t0,	t3			# Encontramos o endere�o da posi��o correspondente � dificuldade atual
						lbu		a2,	0(t0)				# Quantidade de blocos m�xima de terra, partindo da ponta
						lbu		a3,	1(t0)				# Quantidade de blocos m�nima de rio
						lbu		a4,	2(t0)				# Largura m�nima de abertura
						lbu		s0,	3(t0)				# Probabilidade	de fuel, para a pr�xima rotina
						lbu		s1,	4(t0)				# �ndice m�ximo dos inimigos, para a pr�xima rotina
						call		createBlock
						#############################
						# Gera��o do pr�ximo objeto #
						#############################
	Update.genObject:			la		t6,	objectPtrList			# Lista de ponteiros para objetos 0 a 6
						la		t0,	objectListWriteIdx		# Endere�o onde est� o n�mero do �ndice onde ser� salvo o objeto						
						lbu		t1,	0(t0)				# Pegamos esse valor
						li		t2,	4				# Offset de word
						mul		t3,	t1,	t2			# C�lculo do offset
						add		t6,	t6,	t3			# Aplicando offset
						lw		a0,	0(t6)				# Endere�o de escrita do objeto certo
						mv		s7,	a0				# Salvando valor para a rotina placeObject
						addi		a1,	a0,	25			# N�mero m�gico que indica em que endere�o est� a vari�vel de dire��o
						la		a2,	objectFuel			# Endere�o da tabela de objetos (o primeiro elemento � fuel)
						la		t1,	objectSize
						lbu		a3,	0(t1)				# Tamanho do objeto
						mv		a4,	s0				# Probabilidade guardada antes de createBlock
						mv		a5,	s1				# Outro n�mero pego antes de createBlock
						call		generateObject
						
						la		t0,	blockCurrent
						lbu		a0,	0(t0)				# Id do bloco atual
						la		t2,	lineDrawnCounter		
						lbu		a2,	0(t2)				# N�mero de linhas desenhadas do novo bloco
						li		a1,	20				# At� agora, todos os objetos criados aqui tem largura 20
						call		placeObject
						
						addi		t0,	s7,	16			# Endere�o de escrita salvo antes de generateObject, com offset..
						sh		a0,	0(t0)				# ..para acharmos o endere�o de objectPosX
						addi		t1,	s7,	18			# Endere�o de PosY
						sh		a1,	0(t1)	
						
	Update.objectListUpdate:		la		t0,	objectListWriteIdx		# Atualizando �ndice para usarmos o pr�ximo espa�o no vetor de objetos
						lbu		t1,	0(t0)
						addi		t1,	t1,	1
						li		t2,	6
						remu		t1,	t1,	t2			# �ndice dever estar sempre em [0,6]
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
						lbu		t1,	0(t0)				# Atualizamos o n�mero de blocos escritos
						addi		t1,	t1,	1
						li		t2,	16				# N�mero de blocos por sess�o
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
	
						la		s0,	shotCreate			# Endere�o da vari�vel de cria��o de tiro
						la		s1,	playerShotCD			# Endere�o do contador de espera
						lbu		t0,	0(s0)				# Vemos se h� tiro para criar
						lb		t1,	0(s1)				# Pegamos o contador
						beq		t0,	zero,	Player.CD.end		# Se for 1, temos que avaliar se o tiro pode ser criado ou se precisamos esperar
						beq		t1,	zero,	Player.CD.addCD		# Se o contador de espera estiver em zero, sem problemas		
						li		t0,	0
						sb		t0,	0(s0)				# Se n�o, cancelamos o tiro
						j		Player.CD.end
	Player.CD.addCD:			la		s2,	shotDelay			# Houve tiro, ent�o temos que come�ar o per�odo de espera
						lbu		t1,	0(s2)				# Pegamos o valor de espera da ROM													
						j		Player.CD.end.noAdjust																	
	Player.CD.end:				addi		t1,	t1,	-1			# Passou-se um frame, ent�o diminuimos em 1
						bge		t1,	zero,	Player.CD.end.noAdjust	# Se for maior que zero, est� OK
						li		t1,	0				# Se n�o, ajustamos
	Player.CD.end.noAdjust:			sb		t1,	0(s1)				# Guardamos o valor
	
	#####################
	# DESENHO E COLIS�O #
	#####################
	Player.render:				la		t0,	playerPosX			# Carregando X do jogador
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
							li		t2,	RVCL			# Transpar�ncia
							beq		t1,	t2,	drawObject.noDraw # Se a cor for igual a do rio, ent�o n�o pintamos							
							sb		t1,	0(t0)			# Desenhamos na tela
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
							beq		t1,	t5,	drawPlayerChkC.noDraw 	# Assim, ignoramos o teste de colis�o
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
	drawPlayerChkC.noDraw:				addi		a4,	a4,	1			# Passamos para o pr�ximo byte
	
							addi		t0,	t0,	1			# Pr�ximo endere�o de pintura
							addi		t6,	t6,	-1			# j--
							j		drawPlayerChkC.drawLine
							
	
	drawPlayerChkC.drawLineF:		beq		t6,	zero,	drawPlayerChkC.drawLineF.end # while (j > 0 )
							
							# CHECAGEM DE COLIS�O	
							lbu		t1,	0(a4)				# Pegamos o primeiro byte do bitmap do objeto
							li		t5,	RVCL				# Cor do rio (nessa rotina, ignoramos os bytes com essa cor para o prop�sito de colis�o
							beq		t1,	t5,	drawPlayerChkC.noDrawF 	# Assim, ignoramos o teste de colis�o
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
	drawPlayerChkC.noDrawF:				addi		a4,	a4,	-1		# Passamos para o pr�ximo byte
	
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
# Arg9: Endere�o da vari�vel de cria��o de tiro
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
					bne		t0,	t1,	getInputRars.testFire		# Testamos se � baixo
					la		t1,	scrollSpeedSlow				# Pegamos o valor da velocidade no n�vel r�pido
					lbu		t2,	0(t1)
					la		t1,	Arg8					# Pegamos o endere�o onde est� a velocidade de scroll da tela
					lw		t3,	0(t1)					#
					sb		t2,	0(t3)					# Atualizamos a velocidade
					sw		a5,	0(a7)
					j		getInputRars.end
					
	getInputRars.testFire:		li		t1,	M_FIRE
					bne		t0,	t1,	getInputRars.noMove		# Testamos se � tiro
					la		t1,	Arg9					
					lw		t2,	0(t1)					# Endere�o da vari�vel de cria��o de tiro
					li		t3,	1
					sb		t3,	0(t2)					# Colocamos 1 para pedir cria��o de tiro
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
					lw		t1, 0(a1)					# Pegamos o valor do eixo Y
					
					
					li		t1,	400					# Valor do deadzone em dire��o a zero
					bge		t0,	t1,	getInputStick.testXp		# Se for maior, o jogador n�o est� indo nessa dire��o
					# Vamos presumir que � a direita
					lhu		t2,	0(a3)					# Pegamos a posi��o X do jogador
					add		t2,	t2,	a2				# Atualizamos a posi��o
					sh		t2,	0(a3)					# Guardamos no endere�o certo
					li		t1,	0					# 0 = direita
					sb		t1,	0(a4)					# Atualizamos a dire��o
					sw		a6,	0(a7)					# Atualizamos o sprite
					j		getInputStick.testYm
					
	getInputStick.testXp:		li		t1,	3695					# Valor do deadzone em dire��o a 1023	
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
					li		t1,	400					# Valor do deadzone em dire��o a zero
					bge		t0,	t1,	getInputStick.testYp		# Se for maior, n�o est� indo nessa dire��o
					# Vamos presumir que � baixo
					la		t1,	scrollSpeedSlow				# Pegamos o valor da velocidade no n�vel r�pido
					lbu		t2,	0(t1)
					la		t1,	Arg8					# Pegamos o endere�o onde est� a velocidade de scroll da tela
					lw		t3,	0(t1)					#
					sb		t2,	0(t3)					# Atualizamos a velocidade
					sw		a5,	0(a7)					# Usa o sprite padr�o
					j		getInputStick.testButton
	
	getInputStick.testYp:		li		t1,	3695					# Deadzone em dire��o a 1023
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
					li		a1,	-6					# Y inicial padr�o para um objeto novo ("fora da tela")
					add		a1,	a1,	a2				# Ajuste necess�rio, sem ele o objetos novos seram colocados em posi��es erradas
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
# a0: Endere�o do frame 0
# a1: Endere�o do frame 1
# a2: Contador de frames para troca
# a3: N�mero para a troca
# Sa�das:
# a2: Contador de frames atualizado
# Tamb�m altera o conte�do dos endere�os a0 e a1
############################

animateObject:				beq		a3,	zero,	animateObject.end			# Se n�o for um objeto animado, n�o � feita a rotina
					addi		a2,	a2,	1
					bne		a2,	a3,	animateObject.end			# Se a2 != a3, ainda n�o � hora de atualizar o frame
					lw		t0,	0(a0)						# Salvamos o endere�o do frame anterior em t0 temporariamente
					lw		t1,	0(a1)						# Pegamos o endere�o do frame novo para sobreescrever
					sw		t1,	0(a0)						# Trocado
					sw		t0,	0(a1)						# Trocado tamb�m
					li		a2,	0						# Resetamos o contador						
	animateObject.end:		ret


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

###############################
# - Memcpy -
# Entradas.
# a0 : Endere�o de destino ;; a1 : Endere�o de origem ;; a2 : Tamanho em bytes
# Sa�das.
# a0 : Endere�o de destino
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
# Byte 00: Quantidade de blocos m�xima de terra, partindo da ponta
# Byte 01: Quantidade de blocos m�nima de rio
# Byte 02: Largura m�nima de abertura
# Byte 03: Probabilidade de gerar comb�stivel (1/x) (Na rotina, se o n�mero aleat�rio Mod x == 0, � fuel)
# Byte 04: �ndice m�ximo dos inimigos que podem aparecer (+1)
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
objectFuel: 	.word Fuel_f0		# 00 objectBitmapPtr0: .word # endere�o do frame 0	
		.word Fuel_f0		# 04 objectBitmapPtr1: .word # endere�o do frame 1	
		.word 0			# 08 objectCollision: .word # endere�o da rotina de colis�o	
		.word 0			# 12 objectAction: .word # endere�o de rotina especial	
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
		.byte 0			# 28 objectCollided: .byte # booleana de colis�o	
		.space 3

.align 2
# 01 - Helicopter
objectHeli:	.word Heli_f0		# 00 objectBitmapPtr0: .word # endere�o do frame 0	
		.word Heli_f1		# 04 objectBitmapPtr1: .word # endere�o do frame 1	
		.word 0			# 08 objectCollision: .word # endere�o da rotina de colis�o	
		.word 0			# 12 objectAction: .word # endere�o de rotina especial	
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
		.byte 0			# 28 objectCollided: .byte # booleana de colis�o	
		.space 3

.align 2
# 02 - Ship
objectShip:	.word Ship_f0		# 00 objectBitmapPtr0: .word # endere�o do frame 0	
		.word Ship_f0		# 04 objectBitmapPtr1: .word # endere�o do frame 1	
		.word 0			# 08 objectCollision: .word # endere�o da rotina de colis�o	
		.word 0			# 12 objectAction: .word # endere�o de rotina especial	
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
		.byte 0			# 28 objectCollided: .byte # booleana de colis�o	
		.space 3

.align 2
# 03 - Plane
objectPlane: 	.word Plane_f0		# 00 objectBitmapPtr0: .word # endere�o do frame 0	
		.word Plane_f0		# 04 objectBitmapPtr1: .word # endere�o do frame 1	
		.word 0			# 08 objectCollision: .word # endere�o da rotina de colis�o	
		.word 0			# 12 objectAction: .word # endere�o de rotina especial	
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
		.byte 0			# 28 objectCollided: .byte # booleana de colis�o	
		.space 3

.align 2
# 04 - Bad fuel
objectLeuf:	.word Leuf_f0		# 00 objectBitmapPtr0: .word # endere�o do frame 0	
		.word Leuf_f0		# 04 objectBitmapPtr1: .word # endere�o do frame 1	
		.word 0			# 08 objectCollision: .word # endere�o da rotina de colis�o	
		.word 0			# 12 objectAction: .word # endere�o de rotina especial	
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
		.byte 0			# 28 objectCollided: .byte # booleana de colis�o	
		.space 3

.align 2
# 97 - Explosion
objectExplo:    .word Leuf_f0		# 00 objectBitmapPtr0: .word # endere�o do frame 0	
		.word Leuf_f0		# 04 objectBitmapPtr1: .word # endere�o do frame 1	
		.word 0			# 08 objectCollision: .word # endere�o da rotina de colis�o	
		.word 0			# 12 objectAction: .word # endere�o de rotina especial	
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
		.byte 0			# 28 objectCollided: .byte # booleana de colis�o	
		.space 3

.align 2
# 98 - Empty
objectEmpty:	.word Leuf_f0		# 00 objectBitmapPtr0: .word # endere�o do frame 0	
		.word Leuf_f0		# 04 objectBitmapPtr1: .word # endere�o do frame 1	
		.word 0			# 08 objectCollision: .word # endere�o da rotina de colis�o	
		.word 0			# 12 objectAction: .word # endere�o de rotina especial	
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
		.byte 0			# 28 objectCollided: .byte # booleana de colis�o	
		.space 3

.align 2
# 99 - Bridge
objectBridge:	.word Bridg_f0		# 00 objectBitmapPtr0: .word # endere�o do frame 0	
		.word Bridg_f0		# 04 objectBitmapPtr1: .word # endere�o do frame 1	
		.word 0			# 08 objectCollision: .word # endere�o da rotina de colis�o	
		.word 0			# 12 objectAction: .word # endere�o de rotina especial	
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
		.byte 0			# 28 objectCollided: .byte # booleana de colis�o	
		.space 3

objectBridgeOffset: .byte 7

# Tiro
shotSize: 	.byte 20		# Tamanho de um tiro em bytes
shotMax:	.byte 20		# N�mero m�ximo de tiros
shotDelay:	.byte 2			# N�mero de frames que � preciso esperar para atirar de novo
shotXoffset:	.byte 9			# Aplicado para que o tiro saia do centro do player
.align 2
shotFormat:	.word Shot_f0		# 00 Endere�o do bitmap da imagem
		.half 0			# 04 Coordenada X
		.half 145		# 06 Coordenada Y
		.byte -12		# 08 Velocidade Y (Negativa, porque vai para o topo)
		.byte 6			# 09 Altura da imagem
		.byte 2			# 10 Largura da imagem
		.byte 1			# 11 Booleana de exist�ncia
		.byte 0			# 12 Booleana de colis�o		

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
