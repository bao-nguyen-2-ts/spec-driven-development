---
description: Create or update a comprehensive backend API specification (dive-in.md) for the current feature using the dive-in template.
---

## User Input

```text
$ARGUMENTS
```

You **MUST** consider the user input before proceeding (if not empty).

## Outline

Goal: Generate a detailed backend API specification document at `FEATURE_DIR/dive-in.md` that serves as the complete technical reference for backend implementation and frontend integration.

This command creates a "dive-in" specification that documents:

- All API endpoints with complete request/response schemas
- Status definitions and state transitions
- Data models and database schemas
- Error responses and edge cases
- Integration requirements and business rules
- Frontend integration checklist

## Execution Steps

### 1. Initialize Feature Context

Run `.specify/scripts/bash/check-prerequisites.sh --json --paths-only` from repo root **once** to get feature paths.

Parse JSON output for:

- `FEATURE_DIR` - The feature directory path
- `FEATURE_SPEC` - Path to spec.md (if exists, use for context)
- `FEATURE_BRANCH` - Current feature branch name

**Handle Branch Validation Errors:**

If JSON parsing fails or FEATURE_DIR is missing (branch validation error):

1. Check if there's a branch mismatch (e.g., current branch is not a valid feature branch like `001-feature-name`)

2. **Present user with choices:**

```
⚠️ Branch Validation Issue Detected

Current branch: [CURRENT_BRANCH_NAME]
Expected format: NNN-feature-name (e.g., 001-cashback-tool, 002-voucher-mgmt)

How would you like to proceed?

A) **Continue with current branch** (Override validation)
   - Creates dive-in.md in the detected/specified feature directory
   - Use this if you're working on an existing feature or want manual control
   - You'll need to specify the feature directory if it can't be auto-detected

B) **Create a new feature branch** (Recommended for new features)
   - Run /speckit.specify to create a proper feature branch
   - Sets up complete feature directory structure
   - Then re-run this dive-in command

C) **Switch to existing feature branch**
   - Checkout an existing feature branch (e.g., 001-read-operations)
   - Then re-run this dive-in command

D) **Specify feature directory manually**
   - Provide the feature directory path directly (e.g., specs/001-read-operations)
   - Continue with current branch

Please respond with: A, B, C, or D
```

3. **Handle user response:**

   - **Option A (Continue)**: Ask for feature directory if not detected:

     - "Please provide the feature directory path (e.g., specs/001-read-operations):"
     - Validate the directory exists or can be created
     - Set FEATURE_DIR to provided path
     - Proceed to Step 2
     - Add warning comment in generated file: `<!-- Generated on non-standard branch: [BRANCH_NAME] -->`

   - **Option B (Create new)**:

     - Provide instructions: "Please run `/speckit.specify` first to create a feature branch, then re-run this command"
     - Exit command

   - **Option C (Switch branch)**:

     - List available feature branches if detectable (check specs/\*/ directories)
     - Provide instructions: "Run: `git checkout [branch-name]` then re-run this command"
     - Exit command

   - **Option D (Manual directory)**:
     - Same as Option A - ask for feature directory path
     - Proceed with validation

4. **If user provides feature directory manually:**
   - Verify directory exists or create it if it's under specs/
   - Look for existing spec.md in that directory for context
   - Continue with the command using the manual directory path

**Notes:**

- For single quotes in args like "I'm Groot", use escape syntax: `'I'\''m Groot'` (or double-quote: `"I'm Groot"`)
- When continuing with non-standard branch, document this in the generated dive-in.md file
- Always validate that the final FEATURE_DIR path is set before proceeding to Step 2

### 2. Load Context and Template

Load the following files for reference:

- `.specify/templates/dive-in-template.md` - The structural template
- `FEATURE_SPEC` (if exists) - For feature context and requirements

### 3. **MANDATORY: Obtain Backend API Specification**

**This step is REQUIRED before proceeding. You MUST have API specification content.**

**Step 3a: Check User Input for API Spec**

Examine \$ARGUMENTS to see if the user provided:

- Direct API specification content (endpoint details, schemas, etc.)
- A Confluence page URL/link containing the API spec
- Explicit statement that they will provide the spec

**Step 3b: If API Spec NOT Provided, Request Confluence Link**

If no API specification found in \$ARGUMENTS, you MUST ask:

```
**REQUIRED: Backend API Specification Source**

To generate a complete dive-in specification, I need the backend API documentation.

Please provide ONE of the following:

1. **Confluence Page URL**: Link to the backend API dive-in/specification page
   Format: https://your-org.atlassian.net/wiki/spaces/.../pages/...

2. **Direct API Specification**: Paste the API endpoint details directly
   (Include endpoints, request/response schemas, status definitions)

3. **Skip**: Type 'skip' only if you want to create a blank template
   (Not recommended - will require manual completion)

Your choice:
```

**Wait for user response. Do NOT proceed without this information.**

**Step 3c: Access Confluence Content via MCP**

If user provides a Confluence URL:

1. Extract the Confluence page URL from user's response
2. Use the appropriate MCP (Model Context Protocol) tool to access Confluence:

   - Look for available MCP tools for Confluence access
   - Common tools might include: `confluence_read`, `mcp_confluence_get_page`, or similar
   - Use the tool with the page URL to fetch the content

3. Parse the retrieved Confluence content:

   - Extract API endpoints and their details
   - Extract status definitions
   - Extract data models and schemas
   - Extract any example requests/responses
   - Extract integration notes and business rules

4. Store this parsed information for use in specification generation

**Step 3d: Process Direct API Spec Input**

If user provides direct API specification text:

1. Parse the provided specification for:

   - Endpoint definitions (method, path, parameters)
   - Request/response schemas
   - Status enums and transitions
   - Data models
   - Authentication requirements
   - Error responses

2. Validate that minimum required information is present:
   - At least one endpoint definition
   - At least one data model or entity
   - Status definitions (if applicable)

**Step 3e: Handle Skip Option**

If user chooses to skip:

1. Warn: "⚠️ Creating blank template - you will need to manually fill all sections"
2. Create a template with placeholder comments
3. Mark status as "Draft - Incomplete"
4. Add prominent `<!-- TODO: FILL BACKEND API DETAILS -->` markers

**Critical Rules:**

- You CANNOT proceed to step 4 without either Confluence content or direct API spec
- If Confluence access fails, ask user to paste content directly
- If user refuses to provide info, create blank template with warnings
- Document the source of API spec in the generated dive-in.md (Confluence URL or "Direct Input")

Extract from the obtained API spec or user's input:

- Feature name/title
- Related resources (ticket ID, PRD, Figma, Confluence links)
- Core entities/resources being managed
- Key workflows and operations

### 4. Interactive Information Gathering

If critical information is missing from the obtained API spec or user input, ask targeted questions:

**Present questions one at a time in this order (skip if already known):**

1. **Feature Name & Resources**

   - "What is the feature name?" (e.g., "Cashback Tool", "Voucher Management")
   - "What is the ticket ID?" (e.g., "EMA-7325")
   - "Provide links to PRD, Figma, and Confluence (or 'skip' if none)"

2. **Core Resources**

   - "What are the main resources/entities being managed?" (e.g., "cashbacks, result_tickets")
   - "What operations are needed?" (e.g., "list, create, update, delete, export, import")

3. **Status Definitions**

   - "What statuses can [entity] have?" (e.g., "init, processing, done, failed")
   - "Briefly describe what each status means"
   - Repeat for each major entity type

4. **Endpoints Structure**

   - "What base URL pattern is used?" (e.g., "portal-evo-vn-staging-internal.tsengineering.io/api")
   - "What authentication is required?" (e.g., "evo_operator role", "Bearer token")

5. **Data & Integration**
   - "Are there file upload/download operations?" (yes/no)
   - "Are there external service integrations?" (name them if yes)
   - "What database tables are involved?" (list table names)

**Rules for Information Gathering:**

- Ask maximum 10 questions total
- Accept short answers (user can elaborate in spec later)
- Make reasonable assumptions for minor details (document them)
- User can provide all info at once in \$ARGUMENTS to skip questions
- If user says "use spec" or "infer from spec", extract from FEATURE_SPEC

### 5. Generate Dive-In Specification

Using the dive-in-template.md structure and the obtained backend API specification, create a complete specification:

**For each section:**

a. **Overview**

- Write 2-3 paragraphs describing the feature
- Include purpose, problem solved, and key differences from similar features
- Add all related resource links (ticket, PRD, Figma, Confluence)

b. **Status Definitions**

- Create tables for each entity's statuses
- Include clear descriptions for each status value
- Group by entity type if multiple status sets exist

c. **API Endpoints**

- Define base URLs (staging, UAT, production)
- Specify required authentication/authorization
- Group endpoints by resource (following REST conventions)
- For each endpoint provide:
  - HTTP method and path
  - Clear description
  - All parameters (path, query, headers, body)
  - Request schema with types and constraints
  - Success response schema (200/201)
  - Error response schemas (400/401/403/404/409/422/500)
  - Any special notes or behaviors

d. **Common Endpoint Patterns**

- List operations: Include pagination (page_id, per_page), filtering, search
- Create operations: Include validation rules and initial status
- Get details: Include path parameters and full object response
- Update operations: PATCH for partial, PUT for full updates
- Delete operations: Note any cascade behaviors
- Custom actions: Document state changes and side effects
- File operations: Export (with limits), upload (with validation), download

e. **Data Models**

- Define TypeScript-style interfaces for each entity
- Include field types, constraints, and descriptions
- Document relationships between entities
- Add database schema updates if new tables/columns needed
- Use SQL syntax for schema changes

f. **Error Responses**

- Document all HTTP status codes used
- Provide example JSON for each error type
- Include specific error verdicts and messages

g. **State Transitions**

- Map out status transition diagrams
- Format: `[initial] → [trigger] → [final]`
- Note any special rules or irreversible transitions

h. **Integration Notes**

- Document external service dependencies
- Describe async processing mechanisms
- Note concurrency controls and rate limits
- List business logic constraints

i. **Frontend Integration Checklist**

- Create comprehensive TODO list for frontend developers
- Include all UI components needed
- List all API integration points
- Note validation rules and error handling requirements

**Quality Standards:**

- All endpoints must have complete request/response schemas
- All statuses must be clearly defined
- All state transitions must be documented
- Error responses must be comprehensive
- Examples should use realistic data
- Frontend checklist must be actionable

### 6. Validation

After generating the specification, validate:

**Completeness Checks:**

- [ ] All placeholder text replaced with actual content
- [ ] No `[PLACEHOLDER]` or `[TODO]` markers remain
- [ ] All endpoints have request/response schemas
- [ ] All statuses are defined and explained
- [ ] State transitions are complete
- [ ] Data models include all fields with types
- [ ] Error responses cover all HTTP codes used
- [ ] Frontend checklist is comprehensive

**Consistency Checks:**

- [ ] Status values match between definitions and endpoints
- [ ] Entity field names consistent across endpoints
- [ ] Data types consistent in requests/responses
- [ ] Terminology used consistently throughout
- [ ] No contradictory requirements or flows

**Quality Checks:**

- [ ] Endpoints follow REST conventions
- [ ] Authentication requirements clearly stated
- [ ] Pagination parameters consistent across list endpoints
- [ ] Error responses use standard verdict format
- [ ] Database schemas include proper indexes
- [ ] Integration notes mention all external dependencies

If validation fails:

1. List specific issues found
2. Fix issues automatically where possible
3. Mark unresolvable issues with `<!-- REVIEW: [issue description] -->` comments
4. Warn user about items needing review

### 7. Write Specification File

Write the complete specification to: `FEATURE_DIR/dive-in.md`

**IMPORTANT: Document API Specification Source**

At the top of the generated dive-in.md file, immediately after the "Related Resources" section, add:

```markdown
**API Specification Source**: [Confluence URL] | [Direct Input] | [Generated from spec.md]
**Retrieved On**: [YYYY-MM-DD]
```

**File Writing Rules:**

- Preserve exact template structure and heading hierarchy
- Use consistent markdown formatting
- Ensure code blocks have proper language tags (json, typescript, sql, bash)
- Add blank lines between major sections for readability
- Include last updated date and status at bottom

**Status Values:**

- Draft: Initial creation, may have incomplete sections
- Review: Complete but awaiting review
- Approved: Reviewed and approved for implementation
- Implemented: Backend implementation complete

Set status to "Draft" for initial creation.

### 8. Update Progress Report

**Update Progress Report** (if exists at `FEATURE_DIR/checklists/progress.md`):
- Update the "Stage 4: Dive-In" section to mark completion:
  - Change checkboxes from `- [ ]` to `- [X]` for completed items
  - Update **Status** from "Not started" to "Complete"
  - Add **Completed** field with current date
  - Update **Blockers** to "None" if completed successfully
- Update the "Quick Stats" section:
  - Increment "Stages Completed" count (e.g., from 3/8 to 4/8)
  - Update "Current Stage" to "Dive-In"
  - Update "Next Recommended" to `/speckit.plan`
  - Update percentage complete (e.g., from 37.5% to 50%)
- Update **Last Updated** timestamp at the top of the file
- Add **Artifacts** section documenting the dive-in specification
- Example update:
  ```markdown
  ### Stage 4: Dive-In ✓
  - [X] Backend API specification created
  - [X] Endpoint schemas documented
  - [X] Integration requirements defined
  - **Command**: `/speckit.dive-in`
  - **Completed**: [DATE]
  - **Status**: Complete
  - **Blockers**: None
  - **API Spec Source**: [Confluence URL / Direct Input / Generated]
  - **Endpoints Documented**: [N]
  - **Resources Covered**: [List]
  - **Artifacts**:
    - dive-in.md
    - checklists/progress.md (this file)
  ```

### 9. Generate Summary Report

Output a completion report with:

**Created Document:**

- Path: `FEATURE_DIR/dive-in.md`
- Feature: [Feature Name]
- Status: Draft
- Line count: [number]
- **API Spec Source**: [Confluence URL / Direct Input / Generated]

**Content Summary:**

- Total endpoints documented: [count]
- Resources covered: [list]
- Status definitions: [count]
- Data models: [count]
- Frontend checklist items: [count]
- Backend API documentation: [Complete / Partial / Template Only]

**Validation Results:**

- Completeness: [PASS/WARNINGS - list warnings]
- Consistency: [PASS/WARNINGS - list warnings]
- Quality: [PASS/WARNINGS - list warnings]

**Next Steps:**

1. Review `dive-in.md` for accuracy and completeness
2. Address any `<!-- REVIEW: ... -->` comments if present
3. Share with backend team for validation
4. Update status to "Review" when ready
5. Use checklist to guide frontend implementation

**Related Commands:**

- `/speckit.specify` - Update feature specification if needed
- `/speckit.plan` - Create implementation plan
- `/speckit.implement` - Begin implementation with this spec as reference

**Progress Status:**

- Stages completed: [N/8 - X%]
- Current stage: Dive-In
- Next recommended: `/speckit.plan`
- `/speckit.implement` - Begin implementation with this spec as reference

## Operating Principles

### Information Gathering

- **MANDATORY**: Always obtain backend API specification first (Confluence or direct input)
- Use MCP tools to access Confluence when user provides URL
- If MCP Confluence access fails, request user to paste content directly
- Prefer extracting from existing spec.md for supplementary context
- Make reasonable assumptions for standard patterns (REST conventions, common status flows)
- Document all assumptions in appropriate sections
- Document the source of API specification in the generated file
- Only ask critical questions that significantly impact the specification

### Template Usage

- Follow dive-in-template.md structure exactly
- Remove optional sections if not applicable (don't leave empty)
- Add sections if feature requires them (document why)
- Use dive-in-example.md for reference on tone and detail level

### Quality Standards

- Specifications must be implementation-ready
- All endpoints must have testable definitions
- Frontend developers should be able to build UI from this spec alone
- Backend developers should be able to implement APIs from this spec alone
- No ambiguity in status transitions or data models

### Error Handling

- **Branch validation errors**: Present user with 4 options (continue, create new branch, switch branch, or manual directory)
- **Missing feature directory**: Allow user to specify manually or guide them to create proper structure
- **Non-standard branch**: Allow override with warning comment in generated file
- If spec.md doesn't exist, proceed without it (use API spec and user input)
- If user provides insufficient info and won't answer questions, create draft with `<!-- REVIEW -->` markers
- If template is missing, use the example as fallback structure
- Always validate before writing final file

## Notes

- **REQUIREMENT**: Backend API specification must be provided (via Confluence URL or direct input)
- MCP tools will be used to fetch Confluence pages when URL is provided
- This command is typically run AFTER `/speckit.specify` but can be run independently
- The dive-in spec is more technical than spec.md (includes implementation details)
- This spec serves as the contract between backend and frontend teams
- Keep the spec updated as implementation progresses (status changes)
- Use this spec as the single source of truth for API behavior
- Always document the source of the API specification in the generated file

## Context

\$ARGUMENTS
