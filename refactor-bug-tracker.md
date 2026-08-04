# Refactor Bug Tracker — Find the Words

Fold these fixes into whichever refactor phase touches the relevant module. Update status as you go.

## 🔴 Crucial — fix in the phase that touches this area, don't defer indefinitely

| # | Bug | File | Status |
|---|---|---|---|
| 1 | `minWordsPerLevel` indexes a hardcoded 10-element array with `level - 1`. Any player reaching level 11 crashes stage generation (uncaught `RangeError`). | `stage_criteria.dart` | Open |
| 2 | `AccountBoostCubit.activate()` grants the XP boost before confirming point deduction succeeded. Only a cosmetic UI check prevents free boosts. | `AccountBoostCubit` | Open |
| 3 | Sync merge logic is asymmetric and lossy: "local ahead" drops cloud-only words, "cloud ahead" drops local-only points/freezes. `scheduleSync` (called after every word found) is pure last-write-wins with no re-merge — concurrent play on two devices silently clobbers data. | `CloudSyncService._mergeUserData`, `scheduleSync` | Open — needs proper field-level merge design + test cases, not a quick patch |
| 4 | Unknown: no `firestore.rules` in repo. Unclear whether Firestore blocks clients from writing arbitrary points/level directly. Makes bug #3 potentially worse (spoofing, not just data loss). | Firebase Console / project config | **Blocked on you** — check Console → Firestore → Rules, or `firebase firestore:rules:get` |

## 🟡 Should fix, not urgent

| # | Bug | File | Status |
|---|---|---|---|
| 5 | `reauthenticateWithApple()` exists but is never wired into the delete-account flow — only Google re-auth works there. Apple has rejected apps for this exact gap; fix before next App Store submission. | delete-account UI | Open |
| 7 | `MyAppLoader._initializeApp()` catches any bootstrap exception, `debugPrint`s it, and leaves `_isReady = false` forever. Splash screen hangs indefinitely with no error surfaced — even though `ErrorScreen` already exists and is wired into the router. Bad Firebase config or no network on first launch = permanently stuck splash. | `app_loader.dart` | Fixed — `_MyAppLoaderState` now tracks a tri-state (`loading`/`ready`/`failed`) instead of `bool _isReady`; failure renders a new `BootstrapErrorScreen` (message + retry button that re-runs `AppBootstrapper().initialize()`). `ErrorScreen` (GoRouter's unmatched-route fallback) left untouched — different concern, no shared behavior worth reusing. |
| 8 | `AppRouter.redirect` reads `getIt<AuthCubit>()`, `getIt<LanguageCubit>()`, `getIt<VersionBloc>()` directly via service locator instead of injected dependencies — works but untestable in isolation, and the 5-branch `if` chain has implicit order-dependence that's easy to get subtly wrong with zero test coverage. | `app_router.dart` | Open |
| 9 | Route `extra` args handled inconsistently: `stage` route silently defaults (`stage: 0, level: 1`) on bad/missing cast; `complete` route force-casts `as StageResults` with no null safety and will crash. | `app_router.dart` | Open |

## 🟢 Low-risk cleanup — batch with general refactor work

| # | Bug | File | Status |
|---|---|---|---|
| 10 | `MobileAds.instance.initialize()` not awaited in `main.dart` — possible race if anything requests an ad before init completes. Confirm intentional vs. oversight. | `main.dart` | Open |
| 11 | `forceUpdate` route missing `parentNavigatorKey` that every other route has — confirm intentional or copy-paste miss. | `app_router.dart` | Open |
| 12 | `SoundCubit()` and `ConnectivityCubit(...)` constructed inline in `_appProviders()` while every other cubit comes from `getIt<T>()` — inconsistent DI pattern, flagged by the flutter-clean-architecture skill. | `app_loader.dart` | Open |
| 13 | Redundant `Builder` wrapper in `MyApp.build()` — context already supports `watch<T>()` without it. | `my_app.dart` | Open |
| 6 | Stage-word files get re-decompressed on every single stage generation, no caching. Cheap, isolated perf fix. | stage generation | Open |

## Already confirmed fixed (verified via commit 0616fb0)
- Difficulty-classification operator-precedence bug
- Word-availability crossword-ratio inversion

---
*Keep this file updated as phases complete. Add new findings here as Claude Code surfaces them during refactor work.*