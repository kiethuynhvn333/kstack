# Verification case format

Shared by `fix-and-save-mistake` (writes cases) and `run-verification-tests` (runs them).
Each case is `skills/fix-and-save-mistake/cases/<short-descriptive-id>.md`. Keep its fixtures or
scripts beside it. Results go in `skills/run-verification-tests/runs/`.

Each case contains:
- **ID and title:** stable and descriptive; reuse the case for the same failure.
- **Incident:** the C- ID, or the observed wrong behavior if none exists.
- **Cause and fix:** confirmed cause vs guess, the file changed, what's still uncertain.
- **Type:** local script · live read-only check · agent behavior.
- **Inputs:** exact files or frozen prompt; dates, scope, account, prerequisites.
- **Run:** exact command, query, or agent steps.
- **Expected:** measurable pass conditions and why they're right; explicit fail conditions.
- **Negative control:** how to reproduce the original mistake and show the check catches it.
- **Limits:** what this doesn't prove. A missing dependency means UNABLE, never PASS.

Test the current, maintained source or a fresh agent response — not a correct answer pasted into
the test. Live numbers change: use dated expectations or invariants, never yesterday's exact count.

For agent behavior, give a fresh agent only the prompt, the fixtures and the normal repo — not the
incident story or the expected answer — then grade what it did. If no fresh agent is available,
record UNABLE; reading the instructions is not a pass.

Every run records: case ID, PASS / FAIL / UNABLE, what actually happened, evidence paths, date,
the source version tested, and any blocker. Never make a failing test pass by weakening it
without evidence and a written reason.
