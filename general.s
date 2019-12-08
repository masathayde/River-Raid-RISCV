.text
#############################
# Toca um som tirado da tabela			
# a0: Endereço da tabela
# a1: Número do som
############################
# Cada som é composto por 4 words, então o offset é 16 bytes
playSound:				bne		a1,	zero,	playSound.regular		# Se for zero, nenhum som novo é tocado
					li		a1,	5
	playSound.regular:		addi		a1,	a1,	-1				# Som 1 -> Offset zero, porque soundSelect em zero significa nenhum som
					li		t0,	16
					mul		t0,	t0,	a1				# Cálculo do offset
					add		t1,	a0,	t0				# Aplicando offset
					lw		a0,	0(t1)					# Nota
					lw		a1,	4(t1)					# Duração
					lw		a2,	8(t1)					# Instrumento
					lw		a3,	12(t1)					# Volume
					li		a7,	31					# ecall MidiOUT
					ecall
	playSound.end:			ret
	
#############################
# Seleciona qual som tem maior prioridade no frame			
# a0: Número do som a avaliar
############################
soundSelect:				beq		a0,	zero,	soundSelect.nop			# Se o novo som == 0, ignora-se a rotina
					la		t0,	nextSound				# Endereço onde está o som
					lbu		t1,	0(t0)					# Pega o valor
					beq		t1,	zero,	soundSelect.newSound		# Se o som atual for 0, só troca o valor de nextSound
					ble		a0,	t1,	soundSelect.newSound		# Se o número do som for menor, ele tem prioridade	
					mv		a0,	t1					# Mantemos o som anterior
	soundSelect.newSound:		sb		a0,	0(t0)					# Novo som colocado
	soundSelect.nop:		ret
###############################
# - Memcpy -
# Entradas.
# a0 : Endereço de destino ;; a1 : Endereço de origem ;; a2 : Tamanho em bytes
# Saídas.
# a0 : Endereço de destino
###############################
memcpy:					mv 		t0,	zero
					mv		t6,	a0
	memcpy.L1:			beq		t0,	a2,	memcpy.L1.end
		
						lbu		t1,	(a1)
						sb		t1,	(t6)
						addi		t0, 	t0,	1
						addi		t6,	t6,	1
						addi		a1,	a1,	1
						j		memcpy.L1
							
	memcpy.L1.end:			ret
