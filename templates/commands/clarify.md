---
description: Inicia o desenvolvimento de uma feature: clarifica, especifica, implementa, revisa, valida e abre PR. Fluxo completo sem intervenção do usuário exceto nas gates de aprovação e validação manual.
---

Execute o fluxo completo de desenvolvimento de feature na ordem abaixo. Não pule fases.

## Fase 1 — Branch (PR Workflow)

Verifique se o `CLAUDE.md` contém `## PR Workflow`.

**Se sim:**
1. `git branch --show-current`
2. Leia a branch base do `CLAUDE.md`
3. Se estiver na branch base: peça ao usuário o nome da branch de feature e execute `git checkout -b <nome>`
4. Se já estiver em branch de feature: continue

## Fase 2 — Clarificação

Se o usuário forneceu descrição via `$ARGUMENTS`, use como ponto de partida. Caso contrário, peça uma descrição livre.

Faça todas as perguntas em uma única mensagem:

1. **Ator**: quem executa essa ação?
2. **Fluxo principal**: passo a passo do que o ator faz e o que o sistema responde
3. **Estados de erro**: o que pode dar errado e o que o sistema deve fazer em cada caso
4. **Interface**: novos endpoints? Novas telas? Ambos? Nenhum?
5. **Impacto em features existentes**: afeta algo que já existe?
6. **Critério de pronto**: como saber que está funcionando?

Aguarde as respostas antes de prosseguir.

**Avaliação de escopo:** proponha split se a feature tiver mais de um domínio de negócio independente, partes entregáveis separadamente, ou mais de 6 critérios de aceite distintos. Aguarde confirmação antes de prosseguir.

Produza o brief consolidado:

```
Feature: <nome>
Ator: <quem>
Fluxo principal: <passos>
Erros tratados: <lista>
Interface: <endpoints / telas>
Impactos em features existentes: <lista ou "nenhum">
Critérios de pronto: <lista>
```

## Fase 3 — Spec

Invoque o agente `architect` passando o brief como contexto.

Após o architect retornar, pergunte ao usuário:

> "Spec escrita. Aprova e inicia o desenvolvimento, quer ajustes ou prefere cancelar?"

- **Ajustes**: repasse ao architect e repita esta fase
- **Cancelar**: interrompa
- **Aprovação**: prossiga

## Fase 4 — Testes

Invoque o agente `tdd` passando o caminho da spec.

Se o `CLAUDE.md` contiver `## Git Worktree`: use `isolation: "worktree"`.

## Fase 5 — Implementação

Invoque `backend` e `frontend` **em paralelo**, passando caminho da spec e arquivos de teste. Omita o que não se aplica ao projeto.

```
Agent(subagent_type="backend", [isolation: "worktree"], prompt="Implemente <spec-path>. Testes em <test-paths>.")
Agent(subagent_type="frontend", [isolation: "worktree"], prompt="Implemente <spec-path>. Testes em <test-paths>.")
```

## Fase 6 — Revisão

Execute o checklist inline. Para cada violação encontrada: corrija diretamente.

- [ ] Direção de dependência respeitada (Controller → Service → Repository, nunca ao contrário)
- [ ] Lógica de negócio no service, não no controller ou repository
- [ ] DRY: sem duplicação — verifique se existe código reutilizável antes de criar novo
- [ ] Tipos explícitos, sem `any` desnecessário
- [ ] Inputs validados, erros tratados com exceções HTTP adequadas
- [ ] Sem dados sensíveis em logs ou respostas de erro
- [ ] Sem SQL/command injection (queries parametrizadas)
- [ ] Sem código morto ou comentado

## Fase 7 — Testes automatizados

Leia o `CLAUDE.md` para os comandos de compile, lint e teste da stack. Execute-os.

- Falhas: corrija e re-execute até passar
- Se algum teste não puder ser corrigido sem mudança de spec: informe o usuário antes de prosseguir

## Fase 8 — Validação manual (gate obrigatório)

> "Implementação concluída. Rode a aplicação e teste a feature manualmente. Quando terminar, confirme se está tudo ok ou descreva os ajustes necessários."

**Aguarde.** Não prossiga sem resposta do usuário.

- **Ajustes solicitados**: execute as correções usando o agente adequado e retorne a esta fase
- **Confirmação**: prossiga

## Fase 9 — Documentação

Invoque o agente `docs` passando os arquivos modificados como contexto.

## Fase 10 — Commit

1. `git status`
2. `git diff HEAD`
3. Adicione os arquivos relevantes ao stage (evite `git add -A`)
4. Commit no formato:
   ```
   <tipo>(<escopo>): <descrição>

   Co-Authored-By: Claude <noreply@anthropic.com>
   ```

## Fase 11 — PR

Verifique se o `CLAUDE.md` contém `## PR Workflow`.

**Se sim:**
1. `git push -u origin <branch-atual>` (se não publicada)
2. Título: derivado do último commit. Body: `git log <base>..<atual> --oneline`
3. `gh pr create --base <branch-base> --title "..." --body "..."`
4. Exiba a URL do PR
5. Se worktree: informe que após o merge o worktree pode ser removido com `git worktree remove <path>`

**Se não:** informe que o desenvolvimento foi concluído.
