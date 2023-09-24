
$PSStyle.FileInfo.Directory = ''

$PROJECTSPATH = "$HOME\Projects\"
$IGNOREDIR = "$HOME\Projects\deploys*"
$opCommandCompletion = {
    param($stringMatch)
    $items  = @(Get-ChildItem -Path "$PROJECTSPATH\*\$stringMatch*" -Directory | 
        Where-Object {$_.fullname -notlike $IGNOREDIR } |
        Select-Object -ExpandProperty name )
    
    $items
}

Set-PSReadLineKeyHandler -Key Ctrl+l `
                         -BriefDescription RemapForwardToCtrlL `
                         -ScriptBlock {
    param($key, $arg)

    [Microsoft.PowerShell.PSConsoleReadLine]::ForwardChar($key, $arg)
}

Set-PSReadLineKeyHandler -Key Ctrl+Shift+l `
                         -BriefDescription RemapAceeptNextCharToCtrlL `
                         -ScriptBlock {
    param($key, $arg)
    [Microsoft.PowerShell.PSConsoleReadLine]::AcceptNextSuggestionWord($key, $arg)
}

Register-ArgumentCompleter -Native -CommandName op -ScriptBlock $opCommandCompletion
