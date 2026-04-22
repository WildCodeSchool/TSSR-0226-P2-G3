#!/bin/bash

function log
{
    echo "$(date '+%d-%m-%Y_%H:%M:%S')_${USER}_$1" >> "$log_file"
}

# Il est nécessaire d'installer ipcalc sur le client linux (A noter dans install ou readme)

#initialisation des variables principales

last_logins=$(ssh $ssh_user@$ip_client "powershell.exe -Command 'Get-EventLog -LogName Security -InstanceId 4624 -Newest 5 | Select-Object TimeGenerated, UserName'")
ipcon_client=$(ssh $ssh_user@$ip_client "powershell.exe -Command 'Get-NetIPAddress -AddressFamily IPv4 | Where-Object {\$_.InterfaceAlias -notlike ''*Loopback*''} | Select-Object -ExpandProperty IPAddress'")
mask_client=$(ssh $ssh_user@$ip_client "powershell.exe -Command ")
gateway_client=$(ssh $ssh_user@$ip_client "powershell.exe -Command ")



function secondary_menu
{
    echo "1 - Revenir au menu Disques"
    echo "2 - Revenir au menu principal"
    echo "q - Quitter le script"
    read -p "Quel est votre choix ?" choice_secondary

    case $choice_secondary in

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
        secondary_menu
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
    read -p "Quel est votre choix ? :" choice

    case $choice in

    # Affichage des 5 dcerniers logins

    1) 
	    log "cinq derniers login"
	    echo "Voici les 5 derniers loggings :"
	    echo "$last_logins"
	    secondary_menu
        ;;
# Adresse IP, Masque, Passerelle client
    2) 
	    log "Affichage IP, Masque, Passerelle "
	    echo "L'adresse IP du client est $ipcon_client"
	    echo "Le masque de sous-réseau du client est $mask_client"
	    echo "La passerelle du client est $gateway_client"
	    secondary_menu
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