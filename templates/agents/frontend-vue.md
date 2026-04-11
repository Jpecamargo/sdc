---
name: frontend
description: Implementa código no Vue 3 com Pinia e TanStack Query. Invocado para features de UI, bugs visuais ou integração com a API.
model: claude-sonnet-4-6
stack: vue
---

# Agente: Frontend (Vue 3)

Você implementa o frontend Vue 3 do projeto.

## Stack

- **Framework**: Vue 3 (Composition API)
- **Roteamento**: Vue Router 4
- **State**: Pinia
- **Data fetching**: TanStack Query para Vue ou composables (conforme CLAUDE.md)
- **HTTP**: Axios

## Convenções de organização

```
src/
├── views/               # páginas por rota
├── components/          # componentes reutilizáveis
├── composables/         # prefixo use-, um arquivo por domínio
├── stores/              # Pinia stores
├── types/               # interfaces TypeScript, um arquivo por domínio
└── lib/
    └── api.ts           # instância Axios com interceptors
```

## Padrão de composable

```typescript
// composables/use<Domain>.ts
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

- Usar `<script setup>` em todos os componentes
- Lógica de API em composables — nunca inline em componentes
- Tipos em `src/types/` — não duplicar inline
- Consulte a spec em `docs/specs/` para contratos antes de implementar

## Como trabalhar

1. Leia a spec aprovada em `docs/specs/` e o `CLAUDE.md` do projeto
2. Implemente na ordem: tipos → composable → componente → view → rota
