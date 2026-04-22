#!/bin/bash

function menu_secondaire
{
    echo "1 - Revenir au menu répertoires"
    echo "2 - Revenir au menu principal"
    echo "q - Quitter le script"
    read -p "Quel est votre choix ?" choix_secondaire

    case $choix_secondaire in

    1)
        log "Retour menu répertoires"
        echo "Vous retournez au menu répertoires"
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


# Menu Répertoires


log "Demande sur répertoire"
echo "Bienvenue dans le menu répertoires"
sleep 3
clear

while true
do
    echo "Que souhaitez-vous faire ?"
    echo "1- Créer un répertoire"
    echo "2- Supprimer un répertoire"
    echo "r - Revenir au menu précédent"
    echo "q - Quitter le script"
    read -p "Quel est votre choix ? :" choix

    case $choix in

    1) 
        log "Création répertoire"
        echo -e "Exemple: C:\\Users\\user\\monrepertoire ou C:\\Temp\\monrepertoire"
        read -p "Entrez le chemin du répertoire à créer : " repo

        if [ -z "$repo" ]; 
        then
            echo -e "Erreur : saisie vide, veuillez recommencer."
        return
        fi

        # Vérification si le répertoire existe déjà sur Windows
        EXISTE=$(ssh "$ssh_client" \
            "powershell -Command \"Test-Path -Path '$repo'\"")

        if echo "$EXISTE" | grep -qi "true";
        then
            echo "Ce répertoire existe déjà, création refusée."
        return
        fi

        read -p "Voulez-vous vraiment créer ce répertoire ? (O/N) : " creation
        if [ "$creation" = "o" ] || [ "$creation" = "O" ]; 
        then
            ssh "$ssh_client" \
                "powershell -Command \"New-Item -ItemType Directory -Path '$repo'\""
            echo "Le répertoire '$repo' a été créé avec succès."
        else
            echo "Création annulée."
        fi
        menu_secondaire
        ;;

    2) 
        log "Suppression répertoire"
        echo -e "Exemple: C:\\Users\\user\\monrepertoire ou C:\\Temp\\monrepertoire"
        read -p "Entrez le chemin du répertoire à supprimer : " reposupp

        # Vérification si le répertoire existe sur Windows
        EXISTE=$(ssh "$ssh_client" \
            "powershell -Command \"Test-Path -Path '$reposupp'\"")

        if echo "$EXISTE" | grep -qi "false";
        then
            echo "Le répertoire '$reposupp' n'existe pas."
        return
        fi

        read -p "Voulez-vous vraiment supprimer ce répertoire ? (O/N) : " supprime
        if [ "$supprime" = "o" ] || [ "$supprime" = "O" ]; 
        then
            ssh "$ssh_client" \
                "powershell -Command \"Remove-Item -Recurse -Force -Path '$reposupp'\""
            echo "Le répertoire '$reposupp' a été supprimé avec succès."
        else
            echo "Suppression annulée."
        fi
        menu_secondaire
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
