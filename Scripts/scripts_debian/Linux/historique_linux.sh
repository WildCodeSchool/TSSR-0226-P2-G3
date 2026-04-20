#!/bin/bash

function menu_secondaire
{
    echo "1 - Revenir au menu Historique"
    echo "r - Revenir au menu principal"
    echo "q - Quitter le script"
    read -p "Quel est votre choix ?" choix_secondaire

    case $choix_secondaire in

    1)
        log "Retour menu historique"
        echo "Vous retournez au menu connexion"
        sleep 1
        return
        ;;
    r)
        log "Retour au menu principal"
        echo "Vous retournez au menu principal"
        sleep 1
        exit 0
        ;;
    q)
        log "Quitte le script"
        echo "Vous quittez le script"
        sleep 1
        exit 50
        ;;
    *)
        echo "L'option choisi n'existe pas, veuillez recommencer"
        sleep 1
        menu_secondaire
        ;;
    esac
}

log "Demande sur Historique"

echo "Bienvenue dans le menu historique"
sleep 1
clear

# Menu Connexion

while true
do
    echo "Menu Historique"
    echo "Que souhaitez-vous connaitre ?"
    echo "1 - La date de dernière connexion d'un utilisateur"
    echo "2 - La date de dernière modification d'un mot de passe"
    echo "3 - La liste des sessions ouvertes par l'utilisateur"
    echo "r - Revenir au menu principal"
    echo "q - Quitter le script"
    read -p "Quel est votre choix ? :" choix

    case $choix in

# 

    1) 
        log "Demande dernière connexion"
        echo "Vous souhaitez connaitre la date de dernière connexion d'un utilisateur"
        read -p "De quel utilisateur ?" utilisateur_choisi
        log "Demande dernière connexion pour $utilisateur_choisi"
        date_derniere_connexion=$(ssh $ssh_client "last -F $utilisateur_choisi -n 1 | awk '{print \$4, \$5, \$6, \$8, \$7}'")
        echo "La date de la dernière connexion de l'utilisateur $utilisateur_choisi est $date_derniere_connexion"
        menu_secondaire
        ;;
# 
    2) 
        log "Demande dernière modification mot de passe"
        echo "Vous souhaitez connaitre la date de dernière modification de mot de passe d'un utilisateur"
        read -p "De quel utilisateur ?" utilisateur_choisi
        log "Demande date dernière modification de mot de passe pour $utilisateur_choisi"
        date_dernier_mdp=$(ssh $ssh_client "chage -l $utilisateur_choisi | head -1 | awk '{print \$9, \$8, \$10}' | tr -d ','")
        echo "La date de la dernière modification de l'utilisateur $utilisateur_choisi est $date_dernier_mdp"
        menu_secondaire
        ;;
        3) 
        log "Demande liste sessions"
        echo "Vous souhaitez connaitre la liste des sessions d'un utilisateur"
        read -p "De quel utilisateur ?" utilisateur_choisi
        log "Demande liste des sessions pour $utilisateur_choisi"
        liste_sessions=$(ssh $ssh_client "last $utilisateur_choisi | grep -E 'seat|pts' | grep -v "wtmp"")
        echo "La liste des sessions pour $utilisateur_choisi est (seat=local, pts=à distance)"
        echo "$liste_sessions"
        menu_secondaire
        ;;
    r)
        log "Retour arrière"
        echo "Vous allez revenir au menu principal"
        sleep 1
        exit 0
        ;;
    q)
        log "EndScript"
        echo "Vous quittez le script"
        sleep 1
        exit 50
        ;;
    *) 
        echo "L'option choisi n'existe pas veuillez recommencer"
        ;;
    esac
done
