# Setup — rules 1–8

**Load when:** `profile.md` or `workspace.md` is missing, the user says "set up" or "update my
setup", or a task needs an answer these files mark unknown.

## Rules
1. Read `profile.md` and `workspace.md` if they exist. Ask about missing information; do not repeat
   questions already answered.
2. Ask: What is your role, which businesses or clients do you support, and which parts of digital
   media do you own? How do you split the work (by brand, market, client, product line…)? Each
   split becomes a `<segment>` folder.
3. Ask: What business outcomes matter, how are they measured, and what are your current
   objectives, targets, and constraints? Each objective with its own target becomes a project.
4. Ask: How should we work together—language, answer length, level of explanation, and preferred
   deliverable formats?
5. Ask: Which actions may I take independently, which need approval, and who can approve spending,
   tracking changes, publication, and messages?
6. Ask: Which tools and data sources are available, which sources are trusted for each purpose,
   who or what can independently check a number (and how long it takes), and what timezone,
   currency, and review cadence should we use?
7. Ask in small batches. Let the user skip optional questions and start useful work; keep
   unanswered business facts and permissions marked unknown. An unknown permission means "ask first".
8. When editing is allowed, show the proposed content, then save confirmed working preferences in
   `profile.md` and business, tool, and permission settings in `workspace.md`. Keep actual company
   and client configuration private. Revisit setup when the user asks or an answer is outdated.

## What setup produces
| Answer from | Saved to |
|---|---|
| Rule 4 (working style) | `profile.md` |
| Rules 2, 3, 5, 6 (business, objectives, permissions, tools, timezone, currency, cadence) | `workspace.md` |
| Each objective (rule 3) × each segment (rule 2) | `projects/<objective>/<segment>/` copied from `projects/_template/` |

Start from `profile.example.md` and `workspace.example.md`. Unknown answers stay in the file as
`unknown`, never deleted, so the next session knows what is still missing.

## Done when
- Both files exist and the user has confirmed their content.
- Every project folder has a `worklog.md` and each segment has the four tracking files.
- The first worklog entry records that setup ran, what was answered, and what is still unknown.
