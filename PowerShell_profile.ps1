# For disabling colors for directories
$PSStyle.FileInfo.Directory = ''

# directory arg autocomplete for `op`
$PROJECTSPATH = "$HOME\Projects\"
$IGNOREDIR = "$HOME\Projects\deploys*"
$opCommandCompletion = {
    # For why should we use these 3 specific parameters 
    # see powershell docs for `register-argumentcompleter` for `Native` command
    param ( $wordToComplete,
        $commandAst,
        $cursorPosition )
    
    # The next couple of `if` blocks are there to stop autocomplete
    # after the first argument. Maybe a better way exists but this is
    # works for now
    $spaces = $commandAst.ToString().Split(" ").GetUpperBound(0)
    if (($wordToComplete -and ($spaces -gt 1)) ) {
        return
    }
    if ((-not $wordToComplete -and ($spaces -ge 1)) ) {
        return
    }

    # autocomplete list
    $items = @(Get-ChildItem -Path "$PROJECTSPATH\*\$wordToComplete*" -Directory | 
        Where-Object { $_.fullname -notlike $IGNOREDIR } |
        Select-Object -ExpandProperty name )

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

