Il faut ajouter la demande de credentials au début du script principal et les passer à tous les Invoke-Command.
utilitaire.ps1 — ajout du paramètre -Credential :
powershell$LOG_FILE     = "C:\Windows\System32\LogFiles\log_evt.log"
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

Script principal — ajout de $REMOTE_CRED :
powershell. "$PSScriptRoot\scripts_windows_server\utilitaire.ps1"

function LancementEnfant {
    param([string]$script)
    & $script
    if ($LASTEXITCODE -eq 50) {
        Log "EndScript"
        exit 0
    }
}

# Demande la machine à cibler
$ssh_client  = Read-Host "Quel est le nom de la machine sur laquelle vous souhaitez vous connecter ?"
$REMOTE_PC   = $ssh_client
$REMOTE_CRED = Get-Credential -Message "Entrez les credentials de $REMOTE_PC"

# Vérifie que la machine est joignable via WinRM
if (-not (Test-WSMan -ComputerName $REMOTE_PC -Credential $REMOTE_CRED -Authentication Negotiate -ErrorAction SilentlyContinue)) {
    Write-Host "Impossible de joindre $REMOTE_PC via WinRM."
    exit 1
}

Init-Log

Start-Sleep 2
Clear-Host

# Détection OS via WinRM
$os_type = Invoke-Command -ComputerName $REMOTE_PC -Credential $REMOTE_CRED -ScriptBlock {
    if ($env:OS -eq "Windows_NT") { "Windows" } else { "Linux" }
}

while ($true) {
    Write-Host "Bienvenue sur la gestion de $ssh_client"
    Write-Host "Menu Principal"
    Write-Host "Quel menu souhaitez-vous utiliser ?"
    Write-Host "1 - Gestion des utilisateurs"
    Write-Host "2 - Gestion des groupes"
    Write-Host "3 - Gestion des repertoires"
    Write-Host "4 - Maintenance machine"
    Write-Host "5 - Gestion des connexions"
    Write-Host "6 - Gestion des disques"
    Write-Host "7 - Gestion du système"
    Write-Host "8 - Historique Utilisateur"
    Write-Host "9 - Recherche d'évènements dans les logs"
    Write-Host "q - quitter le script"
    Write-Host "Aide : tapez le numéro suivi de ? pour le détail, ex: 1?"
    $choice = Read-Host "Quel est votre choix ?"

    switch ($choice) {
        "1" {
            Log "Start_Menu_Utilisateurs"
            if ($os_type -eq "Linux") {
                LancementEnfant "$PSScriptRoot\scripts_windows_server\Linux\utilisateurs_linux.ps1"
            } else {
                LancementEnfant "$PSScriptRoot\scripts_windows_server\Windows\utilisateurs_windows.ps1"
            }
        }
        "1?" {
            Write-Host "Gestion des utilisateurs vous permet :"
            Write-Host " - De créer un compte utilisateur local"
            Write-Host " - De changer un mot de passe utilisateur"
            Write-Host " - De supprimer un compte utilisateur local"
            Read-Host "Appuyez sur Entrée pour continuer..."
        }
        "2" {
            Log "Start_Menu_Groupes"
            if ($os_type -eq "Linux") {
                LancementEnfant "$PSScriptRoot\scripts_windows_server\Linux\groupes_linux.ps1"
            } else {
                LancementEnfant "$PSScriptRoot\scripts_windows_server\Windows\groupes_windows.ps1"
            }
        }
        "2?" {
            Write-Host "Gestion des groupes vous permet :"
            Write-Host " - D'ajouter un utilisateur à un groupe d'administration"
            Write-Host " - D'ajouter un utilisateur à un groupe"
            Write-Host " - De retirer un utilisateur d'un groupe"
            Read-Host "Appuyez sur Entrée pour continuer..."
        }
        "3" {
            Log "Start_Menu_Repertoires"
            if ($os_type -eq "Linux") {
                LancementEnfant "$PSScriptRoot\scripts_windows_server\Linux\repertoires_linux.ps1"
            } else {
                LancementEnfant "$PSScriptRoot\scripts_windows_server\Windows\repertoires_windows.ps1"
            }
        }
        "3?" {
            Write-Host "Gestion des répertoires vous permet :"
            Write-Host " - De créer un répertoire"
            Write-Host " - De supprimer un répertoire"
            Read-Host "Appuyez sur Entrée pour continuer..."
        }
        "4" {
            Log "Start_Menu_Maintenance"
            if ($os_type -eq "Linux") {
                LancementEnfant "$PSScriptRoot\scripts_windows_server\Linux\maintenance_linux.ps1"
            } else {
                LancementEnfant "$PSScriptRoot\scripts_windows_server\Windows\maintenance_windows.ps1"
            }
        }
        "4?" {
            Write-Host "Maintenance machine vous permet :"
            Write-Host " - De prendre en main un client à distance (CLI)"
            Write-Host " - D'activer le pare-feu"
            Write-Host " - D'exécuter des scripts sur la machine distante"
            Write-Host " - De lister les utilisateurs locaux"
            Read-Host "Appuyez sur Entrée pour continuer..."
        }
        "5" {
            Log "Start_Menu_Connexions"
            if ($os_type -eq "Linux") {
                LancementEnfant "$PSScriptRoot\scripts_windows_server\Linux\connexions_linux.ps1"
            } else {
                LancementEnfant "$PSScriptRoot\scripts_windows_server\Windows\connexions_windows.ps1"
            }
        }
        "5?" {
            Write-Host "Gestion des connexions vous permet :"
            Write-Host " - De consulter les 5 dernières connexions"
            Write-Host " - De consulter l'IP, le masque de sous-réseau et la passerelle du client"
            Read-Host "Appuyez sur Entrée pour continuer..."
        }
        "6" {
            Log "Start_Menu_Disques"
            if ($os_type -eq "Linux") {
                LancementEnfant "$PSScriptRoot\scripts_windows_server\Linux\disques_linux.ps1"
            } else {
                LancementEnfant "$PSScriptRoot\scripts_windows_server\Windows\disques_windows.ps1"
            }
        }
        "6?" {
            Write-Host "Gestion des disques vous permet :"
            Write-Host " - De consulter le nombre de disques"
            Write-Host " - De connaitre le détail des partitions par disque"
            Write-Host " - De connaitre la liste des lecteurs montés (disque, CD, etc...)"
            Read-Host "Appuyez sur Entrée pour continuer..."
        }
        "7" {
            Log "Start_Menu_Systeme"
            if ($os_type -eq "Linux") {
                LancementEnfant "$PSScriptRoot\scripts_windows_server\Linux\systeme_linux.ps1"
            } else {
                LancementEnfant "$PSScriptRoot\scripts_windows_server\Windows\systeme_windows.ps1"
            }
        }
        "7?" {
            Write-Host "Gestion du système vous permet :"
            Write-Host " - De consulter la version de l'OS"
            Write-Host " - De connaitre les mises à jour critiques en attente"
            Write-Host " - De connaitre la marque et le modèle du client"
            Write-Host " - Sur client Windows : De vérifier si l'UAC est activé"
            Read-Host "Appuyez sur Entrée pour continuer..."
        }
        "8" {
            Log "Start_Menu_Historique"
            if ($os_type -eq "Linux") {
                LancementEnfant "$PSScriptRoot\scripts_windows_server\Linux\historique_linux.ps1"
            } else {
                LancementEnfant "$PSScriptRoot\scripts_windows_server\Windows\historique_windows.ps1"
            }
        }
        "8?" {
            Write-Host "L'historique utilisateur vous permet :"
            Write-Host " - De consulter la dernière connexion d'un utilisateur"
            Write-Host " - De consulter la dernière modification du mot de passe"
            Write-Host " - De consulter la liste des sessions ouvertes par un utilisateur"
            Read-Host "Appuyez sur Entrée pour continuer..."
        }
        "9" {
            Log "Start_Menu_Recherche_logs"
            if ($os_type -eq "Linux") {
                LancementEnfant "$PSScriptRoot\scripts_windows_server\Linux\logs_recherches_linux.ps1"
            } else {
                LancementEnfant "$PSScriptRoot\scripts_windows_server\Windows\logs_recherches_windows.ps1"
            }
        }
        "9?" {
            Write-Host "La recherche d'évènement dans les logs peut se faire :"
            Write-Host " - Par utilisateur"
            Write-Host " - Par machine"
            Read-Host "Appuyez sur Entrée pour continuer..."
        }
        "q" {
            Log "EndScript"
            Write-Host "Vous quittez le script"
            Start-Sleep 2
            exit 0
        }
        default {
            Write-Host "L'option choisie n'existe pas, veuillez recommencer"
        }
    }
}
