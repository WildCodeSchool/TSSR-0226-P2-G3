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
