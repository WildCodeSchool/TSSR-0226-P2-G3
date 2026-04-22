$LOG_FILE     = "/var/log/log_evt.log"
$CURRENT_USER = $env:USER

# --- ECRIRE DANS LE LOG ---
function Write-Log {
    param($Event)
    $line = "$(Get-Date -Format 'yyyyMMdd_HHmmss')_${CURRENT_USER}_${Event}"
    Add-Content -Path $LOG_FILE -Value $line
}

# --- CREER LE LOG AU DEMARRAGE ---
function Init-Log {
    if (-not (Test-Path $LOG_FILE)) {
        New-Item -ItemType File -Path $LOG_FILE -Force | Out-Null
    }
    Write-Log "StartScript"
}

# --- QUITTER PROPREMENT ---
function End-Log {
    Write-Log "EndScript"
    Write-Host "Au revoir $CURRENT_USER !"
    exit 0
}

# --- AFFICHER L'EN-TETE ---
function Display-Header {
    param($Title)
    Clear-Host
    Write-Host "========================================"
    Write-Host "  SRVLNX01 | $CURRENT_USER | $(Get-Date -Format 'dd/MM/yyyy HH:mm:ss')"
    Write-Host "  $Title"
    Write-Host "========================================"
}

# --- RECHERCHE DANS LES LOGS ---
function Menu-RechercheLogs {
    do {
        Display-Header "RECHERCHE LOGS"
        Write-Host "  1) Par utilisateur"
        Write-Host "  2) Par mot-cle"
        Write-Host "  3) 20 dernieres lignes"
        Write-Host "  0) Retour"

        $choix = Read-Host "> Choix"

        switch ($choix) {
            "1" {
                $user = Read-Host "> Utilisateur"
                Get-Content $LOG_FILE | Where-Object { ($_ -split "_",4)[2] -eq $user }
            }
            "2" {
                $mot = Read-Host "> Mot-cle"
                Get-Content $LOG_FILE | Where-Object { $_ -match $mot }
            }
            "3" {
                Get-Content $LOG_FILE | Select-Object -Last 20
            }
        }

        if ($choix -ne "0") { Read-Host "> [Entree] pour continuer" }

    } while ($choix -ne "0")
}

# --- MENU PRINCIPAL ---
function Menu-Principal {
    do {
        Display-Header "MENU PRINCIPAL"
        Write-Host "  1) Recherche dans les logs"
        Write-Host "  0) Quitter"

        $choix = Read-Host "> Choix"

        switch ($choix) {
            "1" { Menu-RechercheLogs }
            "0" { End-Log }
        }
    } while ($choix -ne "0")
}

# --- LANCEMENT ---
Init-Log
Menu-Principal