param(
    [string]$REMOTE_PC,
    [System.Management.Automation.PSCredential]$REMOTE_CRED
)
. "$PSScriptRoot\..\utilitaire.ps1"
# Variables principales - commandes PowerShell pour client Windows
$derniers_logins = ssh $ssh_client "powershell.exe -Command 'Get-EventLog -LogName Security -InstanceId 4624 -Newest 5 | Select-Object TimeGenerated, UserName'"
$ipcon_client = ssh $ssh_client "powershell.exe -Command 'Get-NetIPAddress -AddressFamily IPv4 | Where-Object {\$_.InterfaceAlias -notlike ''*Loopback*''} | Select-Object -ExpandProperty IPAddress'"
$prefixe = ssh $ssh_client "powershell.exe -Command 'Get-NetIPAddress -AddressFamily IPv4 | Where-Object {\$_.InterfaceAlias -notlike ''*Loopback*''} | Select-Object -ExpandProperty PrefixLength'"
$masque_client = ConvertirMasque -prefixe $prefixe
$passerelle_client = ssh $ssh_client "powershell.exe -Command 'Get-NetRoute -DestinationPrefix 0.0.0.0/0 | Select-Object -ExpandProperty NextHop'"

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
Start-Sleep 1
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
