#!/bin/bash

# Sous-menu pour gérer la navigation après chaque action
function menu_secondaire 
{
    echo "1 - Revenir au menu Utilisateurs"
    echo "2 - Revenir au menu principal"
    echo "q - Quitter le script"
    read -p "Quel est votre choix ? " choix_secondaire

    case $choix_secondaire in
    1)
        log "Retour menu utilisateurs"
        echo "Vous retournez au menu Utilisateurs"
        sleep 3
        return
        ;;
    2)
        log "Retour au menu principal"
        echo "Vous retournez au menu principal"
        sleep 3
        exit 0
        ;;
    q)
        log "Quitte le script"
        echo "Vous quittez le script"
        sleep 3
        exit 50
        ;;
    *)
        echo "L'option choisie n'existe pas, veuillez recommencer"
        sleep 3
        menu_secondaire
        ;;
    esac
}

log "Demande sur utilisateurs (Windows)"

echo "Bienvenue dans la gestion des Utilisateurs (Cible : Windows 11)"
sleep 3
clear

# Boucle principale du menu
while true
do
    echo "Menu Utilisateurs Windows"
    echo "Que souhaitez-vous faire sur le poste client ($ip_client) ?"
    echo "1 - Création de compte utilisateur local"
    echo "2 - Changement de mot de passe"
    echo "3 - Suppression de compte utilisateur local"
    echo "4 - Revenir au menu principal"
    echo "q - Quitter le script"
    read -p "Quel est votre choix ? : " choix

    case $choix in
    1)
        log "Initialisation création utilisateur client Windows"
        read -p "Saisissez le nom du nouvel utilisateur : " cible_username
        read -s -p "Saisissez son mot de passe initial : " nouveau_password
        echo ""
        
        # Check si le compte existe déjà (SilentlyContinue masque l'erreur rouge de PowerShell si non trouvé)
        utilisateur_exist=$(ssh $ssh_user@$ip_client "powershell.exe -Command \"Get-LocalUser -Name '$cible_username' -ErrorAction SilentlyContinue\"")

        if [ -z "$utilisateur_exist" ]; then
            # Windows exige un mot de passe converti en SecureString
            ssh $ssh_user@$ip_client "powershell.exe -Command \"\$sec_pwd = ConvertTo-SecureString '$nouveau_password' -AsPlainText -Force; New-LocalUser -Name '$cible_username' -Password \$sec_pwd\""
            
            if [ $? -eq 0 ]; then
                echo "L'utilisateur $cible_username a été créé avec succès."
                log "Succès création utilisateur $cible_username"
            else
                echo "Erreur lors de la création de l'utilisateur."
                log "Erreur création utilisateur $cible_username"
            fi
        else
            echo "Erreur : L'utilisateur $cible_username existe déjà."
            log "Erreur création utilisateur $cible_username (existe déjà)"
        fi
        menu_secondaire
        ;;

    2)
        log "Initialisation changement de mot de passe client Windows"
        read -p "Saisissez le nom de l'utilisateur : " cible_username
        read -s -p "Saisissez le nouveau mot de passe : " nouveau_password
        echo ""

        # Modif du mot de passe via Set-LocalUser
        ssh $ssh_user@$ip_client "powershell.exe -Command \"\$sec_pwd = ConvertTo-SecureString '$nouveau_password' -AsPlainText -Force; Set-LocalUser -Name '$cible_username' -Password \$sec_pwd\""

        if [ $? -eq 0 ]; then
            echo "Le mot de passe de $cible_username a été mis à jour."
            log "Succès changement mdp $cible_username"
        else
            echo "Erreur lors du changement de mot de passe."
            log "Erreur changement mdp $cible_username"
        fi
        menu_secondaire
        ;;

    3)
        log "Initiation suppression utilisateur client Windows"
        read -p "Saisissez le nom de l'utilisateur à supprimer : " cible_username
        read -p "Êtes-vous sûr de vouloir supprimer $cible_username ? (o/n) : " confirm

        if [ "$confirm" = "o" ]; 
        then
            # Suppression via Remove-LocalUser
            ssh $ssh_user@$ip_client "powershell.exe -Command \"Remove-LocalUser -Name '$cible_username'\""
            
            if [ $? -eq 0 ]; then
                echo "L'utilisateur $cible_username a été supprimé."
                log "Succès suppression utilisateur $cible_username"
            else
                echo "Erreur lors de la suppression."
                log "Erreur suppression utilisateur $cible_username"
            fi
        else
            echo "Action annulée."
            log "Annulation suppression utilisateur $cible_username"
        fi
        menu_secondaire
        ;;

    4)
        log "Retour au menu principal"
        echo "Vous revenez au menu principal"
        sleep 3
        exit 0
        ;;

    q)
        log "Quitte le script"
        echo "Vous quittez le script"
        sleep 3
        exit 50
        ;;

    *)
        echo "L'option choisie n'existe pas, veuillez recommencer"
        sleep 3
        ;;
    esac
done