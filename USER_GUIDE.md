# Guide d'Utilisation - Outil d'Administration

Bienvenue dans la documentation utilisateur de notre outil d'administration de parc informatique. 

Cet outil vous permet de gérer de manière centralisée les utilisateurs et les groupes sur des machines clientes Linux (Ubuntu) et Windows (10/11), depuis un serveur Debian ou un Windows Server.

---

## 1. Utilisation : Comment exécuter le script ?

L'outil a été conçu de manière interactive. Vous n'avez pas besoin de mémoriser de longues commandes, il vous suffit de lancer le script parent (le chef d'orchestre) et de vous laisser guider par les menus à l'écran.

### Depuis le serveur d'administration Linux (Debian)

Cette partie permet d'administrer n'importe quel client (Linux ou Windows) depuis le terminal de votre serveur Debian.

**Étape 1 : Préparation**

Ouvrez votre terminal et placez-vous dans le dossier contenant le script :
`cd /chemin/vers/votre/dossier/scripts_debian/`

**Étape 2 : Exécution**

Lancez le script parent avec la commande suivante :
`./parental_linux.sh`
*(Note : Si le système vous indique "Permission non accordée", tapez d'abord `chmod +x parental_linux.sh` pour lui donner les droits d'exécution).*

**Étape 3 : Navigation**

  1. Le script vous demandera d'abord ???????????????????? et l'adresse IP de la machine cible.
     
  2. Le Menu Principal s'affiche. Tapez le numéro correspondant à l'action souhaitée (ex: `1` pour Utilisateurs, `2` pour Groupes).
     
  3. L'outil détectera automatiquement si la cible est un Linux ou un Windows et lancera les commandes adaptées en arrière-plan.

### Depuis le serveur d'administration Windows (Windows Serveur 2022)

Cette partie permet d'administrer votre parc depuis l'environnement PowerShell de votre serveur Windows.

**Étape 1 : Préparation**
Ouvrez une console **PowerShell en tant qu'Administrateur** et naviguez vers le dossier du script :
`cd C:\chemin\vers\votre\dossier\scripts_windows_server\`

**Étape 2 : Exécution**
Lancez le script parent avec la commande :
`.\parental_windows.ps1`

**Étape 3 : Navigation**
La logique est strictement identique à la version Linux : entrez les identifiants de la machine cible, puis naviguez dans les menus chiffrés pour créer, modifier ou supprimer vos comptes utilisateurs et groupes.

---

## 2. FAQ

**Q : Où puis-je consulter l'historique des actions effectuées par le script ?**
**R :** Notre outil intègre une journalisation .................................... Où ??????

**Q : Le script me renvoie une erreur "Connection refused" ou "Permission denied" au moment de l'action, pourquoi ?**

**R :** Cela signifie que le tunnel de communication n'a pas pu s'établir.
- Vérifiez que vous avez saisi la bonne adresse IP.
- Vérifiez que le service SSH (OpenSSH) est bien installé et démarré sur la machine cliente cible (surtout sur les clients Windows 10/11 où il n'est pas toujours actif par défaut).

**Q : Pourquoi mon script `parental_linux.sh` se ferme-t-il brusquement après une action ?**

**R :** Si le script s'arrête au lieu d'afficher le sous-menu de retour, c'est généralement lié à une erreur de syntaxe cachée. Assurez-vous que tous les sous-scripts enfants (dans `child_linux` et `child_windows`) possèdent bien l'extension `.sh` et sont présents dans le même dossier que le script parent.
