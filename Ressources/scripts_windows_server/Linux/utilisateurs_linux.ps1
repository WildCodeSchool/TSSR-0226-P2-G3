. "$PSScriptRoot\scripts_windows_server\utilitaire.ps1"

# Sous-menu pour gérer la navigation
function MenuSecondaire {
    Write-Host "1 - Revenir au menu Utilisateurs"
    Write-Host "2 - Revenir au menu principal"
    Write-Host "q - Quitter le script"
    $choix_secondaire = Read-Host "Quel est votre choix ?"

    switch ($choix_secondaire) {
        '1' {
            Write-Log "Retour menu utilisateurs"
            Write-Host "Vous retournez au menu Utilisateurs" -ForegroundColor Cyan
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
            MenuSecondaire
        }
    }
}

Log "Demande sur utilisateurs"
Write-Host "Bienvenue dans la gestion des Utilisateurs" -ForegroundColor Green
Start-Sleep -Seconds 1
Clear-Host

# Boucle principale du menu Utilisateurs
while ($true) {
    Write-Host "Menu Utilisateurs" -ForegroundColor Yellow
    Write-Host "Que souhaitez-vous faire sur le poste client ($ip_client) ?"
    Write-Host "1 - Création de compte utilisateur local"
    Write-Host "2 - Changement de mot de passe"
    Write-Host "3 - Suppression de compte utilisateur local"
    Write-Host "4 - Revenir au menu principal"
    Write-Host "q - Quitter le script"
    $choix = Read-Host "Quel est votre choix ?"

    switch ($choix) {
        '1' {
            Log "Initialisation création utilisateur client Linux"
            $cible_username = Read-Host "Saisissez le nom du nouvel utilisateur"
            
            # Vérification de l'existence du compte via SSH
            $utilisateur_exist = ssh $ssh_user@$ip_client "grep '^$cible_username:' /etc/passwd"

            if ([string]::IsNullOrWhiteSpace($utilisateur_exist)) {
                # Création via SSH avec sudo (autorisé par visudo)
                ssh $ssh_user@$ip_client "sudo useradd -m $cible_username"
                
                # $LASTEXITCODE capte la réussite (0) ou l'échec de la commande SSH
                if ($LASTEXITCODE -eq 0) {
                    Write-Host "L'utilisateur $cible_username a été créé avec succès." -ForegroundColor Green
                    Log "Succès création utilisateur $cible_username"
                } else {
                    Write-Host "Erreur critique : L'utilisateur n'a pas pu être créé." -ForegroundColor Red
                    Log "Erreur création utilisateur $cible_username (Échec SSH/Sudo)"
                }
            } else {
                Write-Host "Erreur : L'utilisateur $cible_username existe déjà sur la machine cible." -ForegroundColor Red
                Log "Erreur création utilisateur $cible_username (existe déjà)"
            }
            MenuSecondaire
        }

        '2' {
            Log "Initialisation changement de mot de passe client Linux"
            $cible_username = Read-Host "Saisissez le nom de l'utilisateur"
            $nouveau_password = Read-Host "Saisissez le nouveau mot de passe" 
            Write-Host ""

            # Changement de mot de passe envoyé de manière non-interactive
            ssh $ssh_user@$ip_client "echo '$cible_username:$nouveau_password' | sudo chpasswd"

            if ($LASTEXITCODE -eq 0) {
                Write-Host "Le mot de passe de $cible_username a été mis à jour." -ForegroundColor Green
                Log "Succès changement mdp $cible_username"
            } else {
                Write-Host "Erreur lors du changement de mot de passe." -ForegroundColor Red
                Log "Erreur changement mdp $cible_username"
            }
            MenuSecondaire
        }

        '3' {
            Log "Initiation suppression utilisateur client Linux"
            $cible_username = Read-Host "Saisissez le nom de l'utilisateur à supprimer"
            $confirm = Read-Host "Êtes-vous sûr de vouloir supprimer $cible_username ? (o/n)"

            if ($confirm -eq 'o') {
                # Suppression du compte et de son répertoire personnel
                ssh $ssh_user@$ip_client "sudo userdel -r $cible_username"
                
                if ($LASTEXITCODE -eq 0) {
                    Write-Host "L'utilisateur $cible_username a été supprimé." -ForegroundColor Green
                    Log "Succès suppression utilisateur $cible_username"
                } else {
                    Write-Host "Erreur lors de la suppression." -ForegroundColor Red
                    Log "Erreur suppression utilisateur $cible_username"
                }
            } else {
                Write-Host "Action annulée." -ForegroundColor Yellow
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
