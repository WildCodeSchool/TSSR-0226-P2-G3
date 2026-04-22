#!/bin/bash

function menu_secondaire
{
    echo "1 - Revenir au menu maintenance"
    echo "2 - Revenir au menu principal"
    echo "q - Quitter le script"
    read -p "Quel est votre choix ?" choix_secondaire

    case $choix_secondaire in

    1)
        log "Retour menu maintenance"
        echo "Vous retournez au menu maintenance"
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


# Menu Maintenance

while true
do
	clear
    echo "=== Maintenance des machines ==="
    echo "1 - Redemarrage de la machine"
    echo "2 - Prise en main a distance"
    echo "3 - Activation de pare feu"
    echo "4 - Execution de script a distance"
    echo "5 - Liste des utilisateurs locaux"
    echo "r - revenir en arrière"
    read -p "Votre choix : " choix

    case $choix in
    1) 
        log "Redémarrage_De_La_Machine"
        read -p "Voulez-vous vraiment faire un redémarrage de la machine ? (O/N) : " redemarre

        if [ "$redemarre" = "O" ] || [ "$redemarre" = "o" ]; then
            echo "Le pc redémarre..."
            sleep 1
            ssh $ssh_client "reboot"
        else
            echo "Redémarrage annulé."
            menu_secondaire
        fi
        ;;
    2)
        log "Prise_En_Main_A_Distance"
        # --- Saisie et validation de l'IP cible ---
        while true
		do
            read -p "Entrez l'adresse IP de la machine distante : " IP_cible

            if [ -z "$IP_cible" ]; then
                echo "Vous n'avez pas entré d'adresse IP, réessayez."
                continue
            fi

            if [[ ! "$IP_cible" =~ ^([0-9]{1,3}\.){3}[0-9]{1,3}$ ]]; then
                echo "Format d'adresse IP invalide, réessayez."
                continue
            fi

            break
        done

        # --- Saisie du nom d'utilisateur distant ---
        while true
		do
            read -p "Entrez le nom d'utilisateur distant : " utilisateur_distant

            if [ -z "$utilisateur_distant" ]; then
                echo "Vous n'avez pas entré de nom d'utilisateur, recommencez."
                continue
            fi

            break
        done

        # --- Test de connectivité avant SSH ---
        echo "Test de connectivité vers $IP_cible..."

        if ! ping -c 3 -W 2 "$IP_cible" &>/dev/null
		then
            echo "Erreur : la machine $IP_cible ne répond pas au ping."
            echo "Vérifiez que la machine est allumée et accessible sur le réseau."
            menu_secondaire
            return
        fi

        echo "Ping OK, tentative de connexion SSH..."

        # --- #connexion_ssh ---
        echo "Tentative de connexion SSH vers $utilisateur_distant@$IP_cible..."

        if ssh "$utilisateur_distant@$IP_cible"
		then
            echo "Vous êtes maintenant connecté à $IP_cible."
        else
            echo "Connexion SSH impossible vers $IP_cible."
            echo "Vérifiez les identifiants et que le service SSH est actif sur la machine distante."
        fi
        ;;
    3)
        log "Activation_Du_pare_Feu"
        read -p "Voulez vous vraiment activer les pare-feu ? (O/N) " reponse
        if [ "$reponse" = "O" ] || [ "$reponse" = "o" ]
		then
            ssh $ssh_client ufw enable
                if ufw status | grep -q "Status: active"
				then
                    echo "Vos Pare-Feu ont bien été activé"
                else
                    echo "Activation Pare-Feu impossible"
                fi
        else
            echo "Activation Pare-feu annulé"
        fi
        menu_secondaire
        ;;
    4)
        log "Execution_Script_A_Distance"
        if ssh -q -o BatchMode=yes -o ConnectTimeout=5 "$utilisateur_distant@$IP_cible" exit
		then
            echo "Connexion SSH établie"
        else
            echo "Connexion SSH impossible"
            menu_secondaire
        fi

        read -p "Quel script souhaitez vous lancer ? " script

        if [ -f "$script" ] && [ -x "$script" ]
		then
            read -p "Le script existe et est exécutable voulez vous vraiment lancer ce script (O/N)" reponse
            if [ "$reponse" = "O" ] || [ "$reponse" = "o" ]
			then
            bash "$script"
                if [ $? -eq 0 ]
				then
                    echo "Script exécuté avec succès"
                else
                    echo "Erreur lors de l'exécution du script"
                fi
            else
                echo "Retour au menu Operateur De Maintenance"
                menu_secondaire
            fi
        else
            echo "Le script est introuvable ou non exécutable"
            menu_secondaire
        fi
        ;;
    5)
        log "Liste_Utilisateurs_Locaux"
		liste=$(cat /etc/passwd | cut -d: -f1)
		if [ $? -eq 0 ]
		then
    		echo "Les 5 derniers utilisateurs locaux :"
    		echo "$liste" | tail -10
		else
    		echo "Récupération impossible"
		fi
        ;;
    r)
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
        echo "Choix invalide, réessayez."
        ;;
    esac
done
