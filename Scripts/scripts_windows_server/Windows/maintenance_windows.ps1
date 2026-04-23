# Appel utilitaires pour logs
. "$PSScriptRoot\..\utilitaire.ps1"

function MenuSecondaire {
    Write-Host "1 - Revenir au menu maintenance"
    Write-Host "2 - Revenir au menu principal"
    Write-Host "q - Quitter le script"
    $choix_secondaire = Read-Host "Quel est votre choix ?"

    switch ($choix_secondaire) {
        "1" {
            Log "Retour menu maintenance"
            Write-Host "Vous retournez au menu maintenance"
            Start-Sleep -Seconds 1
            return
        }
        "2" {
            Log "Retour au menu principal"
            Write-Host "Vous retournez au menu principal"
            Start-Sleep -Seconds 1
            exit 0
        }
        "q" {
            Log "Quitte le script"
            Write-Host "Vous quittez le script"
            Start-Sleep -Seconds 1
            exit 50
        }
        default {
            Write-Host "L'option choisie n'existe pas, veuillez recommencer"
            Start-Sleep -Seconds 1
            MenuSecondaire
        }
    }
}

# Menu Maintenance

while ($true) {
    Write-Host "=== Maintenance des machines ==="
    Write-Host "1 - Redemarrage de la machine"
    Write-Host "2 - Prise en main a distance"
    Write-Host "3 - Activation de pare feu"
    Write-Host "4 - Execution de script a distance"
    Write-Host "5 - Liste des utilisateurs locaux"
    Write-Host "r - revenir en arrière"
    $choix = Read-Host "Votre choix : "

    switch ($choix) {

        "1" {
            Log "Redémarrage_De_La_Machine"
            $redemarre = Read-Host "Voulez-vous vraiment faire un redémarrage de la machine ? (O/N) : "

            if ($redemarre -eq "O" -or $redemarre -eq "o") {
                Write-Host "Le pc redémarre..."
                Start-Sleep -Seconds 1
                Invoke-Command -ComputerName $IP_cible -Credential $credential -ScriptBlock {
                    Restart-Computer -Force
                }
            } else {
                Write-Host "Redémarrage annulé."
                MenuSecondaire
            }
        }

        "2" {
            Log "Prise_En_Main_A_Distance"

            # --- Saisie et validation de l'IP cible ---
            while ($true) {
                $IP_cible = Read-Host "Entrez l'adresse IP de la machine distante : "

                if ([string]::IsNullOrWhiteSpace($IP_cible)) {
                    Write-Host "Vous n'avez pas entré d'adresse IP, réessayez."
                    continue
                }

                if ($IP_cible -notmatch '^(\d{1,3}\.){3}\d{1,3}$') {
                    Write-Host "Format d'adresse IP invalide, réessayez."
                    continue
                }
                break
            }

            # --- Saisie du nom d'utilisateur distant ---
            while ($true) {
                $utilisateur_distant = Read-Host "Entrez le nom d'utilisateur distant : "

                if ([string]::IsNullOrWhiteSpace($utilisateur_distant)) {
                    Write-Host "Vous n'avez pas entré de nom d'utilisateur, recommencez."
                    continue
                }
                break
            }

            # --- Test de connectivité ---
            Write-Host "Test de connectivité vers $IP_cible..."

            if (-not (Test-Connection -ComputerName $IP_cible -Count 3 -Quiet)) {
                Write-Host "Erreur : la machine $IP_cible ne répond pas au ping."
                Write-Host "Vérifiez que la machine est allumée et accessible sur le réseau."
                MenuSecondaire
                return
            }

            Write-Host "Ping OK, tentative de connexion SSH..."

            # --- Connexion SSH ---
            Write-Host "Tentative de connexion SSH vers $utilisateur_distant@$IP_cible..."

            $testSSH = Test-NetConnection -ComputerName $IP_cible -Port 22
            if ($testSSH.TcpTestSucceeded) {
                Write-Host "Port SSH ouvert, connexion en cours..."
                ssh "$utilisateur_distant@$IP_cible"
                Write-Host "Vous êtes maintenant connecté à $IP_cible."
            } else {
                Write-Host "Connexion SSH impossible vers $IP_cible."
                Write-Host "Vérifiez les identifiants et que le service SSH est actif sur la machine distante."
            }
        }

        "3" {
            Log "Activation_Du_Pare_Feu"
            $reponse = Read-Host "Voulez-vous vraiment activer le pare-feu ? (O/N) "

            if ($reponse -eq "O" -or $reponse -eq "o") {
                Invoke-Command -ComputerName $IP_cible -Credential $credential -ScriptBlock {
                    Set-NetFirewallProfile -Profile Domain,Public,Private -Enabled True
                }

                $statut = Invoke-Command -ComputerName $IP_cible -Credential $credential -ScriptBlock {
                    (Get-NetFirewallProfile -Name Public).Enabled
                }

                if ($statut -eq $true) {
                    Write-Host "Vos pare-feux ont bien été activés."
                } else {
                    Write-Host "Activation du pare-feu impossible."
                }
            } else {
                Write-Host "Activation pare-feu annulée."
            }
           MenuSecondaire
        }

        "4" {
            Log "Execution_Script_A_Distance"

            $testSSH = Test-NetConnection -ComputerName $IP_cible -Port 22
            if ($testSSH.TcpTestSucceeded) {
                Write-Host "Connexion SSH établie."
            } else {
                Write-Host "Connexion SSH impossible."
                MenuSecondaire
                break
            }

            $script = Read-Host "Quel script souhaitez-vous lancer ? "

            if (Test-Path -Path $script) {
                $reponse = Read-Host "Le script existe, voulez-vous vraiment le lancer ? (O/N) "
                if ($reponse -eq "O" -or $reponse -eq "o") {
                    $session = New-PSSession -ComputerName $IP_cible -Credential $credential
                    Copy-Item -Path $script -Destination "C:\Windows\Temp\script_distant.ps1" -ToSession $session
                    Invoke-Command -Session $session -ScriptBlock {
                        powershell -ExecutionPolicy Bypass -File "C:\Windows\Temp\script_distant.ps1"
                    }
                    Remove-PSSession $session
                    Write-Host "Script exécuté avec succès."
                } else {
                    Write-Host "Retour au menu Maintenance."
                    MenuSecondairee
                }
            } else {
                Write-Host "Le script est introuvable."
                MenuSecondaire
            }
        }

        "5" {
            Log "Liste_Utilisateurs_Locaux"
            Write-Host "=== Utilisateurs locaux ($IP_cible - Windows) ==="
            Invoke-Command -ComputerName $IP_cible -Credential $credential -ScriptBlock {
                Get-LocalUser | Select-Object Name, Enabled, LastLogon
            }
            MenuSecondaire
        }

        "r" {
            Log "Retour arrière"
            Write-Host "Vous allez revenir au menu principal"
            Start-Sleep -Seconds 1
            exit 0
        }

        "q" {
            Log "EndScript"
            Write-Host "Vous quittez le script"
            Start-Sleep -Seconds 1
            exit 50
        }

        default {
            Write-Host "Choix invalide, réessayez."
        }
    }
}
