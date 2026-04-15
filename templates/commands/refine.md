---
description: Revisa o código implementado e corrige violações de arquitetura, padrões e convenções.
---

Revise o código modificado recentemente e corrija violações. Leia o `CLAUDE.md` para entender a arquitetura e convenções do projeto antes de revisar.

## Checklist de revisão

### Arquitetura
- [ ] Direção de dependência respeitada (Controller → Service → Repository, nunca ao contrário)
- [ ] Nenhuma camada foi pulada
- [ ] Lógica de negócio está no service, não no controller ou repository
- [ ] Repository é a única camada que toca o ORM/banco

### Código
- [ ] Sem variáveis de ambiente lidas diretamente (`process.env`, `os.environ`) fora do módulo de config
- [ ] Tipos explícitos — sem `any` desnecessário
- [ ] Erros tratados com exceções HTTP adequadas (não retornar null como sucesso)
- [ ] Imports corretos para a stack (ex: extensão `.js` em projetos nodenext)

### Testes
- [ ] Testes existem para os critérios de aceite da spec
- [ ] Sem lógica de produção em arquivos de teste
- [ ] Mocks usados apenas onde necessário

### Segurança
- [ ] Sem dados sensíveis em logs ou respostas de erro
- [ ] Inputs validados antes de processar
- [ ] Sem SQL/command injection (queries parametrizadas, nunca concatenação)

### Qualidade
- [ ] Sem código morto ou comentado
- [ ] Sem duplicação desnecessária
- [ ] Nomes descritivos e consistentes com as convenções do projeto

## Comportamento

Para cada violação encontrada: corrija diretamente. Não crie helpers ou abstrações desnecessárias — resolva o problema mínimo.

Durante a revisão, **não apague arquivos**. Apenas anote quais deveriam ser removidos.

## Gate de remoção de arquivos

Ao final da revisão, se houver arquivos a remover, apresente a lista completa:

> "Revisão concluída. Os seguintes arquivos devem ser removidos:
>
> - `src/modules/old-feature/old-feature.service.ts`
> - `src/modules/old-feature/old-feature.controller.ts`
> - `tests/old-feature.spec.ts`
>
> Confirma a remoção? Se quiser preservar algum arquivo, informe quais."

Aguarde a resposta antes de executar qualquer `rm`.

- Se o usuário confirmar: remova todos os arquivos listados
- Se o usuário excluir algum: remova apenas os aprovados
- Se o usuário recusar: não remova nada

Se não houver arquivos a remover, pule este gate e liste apenas o que foi corrigido e o que estava OK.
