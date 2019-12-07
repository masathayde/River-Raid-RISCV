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
	
	nextSound: .byte 0				# Variável que controla qual som será tocado a seguir
	
	
	
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
	playerFuel: .half INITIAL_FUEL
	playerPosX: .half PLAYER_INITIAL_X
	playerLives: .byte INITIAL_LIVES
	playerPosY: .byte 155 # Normalmente, não deve mudar
	playerDirection: .byte 0 # Usado para decidir se haverá flip no sprite
	playerShotCount: .byte 0 # Contador de tiros
	playerCollision: .byte 0 # 0 - sem colisão; 1 - colisão com algo que destrói ; 2 - colisão com fuel ; 3 - colisão com bad fuel
	playerSpeedX: .byte 4 # Velocidade em pixels/frame
	playerShotCD: .byte 0 # Número de frames a esperar para atirar de novo
	playerCrashed: .byte 0 # Usada para rotina de perda de vida
                                                                                                      
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
