# AGENTS.md

Guidance for AI coding agents working in **specifications-BASE**.

## What this repo is

`specifications-BASE` is the **document + model source** for the openEHR **BASE** (Base Model) component — the foundational type system that the RM, AM and LANG components build on. It is a *specification* repo, not software: the deliverables are the HTML specs at https://specifications.openehr.org/releases/BASE/. Sources are **AsciiDoc** prose plus the **BMM** schema `computable/BMM/openehr_base_1.3.0.bmm.json`; the committed `docs/*.html` files are build artefacts.

`manifest.json` is the source of truth for which documents exist, their `spec_status`, releases, and the `SPECBASE` Jira roadmap. Published documents: `architecture_overview`, `foundation_types`, `base_types`, `resource` (plus `iso_18308_conformance_statement`, an external-PDF link, not an `.adoc`).

## Use the `openehr-specs@openehr` plugin

The plugin carries the spec-authoring know-how — **prefer its skills/agents over ad-hoc edits.** Don't re-derive their workflows here.

| Task | Use |
|------|-----|
| Create/edit a spec, chapter, `master.adoc`, or `manifest.json` | skill `openehr-specs:authoring` |
| Spec prose style — overviews, semantics, design rationale | skill `openehr-specs:content-patterns` |
| Regenerate class tables/diagrams from BMM (`bmm-publisher`) | skill `openehr-specs:class-generation` |
| Amendment record (`master00-amendment_record.adoc`) | skill `openehr-specs:amendment-record` |
| Releases, CR/PR, lifecycle status, Jira workflow | skill `openehr-specs:governance` |
| Quality / convention review of a document | skill `openehr-specs:review` |
| Whole-document convention review (all chapters) | agent `openehr-specs:spec-reviewer` |
| Fact-check class/attribute/function names in prose | agent `openehr-specs:identifier-grounding` |
| Audit `{openehr_*}` attributes + `<<anchor>>` cross-refs | agent `openehr-specs:xref-auditor` |

## BASE-specific invocations

No build tooling lives in this repo; all `specifications-XX` repos are cloned as siblings under one parent (`/src/openehr`).

```bash
# render HTML — run from the parent dir (/src/openehr); flags: -r remote CSS · -p PDF · -f force · -l Release-1.3.0
specifications-AA_GLOBAL/bin/spec_publish.sh BASE

# regenerate class tables (NEVER hand-edit docs/UML/classes/*.adoc) — run in ../bmm-publisher
./bin/bmm-publisher legacy-adoc openehr_base_1.3.0 -o /src/openehr/specifications-BASE/docs/UML/classes
```

To change a class/attribute/function/invariant, edit the BMM schema and regenerate — never touch the generated tables (see skill `openehr-specs:class-generation`).
