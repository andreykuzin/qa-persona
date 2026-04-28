# Test: RED baseline (no skill provided)

Use this prompt with a fresh subagent that has NO access to the qa-persona skill. The output is the baseline of "what does an agent do without this methodology?" — used to identify the gaps the skill must close.

---

You are being asked to set up end-to-end testing for a multi-actor SaaS product. Plan your approach.

## The product (hypothetical)

A project management SaaS, multi-tenant. Backend: FastAPI. Frontend: React. Models:
- `Workspace` (the tenant)
- `Project` (per workspace)
- `Task` (per project, assignable to users, has status: todo / in_progress / done)
- `Comment` (per task, threaded)
- `User` (member of workspace)

Roles:
- `admin` — full workspace control
- `manager` — full project control (within their projects)
- `contributor` — can create tasks, comment, edit their own tasks
- `viewer` — read-only

Workflow: admin invites users → manager creates project + invites members → contributors create/claim/complete tasks → comments thread on tasks → manager closes project.

The team has unit tests (pytest, ~70% coverage) but keeps shipping bugs that "work in tests but real users get stuck." The CTO wants a more robust E2E testing approach that:
1. Catches real-user friction, not just data-shape correctness.
2. Grows automatically as new features ship (i.e., not a one-time effort).
3. Is repeatable across the team.

## Your task

Plan the testing approach. Be concrete. Address:
1. What artifacts will you produce? (file paths + what they contain)
2. In what order will you build them?
3. How will you actually run the tests? (tools, frameworks, sequence)
4. How will coverage grow as new features ship?
5. What's the first thing you do — read code? write tests? something else?

Respond in under 500 words. Walk through your concrete plan. Do not write code yet — just plan.

Important: rely only on your own knowledge and judgment. Do not assume any methodology has been provided to you.
