# Architecture

## Overview

This repository provides the **Spec Kit** - a collection of AI prompts and templates for implementing spec-driven development workflows in your projects.

## Repository Structure

```
spec-driven-development/
├── README.md                      # Setup instructions and quick start guide
├── ARCHITECTURE.md               # This file - architecture documentation
├── prompts/                      # Source prompts for Spec Kit workflow
│   ├── setup_prompts.sh         # Installation script for different IDEs
│   ├── SPECKIT_DOCUMENTATION.md # Core Spec Kit documentation
│   ├── speckit.analyze.md       # Cross-artifact consistency analysis
│   ├── speckit.checklist.md     # Quality checklist generation
│   ├── speckit.clarify.md       # Requirements clarification
│   ├── speckit.constitution.md  # Project constitution setup
│   ├── speckit.dive-in.md       # Deep dive into existing code
│   ├── speckit.implement.md     # Implementation workflow
│   ├── speckit.plan.md          # Implementation planning
│   ├── speckit.specify.md       # Specification generation
│   └── speckit.tasks.md         # Task breakdown
└── .specify/                     # Specification templates (to be added)
    └── templates/               # Specification document templates
```

## Technology Stack

- **Shell Scripting**: Bash scripts for prompt installation
- **Markdown**: Documentation and prompt definitions
- **AI Integration**: Compatible with multiple AI-powered IDEs

## Supported IDEs

The Spec Kit integrates with the following development environments:

| IDE                          | Configuration Directory | File Pattern          |
| ---------------------------- | ----------------------- | --------------------- |
| **GitHub Copilot** (VS Code) | `.github/prompts/`      | `speckit.*.prompt.md` |
| **Cursor**                   | `.claude/commands/`     | `speckit.*.md`        |
| **Claude Code**              | `.claude/commands/`     | `speckit.*.md`        |
| **Windsurf**                 | `.windsurf/prompts/`    | `speckit.*.md`        |
| **Kilo Code**                | `.kilocode/prompts/`    | `speckit.*.md`        |
| **Roo Code**                 | `.roo/prompts/`         | `speckit.*.md`        |

## Spec-Driven Development Workflow

The Spec Kit implements a structured approach to software development:

### 1. **Constitution** (`speckit.constitution`)

- Establishes project guidelines and principles
- Defines coding standards and architectural patterns
- Sets up team agreements and conventions

### 2. **Clarification** (`speckit.clarify`)

- Analyzes feature requests and requirements
- Asks clarifying questions
- Documents assumptions and constraints

### 3. **Specification** (`speckit.specify`)

- Generates detailed technical specifications
- Documents acceptance criteria
- Defines interfaces and contracts

### 4. **Planning** (`speckit.plan`)

- Creates implementation roadmap
- Breaks down work into tasks
- Identifies dependencies and risks

### 5. **Implementation** (`speckit.implement`)

- Guides step-by-step development
- Ensures adherence to specifications
- Maintains consistency across codebase

### 6. **Analysis** (`speckit.analyze`)

- Validates cross-artifact consistency
- Checks specification compliance
- Reviews code quality

### Supporting Workflows

- **Dive-In** (`speckit.dive-in`): Deep analysis of existing codebases
- **Tasks** (`speckit.tasks`): Granular task breakdown and tracking
- **Checklist** (`speckit.checklist`): Quality assurance checklists

## Installation Process

### User Setup Flow

1. **Download**: User copies `prompts/` and `.specify/` folders to their project
2. **Configure**: User runs `setup_prompts.sh <IDE>` to install prompts
3. **Initialize**: User creates project-specific `ARCHITECTURE.md`
4. **Start**: User begins using Spec Kit commands in their IDE

### Script Behavior

The `setup_prompts.sh` script:

1. Validates IDE argument
2. Determines target directory based on IDE
3. Creates target directory if needed
4. Copies prompt files with appropriate naming
5. Checks for existing files and only updates if changed
6. Reports installation status

## Key Design Decisions

### Multi-IDE Support

The architecture supports multiple IDEs through a unified script with IDE-specific directory mapping, allowing teams to use different tools while maintaining consistent workflows.

### Prompt-Based Architecture

Prompts are stored as standalone Markdown files, making them:

- Easy to version control
- Simple to customize per project
- Human-readable and editable
- IDE-agnostic in source form

### Specification Storage

The `.specify/` folder contains templates and generated specifications, keeping them:

- Separate from source code
- Easy to reference
- Organized by feature/component
- Version-controlled alongside code

## Extension Points

Teams can customize the Spec Kit by:

1. **Modifying Prompts**: Edit source prompts in `prompts/` directory
2. **Adding Custom Prompts**: Create new `speckit.*.md` files
3. **Customizing Templates**: Modify specification templates in `.specify/`
4. **Project Constitution**: Tailor guidelines in project-specific constitution

## Dependencies

### Runtime

- Bash shell (for setup script)
- AI-powered IDE with custom prompt support

### Development

- Text editor for prompt customization
- Git for version control

## Future Enhancements

Potential areas for expansion:

- Additional IDE integrations
- Specification validation tools
- Automated consistency checking
- Integration with project management tools
- Multi-language specification templates
- CI/CD integration for spec compliance

## References

- [Spec Kit Documentation](https://github.com/github/spec-kit)
- [GitHub Copilot Documentation](https://docs.github.com/en/copilot)
- [Cursor Documentation](https://cursor.sh/docs)
