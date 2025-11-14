#!/usr/bin/env bash
#
# setup_prompts.sh - Setup speckit prompts for your IDE
#
# Usage:
#   ./setup_prompts.sh <IDE>        # IDE argument is required
#   ./setup_prompts.sh cursor       # Setup for Cursor
#   ./setup_prompts.sh vscode       # Setup for VS Code
#   ./setup_prompts.sh claude       # Setup for Claude Code
#   ./setup_prompts.sh windsurf     # Setup for Windsurf
#   ./setup_prompts.sh kilocode     # Setup for Kilo Code
#   ./setup_prompts.sh roo          # Setup for Roo Code

set -e

# Color output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color

# Script directory
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"

# Prompt source files
PROMPT_FILES=(
    "speckit.analyze.md"
    "speckit.checklist.md"
    "speckit.clarify.md"
    "speckit.constitution.md"
    "speckit.dive-in.md"
    "speckit.implement.md"
    "speckit.plan.md"
    "speckit.specify.md"
    "speckit.tasks.md"
)

# IDE configurations
# Format: ide_name:target_dir:file_suffix:description
IDE_CONFIGS=(
    "vscode:.github/prompts:.prompt.md:GitHub Copilot (VS Code)"
    "cursor:.claude/commands::Cursor"
    "claude:.claude/commands::Claude Code"
    "windsurf:.windsurf/prompts::Windsurf"
    "kilocode:.kilocode/prompts::Kilo Code"
    "roo:.roo/prompts::Roo Code"
)

info() {
    echo -e "${CYAN}ℹ${NC} $1"
}

success() {
    echo -e "${GREEN}✓${NC} $1"
}

warning() {
    echo -e "${YELLOW}⚠${NC} $1"
}

error() {
    echo -e "${RED}✗${NC} $1"
}

show_banner() {
    echo -e "${BLUE}"
    cat << "EOF"
╔═══════════════════════════════════════════════════════╗
║        Spec Kit - IDE Prompts Setup                   ║
╚═══════════════════════════════════════════════════════╝
EOF
    echo -e "${NC}"
}

show_usage() {
    cat << EOF
Usage: $0 <IDE>

Setup speckit prompts for the specified IDE.

Arguments:
  IDE         Required. Specify which IDE to setup. Options:
              - vscode    : VS Code / GitHub Copilot
              - cursor    : Cursor
              - claude    : Claude Code
              - windsurf  : Windsurf
              - kilocode  : Kilo Code
              - roo       : Roo Code

Examples:
  $0 cursor       # Setup for Cursor
  $0 vscode       # Setup for VS Code

Supported IDEs:
  • GitHub Copilot (VS Code)  → .github/prompts/*.prompt.md
  • Cursor                     → .claude/commands/*.md
  • Claude Code                → .claude/commands/*.md
  • Windsurf                   → .windsurf/prompts/*.md
  • Kilo Code                  → .kilocode/prompts/*.md
  • Roo Code                   → .roo/prompts/*.md

EOF
}

detect_ide() {
    # Check for VS Code
    if [[ -n "$VSCODE_PID" ]] || [[ -n "$VSCODE_IPC_HOOK" ]] || [[ -d "$PROJECT_ROOT/.vscode" ]]; then
        echo "vscode"
        return 0
    fi
    
    # Check for Cursor
    if [[ -n "$CURSOR_PID" ]] || [[ -d "$PROJECT_ROOT/.cursor" ]] || [[ -f "$PROJECT_ROOT/.cursorrules" ]]; then
        echo "cursor"
        return 0
    fi
    
    # Check for Claude Code
    if [[ -d "$PROJECT_ROOT/.claude" ]] || command -v claude &> /dev/null; then
        echo "claude"
        return 0
    fi
    
    # Check for Windsurf
    if [[ -d "$PROJECT_ROOT/.windsurf" ]] || [[ -n "$WINDSURF_PID" ]]; then
        echo "windsurf"
        return 0
    fi
    
    # Check for Kilo Code
    if [[ -d "$PROJECT_ROOT/.kilocode" ]]; then
        echo "kilocode"
        return 0
    fi
    
    # Check for Roo Code
    if [[ -d "$PROJECT_ROOT/.roo" ]]; then
        echo "roo"
        return 0
    fi
    
    # Default to vscode if no detection
    return 1
}

get_ide_config() {
    local ide_name="$1"
    
    for config in "${IDE_CONFIGS[@]}"; do
        IFS=':' read -r name target_dir suffix desc <<< "$config"
        if [[ "$name" == "$ide_name" ]]; then
            echo "$target_dir|$suffix|$desc"
            return 0
        fi
    done
    
    return 1
}

setup_prompts() {
    local ide_name="$1"
    local config
    
    config=$(get_ide_config "$ide_name")
    if [[ $? -ne 0 ]]; then
        error "Unknown IDE: $ide_name"
        return 1
    fi
    
    IFS='|' read -r target_dir suffix desc <<< "$config"
    
    local full_target_dir="$PROJECT_ROOT/$target_dir"
    
    echo ""
    info "Setting up prompts for: ${BLUE}$desc${NC}"
    info "Target directory: ${YELLOW}$target_dir${NC}"
    echo ""
    
    # Create target directory
    if [[ ! -d "$full_target_dir" ]]; then
        mkdir -p "$full_target_dir"
        success "Created directory: $target_dir"
    else
        info "Directory already exists: $target_dir"
    fi
    
    # Copy and rename prompt files
    local copied_count=0
    local skipped_count=0
    
    for prompt_file in "${PROMPT_FILES[@]}"; do
        local source_file="$SCRIPT_DIR/$prompt_file"
        
        if [[ ! -f "$source_file" ]]; then
            warning "Source file not found: $prompt_file"
            continue
        fi
        
        # Determine target filename
        local target_filename
        if [[ -n "$suffix" ]]; then
            # Add suffix (e.g., .prompt.md for vscode)
            target_filename="${prompt_file%.md}${suffix}"
        else
            # Keep original name
            target_filename="$prompt_file"
        fi
        
        local target_file="$full_target_dir/$target_filename"
        
        # Copy file
        if [[ -f "$target_file" ]]; then
            # Check if files are different
            if ! diff -q "$source_file" "$target_file" > /dev/null 2>&1; then
                cp "$source_file" "$target_file"
                success "Updated: $target_filename"
                ((copied_count++))
            else
                info "Up to date: $target_filename"
                ((skipped_count++))
            fi
        else
            cp "$source_file" "$target_file"
            success "Created: $target_filename"
            ((copied_count++))
        fi
    done
    
    echo ""
    echo -e "${GREEN}═══════════════════════════════════════════════════════${NC}"
    success "Setup complete!"
    echo ""
    info "Summary:"
    echo "  • IDE: $desc"
    echo "  • Location: $target_dir"
    echo "  • Files copied/updated: $copied_count"
    echo "  • Files unchanged: $skipped_count"
    echo ""
    
    # IDE-specific instructions
    case "$ide_name" in
        vscode)
            info "Next steps for VS Code:"
            echo "  1. Restart VS Code to load new prompts"
            echo "  2. Use GitHub Copilot chat with @workspace"
            echo "  3. Type: @workspace /speckit.analyze (or any other speckit command)"
            ;;
        cursor)
            info "Next steps for Cursor:"
            echo "  1. Restart Cursor to load new prompts"
            echo "  2. Open Cursor chat (Cmd+L or Ctrl+L)"
            echo "  3. Type: /speckit.analyze (or any other speckit command)"
            ;;
        claude)
            info "Next steps for Claude Code:"
            echo "  1. Restart Claude Code to load new commands"
            echo "  2. Type: /speckit.analyze (or any other speckit command)"
            ;;
        windsurf)
            info "Next steps for Windsurf:"
            echo "  1. Restart Windsurf to load new prompts"
            echo "  2. Use the command palette to access prompts"
            ;;
        kilocode)
            info "Next steps for Kilo Code:"
            echo "  1. Restart Kilo Code to load new prompts"
            echo "  2. Access prompts through the Kilo interface"
            ;;
        roo)
            info "Next steps for Roo Code:"
            echo "  1. Restart Roo Code to load new prompts"
            echo "  2. Use the command palette to access prompts"
            ;;
    esac
    
    echo -e "${GREEN}═══════════════════════════════════════════════════════${NC}"
    echo ""
}

main() {
    show_banner
    
    local ide_name=""
    
    # Parse arguments
    if [[ $# -eq 0 ]]; then
        # No IDE specified - throw error
        error "IDE argument is required!"
        echo ""
        show_usage
        exit 1
    elif [[ "$1" == "-h" ]] || [[ "$1" == "--help" ]]; then
        show_usage
        exit 0
    else
        ide_name="$1"
        info "Using specified IDE: $ide_name"
    fi
    
    # Validate IDE name
    if ! get_ide_config "$ide_name" > /dev/null; then
        error "Invalid IDE: $ide_name"
        echo ""
        show_usage
        exit 1
    fi
    
    # Setup prompts
    setup_prompts "$ide_name"
}

main "$@"
