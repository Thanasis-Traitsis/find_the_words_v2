# Find the Words (Βρες τις Λέξεις) — Codebase Reference

Flutter word-puzzle game. Single repo, Firebase backend (Auth + Firestore), no custom server.
Offline-first: guest play works fully offline; authenticated play syncs to Firestore.
Bilingual (Greek/English), dictionaries bundled as compressed assets. Published on both stores
(`com.thanasistraitsis.findthewords`). No unit tests exist anywhere in the repo (`test/` has one
stale, unrelated boilerplate file — see §8).

This file is dense and reference-oriented by design (file paths + function names), meant to be
reloaded as working context, not read once.

---

## 1. Architecture overview

- **State management**: `flutter_bloc` (Cubit + Bloc) used consistently everywhere except a few
  purely-presentational `StatefulWidget`s (14 files use `setState`, all local UI state — no
  business logic in `setState`, confirmed by sweep). Cubits/Blocs are registered as singletons in
  `lib/core/services/service_locator.dart` via `get_it`, then exposed app-wide through
  `MultiBlocProvider` in `lib/main.dart` (`MyAppLoader.build`, lines ~102-120).
- **DI**: `get_it` (`getIt`), split into `_registerServices`/`_registerBlocs`/etc. in
  `service_locator.dart`. Two init phases: `setupMinimalServiceLocator()` (called in `main()`,
  before first frame — just `SharedPreferences` + `LanguageCubit`/`ThemeCubit`) and
  `setupServiceLocator()` (called inside `MyAppLoader._initializeApp`, alongside Google Sign-In
  init and dictionary loading, gated behind the splash screen).
- **Navigation**: `go_router` (`lib/config/routes/app_router.dart`). Single `GoRouter` with a
  `redirect` callback driven by `AuthCubit` + `LanguageCubit` + `VersionBloc` state
  (`appStatusNotifier`, a `Listenable` wrapping both cubits) — handles force-update redirect,
  first-time language selection redirect, and auth-loading → splash redirect all in one place.
- **Key folders**: `lib/config/*` = cross-cutting concerns (ads, language, routes, theme, sound,
  version, connectivity). `lib/core/*` = shared services/models/widgets/constants/utils.
  `lib/features/*` = one folder per feature, each internally split `data/domain/presentation`
  (not all features have all three — smaller features like `freeze`, `points` are thinner).
- **Stages/levels**: fully **data-driven from bundled assets**, not hardcoded. See §6 for the
  dictionary/stage asset pipeline. Stage *difficulty criteria* (word-length range, word-count
  range, min "big words") are computed from `level` + `progress` by
  `StageCriteria.fromLevelAndProgress` (`lib/features/stage/data/models/stage_criteria.dart`) —
  weighted-random difficulty tier selection based on how far through the level the player is
  (`_selectDifficultyWeighted`, more likely to pick harder tiers as `progress` → 100%).
- **Store / IAP**: **there is no real-money IAP anywhere in this codebase** (no
  `in_app_purchase` package, confirmed by dependency scan). "Store" (`lib/features/store/`) is
  entirely a virtual economy: spend in-game **points** (earned via stage completion, rewarded
  ads, etc.) on XP-multiplier boosts, freezes, and discounts. Purchase flow:
  `offer_card.dart:94-102` → `AccountBoostCubit.activate()` — see §3 for a real bug here.

---

## 2. Auth & sync — mechanics + flagged risks

### Identity model
- Every install gets a user immediately, guest or not — there's no "logged out" limbo state in
  normal operation. `AuthCubit._loadAuthState()` (`auth_cubit.dart:31-58`): checks Firebase
  current user first, then a locally-stored guest token (`AppKeys.authTokenKey` via
  `AuthService.userHasToken`), and only creates a brand-new guest user
  (`AuthCubit.createNewUser`) if neither exists.
- Guest users: `UserEntity.guest(...)`, token = a locally-generated random string
  (`TokenUtils.generateGuestToken`), persisted only in Hive (`StorageService`, box
  `user_box`/`stage_box`) + the token in `SharedPreferences`. **No Firestore document ever
  exists for a pure guest.**
- Providers: Google (`google_sign_in` v7, `AuthService.signInWithGoogle`,
  `auth_service.dart:66-102`) and Apple (`sign_in_with_apple`,
  `AuthService.signInWithApple`, `auth_service.dart:118-161`). Both go through
  `firebase_auth.signInWithCredential` and land in the same `_handleAuthenticatedUser` /
  `syncWithCloud` path.

### Sync direction & merge logic (`lib/core/services/cloud_sync_service.dart`)
Entry point `CloudSyncService.syncWithCloud` (line 25) branches three ways:
1. **No cloud doc** → `_uploadLocalToCloud` (local → cloud, one-way, line 47).
2. **Cloud doc exists, no local user** (fresh install, already-known account) → cloud → local
   as-is (line 40-42).
3. **Both exist** → `_mergeUserData` (line 69), keyed off `UserEntity.totalProgressScore`
   (`user_entity.dart:59-63`, = Σ `level + progress/100` across both languages):
   - **Local ahead** (line 86-99): uses `localUser.progressByLanguage`
     **unconditionally, with no merge against cloud's words for that language at all** — any
     words the player found on *another* device that are reflected in the cloud doc but not
     yet known locally are **silently discarded** here (contrast with the cloud-ahead branch
     below, which does merge words both ways).
   - **Cloud ahead** (line 100-149): merges words per-language via `_mergeWords` (union, minus
     banned list — line 247), and clears `currentStage` if cloud's level is strictly higher
     (stale in-progress puzzle, reasonable). But `points`/`totalFreezes` are taken from
     `cloudUser` **directly, not maxed against local** (line 144, 148) — if the local device had
     *more* points or freezes than the cloud snapshot (e.g. earned via ads/store purchase before
     ever syncing), those are **silently lost**.
   - **Equal score** (line 151-160, via `_mergeProgressMaps`, line 167-245): the only branch that
     does this correctly — `points` and `totalFreezes` are both `max(local, cloud)`
     (line 235-243), and per-language progress is compared score-by-score.
   - **Net effect**: the "local ahead" and "cloud ahead" branches are asymmetric and each drop
     some category of local-only progress. This is the most concrete "silent divergence" risk
     in the codebase and should be the first thing touched in any sync refactor.

### Ongoing sync after the initial merge — real multi-device risk
`CloudSyncService.scheduleSync(user)` (line 275) is a **3-second-debounced, unconditional
Firestore `.update()`** of the *entire* current in-memory user snapshot — called from
`UserProfileService` after **every** gameplay-affecting local write: `_saveUpdatedProgress`
(word found / stage saved, line 160), `updateFreezeStatus` (line 212), `updateUserTotalFreezes`
(line 233). It does **not** re-read Firestore or merge before writing — pure last-write-wins.

**Concrete implication for "two devices without syncing in between"**: the only place the
merge/reconciliation logic (`syncWithCloud`) runs is at `AuthCubit._loadAuthState` /
`_handleAuthenticatedUser` — i.e. **app cold start**. If the same account is played on two
devices in the same rough time window (app already open on both, or both opened within the same
session), each device's debounced 3s writes race directly against each other with zero merging;
whichever lands last on the Firestore server wins and silently overwrites the other device's
progress made in that window. This matches the exact scenario named in the brief — it's not
speculative, it's the literal behavior of `scheduleSync`.

### Gap: `AccountBoostCubit` never triggers sync
`AccountBoostCubit._updateBoost` (`account_boost_cubit.dart:119-144`) saves to Hive and updates
`AuthCubit`'s in-memory state directly, but **never calls `CloudSyncService.scheduleSync`**.
Boost activation/decrement/clear only reaches Firestore as an incidental side effect of some
*other* action later triggering a sync (since the boost is embedded in the synced
`progressByLanguage` payload — see `ProfileStatusModel.toMap`,
`profile_status_model.dart:78-88` — it's in the schema, just not proactively pushed).

### Login/logout/delete edge cases
- **Sign out** (`AuthCubit.signOut`, line 174-206): converts the authenticated user back to a
  **guest** with the same progress (`UserModel.guest(...)`, keeps points/progress/freezes) —
  does not clear local data. Firebase-side sign out via `AuthService.signOut` (Google + Firebase
  Auth signOut, line 104-115).
- **Delete account** (`AuthService.deleteAccount`, line 191-236): guests just clear local storage
  (`clearLocalStorage`, line 174-188 — also resets `StoreDiscountService`, `AccountBoostCubit`,
  `FreezeCubit`). Authenticated users: delete Firestore doc → delete Firebase Auth account →
  Google sign-out → clear local storage.
- **Bug — broken deletion path for Apple users**: Firebase requires recent re-login before
  destructive account operations (`requires-recent-login`, handled at
  `auth_service.dart:215-222`). The re-auth UI (`reauthenticate_dialog.dart:18`) calls
  `AuthCubit.reauthenticateAndDeleteAccount()` (`auth_cubit.dart:231-244`), which **only calls
  `AuthService.reauthenticateWithGoogle()`** (line 237). `AuthService.reauthenticateWithApple()`
  exists (`auth_service.dart:238-270`) but **is never called from anywhere in the app** — dead
  code. Net effect: an Apple-Sign-In user who needs to re-authenticate to delete their account has
  no working path to do so. Worth prioritizing — App Store guidelines require a working account
  deletion flow for Sign in with Apple users specifically.

### Open question — Firestore security rules
**No `firestore.rules` (or any `*.rules` file) exists anywhere in this repo.** `firebase.json`
only configures FlutterFire codegen output paths, not deployed rules. This means:
- I cannot verify what, if anything, prevents a client from writing arbitrary values (e.g.
  inflated `points`, `totalFreezes`, or `progressByLanguage.level`) directly to
  `/new_users/{uid}` in Firestore — the app itself has no server-side validation of any synced
  field (all writes are plain `FirebaseFirestore.instance.collection(...).doc(...).set/update`
  calls from `UserRepositoryImpl`, `user_repository_impl.dart:106-121`).
- **Please clarify**: are rules managed separately (Firebase Console / a different
  repo/CI pipeline)? If they live only in the Console, it'd be worth pulling them into this repo
  (`firebase deploy --only firestore:rules` workflow) so they're reviewable — right now this is a
  total blind spot for the "could a client spoof state" question in §3.

---

## 3. Points, hints/help, and ad rewards — full flow

### Two separate currencies — don't conflate them
- **Points** (`PointsCubit`, `lib/features/points/cubit/points_cubit.dart`): the spendable
  in-game currency. `Cubit<int>`, persisted via `UserEntity.points` → Hive. Earned from stage
  completion (`StageResults.totalPointsForStage()`, see below) and rewarded ads; spent on hints
  and store purchases.
- **XP**: not a currency, it's *progress toward the next level* — folded directly into
  `ProfileStatusModel.progress`/`level` (no separate XP balance field exists). "XP earned" from a
  stage is converted immediately into a progress-percentage delta (`StageXPService`, see §2 in
  the XP writeup below) and applied via `UserProfileService.updateAfterStage`.

### Points earned per stage (`StageResults`, `lib/features/stage/data/models/stage_results.dart`)
`totalPointsForStage()` (line 62-67) = `getPointsForStage()` (level, clamped 1-10) +
`getPointsForCrosswordWords()` (tiered by word count, 1-7) +
`getPointsForExtraWords()` (tiered by bonus words found, 0-10) +
`getPointsForLevelup()` (`getPointsForStage() * 5`, only if `newProgress == 100`).
Applied in `StageController.handleStageCompletion` (`stage_controller.dart:107-110`).

### Hints ("help") — `StageBloc._onCrosswordLetterReveal` (`stage_bloc.dart:94-142`)
Two hint modes, both spend points via `PointsCubit.deductPoints` **before** revealing (line
104-107; if insufficient points, emits `StageInGameError(notEnoughPoints)` and aborts, line
109-117):
- **Magic wand** (`StageController.onMagicWandTap` → `CrosswordLetterReveal(null)`): system picks
  a random unrevealed position. **Cost: 10 points.**
- **Targeted reveal** (tap the target/info button → `HelpOverlayCubit` highlights all remaining
  unrevealed positions via `onTargetTap` → tapping one → `CrosswordLetterReveal(index)`): player
  chooses exactly which letter. **Cost: 15 points** — correctly priced higher than the random
  option since it's strictly more valuable to the player.
- No cooldown, no daily/session cap beyond the player's point balance itself.
- Reveal logic: `RevealLetterUsecase` (`reveal_letter_usecase.dart`) also auto-completes any word
  whose *every* letter has now been revealed (line 65-91), even across multiple separate reveals.
- **XP is NOT reduced by hint usage.** `XPCalculator` (§ below) only factors in time, difficulty,
  and extra-words found — hint count never enters the formula. A player can hint through most of
  a stage and still earn full time-based XP as long as they finish quickly. Confirm with product
  whether this is intentional (letting hints be a pure points-sink, decoupled from XP) or a gap.

### Rewarded ads → rewards (`RewardedAdCubit`, `lib/config/ads/rewarded_cubit/`)
Full flow: `RewardedAdCubit.showAd(rewardConfig, context)` → SDK `.show()` →
`onUserEarnedReward` callback → `RewardUseCaseFactory.create(config).execute()`
(`rewarded_ad_usecase.dart:55-67`) → one of:
- `EarnPointsUseCase` → `PointsCubit.addPoints` + records a watch in `PointsAdLimitCubit`
  (rolling 24h window, capped at `AppValues.maxPointsAdWatchesPerDay = 3` — added this session,
  see §7 change log below).
- `StoreDiscountUseCase` → `StoreDiscountService.activateDiscount` (10h window, one active at a
  time — naturally capped by `hasActiveDiscount`).
- `FreezeRewardUseCase` → `FreezeCubit.incrementTotalFreezes` + `recordFreeAdWatched` (24h
  cooldown via `AppValues.freeFreezeRewardHours`).
- **Reward is only granted inside `onUserEarnedReward`**, which the Google Mobile Ads SDK only
  fires after confirmed ad completion (not spoofable from the Flutter side — this is the one
  place in the ad flow that's SDK-enforced, not app logic).
- **Rewarded ads do not grant XP Boosts directly** — despite the intuitive-sounding name, boosts
  are a **points-store purchase only** (see below), not an ad reward type. Ads fund boosts
  indirectly (ad → points → spend points on a boost).

### Store purchases → XP Boosts — real spoofing/desync bug
`AccountBoostCubit.activate()` (`account_boost_cubit.dart:66-90`):
```dart
await _updateBoost(boost, authState.user);   // grants + persists the boost FIRST
await pointsCubit.deductPoints(points);       // deducts points AFTER, return value ignored
```
`PointsCubit.deductPoints` (`points_cubit.dart:47-58`) returns `false` (no-op) if the balance is
insufficient — **but `activate()` never checks that return value.** The only guard against
buying a boost you can't afford is the UI (`CustomOfferButton.isDisabled`, checked against
`currentPoints` in a `BlocBuilder`, `offer_card.dart:89-105`) — purely cosmetic, not enforced by
the cubit. Any path that calls `activate()` without going through that exact button (double-tap
race, a future second entry point, state staleness between render and tap) grants the boost for
free. **This is the single clearest "reward granted before payment confirmed" bug in the
codebase** — fix by checking `deductPoints`'s return value and rolling back `_updateBoost` (or
reordering: deduct first, only activate on success).

---

## 4. XP & leveling — full formula trace

`StageXPService.calculateStageResults` (`stage_xp_service.dart:8-63`) orchestrates:
`StageDifficultyCalculator` → difficulty tier → `XPCalculator` → XP earned → progress-% delta.

### Difficulty score (`StageDifficultyCalculator.calculateDifficultyScore`, 0-100 scale)
Five weighted factors (`stage_difficulty_calculator.dart:23-42`):
1. Consonant ratio × 25 (`_calculateConsonantScore`) — more consonants in the letter set = harder.
2. Letter rarity × 20 (`_calculateLetterRarityScore`) — per-language rarity tables in
   `xp_constants.dart` (Greek/English letter frequency-derived weights).
3. Smallest word length × 20 (`_calculateSmallestWordScore`) — shorter minimum word = easier.
4. Word-availability ratio × 25 (`_calculateWordAvailabilityScore`) —
   `crosswordWordsCount / totalPossibleWords`; **low** ratio (few of the theoretically-possible
   words actually placed in the grid) → **high** difficulty score.
5. Crossword density × 10 (`_calculateCrosswordDensityScore`) — more words placed = harder.

`getDifficulty()` (line 44-65) maps score → tier (easy <30, normal <60, hard <80, veryHard
above), then clamps to a **per-level floor** (`minimumDifficulty`: level ≥8 → floor `hard`,
level ≥5 → floor `normal`, else `easy`) so late-game stages can't roll as trivially easy.

### ⚠️ Two previously-fixed bugs here — confirmed fixed, documenting for regression-awareness
Both fixed in commit `0616fb0` ("cleanup stage screen & complete game rules screens"). Verified
via `git log -p` on this file — no similar patterns found elsewhere in the codebase
(swept for `x * y / x`-style self-cancelling arithmetic project-wide).
- **Difficulty-classification arithmetic bug**: old `getDifficulty()` computed
  `calculateDifficultyScore() - (25 + (level * 5) / level)`. The `(level * 5) / level` term
  algebraically reduces to a **constant 5 for any nonzero level** — so despite referencing
  `level`, the per-level adjustment had zero real scaling effect; every stage effectively got the
  same flat `-30` regardless of player level. Current code replaces this with the explicit
  `minimumDifficulty` floor described above — a real, level-dependent effect.
- **Word-availability scoring inversion**: old `_calculateWordAvailabilityScore` returned *low*
  scores for *low* usage ratios (`< 0.2 → 0.2`, ..., default `1.0` for ratio ≥0.8) — backwards
  from intent. Current thresholds (line 104-114) are correctly flipped (`≥0.8 → 0.1`, ...,
  default `1.0` for ratio <0.2).

### XP formula (`XPCalculator.calculateTotalXP`, `xp_calculator.dart:16-34`)
```
totalXP = round(clamp(
  (baseXP × difficultyMultiplier × timeMultiplier + extraWordsBonus) × accountBoostMultiplier,
  10, 1000
))
```
- `baseXP` = `100 / level` + `crosswordWordPoints × 10.0` (line 36-42) — note this means base XP
  from level alone *shrinks* as level increases (100/1 = 100 vs 100/10 = 10); the per-word bonus
  dominates at higher levels.
- `difficultyMultiplier`: easy 0.8, normal 1.0, hard 1.2, veryHard 1.4 (line 44-57). **Minor doc
  drift**: the comment above this call (line 20) says "0.7 - 1.5x" but actual values are
  0.8-1.4x — harmless but worth fixing if touching this file.
- `timeMultiplier`: ratio of `actualTime / expectedTime` where `expectedTime = 30 + level×30 +
  crosswordWords×15` (`_calculateExpectedTime`, line 77-83); tiered from 1.5× (ratio <0.5, "super
  fast") down to 0.8× (ratio ≥2.0, "extremely slow") — see line 59-75 for the full ladder.
- `extraWordsBonus` = bonus/non-crossword words found × 8.0.
- Final multiplier = `AccountBoostCubit.currentMultiplier` (from an active store-purchased XP
  boost, default 1 if none active).
- Result converted to progress: `progressPercentage = xpEarned × 100 / XPConstants.getXPForLevel
  (level)`, added to `currentProgress` (`stage_xp_service.dart:47-49`). Level-up happens in
  `UserProfileService.updateAfterStage` when `newProgress >= 100` (wraps back to 0, increments
  `level` — `user_profile_service.dart:103-110`).
- `XPConstants.getXPForLevel` (`xp_constants.dart`): hardcoded thresholds for levels 1-9 (800 →
  9000), flat 12000 for level ≥10 — this function scales cleanly to arbitrary levels.

### 🐛 New finding — crash risk at level 11+, not previously flagged
`LevelProgressDifficulty.minWordsPerLevel` (`stage_criteria.dart`, inside the `wordCounts`
lookup) indexes a **hardcoded 10-element array per difficulty tier** with `wordCounts[index]
[level - 1]`. Since `XPConstants.getXPForLevel` explicitly supports levels ≥10 (flat 12000 XP),
the game clearly expects players to progress past level 10 — but `minWordsPerLevel(11)` (or
any level ≥11) indexes position 10 on a length-10 list → **`RangeError`, uncaught, will crash
stage generation** for any player who reaches level 11. This is a live, high-severity,
previously-unflagged bug — top priority for both a fix and a regression test (see §8).

---

## 5. Timers — implementation + edge cases

`StageTimerCubit` (`stage_timer_cubit.dart`), `Cubit<int>` = elapsed seconds.
- **Source of truth: tick-based, not wall-clock.** `_startTimer` (line 24-28) uses
  `Timer.periodic(Duration(seconds: 1), () => emit(state + 1))` — a plain incrementing counter,
  not a timestamp diff against a stored start time. This matters:
- **No `WidgetsBindingObserver`/`AppLifecycleState` handling exists anywhere in the codebase**
  (confirmed by project-wide search — zero matches). Backgrounding the app doesn't dispose the
  cubit (Flutter keeps the widget tree alive), but OS-level timer throttling in the background is
  platform-dependent and unaccounted for either way — elapsed *real* time while backgrounded is
  not reliably reflected in `state`.
- **Persistence only happens on `close()`** (`save()`, called from `close()` at line 42-46, and
  explicitly from `StageController.handleStageCompletion` via `timerCubit.saveAndClear()`). There
  is **no periodic/debounced save** during active play. If the process is killed (swiped away,
  OS memory pressure, crash) mid-stage without a clean widget disposal, all timer progress since
  the last explicit save is lost silently — next launch reads back a stale value via `_initialize`
  (`prefs.getInt(_timerKey) ?? 0`, line 18-22), understating real elapsed time.
- **Interaction with XP**: `timeInSeconds` (from `timerCubit.state` at completion,
  `stage_controller.dart:97`) feeds directly into `XPCalculator._getTimeMultiplier` (§4) — so any
  timer inaccuracy from the above directly skews the time-based XP bonus/penalty.
- **Interaction with hints**: none — hint usage doesn't pause or adjust the timer in any way; a
  hint-heavy playthrough is timed identically to a hint-free one.
- `pause()` is called on freeze activation (`StageController.onFreezeTap`, line 49-54) —
  cancels the periodic timer but doesn't persist; resumes are implicit (next `StageTimerCubit`
  construction restarts `_startTimer` from whatever `state` currently is in memory, not from a
  fresh read).

---

## 6. Dictionary system — structure + tradeoff notes

### Two separate asset pipelines, both gzip-compressed JSON, both under `assets/`
- **`assets/dictionary/`** (~20MB total: `dictionary_en.min.json.gz` ~10MB,
  `dictionary_el.min.json.gz` ~9.9MB): the full per-language word→data lookup, used for
  validating found words and looking up word metadata (`DictionaryService.cachedDictionary`).
  Loaded **eagerly, once, for the current language only** at startup
  (`main.dart:_loadInitialData` → `DictionaryService.loadDictionaryJson`, decompressed via
  `FileUtils.loadCompressedJson` — gunzip + UTF8 decode + full `json.decode` into memory, held as
  a single `Map<String, dynamic>` for the app's lifetime). The *other* language's dictionary is
  not loaded until the player switches languages.
- **`assets/stages/`** (~37MB total, split by word-length **and** language, e.g.
  `9_letter_words_en.min.json.gz` ~5.0MB up to `12_letter_words_en.min.json.gz` ~6.4MB — English
  files are consistently larger than Greek at the same length): pools of candidate stage words,
  grouped by their length. Used by `StageGeneratorService`/`WordSelectionService` to pick a
  puzzle's letter set.

### 🔍 Real (not just theoretical) perf issue: stage files are re-decompressed every single stage
`StageGeneratorService.generateStage` (`stage_generator_service.dart:38`) calls
`FileUtils.loadCompressedJson(filePath)` **fresh on every call — no caching by
language+word-length key.** Since a new stage is generated on every stage completion, this means
full gunzip + JSON-parse of a multi-MB file (up to 6.4MB) happens repeatedly through a normal
play session, not just once at startup. This is a genuine, low-effort-to-fix perf issue (an
in-memory `Map<String, Map<String,dynamic>>` cache keyed by `filePath` in
`StageGeneratorService` or a shared cache service would eliminate almost all of the repeat cost)
— distinct from the dictionary's one-time bundle-size tradeoff below, and worth prioritizing
higher since it's an ongoing per-interaction cost, not a one-time load.

### Bundle size / offline tradeoff (open design decision, not a defect)
~57MB of compressed word data bundled into the app for full offline play in both languages. This
is a deliberate tradeoff (offline capability vs. install size) rather than a bug. If install size
becomes a concern:
- **Per-language on-demand delivery** (Android App Bundle asset packs / iOS On-Demand Resources)
  would let a player who only ever plays Greek skip downloading the ~10MB English dictionary +
  ~19MB of English stage files (and vice versa) — biggest lever available, since language choice
  is already known (`LanguageCubit`) before any of this loads.
  loaded per word-length only when actually needed for stage generation — this is a smaller win
  since word-length distribution across levels isn't extremely skewed, but combined with the
  caching fix above it would reduce peak memory too.
- Current gzip compression is already reasonable; further min/compression gains are likely small
  relative to the on-demand-delivery option.

---

## 7. Known issues / tech debt (prioritized, consolidated from all sections above)

1. **Crash risk at level 11+** — `LevelProgressDifficulty.minWordsPerLevel` array
   out-of-bounds (`stage_criteria.dart`). §4. **Highest severity — will crash for any
   long-term player.**
2. **Cloud sync data loss** — asymmetric merge branches in `CloudSyncService._mergeUserData`
   silently drop local-only progress in two of three branches; unconditional last-write-wins
   `scheduleSync` has no reconciliation for concurrent multi-device play. §2. **Highest
   likelihood of silent, hard-to-diagnose user-facing data loss.**
3. **Broken Apple account-deletion path** — `reauthenticateWithApple` is dead code, only Google
   re-auth is wired up. §2. App Store compliance relevant.
4. **Boost purchase doesn't check payment success** — `AccountBoostCubit.activate` grants before
   confirming `deductPoints` succeeded, return value ignored. §3. Real exploitable/desync bug,
   currently only guarded by a cosmetic UI check.
5. **`AccountBoostCubit` never triggers cloud sync** — boost state changes only reach Firestore
   incidentally. §2.
6. **Stage-file re-decompression on every stage** — no caching in `StageGeneratorService`, real
   perf cost, low-effort fix. §6.
7. **Timer is tick-based with no lifecycle-aware persistence** — silent data loss and inaccurate
   XP time-bonus on force-kill; no `AppLifecycleState` handling exists anywhere in the app (not
   timer-specific — worth a general lifecycle-observer pass if this is ever addressed). §5.
8. Minor: stale doc comment in `xp_calculator.dart:20` ("0.7-1.5x" vs actual 0.8-1.4x). §4.
9. Minor: `shimmer` package declared in `pubspec.yaml` with **zero usages** anywhere in `lib/` —
   dead dependency.
10. Minor dead code: `WordSelectionService._getBannedStagesFromFile`,
    `WordSelectionService._clearUsedStages` (both unreferenced, flagged by `flutter analyze`);
    3 unused imports (`user_repository.dart:3`, `load_stage_usecase.dart:1-2`); a commented-out
    `addTestWords()` debug helper left in `user_profile_service.dart:54-94`.
11. `WordSelectionService.selectUnusedWord` has a `// TODO: get used words from the profile -
    selected language` (line 23) — `usedWords` is currently always `[]`, meaning the
    "used-word-avoidance" step 2 fallback (`_trySelectUsedStageWithNewWords`) never actually
    filters against words the player has already found; it's effectively a no-op filter today.
12. **Open question, not yet a confirmed defect**: no `firestore.rules` in this repo — can't
    verify server-side validation of any synced field exists at all. §2.

---

## 8. Testing gap — highest-risk untested flows

Zero unit/widget/integration tests exist. `test/widget_test.dart` is unmodified Flutter
boilerplate (a counter-app smoke test) that references a `MyApp` widget that no longer matches
the current `main.dart` entry point (`MyAppLoader`/`MyApp` split) — it would fail if run, and
tests nothing about this app. Ranked by (blast radius × silence of failure):

1. **`CloudSyncService._mergeUserData` / `_mergeProgressMaps`** — a regression here loses player
   progress with no error, no crash, nothing visibly wrong until a player notices their words are
   gone. Highest-value target for the first tests written in this codebase.
2. **`LevelProgressDifficulty.minWordsPerLevel` / `StageCriteria.fromLevelAndProgress`** — a
   single boundary test (`level: 11`) would have caught the crash bug in §4 immediately.
3. **`AccountBoostCubit.activate`** — a test asserting "insufficient points → no boost granted"
   would have caught the bug in §3.
4. **`XPCalculator.calculateTotalXP` / `StageDifficultyCalculator`** — core economy math, proven
   history of subtle bugs (§4's two fixed bugs), zero coverage means the next one ships silently.
5. **`RewardedAdCubit`/`rewarded_ad_usecase.dart` reward-granting use cases** — real-money-adjacent
   (ad revenue + points economy); a regression that double-grants or drops a reward is exactly
   the kind of thing that's invisible in manual QA but costly at scale.
6. **`StageTimerCubit`** — persistence-on-close-only behavior is easy to regress further (e.g. if
   someone "simplifies" the save call site) with no test to catch it.
7. **`WordSelectionService`** (stage selection/used-stage/banned-stage bookkeeping) — the
   used/banned `SharedPreferences` list logic is intricate (§7 item 11) and easy to break subtly.
8. **`AuthCubit._handleAuthenticatedUser`** — the guest→authenticated transition and its multiple
   branches (offline vs online, existing vs new Firestore doc) is exactly the kind of
   multi-branch state machine that regresses silently without tests.
