. "$PSScriptRoot\scripts_windows_server\utilitaire.ps1"

#Il est nécessaire d'installer PSWindowsUpdate sur le client Windows
# Variables principales - commandes PowerShell pour client Windows
$version_os = ssh $ssh_client "powershell.exe -Command '(Get-WmiObject Win32_OperatingSystem).Caption'"
$maj_critiques = ssh $ssh_client "powershell.exe -Command 'Import-Module PSWindowsUpdate; Get-WindowsUpdate -Category ''Security Updates'' | Select-Object Title, Size'"
$nombre_maj_critiques = ($maj_critiques | Measure-Object -Line).Lines
$marque_modele = ssh $ssh_client "powershell.exe -Command '(Get-WmiObject Win32_ComputerSystem).Manufacturer + '' '' + (Get-WmiObject Win32_ComputerSystem).Model'"
$uac_status = ssh $ssh_client "powershell.exe -Command '(Get-ItemProperty HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System).EnableLUA'"

function MenuSecondaire {
    Write-Host "1 - Revenir au menu Système"
    Write-Host "2 - Revenir au menu principal"
    Write-Host "q - Quitter le script"
    $choix_secondaire = Read-Host "Quel est votre choix ?"

    switch ($choix_secondaire) {
        "1" {
            Log "Retour menu systeme"
            Write-Host "Vous retournez au menu Système"
            Start-Sleep 3
            return
        }
        "2" {
            Log "Retour au menu principal"
            Write-Host "Vous retournez au menu principal"
            Start-Sleep 3
            exit 0
        }
        "q" {
            Log "Quitte le script"
            Write-Host "Vous quittez le script"
            Start-Sleep 3
            exit 50
        }
        default {
            Write-Host "L'option choisie n'existe pas, veuillez recommencer"
            Start-Sleep 3
            MenuSecondaire
        }
    }
}

Log "Demande sur systeme"
Write-Host "Bienvenue dans les informations système"
Start-Sleep 3
Clear-Host

while ($true) {
    Write-Host "Que souhaitez-vous savoir ?"
    Write-Host "1 - Version de l'OS"
    Write-Host "2 - Mises à jour critiques"
    Write-Host "3 - Marque et modèle"
    Write-Host "4 - Statut UAC"
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
        "4" {
            Log "Consulte statut UAC"
            if ($uac_status -eq 1) {
                Write-Host "L'UAC est activé sur $ssh_client"
            } else {
                Write-Host "L'UAC est désactivé sur $ssh_client"
            }
            MenuSecondaire
        }
        "r" {
            Log "Retour arrière"
            Write-Host "Vous allez revenir au menu principal"
            Start-Sleep 3
            exit 0
        }
        "q" {
            Log "Quitte le script"
            Write-Host "Vous quittez le script"
            Start-Sleep 3
            exit 50
        }
        default {
            Write-Host "L'option choisie n'existe pas, veuillez recommencer"
        }
    }
}
