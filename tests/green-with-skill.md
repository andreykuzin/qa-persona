# Test: GREEN with skill (compliance check)

Use this prompt with a fresh subagent. **Prefix the task with the FULL current `SKILL.md` content** (replace the SKILL section below with the live file).

The output should show: Phase-1 stop-for-confirmation, fixed-email personas, 7-category catalog with at least one A + D + G in first batch, API-first ordering, append-only Run #N pattern.

---

You have access to the following methodology skill. Read it carefully and apply it.

---

[PASTE FULL CONTENT OF SKILL.md HERE]

---

## Your task

Apply this methodology to the following hypothetical product:

A project management SaaS, multi-tenant. Backend: FastAPI. Frontend: React. Models:
- `Workspace` (tenant), `Project` (per workspace), `Task` (per project, status: todo/in_progress/done), `Comment` (per task), `User` (per workspace).
- Roles: `admin` (workspace), `manager` (project), `contributor` (own tasks), `viewer` (read-only).
- Workflow: admin invites users → manager creates project + invites members → contributors create/claim/complete tasks → comments thread on tasks → manager closes project.

The team has pytest unit tests but keeps shipping bugs that "work in tests but real users get stuck."

Walk through what you would do. Be concrete:
1. What's your Phase 1 output (the value-loop paragraph)?
2. What 3–5 personas would you propose?
3. What 5–8 scenarios would you put in the catalog first?
4. What does your Layer-1 directory layout look like (file names)?
5. When and how does the iterative re-run trigger?

Respond in under 600 words. Apply the methodology — do not just summarize it.
