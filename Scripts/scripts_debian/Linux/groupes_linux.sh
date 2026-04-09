#!/bin/bash

# Sous-menu pour gérer la navigation après chaque action
function secondary_menu
{
    echo "1 - Revenir au menu Groupes"
    echo "2 - Revenir au menu principal"
    echo "q - Quitter le script"
    read -p "Quel est votre choix ? " choice_secondary

    case $choice_secondary in
    1)
        log "Retour menu groupes"
        echo "Vous retournez au menu Groupes"
        sleep 3s
        return
        ;;
    2)
        log "Retour au menu principal"
        echo "Vous retournez au menu principal"
        sleep 3s
        exit 0
        ;;
    q)
        log "Quitte le script"
        echo "Vous quittez le script"
        sleep 3s
        exit 50
        ;;
    *)
        echo "L'option choisie n'existe pas, veuillez recommencer"
        sleep 3s
        secondary_menu
        ;;
    esac
}

log "Demande sur groupes"

echo "Bienvenue dans la gestion des Groupes"
sleep 3s
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
    read -p "Quel est votre choix ? : " choice

    case $choice in

    1)
        # Ajout au groupe admin
        log "Initiation ajout admin client"
        read -p "Quel utilisateur doit devenir administrateur ? : " target_username

        # Le groupe admin sous Ubuntu s'appelle sudo
        ssh $ssh_user@$ip_client "sudo usermod -aG sudo $target_username"
        echo "$target_username a été ajouté au groupe d'administration (sudo)."
        log "Succès ajout admin (sudo) pour $target_username"
        secondary_menu
        ;;

    2)
        # Ajout à un groupe basique
        log "Initiation ajout groupe client"
        read -p "Nom de l'utilisateur : " target_username
        read -p "Dans quel groupe souhaitez-vous l'ajouter ? : " target_group

        ssh $ssh_user@$ip_client "sudo usermod -aG $target_group $target_username"
        echo "$target_username a été ajouté au groupe $target_group."
        log "Succès ajout groupe $target_group pour $target_username"
        secondary_menu
        ;;

    3)
        # Retrait d'un groupe
        log "Initiation sortie groupe client"
        read -p "Nom de l'utilisateur : " target_username
        read -p "De quel groupe souhaitez-vous le retirer ? : " target_group

        # Utilisation de gpasswd -d plus simple que usermod pour cette action
        ssh $ssh_user@$ip_client "sudo gpasswd -d $target_username $target_group"
        echo "$target_username a été retiré du groupe $target_group."
        log "Succès sortie groupe $target_group pour $target_username"
        secondary_menu
        ;;

    4)
        log "Retour au menu principal"
        echo "Vous revenez au menu principal"
        sleep 3s
        exit 0
        ;;

    q)
        log "Quitte le script"
        echo "Vous quittez le script"
        sleep 3s
        exit 50
        ;;

    *)
        echo "L'option choisie n'existe pas, veuillez recommencer"
        sleep 3s
        ;;
    esac
done