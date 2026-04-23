param(
    [string]$REMOTE_PC,
    [System.Management.Automation.PSCredential]$REMOTE_CRED
)
. "$PSScriptRoot\..\utilitaire.ps1"

function MenuSecondaire {
    Write-Host "1 - Revenir au menu Utilisateurs"
    Write-Host "2 - Revenir au menu principal"
    Write-Host "q - Quitter le script"
    $choix_secondaire = Read-Host "Quel est votre choix ?"

    switch ($choix_secondaire) {
        '1' {
            Log "Retour menu utilisateurs"
            Write-Host "Vous retournez au menu Utilisateurs" -ForegroundColor Cyan
            Start-Sleep -Seconds 1
            return
        }
        '2' {
            Log "Retour au menu principal"
            Write-Host "Vous retournez au menu principal" -ForegroundColor Cyan
            Start-Sleep -Seconds 1
            exit 0
        }
        'q' {
            Log "Quitte le script"
            Write-Host "Vous quittez le script" -ForegroundColor Cyan
            Start-Sleep -Seconds 1
            exit 50
        }
        default {
            Write-Host "L'option choisie n'existe pas, veuillez recommencer" -ForegroundColor Red
            Start-Sleep -Seconds 1
            MenuSecondaire
        }
    }
}

Log "Demande sur utilisateurs"
Write-Host "Bienvenue dans la gestion des Utilisateurs" -ForegroundColor Green
Start-Sleep -Seconds 1
Clear-Host

while ($true) {
    Write-Host "Menu Utilisateurs" -ForegroundColor Yellow
    Write-Host "Que souhaitez-vous faire sur le poste client ($REMOTE_PC) ?"
    Write-Host "1 - Creation de compte utilisateur local"
    Write-Host "2 - Changement de mot de passe"
    Write-Host "3 - Suppression de compte utilisateur local"
    Write-Host "4 - Revenir au menu principal"
    Write-Host "q - Quitter le script"
    $choix = Read-Host "Quel est votre choix ?"

    switch ($choix) {
        '1' {
            Log "Initialisation creation utilisateur client"
            $cible_username = Read-Host "Saisissez le nom du nouvel utilisateur"
            $nouveau_password = Read-Host "Saisissez le mot de passe initial" -AsSecureString

            $ScriptBlock = {
                param($user, $pwd)
                $exists = Get-LocalUser -Name $user -ErrorAction SilentlyContinue
                if ($null -eq $exists) {
                    New-LocalUser -Name $user -Password $pwd -Description "Cree via script d'administration"
                    return $true
                } else {
                    return $false
                }
            }

            $result = Invoke-Command -ComputerName $REMOTE_PC -Credential $REMOTE_CRED -ScriptBlock $ScriptBlock -ArgumentList $cible_username, $nouveau_password

            if ($result -eq $true) {
                Write-Host "L'utilisateur $cible_username a ete cree avec succes." -ForegroundColor Green
                Log "Succes creation utilisateur $cible_username"
            } else {
                Write-Host "Erreur : L'utilisateur $cible_username existe deja ou a echoue." -ForegroundColor Red
                Log "Erreur creation utilisateur $cible_username"
            }
            MenuSecondaire
        }

        '2' {
            Log "Initialisation changement de mot de passe client"
            $cible_username = Read-Host "Saisissez le nom de l'utilisateur"
            $nouveau_password = Read-Host "Saisissez le nouveau mot de passe" -AsSecureString

            $ScriptBlock = {
                param($user, $pwd)
                Set-LocalUser -Name $user -Password $pwd
            }

            try {
                Invoke-Command -ComputerName $REMOTE_PC -Credential $REMOTE_CRED -ScriptBlock $ScriptBlock -ArgumentList $cible_username, $nouveau_password -ErrorAction Stop
                Write-Host "Le mot de passe de $cible_username a ete mis a jour." -ForegroundColor Green
                Log "Succes changement mdp $cible_username"
            } catch {
                Write-Host "Erreur lors du changement de mot de passe." -ForegroundColor Red
                Log "Erreur changement mdp $cible_username"
            }
            MenuSecondaire
        }

        '3' {
            Log "Initiation suppression utilisateur client"
            $cible_username = Read-Host "Saisissez le nom de l'utilisateur a supprimer"
            $confirm = Read-Host "Etes-vous sur de vouloir supprimer $cible_username ? (o/n)"

            if ($confirm -eq 'o') {
                $ScriptBlock = {
                    param($user)
                    Remove-LocalUser -Name $user
                }

                try {
                    Invoke-Command -ComputerName $REMOTE_PC -Credential $REMOTE_CRED -ScriptBlock $ScriptBlock -ArgumentList $cible_username -ErrorAction Stop
                    Write-Host "L'utilisateur $cible_username a ete supprime." -ForegroundColor Green
                    Log "Succes suppression utilisateur $cible_username"
                } catch {
                    Write-Host "Erreur lors de la suppression." -ForegroundColor Red
                    Log "Erreur suppression utilisateur $cible_username"
                }
            } else {
                Write-Host "Action annulee." -ForegroundColor Yellow
                Log "Annulation suppression utilisateur $cible_username"
            }
            MenuSecondaire
        }

        '4' {
            Log "Retour au menu principal"
            Write-Host "Vous revenez au menu principal" -ForegroundColor Cyan
            Start-Sleep -Seconds 1
            exit 0
        }

        'q' {
            Log "Quitte le script"
            Write-Host "Vous quittez le script" -ForegroundColor Cyan
            Start-Sleep -Seconds 1
            exit 50
        }

        default {
            Write-Host "L'option choisie n'existe pas, veuillez recommencer" -ForegroundColor Red
            Start-Sleep -Seconds 1
        }
    }
}
