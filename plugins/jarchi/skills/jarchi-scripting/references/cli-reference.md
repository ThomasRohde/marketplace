# Archi Command Line Interface Reference

Complete reference for running Archi and jArchi scripts headlessly.

## Basic CLI Syntax

### Windows (PowerShell)

```powershell
& "C:\Program Files\Archi\Archi.exe" -application com.archimatetool.commandline.app `
    -consoleLog -nosplash [options...]
```

### Windows (CMD)

```cmd
"C:\Program Files\Archi\Archi.exe" -application com.archimatetool.commandline.app ^
    -consoleLog -nosplash [options...]
```

### Linux

```bash
./Archi -application com.archimatetool.commandline.app \
    -consoleLog -nosplash [options...]
```

### macOS

```bash
Archi.app/Contents/MacOS/Archi -application com.archimatetool.commandline.app \
    -consoleLog -nosplash [options...]
```

## Core Options

| Option | Description |
|--------|-------------|
| `-application com.archimatetool.commandline.app` | Required: Launch CLI mode |
| `-consoleLog` | Show log output in console |
| `-nosplash` | Don't show splash screen |
| `-h`, `--help` | Show available options |
| `-a`, `--abortOnException` | Stop on first error |
| `-p`, `--pause` | Wait for RETURN key when done |

## Model Operations

### Create Empty Model

```powershell
--createEmptyModel
```

Creates a blank model and sets it as current.

### Create from Template

```powershell
--createEmptyModel "path/to/template.architemplate"
```

### Load Model

```powershell
--loadModel "path/to/model.archimate"
```

Loads existing model and sets it as current.

### Save Model

```powershell
--saveModel "path/to/output.archimate"
```

Saves current model to specified path.

### Import Another Model (Merge)

```powershell
--importModel "path/to/other.archimate"
--importModel.update                      # Update/replace objects
--importModel.updateAll                   # Update model metadata too
```

## Running Scripts

### Basic Script Execution

```powershell
--script.runScript "path/to/script.ajs"
```

### With Model

```powershell
& Archi.exe -application com.archimatetool.commandline.app -consoleLog -nosplash `
    --loadModel "model.archimate" `
    --script.runScript "process.ajs" `
    --saveModel "model.archimate"
```

### With Custom Arguments

Pass arguments after script options:

```powershell
& Archi.exe -application com.archimatetool.commandline.app -consoleLog -nosplash `
    --loadModel "model.archimate" `
    --script.runScript "export.ajs" `
    --outputPath "C:\Output" `
    --format "csv"
```

Access in script:

```javascript
// Parse arguments
function getArg(name) {
    var args = $.process.argv;
    for (var i = 0; i < args.length; i++) {
        if (args[i] === "--" + name || args[i] === "-" + name) {
            if (i + 1 < args.length) {
                return args[i + 1];
            }
        }
    }
    return null;
}

var outputPath = getArg("outputPath") || "./output";
var format = getArg("format") || "csv";
```

## Export Operations

### CSV Export

```powershell
--csv.export "path/to/output"
--csv.exportDelimiter ","                 # or ";" or "\t"
--csv.exportEncoding "UTF-8"              # or "UTF-8 BOM" or "ANSI"
--csv.exportFilenamePrefix "model_"
--csv.exportExcelCompatible               # Excel-friendly format
--csv.exportStripNewLines                 # Remove newlines from values
```

### HTML Report

```powershell
--html.createReport "path/to/output/folder"
```

### Jasper Reports

```powershell
--jasper.createReport "path/to/output"
--jasper.filename "report"
--jasper.title "Architecture Report"
--jasper.format "PDF,HTML,DOCX"           # Comma-separated formats
--jasper.template "path/to/main.jrxml"    # Custom template
--jasper.locale "en_US"
```

### Open Exchange XML

Export:
```powershell
--xmlexchange.export "path/to/output.xml"
--xmlexchange.exportFolders               # Include folder structure
--xmlexchange.exportLang "en"
```

Import:
```powershell
--xmlexchange.import "path/to/model.xml"
```

## Collaboration (Git)

### Load from Local Repository

```powershell
--modelrepository.loadModel "path/to/repo"
```

### Clone Remote Repository

```powershell
--modelrepository.cloneModel "https://github.com/user/repo.git"
--modelrepository.loadModel "path/to/local/repo"
--modelrepository.userName "username"
--modelrepository.passFile "path/to/password.txt"
```

### SSH Authentication

```powershell
--modelrepository.cloneModel "git@github.com:user/repo.git"
--modelrepository.loadModel "path/to/local/repo"
--modelrepository.identityFile "~/.ssh/id_rsa"
--modelrepository.passFile "path/to/passphrase.txt"
```

## Execution Priority

CLI providers execute in this order:

1. Load/Create Model (priority 10)
2. Import (priority 20)
3. Run Script (priority 30)
4. Report/Export (priority 40)
5. Save Model (priority 50)

This means you can combine options in any order:

```powershell
# These are equivalent:
--saveModel "out.archimate" --loadModel "in.archimate" --script.runScript "process.ajs"
--loadModel "in.archimate" --script.runScript "process.ajs" --saveModel "out.archimate"
```

## Linux Headless Mode

### Using xvfb-run (Recommended)

```bash
xvfb-run Archi -application com.archimatetool.commandline.app \
    -consoleLog -nosplash \
    --loadModel "model.archimate" \
    --script.runScript "script.ajs"
```

### Manual Xvfb

```bash
# Start virtual display
Xvfb :99 &
export DISPLAY=:99

# Run Archi
./Archi -application com.archimatetool.commandline.app \
    -consoleLog -nosplash \
    --loadModel "model.archimate" \
    --script.runScript "script.ajs"

# Stop virtual display
pkill -f 'Xvfb :99'
```

### Required Packages

```bash
# Debian/Ubuntu
apt install libgtk-3-0 xvfb

# RHEL/CentOS
yum install gtk3 xorg-x11-server-Xvfb
```

## Complete Examples

### PowerShell: Process and Export

```powershell
# process-model.ps1

$ArchiPath = "C:\Program Files\Archi\Archi.exe"
$ModelPath = "C:\Models\enterprise.archimate"
$ScriptPath = "C:\Scripts\update-docs.ajs"
$OutputPath = "C:\Output"

# Run script and export
& $ArchiPath -application com.archimatetool.commandline.app `
    -consoleLog -nosplash `
    --loadModel $ModelPath `
    --script.runScript $ScriptPath `
    --saveModel $ModelPath `
    --html.createReport $OutputPath

if ($LASTEXITCODE -eq 0) {
    Write-Host "Success!"
} else {
    Write-Host "Failed with exit code: $LASTEXITCODE"
    exit 1
}
```

### PowerShell: Batch Processing

```powershell
# batch-export.ps1

$ArchiPath = "C:\Program Files\Archi\Archi.exe"
$ModelsDir = "C:\Models"
$OutputDir = "C:\Reports"
$ScriptPath = "C:\Scripts\generate-report.ajs"

Get-ChildItem -Path $ModelsDir -Filter "*.archimate" | ForEach-Object {
    $modelName = $_.BaseName
    $modelPath = $_.FullName
    $outputPath = Join-Path $OutputDir $modelName

    Write-Host "Processing: $modelName"

    New-Item -ItemType Directory -Path $outputPath -Force | Out-Null

    & $ArchiPath -application com.archimatetool.commandline.app `
        -consoleLog -nosplash `
        --loadModel $modelPath `
        --script.runScript $ScriptPath `
        --outputDir $outputPath

    if ($LASTEXITCODE -ne 0) {
        Write-Host "  Failed!" -ForegroundColor Red
    } else {
        Write-Host "  Done" -ForegroundColor Green
    }
}
```

### Bash: CI/CD Integration

```bash
#!/bin/bash
# validate-model.sh

ARCHI_PATH="/opt/archi/Archi"
MODEL_PATH="$1"
SCRIPT_PATH="./scripts/validate.ajs"

if [ -z "$MODEL_PATH" ]; then
    echo "Usage: $0 <model.archimate>"
    exit 1
fi

# Run validation script
xvfb-run "$ARCHI_PATH" -application com.archimatetool.commandline.app \
    -consoleLog -nosplash \
    --loadModel "$MODEL_PATH" \
    --script.runScript "$SCRIPT_PATH"

EXIT_CODE=$?

if [ $EXIT_CODE -eq 0 ]; then
    echo "Validation passed!"
else
    echo "Validation failed!"
    exit 1
fi
```

### Bash: Docker Integration

```dockerfile
# Dockerfile
FROM ubuntu:22.04

RUN apt-get update && apt-get install -y \
    libgtk-3-0 \
    xvfb \
    wget \
    unzip

# Download and install Archi
RUN wget https://www.archimatetool.com/downloads/archi/Archi-Linux64.tgz \
    && tar -xzf Archi-Linux64.tgz -C /opt \
    && rm Archi-Linux64.tgz

# Copy scripts
COPY scripts/ /scripts/

ENTRYPOINT ["xvfb-run", "/opt/Archi/Archi", \
    "-application", "com.archimatetool.commandline.app", \
    "-consoleLog", "-nosplash"]
```

```bash
# Run container
docker run -v ./models:/models archi-cli \
    --loadModel /models/enterprise.archimate \
    --script.runScript /scripts/export.ajs \
    --csv.export /models/output
```

### PowerShell: Scheduled Task

```powershell
# scheduled-export.ps1
# Run daily to export architecture reports

$Date = Get-Date -Format "yyyy-MM-dd"
$ArchiPath = "C:\Program Files\Archi\Archi.exe"
$ModelPath = "C:\Models\enterprise.archimate"
$OutputBase = "C:\Reports\Daily"
$OutputPath = Join-Path $OutputBase $Date

# Create output directory
New-Item -ItemType Directory -Path $OutputPath -Force | Out-Null

# Generate reports
& $ArchiPath -application com.archimatetool.commandline.app `
    -consoleLog -nosplash `
    --loadModel $ModelPath `
    --html.createReport $OutputPath `
    --csv.export $OutputPath

# Log result
$LogPath = Join-Path $OutputBase "export.log"
$Result = if ($LASTEXITCODE -eq 0) { "SUCCESS" } else { "FAILED" }
"$Date $Result" | Out-File -Append $LogPath

# Clean up old reports (keep 30 days)
Get-ChildItem -Path $OutputBase -Directory |
    Where-Object { $_.CreationTime -lt (Get-Date).AddDays(-30) } |
    Remove-Item -Recurse -Force
```

## Troubleshooting

### Common Issues

**"No display" error on Linux:**
```bash
# Use xvfb-run
xvfb-run Archi ...

# Or set DISPLAY
export DISPLAY=:99
```

**Script not found:**
- Use absolute paths for scripts
- Check file permissions
- Verify .ajs extension

**Model not loading:**
- Check file path exists
- Verify .archimate extension
- Check file permissions

**Out of memory:**
```powershell
# Add JVM options
& Archi.exe -vmargs -Xmx4g [other options...]
```

### Debugging

Enable verbose logging:
```powershell
& Archi.exe -application com.archimatetool.commandline.app `
    -consoleLog -nosplash `
    -debug `
    --loadModel "model.archimate" `
    --script.runScript "script.ajs"
```

Check exit codes:
```powershell
& Archi.exe [options...]
Write-Host "Exit code: $LASTEXITCODE"
```
