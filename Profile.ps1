# Aliases
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
Set-Alias -Name cat -Value bat
Set-Alias -Name df -Value Get-Volume
Set-Alias -Name ff -Value Find-File
Set-Alias -Name grep -Value Find-String
Set-Alias -Name l -Value Get-ChildItemPretty
Set-Alias -Name la -Value Get-ChildItemPretty
Set-Alias -Name ll -Value Get-ChildItemPretty
Set-Alias -Name ls -Value Get-ChildItemPretty
Set-Alias -Name rm -Value Remove-ItemExtended
Set-Alias -Name su -Value sudo
Set-Alias -Name tif Show-ThisIsFine
Set-Alias -Name touch -Value New-File
Set-Alias -Name up -Value Update-Profile
Set-Alias -Name us -Value Update-Software
Set-Alias -Name vi -Value nvim
Set-Alias -Name vim -Value nvim
Set-Alias -Name which -Value Show-Command

function git_status { git status $args }; 
function git_add { git add $args }; 
function git_commit { git commit -v $args }; 
function git_checkout { git checkout $args }; 
function git_push { git push $args }; 
function git_merge { git merge $args }; 

Remove-Item Alias:gc -ErrorAction SilentlyContinue
Remove-Item Alias:gp -ErrorAction SilentlyContinue
Remove-Item Alias:gm -ErrorAction SilentlyContinue
Remove-Item Alias:clc -ErrorAction SilentlyContinue


Set-Alias -Name gst -Value git_status -Force
Set-Alias -Name ga -Value git_add -Force
Set-Alias -Name gc -Value git_commit -Force
Set-Alias -Name gco -Value git_checkout -Force
Set-Alias -Name gp -Value git_push -Force
Set-Alias -Name gm -Value git_merge -Force

Set-Alias -Name clc -Value Clear-Console -Force

Set-Alias -name activate -value Start-Python-Venv
Set-Alias -name windots -value Set-WindotsLocation

# Putting the FUN in Functions!

# Winget & choco dependencies
$wingetDeps = @(
    "chocolatey.chocolatey"
    "eza-community.eza"
    "ezwinports.make"
    "fastfetch-cli.fastfetch"
    "gerardog.gsudo"
    "git.git"
    "github.cli"
    "kitware.cmake"
    "mbuilov.sed"
    "microsoft.powershell"
    "neovim.neovim"
    "openjs.nodejs"
    "starship.starship"
)

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
function Clear-Console {
    <#
    .SYNOPSIS
        Clears the console and runs fastfetch.
    #>
    Clear-Host
    fastfetch
}

function Set-WindotsLocation {
    <#
        .SYNOPSIS
            Changes the current directory to Windots.
        .DESCRIPTION
            Changes the current directory to Windots, the root directory of the Windots repository.
        .EXAMPLE
            GoTo-Windots
            Changes the current directory to Windots.
    #>

    Set-Location -Path $ENV:WindotsLocalRepo
}

function Start-Python-Venv {
    # Define possible virtual environment folder names
    $venvFolders = @('.venv', 'venv')

    # Find the virtual environment folder in the current directory
    $venvFolder = $venvFolders | ForEach-Object {
        if (Test-Path -Path $_ && (Test-Path -Path "$_\Scripts\Activate.ps1")) {
            return $_
        }
    } | Select-Object -First 1

    if ($venvFolder) {
        # Construct the path to the Activate.ps1 script
        $activateScript = Join-Path -Path $venvFolder -ChildPath 'Scripts\Activate.ps1'

        # Activate the virtual environment
        Write-Verbose "Activating virtual environment: $venvFolder"
        . $activateScript
    } else {
        Write-Verbose "No virtual environment found in the current directory."
    }
}

function Get-WingetDeps {
    <#
    .SYNOPSIS
        Gets the list of winget dependencies.
    #>

    # Winget & choco dependencies
    $wingetDeps = @(
        "chocolatey.chocolatey"
        "eza-community.eza"
        "ezwinports.make"
        "fastfetch-cli.fastfetch"
        "gerardog.gsudo"
        "git.git"
        "github.cli"
        "kitware.cmake"
        "mbuilov.sed"
        "microsoft.powershell"
        "neovim.neovim"
        "openjs.nodejs"
        "starship.starship"
    )

    return $wingetDeps
}

function Find-WindotsRepository {
    <#
    .SYNOPSIS
        Finds the local Windots repository.
    #>
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true, Position = 0)]
        [string]$ProfilePath
    )

    Write-Verbose "Resolving the symbolic link for the profile"
    $profileSymbolicLink = Get-ChildItem $ProfilePath | Where-Object FullName -EQ $PROFILE.CurrentUserAllHosts
    return Split-Path $profileSymbolicLink.Target
}

function Update-Profile {
    <#
    .SYNOPSIS
        Gets the latest changes from git, reruns the setup script and reloads the profile.
        Note that functions won't be updated, this requires a full PS session restart. Alias: up
    #>
    [CmdletBinding()]
    param ()

    Write-Verbose "Storing current working directory in memory"
    $currentWorkingDirectory = $PWD

    Write-Verbose "Updating local profile from Github repository"
    Set-Location $ENV:WindotsLocalRepo
    git stash | Out-Null
    git pull | Out-Null
    git stash pop | Out-Null

    Write-Verbose "Rerunning setup script to capture any new dependencies."
    if (Get-Command -Name gsudo -ErrorAction SilentlyContinue) {
        sudo ./Setup.ps1
    }
    else {
        Start-Process wezterm -Verb runAs -WindowStyle Hidden -ArgumentList "start --cwd $PWD pwsh -NonInteractive -Command ./Setup.ps1"
    }

    Write-Verbose "Reverting to previous working directory"
    Set-Location $currentWorkingDirectory

    Write-Verbose "Re-running profile script from $($PROFILE.CurrentUserAllHosts)"
    .$PROFILE.CurrentUserAllHosts
}

function Update-Software {
    <#
    .SYNOPSIS
        Updates all software installed via Winget & Chocolatey. Alias: us
    #>
    [CmdletBinding()]
    param ()

    Write-Verbose "Updating software installed via Winget & Chocolatey"

    $wingetDeps = Get-WingetDeps

    sudo cache on

    $wingetUpdatesString = Start-Job -ScriptBlock { winget list --upgrade-available | Out-String } | Wait-Job | Receive-Job
    $filteredUpdates = $wingetUpdatesString -split "`n" | Where-Object { $_ -match ($wingetDeps -join '|') }

    # Update winget packages from the filtered list
    if ($filteredUpdates.Length -gt 0) {
        foreach ($update in $filteredUpdates) {
            $packageId = ($update -split '\s+')[1]  # Extract the package ID
            Write-Verbose "Updating $packageId via Winget"
            sudo winget upgrade --id $packageId --silent --verbose
        }
    }

    sudo choco upgrade all -y
    sudo -k
    $ENV:SOFTWARE_UPDATE_AVAILABLE = ""
}

function Find-File {
    <#
    .SYNOPSIS
        Finds a file in the current directory and all subdirectories. Alias: ff
    #>
    [CmdletBinding()]
    param (
        [Parameter(ValueFromPipeline, Mandatory = $true, Position = 0)]
        [string]$SearchTerm
    )

    Write-Verbose "Searching for '$SearchTerm' in current directory and subdirectories"
    $result = Get-ChildItem -Recurse -Filter "*$SearchTerm*" -ErrorAction SilentlyContinue

    Write-Verbose "Outputting results to table"
    $result | Format-Table -AutoSize
}

function Find-String {
    <#
    .SYNOPSIS
        Searches for a string in a file or directory. Alias: grep
    #>
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true, Position = 0)]
        [string]$SearchTerm,
        [Parameter(ValueFromPipeline, Mandatory = $false, Position = 1)]
        [string]$Directory,
        [Parameter(Mandatory = $false)]
        [switch]$Recurse
    )

    Write-Verbose "Searching for '$SearchTerm' in '$Directory'"
    if ($Directory) {
        if ($Recurse) {
            Write-Verbose "Searching for '$SearchTerm' in '$Directory' and subdirectories"
            Get-ChildItem -Recurse $Directory | Select-String $SearchTerm
            return
        }

        Write-Verbose "Searching for '$SearchTerm' in '$Directory'"
        Get-ChildItem $Directory | Select-String $SearchTerm
        return
    }

    if ($Recurse) {
        Write-Verbose "Searching for '$SearchTerm' in current directory and subdirectories"
        Get-ChildItem -Recurse | Select-String $SearchTerm
        return
    }

    Write-Verbose "Searching for '$SearchTerm' in current directory"
    Get-ChildItem | Select-String $SearchTerm
}

function New-File {
    <#
    .SYNOPSIS
        Creates a new file with the specified name and extension. Alias: touch
    #>
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true, Position = 0)]
        [string]$Name
    )

    Write-Verbose "Creating new file '$Name'"
    New-Item -ItemType File -Name $Name -Path $PWD | Out-Null
}

function Show-Command {
    <#
    .SYNOPSIS
        Displays the definition of a command. Alias: which
    #>
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true, Position = 0)]
        [string]$Name
    )
    Write-Verbose "Showing definition of '$Name'"
    Get-Command $Name | Select-Object -ExpandProperty Definition
}

function Get-OrCreateSecret {
    <#
    .SYNOPSIS
        Gets secret from local vault or creates it if it does not exist. Requires SecretManagement and SecretStore modules and a local vault to be created.
        Install Modules with:
            Install-Module Microsoft.PowerShell.SecretManagement, Microsoft.PowerShell.SecretStore
        Create local vault with:
            Install-Module Microsoft.PowerShell.SecretManagement, Microsoft.PowerShell.SecretStore
            Set-SecretStoreConfiguration -Authentication None -Confirm:$False

        https://devblogs.microsoft.com/powershell/secretmanagement-and-secretstore-are-generally-available/

    .PARAMETER secretName
        Name of the secret to get or create. It is recommended to use the username or public key / client id as secret name to make it easier to identify the secret later.

    .EXAMPLE
        $password = Get-OrCreateSecret -secretName $username

    .EXAMPLE
        $clientSecret = Get-OrCreateSecret -secretName $clientId

    .OUTPUTS
        System.String
    #>

    [CmdletBinding()]
    param(
        [Parameter(Mandatory = $true)]
        [string]$secretName
    )

    Write-Verbose "Getting secret $secretName"
    $secretValue = Get-Secret $secretName -AsPlainText -ErrorAction SilentlyContinue

    if (!$secretValue) {
        $createSecret = Read-Host "No secret found matching $secretName, create one? Y/N"

        if ($createSecret.ToUpper() -eq "Y") {
            $secretValue = Read-Host -Prompt "Enter secret value for ($secretName)" -AsSecureString
            Set-Secret -Name $secretName -SecureStringSecret $secretValue
            $secretValue = Get-Secret $secretName -AsPlainText
        }
        else {
            throw "Secret not found and not created, exiting"
        }
    }
    return $secretValue
}

function Get-ChildItemPretty {
    <#
    .SYNOPSIS
        Runs eza with a specific set of arguments. Plus some line breaks before and after the output.
        Alias: ls, ll, la, l
    #>
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $false, Position = 0)]
        [string]$Path = $PWD
    )

    Write-Host ""
    eza -a -l --header --icons --hyperlink --time-style relative $Path
    Write-Host ""
}

function Show-ThisIsFine {
    <#
    .SYNOPSIS
        Displays the "This is fine" meme in the console. Alias: tif
    #>
    Write-Verbose "Running thisisfine.ps1"
    Show-ColorScript -Name thisisfine
}

function Remove-ItemExtended {
    <#
    .SYNOPSIS
        Removes an item and (optionally) all its children. Alias: rm
    #>
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $false)]
        [switch]$rf,
        [Parameter(Mandatory = $true, Position = 0)]
        [string]$Path
    )

    Write-Verbose "Removing item '$Path' $($rf ? 'and all its children' : '')"
    Remove-Item $Path -Recurse:$rf -Force:$rf
}

# Environment Variables
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
$ENV:WindotsLocalRepo = Find-WindotsRepository -ProfilePath $PSScriptRoot
$ENV:STARSHIP_CONFIG = "$ENV:WindotsLocalRepo\starship\starship.toml"
$ENV:_ZO_DATA_DIR = $ENV:WindotsLocalRepo
$ENV:OBSIDIAN_PATH = "$HOME\iCloudDrive\iCloud~md~obsidian\Obsidian"
$ENV:BAT_CONFIG_DIR = "$ENV:WindotsLocalRepo\bat"
$ENV:FZF_DEFAULT_OPTS = '--color=fg:-1,fg+:#ffffff,bg:-1,bg+:#3c4048 --color=hl:#5ea1ff,hl+:#5ef1ff,info:#ffbd5e,marker:#5eff6c --color=prompt:#ff5ef1,spinner:#bd5eff,pointer:#ff5ea0,header:#5eff6c --color=gutter:-1,border:#3c4048,scrollbar:#7b8496,label:#7b8496 --color=query:#ffffff --border="rounded" --border-label="" --preview-window="border-rounded" --height 40% --preview="bat -n --color=always {}"'

# Check for Windots and software updates while prompt is loading
Start-ThreadJob -ScriptBlock {
    Set-Location -Path $ENV:WindotsLocalRepo
    $gitUpdates = git fetch && git status
    if ($gitUpdates -match "behind") {
        $ENV:DOTFILES_UPDATE_AVAILABLE = "`u{db86}`u{dd1b} "
    }
    else {
        $ENV:DOTFILES_UPDATE_AVAILABLE = ""
    }
} | Out-Null

Start-ThreadJob -ScriptBlock {
    <#
        This is gross, I know. But there's a noticible lag that manifests in powershell when running the winget and choco commands
        within the main pwsh process. Running this whole block as an isolated job fails to set the environment variable correctly.
        The compromise is to run the main logic of this block within a threadjob and get the output of the winget and choco commands
        via two isolated jobs. This sets the environment variable correctly and doesn't cause any lag (that I've noticed yet).
    #>
    $wingetDeps = Get-WingetDeps
    $wingetUpdatesString = Start-Job -ScriptBlock { winget list --upgrade-available | Out-String } | Wait-Job | Receive-Job
    $filteredUpdates = $wingetUpdatesString -split "`n" | Where-Object {
        foreach ($dep in $wingetDeps) {
            if ($_ -match $dep) {
                return $true
            }
        }
        return $false
    }
    $chocoUpdatesString = Start-Job -ScriptBlock { choco upgrade all --noop -y | Out-String } | Wait-Job | Receive-Job
    if ($filteredUpdates.Length -gt 0 -or $chocoUpdatesString -notmatch "can upgrade 0/") {
        $ENV:SOFTWARE_UPDATE_AVAILABLE = "`u{eb29} "
    }
    else {
        $ENV:SOFTWARE_UPDATE_AVAILABLE = ""
    }
} | Out-Null

function Invoke-Starship-TransientFunction {
    &starship module character
}

# Prompt Setup
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
Invoke-Expression (&starship init powershell)
Enable-TransientPrompt
Invoke-Expression (& { ( zoxide init powershell --cmd cd | Out-String ) })

$colors = @{
    "Operator"         = "`e[35m" # Purple
    "Parameter"        = "`e[36m" # Cyan
    "String"           = "`e[32m" # Green
    "Command"          = "`e[34m" # Blue
    "Variable"         = "`e[37m" # White
    "Comment"          = "`e[38;5;244m" # Gray
    "InlinePrediction" = "`e[38;5;244m" # Gray
}

Set-PSReadLineOption -Colors $colors
Set-PSReadLineOption -PredictionSource HistoryAndPlugin
Set-PSReadLineOption -PredictionViewStyle InlineView
Set-PSReadLineKeyHandler -Function AcceptSuggestion -Key Alt+l
Import-Module -Name CompletionPredictor

# Skip fastfetch for non-interactive shells
if ([Environment]::GetCommandLineArgs().Contains("-NonInteractive")) {
    return
}
fastfetch
