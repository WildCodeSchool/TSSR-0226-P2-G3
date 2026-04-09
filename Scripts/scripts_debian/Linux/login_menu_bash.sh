#!/bin/bash

# ==========================================================
# CONFIGURATION & VARIABLES
# ==========================================================
IP_WIN="172.16.30.20"
USER_WIN="Wilder"
CLE_PRIVEE="/root/.ssh/id_rsa_win"
LOG_FILE="log_evt.log"

# Commande SSH pré-configurée pour Windows
SSH_WIN="ssh -q -i $CLE_PRIVEE $USER_WIN@$IP_WIN"

# ==========================================================
# FONCTIONS TECHNIQUES
# ==========================================================

# Fonction de Journalisation (Tâche Write-Log)
write_log() {
    local action=$1
    echo "$(date '+%Y-%m-%d %H:%M:%S') - Action: $action" >> "$LOG_FILE"
}

# Fonction d'exportation (Camille - Tâche 26)
afficher_resultat() {
    local donnees="$1"
    echo -e "\n--- CHOIX DE SORTIE ---"
    echo "1. Affichage rapide à l'écran"
    echo "2. Exportation dans un fichier (.txt)"
    read -p "Choix : " choix_sortie

    if [ "$choix_sortie" == "1" ]; then
        echo -e "\n$donnees"
    else
        local nom_fichier="export_$(date +%Y%m%d_%H%M%S).txt"
        echo "$donnees" > "$nom_fichier"
        echo "✅ Succès : Sauvegardé dans $nom_fichier"
    fi
}

# Fonction de Recherche (Anass - Tâches 24 & 25)
rechercher_dans_logs() {
    echo -e "\n--- MOTEUR DE RECHERCHE ---"
    echo "1. Rechercher par UTILISATEUR"
    echo "2. Rechercher par MACHINE"
    echo "3. Rechercher par ACTION"
    read -p "Choix : " type_rech
    
    read -p "Entrez votre mot-clé : " mot_cle
    
    # Filtrage avec grep
    local resultats=$(grep -i "$mot_cle" "$LOG_FILE")
    
    if [ -z "$resultats" ]; then
        echo "❌ Aucune trace trouvée pour : $mot_cle"
    else
        afficher_resultat "$resultats"
    fi
}

# ==========================================================
# MENU PRINCIPAL
# ==========================================================
write_log "StartScript"

while true; do
    echo -e "\n=============================================="
    echo "      --- MENU ADMINISTRATION CENTRALISÉE ---"
    echo "=============================================="
    echo "1. Gérer le parc LINUX (SRV Debian / CLI Ubuntu)"
    echo "2. Gérer le parc WINDOWS (SRV Win / CLI Win)"
    echo "3. Consulter les LOGS (Recherche Anass)"
    echo "4. Quitter"
    echo "=============================================="
    read -p "Votre choix : " choix_parc

    case $choix_parc in
        1) # Parc Linux
            echo "Action sur SRVLX01 (Local) :"
            res=$(last -n 5) # Exemple : 5 dernières connexions
            afficher_resultat "$res"
            write_log "Consultation-Linux"
            ;;

        2) # Parc Windows (Utilise ta clé !)
            echo "Cible : [A] SRVWIN01 (Distant)"
            read -p "Cible : " cible
            echo "Récupération des sessions ouvertes sur Windows..."
            # On utilise ta variable SSH_WIN !
            res=$($SSH_WIN "powershell quser")
            afficher_resultat "$res"
            write_log "Consultation-Windows-Remote"
            ;;

        3) # Recherche Anass
            rechercher_dans_logs
            ;;

        4)
            write_log "EndScript"
            echo "Fermeture..."
            exit 0
            ;;
        *)
            echo "Choix invalide."
            ;;
    esac
    
    echo -e "\nAppuyez sur Entrée pour continuer..."
    read
done