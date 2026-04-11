**Infos supplémentaires :**
Script clair = si camelcase, camelcase partout / nom variable clair

Chocolatey ? logiciel packet management Windows

Penser à droit exécution + menu (en avant en arrière cibler un ordinateur ou un utilisateur)
taille ram machine, ajouter utilisateur ou retirer utilisateur groupe ...

# Mes scripts

1. Connexions
	5 Derniers Login
	Adresse IP, masque, passerelle

2. Disques
	Nombre de disque
	Partition (nombre, non, FS, taille) par disque
	Liste des lecteurs monté (disque, CD, etc...)

3. Systeme
	Version de l'OS
	Mise à jour critiques manquantes
	Marque/modele


## 1.Connexion

``` bash

connexions_linux.sh
et 
connexions_window.sh

LAST_LOGGINGS= Tableau des 5 derniers loggings IP et horodatage
$IP= Ip du client
$MASK= Masque Ip du client
$GATEWAY= Passerelle du client

FONCTION IN_CASE_MENU
{
	Affiche "1 - Revenir au menu connexion"
	Affiche "2 - Revenir au menu principal"
	Affiche "q - Quitter le script"
	Demande
	CAS ou $CHOICE_MENU est
	1)
		Log "Retour menu connexion"
		Affiche "Vous allez revenir au Menu Connexion"
		Return
	2)
		Log "Retour menu principal"
		Affiche "Vous allez revenir au menu principal"
		Attente 3 sec
		Exit 0
	q)
		Affiche "Vous quittez le script"
		Attente 3sec
		Exit 50
	*) 
		Affiche "L'option choisi n'existe pas veuillez recommencer"
		IN_CASE_MENU
}


Log "Demande infos connexion"

# Menu connexions

Affiche "Bienvenue dans la gestion des connexion"
Attente 3sec puis efface

Tant que vrai
Affiche "Que souhaitez-vous savoir ?"
Affiche "1- Derniers loggings à distance"
Affiche "2- Adresse IP, masque Ip et passerelle du client"
Affiche "3 - Revenir au menu précédent"
Affiche "q - Quitter le script"
Demande "Quel est votre choix ?" : CHOICE

CAS ou $CHOICE est

# Affichage 5 derniers loggings
1) 
	Log "cinq derniers login"
	Affiche "Voici les 5 derniers loggings :"
	Affiche Tableau $LAST_LOGGINGS
	IN_CASE_MENU
   
# Adresse IP, Masque, Passerelle client
2) 
	Log "Affichage IP, Masque, Passerelle "
	Affiche "L'adresse IP du client est $IP_CLIENT"
	Affiche "Le masque de sous-réseau du client est $MASK"
	Affiche "La passerelle du client est $GATEWAY"
	IN_CASE_MENU
3)
	Log "Retour arrière"
	Affiche "Vous allez revenir au menu principal"
	Attente 3 sec
	Exit 0

q)
	Log "Quitte le script"
	Affiche "Vous quittez le script"
	Attente 3sec
	Exit 50

*) 
	Affiche "L'option choisi n'existe pas veuillez recommencer"
```

## 2.Disques

```bash

disks_linux.sh
et
disks_Windows.sh

NUMBER_DISK_CLIENT=compter les disques client
LIST_DISK=liste des des disques client
LIST_DISK_READER= Liste des lecteur montés

FONCTION IN_CASE_MENU
{
	Affiche "1 - Revenir au menu disques"
	Affiche "2 - Revenir au menu principal"
	Affiche "q - Quitter le script"
	Demande
	CAS ou $CHOICE_MENU est
	1)
		Log "Retour menu disque"
		Affiche "Vous allez revenir au Menu Disques"
		Return
	2)
		Log "Retour menu principal"
		Affiche "Vous allez revenir au menu principal"
		Attente 3 sec
		Exit 0
	q)
		Affiche "Vous quittez le script"
		Attente 3sec
		Exit 50
	*) 
		Affiche "L'option choisi n'existe pas veuillez recommencer"
		IN_CASE_MENU
}

Log "Demande sur disques"

# Menu Disques


Affiche "Bienvenue dans la gestion des disques et lecteurs"
Attente 3sec puis efface

Tant que vrai
Affiche "Menu Disques"
Affiche "Que souhaitez-vous savoir ?"
Affiche "1 - Le nombre de disques"
Affiche "2 - Le partionnement par disque"
Affiche "3 - La liste des lecteurs montés"
Affiche "4 - Revenir au menu principal"
Affiche "q - Quitter le script"
Demande "Quel est votre choix ?" : CHOICE



CAS ou $CHOICE est

# Affichage nombre de disques
1) 
   Log "nombre de disques durs client"
   Affiche "Le nombre de disque de $CLIENT_NAME($IP_CLIENT) est de $NUMBER_DISK_CLIENT"
   IN_CASE_MENU
   
# Affichage partitions
2) 
   Log "Affichage partitions"
   Affiche "Le $CLIENT_NAME contient $NUMBER_DISK_CLIENT avec pour détail"
   SAUT DE LIGNE

POUR DISK dans LIST_DISK
PART_NUMBER_DISK=Nombre de partition du $DISK
   AFFICHE " Le nom du disque est $DISK"
   AFFICHE "Nombre partitions de $DISK : $PART_NUMBER_DISK"
   SAUT DE LIGNE
   
POUR PARTITION dans DISK
FS_PART_DISK=File System de la $PARTITION
SIZE_PART_DISK=Taille de la $PARTITION
	AFFICHE "Concernant la partition $PARTITION"
	AFFICHE "Le File System est : $FS_PART_DISK"
	AFFICHE "Et sa taille est : $SIZE_PART_DISK"
   IN_CASE_MENU


3)
	Log "Liste lecteurs montés"
	Affiche "La liste des lecteurs montés de $CLIENT_NAME ($IP_CLIENT) est : $LIST_DISK_READER "
	IN_CASE_MENU

4)
	Log "Retour menu principal"
	Affiche "Vous allez revenir au menu principal"
	Attente 3 sec
	Exit 0

q)
	Log "Quitte le script"
	Affiche "Vous quittez le script"
	Attente 3sec
	Exit 50

*) 
	Affiche "L'option choisi n'existe pas veuillez recommencer"
```

## 3.Systeme

```bash

systeme_linux.sh
et 
systeme_window.sh

OS_VERSION= Version OS
CRITICAL_UPDATE= Liste des mises à jours critiques
NUMBER_CRITICAL_UPDATE= Nombre de mises à jours critiques *(=$(echo "$CRITICAL_UPDATE | wc -l))*
BRAND_AND_MODEL= Marque et modèle

FONCTION IN_CASE_MENU
{
	Affiche "1 - Revenir au menu connexion"
	Affiche "2 - Revenir au menu principal"
	Affiche "q - Quitter le script"
	Demande
	CAS ou $CHOICE_MENU est
	1)
		Log "Retour menu connexion"
		Affiche "Vous allez revenir au Menu Connexion"
		Return
	2)
		Log "Retour menu principal"
		Affiche "Vous allez revenir au menu principal"
		Attente 3 sec
		Exit 0
	q)
		Log "Quitte le script"
		Affiche "Vous quittez le script"
		Attente 3sec
		Exit 50
	*) 
		Affiche "L'option choisi n'existe pas veuillez recommencer"
		IN_CASE_MENU
}


Log "Demande infos systeme"

# Menu systeme

Affiche "Bienvenue dans les informations système"
Attente 3sec puis efface

Tant que vrai
Affiche "Que souhaitez-vous savoir ?"
Affiche "1- Version de l'OS"
Affiche "2- Mise à jours critiques"
Affiche "3- Marque et modèle"
Affiche "r - Revenir au menu précédent"
Affiche "q - Quitter le script"
Demande "Quel est votre choix ?" : CHOICE

CAS ou $CHOICE est

# Affichage Version OS
1) 
	Log "Consulte version OS"
	Affiche "La version de l'OS est : $OS_VERSION"
	IN_CASE_MENU
   
# Mises à jours critiques
2) 
	Log "Consulte mises à jours critiques"
	Affiche "Il y a $NUMBER_CRITICAL_UPDATE mise à jours critiques à faire"
	Affiche "Liste des mises à jours : $CRITICAL_UPDATE"
	IN_CASE_MENU
3) 
	Log "Consulte marque et modele"
	Affiche "Le client est de la marque/modèle : $BRAND_AND_MODEL"
	IN_CASE_MENU
r)
	Log "Retour arrière"
	Affiche "Vous allez revenir au menu principal"
	Attente 3 sec
	Exit 0

q)
	Affiche "Vous quittez le script"
	Attente 3sec
	Exit 50

*) 
	Affiche "L'option choisi n'existe pas veuillez recommencer"
	
	
	/// UAC_STATUS à integrer dans ce script version Windows ///
```
