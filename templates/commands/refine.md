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

Ao final, liste o que foi corrigido e o que estava OK.
