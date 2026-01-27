#!/bin/bash
#
# Archi CLI Automation Examples for Bash
#
# This script demonstrates various ways to run Archi and jArchi scripts
# from the command line. Includes examples for:
# - Running scripts on models
# - Batch processing multiple models
# - Exporting reports
# - CI/CD integration patterns
# - Headless Linux operation
#
# Prerequisites:
# - Archi installed (with jArchi plugin for scripting)
# - For Linux: xvfb-run for headless operation
#
# Usage:
#   ./cli-automation.sh <action> [options]
#
# Examples:
#   ./cli-automation.sh run-script --model model.archimate --script update.ajs
#   ./cli-automation.sh export --model model.archimate --output ./reports
#   ./cli-automation.sh batch --models-dir ./models --script process.ajs
#   ./cli-automation.sh validate --model model.archimate

set -e

# ============================================
# Configuration
# ============================================

# Default Archi path (adjust for your system)
if [[ "$OSTYPE" == "darwin"* ]]; then
    ARCHI_PATH="${ARCHI_PATH:-/Applications/Archi.app/Contents/MacOS/Archi}"
else
    ARCHI_PATH="${ARCHI_PATH:-/opt/Archi/Archi}"
fi

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
CYAN='\033[0;36m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# ============================================
# Helper Functions
# ============================================

log_info() {
    echo -e "${CYAN}[INFO]${NC} $1"
}

log_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

log_error() {
    echo -e "${RED}[ERROR]${NC} $1" >&2
}

log_warn() {
    echo -e "${YELLOW}[WARN]${NC} $1"
}

# Check if Archi is installed
check_archi() {
    if [[ ! -x "$ARCHI_PATH" ]]; then
        log_error "Archi not found at: $ARCHI_PATH"
        log_info "Please install Archi from https://www.archimatetool.com/"
        log_info "Or set ARCHI_PATH environment variable"
        exit 1
    fi
}

# Run Archi CLI with optional xvfb for headless Linux
run_archi_cli() {
    local args=("$@")

    local base_args=(
        "-application" "com.archimatetool.commandline.app"
        "-consoleLog"
        "-nosplash"
    )

    log_info "Running Archi CLI..."

    # Use xvfb-run on Linux if available and no display
    if [[ "$OSTYPE" == "linux"* ]] && [[ -z "$DISPLAY" ]]; then
        if command -v xvfb-run &> /dev/null; then
            log_info "Using xvfb-run for headless operation"
            xvfb-run "$ARCHI_PATH" "${base_args[@]}" "${args[@]}"
        else
            log_warn "xvfb-run not found. Install with: apt install xvfb"
            "$ARCHI_PATH" "${base_args[@]}" "${args[@]}"
        fi
    else
        "$ARCHI_PATH" "${base_args[@]}" "${args[@]}"
    fi
}

# ============================================
# Action: Run Script
# ============================================

action_run_script() {
    local model=""
    local script=""

    while [[ $# -gt 0 ]]; do
        case $1 in
            --model|-m) model="$2"; shift 2 ;;
            --script|-s) script="$2"; shift 2 ;;
            *) shift ;;
        esac
    done

    if [[ -z "$model" ]] || [[ -z "$script" ]]; then
        log_error "Usage: run-script --model <model.archimate> --script <script.ajs>"
        exit 1
    fi

    log_info "Running script on model"
    log_info "  Model: $model"
    log_info "  Script: $script"

    run_archi_cli --loadModel "$model" --script.runScript "$script"

    log_success "Script completed"
}

# ============================================
# Action: Run Script and Save
# ============================================

action_run_and_save() {
    local model=""
    local script=""
    local output=""

    while [[ $# -gt 0 ]]; do
        case $1 in
            --model|-m) model="$2"; shift 2 ;;
            --script|-s) script="$2"; shift 2 ;;
            --output|-o) output="$2"; shift 2 ;;
            *) shift ;;
        esac
    done

    if [[ -z "$model" ]] || [[ -z "$script" ]]; then
        log_error "Usage: run-and-save --model <model> --script <script> [--output <output>]"
        exit 1
    fi

    output="${output:-$model}"

    log_info "Running script and saving model"
    log_info "  Input: $model"
    log_info "  Script: $script"
    log_info "  Output: $output"

    run_archi_cli \
        --loadModel "$model" \
        --script.runScript "$script" \
        --saveModel "$output"

    log_success "Model saved to: $output"
}

# ============================================
# Action: Export Reports
# ============================================

action_export() {
    local model=""
    local output=""

    while [[ $# -gt 0 ]]; do
        case $1 in
            --model|-m) model="$2"; shift 2 ;;
            --output|-o) output="$2"; shift 2 ;;
            *) shift ;;
        esac
    done

    if [[ -z "$model" ]] || [[ -z "$output" ]]; then
        log_error "Usage: export --model <model.archimate> --output <directory>"
        exit 1
    fi

    mkdir -p "$output"

    log_info "Exporting reports"
    log_info "  Model: $model"
    log_info "  Output: $output"

    run_archi_cli \
        --loadModel "$model" \
        --html.createReport "$output" \
        --csv.export "$output"

    log_success "Reports exported to: $output"
    ls -la "$output"
}

# ============================================
# Action: Batch Process
# ============================================

action_batch() {
    local models_dir=""
    local script=""
    local output_dir=""

    while [[ $# -gt 0 ]]; do
        case $1 in
            --models-dir|-d) models_dir="$2"; shift 2 ;;
            --script|-s) script="$2"; shift 2 ;;
            --output|-o) output_dir="$2"; shift 2 ;;
            *) shift ;;
        esac
    done

    if [[ -z "$models_dir" ]] || [[ -z "$script" ]]; then
        log_error "Usage: batch --models-dir <dir> --script <script.ajs> [--output <dir>]"
        exit 1
    fi

    log_info "Batch processing models"
    log_info "  Models directory: $models_dir"
    log_info "  Script: $script"

    local total=0
    local success=0
    local failed=0

    for model in "$models_dir"/*.archimate; do
        [[ -f "$model" ]] || continue
        ((total++))

        local basename=$(basename "$model" .archimate)
        log_info "Processing: $basename"

        local args=(--loadModel "$model" --script.runScript "$script")

        if [[ -n "$output_dir" ]]; then
            local model_output="$output_dir/$basename"
            mkdir -p "$model_output"
            args+=(--outputDir "$model_output")
        fi

        if run_archi_cli "${args[@]}"; then
            log_success "  Completed: $basename"
            ((success++))
        else
            log_error "  Failed: $basename"
            ((failed++))
        fi
    done

    echo ""
    log_info "Batch processing complete"
    log_info "  Total: $total | Success: $success | Failed: $failed"

    [[ $failed -eq 0 ]] || exit 1
}

# ============================================
# Action: Validate Model (CI/CD)
# ============================================

action_validate() {
    local model=""
    local script=""

    while [[ $# -gt 0 ]]; do
        case $1 in
            --model|-m) model="$2"; shift 2 ;;
            --script|-s) script="$2"; shift 2 ;;
            *) shift ;;
        esac
    done

    if [[ -z "$model" ]]; then
        log_error "Usage: validate --model <model.archimate> [--script <validation.ajs>]"
        exit 1
    fi

    # Create default validation script if not provided
    if [[ -z "$script" ]]; then
        script=$(mktemp --suffix=.ajs)
        cat > "$script" << 'EOF'
// Validation Script
if (!model.isSet()) {
    console.error("No model loaded");
    java.lang.System.exit(1);
}

var errors = [];

// Check for elements without names
$("element").each(function(e) {
    if (!e.name || e.name.trim() === "") {
        errors.push("Unnamed element: " + e.type + " (ID: " + e.id + ")");
    }
});

// Check for orphaned elements (no relationships and not in any view)
$("element").each(function(e) {
    if ($(e).rels().size() === 0 && $(e).viewRefs().size() === 0) {
        errors.push("Orphaned element: " + e.name + " (" + e.type + ")");
    }
});

// Check for empty views
$("view").each(function(v) {
    if ($(v).children().size() === 0) {
        errors.push("Empty view: " + v.name);
    }
});

if (errors.length > 0) {
    console.error("Validation failed with " + errors.length + " error(s):");
    errors.forEach(function(err) {
        console.error("  - " + err);
    });
    java.lang.System.exit(1);
} else {
    console.log("Validation passed!");
    console.log("  Elements: " + $("element").size());
    console.log("  Relationships: " + $("relationship").size());
    console.log("  Views: " + $("view").size());
}
EOF
        trap "rm -f $script" EXIT
    fi

    log_info "Validating model"
    log_info "  Model: $model"

    if run_archi_cli --loadModel "$model" --script.runScript "$script" -a; then
        log_success "Validation PASSED"
        exit 0
    else
        log_error "Validation FAILED"
        exit 1
    fi
}

# ============================================
# Action: Scheduled Export
# ============================================

action_scheduled() {
    local model=""
    local output_base=""
    local retention_days=30

    while [[ $# -gt 0 ]]; do
        case $1 in
            --model|-m) model="$2"; shift 2 ;;
            --output|-o) output_base="$2"; shift 2 ;;
            --retention|-r) retention_days="$2"; shift 2 ;;
            *) shift ;;
        esac
    done

    if [[ -z "$model" ]] || [[ -z "$output_base" ]]; then
        log_error "Usage: scheduled --model <model> --output <base-dir> [--retention <days>]"
        exit 1
    fi

    local date=$(date +%Y-%m-%d)
    local output_dir="$output_base/$date"

    mkdir -p "$output_dir"

    log_info "Scheduled export"
    log_info "  Model: $model"
    log_info "  Output: $output_dir"

    local log_file="$output_base/export.log"

    if run_archi_cli \
        --loadModel "$model" \
        --html.createReport "$output_dir" \
        --csv.export "$output_dir"; then

        echo "$date SUCCESS" >> "$log_file"
        log_success "Export completed"
    else
        echo "$date FAILED" >> "$log_file"
        log_error "Export failed"
    fi

    # Cleanup old exports
    log_info "Cleaning up exports older than $retention_days days..."
    find "$output_base" -maxdepth 1 -type d -mtime +$retention_days -exec rm -rf {} \;
}

# ============================================
# Show Help
# ============================================

show_help() {
    cat << EOF

Archi CLI Automation Script
===========================

Usage: $0 <action> [options]

Actions:
  run-script    Run a jArchi script on a model
  run-and-save  Run a script and save the model
  export        Export HTML and CSV reports
  batch         Process multiple models
  validate      Validate a model (for CI/CD)
  scheduled     Scheduled export with cleanup

Options:
  --model, -m      Path to .archimate model file
  --script, -s     Path to .ajs script file
  --output, -o     Output directory
  --models-dir, -d Directory containing models (for batch)
  --retention, -r  Days to keep reports (for scheduled)

Environment:
  ARCHI_PATH       Path to Archi executable (default: /opt/Archi/Archi)

Examples:
  $0 run-script --model enterprise.archimate --script update.ajs
  $0 export --model enterprise.archimate --output ./reports
  $0 batch --models-dir ./models --script validate.ajs
  $0 validate --model enterprise.archimate
  $0 scheduled --model enterprise.archimate --output ./daily-reports

EOF
}

# ============================================
# Main Entry Point
# ============================================

check_archi

action="${1:-help}"
shift || true

case "$action" in
    run-script)
        action_run_script "$@"
        ;;
    run-and-save)
        action_run_and_save "$@"
        ;;
    export)
        action_export "$@"
        ;;
    batch)
        action_batch "$@"
        ;;
    validate)
        action_validate "$@"
        ;;
    scheduled)
        action_scheduled "$@"
        ;;
    help|--help|-h)
        show_help
        ;;
    *)
        log_error "Unknown action: $action"
        show_help
        exit 1
        ;;
esac
