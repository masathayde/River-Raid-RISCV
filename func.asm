.eqv VGAADDRESSINI0     0xFF000000
.eqv VGAADDRESSFIM0     0xFF012C00
.eqv VGAADDRESSINI1     0xFF100000
.eqv VGAADDRESSFIM1     0xFF112C00 

# 20 pixels por seção vertical
.eqv SECV 20
.eqv SECH 40
.eqv OUTER 6
.eqv INNER 0

.eqv SOILCOLOR 0xFF
.eqv WATERCOLOR 0x33

.data

.text

test.drawPixel:				li		a0,	160
					li		a1,	120
					li		a2,	0x0FF
					call		drawPixel
					
					li		a7,	10
					ecall

# - Draw Pixel - Pinta um pixel na tela usando um par de coordenadas (x,y)
# Entradas.
# a0: Coordenada X ;; a1: Coordenada Y ;; a2: Cor do pixel (byte)
# Saidas.
# 
drawPixel:				li		t0,	VGAADDRESSINI0			# Endereço do display
					li		t1,	320				# Largura da tela
					mul		t1,	t1,	a1			# t1 = y * 320
					add		t1,	t1,	a0			# t1 += x
					add		t0,	t0,	t1			# Juntamos tudo para ter o endereço correto
					sb		a2,	(t0)				# Colocamos o valor da cor no endereço
					ret
					

drawSection:					