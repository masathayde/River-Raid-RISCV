	li a0, 67		# define a nota
	li a1, 500		# define a duração da nota em ms
	li a2, 127		# define o instrumento
	li a3, 100		# define o volume
	li a7, 33		# define o syscall
	ecall		# define o syscall
	
	li	a7,	10
	ecall	
