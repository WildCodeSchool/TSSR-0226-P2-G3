#!/bin/bash

log_file=/var/log/log_evt.log

function menu_secondaire
{
    echo "1 - Revenir au menu Recherche Logs"
    echo "2 - Revenir au menu principal"
    echo "q - Quitter le script"
    read -p "Quel est votre choix ?" choix_secondaire

    case $choix_secondaire in

    1)
        log "Retour menu historique"
        echo "Vous retournez au menu connexion"
        sleep 1
        return
        ;;
    2)
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

log "Menu Recherche Logs"

echo "Bienvenue dans le menu Recherche Logs"
sleep 1
clear

# Menu Connexion

while true
do
    echo "Menu Recherches Logs"
    echo "Que souhaitez-vous faire ?"
    echo "1 - Rechercher des évènements dans les logs par utilisateur"
    echo "2 - Rechercher des évènements dans les logs par ordinateur"
    echo "3 - Revenir au menu principal"
    echo "q - Quitter le script"
    read -p "Quel est votre choix ? :" choix

    case $choix in

# 

    1)
        read -p "Utilisateur cible : " cible_utilisateur
        historique_cible=$(grep "_${cible_utilisateur}_" "$log_file")
        if [[ -z "$historique_cible" ]]
        then
            echo "Aucun résultat trouvé pour $cible_utilisateur"
        else
            echo "$historique_cible"
        fi
        log "Recherche logs pour $cible_utilisateur"
        menu_secondaire
        ;;
    2)
        read -p "Machine cible : " machine
        historique_machine=$(grep "_${machine}-" "$log_file")
        if [[ -z "$historique_machine" ]]
        then
            echo "Aucun résultat trouvé pour $machine"
        else
            echo "$historique_machine"
        fi
        log "Recherche logs pour $machine"
        menu_secondaire
        ;;
    3) 
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
