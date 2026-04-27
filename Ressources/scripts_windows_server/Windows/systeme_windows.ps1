param(
    [string]$REMOTE_PC,
    [System.Management.Automation.PSCredential]$REMOTE_CRED
)
. "$PSScriptRoot\..\utilitaire.ps1"

function MenuSecondaire {
    Write-Host "1 - Revenir au menu Systeme"
    Write-Host "2 - Revenir au menu principal"
    Write-Host "q - Quitter le script"
    $choix_secondaire = Read-Host "Quel est votre choix ?"
    switch ($choix_secondaire) {
        "1" {
            Log "Retour menu systeme"
            Write-Host "Vous retournez au menu Systeme"
            Start-Sleep 1
            Clear-Host
            return
        }
        "2" {
            Log "Retour au menu principal"
            Write-Host "Vous retournez au menu principal"
            Start-Sleep 1
            Clear-Host
            exit 0
        }
        "q" {
            Log "Quitte le script"
            Write-Host "Vous quittez le script"
            Start-Sleep 1
            Clear-Host
            exit 50
        }
        default {
            Write-Host "L'option choisie n'existe pas, veuillez recommencer"
            Start-Sleep 1
            Clear-Host
            MenuSecondaire
        }
    }
}

Log "Demande sur systeme"
Write-Host "Bienvenue dans les informations systeme"
Start-Sleep 1
Clear-Host

while ($true) {
    Write-Host "Menu Système"
    Write-Host "Que souhaitez-vous savoir ?"
    Write-Host "1 - Version de l'OS"
    Write-Host "2 - Mises a jour critiques"
    Write-Host "3 - Marque et modele"
    Write-Host "4 - Statut UAC"
    Write-Host "r - Revenir au menu precedent"
    Write-Host "q - Quitter le script"
    $choix = Read-Host "Quel est votre choix ?"

    switch ($choix) {
        "1" {
            Log "Consulte version OS"
            $version_os = Invoke-Command -ComputerName $REMOTE_PC -Credential $REMOTE_CRED -ScriptBlock {
                (Get-CimInstance Win32_OperatingSystem).Caption
            }
            Write-Host "La version de l'OS est : $version_os"
            MenuSecondaire
        }
        "2" {
            Log "Consulte mises a jour critiques"
            Invoke-Command -ComputerName $REMOTE_PC -Credential $REMOTE_CRED -ScriptBlock {
                $maj = Get-HotFix | Where-Object { $_.Description -eq "Security Update" }
                Write-Host "Nombre de mises a jour critiques : $($maj.Count)"
                $maj | Select-Object HotFixID, InstalledOn | Format-Table -AutoSize
            }
            MenuSecondaire
        }
        "3" {
            Log "Consulte marque et modele"
            $marque_modele = Invoke-Command -ComputerName $REMOTE_PC -Credential $REMOTE_CRED -ScriptBlock {
                $cs = Get-CimInstance Win32_ComputerSystem
                "$($cs.Manufacturer) $($cs.Model)"
            }
            Write-Host "Le client est de la marque/modele : $marque_modele"
            MenuSecondaire
        }
        "4" {
            Log "Consulte statut UAC"
            $uac = Invoke-Command -ComputerName $REMOTE_PC -Credential $REMOTE_CRED -ScriptBlock {
                (Get-ItemProperty "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System").EnableLUA
            }
            if ($uac -eq 1) {
                Write-Host "L'UAC est active sur $REMOTE_PC"
            } else {
                Write-Host "L'UAC est desactive sur $REMOTE_PC"
            }
            MenuSecondaire
        }
        "r" {
            Log "Retour arriere"
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
