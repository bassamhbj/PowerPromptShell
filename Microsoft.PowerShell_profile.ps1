# Comment out if use Terminal-Icons
#Import-Module -Name Terminal-Icons

$GIT_GLYPH = $([char]0xf113)
$BRANCH_GLYPH = $([char]0xe0a0)
$PYTHON_GLYPH = $([char]0xe235)
$SEPARATOR_GLYPH = $([char]0xe0b0)
$FOLDER_GLYPH = $([char]0xf115)
$WARNING_GLYPH = $([char]0xf071)

function prompt {
    # Set Window Title
    $host.ui.RawUI.WindowTitle = "Path: $pwd"

    # Configure Output Info
    $currentFolder = Split-Path -Path $pwd -Leaf
    #$user = [Security.Principal.WindowsIdentity]::GetCurrent();
    $date = Get-Date -Format 'dddd hh:mm:ss tt'

    # Check If is Admin
    $isAdmin = (New-Object Security.Principal.WindowsPrincipal ([Security.Principal.WindowsIdentity]::GetCurrent())).IsInRole([Security.Principal.WindowsBuiltinRole]::Administrator)

    # Check if git is enabled in the current directory
    $isGitRepo = git rev-parse --git-dir
    $repoName = "----"
    $branchName = ""

    if($isGitRepo){
        $repo = git config --get remote.origin.url

        if($repo) {
            $repoName = $repo.split("/") | Select-Object -Last 1
            $branch = git branch --show-current
            $branchName = "$BRANCH_GLYPH $branch"
        } else {
            $repoName = "$WARNING_GLYPH GIT NOT INITIATED $WARNING_GLYPH"
        }
    }    

    # If is a Conda Environment, display current environment name
    if($env:CONDA_DEFAULT_ENV) {
        Write-Host " $PYTHON_GLYPH $($env:CONDA_DEFAULT_ENV) " `
            -BackgroundColor Cyan `
            -ForegroundColor Black `
            -NoNewline
    } 

    # Display if run as Administrator
    Write-host ($(if ($isAdmin) { " Admin:Enabled " } else { " Admin:Disabled " })) `
        -BackgroundColor DarkRed `
        -ForegroundColor White `
        -NoNewline

    # Separator
    Write-Host $SEPARATOR_GLYPH `
        -BackgroundColor DarkBlue `
        -ForegroundColor DarkRed `
        -NoNewline

    # Current folder
    Write-Host " $FOLDER_GLYPH $currentFolder " `
        -BackgroundColor DarkBlue `
        -ForegroundColor Black `
        -NoNewline

    # Separator
    Write-Host $SEPARATOR_GLYPH `
        -BackgroundColor Yellow `
        -ForegroundColor DarkBlue `
        -NoNewline

    # Git repo
    Write-Host " $GIT_GLYPH $repoName $branchName" `
        -BackgroundColor Yellow `
        -ForegroundColor Black `
        -NoNewline

    # Separator
    Write-Host $SEPARATOR_GLYPH `
        -ForegroundColor Yellow `
        -NoNewline

    # Date
    Write-Host " $date" `
        -ForegroundColor White

    return "> "
} 