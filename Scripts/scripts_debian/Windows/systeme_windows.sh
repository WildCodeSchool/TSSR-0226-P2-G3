#!/bin/bash

# SSH-Agent permettant la connexion sans interrogation du mot de passe
eval $(ssh-agent -s)
ssh-add ~/.ssh/id_rsa

#initialisation des variables principales

version_os=$(ssh $ssh_client "powershell.exe -Command '(Get-WmiObject Win32_OperatingSystem).Caption'")
maj_critiques=$(ssh $ssh_client "powershell.exe -Command 'Import-Module PSWindowsUpdate; Get-WindowsUpdate -Category ''Security Updates'' | Select-Object Title, Size'")
nombre_maj_critiques=$(echo "$maj_critiques" | wc -l)
marque_modele=$(ssh $ssh_client "powershell.exe -Command '(Get-WmiObject Win32_ComputerSystem).Manufacturer + '' '' + (Get-WmiObject Win32_ComputerSystem).Model'")
uac_status=$(ssh $ssh_client "powershell.exe -Command '(Get-ItemProperty HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System).EnableLUA'")


function secondary_menu
{
    echo "1 - Revenir au menu Disques"
    echo "2 - Revenir au menu principal"
    echo "q - Quitter le script"
    read -p "Quel est votre choix ?" choice_secondary

    case $choice_secondary in

    1)
        log "Retour menu systeme"
        echo "Vous retournez au menu systeme"
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
        secondary_menu
        ;;
    esac
}



# Menu systeme


log "Demande sur systeme"
echo "Bienvenue dans les informations système"
sleep 3
clear

while true
do

    echo "Que souhaitez-vous savoir ?"
    echo "1- Version de l'OS"
    echo "2- Mise à jours critiques"
    echo "3- Marque et modèle"
    echo "4- Statut UAC"
    echo "r - Revenir au menu précédent"
    echo "q - Quitter le script"
    read -p "Quel est votre choix ? :" choice

    case $choice in

        # Affichage Version OS
    1) 
	    log "Consulte version OS"
	    echo "La version de l'OS est : $os_version"
	    secondary_menu
        ;;
        # Mises à jours critiques
    2) 
	    log "Consulte mises à jours critiques"
	    echo "Il y a $number_critical_update mises à jours critiques à faire"
	    echo "Liste des mises à jours :"
        echo "$critical_update"
        secondary_menu
        ;;
    3) 
	    log "Consulte marque et modele"
	    echo "Le client est de la marque/modèle : $brand_and_model"
        secondary_menu
        ;;
    4)
        log "Consulte statut UAC"
        if [[ $uac_status -eq 1 ]]; then
            echo "L'UAC est activé sur $ssh_client"
        else
            echo "L'UAC est désactivé sur $ssh_client"
        fi
        secondary_menu
        ;;
    r)
	    log "Retour arrière"
	    echo "Vous allez revenir au menu principal"
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
        echo "L\'option choisie n\'existe pas veuillez recommencer"
        ;;
    esac
done
