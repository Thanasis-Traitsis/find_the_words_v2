---
name: flutter-clean-architecture
description: Use this skill whenever creating, refactoring, or reviewing Dart/Flutter code in this project — new feature modules, Cubits, repositories, use-cases, models/entities, or dependency injection wiring. Encodes this project's clean-architecture layering (presentation/domain/data), Cubit-based state management conventions, and the get_it + injectable DI pattern. Trigger for any refactor phase touching app structure, any "where should this code live" question, and any new feature scaffolding.
---

# Flutter Clean Architecture — Project Conventions

This is the target architecture for the "Find the Words" refactor. Apply these rules to new code and to anything being refactored. Existing code that hasn't been touched yet may not follow this — don't assume it does, and don't rewrite untouched modules to match this "for consistency" unless that module is explicitly in scope for the current phase.

## Layers and dependency direction

Three layers per feature: **presentation → domain ← data**. Domain is the center; nothing in domain depends on presentation or data. Data depends on domain (implements its interfaces). Presentation depends on domain (calls use-cases).

```
lib/
  features/
    <feature_name>/
      presentation/
        cubit/
          <feature>_cubit.dart
          <feature>_state.dart
        widgets/
        pages/
      domain/
        entities/
        repositories/          # abstract interfaces only
        usecases/
      data/
        models/                # DTOs — fromJson/toJson, Firestore (de)serialization
        repositories/          # concrete impls of domain interfaces
        datasources/           # remote (Firestore/Firebase) and local (Hive/SharedPrefs)
  core/
    di/
    error/
    usecase/                   # shared UseCase base class
```

**Hard rule:** nothing under `domain/` imports Flutter, Firebase, Hive, or any package tied to a specific data source or UI framework. Domain is pure Dart. If a domain file needs `import 'package:flutter/...'` or `import 'package:cloud_firestore/...'`, that's a layering violation — stop and flag it rather than "just importing it because it's convenient."

## Use-cases

- One class per discrete operation, named as a verb phrase: `GetStageWordsUseCase`, `SyncUserProgressUseCase`, `RedeemXpBoostUseCase`.
- Callable class pattern — implements `call()` so it can be invoked like a function:
  ```dart
  class GetStageWordsUseCase {
    final WordRepository repository;
    GetStageWordsUseCase(this.repository);

    Future<List<Word>> call(StageId stageId) => repository.getWordsForStage(stageId);
  }
  ```
- Use-cases depend on repository **interfaces** (domain), never on concrete data-layer implementations.
- Cubits call use-cases, not repositories directly. If a Cubit is calling a repository method directly, that's skipping the domain layer — flag it.
- Keep use-cases single-purpose. If a use-case starts orchestrating multiple unrelated repository calls, that's a sign it should either be split, or that logic belongs in the Cubit orchestrating multiple use-cases instead.

## Repositories

- Abstract interface lives in `domain/repositories/`, e.g. `abstract class WordRepository`.
- Concrete implementation lives in `data/repositories/`, e.g. `class WordRepositoryImpl implements WordRepository`.
- The impl is responsible for choosing between local/remote datasources and any merge logic (this is exactly where the sync merge logic from the bug tracker should eventually live cleanly — one obvious place to look, not scattered across cubits).
- Repositories return domain entities, never raw DTOs/models. Mapping from data model → domain entity happens inside the repository impl.

## Cubit/Bloc conventions

- One Cubit per feature or per cohesive screen — not one giant app-level Cubit.
- States are explicit, sealed/closed classes (use `sealed class` or `freezed` — pick one and use it consistently across all Cubits, don't mix). Prefer named states over boolean flags: `StageLoading`, `StageLoaded(words)`, `StageError(message)` rather than a single state with `isLoading`/`hasError` booleans bolted on.
- Cubit constructors take use-cases as dependencies (injected via get_it), never construct their own repository or datasource instances.
- Cubits contain orchestration logic (call use-case, map result to state) — they should not contain business rules like XP calculation or merge logic directly. That belongs in domain (use-case or a domain service).
- Naming: `<Feature>Cubit` + `<Feature>State`, file names `<feature>_cubit.dart` / `<feature>_state.dart`, colocated in `presentation/cubit/`.

## Dependency injection — get_it + injectable

- Every injectable class (repositories, use-cases, datasources, Cubits that aren't scoped to a single widget tree) is annotated with `@injectable`, `@lazySingleton`, or `@singleton` as appropriate — not manually registered in a giant hand-written `get_it` setup file.
- Repository interfaces are bound to implementations via `@Injectable(as: WordRepository)` on the impl class.
- Datasources that talk to Firebase/Hive directly are injected into repository impls, never instantiated inline inside a repository or Cubit.
- Composition root (where `getIt.init()` / `configureDependencies()` runs) stays in the app bootstrap sequence (`main.dart` / bootstrapper class) — this is the one place manual service-locator wiring is expected.
- Outside the composition root, code should ask for dependencies via constructor injection, not by calling `getIt<T>()` directly inside business logic. `getIt<T>()` calls scattered through Cubits/use-cases are a smell — flag them.

## What to flag, not silently fix, when refactoring existing code

- Domain-layer files importing Flutter/Firebase/Hive.
- Cubits calling repositories or datasources directly, skipping use-cases.
- Business logic (XP math, merge logic, difficulty scaling) living inside a Cubit or a widget instead of domain.
- Manual `getIt<T>()` calls outside the composition root.
- Repositories returning raw Firestore documents/maps instead of mapped domain entities.

When you find one of these outside the current phase's scope, note it in `refactor-bug-tracker.md` (or a new "architecture debt" section there) rather than fixing it inline — keeps phases reviewable and scoped.