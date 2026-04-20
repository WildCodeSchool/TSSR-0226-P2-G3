
# Destination des logs
$log_file = "C:\Windows\System32\LogFiles\log_evt.log"

# Fonction d'enregistrement de logs exporté dans parent et enfants
function Log {
    param([string]$message)
    $date = Get-Date -Format "yyyyMMdd_HHmmss"
    "$date_${env:USERNAME}_$message" | Out-File -Append $log_file
}

# Fonction conversion de CIDR en décimal pour script connexion
function ConvertirMasque {
    param([int]$prefixe)
    $masque = [uint32]0
    for ($i = 0; $i -lt $prefixe; $i++) {
        $masque = $masque -bor (1 -shl (31 - $i))
    }
    $bytes = [BitConverter]::GetBytes($masque)
    [Array]::Reverse($bytes)
    return ($bytes -join ".")
}