#Requires -Version 5.1
<#
.SYNOPSIS
    Install the free MotionSites Web Builder skill for OpenCode.

.DESCRIPTION
    Downloads the skill from the official Motionsites-AI/claude-skill repository
    and copies it to the OpenCode global skills directory, so OpenCode discovers
    it automatically. Nothing is vendored or re-hosted by this project.

.PARAMETER SkillDir
    OpenCode skills root. Defaults to $env:OPENCODE_SKILLS_DIR, or
    ~/.config/opencode/skills.

.PARAMETER Ref
    Branch, tag, or commit of the upstream repository. Defaults to "main".

.PARAMETER Force
    Replace an existing installation. Without it, the installer leaves the
    current copy untouched.

.EXAMPLE
    powershell -ExecutionPolicy Bypass -File .\install.ps1

.EXAMPLE
    .\install.ps1 -Force -Ref v1.0.0
#>
[CmdletBinding()]
param(
    [string]$SkillDir,
    [string]$Ref = "main",
    [switch]$Force
)

$ErrorActionPreference = "Stop"

if ($env:MOTIONSITES_REF -and -not $PSBoundParameters.ContainsKey("Ref")) {
    $Ref = $env:MOTIONSITES_REF
}
if ($env:MOTIONSITES_FORCE -eq "1") {
    $Force = $true
}

$Repo = "Motionsites-AI/claude-skill"
$Name = "motionsites-web-builder"

function Write-Step([string]$Message) {
    Write-Host "==> $Message" -ForegroundColor Cyan
}

function Write-Ok([string]$Message) {
    Write-Host "OK  $Message" -ForegroundColor Green
}

function Write-Warn([string]$Message) {
    Write-Host "!!  $Message" -ForegroundColor Yellow
}

if (-not $SkillDir) {
    if ($env:OPENCODE_SKILLS_DIR) {
        $SkillDir = $env:OPENCODE_SKILLS_DIR
    }
    else {
        $HomeDir = if ($HOME) { $HOME } elseif ($env:USERPROFILE) { $env:USERPROFILE } else { $null }
        if (-not $HomeDir) {
            throw "Could not find your home directory. Pass -SkillDir explicitly."
        }
        $SkillDir = Join-Path $HomeDir ".config\opencode\skills"
    }
}

$Target = Join-Path $SkillDir $Name

if ((Split-Path -Leaf $Target) -ne $Name) {
    throw "Refusing to install to an unexpected path: $Target"
}

$AlreadyInstalled = $false

if (Test-Path -LiteralPath $Target) {
    if (-not $Force) {
        Write-Warn "$Name is already installed at:"
        Write-Host "    $Target"
        Write-Host "    Re-run with -Force to update it."
        $AlreadyInstalled = $true
    }
    else {
        Write-Step "Removing the existing installation"
        Remove-Item -LiteralPath $Target -Recurse -Force
    }
}

$TempDir = $null
if (-not $AlreadyInstalled) {
    $TempDir = Join-Path ([System.IO.Path]::GetTempPath()) ("motionsites-" + [Guid]::NewGuid().ToString("N"))
    New-Item -ItemType Directory -Path $TempDir | Out-Null
}

try {
    if ($AlreadyInstalled) {
        return
    }

    try {
        [Net.ServicePointManager]::SecurityProtocol = [Net.ServicePointManager]::SecurityProtocol -bor [Net.SecurityProtocolType]::Tls12
    }
    catch {
        # PowerShell 7 / .NET Core does not need (and may reject) this setting.
    }

    $Url = "https://github.com/$Repo/archive/$Ref.zip"
    $ZipPath = Join-Path $TempDir "skill.zip"

    Write-Step "Downloading $Url"
    Invoke-WebRequest -Uri $Url -OutFile $ZipPath -UseBasicParsing

    Write-Step "Extracting"
    Expand-Archive -LiteralPath $ZipPath -DestinationPath $TempDir -Force

    $SkillMd = Get-ChildItem -LiteralPath $TempDir -Recurse -File -Filter "SKILL.md" |
        Where-Object { $_.Directory.Name -eq $Name } |
        Select-Object -First 1

    if (-not $SkillMd) {
        throw "Could not find $Name/SKILL.md in the downloaded archive. The upstream layout may have changed."
    }

    $SkillText = Get-Content -LiteralPath $SkillMd.FullName -Raw
    if ($SkillText -notmatch "(?m)^name:\s*$([regex]::Escape($Name))\s*$") {
        throw "SKILL.md does not look like the MotionSites skill (missing 'name: $Name')."
    }

    $Source = $SkillMd.Directory.FullName

    Write-Step "Installing to $Target"
    New-Item -ItemType Directory -Path $SkillDir -Force | Out-Null
    New-Item -ItemType Directory -Path $Target -Force | Out-Null
    Copy-Item -Path (Join-Path $Source "*") -Destination $Target -Recurse -Force

    $Required = @(
        "SKILL.md",
        "examples\INDEX.md",
        "media\MEDIA.md",
        "references\techniques\INDEX.md",
        "scripts\shoot.py"
    )
    foreach ($RelativePath in $Required) {
        if (-not (Test-Path -LiteralPath (Join-Path $Target $RelativePath))) {
            throw "Installation is incomplete: missing $RelativePath."
        }
    }

    $FileCount = (Get-ChildItem -LiteralPath $Target -Recurse -File).Count
    Write-Ok "Installed $FileCount files to $Target"
}
finally {
    if ($TempDir) {
        Remove-Item -LiteralPath $TempDir -Recurse -Force -ErrorAction SilentlyContinue
    }
}

Write-Host ""
Write-Host "Start a new OpenCode session and ask for a landing page, hero, portfolio or redesign." -ForegroundColor Green
Write-Host "The skill is picked up automatically. Examples:"
Write-Host '  - "Build a cinematic hero for a luxury sleep-tracking ring."'
Write-Host '  - "Hazme una landing para un estudio de arquitectura en Lisboa. Editorial y silenciosa."'
Write-Host '  - "Write a Lovable prompt for a waitlist page for my AI travel app."'
Write-Host ""
Write-Host "Source and license: https://github.com/$Repo"
