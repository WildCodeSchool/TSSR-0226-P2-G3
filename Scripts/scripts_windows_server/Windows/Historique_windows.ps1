$LOG_FILE     = "C:\Windows\System32\LogFiles\log_evt.log"  # Emplacement du fichier log
$CURRENT_USER = $env:USERNAME                                # Utilisateur qui lance le script

# ==============================================================================
# JOURNALISATION
# ==============================================================================

# Ecrit une ligne dans le fichier log
# Format : yyyymmdd_hhmmss_Utilisateur_Evenement
function Write-Log {
    param($Event)
    $line = "$(Get-Date -Format 'yyyyMMdd')_$(Get-Date -Format 'HHmmss')_${CURRENT_USER}_${Event}"
    Add-Content -Path $LOG_FILE -Value $line -Encoding UTF8
}

# Lance au demarrage : cree le fichier log si besoin + ecrit StartScript
function Init-Log {
    if (-not (Test-Path $LOG_FILE)) {
        New-Item -ItemType File -Path $LOG_FILE -Force | Out-Null
    }
    Write-Log "StartScript"
}

# Lance a la fermeture : ecrit EndScript + quitte proprement
function End-Log {
    Write-Log "EndScript"
    Write-Host "Au revoir $CURRENT_USER !"
    exit 0
}

# ==============================================================================
# AFFICHAGE
# ==============================================================================

# Affiche un en-tete propre sur chaque menu
function Display-Header {
    param($Title)
    Clear-Host
    Write-Host "============================================================"
    Write-Host "   ADMINISTRATION CENTRALISEE - SRVWIN01"
    Write-Host "   Utilisateur : $CURRENT_USER"
    Write-Host "   Date/Heure  : $(Get-Date -Format 'dd/MM/yyyy HH:mm:ss')"
    Write-Host "------------------------------------------------------------"
    Write-Host "   $Title"
    Write-Host "============================================================"
    Write-Host ""
}

# Attend que l'utilisateur appuie sur Entree avant de revenir au menu
function Pause-Retour {
    Write-Host ""
    Read-Host "   Appuyez sur [Entree] pour revenir au menu"
}

# ==============================================================================
# RECHERCHE DANS LES LOGS
# ==============================================================================

function Menu-RechercheLogs {
    do {
        Display-Header "RECHERCHE DANS LES LOGS"
        Write-Host "   1) Rechercher par UTILISATEUR"
        Write-Host "   2) Rechercher par ORDINATEUR"
        Write-Host "   3) Voir les 20 dernieres lignes"
        Write-Host "   0) Retour"
        Write-Host ""
        $choix = Read-Host "   Votre choix"
        Write-Log "RechercheLogs_Choix_$choix"

        switch ($choix) {

            "1" {
                # Recherche par utilisateur = filtre sur la 3eme colonne du log
                $user = Read-Host "   Nom utilisateur"
                Write-Log "Recherche_Utilisateur_$user"
                Write-Host ""
                $results = Get-Content $LOG_FILE | Where-Object {
                    ($_ -split "_", 4)[2] -eq $user
                }
                if ($results) { $results | ForEach-Object { Write-Host "   $_" } }
                else { Write-Host "   Aucun resultat pour '$user'." }
                Pause-Retour
            }

            "2" {
                # Recherche par ordinateur = filtre dans le champ evenement
                $pc = Read-Host "   Nom ordinateur"
                Write-Log "Recherche_Ordinateur_$pc"
                Write-Host ""
                $results = Get-Content $LOG_FILE | Where-Object { $_ -match $pc }
                if ($results) { $results | ForEach-Object { Write-Host "   $_" } }
                else { Write-Host "   Aucun resultat pour '$pc'." }
                Pause-Retour
            }

            "3" {
                # Affiche les 20 dernieres lignes du log
                Write-Log "Recherche_Tail20"
                Write-Host ""
                Get-Content $LOG_FILE -Tail 20 | ForEach-Object { Write-Host "   $_" }
                Pause-Retour
            }

            "0" {
                # Retour au menu precedent
                Write-Log "Retour_DepuisRechercheLogs"
            }

            default {
                # Choix invalide - on reboucle automatiquement
                Write-Host "   Choix invalide."
                Start-Sleep 1
            }
        }

    } while ($choix -ne "0")
}

# ==============================================================================
# MENU INFOS SCRIPT
# ==============================================================================

function Menu-InfosScript {
    do {
        Display-Header "INFORMATIONS SUR LE SCRIPT"
        Write-Host "   1) Recherche dans les logs"
        Write-Host "   2) Chemin du fichier log"
        Write-Host "   3) Taille du fichier log"
        Write-Host "   0) Retour"
        Write-Host ""
        $choix = Read-Host "   Votre choix"
        Write-Log "InfosScript_Choix_$choix"

        switch ($choix) {

            "1" {
                # Ouvre le sous-menu de recherche
                Menu-RechercheLogs
            }

            "2" {
                # Affiche le chemin du fichier log
                Write-Log "InfosScript_Chemin"
                Write-Host ""
                Write-Host "   Fichier log : $LOG_FILE"
                Pause-Retour
            }

            "3" {
                # Affiche le nombre de lignes et la taille du fichier log
                Write-Log "InfosScript_Taille"
                Write-Host ""
                $lignes = (Get-Content $LOG_FILE).Count
                $taille = [math]::Round((Get-Item $LOG_FILE).Length / 1KB, 2)
                Write-Host "   Lignes : $lignes"
                Write-Host "   Taille : $taille Ko"
                Pause-Retour
            }

            "0" {
                # Retour au menu principal
                Write-Log "Retour_MenuPrincipal"
            }

            default {
                Write-Host "   Choix invalide."
                Start-Sleep 1
            }
        }

    } while ($choix -ne "0")
}

# ==============================================================================
# MENU PRINCIPAL
# ==============================================================================

function Menu-Principal {
    do {
        Display-Header "MENU PRINCIPAL"
        Write-Host "   1) Gestion des Utilisateurs"
        Write-Host "   2) Gestion des Postes Clients"
        Write-Host "   3) Informations sur les Postes Clients"
        Write-Host "   4) Informations sur le Script / Logs"
        Write-Host "   0) Quitter"
        Write-Host ""
        $choix = Read-Host "   Votre choix"
        Write-Log "MenuPrincipal_Choix_$choix"

        switch ($choix) {
            "1" { Menu-Utilisateurs }   # Partie collegue
            "2" { Menu-PostesClients }  # Partie collegue
            "3" { Menu-InfosClients }   # Partie collegue
            "4" { Menu-InfosScript }    # MA PARTIE
            "0" {
                # Demande confirmation avant de quitter
                $confirm = Read-Host "   Quitter ? (o/n)"
                if ($confirm -match "^[oO]$") { End-Log }
                else { $choix = "" }  # Annule le quitter, on reboucle
            }
            default {
                Write-Host "   Choix invalide."
                Start-Sleep 1
            }
        }

    } while ($choix -ne "0")
}

# ==============================================================================
# LANCEMENT
# ==============================================================================

Init-Log        # Cree le log + ecrit StartScript
Menu-Principal  # Lance le menu