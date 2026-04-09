Execution_Script_A_Distance() {
log "Execution_Script_A_Distance"
    if ssh -q -o BatchMode=yes -o ConnectTimeout=5 "$USER_DISTANT@$IP_cible" exit; then
        echo "Connexion SSH établie"
    else
        echo "Connexion SSH impossible"
        Menu_Operateur_Maintenance
    fi

read -p "Quel script souhaitez vous lancer ? " script

if [ -f "$script" ] && [ -x "$script" ]; then
    read -p "Le script existe et est exécutable voulez vous vraiment lancer ce script (O/N)" reponse
    if [ "$reponse" = "O" ] || [ "$reponse" = "o" ]; then
    bash "$script"
        if [ $? -eq 0 ]; then
            echo "Script exécuté avec succès"
        else
            echo "Erreur lors de l'exécution du script"
        fi
    else
        echo "Retour au menu Operateur De Maintenance"
        Menu_Operateur_Maintenance
    fi
else
    echo "Le script est introuvable ou non exécutable"
    Menu_Operateur_Maintenance
fi
}
