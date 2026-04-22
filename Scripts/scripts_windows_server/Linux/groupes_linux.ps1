. "./scripts_windows_server/utilitaire.ps1"

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

Log "Demande sur groupes"
Write-Host "Bienvenue dans la gestion des Groupes" -ForegroundColor Green
Start-Sleep -Seconds 1
Clear-Host

# Boucle principale du menu Groupes
while ($true) {
    Write-Host "Menu Groupes" -ForegroundColor Yellow
    Write-Host "Que souhaitez-vous faire sur le poste client ($ip_client) ?"
    Write-Host "1 - Ajout à un groupe d'administration"
    Write-Host "2 - Ajout à un groupe standard"
    Write-Host "3 - Sortie d'un groupe"
    Write-Host "4 - Revenir au menu principal"
    Write-Host "q - Quitter le script"
    $choix = Read-Host "Quel est votre choix ?"

    switch ($choix) {
        '1' {
            Log "Initiation ajout admin client Linux"
            $cible_username = Read-Host "Quel utilisateur doit devenir administrateur ?"

            # Ajout au groupe 'sudo' spécifique à Ubuntu via SSH
            ssh $ssh_user@$ip_client "sudo usermod -aG sudo $cible_username"
            
            if ($LASTEXITCODE -eq 0) {
                Write-Host "$cible_username a été ajouté au groupe d'administration." -ForegroundColor Green
                Log "Succès ajout admin pour $cible_username"
            } else {
                Write-Host "Erreur lors de l'ajout au groupe d'administration." -ForegroundColor Red
                Log "Erreur ajout admin pour $cible_username"
            }
            MenuSecondaire
        }

        '2' {
            Log "Initiation ajout groupe client Linux"
            $cible_username = Read-Host "Nom de l'utilisateur"
            $cible_groupe = Read-Host "Dans quel groupe souhaitez-vous l'ajouter ?"

            # Ajout à un groupe standard
            ssh $ssh_user@$ip_client "sudo usermod -aG $cible_groupe $cible_username"
            
            if ($LASTEXITCODE -eq 0) {
                Write-Host "$cible_username a été ajouté au groupe $cible_groupe." -ForegroundColor Green
                Log "Succès ajout groupe $cible_groupe pour $cible_username"
            } else {
                Write-Host "Erreur lors de l'ajout au groupe $cible_groupe." -ForegroundColor Red
                Log "Erreur ajout groupe $cible_groupe pour $cible_username"
            }
            MenuSecondaire
        }

        '3' {
            Log "Initiation sortie groupe client Linux"
            $cible_username = Read-Host "Nom de l'utilisateur"
            $cible_groupe = Read-Host "De quel groupe souhaitez-vous le retirer ?"

            # Retrait du groupe via gpasswd
            ssh $ssh_user@$ip_client "sudo gpasswd -d $cible_username $cible_groupe"
            
            if ($LASTEXITCODE -eq 0) {
                Write-Host "$cible_username a été retiré du groupe $cible_groupe." -ForegroundColor Green
                Log "Succès sortie groupe $cible_groupe pour $cible_username"
            } else {
                Write-Host "Erreur lors de la sortie du groupe $cible_groupe." -ForegroundColor Red
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
