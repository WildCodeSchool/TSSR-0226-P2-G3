# Définition de la fonction de journalisation (à adapter si elle est gérée par le parent)
function Write-Log {
    param([string]$Message)
    $Date = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
    Add-Content -Path "C:\logs\log_evt.log" -Value "[$Date] $Message"
}

# Sous-menu pour gérer la navigation
function Show-MenuSecondaire {
    Write-Host "1 - Revenir au menu Utilisateurs"
    Write-Host "2 - Revenir au menu principal"
    Write-Host "q - Quitter le script"
    $choix_secondaire = Read-Host "Quel est votre choix ?"

    switch ($choix_secondaire) {
        '1' {
            Write-Log "Retour menu utilisateurs"
            Write-Host "Vous retournez au menu Utilisateurs" -ForegroundColor Cyan
            Start-Sleep -Seconds 3
            return # Permet de sortir de la fonction et de relancer la boucle
        }
        '2' {
            Write-Log "Retour au menu principal"
            Write-Host "Vous retournez au menu principal" -ForegroundColor Cyan
            Start-Sleep -Seconds 3
            exit 0 # Quitte le script enfant et redonne la main au script parent
        }
        'q' {
            Write-Log "Quitte le script"
            Write-Host "Vous quittez le script" -ForegroundColor Cyan
            Start-Sleep -Seconds 3
            exit 50 # Quitte totalement avec un code d'erreur spécifique
        }
        default {
            Write-Host "L'option choisie n'existe pas, veuillez recommencer" -ForegroundColor Red
            Start-Sleep -Seconds 3
            Show-MenuSecondaire # Rappel récursif si erreur
        }
    }
}

Write-Log "Demande sur utilisateurs"
Write-Host "Bienvenue dans la gestion des Utilisateurs" -ForegroundColor Green
Start-Sleep -Seconds 3
Clear-Host

# Boucle principale du menu
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
            Write-Log "Initialisation création utilisateur client"
            $cible_username = Read-Host "Saisissez le nom du nouvel utilisateur"
            # Read-Host -AsSecureString masque la saisie nativement
            $nouveau_password = Read-Host "Saisissez le mot de passe initial" -AsSecureString
            
            # Bloc de commande exécuté à distance via WinRM
            $ScriptBlock = {
                param($user, $pwd)
                # Vérification si l'utilisateur existe (SilentlyContinue masque l'erreur si introuvable)
                $exists = Get-LocalUser -Name $user -ErrorAction SilentlyContinue
                if ($null -eq $exists) {
                    New-LocalUser -Name $user -Password $pwd -Description "Créé via script d'administration"
                    return $true
                } else {
                    return $false
                }
            }

            # Lancement de l'action sur le client
            $result = Invoke-Command -ComputerName $ip_client -Credential $cred -ScriptBlock $ScriptBlock -ArgumentList $cible_username, $nouveau_password

            if ($result -eq $true) {
                Write-Host "L'utilisateur $cible_username a été créé avec succès." -ForegroundColor Green
                Write-Log "Succès création utilisateur $cible_username"
            } else {
                Write-Host "Erreur : L'utilisateur $cible_username existe déjà ou a échoué." -ForegroundColor Red
                Write-Log "Erreur création utilisateur $cible_username"
            }
            Show-MenuSecondaire
        }

        '2' {
            Write-Log "Initialisation changement de mot de passe client"
            $cible_username = Read-Host "Saisissez le nom de l'utilisateur"
            $nouveau_password = Read-Host "Saisissez le nouveau mot de passe" -AsSecureString

            $ScriptBlock = {
                param($user, $pwd)
                Set-LocalUser -Name $user -Password $pwd
            }

            try {
                Invoke-Command -ComputerName $ip_client -Credential $cred -ScriptBlock $ScriptBlock -ArgumentList $cible_username, $nouveau_password -ErrorAction Stop
                Write-Host "Le mot de passe de $cible_username a été mis à jour." -ForegroundColor Green
                Write-Log "Succès changement mdp $cible_username"
            } catch {
                Write-Host "Erreur lors du changement de mot de passe." -ForegroundColor Red
                Write-Log "Erreur changement mdp $cible_username"
            }
            Show-MenuSecondaire
        }

        '3' {
            Write-Log "Initiation suppression utilisateur client"
            $cible_username = Read-Host "Saisissez le nom de l'utilisateur à supprimer"
            $confirm = Read-Host "Êtes-vous sûr de vouloir supprimer $cible_username ? (o/n)"

            if ($confirm -eq 'o') {
                $ScriptBlock = {
                    param($user)
                    Remove-LocalUser -Name $user
                }

                try {
                    Invoke-Command -ComputerName $ip_client -Credential $cred -ScriptBlock $ScriptBlock -ArgumentList $cible_username -ErrorAction Stop
                    Write-Host "L'utilisateur $cible_username a été supprimé." -ForegroundColor Green
                    Write-Log "Succès suppression utilisateur $cible_username"
                } catch {
                    Write-Host "Erreur lors de la suppression." -ForegroundColor Red
                    Write-Log "Erreur suppression utilisateur $cible_username"
                }
            } else {
                Write-Host "Action annulée." -ForegroundColor Yellow
                Write-Log "Annulation suppression utilisateur $cible_username"
            }
            Show-MenuSecondaire
        }

        '4' {
            Write-Log "Retour au menu principal"
            Write-Host "Vous revenez au menu principal" -ForegroundColor Cyan
            Start-Sleep -Seconds 3
            exit 0
        }

        'q' {
            Write-Log "Quitte le script"
            Write-Host "Vous quittez le script" -ForegroundColor Cyan
            Start-Sleep -Seconds 3
            exit 50
        }

        default {
            Write-Host "L'option choisie n'existe pas, veuillez recommencer" -ForegroundColor Red
            Start-Sleep -Seconds 3
        }
    }
}