# Agregando várias rotinas e instruções usados na rotina principal para deixar o código mais compacto

#############################################
# Combina várias rotinas para geração de um objeto
# a0: Valor de Y desejado para o novo objeto
#############################################
setupGenerateObject:				addi		sp,	sp,	-20
						sw		ra,	0(sp)
						sw		s0,	4(sp)
						sw		s1,	8(sp)
						sw		s7,	12(sp)
						sw		s8	16(sp)
						mv		s8,	a0				# Salvando o valor de Y desejado
										
						la		t0,	DifficultyTable			# Endereço da tabela de dificuldade
						lbu		s0,	3(t0)				# Probabilidade	de fuel, para a próxima rotina
						lbu		s1,	4(t0)				# Índice máximo dos inimigos, para a próxima rotina				
						la		t6,	objectPtrList			# Lista de ponteiros para objetos 0 a 6
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
						mv		a3,	s8				# Usando o valor de Y salvo antes
						call		placeObject
						
						addi		t0,	s7,	16			# Endereço de escrita salvo antes de generateObject, com offset..
						sh		a0,	0(t0)				# ..para acharmos o endereço de objectPosX
						addi		t1,	s7,	18			# Endereço de PosY
						sh		a1,	0(t1)	
						
						la		t0,	objectListWriteIdx		# Atualizando índice para usarmos o próximo espaço no vetor de objetos
						lbu		t1,	0(t0)
						addi		t1,	t1,	1
						li		t2,	6
						remu		t1,	t1,	t2			# Índice dever estar sempre em [0,6]
						sb		t1,	0(t0)				# Atualizado
						
						
						lw		ra,	0(sp)
						lw		s0,	4(sp)
						lw		s1,	8(sp)
						lw		s7,	12(sp)
						lw		s8,	16(sp)
						addi		sp,	sp,	20
						ret
						
#################################################
# Combina várias rotinas para geração de um bloco
# a0: Valor do ID. Se a0 = 0, cria um bloco aleatório baseado na dificuldade
#################################################
setupCreateBlock:				addi		sp,	sp,	-4
						sw		ra,	0(sp)
						
						beq		a0,	zero,	setupCreateBlock.random # Se não for zero, usamos o valor de a0 para o novo bloco
						la		t0,	blockCurrent
						sb		a0,	0(t0)
						j		setupCreateBlock.w2Playfield
	setupCreateBlock.random:		la		a0,	blockCurrent			# Geração do bloco novo
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
					
	setupCreateBlock.w2Playfield:		la		a0,	playfield
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
						
						lw		ra,	0(sp)
						addi		sp,	sp,	4
						ret