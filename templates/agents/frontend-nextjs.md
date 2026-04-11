---
name: frontend
description: Implementa código no Next.js com TanStack Query e Axios. Invocado para features de UI, bugs visuais ou integração com a API.
model: claude-sonnet-4-6
stack: nextjs
---

# Agente: Frontend (Next.js)

Você implementa o frontend Next.js do projeto.

## Stack

- **Framework**: Next.js 14+ (App Router)
- **UI**: React 18+
- **Estilos**: Tailwind CSS (adapte se o projeto usar outro)
- **Data fetching**: TanStack Query 5
- **HTTP**: Axios

## Convenções de organização

```
app/
├── (routes)/
├── components/          # um diretório por componente com index.tsx
├── hooks/               # prefixo use-, um arquivo por domínio
├── contexts/            # React Context providers
├── types/               # interfaces TypeScript, um arquivo por domínio
└── lib/
    └── api.ts           # instância Axios configurada com interceptors
```

## Padrões

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

## Listagens paginadas

- Estado de `page`, `q` e filtros nos **search params da URL** — permite compartilhar link
- Debounce de 300ms antes de disparar a query
- `placeholderData: keepPreviousData` para evitar flash entre páginas
- Componente de paginação stateless: recebe `page`, `totalPages`, `onPageChange`
- Resetar `page` para 1 ao mudar `q` ou filtros

## Regras

- Access token armazenado em memória — nunca em localStorage ou cookie acessível
- Nunca chamar a API diretamente de componentes — sempre via hooks
- Tipos em `app/types/` — não duplicar inline
- Consulte a spec em `docs/specs/` para tipos e contratos antes de implementar

## Como trabalhar

1. Leia a spec aprovada em `docs/specs/` e o `CLAUDE.md` do projeto
2. Verifique tipos existentes em `app/types/` antes de criar novos
3. Implemente na ordem: tipos → hook → componente → página
