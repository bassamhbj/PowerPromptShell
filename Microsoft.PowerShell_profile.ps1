# Comment out if use Terminal-Icons
#Import-Module -Name Terminal-Icons

Write-Host "            //////////////////////////////////// " -ForegroundColor Blue
Write-Host "           ///////   //////////////////////////  " -ForegroundColor Blue
Write-Host "          /////////     //////////////////////   " -ForegroundColor Blue
Write-Host "         /////////////    ///////////////////    " -ForegroundColor Blue
Write-Host "        ////////////////    ////////////////     " -ForegroundColor Blue
Write-Host "       //////////////////     /////////////      " -ForegroundColor Blue
Write-Host "      ///////////////      ///////////////       " -ForegroundColor Blue
Write-Host "     /////////////     //////////////////        " -ForegroundColor Blue
Write-Host "    //////////      ////         ///////         " -ForegroundColor Blue
Write-Host "   ///////////  ///////////////////////          " -ForegroundColor Blue
Write-Host "  ////////////////////////////////////           " -ForegroundColor Blue
""
""

$GIT_GLYPH = $([char]0xf113)
$BRANCH_GLYPH = $([char]0xe0a0)
$PYTHON_GLYPH = $([char]0xe235)
$SEPARATOR_RIGHT_GLYPH = $([char]0xe0b0)
$SEPARATOR_LEFT_GLYPH = $([char]0xe0b2)
$FOLDER_GLYPH = $([char]0xf115)
$WARNING_GLYPH = $([char]0xf071)
$PROMPT_GLYPH = $([char]0xe0b1)
#$TERMINAL_GLYPH = $([char]0xf489)
$TERMINAL_GLYPH = $([char]0xe62a)
$START_GLYPH = "$([char]0x256d)$([char]0x2500)"
$START_GLYPH_2 = "$([char]0x2570)$([char]0x2500)"


$CIRCLE_LEFT_GLYPH = $([char]0xe0b6)
$CIRCLE_RIGHT_GLYPH = $([char]0xe0b4)
#$ARC_RIGHT_GLYPH = $([char]0xe0b5)

function GetPromptIcon {
    return " $(if($env:CONDA_DEFAULT_ENV) { $PYTHON_GLYPH } else { $TERMINAL_GLYPH } )  "
}

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
    $promptIcon = GetPromptIcon

    $promptLength += $currentFolderDetails.Length
    #$promptLength += $adminDetails.Length
    $promptLength += $repoDetails.Length
    $promptLength += $promptIcon.Length

    # Icon separators
    $promptLength += $CIRCLE_LEFT_GLYPH.Length
    $promptLength += $CIRCLE_RIGHT_GLYPH.Length
    $promptLength += $CIRCLE_RIGHT_GLYPH.Length

    # Use 3 separators
    $promptLength += $SEPARATOR_RIGHT_GLYPH.Length
    $promptLength += $SEPARATOR_RIGHT_GLYPH.Length
    $promptLength += $SEPARATOR_RIGHT_GLYPH.Length

    # Date separators
    $promptLength += $SEPARATOR_RIGHT_GLYPH.Length
    $promptLength += $SEPARATOR_LEFT_GLYPH.Length

    # Display start
    $promptLength += $START_GLYPH.Length

    Write-Host $START_GLYPH `
        -ForegroundColor Yellow `
        -NoNewline

    # Display terminal icon
    Write-Host $CIRCLE_LEFT_GLYPH `
        -ForegroundColor Yellow `
        -NoNewline

    Write-Host $promptIcon `
        -BackgroundColor Yellow `
        -ForegroundColor Black `
        -NoNewline

    Write-Host $CIRCLE_RIGHT_GLYPH `
        -BackgroundColor DarkBlue `
        -ForegroundColor Yellow `
        -NoNewline

    # If is a Conda Environment, display current environment name
    if($env:CONDA_DEFAULT_ENV) {
        $promptLength += $env:CONDA_DEFAULT_ENV.Length

        Write-Host $CIRCLE_RIGHT_GLYPH `
            -BackgroundColor Cyan `
            -ForegroundColor Black `
            -NoNewline

        Write-Host $env:CONDA_DEFAULT_ENV `
            -BackgroundColor Cyan `
            -ForegroundColor Black `
            -NoNewline
    } else {
        # Write-Host $CIRCLE_RIGHT_GLYPH `
        #     -BackgroundColor DarkRed `
        #     -ForegroundColor Black `
        #     -NoNewline

        # # Black separator

        # Write-Host $CIRCLE_RIGHT_GLYPH `
        #     -BackgroundColor DarkBlue `
        #     -ForegroundColor Black `
        #     -NoNewline
    }

    $emptySeparator = GetEmptySeparator `
        -PromptLength $promptLength `
        -DateLength $dateDetails.Length

    # Display if run as Administrator

    # Write-host $adminDetails `
    #     -BackgroundColor DarkRed `
    #     -ForegroundColor White `
    #     -NoNewline

    # Separator
    # Write-Host $SEPARATOR_RIGHT_GLYPH `
    #     -BackgroundColor DarkBlue `
    #     -ForegroundColor DarkRed `
    #     -NoNewline

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

    ## Second line
    Write-Host $START_GLYPH_2 `
        -ForegroundColor DarkYellow `
        -NoNewline

    # Write-Host "$PROMPT_GLYPH$PROMPT_GLYPH" `
    #     -ForegroundColor DarkYellow `
    #     -NoNewline

    return " "
} 