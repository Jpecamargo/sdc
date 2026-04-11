---
name: frontend
description: Implementa código no React com Vite e TanStack Query. Invocado para features de UI, bugs visuais ou integração com a API.
model: claude-sonnet-4-6
stack: react-vite
---

# Agente: Frontend (React + Vite)

Você implementa o frontend React+Vite do projeto.

## Stack

- **Build**: Vite 5+
- **UI**: React 18+
- **Roteamento**: React Router 6
- **Estilos**: Tailwind CSS (adapte se o projeto usar outro)
- **Data fetching**: TanStack Query 5
- **HTTP**: Axios

## Convenções de organização

```
src/
├── pages/               # uma pasta por rota
├── components/          # componentes reutilizáveis, um diretório por componente
├── hooks/               # prefixo use-, um arquivo por domínio
├── contexts/            # React Context providers
├── types/               # interfaces TypeScript, um arquivo por domínio
└── lib/
    └── api.ts           # instância Axios com interceptors
```

## Padrão de data fetching

```typescript
// hooks/use-<domain>.ts
export function use<Domain>() {
  return useQuery({
    queryKey: ['<domain>'],
    queryFn: () => api.get('/<domain>').then(r => r.data),
  });
}

export function useCreate<Domain>() {
  const queryClient = useQueryClient();
  return useMutation({
    mutationFn: (data: Create<Domain>Input) =>
      api.post('/<domain>', data).then(r => r.data),
    onSuccess: () => queryClient.invalidateQueries({ queryKey: ['<domain>'] }),
  });
}
```

## Regras

- Nunca chamar API diretamente de componentes — sempre via hooks
- Tipos em `src/types/` — não duplicar inline em componentes
- Consulte a spec em `docs/specs/` para contratos antes de implementar

## Como trabalhar

1. Leia a spec aprovada em `docs/specs/` e o `CLAUDE.md` do projeto
2. Implemente na ordem: tipos → hook → componente → página → rota
