<#
.SYNOPSIS
    One-shot build of a xiaozhi-esp32 board firmware.

.DESCRIPTION
    For each board you own a separate firmware project folder. This script turns
    the whole manual dance into one invocation:

      0. (Optional bootstrap) If the project folder does not exist yet and -Clone
         is given, the script creates it, git-clones the upstream firmware repo
         (https://github.com/78/xiaozhi-esp32) into it, and checks out -Tag if
         given. Skipped when the folder already exists, so re-runs are unaffected.
      1. Activate the ESP-IDF v6.1 environment (dot-sources the Espressif EIM
         PowerShell profile -- the same thing the "IDF v6.1.0" desktop icon does).
      2. In the board's project folder, write the board / wake word / language /
         OTA-URL choices into sdkconfig.defaults.<target> -- this REPLACES the
         manual menuconfig steps (Target Board, wake word, language, OTA address).
      3. idf.py set-target <chip>
      4. idf.py build
      5. Stage build\xiaozhi.bin as <board>_<version>.bin under build\ota\ and
         print the path -- that app image is what you upload on the Console's
         Firmware Management page.

    Re-running the script for the same board just rebuilds; the settings persist
    in sdkconfig.defaults.<target> so future builds keep them.

    NOTE: on a git clone the script edits sdkconfig.defaults.<target>, which is a
    tracked upstream file, so the tree shows it as modified. Before switching to
    a newer tag/version, discard those local edits first:
        git restore sdkconfig.defaults.<target>
    then fetch + checkout the new tag; the script re-applies the settings fresh
    on its next run.

.PARAMETER Project
    Full path to the board's firmware project folder (its own clone/export), e.g.
    D:\DEV\Projects\xiaozhi-quandong-s3-dev\xiaozhi-esp32-v250

.PARAMETER Target
    ESP-IDF target (chip) for this board -- matches the board's config.json
    "target" field. Valid: esp32, esp32c3, esp32c5, esp32c6, esp32p4, esp32s3, esp32s31

.PARAMETER Board
    Board type/name -- the same string a device reports and the Console board
    dictionary entry (e.g. quandong-s3-dev). Drives the Kconfig board symbol
    (CONFIG_BOARD_TYPE_<BOARD>) and the staged .bin file name.

.PARAMETER WakeWord
    ESP-SR wake word model. Default wn9_jarvis_tts ("Jarvis").

.PARAMETER Language
    Firmware locale. Default en-US (CONFIG_LANGUAGE_EN_US).

.PARAMETER OtaUrl
    Firmware OTA address baked into the build. Default is the console-managed
    endpoint on this LAN; override if your server IP changes.

.PARAMETER IdfProfile
    Path to the Espressif EIM PowerShell profile that activates the IDF v6.1 env.

.PARAMETER NoActivate
    Skip the IDF-environment activation step (use if you already sourced it).

.PARAMETER NoBuild
    Stop after set-target + sdkconfig write (so you can review in menuconfig).

.PARAMETER Clone
    Bootstrap the project folder if it does not exist yet: create the parent,
    git clone the upstream firmware repo into $Project, then check out $Tag if
    set. Ignored when $Project already exists.

.PARAMETER RepoUrl
    Repository to clone when -Clone is used. Default is the upstream xiaozhi-esp32
    repo (https://github.com/78/xiaozhi-esp32.git).

.PARAMETER Tag
    Tag (or branch) to check out after cloning, e.g. v2.5.0. Empty (default)
    leaves the clone on its default branch (master).

.EXAMPLE
    .\tools\Build-XiaozhiFirmware.ps1 `
        -Project D:\DEV\Projects\xiaozhi-quandong-s3-dev\xiaozhi-esp32-v250 `
        -Target esp32s3 -Board quandong-s3-dev

    Builds the Espressif S3 board firmware with Jarvis wake word, en-US language,
    and the local OTA URL, then prints build\ota\quandong-s3-dev_2.5.0.bin.

.EXAMPLE
    .\tools\Build-XiaozhiFirmware.ps1 `
        -Project D:\DEV\Projects\mynewboard\xiaozhi-esp32-v250 `
        -Target esp32c3 -Board mynewboard `
        -Clone -Tag v2.5.0

    Clones the firmware repo into a fresh folder (creating the parent), pins it to
    the v2.5.0 tag, then activates IDF and builds as usual. Re-running when the
    folder already exists means -Clone is ignored and later runs just rebuild.
#>
[CmdletBinding()]
param(
    [Parameter(Mandatory = $true, Position = 0)]
    [string]$Project,

    [Parameter(Mandatory = $true, Position = 1)]
    [ValidateSet('esp32', 'esp32c3', 'esp32c5', 'esp32c6', 'esp32p4', 'esp32s3', 'esp32s31')]
    [string]$Target,

    [Parameter(Mandatory = $true, Position = 2)]
    [string]$Board,

    [string]$WakeWord = 'wn9_jarvis_tts',
    [string]$Language = 'en-US',
    [string]$OtaUrl = 'http://192.168.0.195:8002/xiaozhi/ota/',
    [string]$IdfProfile = 'C:\Espressif\tools\Microsoft.v6.1.PowerShell_profile.ps1',
    [switch]$NoActivate,
    [switch]$NoBuild,
    [switch]$Clone,
    [string]$RepoUrl = 'https://github.com/78/xiaozhi-esp32.git',
    [string]$Tag = ''
)

$ErrorActionPreference = 'Stop'

# ----------------------------------------------------------------------------
# Helpers
# ----------------------------------------------------------------------------
function Write-Step([string]$msg) {
    Write-Host ''
    Write-Host "=== $msg ===" -ForegroundColor Cyan
}

# Ensure a set of CONFIG_ keys in an sdkconfig.defaults file.
#  - clearPrefixes: any line (incl. '# CONFIG_X is not set' comments) whose key
#    starts with one of these prefixes is dropped first, so only one wake word /
#    one language survives.
#  - forceKeys: after clearing, each key is appended once (and any pre-existing
#    line with the same key is replaced).
function Set-SdkconfigKeys {
    param(
        [Parameter(Mandatory)][string]$file,
        [Parameter(Mandatory)][string[]]$clearPrefixes,
        [Parameter(Mandatory)][hashtable]$forceKeys
    )
    if (-not (Test-Path $file)) { throw "Defaults file not found: $file" }

    $lines = [System.Collections.Generic.List[string]]::new(
        [System.IO.File]::ReadAllLines($file))

    $kept = [System.Collections.Generic.List[string]]::new()
    foreach ($line in $lines) {
        $skip = $false
        foreach ($p in $clearPrefixes) {
            # plain "CONFIG_X=y" form
            if ($line.Trim().StartsWith($p)) { $skip = $true; break }
            # comment form "# CONFIG_X is not set"
            if ($line.Trim() -match "^#\s+($([regex]::Escape($p))[A-Za-z0-9_]*)\s+is not set") {
                $skip = $true; break
            }
        }
        if (-not $skip) { $kept.Add($line) }
    }

    foreach ($key in $forceKeys.Keys) {
        for ($i = $kept.Count - 1; $i -ge 0; $i--) {
            if ($kept[$i].Trim() -match "^$([regex]::Escape($key))=") { $kept.RemoveAt($i) }
        }
    }
    foreach ($key in $forceKeys.Keys) { $kept.Add("$key=$($forceKeys[$key])") }

    [System.IO.File]::WriteAllLines(
        $file, @($kept), (New-Object System.Text.UTF8Encoding($false)))
    Write-Host "Updated $file :"
    foreach ($key in $forceKeys.Keys) {
        Write-Host "  $key=$($forceKeys[$key])" -ForegroundColor Green
    }
}

# ----------------------------------------------------------------------------
# 1. Activate the ESP-IDF v6.1 environment
# ----------------------------------------------------------------------------
if ($NoActivate) {
    Write-Step "Skipping IDF activation (-NoActivate)"
}
elseif ($env:IDF_PATH -and (Get-Command 'idf.py' -ErrorAction SilentlyContinue)) {
    Write-Step "IDF environment already active (IDF_PATH=$env:IDF_PATH)"
}
else {
    if (-not (Test-Path $IdfProfile)) {
        throw "IDF activation profile not found: $IdfProfile  (set -IdfProfile)"
    }
    Write-Step "Activating ESP-IDF environment: $IdfProfile"
    . $IdfProfile
    if (-not (Get-Command 'idf.py' -ErrorAction SilentlyContinue)) {
        throw "idf.py is not available after loading the profile."
    }
}

# ----------------------------------------------------------------------------
# 2. Bootstrap (git clone) if requested, then validate the project
# ----------------------------------------------------------------------------
$Project = if (-not [System.IO.Path]::IsPathRooted($Project)) {
    if (Test-Path $Project) { (Resolve-Path $Project).Path }
    else { Join-Path (Get-Location) $Project }
} else { $Project }

if (-not (Test-Path $Project)) {
    if ($Clone) {
        $parent = Split-Path -Parent $Project
        New-Item -ItemType Directory -Force -Path $parent | Out-Null
        Write-Step "Cloning firmware repo: $RepoUrl"
        Write-Host "  into: $Project"
        git clone $RepoUrl $Project
        if ($LASTEXITCODE -ne 0) {
            throw "git clone failed (exit code $LASTEXITCODE)."
        }
        if ($Tag) {
            Write-Step "Checking out tag/branch: $Tag"
            Push-Location $Project
            try {
                git checkout $Tag
                if ($LASTEXITCODE -ne 0) {
                    throw "git checkout '$Tag' failed (exit code $LASTEXITCODE)."
                }
            }
            finally { Pop-Location }
        }
    }
    else {
        throw "Project folder not found: $Project  (use -Clone to create it from the firmware repo)"
    }
}
elseif ($Clone) {
    Write-Step "Project folder already exists (-Clone ignored): $Project"
}

$cmake = Join-Path $Project 'CMakeLists.txt'
if (-not (Test-Path $cmake)) { throw "No CMakeLists.txt in '$Project' - not an ESP-IDF project." }

$defaultsFile = Join-Path $Project "sdkconfig.defaults.$Target"
if (-not (Test-Path $defaultsFile)) {
    throw "Missing target defaults file: $defaultsFile"
}

# ----------------------------------------------------------------------------
# 3. Persist board / wake word / language / OTA URL (the manual menuconfig part)
# ----------------------------------------------------------------------------
$boardSymbol = 'CONFIG_BOARD_TYPE_' + ($Board.ToUpperInvariant() -replace '[^A-Z0-9]+', '_')
$wwSymbol    = 'CONFIG_SR_WN_' + $WakeWord.ToUpperInvariant()
$langSymbol  = 'CONFIG_LANGUAGE_' + ($Language -replace '-', '_').ToUpperInvariant()

# Wake-word models are chip-specific: the AFE "wn9_" models (e.g. Jarvis) are
# only selectable on esp32 / esp32s3 / esp32p4 / esp32s31. The lite chips
# (esp32c3 / esp32c5 / esp32c6) accept only the "wn9s_" models, so catch an
# invalid combo before the build fails inside Kconfig.
$liteChips = @('esp32c3', 'esp32c5', 'esp32c6')
if (($liteChips -contains $Target) -and ($WakeWord -notlike 'wn9s_*')) {
    Write-Host "WARNING: target '$Target' is a lite chip and only accepts 'wn9s_*'" -ForegroundColor Yellow
    Write-Host "         wake-word models. '$WakeWord' is an AFE model and will be rejected" -ForegroundColor Yellow
    Write-Host "         by Kconfig. Pass -WakeWord wn9s_xxxx if you meant a lite-chip model." -ForegroundColor Yellow
}

Write-Step "Applying persistent build settings to $defaultsFile"
Set-SdkconfigKeys -file $defaultsFile `
    -clearPrefixes @('CONFIG_SR_WN_', 'CONFIG_LANGUAGE_') `
    -forceKeys @{
        $boardSymbol = 'y'
        $wwSymbol    = 'y'
        $langSymbol  = 'y'
        'CONFIG_OTA_URL' = '"' + $OtaUrl + '"'
    }

# ----------------------------------------------------------------------------
# 4. Target + build
# ----------------------------------------------------------------------------
Push-Location $Project
try {
    Write-Step "idf.py set-target $Target"
    idf.py set-target $Target

    if ($NoBuild) {
        Write-Step "Stopped before build (-NoBuild). Review in menuconfig, then re-run without -NoBuild."
        return
    }

    Write-Step "idf.py build"
    idf.py build
}
finally {
    Pop-Location
}

# ----------------------------------------------------------------------------
# 5. Locate the app image and stage it for the Console Firmware page
# ----------------------------------------------------------------------------
$bin = Join-Path $Project 'build\xiaozhi.bin'
if (-not (Test-Path $bin)) {
    throw "Build finished but app image not found: $bin"
}

$version = $null
if (Test-Path $cmake) {
    $m = Select-String -Path $cmake -Pattern 'set\(PROJECT_VER\s+"([^"]+)"\)' | Select-Object -First 1
    if ($m) { $version = $m.Matches[0].Groups[1].Value }
}

$otaDir = Join-Path $Project 'build\ota'
New-Item -ItemType Directory -Force -Path $otaDir | Out-Null
$staged = Join-Path $otaDir "$Board`_$version.bin"
Copy-Item $bin $staged -Force

$sizeKB = [math]::Round((Get-Item $bin).Length / 1KB, 0)

Write-Step "BUILD COMPLETE"
Write-Host ''
Write-Host ("Board type : {0}" -f $Board) -ForegroundColor Green
Write-Host ("Reported ver: {0}" -f $version) -ForegroundColor Green
Write-Host ("App image  : {0}" -f $bin) -ForegroundColor Green
Write-Host ("Staged copy: {0}  ({1} KB)" -f $staged, $sizeKB)
Write-Host ''
Write-Host 'Upload to Console -> Firmware Management -> +Add New:' -ForegroundColor Yellow
Write-Host "  Firmware name : $Board`_$version" -ForegroundColor Yellow
Write-Host "  Type          : $Board   (must equal the device-reported board type)" -ForegroundColor Yellow
Write-Host "  Version       : $version   (must be numerically higher than the device's current version)" -ForegroundColor Yellow
Write-Host "  File          : the app image above (build\ota\$Board`_$version.bin)" -ForegroundColor Yellow
Write-Host ''
Write-Host 'Notes:' -ForegroundColor Yellow
Write-Host '  - A firmware image swaps only the app partition, so the first install of a new board'
Write-Host '    or any wake-word change still needs a USB flash. Later versions ride OTA.'
Write-Host "  - The OTA URL baked in is: $OtaUrl"
