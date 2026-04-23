$LOG_FILE     = "C:\Windows\System32\LogFiles\log_evt.log"
$CURRENT_USER = $env:USERNAME

function Log {
    param($Event)
    $line = "$(Get-Date -Format 'yyyyMMdd')_$(Get-Date -Format 'HHmmss')_${CURRENT_USER}_${Event}"
    Invoke-Command -ComputerName $REMOTE_PC -Credential $REMOTE_CRED -ScriptBlock {
        param($l, $f)
        Add-Content -Path $f -Value $l -Encoding UTF8
    } -ArgumentList $line, $LOG_FILE
}

function Init-Log {
    Invoke-Command -ComputerName $REMOTE_PC -Credential $REMOTE_CRED -ScriptBlock {
        param($f)
        if (-not (Test-Path $f)) {
            New-Item -ItemType File -Path $f -Force | Out-Null
        }
    } -ArgumentList $LOG_FILE
    Log "StartScript"
}

function End-Log {
    Log "EndScript"
    Write-Host "Au revoir $CURRENT_USER !"
    exit 0
}
