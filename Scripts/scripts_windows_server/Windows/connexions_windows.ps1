param(
    [string]$REMOTE_PC,
    [System.Management.Automation.PSCredential]$REMOTE_CRED
)
. "$PSScriptRoot\..\utilitaire.ps1"

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
    Write-Host "1 - Les 5 dernieres connexions a distance"
    Write-Host "2 - Adresse IP, masque IP et passerelle du Client"
    Write-Host "3 - Revenir au menu principal"
    Write-Host "q - Quitter le script"
    $choix = Read-Host "Quel est votre choix ?"

    switch ($choix) {
        "1" {
            Log "cinq derniers login"
            Write-Host "Voici les 5 derniers loggings :"
            Invoke-Command -ComputerName $REMOTE_PC -Credential $REMOTE_CRED -ScriptBlock {
                Get-WinEvent -FilterHashtable @{LogName='Security'; Id=4624} -MaxEvents 5 |
                ForEach-Object {
                    $xml = [xml]$_.ToXml()
                    $user = $xml.Event.EventData.Data |
                            Where-Object { $_.Name -eq 'TargetUserName' } |
                            Select-Object -ExpandProperty '#text'
                    [PSCustomObject]@{
                        Date     = $_.TimeCreated
                        Username = $user
                    }
                } | Format-Table -AutoSize
            }
            MenuSecondaire
        }
        "2" {
            Log "Affichage IP, Masque, Passerelle"
            $infos = Invoke-Command -ComputerName $REMOTE_PC -Credential $REMOTE_CRED -ScriptBlock {
                $ip = Get-NetIPAddress -AddressFamily IPv4 |
                      Where-Object { $_.InterfaceAlias -notlike '*Loopback*' } |
                      Select-Object -ExpandProperty IPAddress
                $prefixe = Get-NetIPAddress -AddressFamily IPv4 |
                           Where-Object { $_.InterfaceAlias -notlike '*Loopback*' } |
                           Select-Object -ExpandProperty PrefixLength
                $passerelle = Get-NetRoute -DestinationPrefix 0.0.0.0/0 |
                              Select-Object -ExpandProperty NextHop
                [PSCustomObject]@{ IP = $ip; Prefixe = $prefixe; Passerelle = $passerelle }
            }
            $masque = ConvertirMasque -prefixe $infos.Prefixe
            Write-Host "Adresse IP      : $($infos.IP)"
            Write-Host "Masque          : $masque"
            Write-Host "Passerelle      : $($infos.Passerelle)"
            MenuSecondaire
        }
        "3" {
            Log "Retour arriere"
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
