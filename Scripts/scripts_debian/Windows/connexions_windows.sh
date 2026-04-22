#!/bin/bash


#initialisation des variables principales

last_logins=$(ssh $ssh_client "powershell.exe -Command 'Get-EventLog -LogName Security -InstanceId 4624 -Newest 20 | Where-Object {\$_.ReplacementStrings[8] -eq 2 -or \$_.ReplacementStrings[8] -eq 10} | Select-Object -First 5 TimeGenerated, ReplacementStrings'")
ipcon_client=$(ssh $ssh_client "powershell.exe -Command 'Get-NetIPAddress -AddressFamily IPv4 | Where-Object {\$_.InterfaceAlias -notlike ''*Loopback*''} | Select-Object -ExpandProperty IPAddress'")
mask_client=$(ssh $ssh_client "powershell.exe -Command '\$prefix = (Get-NetIPAddress -AddressFamily IPv4 | Where-Object {\$_.InterfaceAlias -notlike ''*Loopback*''}).PrefixLength; \$mask = [uint32]0; for(\$i=0;\$i -lt \$prefix;\$i++){\$mask = \$mask -bor (1 -shl (31-\$i))}; ([System.Net.IPAddress]\$mask).ToString()'")
gateway_client=$(ssh $ssh_client "powershell.exe -Command 'Get-NetRoute -DestinationPrefix 0.0.0.0/0 | Select-Object -ExpandProperty NextHop'")



function menu_secondaire
{
    echo "1 - Revenir au menu Connexion"
    echo "2 - Revenir au menu principal"
    echo "q - Quitter le script"
    read -p "Quel est votre choix ?" choix_secondaire

    case $choix_secondaire in

    1)
        log "Retour menu connexion"
        echo "Vous retournez au menu connexion"
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

log "Demande sur connexion"

echo "Direction le menu connexion"
sleep 1
clear

# Menu Connexion

while true
do
	clear
    echo "Menu Connexion"
    echo "Que souhaitez-vous connaitre ?"
    echo "1 - Les 5 dernières connexions à distance"
    echo "2 - Adresse IP, masque IP et passerelle du Client"
    echo "3 - Revenir au menu principal"
    echo "q - quitter le script"
    read -p "Quel est votre choix ? :" choix

    case $choix in

    # Affichage des 5 dcerniers logins

    1) 
		clear
	    log "cinq derniers login"
	    echo "Voici les 5 derniers loggings :"
	    echo "$last_logins"
	    menu_secondaire
        ;;
# Adresse IP, Masque, Passerelle client
    2) 
		clear
	    log "Affichage IP, Masque, Passerelle "
		echo -e "Voici les informations réseau\n"
	    echo "L'adresse IP du client est $ipcon_client"
	    echo "Le masque de sous-réseau du client est $mask_client"
	    echo -e "La passerelle du client est $gateway_client\n"
	    menu_secondaire
        ;;
    3)
	    log "Retour arrière"
	    echo "Vous allez revenir au menu principal"
	    sleep 1
	    exit 0
        ;;
    q)
	    log "EndScript"
	    echo "Vous quittez le script"
	    sleep 1
	    exit 50
        ;;
    *) 
	    echo "L'option choisi n'existe pas veuillez recommencer"
        ;;
    esac
done
