#!/bin/bash

# Fonction pour formater et écrire les logs dans le fichier global
function log
{
    echo "[$(date '+%d-%m-%Y %H:%M:%S')] $1" >> "$log_file"
}

# Sous-menu pour gérer la navigation après chaque action
function secondary_menu
{
    echo "1 - Revenir au menu Utilisateurs"
    echo "2 - Revenir au menu principal"
    echo "q - Quitter le script"
    read -p "Quel est votre choix ? " choice_secondary

    case $choice_secondary in
    1)
        log "Retour menu utilisateurs"
        echo "Vous retournez au menu Utilisateurs"
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

log "Demande sur utilisateurs"

echo "Bienvenue dans la gestion des Utilisateurs"
sleep 3s
clear

# Boucle principale du menu
while true
do
    echo "Menu Utilisateurs"
    echo "Que souhaitez-vous faire sur le poste client ($ip_client) ?"
    echo "1 - Création de compte utilisateur local"
    echo "2 - Changement de mot de passe"
    echo "3 - Suppression de compte utilisateur local"
    echo "4 - Ajout à un groupe d'administration"
    echo "5 - Ajout à un groupe standard"
    echo "6 - Sortie d'un groupe"
    echo "7 - Revenir au menu principal"
    echo "q - Quitter le script"
    read -p "Quel est votre choix ? : " choice

    case $choice in

    1)
        # Création de compte
        log "Initiation création utilisateur client"
        read -p "Saisissez le nom du nouvel utilisateur : " target_username
        
        # Check si le compte existe déjà sur la machine distante pour éviter les erreurs
        user_exists=$(ssh $ssh_user@$ip_client "grep '^$target_username:' /etc/passwd")

        if [ -z "$user_exists" ]; then
            # L'option -m permet de forcer la création du repertoire /home/
            ssh $ssh_user@$ip_client "sudo useradd -m $target_username"
            echo "L'utilisateur $target_username a été créé avec succès."
            log "Succès création utilisateur $target_username"
        else
            echo "Erreur : L'utilisateur $target_username existe déjà."
            log "Erreur création utilisateur $target_username (existe déjà)"
        fi
        secondary_menu
        ;;

    2)
        # Modif du mot de passe
        log "Initiation changement de mot de passe client"
        read -p "Saisissez le nom de l'utilisateur : " target_username
        read -s -p "Saisissez le nouveau mot de passe : " new_password
        echo ""

        # On passe le mdp via chpasswd pour éviter l'invite interactive qui fait planter le script
        ssh $ssh_user@$ip_client "echo '$target_username:$new_password' | sudo chpasswd"

        if [ $? -eq 0 ]; then
            echo "Le mot de passe de $target_username a été mis à jour."
            log "Succès changement mdp $target_username"
        else
            echo "Erreur lors du changement de mot de passe."
            log "Erreur changement mdp $target_username"
        fi
        secondary_menu
        ;;

    3)
        # Suppression de compte
        log "Initiation suppression utilisateur client"
        read -p "Saisissez le nom de l'utilisateur à supprimer : " target_username
        read -p "Êtes-vous sûr de vouloir supprimer $target_username ? (o/n) : " confirm

        if [ "$confirm" = "o" ]; then
            # L'option -r supprime aussi le dossier personnel de l'utilisateur
            ssh $ssh_user@$ip_client "sudo userdel -r $target_username"
            echo "L'utilisateur $target_username a été supprimé."
            log "Succès suppression utilisateur $target_username"
        else
            echo "Action annulée."
            log "Annulation suppression utilisateur $target_username"
        fi
        secondary_menu
        ;;

    4)
        # Ajout au groupe admin
        log "Initiation ajout admin client"
        read -p "Quel utilisateur doit devenir administrateur ? : " target_username

        # Le groupe admin sous Ubuntu s'appelle sudo
        ssh $ssh_user@$ip_client "sudo usermod -aG sudo $target_username"
        echo "$target_username a été ajouté au groupe d'administration (sudo)."
        log "Succès ajout admin (sudo) pour $target_username"
        secondary_menu
        ;;

    5)
        # Ajout à un groupe basique
        log "Initiation ajout groupe client"
        read -p "Nom de l'utilisateur : " target_username
        read -p "Dans quel groupe souhaitez-vous l'ajouter ? : " target_group

        ssh $ssh_user@$ip_client "sudo usermod -aG $target_group $target_username"
        echo "$target_username a été ajouté au groupe $target_group."
        log "Succès ajout groupe $target_group pour $target_username"
        secondary_menu
        ;;

    6)
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

    7)
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