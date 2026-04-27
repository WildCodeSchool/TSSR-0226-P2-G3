#!/bin/bash

#initialisation des variables principales

number_disk_client=$(ssh $ssh_client "powershell.exe -Command 'Get-Volume | Where-Object {\$_.DriveType -eq ''Fixed''} | Measure-Object | Select-Object -ExpandProperty Count'")
volumes_client=$(ssh $ssh_client "powershell.exe -Command 'Get-Volume | Select-Object DriveLetter, FileSystemType, Size, DriveType, FriendlyName'")
list_reader_client=$(ssh $ssh_client "powershell.exe -Command 'Get-Volume | Where-Object {\$_.DriveLetter -ne \$null} | Select-Object DriveLetter, FileSystemType, Size, FriendlyName'")

function menu_secondaire
{
    echo "1 - Revenir au menu Disques"
    echo "2 - Revenir au menu principal"
    echo "q - Quitter le script"
    read -p "Quel est votre choix ?" choix_secondaire

    case $choix_secondaire in

    1)
        log "Retour menu disque"
        echo "Vous retournez au menu Disques"
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

log "Demande sur disques"

echo "Direction la gestion des Disques et Lecteurs"
sleep 1
clear

# Menu disques

while true
do
    clear
    echo -e "Menu Disques\n"
    echo -e "Que souhaitez-vous connaitre ?\n"
    echo "1 - Le nombre de disques"
    echo "2 - Le partitionnement par disque"
    echo "3 - La liste des lecteurs montés"
    echo "4 - Revenir au menu principal"
    echo "q - quitter le script"
    read -p "Quel est votre choix ? :" choix

    case $choix in

     #Affichage du nombre de disques sur le poste client
    1)
        log "Consultation nombre de disques client"
        clear
        echo -e "Le nombre de disques de $ssh_client est de $number_disk_client\n"
        menu_secondaire
        ;;
    # Affichage détaillé des partitions
    2)
        log "Consultation détail des partitions"
        clear
        echo -e "Le poste $ssh_client contient les volumes suivants :\n"
        echo -e "$volumes_client\n"
        menu_secondaire
        ;;
    3)
        log "Consultation disques montés"
        echo -e "La liste des lecteurs montés sur $ssh_client :\n"
        echo -e "$list_reader_client\n"
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
        echo "L'option choisi n'existe pas, veuillez recommencer"
        sleep 1
        ;;
    esac
done
