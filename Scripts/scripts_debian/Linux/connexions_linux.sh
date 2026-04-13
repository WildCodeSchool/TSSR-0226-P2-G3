#!/bin/bash

# Il est nécessaire d'installer ipcalc sur le client linux (A noter dans install ou readme)

#initialisation des variables principales

derniers_logins=$(ssh $ssh_user@$ip_client "last -n 5 | grep 'pts'")
ipcon_client=$(ssh $ssh_user@$ip_client "ip route get 1 | awk '{print $7; exit}'")
masque_client=$(ssh $ssh_user@$ip_client "ipcalc $ipcon_client | grep 'Netmask' | awk '{print $2}'")
passerelle_client=$(ssh $ssh_user@$ip_client "ip route | grep 'default' | awk '{print $3}'")



function menu_secondaire
{
    echo "1 - Revenir au menu Disques"
    echo "2 - Revenir au menu principal"
    echo "q - Quitter le script"
    read -p "Quel est votre choix ?" choix_secondaire

    case $choix_secondaire in

    1)
        log "Retour menu connexion"
        echo "Vous retournez au menu connexion"
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
        echo "L'option choisi n'existe pas, veuillez recommencer"
        sleep 3
        menu_secondaire
        ;;
    esac
}

log "Demande sur connexion"

echo "Bienvenue dans le menu connexion"
sleep 3
clear

# Menu Connexion

while true
do
    echo "Menu Disques"
    echo "Que souhaitez-vous connaitre ?"
    echo "1 - Les 5 dernières connexions à distance"
    echo "2 - Adresse IP, masque IP et passerelle du Client"
    echo "3 - Revenir au menu principal"
    echo "q - quitter le script"
    read -p "Quel est votre choix ? :" choix

    case $choix in

    # Affichage des 5 dcerniers logins

    1) 
        log "cinq derniers login"
        echo "Voici les 5 derniers loggings :"
        echo "$derniers_logins"
        menu_secondaire
        ;;
# Adresse IP, Masque, Passerelle client
    2) 
        log "Affichage IP, Masque, Passerelle "
        echo "L'adresse IP du client est $ipcon_client"
        echo "Le masque de sous-réseau du client est $masque_client"
        echo "La passerelle du client est $passerelle_client"
        menu_secondaire
        ;;
    3)
        log "Retour arrière"
        echo "Vous allez revenir au menu principal"
        sleep 3
        exit 0
        ;;

    q)
        log "EndScript"
        echo "Vous quittez le script"
        sleep 3
        exit 50
        ;;
    *) 
        echo "L'option choisi n'existe pas veuillez recommencer"
        ;;
    esac
done