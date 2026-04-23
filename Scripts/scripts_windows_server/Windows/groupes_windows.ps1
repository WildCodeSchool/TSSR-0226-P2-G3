# Appel utilitaires pour logs
param(
    [string]$REMOTE_PC,
    [System.Management.Automation.PSCredential]$REMOTE_CRED
)
. "$PSScriptRoot\..\utilitaire.ps1"

# Sous-menu pour gérer la navigation
function MenuSecondaire {
    Write-Host "1 - Revenir au menu Groupes"
    Write-Host "2 - Revenir au menu principal"
    Write-Host "q - Quitter le script"
    $choix_secondaire = Read-Host "Quel est votre choix ?"

    switch ($choix_secondaire) {
        '1' {
            Log "Retour menu groupes"
            Write-Host "Vous retournez au menu Groupes" -ForegroundColor Cyan
            Start-Sleep -Seconds 1
            Clear-Host
            return
        }
        '2' {
            Log "Retour au menu principal"
            Write-Host "Vous retournez au menu principal" -ForegroundColor Cyan
            Start-Sleep -Seconds 1
            Clear-Host
            exit 0
        }
        'q' {
            Log "Quitte le script"
            Write-Host "Vous quittez le script" -ForegroundColor Cyan
            Start-Sleep -Seconds 1
            Clear-Host
        
            exit 50
        }
        default {
            Write-Host "L'option choisie n'existe pas, veuillez recommencer" -ForegroundColor Red
            Start-Sleep -Seconds 1
            Clear-Host
            MenuSecondaire
        }
    }
}

Log "Demande sur groupes"
Write-Host "Bienvenue dans la gestion des Groupes" -ForegroundColor Green
Start-Sleep -Seconds 1
Clear-Host

# Boucle principale du menu
while ($true) {
    Write-Host "Menu Groupes" -ForegroundColor Yellow
    Write-Host "Que souhaitez-vous faire sur le poste client ($ip_client) ?"
    Write-Host "1 - Ajout à un groupe d'administration"
    Write-Host "2 - Ajout à un groupe standard"
    Write-Host "3 - Sortie d'un groupe"
    Write-Host "r - Revenir au menu principal"
    Write-Host "q - Quitter le script"
    $choix = Read-Host "Quel est votre choix ?"

    switch ($choix) {
        '1' {
            Log "Initiation ajout admin client"
            $cible_username = Read-Host "Quel utilisateur doit devenir administrateur ?"

            $ScriptBlock = {
                param($user)
                Add-LocalGroupMember -Group "Administrateurs" -Member $user
            }

            try {
                Invoke-Command -ComputerName $ip_client -Credential $cred -ScriptBlock $ScriptBlock -ArgumentList $cible_username -ErrorAction Stop
                Write-Host "$cible_username a été ajouté au groupe d'administration." -ForegroundColor Green
                Log "Succès ajout admin pour $cible_username"
            } catch {
                Write-Host "Erreur lors de l'ajout au groupe d'administration." -ForegroundColor Red
                Log "Erreur ajout admin pour $cible_username"
            }
            MenuSecondaire
        }

        '2' {
            Log "Initiation ajout groupe client"
            $cible_username = Read-Host "Nom de l'utilisateur"
            $cible_groupe = Read-Host "Dans quel groupe souhaitez-vous l'ajouter ?"

            $ScriptBlock = {
                param($group, $user)
                Add-LocalGroupMember -Group $group -Member $user
            }

            try {
                Invoke-Command -ComputerName $ip_client -Credential $cred -ScriptBlock $ScriptBlock -ArgumentList $cible_groupe, $cible_username -ErrorAction Stop
                Write-Host "$cible_username a été ajouté au groupe $cible_groupe." -ForegroundColor Green
                Log "Succès ajout groupe $cible_groupe pour $cible_username"
            } catch {
                Write-Host "Erreur lors de l'ajout de l'utilisateur au groupe." -ForegroundColor Red
                Log "Erreur ajout groupe $cible_groupe pour $cible_username"
            }
            MenuSecondaire
        }

        '3' {
            Log "Initiation sortie groupe client"
            $cible_username = Read-Host "Nom de l'utilisateur"
            $cible_groupe = Read-Host "De quel groupe souhaitez-vous le retirer ?"

            $ScriptBlock = {
                param($group, $user)
                Remove-LocalGroupMember -Group $group -Member $user
            }

            try {
                Invoke-Command -ComputerName $ip_client -Credential $cred -ScriptBlock $ScriptBlock -ArgumentList $cible_groupe, $cible_username -ErrorAction Stop
                Write-Host "$cible_username a été retiré du groupe $cible_groupe." -ForegroundColor Green
                Log "Succès sortie groupe $cible_groupe pour $cible_username"
            } catch {
                Write-Host "Erreur lors du retrait de l'utilisateur du groupe." -ForegroundColor Red
                Log "Erreur sortie groupe $cible_groupe pour $cible_username"
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
