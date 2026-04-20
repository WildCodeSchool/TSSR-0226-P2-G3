
. "./scripts_windows_server/utilitaire.ps1"

function LancementEnfant {
    param([string]$script)
    & $script
    if ($LASTEXITCODE -eq 50) {
        Log "EndScript"
        exit 0
    }
}

Log "StartScript"

# Demande la machine à cibler
$ssh_client = Read-Host "Quel est le nom de la machine sur laquelle vous souhaitez vous connecter ?"

# Démarrage ssh-agent et ajout de la clé
Start-Service ssh-agent
ssh-add "$env:USERPROFILE\.ssh\id_ed25519"

Start-Sleep 2
Clear-Host

# Détection OS
$os_type = (ssh $ssh_client "uname") 2>$null

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
                LancementEnfant "./scripts_windows_server/Linux/utilisateurs_linux.sh"
            } else {
                LancementEnfant "./scripts_windows_server/Windows/utilisateurs_windows.sh"
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
                LancementEnfant "./scripts_windows_server/Linux/groupes_linux.sh"
            } else {
                LancementEnfant "./scripts_windows_server/Windows/groupes_windows.sh"
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
                LancementEnfant "./scripts_windows_server/Linux/repertoires_linux.sh"
            } else {
                LancementEnfant "./scripts_windows_server/Windows/repertoires_windows.sh"
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
                LancementEnfant "./scripts_windows_server/Linux/maintenance_linux.sh"
            } else {
                LancementEnfant "./scripts_windows_server/Windows/maintenance_windows.sh"
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
                LancementEnfant "./scripts_windows_server/Linux/connexions_linux.sh"
            } else {
                LancementEnfant "./scripts_windows_server/Windows/connexions_windows.sh"
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
                LancementEnfant "./scripts_windows_server/Linux/disques_linux.sh"
            } else {
                LancementEnfant "./scripts_windows_server/Windows/disques_windows.sh"
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
                LancementEnfant "./scripts_windows_server/Linux/systeme_linux.sh"
            } else {
                LancementEnfant "./scripts_windows_server/Windows/systeme_windows.sh"
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
                LancementEnfant "./scripts_windows_server/Linux/historique_linux.sh"
            } else {
                LancementEnfant "./scripts_windows_server/Windows/historique_windows.sh"
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
                LancementEnfant "./scripts_windows_server/Linux/logs_recherches_linux.sh"
            } else {
                LancementEnfant "./scripts_windows_server/Windows/logs_recherches_windows.sh"
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
