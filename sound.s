.text
#explosao 
#	li a0, 37		# define a nota
#	li a1, 1000		# define a duração da nota em ms
#	li a2, 127		# define o instrumento
#	li a3, 127		# define o volume
#	li a7, 33		# define o syscall
#	ecall			# toca a nota

#tiro 
#	li a0, 16		# define a nota
#	li a1, 500		# define a duração da nota em ms
#	li a2, 123		# define o instrumento
#	li a3, 127		# define o volume
#	li a7, 33		# define o syscall
#	ecall			# toca a nota

#objeto atingido
#	li a0, 39		# define a nota
#	li a1, 1000		# define a duração da nota em ms
#	li a2, 127		# define o instrumento
#	li a3, 127		# define o volume
#	li a7, 33		# define o syscall
#	ecall			# toca a nota

#voando acelerado
#	li a0, 127		# define a nota
#	li a1, 5000		# define a duração da nota em ms
#	li a2, 122		# define o instrumento
#	li a3, 127		# define o volume
#	li a7, 33		# define o syscall
#	ecall			# toca a nota

#voo normal
#	li a0, 20		# define a nota
#	li a1, 5000		# define a duração da nota em ms
#	li a2, 122		# define o instrumento
#	li a3, 127		# define o volume
#	li a7, 33		# define o syscall
#	ecall			# toca a nota

#voo lento
#	li a0, 0		# define a nota
#	li a1, 5000		# define a duração da nota em ms
#	li a2, 122		# define o instrumento
#	li a3, 127		# define o volume
#	li a7, 33		# define o syscall
#	ecall			# toca a nota	

#alerta de combustivel em baixa
#	li a0, 20		# define a nota
#	li a1, 3000		# define a duração da nota em ms
#	li a2, 124		# define o instrumento
#	li a3, 127		# define o volume
#	li a7, 33		# define o syscall
#	ecall			# toca a nota	

#som de recarga do combustivel
	li a0, 50		# define a nota
	li a1, 1500		# define a duração da nota em ms
	li a2, 124		# define o instrumento
	li a3, 127		# define o volume
	li a7, 33		# define o syscall
	ecall			# toca a nota	

#recarga com tanque cheio (eu achei zoado pq parece um telefone, mas eh o unico som q eu achei q toca e varias vezes em sequencia. qnt mais agudo, mais parece telefone)
#(acho q de 90 pra cima fica mto esquisito)
#	li a0, 60		# define a nota
#	li a1, 1500		# define a duração da nota em ms
#	li a2, 124		# define o instrumento
#	li a3, 127		# define o volume
#	li a7, 33		# define o syscall
#	ecall			# toca a nota	

#se quiser testar um de cada vez, basta olhar os valores e setar eles aqui. se quiser testar todos em sequencia, é só tirar os '#'
#	li a0, 60		# define a nota
#	li a1, 1500		# define a duração da nota em ms
#	li a2, 124		# define o instrumento
#	li a3, 127		# define o volume
#	li a7, 33		# define o syscall
#	ecall			# toca a nota
	
	li a7,10		# define o syscall Exit
	ecall			# exit
