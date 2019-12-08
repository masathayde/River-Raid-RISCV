	li a0,48		# define a nota
	li a1, 300		# define a duração da nota em ms
	li a2, 9		# define o instrumento
	li a3, 60		# define o volume
	li a7, 33		# define o syscall
	ecall		# define o syscall

	
	li	a7,	10
	ecall	
