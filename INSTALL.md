# Sommaire

1. [Prérequis technique](#1-prérequis-techniques)
2. [Configuration sur le serveur Debian (Debian 13)](#2-configuration-sur-le-serveur-debian-debian-13)
3. [Configuration sur le serveur Windows (Windows serveur 2022)](#3-configuration-sur-le-serveur-windows-windows-serveur-2022)
4. [Configuration sur le client Linux (Ubuntu 24.04 LTS)](#4-configuration-sur-le-client-linux-ubuntu-2404-lts)
5. [Configuration sur le client Windows (Windows 10)](#5-configuration-sur-le-client-windows-windows-10)
6. [FAQ](#6-faq)



# 1. Prérequis techniques  

## Architecture de l'Environnement Virtuel (PROXMOX)

### Configuration Réseau Globale

| Paramètre | Valeur |
| :--- | :--- |
| **Réseau** | `172.16.30.0/24` |
| **Masque de sous-réseau** | `255.255.255.0` |
| **Broadcast (Diffusion)** | `172.16.30.255` |
| **Passerelle (Gateway)** | `172.16.30.254`  |
| **Serveur DNS** | `8.8.8.8` |

## Inventaire des Machines Virtuelles

### Pôle Serveurs

| OS | Nom d'hôte | Adresse IP | Comptes Utilisateurs Requis |
| :--- | :--- | :--- | :--- |
| **Debian** | `srvlx01` | `172.16.30.10` | <ul><li>`root` (Administrateur système)</li><li>`wilder` (Utilisateur standard)</li></ul> |
| **Windows Server 2022** | `srvwin01` | `172.16.30.5` | <ul><li>`Administrator` (Administrateur local/domaine)</li><li>`wilder` (Utilisateur standard)</li></ul> |

### Pôle Clients

| OS | Nom d'hôte | Adresse IP | Comptes Utilisateurs Requis |
| :--- | :--- | :--- | :--- |
| **Linux** | `clilin01` | `172.16.30.30` | <ul><li>`wilder`</li></ul> |
| **Windows 10** | `cliwin01` | `172.16.30.20` | <ul><li>`wilder`</li></ul> |

# 2. Configuration sur le serveur Debian (Debian 13)

## Configuration de l'interface réseau

**Allez voir votre configuration de carte réseau**

``` bash
ip adds show
```
![Screen Snap](Ressources/SCREENSHOT/Config_Debian_SERV/Config_Reseau/DEB_IP_adress_show.png).

Comme vous pouvez le voir l'adresse ip existante n'est pas celle souhaité.

**Ajoutez la nouvelle adresse ip a la carte réseau**

``` bash
ip addr add 172.16.30.10/24 dev enp0s8
```
![Screen Snap](Ressources/SCREENSHOT/Config_Debian_SERV/Config_Reseau/DEB_IP_adress_add_.png)

**Si vous n'avez pas de carte réseau configuré ouvrez le fichier d'interface réseau**

``` bash
nano /etc/network/interface
```

**Une fois dans le fichier interface ajouter votre carte réseau ainsi que les informations souhaité**

``` bash
ip addr add 172.16.30.10/24 dev enp0s8
```

![Screen Snap](Ressources/SCREENSHOT/Config_Debian_SERV/Config_Reseau/DEB_new_network_interface.png)

### Mettez a jour votre service de gestion reseau
**Pour ce faire vous pouvez soit : Relancer le service de gestion du reseau puis activer la configuration du réseau en deux commandes distinctes**
``` bash
systemctl restart networking.service
```
``` bash
ifup enp0s8
```
![Screen Snap](Ressources/SCREENSHOT/Config_Debian_SERV/Config_Reseau/DEB_restart_network.png)
![Screen Snap](Ressources/SCREENSHOT/Config_Debian_SERV/Config_Reseau/DEB_activate_network.png)

**Soit faire les deux actions en une seule commande**(recommandé)

``` bash
systemctl restart networking.service;ifup enp0s8
```
![Screen Snap](Ressources/SCREENSHOT/Config_Debian_SERV/Config_Reseau/DEB_restart_network+ifup.png)

**Verifier si votre carte réseau est désormais active, votre adresse IP et votre masque de sous-réseau sont bien configuré **
``` bash
ip addr show
```
![Screen Snap]()

**Vous pouvez tester la confiuration avec un ping vers une autre machine sur le meme réseau** (exemple avec la machine ubuntu préalablement configuré)

``` bash
ping -c 4 172.16.30.30
```
![Screen Snap](Ressources/SCREENSHOT/Config_Debian_SERV/Config_Reseau/DEB_IP_adress_show2.png)
**Et voila comme vous pouvez le constaté la création ainsi que la configuration de votre carte réseau est bien effectué ! **


## Configuration de l'interconnaxion SSH avec le client windows

## Configuration de l'interconnaxion SSH avec le client ubuntu

**Commencer par installer openssh-server**

``` bash
sudo apt install openssh-server
```

![Screen Snap](Ressources/SCREENSHOT/Config_Debian_SERV/Config_SSH_DEBSERV_UBU/DEB_SSH_install.png)

**Permet de configurer le service SSH pour qu'il démarre automatiquement chaque fois que le système d'exploitation est redémarré** 

``` bash
sudo systemctl enable ssh
```

![Screen Snap](Ressources/SCREENSHOT/Config_Debian_SERV/Config_SSH_DEBSERV_UBU/DEB_systemctl_enable_SSH.png)

**Vérifier le status de la configuration ssh** 

``` bash
sudo systemctl status ssh
```

![Screen Snap](Ressources/SCREENSHOT/Config_Debian_SERV/Config_SSH_DEBSERV_UBU/DEB_systemctl_status.png)

**Tester si le port 22 est bien ouvert**

``` bash
ss -tnlp | grep :22
```
![Screen Snap](Ressources/SCREENSHOT/Config_Debian_SERV/Config_SSH_DEBSERV_UBU/DEB_test_port_22.png)

**Et voilà l’interconnexion sécurisé via OpenSSH entre vos deux machines est desormais possible vous trouverez la suite de la configuration sur la machine ubuntu.**

# 3. Configuration sur le serveur Windows (Windows serveur 2022)


# 4. Configuration sur le client Linux (Ubuntu 24.04 LTS)
## Configuration de la carte réseau


## Configuration de l'interconnaxion SSH avec le serveur Windows 


## Configuration de l'interconnaxion SSH avec le serveur Debian

**Commencer par installer openssh-server**

``` bash
sudo apt install openssh-server
```

![Screen Snap](Ressources/SCREENSHOT/Config_Ubuntu/Config_Ssh_UBU_DEBSERV/UBU_installSSH_server.png)

**Verifier si openssh est bien installer en tapant la commande suivante**  
``` bash
sudo systemctl status ssh
```

![Screen Snap](Ressources/SCREENSHOT/Config_Ubuntu/Config_Ssh_UBU_DEBSERV/UBU_systemctl_status.png)
Comme vous pouvez le voir le service ssh est bien installer mais il ne demarrera pas automatiquement a chaque demarrage de votre machine.

**Configuration du service SSH pour démarrage automatique** 

``` bash
sudo systemctl enable ssh
```

![Screen Snap](Ressources/SCREENSHOT/Config_Ubuntu/Config_Ssh_UBU_DEBSERV/UBU_systemctl_enable.png)

**Revérifier le status de la configuration ssh** 

``` bash
sudo systemctl status ssh
```

![Screen Snap](Ressources/SCREENSHOT/Config_Ubuntu/Config_Ssh_UBU_DEBSERV/UBU_systemctl_status_enable.png)
Ca y est maintenant a chaque redemarrage de votre machine vous n'aurais pas a réactiver votre service ssh, il se lancer automatiquement.

**Créer une cle ssh pour la connection securisé entre notre machine et notre serveur** 

``` bash
ssh-keygen 
```  
ou
``` bash
ssh-keygen -t ed25519
```

![Screen Snap](Ressources/SCREENSHOT/Config_Ubuntu/Config_Ssh_UBU_DEBSERV/UBU_SSH_creation_keygen.png)

**Vous trouverez la clé publique à l’aide de cette commande** (.pub correspond a la clé public)  

``` bash
cat ~/.ssh/id_ed25519.pub
```

![Screen Snap](Ressources/SCREENSHOT/Config_Ubuntu/Config_Ssh_UBU_DEBSERV/UBU_command_check_ssh_pub.png)

**Une fois la clé SSH crée, copiez la vers le serveur voulu avec ssh-copy-id** (confirmation de connexion) 

``` bash
ssh-copy-id -i ~/.ssh/id_ed25519.pub wilder@172.16.30.10
```

![Screen Snap](Ressources/SCREENSHOT/Config_Ubuntu/Config_Ssh_UBU_DEBSERV/UBU_SSH_copy_id.png)
Comme vous pouvez le constater on vous pose une question avant de passer a la suite repondez yes si vous souhaité continuer la copie si les informations renseignés sont bonnes.

**Entrez le mot de passe de votre serveur Debian** 

``` bash
# wilder@172.16.30.10's password: "Votre mot de passe"
```

![Screen Snap](Ressources/SCREENSHOT/Config_Ubuntu/Config_Ssh_UBU_DEBSERV/UBU_password_copy_id.png)

**Et voilà la clé publique est enregistrée sur votre machine client**

![Screen Snap](Ressources/SCREENSHOT/Config_Ubuntu/Config_Ssh_UBU_DEBSERV/UBU_copy_id_success.png)

**Pour éviter de retaper votre passphrase à chaque connexion vous pouvez activer l’agent SSH sur le client avec ssh-add ~/votre_chemin puis entrez un mot de passe ou pas pour sécuriser votre connexion** 

``` bash
ssh-add ~/.ssh/id_ed25519
```

![Screen Snap](Ressources/SCREENSHOT/Config_Ubuntu/Config_Ssh_UBU_DEBSERV/UBU_ssh_add.png)

Et voilà l’interconnexion sécurisé via OpenSSH entre vos deux machines est desormais établie. 


# 5. Configuration sur le client windows (Windows 10)


# 6. FAQ


