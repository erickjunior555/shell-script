#!/bin/bash
PURPLE='0;35'
NC='\033[0m' 
VERSAO=11
echo "$(tput setaf 10)[ControlTec]:$(tput setaf 7) Bem vindo a ControlTec!"
echo ""
sleep 2
echo "$(tput setaf 10)[ControlTec]:$(tput setaf 7) Olá, eu sou o ControlBot e te ajudarei na instalação!;"
sleep 2
echo "$(tput setaf 10)[ControlTec]:$(tput setaf 7) Primeira, vou checar se você já tem o que é necessario....;"
sleep 2
echo "$(tput setaf 10)[ControlTec]:$(tput setaf 7) Verificando se o Java está instalado...;"
sleep 2

java --version
if [ $? -eq 0 ]
	then
		echo "$(tput setaf 10)[ControlTec]:$(tput setaf 7) Você já tem o java instalado!!"
		sleep 2
	else
		echo "$(tput setaf 10)[ControlTec]:$(tput setaf 7) Nenhuma versão do java encontrada, vou resolver isso!"
		sleep 2
		echo "$(tput setaf 10)[ControlTec]:$(tput setaf 7) Adicionando o repositório!"
			sleep 2
			sudo add-apt-repository ppa:webupd8team/java -y
			clear
			echo "$(tput setaf 10)[ControlTec]:$(tput setaf 7) Atualizandooooooo, vai ser rapido."
			sleep 2
			sudo apt update -y
			clear
			
		if [ $VERSAO -eq 11 ]
			then
				echo "$(tput setaf 10)[ControlTec]:$(tput setaf 7) A versão 11 do java será solicitada a ser instalada, confirme quando for pedido"
				sleep 1
				sudo apt install default-jre ; apt install openjdk-11-jre-headless; -y
				clear
				echo "$(tput setaf 10)[ControlTec]:$(tput setaf 7) Java instalado com sucesso!"
				sleep 3
				clear
		fi
fi

echo  "$(tput setaf 10)[ControlTec]:$(tput setaf 7) Instalando o compactador de arquivos ZIP...;"
sleep 2
echo "$(tput setaf 10)[ControlTec]:$(tput setaf 7) Adicionando o repositório!"
		sleep 2
		sudo apt install zip
		clear
		echo "$(tput setaf 10)[ControlTec]:$(tput setaf 7) Atualizando Pacotes! Quase lá."
		sleep 2
		sudo apt update -y
		clear
		echo "$(tput setaf 10)[ControlTec]:$(tput setaf 7) ZIP instalado com sucesso!"
		sleep 3
		clear

echo "$(tput setaf 10)[ControlTec]:$(tput setaf 7) Sua instância está pronta para instalar a aplicação da ControlTec!"
sleep 2
echo "$(tput setaf 10)[ControlTec]:$(tput setaf 7) Confirme a instalação da aplicação (Y/n)?"		
read inst
if [ \"$inst\" == \"Y\" ]
	then
		echo "$(tput setaf 10)[ControlTec]:$(tput setaf 7) Ok! Você escolheu instalar a aplicação."
		sleep 2
		echo "$(tput setaf 10)[ControlTec]:$(tput setaf 7) Clonando o repositório!"
		sleep 2
		cd ~ 
		mkdir control-tec
		cd ~/control-tec
		git clone https://github.com/Luiz0809/ControlTecApp.git
		sleep 2
		clear
		echo "$(tput setaf 10)[ControlTec]:$(tput setaf 7) Aplicação instalada com sucesso!"
		sleep 3
		clear
	else 	
		echo "$(tput setaf 10)[ControlTec]:$(tput setaf 7) Você optou por não instalar a aplicação, nada será feito, adiossss."
		sleep 3
		clear
fi

echo  "$(tput setaf 10)[ControlTec]:$(tput setaf 7) Verificando se o docker está instalado...;"
sleep 2

docker --version
if [ $? -eq 0 ]
	then
		echo "$(tput setaf 10)[ControlTec]:$(tput setaf 7)  Encontrei o docker, vou dar continuidade"
		sleep 2
	else
		echo "$(tput setaf 10)[ControlTec]:$(tput setaf 7) Nenhuma versão do docker encontrada, vou resolver isso !"
		sleep 2
		echo "$(tput setaf 10)[ControlTec]:$(tput setaf 7) Adicionando o repositório!"
		sleep 2
		sudo apt install docker.io 
		echo "$(tput setaf 10)[ControlTec]:$(tput setaf 7) Iniciando o container!"
		sleep 2
		sudo systemctl start docker 
		sudo systemctl enable docker
		sleep 2
		clear
		echo "$(tput setaf 10)[ControlTec]:$(tput setaf 7) Docker instalado com sucesso!"
		sleep 3
		clear
fi

echo  "$(tput setaf 10)[ControlTec]:$(tput setaf 7) Instalando o mysql no container..."
sudo docker pull mysql:5.7 
sleep 2
clear
echo "$(tput setaf 10)[ControlTec]:$(tput setaf 7) Executando o container!"
sudo docker run -d -p 3306:3306 --name ConteinerCT -e "MYSQL_DATABASE=controltec" -e "MYSQL_ROOT_PASSWORD=urubu100" mysql:5.7 
sleep 25
clear
cat > table.sh<<END
#!/bin/bash
sudo docker exec ConteinerTF mysql -u root --password="urubu100" -e "grant all privileges on . to root@localhost;"
sudo docker exec ConteinerTF mysql -u root --password="urubu100" -e "FLUSH PRIVILEGES;"
sudo docker exec ConteinerTF mysql -u root --password="urubu100" -e "use controltec;create table Instituicao(
idInstituicao int primary auto_increment,
nome varchar(100),
numeroEndereco int,
Rua varchar(45),
Bairro varchar(45),
CEP varchar(45),
Complemento varchar(100),
pontoReferencia varchar(100)
);

create table Turma(
idTurma int primary key auto_increment,
nome varchar(45),
descricao varchar(45),
sala varchar(10),
fkInstituicao int,
foreign key (fkInstituicao) references Instituicao(idInstituicao)
);

create table Usuario (
idUsuario int primary key auto_increment,
nome varchar(45),
dataNascimento date,
email varchar(50),
senha varchar(50),
tipo_usuario varchar(20),
fkInstituicao int,
foreign key (fkInstituicao) references Instituicao(idInstituicao)
);

create table Maquina (
idMaquina int primary key auto_increment,
identificador varchar(100),
sistemaOperacional varchar(45),
fkTurma int,
foreign key (fkTurma) references Turma(idTurma)
);

create table Componentes (
idComponente int primary key auto_increment,
nomeComponente varchar(45),
modeloComponente varchar(45),
tamanhoComponenteEmBytes bigint,
fkMaquina int,
foreign key (fkMaquina) references Maquina(idMaquina)
);


create table UsoDeMaquina (
Usuario int,
Componentes int,
hora datetime,
inicializado datetime,
tempoEmUso bigint,
consumoCPU bigint,
consumoMemoria bigint,
consumoDisco bigint,
temperatura float,
primary key(Usuario, Componentes, hora)
);

create table Alertas (
idAlerta int primary key identity(1,1),
descricao varchar(200),
hora datetime default current_timestamp,
Usuario int,
foreign key (Usuario) references Usuario(IdUsuario),
Componente int,
foreign key (Componente) references Componentes(IdComponente)
);"

echo  "$(tput setaf 10)[ControlTec]:$(tput setaf 7) Ok! Você já possui todas as dependências necessárias. Gostaria de iniciar a aplicação?"
sleep 3	
echo "$(tput setaf 10)[ControlTec]:$(tput setaf 7) Confirme para mim se realmente deseja iniciar a aplicação (Y/n)?"		
	read inst
	if [ \"$inst\" == \"Y\" ]
		then
			echo "$(tput setaf 10)[ControlTec]:$(tput setaf 7) Ok! Você escolheu iniciar a aplicação."
			cd ~/ControlTecApp 
			java -jar ControlTec-1.0-jar-with-dependencies.jar 
			sleep 2
			echo "$(tput setaf 10)[ControlTec]:$(tput setaf 7)  Aplicação iniciada!"
			sleep 2
			clear
		
		else 	
		echo "$(tput setaf 10)[ControlTec]:$(tput setaf 7)  Você optou por não iniciar a aplicação por enquanto, até a próxima então!"
		sleep 1
	fi
END
chmod +x table.sh
sleep 3
./table.sh

# ===================================================================
# Todos direitos reservados para o autor: Dra. Profa. Marise Miranda.
# Sob licença Creative Commons @2020
# Podera modificar e reproduzir para uso pessoal.
# Proibida a comercialização e a exclusão da autoria.
# ===================================================================