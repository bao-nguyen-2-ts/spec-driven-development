# Spec Kit Prompts Setup

This directory contains the Spec Kit prompts for spec-driven development workflow.

## Quick Start

### Step 1: Download Prompts and Specification Folder

First, download the `prompts/` folder and `.specify/` folder to your repository:

```bash
# Clone or download the spec-kit repository contents
# Copy the prompts folder to your project root
cp -r /path/to/spec-kit/prompts ./

# Copy the .specify folder to your project root (contains specification templates)
cp -r /path/to/spec-kit/.specify ./
```

Create an `ARCHITECTURE.md` file to describe your repository architecture:

```bash
touch ARCHITECTURE.md
```

See the [Architecture Documentation](#architecture-documentation) section below for guidance on what to include.

### Step 2: Configure Prompts for Your IDE

Run the setup script to configure prompts for your IDE (IDE argument is required):

```bash
# Specify your IDE
./prompts/setup_prompts.sh cursor
./prompts/setup_prompts.sh vscode
./prompts/setup_prompts.sh claude
./prompts/setup_prompts.sh windsurf
```

## Supported IDEs

The setup script supports the following IDEs:

| IDE                          | Target Directory     | Filename Pattern      | Notes                         |
| ---------------------------- | -------------------- | --------------------- | ----------------------------- |
| **GitHub Copilot** (VS Code) | `.github/prompts/`   | `speckit.*.prompt.md` | Files get `.prompt.md` suffix |
| **Cursor**                   | `.claude/commands/`  | `speckit.*.md`        | Original filenames preserved  |
| **Claude Code**              | `.claude/commands/`  | `speckit.*.md`        | Original filenames preserved  |
| **Windsurf**                 | `.windsurf/prompts/` | `speckit.*.md`        | Original filenames preserved  |
| **Kilo Code**                | `.kilocode/prompts/` | `speckit.*.md`        | Original filenames preserved  |
| **Roo Code**                 | `.roo/prompts/`      | `speckit.*.md`        | Original filenames preserved  |

## Available Prompts

The following Spec Kit prompts will be installed:

- `speckit.analyze.md` - Cross-artifact consistency analysis
- `speckit.checklist.md` - Quality checklist generation
- `speckit.clarify.md` - Requirements clarification
- `speckit.constitution.md` - Project constitution setup
- `speckit.dive-in.md` - Deep dive into existing code
- `speckit.implement.md` - Implementation workflow
- `speckit.plan.md` - Implementation planning
- `speckit.specify.md` - Specification generation
- `speckit.tasks.md` - Task breakdown

## Usage

### VS Code (GitHub Copilot)

After running the setup script:

1. Restart VS Code to load new prompts
2. Open GitHub Copilot chat
3. Use commands with `@workspace`:
   ```
   @workspace /speckit.analyze
   @workspace /speckit.plan
   @workspace /speckit.implement
   ```

### Cursor

After running the setup script:

1. Restart Cursor to load new prompts
2. Open Cursor chat (Cmd+L or Ctrl+L)
3. Use commands directly:
   ```
   /speckit.analyze
   /speckit.plan
   /speckit.implement
   ```

### Claude Code

After running the setup script:

1. Restart Claude Code to load new commands
2. Use commands directly in the chat:
   ```
   /speckit.analyze
   /speckit.plan
   /speckit.implement
   ```

### Other IDEs

Follow similar patterns for Windsurf, Kilo Code, and Roo Code. Check your IDE's documentation for how to access custom prompts/commands.

## IDE Selection

The setup script **requires** you to specify which IDE you're using:

```bash
./prompts/setup_prompts.sh <IDE>
```

**Available IDEs:**

- `cursor` - Cursor
- `vscode` - VS Code / GitHub Copilot
- `claude` - Claude Code
- `windsurf` - Windsurf
- `kilocode` - Kilo Code
- `roo` - Roo Code

**Example:**

```bash
./prompts/setup_prompts.sh cursor
```

## Manual Setup

If you prefer to manually copy prompts:

### For VS Code (GitHub Copilot)

```bash
mkdir -p .github/prompts
cp prompts/*.md .github/prompts/
# Rename files to add .prompt suffix
cd .github/prompts
for f in *.md; do mv "$f" "${f%.md}.prompt.md"; done
```

### For Cursor

```bash
mkdir -p .claude/commands
cp prompts/*.md .claude/commands/
```

### For Claude Code

```bash
mkdir -p .claude/commands
cp prompts/*.md .claude/commands/
```

## Updating Prompts

To update prompts after changes to the source files:

```bash
# Run the setup script again with your IDE
./prompts/setup_prompts.sh cursor
./prompts/setup_prompts.sh vscode
```

The script will:

- Skip files that are already up to date
- Update files that have changed
- Create new files if they don't exist

## Troubleshooting

### "IDE argument is required"

If you see this error, you need to specify which IDE you're using:

1. Run the script with your IDE: `./prompts/setup_prompts.sh cursor`
2. Available options: `cursor`, `vscode`, `claude`, `windsurf`, `kilocode`, `roo`
3. See usage help: `./prompts/setup_prompts.sh --help`

### Prompts not showing up

1. Restart your IDE after running the setup script
2. Check that files were created in the correct directory
3. Verify your IDE's settings for custom prompts/commands
4. For VS Code, ensure GitHub Copilot extension is installed and enabled

### Permission denied

If you get permission errors:

```bash
chmod +x prompts/setup_prompts.sh
```

## Architecture Documentation

Your `ARCHITECTURE.md` file should describe:

- **Repository Structure**: Key directories and their purposes
- **Technology Stack**: Languages, frameworks, and tools used
- **Module Organization**: How code is organized and module boundaries
- **Data Flow**: How data moves through the system
- **Key Dependencies**: External libraries and services
- **Build & Deployment**: How the project is built and deployed

This file helps the Spec Kit understand your codebase structure for better specification generation and implementation planning.

## More Information

For more details about the Spec Kit workflow, see:

- [ARCHITECTURE.md](./ARCHITECTURE.md) - Your repository architecture
- [Spec Kit Documentation](https://github.com/github/spec-kit)
