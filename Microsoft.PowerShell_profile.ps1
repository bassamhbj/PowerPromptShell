# Comment out if use Terminal-Icons
#Import-Module -Name Terminal-Icons

$GIT_GLYPH = $([char]0xf113)
$BRANCH_GLYPH = $([char]0xe0a0)
$PYTHON_GLYPH = $([char]0xe235)
$SEPARATOR_RIGHT_GLYPH = $([char]0xe0b0)
$SEPARATOR_LEFT_GLYPH = $([char]0xe0b2)
$FOLDER_GLYPH = $([char]0xf115)
$WARNING_GLYPH = $([char]0xf071)
$PROMPT_GLYPH = $([char]0xe0b1)

function GetAdminDetails {
    $isAdmin = (New-Object Security.Principal.WindowsPrincipal ([Security.Principal.WindowsIdentity]::GetCurrent())).IsInRole([Security.Principal.WindowsBuiltinRole]::Administrator)
 
    return $(if ($isAdmin) { " Admin:Enabled " } else { " Admin:Disabled " })
}

function GetGitRepoDetails {
    # Check if git is enabled in the current directory
    $isGitRepo = git rev-parse --git-dir
    $repoDetails = "----"

    if($isGitRepo){
        $repo = git config --get remote.origin.url

        if($repo) {
            $repoName = $repo.split("/") | Select-Object -Last 1
            $branch = git branch --show-current
            $repoDetails = "$repoName $BRANCH_GLYPH $branch"
        } else {
            $repoName = "$WARNING_GLYPH GIT NOT INITIATED $WARNING_GLYPH"
        }
    }
    
    return " $GIT_GLYPH $repoDetails"
}

function GetFolderDetails {
    $currentFolder = Split-Path -Path $pwd -Leaf

    return " $FOLDER_GLYPH $currentFolder "
}

function GetDateDetails {
    $date = Get-Date -Format 'dddd hh:mm:ss tt'
    
    return " $date "
}

function GetEmptySeparator {
    param (
        [int]$PromptLength,
        [int]$DateLength
    )
    
    $promptTotalLength = $host.ui.RawUI.WindowSize.Width
    $emptyStringLength = $promptTotalLength - $PromptLength - $DateLength

    $emptySeparator = ""

    for ($i = 0; $i -lt $emptyStringLength; $i++) {
        $emptySeparator += " "
    }

    return $emptySeparator
}

function prompt {
    # Set Window Title
    $host.ui.RawUI.WindowTitle = "Path: $pwd"

    $promptLength = 0

    # Configure Output Info
    $currentFolderDetails = GetFolderDetails
    $dateDetails = GetDateDetails
    $adminDetails = GetAdminDetails
    $repoDetails = GetGitRepoDetails

    $promptLength += $currentFolderDetails.Length
    $promptLength += $adminDetails.Length
    $promptLength += $repoDetails.Length

    # Use 3 separators
    $promptLength += $SEPARATOR_RIGHT_GLYPH.Length
    $promptLength += $SEPARATOR_RIGHT_GLYPH.Length
    $promptLength += $SEPARATOR_RIGHT_GLYPH.Length

    # Date separators
    $promptLength += $SEPARATOR_RIGHT_GLYPH.Length
    $promptLength += $SEPARATOR_LEFT_GLYPH.Length


    # If is a Conda Environment, display current environment name
    if($env:CONDA_DEFAULT_ENV) {
        $codaDetails = " $PYTHON_GLYPH $($env:CONDA_DEFAULT_ENV) "

        $promptLength += $codaDetails.Length

        Write-Host $codaDetails `
            -BackgroundColor Cyan `
            -ForegroundColor Black `
            -NoNewline
    } 

    $emptySeparator = GetEmptySeparator `
        -PromptLength $promptLength `
        -DateLength $dateDetails.Length

    # Display if run as Administrator
    Write-host $adminDetails `
        -BackgroundColor DarkRed `
        -ForegroundColor White `
        -NoNewline

    # Separator
    Write-Host $SEPARATOR_RIGHT_GLYPH `
        -BackgroundColor DarkBlue `
        -ForegroundColor DarkRed `
        -NoNewline

    # Current folder
    Write-Host $currentFolderDetails `
        -BackgroundColor DarkBlue `
        -ForegroundColor Black `
        -NoNewline

    # Separator
    Write-Host $SEPARATOR_RIGHT_GLYPH `
        -BackgroundColor Yellow `
        -ForegroundColor DarkBlue `
        -NoNewline

    # Git repo
    Write-Host $repoDetails `
        -BackgroundColor Yellow `
        -ForegroundColor Black `
        -NoNewline

    # Separator
    Write-Host $SEPARATOR_RIGHT_GLYPH `
        -ForegroundColor Yellow `
        -NoNewline

    Write-Host $emptySeparator `
        -NoNewline
    
    # Date
    Write-Host $SEPARATOR_LEFT_GLYPH `
        -ForegroundColor DarkGray `
        -NoNewline

    Write-Host $dateDetails `
        -ForegroundColor White `
        -BackgroundColor DarkGray `
        -NoNewline

    Write-Host $SEPARATOR_RIGHT_GLYPH `
        -ForegroundColor DarkGray

    Write-Host "$PROMPT_GLYPH$PROMPT_GLYPH" `
        -ForegroundColor DarkYellow `
        -NoNewline

    return " "
} 