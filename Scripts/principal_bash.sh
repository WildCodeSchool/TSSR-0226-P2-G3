#!/bin/bash

# Destination du fichier logs
export log_file=/var/log/log_evt.log

# Fonction de log d'utilisation du script
function log {
    echo "$(date '+%Y%m%d_%H%M%S')_${USER}_$1" >> "$log_file"
}
export -f log

# lanceur des scripts enfants avec exit 50 pour exit script total depuis script enfant
function lancement_enfant {
    bash "$1"
    if [[ $? == 50 ]]; then
        log "EndScript"
        exit 0
    fi
}

log "StartScript"

#initialisation de la connexion avec verification de la bonne machine
while true
do
    read -p "Quel est le nom de la machine cible ? :" ssh_client
    if ssh -q -o ConnectTimeout=5 $ssh_user@$ssh_client "exit" 2>/dev/null
    then
        break
    else
        echo "Impossible de joindre $ssh_client — vérifiez le nom ou l'IP"
    fi
done

export ssh_client

# SSH-Agent permettant la connexion sans interrogation du mot de passe
eval $(ssh-agent -s)
ssh-add ~/.ssh/id_ed25519

sleep 3
clear

# Verification du type d'OS Linux ou Windows pour executer les bons scripts enfants
os_type=$(ssh $ssh_client "uname")


while true
do
    echo "Bienvenue sur la gestion de $ssh_client"
    echo "Menu Principal"
    echo "Quel menu souhaitez-vous utiliser ?"
    echo "1 - Gestion des utilisateurs"
    echo "2 - Gestion des groupes"
    echo "3 - Gestion des repertoires"
    echo "4 - Maintenance machine"
    echo "5 - Gestion des connexions"
    echo "6 - Gestion des disques"
    echo "7 - Gestion du système"
    echo "8 - Historique Utilisateur"
    echo "9 - Recherche d'évènements dans les logs"
    echo "q - quitter le script"
    echo "Aide : Pour connaitre le détail des options il vous suffit de taper le numéro suivi d'un point d'interrogation, par exemple 1?"
    read -p "quel est votre choix ? :" choice

    case $choice in

    1)
        log "Start_Menu_Utilisateurs"
        if [[ $os_type == "Linux" ]]
        then
            lancement_enfant ./scripts_debian/Linux/utilisateurs_linux.sh
        else
            lancement_enfant ./scripts_debian/Windows/utilisateurs_windows.sh
        fi
        ;;
    1?)
        echo "Gestion des utilisateurs vous permet :"
        echo " - De créer un compte utilisateur local"
        echo " - De changer un mot de passe utilisateur"
        echo " - De supprimer un compte utilisateur local"
        read -p "Appuyez sur Entrée pour continuer..." _
        ;;
    2)
        log "Start_Menu_Groupes"
        if [[ $os_type == "Linux" ]]
        then
            lancement_enfant ./scripts_debian/Linux/groupes_linux.sh
        else
            lancement_enfant ./scripts_debian/Windows/groupes_windows.sh
        fi
        ;;
    2?)
        echo "Gestion des groupes vous permet :"
        echo " - D'ajouter un utilisateur à un groupe d'administration"
        echo " - D'ajouter un utilisateur à un groupe"
        echo " - De retirer un utilisateur d'un groupe"
        read -p "Appuyez sur Entrée pour continuer..." _
        ;;
    3)
        log "Start_Menu_Repertoires"
        if [[ $os_type == "Linux" ]]
        then
            lancement_enfant ./scripts_debian/Linux/repertoires_linux.sh
        else
            lancement_enfant ./scripts_debian/Windows/repertoires_windows.sh
        fi
        ;;
    3?)
        echo "Gestion des répertoires vous permet :"
        echo " - De créer un répertoire"
        echo " - De supprimer un répertoire"
        read -p "Appuyez sur Entrée pour continuer..." _
        ;;
    4)
        log "Start_Menu_Maintenance"
        if [[ $os_type == "Linux" ]]
        then
            lancement_enfant ./scripts_debian/Linux/maintenance_linux.sh
        else
            lancement_enfant ./scripts_debian/Windows/maintenance_windows.sh
        fi
        ;;
    4?)
        echo "Maintenance machine vous permet :"
        echo " - De prendre en main un client à distance (CLI)"
        echo " - D'activer le pare-feu"
        echo " - D'éxecuter des scripts sur la machine distante"
        echo " - De lister les utilisateurs locaux"
        read -p "Appuyez sur Entrée pour continuer..." _
        ;;
    5)
        log "Start_Menu_Connexions"
        if [[ $os_type == "Linux" ]]
        then
            lancement_enfant ./scripts_debian/Linux/connexions_linux.sh
        else
            lancement_enfant ./scripts_debian/Windows/connexions_windows.sh
        fi
        ;;
    5?)
        echo "Gestion des connexions vous permet :"
        echo " - De consulter les 5 dernières connexions"
        echo " - De consulter l'IP, le masque de sous-réseau et la passerelle du client"
        read -p "Appuyez sur Entrée pour continuer..." _
        ;;
    6)
        log "Start_Menu_Disques"
        if [[ $os_type == "Linux" ]]
        then
            lancement_enfant ./scripts_debian/Linux/disques_linux.sh
        else
            lancement_enfant ./scripts_debian/Windows/disques_windows.sh
        fi
        ;;
    6?)
        echo " Gestion des disques vous permet :"
        echo " - De consulter le nombre de disques"
        echo " - De connaitre le détail des partitions par disque"
        echo " - De connaitre la liste des lecteurs montés (disque, CD, etc...)"
        read -p "Appuyez sur Entrée pour continuer..." _
        ;;
    7)
        log "Start_Menu_Systeme"
        if [[ $os_type == "Linux" ]]
        then
            lancement_enfant ./scripts_debian/Linux/systeme_linux.sh
        else
            lancement_enfant ./scripts_debian/Windows/systeme_windows.sh
        fi
        ;;
    7?)
        echo " Gestion du système vous permet :"
        echo " - De consulter la version de l'OS"
        echo " - De connaitre les mises à jours critiques en attente"
        echo " - De connaitre la marque et le modèle du client"
        echo " - Sur client Windows : De vérifier si l'UAC est activé"
        read -p "Appuyez sur Entrée pour continuer..." _
        ;;
    8)
        log "Start_Menu_Historique"
        if [[ $os_type == "Linux" ]]
        then
            lancement_enfant ./scripts_debian/Linux/historique_linux.sh
        else
            lancement_enfant ./scripts_debian/Windows/historique_windows.sh
        fi
        ;;
    8?)
        echo "L'historique utilisateur vous permet :"
        echo " - De consulter la dernière connexion d'un utilisateur"
        echo " - De consulter la dernière modification du mot de passe"
        echo " - De consulter la liste des sessions ouvertes par un utilisateur"
        read -p "Appuyez sur Entrée pour continuer..." _
        ;;
    9)
        log "Start_Menu_Recherche_logs"
        lancement_enfant ./scripts_debian/logs_recherches.sh
        ;;
    9?)
        echo "La recherche d'évènement dans les logs peut se faire :"
        echo " - Par utilisateur"
        echo " - par machine"
        read -p "Appuyez sur Entrée pour continuer..." _
        ;;
    q)
        log "EndScript"
        echo "Vous quittez le script"
        sleep 3
        exit 0
        ;;
    *) 
        echo "L'option choisi n'existe pas veuillez recommencer"
        ;;
    esac
done
