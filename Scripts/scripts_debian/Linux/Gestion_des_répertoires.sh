Gestion_Des_Répertoires() {
    log "Accès menu Gestion De Répertoire"

    echo "=== Gestion De Répertoire ==="
    echo "1 - Créer Un Répertoire"
    echo "2 - Supprimer Un Répertoire"
    echo "3 - Retour au menu Opérateur de Maintenance"
    read -p "Votre choix : " CHOICE_rep

    case "$CHOICE_rep" in
        1)
            Créer_Un_Répertoire
            ;;
        2)
            Supprimer_Un_Répertoire
            ;;
        3)
            Menu_Operateur_Maintenance
            ;;
        *)
            echo "Choix invalide, réessayez."
            Gestion_Répertoire
            ;;
    esac
}


Créer_Un_Répertoire() {

log "Accès création de répertoire"
echo -e "Exemple: /tmp/monrepertoire ou /home/user/repertoire"
read -p "Entrez le chemin du répertoire à créer : " repo
    # Vérification que l'argument soit présent
    if [ -z "$repo" ]; then
        echo -e "Erreur : saisie vide, veuillez recommencer."
        return
    fi

    if [ -d "$repo" ]; then
        echo "Ce répertoire existe déjà, création refusée."
        return
    fi

    read -p "Voulez-vous vraiment créer ce répertoire ? (O/N) : " reponse
    if [ "$reponse" = "o" ] || [ "$reponse" = "O" ]; then
        mkdir -p "$repo"
        echo "Le répertoire '$repo' a été créé avec succès."
    else
        echo "Création annulée."
    fi
}


Supprimer_Un_Répertoire() {
    log "Accès suppression de répertoire"
echo -e "Exemple: /tmp/monrepertoire ou /home/user/repertoire"
read -p "Entrez le chemin du répertoire à supprimer : " Reponse

    if [ ! -d "$Reponse" ]; then
        echo "Le répertoire '$Reponse' n'existe pas."
        return
    fi

read -p "Voulez-vous vraiment supprimer ce répertoire ? (O/N) : " rep
    if [ "$rep" = "o" ] || [ "$rep" = "O" ]; then
        rm -rf "$Reponse"
        echo "Le répertoire '$rep' a été supprimé avec succès."
    else
        echo "Suppression annulée."
    fi
}
