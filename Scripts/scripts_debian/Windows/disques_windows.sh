#!/bin/bash

#initialisation des variables principales

number_disk_client=$(ssh $ssh_client "powershell.exe -Command '(Get-Disk | Measure-Object).Count'")
list_disk_client=$(ssh $ssh_client "powershell.exe -Command 'Get-Disk | Select-Object -ExpandProperty DiskNumber'")
list_reader_client=$(ssh $ssh_client "powershell.exe -Command 'Get-Volume | Where-Object {\$_.DriveLetter -ne \$null} | Select-Object DriveLetter, FriendlyName, FileSystem, DriveType'")


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
        echo "Le poste $ssh_client contient $number_disk_client avec en détail :\n"
        for disk in $list_disk_client
        do
            part_number=$(ssh $ssh_client "powershell.exe -Command '(Get-Partition -DiskNumber $disk | Measure-Object).Count'")
            echo "Numéro du disque : $disk"
            echo "Nombre de partitions du disque $disk : $part_number"

            for partition in $(ssh $ssh_client "powershell.exe -Command 'Get-Partition -DiskNumber $disk | Select-Object -ExpandProperty PartitionNumber'")
            do
                partition_data=$(ssh $ssh_client "powershell.exe -Command 'Get-Partition -DiskNumber $disk -PartitionNumber $partition | Get-Volume | Select-Object FileSystemType, Size'")
                fs_part=$(echo "$partition_data" | awk '{print $2}')
                size_part=$(echo "$partition_data" | awk '{print $3}')
                echo "Concernant la partition $partition"
                echo "Le File System est : $fs_part"
                echo -e "Et la taille de la partition est : $size_part\n"
            done
        done
        menu_secondaire
        ;;
    3)
        log "Consultation disques montés"
        echo "La liste des lecteurs montés sur <CLIENT NOM> est : $list_reader_client\n"
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
