#!/bin/bash

#initialisation des variables principales

nombre_disque_client=$(ssh $ssh_user@$ip_client "lsblk -d | grep disk | wc -l")
liste_disque_client=$(ssh $ssh_user@$ip_client "lsblk -d | grep disk | awk '{print \$1}'")
liste_lecteur_client=$(ssh $ssh_user@$ip_client "lsblk -o NAME,TYPE,MOUNTPOINT | awk '\$3 != \"\"' | awk '{print \$1, \$2, \$3}'")


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
        sleep 3s
        menu_secondaire
        ;;
    esac
}

log "Demande sur disques"

echo "Bienvenue dans la gestion des Disques et Lecteurs"
sleep 3
clear

# Menu disques

while true
do
    echo "Menu Disques"
    echo "Que souhaitez-vous connaitre ?"
    echo "1 - Le nombre de disques"
    echo "2 - Le partitionnement par disque"
    echo "3 - La liste des lecteurs montés"
    echo "4 - Revenir au menu principal"
    echo "q - quitter le script"
    read -p "Quel est votre choix ? :" choix

    case $choix in

    # Affichage du nombre de disques sur le poste client
    1)
        log "Consultation nombre de disques client"
        echo "Le nombre de disques de $ip_client est de $nombre_disque_client"
        secondary_menu
        ;;
    # Affichage détaillé des partitions
    2)
        log "Consultation détail des partitions"
        echo "Le poste <CLIENT NOM> contient $nombre_disque_client avec en détail :\n"

        for disk in $liste_disque_client
        do
            part_nombre=$(ssh $ssh_user@$ip_client "lsblk | grep $disk | grep part | wc -l")
            echo "Nom du disque : $disk"
            echo "Nombre de partitions de $disk : $part_nombre\n"

            for partition in $(ssh $ssh_user@$ip_client "lsblk -o NAME,TYPE | grep \"$disk\" | grep 'part' | awk '{print $1}'")
            do
                partition_data=$(ssh $ssh_user@$ip_client "lsblk -o NAME,FSTYPE,SIZE | grep \"$partition\"")
                fs_part=$(echo "$partition_data" | awk '{print $2}')
                taille_part=$(echo "$partition_data" | awk '{print $3}')
                echo "Concernant la partition $partition"
                echo "Le File System est : $fs_part"
                echo "Et la taille de la partition est : $taille_part"
            done
        done
        menu_secondaire
        ;;
    3)
        log "Consultation disques montés"
        echo "La liste des lecteurs montés sur <CLIENT NOM> est : $liste_lecteur_client"
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
        echo "L'option choisi n'existe pas, veuillez recommencer"
        sleep 3
        ;;
    esac
done
