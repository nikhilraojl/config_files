
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

Register-ArgumentCompleter -Native -CommandName op -ScriptBlock $opCommandCompletion
