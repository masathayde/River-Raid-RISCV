.eqv VGAADDRESSINI0     0xFF000000
.eqv VGAADDRESSFIM0     0xFF012C00

.data
str.frequencia: .string "Frequencia = "
str.ciclos: .string "Ciclos = "
str.inst: .string "Instrucoes = "
str.tempoMedido: .string "Tempo medido (ms) = "
str.cpiMedia: .string "CPI media = "
str.tempoCalc: .string "Tempo calculado (s) = "


.text
	la tp,exceptionHandling	# carrega em tp o endereço base das rotinas do sistema ECALL
 	csrrw zero,5,tp 	# seta utvec (reg 5) para o endereço tp
 	csrrsi zero,0,1 	# seta o bit de habilitação de interrupção em ustatus (reg 0)

	# Antes de chamar preenche, guardamos o número de ciclos, instruções e tempo até agora.
	csrr		s0,	3072		# Ciclo Low
	csrr		s1,	3200		# Ciclo High
	
	# No RARS, usamos o ecall 30
	li		a7,	30
	ecall
	mv		s2,	a0		# Tempo Low
	mv		s3,	a1		# Tempo High
	# No FPGA, usamos os registradores de controle
	#csrr		s2,	3073
	#csrr		s3,	3201
		
	csrr		s4,	3074		# Inst Low
	csrr		s5,	3202		# Inst High


	li		t0,	VGAADDRESSINI0
	li		t1,	VGAADDRESSFIM0
	li		t2,	0xFFFFFFFF
	
B:	beq		t0,	t1,	E
	sw		t2	0(t0)
	addi		t0,	t0,	4
	j		B
	
E:	# Pegamos os novos tempos
	csrr		t0,	3072		# Ciclo Low
	csrr		t1,	3200		# Ciclo High
	
	# No RARS, usamos o ecall 30
	li		a7,	30
	ecall
	mv		t2,	a0		# Tempo Low
	mv		t3,	a1		# Tempo High
	# No FPGA, usamos os registradores de controle
	#csrr		t2,	3073
	#csrr		t3,	3201
	
	
	csrr		t4,	3074		# Inst Low
	csrr		t5,	3202		# Inst High

	sub		s0,	t0,	s0
	sub		s1,	t1,	s1
	sub		s2,	t2,	s2
	sub		s3,	t3,	s3
	sub		s4,	t4,	s4
	sub		s5,	t5,	s5
	
	
	# Printar frequencia
	la		a0,	str.frequencia
	li		a1,	0
	li		a2,	0
	li		a3,	0x038
	li		a4,	1
	li		a7,	104
	ecall
	
	divu		s9,	s0,	s2		# salvando freq para uso depois
	li		t0,	1000
	mul		s9,	s9,	t0
	mv		a0,	s9
	li		a1,	160
	li		a2,	0
	li		a3,	0x038
	li		a4,	1
	li		a7,	136
	ecall

	# Printar ciclos
	la		a0,	str.ciclos
	li		a1,	0
	li		a2,	15
	li		a3,	0x038
	li		a4,	1
	li		a7,	104
	ecall
	
	mv		a0,	s1
	li		a1,	70
	li		a2,	15
	li		a7,	136
	ecall
	
	mv		a0,	s0
	li		a1,	140
	li		a2,	15
	li		a7,	136
	ecall
	
	# Printar instrucoes
	la		a0,	str.inst
	li		a1,	0
	li		a2,	30
	li		a3,	0x038
	li		a4,	1
	li		a7,	104
	ecall
	
	mv		a0,	s5
	li		a1,	100
	li		a2,	30
	li		a7,	136
	ecall
	
	mv		a0,	s4
	li		a1,	170
	li		a2,	30
	li		a7,	136
	ecall
	
	# Printar tempo medido
	la		a0,	str.tempoMedido
	li		a1,	0
	li		a2,	45
	li		a3,	0x038
	li		a4,	1
	li		a7,	104
	ecall
	
	mv		a0,	s3
	li		a1,	160
	li		a2,	45
	li		a7,	136
	ecall
	
	mv		a0,	s2
	li		a1,	230
	li		a2,	45
	li		a7,	136
	ecall
	
	# Printar CPI media
	la		a0,	str.cpiMedia
	li		a1,	0
	li		a2,	60
	li		a3,	0x038
	li		a4,	1
	li		a7,	104
	ecall
	
	# Conversao para o calculo seguinte
	fcvt.s.wu	ft0,	s0
	fcvt.s.wu	ft4,	s4
	fdiv.s		fs0,	ft0,	ft4		# Ciclos Low dividido por Inst Low
	
	fmv.s		fa0,	fs0
	li		a1,	160
	li		a2,	60
	li		a7,	102
	ecall

	# Printar Tempo calculado
	la		a0,	str.tempoCalc
	li		a1,	0
	li		a2,	75
	li		a3,	0x038
	li		a4,	1
	li		a7,	104
	ecall
	
	# CPI ainda deve estar em fs0, periodo do clock e_ hardcoded, pegamos instrucoes Low de s4 e convertemos para float
	#li		t0,	0x37A7C5AC 	# (0,00002) 50 MHz
	#divu		t0,	s2,	s0	# Periodo
	li		t0,	1
	fcvt.s.wu	ft0,	t0
	fcvt.s.wu	ft1,	s9
	fcvt.s.wu	ft2,	s4
	fdiv.s		ft0,	ft0,	ft1
	fmul.s		ft0,	ft0,	fs0
	fmul.s		fa0,	ft0,	ft2
	
	
	li		a1,	180
	li		a2,	75
	li		a7,	102
	ecall









	li		a7,	10
	ecall

.include "SYSTEMv17.s"