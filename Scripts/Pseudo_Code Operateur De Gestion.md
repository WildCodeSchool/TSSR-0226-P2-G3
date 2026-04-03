#!/bin/bash

# Opérateur De Maintenance

connexions_linux.sh
et  
connexions_window.sh

LAST_LOGGINGS= Tableau des 5 derniers loggings IP et horodatage
$IP= Ip du client
$MASK= Masque Ip du client
$GATEWAY= Passerelle du client

# MISE EN PLACE DU SCRIPT

FONCTION IN_CASE_MENU
{

affiche "1 - Revenir au menu gestion utilisateur"

affiche "2 - Revenir au menu principal"

affiche "q - Quitter le script"
	Demande CHOICE_MENU
	
	CAS ou $CHOICE_MENU est
	1)
		Log "Retour menu gestion utilisateur"
	
    affiche "Vous allez revenir au Menu Utilisateur"
		Return
	2)
		Log "Retour menu principal"
	
    affiche "Vous allez revenir au menu principal"
		Attente 3 sec
		Exit 0
	q)
		Log "Quitte le script"
	
    affiche "Vous quittez le script"
		Attente 3sec
		Exit 50
	*) 
	
    affiche "L'option choisie n'existe pas, veuillez recommencer"
		IN_CASE_MENU
}

affiche "Opérateur de Maintenance"
attente 3sec puis efface

tant que vrai
affiche "- Gestion de répertoire"
affiche "- Reboot"
affiche "- Prise de main à distance (CLI)"
affiche "- Activation du pare-feu"
affiche "- Exécution de script sur la machine distante"
affiche "- Liste des utilisateurs locaux"
affiche "- Retourner au menu précédent"
affiche "- Quitter le script"

CAS ou $CHOISE est 

#############################
# 1. GESTION DE REPERTOIRE
#############################

Log "Accès menu Gestion De Répertoire par $USER"
Affiche "Gestion De Répertoire"
Affiche "1 - Créer Un Répertoire"
Affiche "2 - Supprimer Un Répertoire"
Affiche "3 - Retour au menu Opérateur de Maintenance"
Demande CHOICE_REP

CAS ou $CHOICE_REP est

###############################
#CREER UN REPERTOIRE
###############################

Log "Accès création de répertoire par $USER"

Tester si le repertoire n'existe pas
Si le repertoire n'existe pas alors;
affiche voulez vous vraiment creer ce repertoire ?
    si oui alors,     
        le creer
        informer l_utilisateur que le repertoire a ete creer
    sinon 
        affiche "ce repertoire existe deja , creation du repertoire refuse"
    fi

############################
#SUPPRIMER UN REPERTOIRE
############################

Log "Accès suppression de répertoire par $USER"

Tester si le répertoire existe si oui alors;
    verifier que l_utilisateur souhaite bien creer ce repertoire
    apres confirmation supprimer le répertoire
        Informer l_utilisateur que le répertoire a été supprimé
Sinon 
    Informer que le répertoire n_existe pas
Fin

##########################
# 2. REDEMARRER
##########################

Log "Accès menu Reboot par $USER"

Voulez-vous vraiment reboot le pc ?

Si oui alors;
    affiche Le pc redemarre
    attendre 3 sec
    redemarrage
Sinon
    redemarrage annulé
    Revenir au menu Opérateur de Maintenance
Fi
fin du script reboot

#####################################
# 3. PRISE DE MAIN A DISTANCE (CLI)
#####################################

Log "Accès menu Prise de main à distance par $USER"

#Saisie et validation de l_IP cible
affiche "Entrez l'adresse IP de la machine distante : " IP_cible

Si saisie vide alors
        Affiche vous n'avez pas entré d'adresse ip , reessayer
fi

Si le format de $IP_cible n'est pas une IP valide alors
        Affiche format d'adresse IP invalide, reesayer
fi

#Saisie du nom d'utilisateur distant
    affiche entrez le nom d'utilisateur distant :  User
si saisie vide alors
        Affiche vous n'avez pas entré de nom d'utilisateur, recommencez
Fi

#Test de connectivité avant SSH
    Affiche test de connectivité vers ...
    Ping $IP_cible

Si ping échoue alors
    Affiche erreur : la machine $IP_cible ne répond pas au ping
    Affiche vérifiez que la machine est allumée et accessible sur le réseau
Fi

Si ping OK continue

#Connexion SSH
tentative de connexion SSH
Connexion SSH vers $USER_DISTANT@$IP_CIBLE

Si connexion SSH réussie alors
    Affiche vous êtes maintenant connecté à $IP_CIBLE
Sinon
    Affiche connexion SSH impossible vers $IP_CIBLE
    Affiche Vérifiez les identifiants et que le service SSH est actif sur la machine distante
Fi

#Fin de session SSH
Affiche Vous avez été déconnecté de $IP_CIBLE
Retour au menu Opérateur de Maintenance

##############################
# 4. ACTIVATION DU PARE-FEU                        
##############################

Log Activation du pare-feu par $USER

L'utilisateur souhaite-il activer son pare feu
    Si oui alors;
        active le pare-feu
        si verif activation de pare-feu ok alors;
            Le pare-feu a bien ete active
        Sinon
        Erreur impossible d'activer le pare-feu
        Fi
    Sinon 
        activation annulé
            activation annulé
        Retourne au menu Opérateur de Maintenance
    Fi

#################################################
# 5. EXECUTION DE SCRIPT SUR LA MACHINE DISTANTE
#################################################

Log Execution de script sur la machine distante par $USER
Quel script l'utilisateur souhaite-il lancer

Verification de laconnection ssh
Le script existe-il ?
    Tester si il existe
        Si oui alors;
            on l'execute 
        Sinon
        Le script est introuvable
    Fi

#####################################
# 6. LISTE DES UTILISATEURS LOCAUX
#####################################

Log Liste des utilisateurs locaux par $USER
Récupérer la liste des utilisateurs locaux via la commande
    si recuperation ok alors;
    Afficher la liste à l'utilisateur
Sinon
    affiche recuperation impossible
fi

esac
done
