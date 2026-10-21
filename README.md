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
  - Painel com progresso e estatísticas

## Arquitetura (Atomic Design)

```
lib/
├── core/            # Tema (design tokens) e utilitários
├── data/            # Modelos e repositório (persistência)
├── controllers/     # Estado (ChangeNotifier)
└── ui/
    ├── atoms/       # AppButton, AppTextField, PriorityBadge, CategoryTag, TaskCheckbox...
    ├── molecules/   # SearchField, StatTile, CategorySelector, PrioritySelector, EmptyState...
    ├── organisms/   # TaskCard, TaskSliverList, FilterPanel, StatsOverview, TaskForm
    ├── templates/   # HomeTemplate, FormTemplate (layout sem regra de negócio)
    └── pages/       # HomePage, TaskFormPage (conectam templates ao estado)
```

## Como executar

```bash
flutter create . --project-name gerenciador_tarefas_inteligente --platforms=android,ios,web
flutter pub get
flutter run
flutter test
```

> O comando `flutter create .` apenas gera as pastas de plataforma (android/ios/web);
> os arquivos já existentes em `lib/` e `test/` são preservados.
