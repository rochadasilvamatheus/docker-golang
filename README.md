# Desafio Docker Golang

Este repositório contém a solução para o desafio de publicar uma imagem Docker que executa um simples "Hello World" com a linguagem Go Lang. O objetivo é criar uma imagem que, ao ser executada, imprime a mensagem "Full Cycle Rocks!!" e tenha um tamanho menor que 2MB.

## Objetivo
O desafio consiste em criar um container Docker com uma aplicação Go Lang que, ao ser executada, exibe a mensagem `Full Cycle Rocks`.

**Requisitos**:
- A imagem criada deve ter **menos de 2MB**.
- A imagem deve ser publicada no **Docker Hub**.
- Quando o container for executado com o comando:
```bash
docker run rochamatheus/fullcycle
```
O output esperado é:
```bash
Full Cycle Rocks
```
**Estrutura do Repositório**
```bash
/fullcycle
  ├── Dockerfile
  ├── full-cycle.go
  ├── go.mod
  └── README.md
```
## Repositorio dockerhub
* https://hub.docker.com/r/rochamatheus/fullcycle

## Passos para Execução
### 1. Baixar a Imagem do Docker Hub
Para baixar a imagem diretamente do Docker Hub, execute o seguinte comando:
```bash
docker pull rochamatheus/fullcycle:latest
```
Isso irá baixar a imagem rochamatheus/fullcycle com a tag latest para o seu ambiente local.

### 2. Construir a Imagem Docker
No diretório do projeto, execute o seguinte comando para construir a imagem Docker:
```bash
docker build -t rochamatheus/fullcycle .
```
### 3. Executar o Container Localmente
Após a construção da imagem, execute o container para testar se ele imprime a mensagem correta:
```bash
docker run rochamatheus/fullcycle
```
O comando acima deverá retornar:
```bash
Full Cycle Rocks
```
## O que foi feito para reduzir o tamanho da imagem:
### 1. Uso da Imagem Base `scratch`
A imagem scratch é uma imagem vazia, sem qualquer sistema operacional ou bibliotecas. Isso permite que a imagem final seja extremamente pequena. No entanto, para usá-la, é necessário garantir que o binário Go seja estático, ou seja, sem dependências externas.

### 2. Compilação Estática do Binário
Para garantir que o binário Go seja estático (sem dependências externas como bibliotecas do sistema operacional), foi utilizado as variáveis de ambiente `CGO_ENABLED=0` e `GOOS=linux` durante a compilação.

* `CGO_ENABLED=0`: Desabilita a utilização do Cgo, evitando a vinculação com bibliotecas C externas.
* `GOOS=linux`: Garante que o binário seja compilado para o sistema operacional Linux.
### 3. Otimizações na Compilação
Adicionamos uma flag de compilação para remover informações de depuração e símbolos do binário, o que ajuda a reduzir ainda mais o seu tamanho.

* Flag `-ldflags="-s -w"`: Remove informações de depuração e símbolos de tabela de pilha.

#### Explicação das Mudanças:
* Compilação Estática:

  * `CGO_ENABLED=0`: Garantia de que o binário será totalmente estático.
  * `GOOS=linux`: Compila o binário para o sistema operacional Linux.
  * `go build -o hello-world -ldflags="-s -w"`: Compila o código Go e remove informações de depuração e símbolos desnecessários.
* Imagem Base `scratch`:
  * Foi usado a imagem `scratch`, uma imagem vazia, que contém apenas o binário compilado. Não há dependências ou bibliotecas adicionais.

* Cópia do Binário:
  * `COPY --from=builder /app/full-cycle /full-cycle`: Copia o binário da etapa de construção para a imagem final.

* Comando de Execução:
  * `CMD ["/full-cycle"]`: Define o comando padrão a ser executado no container, que é o binário full-cycle.
