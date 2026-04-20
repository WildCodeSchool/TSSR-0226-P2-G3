#!/bin/bash

# Sous-menu pour gérer la navigation après chaque action
function menu_secondaire
{
    echo "1 - Revenir au menu Groupes"
    echo "2 - Revenir au menu principal"
    echo "q - Quitter le script"
    read -p "Quel est votre choix ? " choix_secondaire

    case $choix_secondaire in
    1)
        log "Retour menu groupes"
        echo "Vous retournez au menu Groupes"
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
        echo "L'option choisie n'existe pas, veuillez recommencer"
        sleep 1
        menu_secondaire
        ;;
    esac
}

log "Demande sur groupes"

echo "Bienvenue dans la gestion des Groupes"
sleep 1
clear

# Boucle principale du menu
while true
do
    echo "Menu Groupes"
    echo "Que souhaitez-vous faire sur le poste client ($ip_client) ?"
    echo "1 - Ajout à un groupe d'administration"
    echo "2 - Ajout à un groupe standard"
    echo "3 - Sortie d'un groupe"
    echo "4 - Revenir au menu principal"
    echo "q - Quitter le script"
    read -p "Quel est votre choix ? : " choix

    case $choix in

    1)
        # Ajout au groupe admin
        log "Initiation ajout admin client"
        read -p "Quel utilisateur doit devenir administrateur ? : " cible_username

        ssh $ssh_client "usermod -aG sudo $cible_username"
        echo "$cible_username a été ajouté au groupe d'administration."
        log "Succès ajout admin pour $cible_username"
        menu_secondaire
        ;;

    2)
        # Ajout à un groupe basique
        log "Initiation ajout groupe client"
        read -p "Nom de l'utilisateur : " cible_username
        read -p "Dans quel groupe souhaitez-vous l'ajouter ? : " cible_groupe

        ssh $ssh_client "usermod -aG $cible_groupe $cible_username"
        echo "$cible_username a été ajouté au groupe $cible_groupe."
        log "Succès ajout groupe $cible_groupe pour $cible_username"
        menu_secondaire
        ;;

    3)
        # Retrait d'un groupe
        log "Initiation sortie groupe client"
        read -p "Nom de l'utilisateur : " cible_username
        read -p "De quel groupe souhaitez-vous le retirer ? : " cible_groupe

        # Utilisation de gpasswd -d plus simple que usermod pour cette action
        ssh $ssh_client "gpasswd -d $cible_username $cible_groupe"
        echo "$cible_username a été retiré du groupe $cible_groupe."
        log "Succès sortie groupe $cible_groupe pour $cible_username"
        menu_secondaire
        ;;

    4)
        log "Retour au menu principal"
        echo "Vous revenez au menu principal"
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
        echo "L'option choisie n'existe pas, veuillez recommencer"
        sleep 1
        ;;
    esac
done
