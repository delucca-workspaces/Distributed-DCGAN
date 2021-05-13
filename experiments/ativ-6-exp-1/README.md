# HPC Atividade 6

Nesta atividade, iremos analisar a execução da aplicação [Distributed-DCGAN](distributed-dcgan-github-repository] em um sistema distribuído, com memória compartilhada. Para a execução do experimento, iremos utilizar a [AWS][aws-site], seu sistemas de computação, rede e arquivos, bem como o MPI para orquestrar a execução.

## Configuração do experimento

A configuração do experimento foi baseada no capítulo 3, intitulado **"Introdução à Computação de Alto Desempenho na Nuvem Computacional"**, escrito por *Edson Borin, Charles Boulhosa Rodamilans e Jeferson Rech Brunetta*, do documento [Minicursos do WSCAD 2018][wscad-arquivo]. Dentro desse capítulo, foi utilizado a seção 3.3.4, *"Estudo de caso 2: Executando o NPB em múltiplas VMs com MPI"*.

Para configurar o experimento, foi feito os seguintes passos:

### 1. Criar uma imagem

Dentro de uma conta da AWS, foi inicializada uma instância *t2.micro*. Essa instância será utilizada como imagem para nossos workers. A criação da instância foi feita de acordo com o documento de base que foi citado anteriormente, para ela foi também atribuído um script de inicialização, como é sugerido no documento. Dentro da instância, foi clonado o [repositório][distrubited-dcgan-github-repository], bem como efetuado os steps de setup (tanto para fazer fetch dos dados de treino, quanto para montar a imagem Docker), e também foi criado uma chave SSH que será utilizada para a conexão entre os workers.

### 2. Configuração do security group

Seguindo os passos do documento que utilizamos como base, foi criado um security group que habilita a interação entre os workers que iremos criar.

### 3. Inicialização dos workers

Com a imagem criada e registrada na AWS, foi criado 2 instâncias *m5.large*, utilizando a imagem construída no passo 1. Ambas instâncias foram colocadas em um mesmo *placement group*, e configuradas para utilizar o security group que foi criado no passo 2.

### 4. Inicialização do nó Main

Uma das instâncias foi escolhida como principal. Foi efetuado o acesso SSH nessa instância e os seguintes passos foram executados:

#### 4.1 Configurar variáveis de ambiente

Para executar o experimento, precisamos dos IPs privados dos nós. Você pode definí-los com o seguinte comando:

```sh
export MAIN_NODE_IP=<IP do nó main>
export WORKER_NODE_IP=<IP do nó worker>
```
> Você pode encontrar os IPs de cada nó nos detalhes da instância na AWS

#### 4.2 Executar o script do experimento

Com as variáveis de ambiente definidas, foi executado o seguinte comando:

```sh
./Distributed-DCGAN/experiments/ativ-6-exp-1/bin/run-node --main
```
> Você precisa executar o comando acima no mesmo shell que você definiu as variáveis de ambiente

### 5. Inicialização do nó Worker

#### 5.1 Configurar variáveis de ambiente

Para executar o experimento, precisamos dos IPs privados dos nós. Você pode definí-los com o seguinte comando:

```sh
export MAIN_NODE_IP=<IP do nó main>
export WORKER_NODE_IP=<IP do nó worker>
```
> Você pode encontrar os IPs de cada nó nos detalhes da instância na AWS

#### 5.2 Executar o script do experimento

Com as variáveis de ambiente definidas, foi executado o seguinte comando:

```sh
./Distributed-DCGAN/experiments/ativ-6-exp-1/bin/run-node
```
> Você precisa executar o comando acima no mesmo shell que você definiu as variáveis de ambiente

### 6. Analise os resultados

Agora o experimento foi finalizado e você pode avaliar os resultados de tempo de iteração e tempo total de execução.

[distributed-dcgan-github-repository]: https://github.com/eborin/Distributed-DCGAN
[aws-site]: https://aws.amazon.com
[wscad-arquivo]: ./assets/minicursos-wscad-2018.pdf
