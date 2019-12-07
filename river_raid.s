# Cores devem ser repetidas 4 vezes na word
.eqv BANK_COLOR_4 0x10101010 										# Cor da costa, deve ser verde
.eqv RIVER_COLOR_4 0xb0b0b0b0 										# Cor do rio, azul
.eqv SCORE_COLOR_4 0x65656565
.eqv SCORE_DIV_4 0x00000000
.eqv INFO_COLOR 0x00006500	# Cor de background deve ser igual a Score_color
.eqv SCRNUM_COLOR 0x000065da

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
.eqv EXPL 0xb6 # explosion color
.eqv PLYR 0xFF # Player color
.eqv SHOT 0xFF # Shot color

.eqv M_LEFT 97 # a
.eqv M_RIGHT 100 # d
.eqv M_UP 119 # w
.eqv M_DOWN 115 # s
.eqv M_FIRE 101 # e

.eqv MAX_BANK_SIZE 7
.eqv MAX_DIFFICULTY 10
.eqv PLAYER_HEIGHT 20
.eqv PLAYER_WIDTH 20											
.eqv PLAYER_MAX_MISSILE 20   # Número máximo de tiros na tela
.eqv PLAYER_MISSILE DELAY 15 # Quanto tempo deve-se esperar para poder atirar de novo (em ciclos)
.eqv PLAYER_SPEED_X 2 # Quantos pixels o jogador se move por ciclo quando é controlado
.eqv INITIAL_LIVES 4
.eqv INITIAL_FUEL 200

.eqv TIMESTEP 33 # Em ms

.eqv VGAADDRESSINI0     0xFF000000
.eqv VGAADDRESSFIM0     0xFF012C00
.eqv VGAADDRESSINI1     0xFF100000
.eqv VGAADDRESSFIM1     0xFF112C00 
.eqv VGAFRAMESELECT	0xFF200604

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
#
# 	Resetando todos as variáveis para reínicio do jogo. Estas variáveis só são resetadas quando um novo jogo é iniciado no menu principal.

	NewGameSetup:			la		t0,	gameLevel
					li		t1,	1
					sw		t1,	0(t0)
					la		t2,	difficulty
					sw		zero,	0(t2)
					la		t3,	playerScore
					sw		zero,	0(t3)	
					la		t4,	playerLives
					li		t5,	INITIAL_LIVES
					sb		t5,	0(t4)


	InitSetup:			
# ______ _____ _____ _____ _____ 
# | ___ \  ___/  ___|  ___|_   _|
# | |_/ / |__ \ `--.| |__   | |  
# |    /|  __| `--. \  __|  | |  
# | |\ \| |___/\__/ / |___  | |  
# \_| \_\____/\____/\____/  \_/  
#	
#	Resetando todos as variáveis para reínicio do jogo. Estas variáveis sempre são resetadas depois de uma perda de vida.

					# JOGADOR #										
					la		t0,	playerCrrSpr				
					la		t1,	Plyr_0					# Sprite do jogador padrão
					sw		t1,	0(t0)					# Salvando no espaço correto
					la		t2,	playerPosX
					li		t3,	120					# Coordenada X padrão do jogador
					sh		t3,	0(t2)
					la		t0,	playerDirection
					sb		zero,	0(t0)
					la		t1,	playerShotCount
					sb		zero,	0(t1)
					la		t2,	playerCollision
					sb		zero,	0(t2)
					la		t3,	playerShotCD
					sb		zero,	0(t3)
					la		t4,	playerCrashed
					sb		zero,	0(t4)
					la		t5,	playerFuel
					li		t6,	INITIAL_FUEL
					sb		t6,	0(t5)
					
					# PLAYFIELD #
					la		t0,	pfWriteOffset
					sb		zero,	0(t0)
					la		t1,	pfReadStartOffset
					li		t2,	160					# Offset de leitura padrão
					sb		t2,	0(t1)
					la		t3,	blockCounter
					sb		zero,	0(t3)
					
					# OBJETOS #
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
					
					# TIROS #
					la		t0,	shotCreate
					sb		zero,	0(t0)
					la		t1,	shotWriteIdx
					sb		zero,	0(t1)
					la		t6,	shotVector
					li		t0,	100					# Tamanho do vetor de tiros, em words
	Reset.shotVector:		beq		t0,	zero,	Reset.shotVector.end
							
						sw		zero,	0(t6)
						addi		t0,	t0,	-1
						addi		t6,	t6,	4
						j		Reset.shotVector
	Reset.shotVector.end:
					
			
					la		t0,	nextSound
					sb		zero,	0(t0)
					la		t1,	blockWriteOffset
					sb		zero,	0(t1)
					la		t2,	lineDrawnCounter
					sb		zero,	0(t2)
					


	# Os primeiros blocos são sempre neutros #
					li		s0,	5					# i = 5
	InitSetup.genMap.0:		beq		s0,	zero,	InitSetup.genMap.0.end		# (while i > 0)
						
						la		t0,	blockCurrent
						li		t1,	0x07				# Um bloco ponte
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
							addi		a7,	s2,	28		# Endereço da booleana de colisão
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
				
	########################
	# DESENHO DE OBJETOS 2 #
	########################
	# De novo? Infelizmente.
	# Maneira mais fácil que eu encontrei para que tiros e objetos se detectem no mesmo frame corretamente.
	
						li		s0,	0				# s0 = i
						li		s1,	6
						la		s2,	object0				# Endereço do primeiro objeto
						la		t0,	objectSize			
						lbu		s3,	0(t0)				# Tamanho dos objetos, para cálculo de offset
	Render.drawObjects2:			beq		s0,	s1,	Render.drawObjects2.end	# Para cada um dos objetos
						
							lw		t0,	0(s2)
							beq		t0,	zero,	Render.drawObjects2.empty # Não desenhamos se ainda não foi escrito
							
							lhu		a0,	16(s2)			# Coordenada X aqui
							lh		a1,	18(s2)			# Coordenada Y aqui
							lbu		a2,	23(s2)			# Altura do objeto
							lbu		a3,	24(s2)			# Largura do objeto
							lw		a4,	0(s2)			# Endereço do bitmap do objeto
							lbu		a6,	25(s2)			# Direção do objeto
							la		t0,	framePtr
							lw		a5,	0(t0)			# Endereço do VGA
							addi		a7,	s2,	28		# Endereço da booleana de colisão
							call		drawObject
	Render.drawObjects2.empty:			addi		s0,	s0,	1		# ++i
							add		s2,	s2,	s3		# Object[] + 1
							j		Render.drawObjects2
	Render.drawObjects2.end:
	
	###############
	# INFORMAÇÕES #
	###############
	# Combústivel restante, vidas, score
							# Printando combústivel com o ecall
							la		a0,	fuelString
							li		a1,	20
							li		a2,	170
							li		a3,	INFO_COLOR
							la		t0,	frameToShow
							lbu		a4,	0(t0)
							li		a7,	104
							ecall							
							la		t0,	playerFuel
							lbu		a0,	0(t0)
							li		a1,	70
							li		a2,	170
							li		a3,	INFO_COLOR
							la		t0,	frameToShow
							lbu		a4,	0(t0)
							li		a7,	136
							ecall
							la		a0,	fuelString2
							li		a1,	97
							li		a2,	170
							li		a3,	INFO_COLOR
							la		t0,	frameToShow
							lbu		a4,	0(t0)
							li		a7,	104
							ecall	
							
							# Printando o número de vidas												
							la		a0,	livesString
							li		a1,	20
							li		a2,	190
							li		a3,	INFO_COLOR
							la		t0,	frameToShow
							lbu		a4,	0(t0)
							li		a7,	104
							ecall
							la		t0,	playerLives
							lbu		a0,	0(t0)
							li		a1,	70
							li		a2,	190
							li		a3,	INFO_COLOR
							la		t0,	frameToShow
							lbu		a4,	0(t0)
							li		a7,	136
							ecall
							
							# Printando a pontuação
							la		t0,	playerScore
							lbu		a0,	0(t0)
							li		a1,	230
							li		a2,	170
							li		a3,	SCRNUM_COLOR
							la		t0,	frameToShow
							lbu		a4,	0(t0)
							li		a7,	136
							ecall						
########################################
#  _   _____________  ___ _____ _____ 
# | | | | ___ \  _  \/ _ \_   _|  ___|
# | | | | |_/ / | | / /_\ \| | | |__  
# | | | |  __/| | | |  _  || | |  __| 
# | |_| | |   | |/ /| | | || | | |___ 
#  \___/\_|   |___/ \_| |_/\_/ \____/ 
########################################        

	#######################
	# DETECÇÃO DE DERROTA #
	#######################
	
						la		t0,	playerCrashed
						lbu		t1,	0(t0)				# Checagem de booleana de derrota
						beq		t1,	zero,	Update.noCrash
						call		defeatHandler
	
	Update.noCrash:
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
						
						# Som - toda vez que criar um tiro, pedir para tocar o som
						li		a0,	2
						call		soundSelect				# Tocamos o som de tiro						
									
						
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
							lw		a4,	12(s2)			# Endereço de rotina especial
							call		animateObject
							sb		a2,	26(s2)			# Atualizando o contador
							
						#########################
						# TRATAMENTO DE COLISÃO #	
						#########################
						
							mv		a0,	s2			# Endereço do objeto
							la		a1,	objectExplo		# Endereço do objeto que substituirá
							la		t0,	objectSize		# Tamanho do objeto
							lbu		a2,	0(t0)
							addi		a3,	s2,	28		# Endereço da booleana de colisão
							lbu		s5,	28(s2)			# Armazenamos aqui para usar no teste de criação de som
							addi		a4,	s2,	16		# Endereço da posição X
							addi		a5,	s2,	18		# Endereço da posição Y
							addi		a6,	s2,	20		# Endereço do tipo de objeto
							call		objectColHandler
							beq		s5,	zero,	Update.objectUpdate.nope # Se houver colisão, tocamos som
							li		a0,	1
							call		soundSelect							
										
							
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
						la		t0, 	Arg9
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
						
						la		t0,	playerCollision
						lbu		a0,	0(t0)				# Booleana de colisão
						la		a1,	playerFuel			# Endereço do valor de combústivel atual
						call		playerColHandler
						li		t0,	1
						bne		a0,	t0,	Player.noCrash		# Se houver colisão, setamos uma booleana
						la		t1,	playerCrashed
						sb		t0,	0(t1)				# Setada
	Player.noCrash:				mv		a0,	a1
						call		soundSelect				# Rotina decide se o som irá tocar			
	###############
	# COMBÚSTIVEL #
	###############
						la		t0,	playerFuel			# Endereço onde está a quantidade de combústivel
						lbu		s1,	0(t0)				# Pegamos o valor
						la		t2,	fuelMax				# Quantidade máxima de combústivel
						lbu		t3,	0(t2)
						ble		s1,	t3,	Player.fuel.noAdjust	# Se o combústivel estiver acima do normal, ajustamos
						mv		s1,	t3				# Limitado à quantidade máxima
	Player.fuel.noAdjust:			la		t2,	fuelLossRate			# Taxa de perda de combústivel
						lbu		t3,	0(t2)				# Pegamos esse valor também
						sub		s1,	s1,	t3			# Atualizamos a quantidade
						bgt		s1,	zero,	Player.fuel.bge0	# Se cair abaixo de 0, é derrota
						li		s1,	0
						la		t2,	playerCrashed
						li		t3,	1
						sb		t3,	0(t2)				# Setamos a booleana de derrota
						mv		a0,	t3
						call		soundSelect					
	Player.fuel.bge0:			sb		s1,	0(t0)				# Salvamos quantidade atualizada																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																			
##########################																		
#  _____  ________  ___
# /  ___||  _  |  \/  |
# \ `--. | | | | .  . |
#  `--. \| | | | |\/| |
# /\__/ /\ \_/ / |  | |
# \____/  \___/\_|  |_/
##########################                   
      Sound.start:               				
                     				
                     				la		t0,	nextSound			# Endereço de seleção de som
                     				lbu		t1,	0(t0)				# Pegamos o som
						beq		t1,	zero,	Sound.end		# Se for zero, não tocamos nada
						la		a0,	Sound1				# Primeiro som da tabela
						mv		a1,	t1
						call		playSound
						
	Sound.end:				la		t0,	nextSound
						sb		zero,	0(t0)				# Ao final de cada frame, resetamos o valor de soundSelect			

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
					

#############################
# Rotina de derrota			
# a0: Endereço da tabela
############################			
# Usaremos variáveis globais
# Presume que o playfied, inimigos e tudo mais já tenha sido pintado, exceto o jogador

defeatHandler:					la		t0,	playerPosX			# Pinta uma explosão na posição do jogador
						lh		a0,	0(t0)
						la		t1,	playerPosY
						lbu		a1,	0(t1)
						li		a2,	20				# Número mágico (altura da explosão)			
						li		a3,	20				# Número mágico (largura da explosão)
						la		a4,	Expl_f0				# Endereço do bitmap da explosão
						li		a6,	0
						la		t0,	framePtr
						lw		a5,	0(t0)				# Endereço do VGA
						la		a7,	playerCollision			# Endereço da booleana de colisão (não vai ser usada)
						call		drawObject
							
						la		t0,	frameToShow			# Terminamos de desenhar, então mostramos o frame
						lbu		t1,	0(t0)
						li		t0,	VGAFRAMESELECT
						sb		t1,	0(t0)
								
						li		a0,	2000
						li		a7,	32
						ecall							# Esperamos 2 segundos
							
						la		t0,	frameToShow			# Trocamos de frame
						la		t2,	framePtr			# Ponteiro para o frame no qual será desenhado o mapa
						lbu		t1,	0(t0)
						xori		t1,	t1,	1			# O uso de xor inverte o bit
						sb		t1,	0(t0)				# Guardamos o valor de volta em frameToShow
						li		t3,	VGAADDRESSINI0			# Inicialmente escolhemos o frame 0
						beq		t1,	zero,	defeatHandler.selectF0	# Mas é realmente o frame 0?
						li		t3,	VGAADDRESSINI1			# Não, então escolhe-se frame 1						
	defeatHandler.selectF0:			sw		t3,	0(t2)				# Salvar em framePtr
							
							
						la		t0,	framePtr
						lw		t1,	0(t0)				# Endereço de pintura
						li		t6,	19200				# Número de words para pintar
	defeatHandler.blackout:			beq		t6,	zero,	defeatHandler.blackout.end						
	
							li		t2,	0			# Cor preta
							sw		t2,	0(t1)			# Pintando
							addi		t1,	t1,	4		# Próxima word
							addi		t6,	t6,	-1		# i--
							j		defeatHandler.blackout
							
													
																			
					# Agora vemos se foi game over ou não																									
	defeatHandler.blackout.end:		la		t0,	playerLives
						lb		t1,	0(t0)				# Número de vidas restante
						addi		t1,	t1,	-1			# Perde-se uma
						bge		zero,	t1,	defeatHandler.gameOver	# Se for <= 0, game over
						sb		t1,	0(t0)				# Salva novo número de vidas
						la		a0,	readyString
						li		a1,	135				# Coordenada X de escrita
						li		a2,	100				# Coordenada Y
						li		a3,	0x00ff				# Cor
						la		t0,	frameToShow
						lbu		a4,	0(t0)
						li		a7,	104
						ecall							# Printa mensagem de alerta na tela
						#ebreak
						la		t0,	frameToShow			# Terminamos de desenhar, então mostramos o frame
						lbu		t1,	0(t0)
						li		t0,	VGAFRAMESELECT
						sb		t1,	0(t0)

						li		a0,	2000
						li		a7,	32
						ecall							# Esperamos mais 2 segundos antes de voltar ao jogo
						
						j		InitSetup
						
						
	defeatHandler.gameOver: li a7, 10
				ecall # placeholder						
	
							
#######################
# Includes
#######################

.include "memory.s"
.include "playfield.s"
.include "player.s"
.include "shot.s"
.include "objects.s"
.include "general.s"
.include "rom.s"
.include "SYSTEMv17.s"
