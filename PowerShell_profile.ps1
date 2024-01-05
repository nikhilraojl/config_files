# For disabling colors for directories
$PSStyle.FileInfo.Directory = ''

# directory arg autocomplete for `op`
$PROJECTSPATH = "$HOME\Projects\"
$IGNOREDIR = "$HOME\Projects\deploys*"
$opCommandCompletion = {
    param($stringMatch)
    $items  = @(Get-ChildItem -Path "$PROJECTSPATH\*\$stringMatch*" -Directory | 
        Where-Object {$_.fullname -notlike $IGNOREDIR } |
        Select-Object -ExpandProperty name )
    
    $items
}
Register-ArgumentCompleter -Native -CommandName op -ScriptBlock $opCommandCompletion

# Full autocomplete predictive text
Set-PSReadLineKeyHandler -Key Ctrl+l `
                         -BriefDescription RemapForwardToCtrlL `
                         -ScriptBlock {
    param($key, $arg)

    [Microsoft.PowerShell.PSConsoleReadLine]::ForwardChar($key, $arg)
}

# Full autocomplete predictive text
Set-PSReadLineKeyHandler -Key Ctrl+Shift+l `
                         -BriefDescription RemapAceeptNextCharToCtrlL `
                         -ScriptBlock {
    param($key, $arg)
    [Microsoft.PowerShell.PSConsoleReadLine]::AcceptNextSuggestionWord($key, $arg)
}

