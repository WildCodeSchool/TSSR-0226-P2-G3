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

log "Demande sur groupes (Windows)"

echo "Bienvenue dans la gestion des Groupes (Cible : Windows 11)"
sleep 1
clear

# Boucle principale du menu
while true
do
    echo "Menu Groupes Windows"
    echo "Que souhaitez-vous faire sur le poste client ($ssh_client) ?"
    echo "1 - Ajout à un groupe d'administration"
    echo "2 - Ajout à un groupe standard"
    echo "3 - Sortie d'un groupe"
    echo "4 - Revenir au menu principal"
    echo "q - Quitter le script"
    read -p "Quel est votre choix ? : " choix

    case $choix in

    1)
        log "Initiation ajout admin client Windows"
        read -p "Quel utilisateur doit devenir administrateur ? : " cible_username

        # Sous Windows en français, le groupe s'appelle Administrateurs
        ssh $ssh_client "powershell.exe -Command \"Add-LocalGroupMember -Group 'Administrateurs' -Member '$cible_username'\""
        
        if [ $? -eq 0 ]; then
            echo "$cible_username a été ajouté au groupe d'administration."
            log "Succès ajout admin pour $cible_username"
        else
            echo "Erreur lors de l'ajout au groupe d'administration."
            log "Erreur ajout admin pour $cible_username"
        fi
        menu_secondaire
        ;;

    2)
        log "Initiation ajout groupe client Windows"
        read -p "Nom de l'utilisateur : " cible_username
        read -p "Dans quel groupe souhaitez-vous l'ajouter ? : " cible_groupe

        ssh $ssh_client "powershell.exe -Command \"Add-LocalGroupMember -Group '$cible_groupe' -Member '$cible_username'\""
        
        if [ $? -eq 0 ]; then
            echo "$cible_username a été ajouté au groupe $cible_groupe."
            log "Succès ajout groupe $cible_groupe pour $cible_username"
        else
            echo "Erreur lors de l'ajout au groupe $cible_groupe."
            log "Erreur ajout groupe $cible_groupe pour $cible_username"
        fi
        menu_secondaire
        ;;

    3)
        log "Initiation sortie groupe client Windows"
        read -p "Nom de l'utilisateur : " cible_username
        read -p "De quel groupe souhaitez-vous le retirer ? : " cible_groupe

        ssh $ssh_client "powershell.exe -Command \"Remove-LocalGroupMember -Group '$cible_groupe' -Member '$cible_username'\""
        
        if [ $? -eq 0 ]; then
            echo "$cible_username a été retiré du groupe $cible_groupe."
            log "Succès sortie groupe $cible_groupe pour $cible_username"
        else
            echo "Erreur lors de la sortie du groupe $cible_groupe."
            log "Erreur sortie groupe $cible_groupe pour $cible_username"
        fi
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
