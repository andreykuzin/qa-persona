<!-- Thanks for opening a PR. Please skim this template — most fields are short. -->

## What this changes

<!-- One or two sentences. -->

## Why

<!-- The motivating problem or finding. Link issues if any. -->

## Scope

<!-- Which files touched. If it touches a SKILL.md, call out which subskill and what changed semantically (not just the diff). -->

## Tests / validation

<!-- Local equivalent of CI:
- shellcheck on templates
- `bash -n` on each .sh
- frontmatter check on every SKILL.md
- `jq` validation on plugin.json
- link check on SKILL.md template references

If you added a new subskill, did you also add the matching slash-command stub? Did CI's validate-subskills job catch any name/directory mismatch?
-->

## Methodology impact

<!-- Skip if not applicable. If this changes a SKILL.md or template, what does an agent now do differently? Could a plausible rationalization slip past the new wording? -->

## Maintainer checklist

- [ ] Plugin version bumped if behavior changed (`.claude-plugin/plugin.json`)
- [ ] CHANGELOG entry added
- [ ] CI green
