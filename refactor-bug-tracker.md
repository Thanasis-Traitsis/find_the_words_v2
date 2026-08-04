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

## 🟢 Low-risk cleanup — batch with general refactor work

| # | Bug | File | Status |
|---|---|---|---|
| 6 | Stage-word files get re-decompressed on every single stage generation, no caching. Cheap, isolated perf fix. | stage generation | Open |

## Already confirmed fixed (verified via commit 0616fb0)
- Difficulty-classification operator-precedence bug
- Word-availability crossword-ratio inversion

---
*Keep this file updated as phases complete. Add new findings here as Claude Code surfaces them during refactor work.*