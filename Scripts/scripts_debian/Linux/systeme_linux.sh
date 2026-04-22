#!/bin/bash

#initialisation des variables principales

version_os=$(ssh $ssh_client "cat /etc/os-release | grep 'VERSION=' | cut -d '=' -f2 | tr -d '\"'")
maj_critiques=$(ssh $ssh_client "apt list --upgradable 2>/dev/null | grep 'security'")
nombre_maj_critiques=$(echo "$critical_update" | wc -l)
marque_modele=$(ssh $ssh_client "dmidecode -t system | grep -E 'Manufacturer|Version'")



function menu_secondaire
{
    echo "1 - Revenir au menu Système"
    echo "2 - Revenir au menu principal"
    echo "q - Quitter le script"
    read -p "Quel est votre choix ?" choix_secondaire

    case $choix_secondaire in

    1)
        log "Retour menu système"
        echo "Vous retournez au menu systeme"
        sleep 1
		clear
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



# Menu systeme


log "Demande sur systeme"
echo "Bienvenue dans les informations système"
sleep 1
clear

while true
do
	clear
    echo "Que souhaitez-vous savoir ?"
    echo "1- Version de l'OS"
    echo "2- Mise à jours critiques"
    echo "3- Marque et modèle"
    echo "r - Revenir au menu précédent"
    echo "q - Quitter le script"
    read -p "Quel est votre choix ? :" choix

    case $choix in

        # Affichage Version OS
    1) 
        log "Consulte version OS"
        echo "La version de l'OS est : $version_os"
        menu_secondaire
        ;;
        # Mises à jours critiques
    2) 
        log "Consulte mises à jours critiques"
        echo "Il y a $nombre_maj_critiques mises à jours critiques à faire"
        echo "Liste des mises à jours :"
        echo "$maj_critiques"
        menu_secondaire
        ;;
    3) 
        log "Consulte marque et modele"
        echo "Le client est de la marque/modèle : $marque_modele"
        menu_secondaire
        ;;
    r)
        log "Retour arrière"
        echo "Vous allez revenir au menu principal"
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
        echo "L\'option choisie n\'existe pas veuillez recommencer"
        ;;
    esac
done
	
# / UAC_STATUS à integrer dans ce script version Windows ///
