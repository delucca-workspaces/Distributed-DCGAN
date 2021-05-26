# HPC - Atividade 8 - Experimento 1

- Data: 25 de maio de 2021
- Autor: Daniel De Lucca <delucca@pm.me>

* [HPC - Atividade 8 - Experimento 1](#)
  * [Objetivo](#objetivo)
  * [Metodologia](#metodologia)
  * [Resultados obtidos](#resultados-obtidos)
  * [Conclusão](#conclusao)

## Objetivo

Neste experimento iremos automatizar a execução de um experimento na nuvem através de uma ferramenta de provisionamento e configuração.

## Metodologia

Para este experimento, estamos utilizando a biblioteca [CLAP](https://github.com/lmcad-unicamp/CLAP) para provisionamento do cluster. Toda a configuração necessária para a execução dos comandos pelo CLAP estão localizadas na pasta [.clap](./.clap) dentro do diretório raiz deste experimento. Para executar a instalação das configurações do CLAP você pode executar o script:

```sh
./bin/setup-clap
```

Com o CLAP configurado, foi executado o experimento em três clusters diferentes:

* **cluster-t2.small-1x:** Um cluster com apenas uma máquina `t2.small`
* **cluster-t2.small-2x:** Um cluster com duas máquinas `t2.small`
* **cluster-t2.small-4x:** Um cluster com quatro máquinas `t2.small`

Dentro destes clusters, configuramos o CLAP para executar 20 paramount iterations do treinamento da rede neural. Em seguida, a última task do CLAP é responsável por coletar os resultados. Você pode reproduzir o experimento com os seguintes passos:

### 1. Configure suas chaves

Antes de executar o experimento, você precisa configurar 4 chaves dentro da pasta `~/.clap/private`, são elas:

* `aws-mgmt.pem`: Um arquivo com sua secret access key da AWS
* `aws-mgmt.pub`: Um arquivo com sua access key da AWS
* `aws-login.pem`: A chave privada de login gerada no painel da AWS
* `aws-login.pub`: A chave pública de login gerada no painel da AWS
> **IMPORTANTE:** Não esqueça de colocar a permissão dos arquivos como 0400

### 2. Crie um novo cluster

```sh
clapp cluster start cluster-t2.small-<tamanho desejado do cluster>
```

### 3. Copie o ID do seu nó principal

```sh
clapp cluster list cluster-<o-ID-do-seu-cluster>
```

### 4. Execute o treinamento

```sh
clapp role action gan -a run-gan -n <o-ID-do-seu-nó-principal>
```

### 5. Faça o download dos resultados

```sh
clapp cluster playbook -p "${HOME}/.clap/roles/playbooks/gan/fetch-result.yml" cluster-<ID-do-seu-cluster>
```

Após executar esse último comando, serão criados arquivos `.log` e `.out` com o sufixo sendo o hostname de cada nó dentro da home de seu usuário.

## Resultados obtidos

Você pode analisar o resultado de cada um dos clusters nas seguintes pastas:

* [cluster-t2.small-1x](./results/cluster-t2.small-1x)
* [cluster-t2.small-2x](./results/cluster-t2.small-2x)
* [cluster-t2.small-4x](./results/cluster-t2.small-4x)

### Análise dos resultados

O resultados obtidos são uma forma eficiente para decidirmos qual será a máquina mais adequada para nossa rede neural. O uso de paramont iterations é uma forma inteligente de reduzirmos o tempo necessário para essa avaliação. O intuito da atividade era para entender o uso do CLAP para automação do provisionamento e análise, e a execução do experimento, agora, ficou bastante simples e intuitiva.

Utilizando o CLAP é possível estruturar um experimento completamente replicável, se baseando também no Ansible para executar as tarefas nos nós de nosso cluster.

## Conclusão

Durante o experimento, foi bastante complicado a automação da identificação dos IPs das máquinas. Em um determinado momento tentei utilizar a chave `vars_prompt` das plays do Ansible, mas o CLAP aparentemente não se integra bem a essa ação. Quando utilizei ela o CLAP simplesmente congelou, sem executar a play, e quando era enviado um SIGTERM (Ctrl+C) para ele aparecia o input mas o processo já havia sido cancelado.

Sugiro que esse experimento seja feito novamente tentando explorar formas alternativas para identificar automaticamente os IPs dos nós.

