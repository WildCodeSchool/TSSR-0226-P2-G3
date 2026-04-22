#!/bin/bash


#initialisation des variables principales

version_os=$(ssh $ssh_client "powershell.exe -Command 'Get-ComputerInfo | Select-Object -ExpandProperty OsName'")
maj_critiques=$(ssh $ssh_client "powershell.exe -Command 'Set-ExecutionPolicy Bypass -Scope Process -Force; Import-Module PSWindowsUpdate; Get-WindowsUpdate -Category Security | Select-Object Title'")
nombre_maj_critiques=$(echo "$maj_critiques" | wc -l)
marque_modele=$(ssh $ssh_client "powershell.exe -Command 'Get-ComputerInfo -Property CsManufacturer,CsModel'")
uac_status=$(ssh $ssh_client "powershell.exe -Command '(Get-ItemProperty HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System).EnableLUA'" | tr -d '[:space:]')


function menu_secondaire
{
    echo "1 - Revenir au menu Système"
    echo "2 - Revenir au menu principal"
    echo "q - Quitter le script"
    read -p "Quel est votre choix ?" choix_secondaire

    case $choix_secondaire in

    1)
        log "Retour menu systeme"
        echo "Vous retournez au menu systeme"
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
        sleep 3s
        menu_secondaire
        ;;
    esac
}



# Menu systeme


log "Demande sur systeme"
echo "Direction les informations système"
sleep 1
clear

while true
do
	clear
    echo "Que souhaitez-vous savoir ?"
    echo "1- Version de l'OS"
    echo "2- Mise à jours critiques"
    echo "3- Marque et modèle"
    echo "4- Statut UAC"
    echo "r - Revenir au menu précédent"
    echo "q - Quitter le script"
    read -p "Quel est votre choix ? :" choix

    case $choix in

        # Affichage Version OS
    1) 
	    log "Consulte version OS"
	    echo "La version de l'OS est : $os_version"
	    menu_secondaire
        ;;
        # Mises à jours critiques
    2) 
	    log "Consulte mises à jours critiques"
	    echo "Il y a $number_critical_update mises à jours critiques à faire"
	    echo "Liste des mises à jours :"
        echo "$critical_update"
        menu_secondaire
        ;;
    3) 
	    log "Consulte marque et modele"
	    echo "Le client est de la marque/modèle : $brand_and_model"
        menu_secondaire
        ;;
    4)
        log "Consulte statut UAC"
        if [[ "$uac_status" == "1" ]]
		then
            echo "L'UAC est activé sur $ssh_client"
        else
            echo "L'UAC est désactivé sur $ssh_client"
        fi
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
