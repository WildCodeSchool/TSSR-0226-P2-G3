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
