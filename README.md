# WAS4P 
> Web Application Server for PHP

## O que é?
É uma iniciativa da [Wend Tecnologia](http://wend.com.br) para divulgar e propagar as melhores práticas do mercado PHP, onde diponibilizamos a VM (Virtual Machine) bem como os scripts que utilizamos para criar nossos servidores para desenvolvimento em PHP.

**Para o iniciante** É tudo que você precisa para começar a programar em PHP! Baixe a VM, e siga os passos citados, e faça seus primeiros testes!

**Para o profissional** É um conjunto de scripts para criação de VM (Virtual Machine) contendo uma instalação padrão para desenvolvimento em PHP.

### Ambiente
* **Minimal**: ZendServer + Git [was4p v1.1.0-dg (32bits)-minimal.ova](http://sourceforge.net/projects/was4p/files/v1.1/was4p%20v1.1.0-dg%20%2832bits%29-minimal.ova/download)
* **Default**: ZendServer + Git + [PHP QA Tools](https://github.com/wendtecnologia/phpqatools)
* **Full**: ZendServer + Git + [PHP QA Tools](https://github.com/wendtecnologia/phpqatools) + Jenkins + PHPTemplate
* 
> Se for utilizar o **MySQL**, instale usando o comando: `$ sudo apt-get install mysql-server`

#### Configurações
- Ubuntu Server 14.04 LTS 32bits¹
- Zend Server 7.0
- PHP 5.5.7

> ¹Disponibilizamos as VMs em 32bits para facilitar a utilização por qualquer pessoa, mesmo que ainda nao possuam um sistema 64bits.
Fizemos vários testes com 64bits e todo procedimento funciona perfeitamente no mesmo.

## Como funciona?
Existem duas formas de aproveitar esse projeto, utilizando a VM que disponibilizamos no SourceForge, ou utilizar os Scripts para criar sua VM do zero.

### Usando a VM(Virtual Machine)
Tendo a versão mais recente do [VirtualBox](http://virtualbox.org) instalada, basta baixar o arquivo no sourceforge e seguir os passos abaixo:

1. Verifique as configurações de rede da VM, resete o MAC das placas de rede preferencialmente.
2. Inicie a VM normalmente, e faça o primeiro acesso utilizando os dados: 
 - **Usuário**: `was4p`
 - **Senha**: `was4p123`
3. Utilize o comando `$ ifconfig ` para idendificar seu IP
 - aproveite para conferir o acesso à internet com `$ ping google.com`
4. Atualize a VM com os comandos: `$ sudo apt-get update` e `$ sudo apt-get upgrade -y`
5. Acesse o Zend Server: http://`ip-da-vm`:10081 e siga o passo a passo para configurar seu Zend Server;
6. Execute os demais [scripts](https://github.com/wendtecnologia/was4p/blob/master/scripts/README.md) conforme necessidade.
7. Sincronize seu projeto com uma das 2 formas abaixo, ou as duas:
 - Use ssh/sftp na sua IDE ou aplicação de FTP preferida para sincronizar os projetos na pasta: `/var/www/html`
 - Utilize os Recursos do Zend Deployment para testar suas aplicações;

> Se for utilizar o **MySQL**, instale usando o comando: `$ sudo apt-get install mysql-server`

### Instalando via Script
Com o script basta criar uma nova VM Linux/Debian, recomendamos o `Ubuntu Server 14.04 LTS`:

1. Faça a instalação padrão de sua VM
2. Instale o git usando o comando: `$ sudo apt-get install git`
3. Clone o projeto was4p: `$ git clone http://github.com/wendtecnologia/was4p.git`
4. Acesse a pasta criada: `$ cd was4p`
5. Execute o comando `$ sudo ./install.sh` para instalar o Zend Server e definir seus PATHs;
6. Siga os passos 5, 6 e 7 da VM para concluir.

## Onde baixar?
A máquina pronta pode ser encontrada no link:
http://sourceforge.net/projects/was4p

## TO-DO
- Criar verificações para instalar em VMs baseadas RedHat

## Author
Walker de Alencar @walkeralencar

