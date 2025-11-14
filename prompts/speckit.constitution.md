---
description: Create or update the project constitution from interactive or provided principle inputs, ensuring all dependent templates stay in sync
---

## User Input

```text
$ARGUMENTS
```

You **MUST** consider the user input before proceeding (if not empty).

## Outline

You are updating the project constitution at `.specify/memory/constitution.md`. This file is a TEMPLATE containing placeholder tokens in square brackets (e.g. `[PROJECT_NAME]`, `[PRINCIPLE_1_NAME]`). Your job is to (a) collect/derive concrete values, (b) fill the template precisely, and (c) propagate any amendments across dependent artifacts.

Follow this execution flow:

0. **Verify Feature Branch Workflow**:

   - Check the current git branch name
   - If NOT on a feature branch (pattern: `###-feature-name` where ### is a number):
     - List existing feature branches to see if there's an appropriate one to checkout
     - If an existing feature branch exists for this work, checkout to it
     - If no suitable feature branch exists, create a new one:
       - Determine next sequential number (e.g., if `001-auth-flow` exists, next is `002`)
       - Generate branch name: `###-constitution-update` (or more specific based on user input)
       - Create and checkout the new feature branch from current branch
     - Inform user of branch switch/creation
   - If already on a feature branch, proceed
   - **EXCEPTION**: Only skip this check if user explicitly states this is a project-wide constitution update that should be on main/master branch

1. Load the existing constitution template at `.specify/memory/constitution.md`.

   - Identify every placeholder token of the form `[ALL_CAPS_IDENTIFIER]`.
     **IMPORTANT**: The user might require less or more principles than the ones used in the template. If a number is specified, respect that - follow the general template. You will update the doc accordingly.

1. Collect/derive values for placeholders:

   - If user input (conversation) supplies a value, use it.
   - Otherwise infer from existing repo context (README, docs, prior constitution versions if embedded).
   - For governance dates: `RATIFICATION_DATE` is the original adoption date (if unknown ask or mark TODO), `LAST_AMENDED_DATE` is today if changes are made, otherwise keep previous.
   - `CONSTITUTION_VERSION` must increment according to semantic versioning rules:
     - MAJOR: Backward incompatible governance/principle removals or redefinitions.
     - MINOR: New principle/section added or materially expanded guidance.
     - PATCH: Clarifications, wording, typo fixes, non-semantic refinements.
   - If version bump type ambiguous, propose reasoning before finalizing.

1. Draft the updated constitution content:

   - Replace every placeholder with concrete text (no bracketed tokens left except intentionally retained template slots that the project has chosen not to define yet—explicitly justify any left).
   - Preserve heading hierarchy and comments can be removed once replaced unless they still add clarifying guidance.
   - Ensure each Principle section: succinct name line, paragraph (or bullet list) capturing non‑negotiable rules, explicit rationale if not obvious.
   - Ensure Governance section lists amendment procedure, versioning policy, and compliance review expectations.

1. Consistency propagation checklist (convert prior checklist into active validations):

   - Read `.specify/templates/plan-template.md` and ensure any "Constitution Check" or rules align with updated principles.
   - Read `.specify/templates/spec-template.md` for scope/requirements alignment—update if constitution adds/removes mandatory sections or constraints.
   - Read `.specify/templates/tasks-template.md` and ensure task categorization reflects new or removed principle-driven task types (e.g., observability, versioning, testing discipline).
   - Read each command file in `.specify/templates/commands/*.md` (including this one) to verify no outdated references (agent-specific names like CLAUDE only) remain when generic guidance is required.
   - Read any runtime guidance docs (e.g., `README.md`, `docs/quickstart.md`, or agent-specific guidance files if present). Update references to principles changed.

1. Produce a Sync Impact Report (prepend as an HTML comment at top of the constitution file after update):

   - Version change: old → new
   - List of modified principles (old title → new title if renamed)
   - Added sections
   - Removed sections
   - Templates requiring updates (✅ updated / ⚠ pending) with file paths
   - Follow-up TODOs if any placeholders intentionally deferred.

1. Validation before final output:

   - No remaining unexplained bracket tokens.
   - Version line matches report.
   - Dates ISO format YYYY-MM-DD.
   - Principles are declarative, testable, and free of vague language ("should" → replace with MUST/SHOULD rationale where appropriate).

1. Write the completed constitution back to `.specify/memory/constitution.md` (overwrite).

1. **Create Initial Progress Report**:

   - At this point, you should be on a feature branch (enforced in step 0)
   - Create `specs/[branch-number-feature-name]/checklists/progress.md` with initial workflow tracking:

     ```markdown
     # Feature Development Progress: [FEATURE NAME from branch]

     **Feature Branch**: [BRANCH_NAME]
     **Created**: [DATE]
     **Last Updated**: [DATE]

     ## Workflow Stages

     This document tracks progress through the speckit development workflow.

     ### Stage 1: Constitution ✓

     - [x] Project constitution established
     - **Command**: `/speckit.constitution`
     - **Completed**: [DATE]
     - **Status**: Complete
     - **Version**: [CONSTITUTION_VERSION]

     ### Stage 2: Specify

     - [ ] Feature specification created
     - [ ] Requirements checklist generated
     - [ ] Progress tracking initialized
     - **Command**: `/speckit.specify`
     - **Status**: Not started
     - **Blockers**: None

     ### Stage 3: Clarify

     - [ ] Ambiguities identified and resolved
     - [ ] Clarifications documented in spec
     - **Command**: `/speckit.clarify`
     - **Status**: Not started
     - **Blockers**: Specify stage must complete first

     ### Stage 4: Dive-In

     - [ ] Backend API specification created
     - [ ] Endpoint schemas documented
     - [ ] Integration requirements defined
     - **Command**: `/speckit.dive-in`
     - **Status**: Not started
     - **Blockers**: Specify stage must complete first

     ### Stage 5: Plan

     - [ ] Technical architecture defined
     - [ ] Data models designed
     - [ ] API contracts generated
     - [ ] Research completed
     - **Command**: `/speckit.plan`
     - **Status**: Not started
     - **Blockers**: Spec must be finalized

     ### Stage 6: Tasks

     - [ ] Task breakdown generated
     - [ ] Dependencies identified
     - [ ] Execution order defined
     - **Command**: `/speckit.tasks`
     - **Status**: Not started
     - **Blockers**: Plan must be complete

     ### Stage 7: Analyze

     - [ ] Cross-artifact consistency verified
     - [ ] Constitution alignment checked
     - [ ] Coverage gaps identified
     - **Command**: `/speckit.analyze`
     - **Status**: Not started
     - **Blockers**: Tasks must be generated

     ### Stage 8: Implement

     - [ ] Implementation started
     - [ ] Tasks being executed
     - [ ] Code review in progress
     - **Command**: `/speckit.implement`
     - **Status**: Not started
     - **Blockers**: Analyze should pass

     ## Quick Stats

     - **Stages Completed**: 1/8 (12.5%)
     - **Current Stage**: Constitution
     - **Next Recommended**: `/speckit.specify`
     - **Estimated Completion**: TBD

     ## Notes

     - Constitution established as foundation for all feature development
     - All subsequent stages will validate against constitution principles
     - Progress tracking initialized automatically

     ## Stage Dependencies
     ```

     constitution → specify → clarify → dive-in → plan → tasks → analyze → implement
     ↓ (optional) ↓
     (required) (optional)

     ```

     - **Required Flow**: constitution → specify → plan → tasks → implement
     - **Recommended**: Include clarify after specify to reduce rework
     - **Optional**: dive-in provides detailed API specs for complex integrations
     - **Quality Gate**: analyze before implement catches issues early
     ```

   - Directory and file created automatically based on current feature branch name

1. Output a final summary to the user with:
   - New version and bump rationale.
   - Any files flagged for manual follow-up.
   - Path to created progress report (if applicable).
   - Suggested commit message (e.g., `docs: amend constitution to vX.Y.Z (principle additions + governance update)`).
   - Next recommended command: `/speckit.specify` if in a feature branch.

Formatting & Style Requirements:

- Use Markdown headings exactly as in the template (do not demote/promote levels).
- Wrap long rationale lines to keep readability (<100 chars ideally) but do not hard enforce with awkward breaks.
- Keep a single blank line between sections.
- Avoid trailing whitespace.

If the user supplies partial updates (e.g., only one principle revision), still perform validation and version decision steps.

If critical info missing (e.g., ratification date truly unknown), insert `TODO(<FIELD_NAME>): explanation` and include in the Sync Impact Report under deferred items.

Do not create a new template; always operate on the existing `.specify/memory/constitution.md` file.
