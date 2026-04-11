---
description: Resolve ambiguidades de uma feature e avalia escopo antes de escrever a spec.
---

O usuário quer desenvolver uma nova feature. Resolva ambiguidades, garanta que o escopo está bem definido e avalie se não é grande demais para uma única spec.

Se o usuário forneceu a descrição via `$ARGUMENTS`, use como ponto de partida. Caso contrário, peça uma descrição livre.

## Passo 1 — Perguntas de clarificação

Faça todas as perguntas em uma única mensagem. Não pergunte uma por vez.

1. **Ator**: quem executa essa ação? (usuário autenticado, admin, sistema automatizado, etc.)
2. **Fluxo principal**: descreva passo a passo o que o ator faz e o que o sistema responde
3. **Estados de erro**: o que pode dar errado? O que o sistema deve fazer em cada caso?
4. **Interface**: envolve novos endpoints? Novas telas? Ambos? Nenhum?
5. **Impacto em features existentes**: afeta algo que já existe no projeto?
6. **Critério de pronto**: como você sabe que está funcionando corretamente?

Aguarde as respostas antes de prosseguir.

## Passo 2 — Avaliação de escopo

Após coletar as respostas, avalie se a feature cabe em uma única spec ou deve ser quebrada. Critérios para propor split:

- Envolve mais de um domínio de negócio independente
- Tem partes que podem ser entregues e usadas separadamente
- Tem mais de 6 critérios de aceite distintos
- Backend e frontend têm complexidades muito diferentes e independentes entre si

Se sugerir split: apresente a proposta com nomes sugeridos para cada spec menor. Aguarde confirmação do usuário antes de prosseguir.

## Passo 3 — Brief consolidado

Após o escopo estar confirmado, produza o brief:

```
Feature: <nome>
Ator: <quem>
Fluxo principal:
  1. ...
  2. ...
Erros tratados: <lista>
Interface: <endpoints / telas envolvidas>
Impactos em features existentes: <lista ou "nenhum">
Critérios de pronto:
  - ...
  - ...
```

Então pergunte: **"Brief consolidado. Posso chamar o architect para escrever a spec?"**

Se o usuário confirmar, invoque o agente architect passando o brief como contexto.
