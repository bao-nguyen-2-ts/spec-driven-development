---
description: Execute the implementation planning workflow using the plan template to generate design artifacts.
---

## User Input

```text
$ARGUMENTS
```

You **MUST** consider the user input before proceeding (if not empty).

## Outline

1. **Setup**: Run `.specify/scripts/bash/setup-plan.sh --json` from repo root and parse JSON for FEATURE_SPEC, IMPL_PLAN, SPECS_DIR, BRANCH. For single quotes in args like "I'm Groot", use escape syntax: e.g 'I'\''m Groot' (or double-quote if possible: "I'm Groot").

2. **Load context**: Read FEATURE_SPEC, `dive-in.md` (for API specifications), and `.specify/memory/constitution.md`. Load IMPL_PLAN template (already copied). **CRITICAL**: Read `ARCHITECTURE.md` for technical context about project structure, patterns, and conventions.

3. **Execute plan workflow**: Follow the structure in IMPL_PLAN template to:
   - Fill Technical Context (mark unknowns as "NEEDS CLARIFICATION")
     - **Reference ARCHITECTURE.md** for:
       - Existing patterns and conventions
       - Technology stack and versions
       - Folder structure and module organization
       - Data flow patterns
       - Component composition patterns
       - API layer conventions
       - State management approach
   - Fill Constitution Check section from constitution
   - **CRITICAL**: Determine if this is NEW infrastructure/feature or REFACTOR of existing code
     - Default assumption: Create NEW standalone feature/infrastructure
     - Only plan refactors if explicitly requested in spec or user input
     - Mark Project Structure with "NEW" for new files, "EXISTING: No changes" for untouched files
     - If creating reusable framework, include demo/reference implementation instead of refactoring existing code
   - Evaluate gates (ERROR if violations unjustified)
   - Phase 0: Generate research.md (resolve all NEEDS CLARIFICATION)
   - Phase 1: Generate data-model.md, contracts/, quickstart.md
   - Phase 1: Update agent context by running the agent script
   - Re-evaluate Constitution Check post-design

4. **Update Progress Report** (if exists at `FEATURE_DIR/checklists/progress.md`):
   - Update the "Stage 5: Plan" section to mark completion:
     - Change checkboxes from `- [ ]` to `- [X]` for completed items
     - Update **Status** from "Not started" to "Complete"
     - Add **Completed** field with current date
     - Update **Blockers** to "None" if completed successfully
   - Update the "Quick Stats" section:
     - Increment "Stages Completed" count (e.g., from 4/8 to 5/8)
     - Update "Current Stage" to "Plan"
     - Update "Next Recommended" to `/speckit.tasks`
     - Update percentage complete (e.g., from 50% to 62.5%)
   - Update **Last Updated** timestamp at the top of the file
   - Add **Artifacts** section documenting planning artifacts
   - Example update:
     ```markdown
     ### Stage 5: Plan ✓
     - [X] Technical architecture defined
     - [X] Data models designed
     - [X] API contracts generated
     - [X] Research completed
     - **Command**: `/speckit.plan`
     - **Completed**: [DATE]
     - **Status**: Complete
     - **Blockers**: None
     - **Artifacts**:
       - plan.md
       - research.md
       - data-model.md
       - contracts/ (API specs)
       - quickstart.md
       - checklists/progress.md (this file)
     ```

5. **Stop and report**: Command ends after Phase 1 planning. Report:
   - Branch name
   - IMPL_PLAN path
   - Generated artifacts (research.md, data-model.md, contracts/, quickstart.md)
   - Progress status (e.g., "5/8 stages complete - 62.5%")
   - Path to updated progress report (if exists)
   - Next recommended command: `/speckit.tasks`

## Phases

### Phase 0: Outline & Research

1. **Extract unknowns from Technical Context** above:
   - **Consult ARCHITECTURE.md first** to check if patterns/solutions already exist
   - For each NEEDS CLARIFICATION → research task
   - For each dependency → best practices task (align with existing stack in ARCHITECTURE.md)
   - For each integration → patterns task (follow existing patterns in ARCHITECTURE.md)

2. **Generate and dispatch research agents**:

   ```text
   For each unknown in Technical Context:
     Task: "Research {unknown} for {feature context}"
   For each technology choice:
     Task: "Find best practices for {tech} in {domain}"
   ```

3. **Consolidate findings** in `research.md` using format:
   - Decision: [what was chosen]
   - Rationale: [why chosen]
   - Alternatives considered: [what else evaluated]

**Output**: research.md with all NEEDS CLARIFICATION resolved

### Phase 1: Design & Contracts

**Prerequisites:** `research.md` complete, `ARCHITECTURE.md` reviewed

1. **Extract entities from feature spec** → `data-model.md`:
   - Entity name, fields, relationships
   - Validation rules from requirements
   - State transitions if applicable
   - **Follow data flow patterns** documented in ARCHITECTURE.md

2. **Generate API contracts** from functional requirements:
   - **Read `dive-in.md` first** to get existing API specifications, endpoint details, request/response schemas
   - For each user action → endpoint (use API specs from dive-in as source of truth)
   - Use standard REST/GraphQL patterns
   - **Follow API Manager Pattern** from ARCHITECTURE.md
   - Map dive-in API endpoints to frontend API manager functions
   - Output contracts to `/contracts/` as **Markdown (.md) or JavaScript (.js) files ONLY**
   - Document API specifications in Markdown format or as JavaScript mock/example files
   - Do NOT create YAML, JSON schema, or other file extensions

3. **Create implementation guide** → `quickstart.md`:
   - **Reference architectural patterns** (hooks, contexts, component composition)
   - For reusable frameworks: Include demo/reference implementation examples
   - For new features: Include step-by-step integration guide following ARCHITECTURE.md conventions
   - Emphasize that existing code should NOT be modified unless explicitly requested
   - Document opt-in adoption patterns for framework features

4. **Agent context update**:
   - Run `.specify/scripts/bash/update-agent-context.sh copilot`
   - These scripts detect which AI agent is in use
   - Update the appropriate agent-specific context file
   - Add only new technology from current plan
   - Preserve manual additions between markers

**Output**: data-model.md, /contracts/*, quickstart.md, agent-specific file

## Key rules

- Use absolute paths
- ERROR on gate failures or unresolved clarifications
- **Default to NEW feature creation**: Unless explicitly requested, do NOT plan refactors of existing code
- **Mark file changes clearly**: Use "NEW" for new files, "EXISTING: No changes" for untouched files, "REFACTOR" only when explicitly requested
- **Framework features**: Should include demo/reference implementations rather than modifying existing domain code
- **Opt-in adoption**: Reusable infrastructure should be documented for future use, not forced onto existing features
