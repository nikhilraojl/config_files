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
    if (($wordToComplete -and ($spaces -gt 1)) ) {
        return
    }
    if ((-not $wordToComplete -and ($spaces -ge 1)) ) {
        return
    }

    # using outupt from the `op --list` command to build autocomplete list
    $items = @(op --list | Where-Object {$_ -like "$wordToComplete*"})

    return $items
}
Register-ArgumentCompleter -Native -CommandName op -ScriptBlock $opCommandCompletion

# Full autocomplete predictive text
Set-PSReadLineKeyHandler -Key Ctrl+l `
    -BriefDescription RemapForwardToCtrlL `
    -ScriptBlock {
    param($key, $arg)

    [Microsoft.PowerShell.PSConsoleReadLine]::ForwardChar($key, $arg)
}

# Single word autocomplete predictive text
Set-PSReadLineKeyHandler -Key Ctrl+Shift+l `
    -BriefDescription RemapAceeptNextCharToCtrlL `
    -ScriptBlock {
    param($key, $arg)
    [Microsoft.PowerShell.PSConsoleReadLine]::AcceptNextSuggestionWord($key, $arg)
}

# Elevate to administrator from a shell
# opens new windows terminal as administrator
function Get-AdminWTShell {
    Start-process wt -Verb runAs
}
Set-Alias -Name su -Value Get-AdminWTShell

# Elevate to administrator from a shell 
# opens new wezterm as administrator
# REQUIRES: wezterms to be installed
function Get-AdminWezterm {
    Start-process wezterm -WindowStyle Hidden -Verb runAs
}
Set-Alias -Name sudow -Value Get-AdminWezterm
