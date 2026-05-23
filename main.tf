# 1. Creamos el Security Group
resource "aws_security_group" "mi_servidor_sg" {
  name        = "servidor-web-sg"
  description = "Permitir trafico web y SSH restringido"

  # Tráfico de Entrada
  ingress {
    description = "Permitir HTTP desde cualquier lugar"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"] 
  }

  ingress {
    description = "Permitir SSH SOLO desde la IP de la oficina/VPN"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    # ¡CERO DEUDA TÉCNICA AQUI! Cambia esto por la IP pública real de tu equipo
    cidr_blocks = ["203.0.113.50/32"] 
  }

  # Egress = Tráfico de Salida
  egress {
    description = "Permitir que el servidor salga a internet (ej. para descargar updates)"
    from_port   = 0
    to_port     = 0
    protocol    = "-1" # El -1 significa "todos los protocolos"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# 2. Creamos el servidor
resource "aws_instance" "mi_servidor" {
  ami           = "ami-0c7217cdde317cfec" # Ubuntu Server 22.04 LTS en us-east-1
  instance_type = "t2.micro"              # Capa Gratuita (Free Tier)

  # Aquí le pegamos el Security Group que creamos arriba
  vpc_security_group_ids = [aws_security_group.mi_servidor_sg.id]

  tags = {
    Name = "Servidor-Desarrollo-01"
  }
}