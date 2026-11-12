# Gerenciador de Tarefas Inteligente (GTI)

App Flutter de gerenciamento de tarefas construído com a metodologia **Atomic Design**.

## Funcionalidades

- ✅ Criar, editar e excluir tarefas (arrastar para excluir + "Desfazer")
- 🏷️ Categorias: Trabalho, Estudo, Pessoal, Saúde, Finanças, Outros
- 🚩 Prioridades: Alta, Média, Baixa
- ☑️ Marcar tarefas como concluídas
- 🔎 Busca por texto e filtros por status, categoria e prioridade
- 💾 Persistência local com `shared_preferences`
- 🧠 Recursos "inteligentes":
  - Ordenação inteligente (pendentes → atrasadas → prioridade → vencimento)
  - Sugestão automática de categoria/prioridade a partir do título
    (ex.: "Pagar boleto **urgente**" → Finanças / Alta)
  - Data de vencimento com alertas de atraso
  - Painel com estatísticas (pendentes, concluídas e atrasadas)

## Arquitetura (Atomic Design + Camadas)

```
lib/
├── core/            # Tema (design tokens) e utilitários
├── data/            # Modelos e repositório (persistência local)
├── domain/          # Regras puras (busca/filtro/ordenação e sugestões)
├── controllers/     # Estado (ChangeNotifier)
└── ui/
    ├── core/        # Apresentação visual de enums e feedbacks compartilhados
    ├── atoms/       # AppButton, AppTextField, PriorityBadge, CategoryTag, TaskCheckbox...
    ├── molecules/   # SearchField, StatTile, FilterButton, ResultsHeader, EmptyState...
    ├── organisms/   # TaskCard, TaskSliverList, FilterBottomSheet, StatsOverview, TaskForm
    ├── templates/   # HomeTemplate, FormTemplate (layout sem regra de negócio)
    └── pages/       # HomePage, TaskFormPage (conectam templates ao estado)
```

## Como executar

```bash
flutter pub get
flutter run
flutter test
```
