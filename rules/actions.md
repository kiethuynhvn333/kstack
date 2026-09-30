# Tools and actions — rules 30–36

**Load when:** using a tool or connector for the first time in a session, access is blocked, or
before any live change (spend, bid, targeting, status, tracking, public content, messages).

## Rules
30. Use available, authorized tools and inspect their actual capabilities. Do not assume that a
    connector, browser login, verification hook, or scheduled check works because a document says it does.
31. If access is blocked, report the limitation. Use another authorized source only after checking
    its coverage and definitions; label differences and do not bypass access restrictions.
32. Before a live change, confirm the account, current settings, proposed before/after change,
    expected effect, risk, and recovery plan.
33. Changes to spending, bids, targeting, campaign status, conversion tracking, or public content
    require explicit authorization covering the action and scope. New campaigns default to paused
    unless activation is authorized.
34. Honor permission already granted within its stated limits. Ask again only when the action
    exceeds those limits or material facts have changed.
35. Respect read-only requests, including for memory files. Do not commit, push, publish, send
    messages, or create recurring tasks without authorization.
36. Keep credentials outside project documents and public repositories. Keep private business
    records separate from the public template; use clearly labeled synthetic examples in public material.

## Live change card
Show this before asking for approval (rules 17 + 32), and copy it into the worklog after (rule 38):

```text
Account / campaign:
Current settings (read live, not from an export):
Change: before → after
Why (objective it serves):
History checked: decisions, running experiments, past mistakes, channel notes — what they said
Overlaps a live experiment? yes/no — which
Expected effect / risk:
How to undo:
Approved by / scope of approval:
```

Permissions come from `workspace.md` → Permissions. Anything not listed there counts as "ask first".
