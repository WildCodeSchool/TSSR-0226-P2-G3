. "$PSScriptRoot\scripts_windows_server\utilitaire.ps1"

# Variables principales pour client Linux depuis Powershell
$version_os = ssh $ssh_client "cat /etc/os-release | grep 'VERSION=' | cut -d '=' -f2 | tr -d '`"'"
$maj_critiques = ssh $ssh_client "apt list --upgradable 2>/dev/null | grep 'security'"
$nombre_maj_critiques = ($maj_critiques | Measure-Object -Line).Lines
$marque_modele = ssh $ssh_client "dmidecode -t system | grep -E 'Manufacturer|Version'"

function MenuSecondaire {
    Write-Host "1 - Revenir au menu Système"
    Write-Host "2 - Revenir au menu principal"
    Write-Host "q - Quitter le script"
    $choix_secondaire = Read-Host "Quel est votre choix ?"

    switch ($choix_secondaire) {
        "1" {
            Log "Retour menu systeme"
            Write-Host "Vous retournez au menu Système"
            Start-Sleep 1
            return
        }
        "2" {
            Log "Retour au menu principal"
            Write-Host "Vous retournez au menu principal"
            Start-Sleep 1
            exit 0
        }
        "q" {
            Log "Quitte le script"
            Write-Host "Vous quittez le script"
            Start-Sleep 1
            exit 50
        }
        default {
            Write-Host "L'option choisie n'existe pas, veuillez recommencer"
            Start-Sleep 1
            MenuSecondaire
        }
    }
}

Log "Demande sur systeme"
Write-Host "Bienvenue dans les informations système"
Start-Sleep 1
Clear-Host

while ($true) {
    Write-Host "Que souhaitez-vous savoir ?"
    Write-Host "1 - Version de l'OS"
    Write-Host "2 - Mises à jour critiques"
    Write-Host "3 - Marque et modèle"
    Write-Host "r - Revenir au menu précédent"
    Write-Host "q - Quitter le script"
    $choix = Read-Host "Quel est votre choix ?"

    switch ($choix) {
        "1" {
            Log "Consulte version OS"
            Write-Host "La version de l'OS est : $version_os"
            MenuSecondaire
        }
        "2" {
            Log "Consulte mises à jour critiques"
            Write-Host "Il y a $nombre_maj_critiques mises à jour critiques installées"
            Write-Host "Liste des mises à jour :"
            Write-Host $maj_critiques
            MenuSecondaire
        }
        "3" {
            Log "Consulte marque et modele"
            Write-Host "Le client est de la marque/modèle : $marque_modele"
            MenuSecondaire
        }
        "r" {
            Log "Retour arrière"
            Write-Host "Vous allez revenir au menu principal"
            Start-Sleep 1
            exit 0
        }
        "q" {
            Log "Quitte le script"
            Write-Host "Vous quittez le script"
            Start-Sleep 1
            exit 50
        }
        default {
            Write-Host "L'option choisie n'existe pas, veuillez recommencer"
        }
    }
}
