# Définition de la fonction de journalisation
function Write-Log {
    param([string]$Message)
    $Date = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
    Add-Content -Path "C:\logs\log_evt.log" -Value "[$Date] $Message"
}

# Sous-menu pour gérer la navigation
function Show-MenuSecondaire {
    Write-Host "1 - Revenir au menu Groupes"
    Write-Host "2 - Revenir au menu principal"
    Write-Host "q - Quitter le script"
    $choix_secondaire = Read-Host "Quel est votre choix ?"

    switch ($choix_secondaire) {
        '1' {
            Write-Log "Retour menu groupes"
            Write-Host "Vous retournez au menu Groupes" -ForegroundColor Cyan
            Start-Sleep -Seconds 1
            return
        }
        '2' {
            Write-Log "Retour au menu principal"
            Write-Host "Vous retournez au menu principal" -ForegroundColor Cyan
            Start-Sleep -Seconds 1
            exit 0
        }
        'q' {
            Write-Log "Quitte le script"
            Write-Host "Vous quittez le script" -ForegroundColor Cyan
            Start-Sleep -Seconds 1
            exit 50
        }
        default {
            Write-Host "L'option choisie n'existe pas, veuillez recommencer" -ForegroundColor Red
            Start-Sleep -Seconds 1
            Show-MenuSecondaire
        }
    }
}

Write-Log "Demande sur groupes (Cible: Linux)"
Write-Host "Bienvenue dans la gestion des Groupes (Cible : Ubuntu)" -ForegroundColor Green
Start-Sleep -Seconds 1
Clear-Host

# Boucle principale du menu Groupes
while ($true) {
    Write-Host "Menu Groupes (Cible Linux)" -ForegroundColor Yellow
    Write-Host "Que souhaitez-vous faire sur le poste client ($ip_client) ?"
    Write-Host "1 - Ajout à un groupe d'administration"
    Write-Host "2 - Ajout à un groupe standard"
    Write-Host "3 - Sortie d'un groupe"
    Write-Host "4 - Revenir au menu principal"
    Write-Host "q - Quitter le script"
    $choix = Read-Host "Quel est votre choix ?"

    switch ($choix) {
        '1' {
            Write-Log "Initiation ajout admin client Linux"
            $cible_username = Read-Host "Quel utilisateur doit devenir administrateur ?"

            # Ajout au groupe 'sudo' spécifique à Ubuntu via SSH
            ssh $ssh_user@$ip_client "sudo usermod -aG sudo $cible_username"
            
            if ($LASTEXITCODE -eq 0) {
                Write-Host "$cible_username a été ajouté au groupe d'administration (sudo)." -ForegroundColor Green
                Write-Log "Succès ajout admin (sudo) pour $cible_username"
            } else {
                Write-Host "Erreur lors de l'ajout au groupe d'administration." -ForegroundColor Red
                Write-Log "Erreur ajout admin pour $cible_username"
            }
            Show-MenuSecondaire
        }

        '2' {
            Write-Log "Initiation ajout groupe client Linux"
            $cible_username = Read-Host "Nom de l'utilisateur"
            $cible_groupe = Read-Host "Dans quel groupe souhaitez-vous l'ajouter ?"

            # Ajout à un groupe standard
            ssh $ssh_user@$ip_client "sudo usermod -aG $cible_groupe $cible_username"
            
            if ($LASTEXITCODE -eq 0) {
                Write-Host "$cible_username a été ajouté au groupe $cible_groupe." -ForegroundColor Green
                Write-Log "Succès ajout groupe $cible_groupe pour $cible_username"
            } else {
                Write-Host "Erreur lors de l'ajout au groupe $cible_groupe." -ForegroundColor Red
                Write-Log "Erreur ajout groupe $cible_groupe pour $cible_username"
            }
            Show-MenuSecondaire
        }

        '3' {
            Write-Log "Initiation sortie groupe client Linux"
            $cible_username = Read-Host "Nom de l'utilisateur"
            $cible_groupe = Read-Host "De quel groupe souhaitez-vous le retirer ?"

            # Retrait du groupe via gpasswd
            ssh $ssh_user@$ip_client "sudo gpasswd -d $cible_username $cible_groupe"
            
            if ($LASTEXITCODE -eq 0) {
                Write-Host "$cible_username a été retiré du groupe $cible_groupe." -ForegroundColor Green
                Write-Log "Succès sortie groupe $cible_groupe pour $cible_username"
            } else {
                Write-Host "Erreur lors de la sortie du groupe $cible_groupe." -ForegroundColor Red
                Write-Log "Erreur sortie groupe $cible_groupe pour $cible_username"
            }
            Show-MenuSecondaire
        }

        '4' {
            Write-Log "Retour au menu principal"
            Write-Host "Vous revenez au menu principal" -ForegroundColor Cyan
            Start-Sleep -Seconds 1
            exit 0
        }

        'q' {
            Write-Log "Quitte le script"
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