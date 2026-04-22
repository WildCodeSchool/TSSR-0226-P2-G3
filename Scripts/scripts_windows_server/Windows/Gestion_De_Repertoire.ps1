function menu_secondaire {
    Write-Host "1 - Revenir au menu répertoires"
    Write-Host "2 - Revenir au menu principal"
    Write-Host "q - Quitter le script"
    $choix_secondaire = Read-Host "Quel est votre choix ?"

    switch ($choix_secondaire) {
        "1" {
            Write-Log "Retour menu répertoires"
            Write-Host "Vous retournez au menu répertoires"
            Start-Sleep -Seconds 1
            return
        }
        "2" {
            Write-Log "Retour au menu principal"
            Write-Host "Vous retournez au menu principal"
            Start-Sleep -Seconds 1
            exit 0
        }
        "q" {
            Write-Log "Quitte le script"
            Write-Host "Vous quittez le script"
            Start-Sleep -Seconds 1
            exit 50
        }
        default {
            Write-Host "L'option choisie n'existe pas, veuillez recommencer"
            Start-Sleep -Seconds 1
            menu_secondaire
        }
    }
}

# Menu Répertoires
Write-Log "Demande sur répertoire"
Write-Host "Bienvenue dans le menu répertoires"
Start-Sleep -Seconds 1
Clear-Host

while ($true) {
    Write-Host "Que souhaitez-vous faire ?"
    Write-Host "1- Créer un répertoire"
    Write-Host "2- Supprimer un répertoire"
    Write-Host "r - Revenir au menu précédent"
    Write-Host "q - Quitter le script"
    $choix = Read-Host "Quel est votre choix ? :"

    switch ($choix) {
        "1" {
            Write-Log "Création répertoire"
            Write-Host "Exemple: C:\Users\user\monrepertoire ou C:\Temp\monrepertoire"
            $repo = Read-Host "Entrez le chemin du répertoire à créer : "

            if ([string]::IsNullOrWhiteSpace($repo)) {
                Write-Host "Erreur : saisie vide, veuillez recommencer."
                return
            }

            $existe = Invoke-Command -ComputerName $IPCible -Credential $credential -ScriptBlock {
                param($chemin)
                Test-Path -Path $chemin
            } -ArgumentList $repo

            if ($existe -eq $true) {
                Write-Host "Ce répertoire existe déjà, création refusée."
                return
            }

            $creation = Read-Host "Voulez-vous vraiment créer ce répertoire ? (O/N)"
            if ($creation -eq "o" -or $creation -eq "O") {
                Invoke-Command -ComputerName $IPCible -Credential $credential -ScriptBlock {
                    param($chemin)
                    New-Item -ItemType Directory -Path $chemin
                } -ArgumentList $repo
                Write-Host "Le répertoire '$repo' a été créé avec succès."
            } else {
                Write-Host "Création annulée."
            }
            menu_secondaire
        }

        "2" {
            Write-Log "Suppression répertoire"
            Write-Host "Exemple: C:\Users\user\monrepertoire ou C:\Temp\monrepertoire"
            $repoSupp = Read-Host "Entrez le chemin du répertoire à supprimer : "

            $existe = Invoke-Command -ComputerName $IPCible -Credential $credential -ScriptBlock {
                param($chemin)
                Test-Path -Path $chemin
            } -ArgumentList $repoSupp

            if ($existe -eq $false) {
                Write-Host "Le répertoire '$repoSupp' n'existe pas."
                return
            }

            $supprime = Read-Host "Voulez-vous vraiment supprimer ce répertoire ? (O/N) : "
            if ($supprime -eq "o" -or $supprime -eq "O") {
                Invoke-Command -ComputerName $IPCible -Credential $credential -ScriptBlock {
                    param($chemin)
                    Remove-Item -Recurse -Force -Path $chemin
                } -ArgumentList $repoSupp
                Write-Host "Le répertoire '$repoSupp' a été supprimé avec succès."
            } else {
                Write-Host "Suppression annulée."
            }
            menu_secondaire
        }

        "r" {
            Write-Log "Retour arrière"
            Write-Host "Vous allez revenir au menu principal"
            Start-Sleep -Seconds 1
            exit 0
        }

        "q" {
            Write-Log "Quitte le script"
            Write-Host "Vous quittez le script"
            Start-Sleep -Seconds 1
            exit 50
        }

        default {
            Write-Host "L'option choisie n'existe pas, veuillez recommencer"
        }
    }
}