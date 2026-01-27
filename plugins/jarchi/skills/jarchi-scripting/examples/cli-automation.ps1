<#
.SYNOPSIS
    Archi CLI Automation Examples for PowerShell

.DESCRIPTION
    This script demonstrates various ways to run Archi and jArchi scripts
    from the command line using PowerShell. Includes examples for:
    - Running scripts on models
    - Batch processing multiple models
    - Exporting reports
    - CI/CD integration patterns

.NOTES
    Prerequisites:
    - Archi installed (with jArchi plugin for scripting)
    - PowerShell 5.1 or later

.EXAMPLE
    .\cli-automation.ps1 -Action "RunScript" -Model "C:\Models\enterprise.archimate" -Script "export.ajs"
#>

param(
    [string]$ArchiPath = "C:\Program Files\Archi\Archi.exe",
    [string]$Action = "Help",
    [string]$Model,
    [string]$Script,
    [string]$OutputDir
)

# ============================================
# Configuration
# ============================================

$ErrorActionPreference = "Stop"

# Verify Archi installation
function Test-ArchiInstalled {
    if (-not (Test-Path $ArchiPath)) {
        Write-Error "Archi not found at: $ArchiPath"
        Write-Host "Please install Archi from https://www.archimatetool.com/"
        exit 1
    }
}

# ============================================
# Helper Functions
# ============================================

function Invoke-ArchiCLI {
    param(
        [Parameter(Mandatory=$true)]
        [string[]]$Arguments
    )

    $baseArgs = @(
        "-application", "com.archimatetool.commandline.app",
        "-consoleLog",
        "-nosplash"
    )

    $allArgs = $baseArgs + $Arguments

    Write-Host "Running Archi CLI..." -ForegroundColor Cyan
    Write-Host "  $ArchiPath $($allArgs -join ' ')" -ForegroundColor Gray

    & $ArchiPath @allArgs

    if ($LASTEXITCODE -ne 0) {
        Write-Error "Archi CLI failed with exit code: $LASTEXITCODE"
        return $false
    }

    return $true
}

# ============================================
# Example 1: Run a Script on a Model
# ============================================

function Invoke-Script {
    param(
        [Parameter(Mandatory=$true)]
        [string]$ModelPath,
        [Parameter(Mandatory=$true)]
        [string]$ScriptPath
    )

    Write-Host "`n=== Running Script on Model ===" -ForegroundColor Green
    Write-Host "Model: $ModelPath"
    Write-Host "Script: $ScriptPath"

    $result = Invoke-ArchiCLI -Arguments @(
        "--loadModel", $ModelPath,
        "--script.runScript", $ScriptPath
    )

    if ($result) {
        Write-Host "Script completed successfully!" -ForegroundColor Green
    }
}

# ============================================
# Example 2: Run Script and Save Model
# ============================================

function Invoke-ScriptAndSave {
    param(
        [Parameter(Mandatory=$true)]
        [string]$ModelPath,
        [Parameter(Mandatory=$true)]
        [string]$ScriptPath,
        [string]$OutputPath
    )

    if (-not $OutputPath) {
        $OutputPath = $ModelPath
    }

    Write-Host "`n=== Running Script and Saving ===" -ForegroundColor Green
    Write-Host "Input: $ModelPath"
    Write-Host "Script: $ScriptPath"
    Write-Host "Output: $OutputPath"

    $result = Invoke-ArchiCLI -Arguments @(
        "--loadModel", $ModelPath,
        "--script.runScript", $ScriptPath,
        "--saveModel", $OutputPath
    )

    if ($result) {
        Write-Host "Model saved to: $OutputPath" -ForegroundColor Green
    }
}

# ============================================
# Example 3: Export Reports
# ============================================

function Export-Reports {
    param(
        [Parameter(Mandatory=$true)]
        [string]$ModelPath,
        [Parameter(Mandatory=$true)]
        [string]$OutputDir
    )

    Write-Host "`n=== Exporting Reports ===" -ForegroundColor Green
    Write-Host "Model: $ModelPath"
    Write-Host "Output: $OutputDir"

    # Create output directory
    if (-not (Test-Path $OutputDir)) {
        New-Item -ItemType Directory -Path $OutputDir -Force | Out-Null
    }

    $result = Invoke-ArchiCLI -Arguments @(
        "--loadModel", $ModelPath,
        "--html.createReport", $OutputDir,
        "--csv.export", $OutputDir
    )

    if ($result) {
        Write-Host "Reports exported to: $OutputDir" -ForegroundColor Green
        Get-ChildItem $OutputDir | ForEach-Object {
            Write-Host "  - $($_.Name)"
        }
    }
}

# ============================================
# Example 4: Batch Process Multiple Models
# ============================================

function Invoke-BatchProcess {
    param(
        [Parameter(Mandatory=$true)]
        [string]$ModelsDir,
        [Parameter(Mandatory=$true)]
        [string]$ScriptPath,
        [string]$OutputDir
    )

    Write-Host "`n=== Batch Processing Models ===" -ForegroundColor Green
    Write-Host "Models directory: $ModelsDir"
    Write-Host "Script: $ScriptPath"

    $models = Get-ChildItem -Path $ModelsDir -Filter "*.archimate"
    $total = $models.Count
    $success = 0
    $failed = 0

    Write-Host "Found $total model(s) to process`n"

    foreach ($model in $models) {
        Write-Host "Processing: $($model.Name)" -ForegroundColor Cyan

        $modelOutputDir = if ($OutputDir) {
            Join-Path $OutputDir $model.BaseName
            New-Item -ItemType Directory -Path $modelOutputDir -Force | Out-Null
        } else { $null }

        $args = @(
            "--loadModel", $model.FullName,
            "--script.runScript", $ScriptPath
        )

        if ($modelOutputDir) {
            $args += @("--outputDir", $modelOutputDir)
        }

        try {
            $result = Invoke-ArchiCLI -Arguments $args
            if ($result) {
                Write-Host "  Success" -ForegroundColor Green
                $success++
            } else {
                Write-Host "  Failed" -ForegroundColor Red
                $failed++
            }
        } catch {
            Write-Host "  Error: $_" -ForegroundColor Red
            $failed++
        }
    }

    Write-Host "`n=== Batch Processing Complete ===" -ForegroundColor Green
    Write-Host "Total: $total | Success: $success | Failed: $failed"
}

# ============================================
# Example 5: CI/CD Validation
# ============================================

function Test-ModelValidation {
    param(
        [Parameter(Mandatory=$true)]
        [string]$ModelPath,
        [string]$ValidationScript = "validate.ajs"
    )

    Write-Host "`n=== Model Validation ===" -ForegroundColor Green
    Write-Host "Model: $ModelPath"

    # Create a temporary validation script if not provided
    if (-not (Test-Path $ValidationScript)) {
        $tempScript = [System.IO.Path]::GetTempFileName() + ".ajs"
        @"
// Validation Script
if (!model.isSet()) {
    console.error("No model loaded");
    java.lang.System.exit(1);
}

var errors = [];

// Check for elements without names
\$("element").each(function(e) {
    if (!e.name || e.name.trim() === "") {
        errors.push("Unnamed element: " + e.type + " (ID: " + e.id + ")");
    }
});

// Check for orphaned elements
\$("element").each(function(e) {
    if (\$(e).rels().size() === 0 && \$(e).viewRefs().size() === 0) {
        errors.push("Orphaned element: " + e.name + " (" + e.type + ")");
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
}
"@ | Out-File -FilePath $tempScript -Encoding UTF8
        $ValidationScript = $tempScript
    }

    $result = Invoke-ArchiCLI -Arguments @(
        "--loadModel", $ModelPath,
        "--script.runScript", $ValidationScript,
        "-a"  # Abort on exception
    )

    if ($result) {
        Write-Host "Validation PASSED" -ForegroundColor Green
        return $true
    } else {
        Write-Host "Validation FAILED" -ForegroundColor Red
        return $false
    }
}

# ============================================
# Example 6: Scheduled Export Task
# ============================================

function Export-ScheduledReports {
    param(
        [Parameter(Mandatory=$true)]
        [string]$ModelPath,
        [Parameter(Mandatory=$true)]
        [string]$OutputBaseDir,
        [int]$RetentionDays = 30
    )

    Write-Host "`n=== Scheduled Report Export ===" -ForegroundColor Green

    $date = Get-Date -Format "yyyy-MM-dd"
    $outputDir = Join-Path $OutputBaseDir $date

    # Create dated output directory
    New-Item -ItemType Directory -Path $outputDir -Force | Out-Null

    Write-Host "Exporting to: $outputDir"

    $result = Invoke-ArchiCLI -Arguments @(
        "--loadModel", $ModelPath,
        "--html.createReport", $outputDir,
        "--csv.export", $outputDir
    )

    if ($result) {
        # Log success
        $logPath = Join-Path $OutputBaseDir "export.log"
        "$date SUCCESS" | Out-File -Append $logPath

        Write-Host "Export completed successfully!" -ForegroundColor Green
    } else {
        $logPath = Join-Path $OutputBaseDir "export.log"
        "$date FAILED" | Out-File -Append $logPath
    }

    # Cleanup old reports
    Write-Host "Cleaning up reports older than $RetentionDays days..."
    Get-ChildItem -Path $OutputBaseDir -Directory |
        Where-Object { $_.CreationTime -lt (Get-Date).AddDays(-$RetentionDays) } |
        ForEach-Object {
            Write-Host "  Removing: $($_.Name)"
            Remove-Item $_.FullName -Recurse -Force
        }
}

# ============================================
# Main Entry Point
# ============================================

Test-ArchiInstalled

switch ($Action) {
    "RunScript" {
        if (-not $Model -or -not $Script) {
            Write-Error "RunScript requires -Model and -Script parameters"
            exit 1
        }
        Invoke-Script -ModelPath $Model -ScriptPath $Script
    }

    "RunAndSave" {
        if (-not $Model -or -not $Script) {
            Write-Error "RunAndSave requires -Model and -Script parameters"
            exit 1
        }
        Invoke-ScriptAndSave -ModelPath $Model -ScriptPath $Script -OutputPath $OutputDir
    }

    "Export" {
        if (-not $Model -or -not $OutputDir) {
            Write-Error "Export requires -Model and -OutputDir parameters"
            exit 1
        }
        Export-Reports -ModelPath $Model -OutputDir $OutputDir
    }

    "Batch" {
        if (-not $Model -or -not $Script) {
            Write-Error "Batch requires -Model (directory) and -Script parameters"
            exit 1
        }
        Invoke-BatchProcess -ModelsDir $Model -ScriptPath $Script -OutputDir $OutputDir
    }

    "Validate" {
        if (-not $Model) {
            Write-Error "Validate requires -Model parameter"
            exit 1
        }
        $result = Test-ModelValidation -ModelPath $Model -ValidationScript $Script
        if (-not $result) { exit 1 }
    }

    "Scheduled" {
        if (-not $Model -or -not $OutputDir) {
            Write-Error "Scheduled requires -Model and -OutputDir parameters"
            exit 1
        }
        Export-ScheduledReports -ModelPath $Model -OutputBaseDir $OutputDir
    }

    default {
        Write-Host @"

Archi CLI Automation Script
===========================

Actions:
  RunScript   - Run a jArchi script on a model
  RunAndSave  - Run a script and save the model
  Export      - Export HTML and CSV reports
  Batch       - Process multiple models
  Validate    - Validate a model (CI/CD)
  Scheduled   - Scheduled export with cleanup

Examples:
  .\cli-automation.ps1 -Action RunScript -Model "model.archimate" -Script "update.ajs"
  .\cli-automation.ps1 -Action Export -Model "model.archimate" -OutputDir "C:\Reports"
  .\cli-automation.ps1 -Action Batch -Model "C:\Models" -Script "process.ajs"
  .\cli-automation.ps1 -Action Validate -Model "model.archimate"

"@
    }
}
