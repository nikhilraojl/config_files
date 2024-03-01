# Environment variables to be set; use [System.Environment]::SetEnvironmentVariable(name, val, 'User')
# $POWERSHELL_UPDATECHECK: To disable update checks for current user(Off, Default, lTS)
# $VS_BUILDTOOLS_DIR: Location of Visual Studio Build Tools, needed for setting up domains in wezterm
# $HOME: home directory, used by many scripts

# For disabling colors for directories
$PSStyle.FileInfo.Directory = ''

# arg autocomplete for `op`
# REQUIRES: `op` program to be in path
$opCommandCompletion = {
    # For why should we use these 3 specific parameters 
    # see powershell docs for `register-argumentcompleter` for `Native` command
    param ( $wordToComplete,
        $commandAst,
        $cursorPosition )
    
    # The next couple of `if` blocks are there to stop autocomplete
    # after the first argument. Maybe a better way exists but this 
    # works for now
    $spaces = $commandAst.ToString().Split(" ").GetUpperBound(0)
    if (($wordToComplete -and ($spaces -gt 1)) )
    {
        return
    }
    if ((-not $wordToComplete -and ($spaces -ge 1)) )
    {
        return
    }

    # using outupt from the `op --list` command to build autocomplete list
    $items = @(op --list | Where-Object {$_ -like "$wordToComplete*"})

    return $items
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
        # HELP: https://git-scm.com/docs/git-ls-files
        $files =  @(git branch -a --format="%(refname:lstrip=-1)" | Where-Object {$_ -like "$wordToComplete*"})
        return $files
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

# Complete full line predictive text
Set-PSReadLineKeyHandler -Key Ctrl+l `
    -BriefDescription RemapForwardToCtrlL `
    -ScriptBlock {
    param($key, $arg)

    [Microsoft.PowerShell.PSConsoleReadLine]::ForwardChar($key, $arg)
}

# Complete single word predictive text
Set-PSReadLineKeyHandler -Key Ctrl+Shift+l `
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
