Prise_En_Main_A_Distance() {
    log "Accès menu Prise de main à distance"

    # --- Saisie et validation de l'IP cible ---
    while true; do
        read -p "Entrez l'adresse IP de la machine distante : " IP_cible

        if [ -z "$IP_cible" ]; then
            echo "Vous n'avez pas entré d'adresse IP, réessayez."
            continue
        fi

        if [[ ! "$IP_cible" =~ ^([0-9]{1,3}\.){3}[0-9]{1,3}$ ]]; then
            echo "Format d'adresse IP invalide, réessayez."
            continue
        fi

        break
    done

    # --- Saisie du nom d'utilisateur distant ---
    while true; do
        read -p "Entrez le nom d'utilisateur distant : " USER_DISTANT

        if [ -z "$USER_DISTANT" ]; then
            echo "Vous n'avez pas entré de nom d'utilisateur, recommencez."
            continue
        fi

        break
    done

    # --- Test de connectivité avant SSH ---
    echo "Test de connectivité vers $IP_cible..."

    if ! ping -c 3 -W 2 "$IP_cible" &>/dev/null; then
        echo "Erreur : la machine $IP_cible ne répond pas au ping."
        echo "Vérifiez que la machine est allumée et accessible sur le réseau."
        Menu_Operateur_Maintenance
        return
    fi

    echo "Ping OK, tentative de connexion SSH..."

    # --- #connexion_ssh ---
    echo "Tentative de connexion SSH vers $USER_DISTANT@$IP_cible..."

    if ssh "$USER_DISTANT@$IP_cible"; then
        echo "Vous êtes maintenant connecté à $IP_cible."
    else
        echo "Connexion SSH impossible vers $IP_cible."
        echo "Vérifiez les identifiants et que le service SSH est actif sur la machine distante."
    fi
}
