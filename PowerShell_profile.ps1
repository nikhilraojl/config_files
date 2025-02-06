# Environment variables to be set; use [System.Environment]::SetEnvironmentVariable(name, val, 'User')
# $POWERSHELL_UPDATECHECK: To disable update checks for current user(Off, Default, lTS)
# $VS_BUILDTOOLS_DIR: Location of Visual Studio Build Tools, needed for setting up domains in wezterm
# $HOME: home directory, used by many scripts

$KB_LAYOUT = [Environment]::GetEnvironmentVariable("KB_LAYOUT")


# For disabling colors for directories
$PSStyle.FileInfo.Directory = ''

# helper function to stop auto complete
function Get-FirstArgumentCompleted
{   param ($wordToComplete, $spaces)
    
    # These couple of `if` blocks are there to check if first parameter is
    # autocompleted. We can use this to stop further autocompletion or generate
    # different output.
    # Maybe a better way exists but this works for now
    if (($wordToComplete -and ($spaces -gt 1)) )
    {
        return $true
    }
    if ((-not $wordToComplete -and ($spaces -ge 1)) )
    {
        return $true
    }

    return $false
}

# Helper funciton. Get current directory branches
function Get-GitBranches
{
    # HELP: https://git-scm.com/docs/git-ls-files
    $branches = git branch -a --format="%(refname:lstrip=2)"
    $branches = $(foreach ( $branch in $branches)
        {
            if ($branch.StartsWith("origin/"))
            {
                $branch.Substring(7)
            } else
            {
                $branch
            }
        }) | Select-Object -Unique
    return $branches
}

# arg autocomplete for `op`
# REQUIRES: `op` program to be in path
$opCommandCompletion = {
    # For why should we use these 3 specific parameters 
    # see powershell docs for `register-argumentcompleter` for `Native` command
    param ( $wordToComplete,
        $commandAst,
        $cursorPosition )
    
    $spaces = $commandAst.ToString().Split(" ").GetUpperBound(0)
    if (-not (Get-FirstArgumentCompleted $wordToComplete $spaces))
    {
        # using outupt from the `op --list` command to build autocomplete list
        $items = @(op --list | Where-Object {$_ -like "$wordToComplete*"})
        return $items
    }
}
Register-ArgumentCompleter -Native -CommandName op -ScriptBlock $opCommandCompletion

# git autocomplete
# REQUIRES: `git` program to be in path
$gitCommandCompletion = {
    # For why should we use these 3 specific parameters 
    # see powershell docs for `register-argumentcompleter` for `Native` command
    param ( $wordToComplete,
        $commandAst,
        $cursorPosition )
    
    $stringifiedAst = $commandAst.ToString().Split(" ")
    $spaces = $stringifiedAst.GetUpperBound(0)

    # autocompletions for first arguments
    if (-not (Get-FirstArgumentCompleted $wordToComplete $spaces))
    {
        $possibleCommands = 'add','branch','checkout','commit','diff', 'log', 'rebase','remote','reset','restore','stash', 'status','switch'
        $branches =  @( $possibleCommands | Where-Object {$_ -like "$wordToComplete*"})
        return $branches
    }

    # autocompletions for more arguments
    $paramName = $stringifiedAst[1]
    if ($paramName -eq "add")
    {
        # HELP: https://git-scm.com/docs/git-ls-files
        $files =  @(git ls-files --modified --others --exclude-standard | Where-Object {$_ -like "$wordToComplete*"})
        return $files
    }

    if ($paramName -eq "diff")
    {
        # HELP: https://git-scm.com/docs/git-branch
        # HELP: https://git-scm.com/docs/git-for-each-ref#_field_names
        $files =  @(git ls-files --modified | Where-Object {$_ -like "$wordToComplete*"})
        return $files
    }

    if ($paramName -eq "switch")
    {
        $branches = Get-GitBranches
        $branches = @($branches | Where-Object {$_ -like "$wordToComplete*"})
        return $branches
    }

    if ($paramName -eq "restore")
    {
        $restoreOption = $stringifiedAst[2] 
        if ($restoreOption -eq "--staged") 
        {
            # `git ls-files` does not have an option which can only show files with changes to be committed
            # HELP: https://git-scm.com/docs/git-diff
            $files =  @( git diff --staged --name-only | Where-Object {$_ -like "$wordToComplete*"})
            return $files
        }

        $files =  @( git ls-files --modified | Where-Object {$_ -like "$wordToComplete*"})
        return $files
    } 

    if ($paramName -eq "branch")
    {
        $branchFlag = $stringifiedAst[2] 
        if (($branchFlag -eq "-d") -or ($branchFlag -eq "-D"))
        {
            # HELP: https://git-scm.com/docs/git-branch
            # HELP: https://git-scm.com/docs/git-for-each-ref#_field_names
            $branches =  @( git branch --format="%(refname:short)" | Where-Object {$_ -like "$wordToComplete*"})
            return $branches
        }
    } 
    
    return 
}
Register-ArgumentCompleter -Native -CommandName git -ScriptBlock $gitCommandCompletion

# autocomplete hostnames for ssh
# reads `Host` values from ~/.ssh/config
$sshHostNameCompletion = {
    # For why should we use these 3 specific parameters 
    # see powershell docs for `register-argumentcompleter` for `Native` command
    param ( $wordToComplete,
        $commandAst,
        $cursorPosition )
    
    $stringifiedAst = $commandAst.ToString().Split(" ")
    $spaces = $stringifiedAst.GetUpperBound(0)

    # autocompletions for first arguments
    if (-not (Get-FirstArgumentCompleted $wordToComplete $spaces))
    {
        $file = Get-Content -Path ~\.ssh\config
        $results = $(foreach ($line in $file)
            {
                if ($line.StartsWith("Host "))
                {
                    $line.Substring(5)
                }
            })
        return $results
    }
    return


}
Register-ArgumentCompleter -Native -CommandName ssh -ScriptBlock $sshHostNameCompletion

# Complete full line predictive text
Set-PSReadLineKeyHandler -Key Ctrl+j `
    -BriefDescription RemapForwardToCtrlL `
    -ScriptBlock {
    param($key, $arg)

    [Microsoft.PowerShell.PSConsoleReadLine]::ForwardChar($key, $arg)
}

# Complete single word predictive text
Set-PSReadLineKeyHandler -Key Ctrl+Shift+j `
    -BriefDescription RemapAceeptNextCharToCtrlL `
    -ScriptBlock {
    param($key, $arg)
    [Microsoft.PowerShell.PSConsoleReadLine]::AcceptNextSuggestionWord($key, $arg)
}

# Elevate to administrator from a shell
# opens new windows terminal as administrator
function Get-AdminWTShell
{
    Start-process wt -Verb runAs
}
Set-Alias -Name su -Value Get-AdminWTShell

# Elevate to administrator from a shell 
# opens new wezterm as administrator
# REQUIRES: wezterm to be installed
function Get-AdminWezterm
{
    Start-process wezterm -WindowStyle Hidden -Verb runAs
}
Set-Alias -Name sudow -Value Get-AdminWezterm
Set-Alias grep Select-String
Set-Alias kblayout $KB_LAYOUT
