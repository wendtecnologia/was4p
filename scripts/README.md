WAS4P - Scripts
=====
Nesta pasta estão disponíveis os scripts utilizados no was4p.

OBS.: A máquina virtual foi criada sem rede inicialmente, para ter o menor 
tamanho possível inibindo as atualizações e instalações extras.

### 01-locale.sh
Define o locale para pt_BR.

### 02-interfaces.sh
Configura o eth0 para iniciar automaticamente e receber IP via DHCP e sobe a
interface de rede.

No VirtualBox definir a primeira rede como Bridge e usando sua placa de rede
que possua acesso à internet.

### 03-upgrade.sh
Faz update e upgrade do SO.

### 04-zendserver.sh
Instalação do Zend Server com php 5.5

### 05-qatools.sh
Instala o composer no contexto global, e instala o PHP QA Tools baseado no composer e ajusta o PATH para incluir o /bin do Composer;

### 06-jenkins.sh
Instala o jenkins e os plugins necessários para sua utilização

### 94-setpath.sh
Ajusta o PATH para incluir o /bin do Zend Server, o /bin e o atalho 'zf' do Zend Framework 1

### 99-dependencies.sh
Intala aplicações dependentes: git-core, git-svn, subversion, gcc, autoconf, make
