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
