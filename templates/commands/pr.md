---
description: Abre um pull request para a branch base configurada no projeto.
model: claude-haiku-4-5-20251001
---

Abra um pull request com as mudanças da branch atual.

## Passos

1. Leia o `CLAUDE.md` e localize a seção `## PR Workflow` para identificar a **branch base**
   - Se a seção não existir: pergunte ao usuário a branch base antes de continuar

2. Execute `git branch --show-current` — se retornar a branch base, interrompa:
   > "Você está na branch base (`<branch-base>`). Crie uma branch de feature antes de abrir um PR."

3. Execute `git status` — se houver mudanças não commitadas, interrompa:
   > "Há mudanças não commitadas. Execute `/commit` antes de abrir o PR."

4. Verifique se a branch já foi publicada no remoto:
   ```bash
   git ls-remote --heads origin <branch-atual>
   ```
   Se não existir: execute `git push -u origin <branch-atual>`

5. Monte o corpo do PR:
   - **Título**: derivado do último commit (`git log -1 --format=%s`) ou do nome da branch
   - **Body**: lista dos commits desde a branch base (`git log <branch-base>..<branch-atual> --oneline`)

6. Execute:
   ```bash
   gh pr create --base <branch-base> --title "<título>" --body "<body>"
   ```

7. Exiba a URL do PR criado

## Trocar a branch base

Se o usuário quiser usar uma branch base diferente da configurada no `CLAUDE.md`, aceite como argumento:

```
/pr main
/pr develop
```

Use o argumento `$ARGUMENTS` como branch base se fornecido, caso contrário use a do `CLAUDE.md`.

## Worktree

Se o `CLAUDE.md` contiver a seção `## Git Worktree`, após criar o PR exiba:

> "PR aberto. Após o merge, remova o worktree com:
> `git worktree remove <path-do-worktree>`"
