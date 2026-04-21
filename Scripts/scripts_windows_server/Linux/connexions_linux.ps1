. "./scripts_windows_server/utilitaire.ps1"

# Variables principales 
$derniers_logins = ssh $ssh_client "last -n 5 | grep 'pts'"
$ipcon_client = ssh $ssh_client "ip route get 1 | awk '{print `$7; exit}'"
$prefixe = ssh $ssh_client "ip a | grep 'inet ' | grep -v '127.0.0.1' | awk '{print `$2}' | cut -d'/' -f2"
$masque_client = ConvertirMasque -prefixe $prefixe
$passerelle_client = ssh $ssh_client "ip route | grep 'default' | awk '{print `$3}'"

function MenuSecondaire {
    Write-Host "1 - Revenir au menu Connexion"
    Write-Host "2 - Revenir au menu principal"
    Write-Host "q - Quitter le script"
    $choix_secondaire = Read-Host "Quel est votre choix ?"

    switch ($choix_secondaire) {
        "1" {
            Log "Retour menu connexion"
            Write-Host "Vous retournez au menu connexion"
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

Log "Demande sur connexion"
Write-Host "Bienvenue dans le menu connexion"
Start-Sleep 3
Clear-Host

while ($true) {
    Write-Host "Menu Connexion"
    Write-Host "Que souhaitez-vous connaitre ?"
    Write-Host "1 - Les 5 dernières connexions à distance"
    Write-Host "2 - Adresse IP, masque IP et passerelle du Client"
    Write-Host "3 - Revenir au menu principal"
    Write-Host "q - Quitter le script"
    $choix = Read-Host "Quel est votre choix ?"

    switch ($choix) {
        "1" {
            Log "cinq derniers login"
            Write-Host "Voici les 5 derniers loggings :"
            Write-Host $derniers_logins
            MenuSecondaire
        }
        "2" {
            Log "Affichage IP, Masque, Passerelle"
            Write-Host "L'adresse IP du client est $ipcon_client"
            Write-Host "Le masque de sous-réseau du client est $masque_client"
            Write-Host "La passerelle du client est $passerelle_client"
            MenuSecondaire
        }
        "3" {
            Log "Retour arrière"
            Write-Host "Vous allez revenir au menu principal"
            Start-Sleep 1
            exit 0
        }
        "q" {
            Log "EndScript"
            Write-Host "Vous quittez le script"
            Start-Sleep 1
            exit 50
        }
        default {
            Write-Host "L'option choisie n'existe pas, veuillez recommencer"
        }
    }
}