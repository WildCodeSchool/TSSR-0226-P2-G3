# **Projet 2 : The Scripting Project**
## Sommaire
- [1. Le projet](#1-le-projet)
- [2. Introduction et mise en contexte](#2-introduction-et-mise-en-contexte)
- [3. Membres et rôles du groupe de projet (Groupe 3)](#3-membres-et-rôles-du-groupe-de-projet-groupe-3)
- [4. Choix Techniques et Infrastructure](#4-choix-techniques-et-infrastructure)
  - [Serveurs d'administration](#serveurs-dadministration)
  - [Machines Clientes cibles](#machines-clientes-cibles)
- [5. Difficultés rencontrées](#5-difficultés-rencontrées)
- [6. Solutions trouvées](#6-solutions-trouvées)
- [7. Améliorations possibles](#7-améliorations-possibles)
---
## 1. Le projet

Ce projet consiste à créer un outil d'administration centralisée multi-plateforme. Il est composé de deux scripts principaux : l'un développé en Bash et l'autre en PowerShell. Ces scripts interagissent avec des machines distantes situées sur le même réseau.

**Objectifs finaux de l'outil :**
* Gérer des utilisateurs à distance (création, modification, etc.).
* Administrer des postes clients (redémarrage, gestion de répertoires, etc.).
* Interroger le statut des machines (IP, OS, espace disque, etc.).
* Créer et rechercher des informations dans des journaux d'événements (logs).
* Automatiser des opérations ciblées via une interface ergonomique (menus interactifs).

---
## 2. Introduction et mise en contexte

* Mise en place d'une architecture client/serveur hétérogène (Windows et Linux).
* Création et gestion experte de scripts Bash et PowerShell.
* Travail collaboratif utilisant la méthode Agile (Sprints, Daily) et gestion des versions via Git.
* Déploiement d'une infrastructure virtualisée sur un hyperviseur Proxmox.

---
## 3. Membres et rôles du groupe de projet (Groupe 3)
Notre équipe applique la méthode Scrum avec des rôles tournants à chaque sprint. Le Product Owner (PO) fait le lien avec le client/formateur, tandis que le Scrum Master (SM) garantit la bonne application de la méthode.

<div align="center">
  
| Membre de l'équipe | Rôle Sprint 1 | Rôle Sprint 2 | Rôle Sprint 3 | Rôle Sprint 4 |
| :--- | :--- | :--- | :--- | :--- |
| **Alexandre** | Scrum Master | Product Owner | Technicien | *(à définir)* |
| **Anass** | Product Owner | Technicien | Scrum Master | *(à définir)* |
| **Camille** | Technicien | Technicien | Product Owner | *(à définir)* |
| **Jeremy** | Technicien | Scrum Master | Technicien | *(à définir)* |

</div>

---

## 4. Choix Techniques et Infrastructure
Toutes nos machines virtuelles sont hébergées sur le nœud de travail Proxmox distant. Conformément à la nomenclature, l'ID de nos VM est compris dans la plage **301 à 398** et leur nom commence par le préfixe **G3-**.

L'infrastructure réseau du Groupe 3 repose sur le sous-réseau **172.16.30.0/24** avec un masque en `255.255.255.0` et un serveur DNS pointant sur `8.8.8.8`.

### Serveurs d'administration

<div align="center">
  
| Rôle | Nom VM | OS | Langue | IP | Compte Admin | Mot de passe |
| :--- | :--- | :--- | :--- | :--- | :--- | :--- |
| **Serveur Linux** | `SRVLX01` | Debian 13 (CLI) | US | 172.16.30.10 | `root` / `wilder` (sudo) | Azerty1* |
| **Serveur Windows** | `SRVWIN01` | Win Server 2022 (GUI) | US | 172.16.30.5 | `Administrator` / `Wilder` (admin) | Azerty1* |

### Machines Clientes cibles
| Rôle | Nom VM | OS | Langue | IP | Compte Utilisateur | Mot de passe |
| :--- | :--- | :--- | :--- | :--- | :--- | :--- |
| **Client Linux** | `CLILIN01` | Ubuntu 24 LTS | FR | 172.16.30.30 | `wilder` (sudo) | Azerty1* |
| **Client Windows** | `CLIWIN01` | Windows 11 | FR | 172.16.30.20 | `Wilder` (admin local) | Azerty1* |
</div>


*Passerelle par défaut (@IP DG) : 172.16.30.254*

---
## 5. Difficultés rencontrées 

- 

---
## 6. Solutions trouvées 

-

---
## 7. Améliorations possibles

-

---
