# 🚀 Installation MASTER V3 : Déploiement Complet de Serveur Debian

Ce script permet de transformer une **installation minimale de Debian** en un serveur de base sécurisé et prêt à l'emploi.

Il configure le réseau en IP statique, installe un ensemble complet d'outils d'administration et de développement (`git`, `ssh`, `samba`, etc.), ajoute l'interface d'administration Webmin, et active le pare-feu UFW.

## ⚙️ Configuration Automatique Appliquée

| Paramètre | Valeur Configurée | Détails |
| :--- | :--- | :--- |
| **Adresse IP** | `192.168.1.50/24` | IP Statique pour l'interface `ens33`. **(À changer sur les clones)** |
| **Passerelle** | `192.168.1.254` | Passé à votre routeur. |
| **DNS** | `192.168.1.254` et `8.8.8.8` | Serveurs DNS primaires et secondaires. |
| **Pare-feu** | UFW (Activé) | Bloque tout sauf les ports 22 (SSH) et 10000 (Webmin). |

## 🛠️ Les Deux Commandes de Déploiement

Cette séquence doit être exécutée sur une **nouvelle VM Debian minimale**.

### Commande 1 : Téléchargement du Script (en tant que votre utilisateur standard, ex: `leo`)

```bash
curl -o install_master.sh [https://raw.githubusercontent.com/leomenard56-cell/debian-scripts/master/install_master.sh](https://raw.githubusercontent.com/leomenard56-cell/debian-scripts/master/install_master.sh)

Commande 2 : Exécution de l'Installation de Zéro (en tant que root)


su -
chmod +x /home/leo/install_master.sh
/home/leo/install_master.sh

💾 Gestion du Modèle VM (Workflow Recommandé)

    Éteignez la VM (shutdown now).

    Clonez-la (créez un Clone Complet).

    Renommez le Clone pour votre projet (Ex: Serveur-Web-Projet-X).

    Changez l'adresse IP (/etc/network/interfaces) du nouveau clone pour qu'elle soit unique (Ex: .51, .52, etc.) avant de le démarrer.


### ⏭️ Prochaine Étape

1.  **Copiez ce code** et créez le fichier `README.md` dans Visual Studio Code.
2.  **Sauvegardez-le** dans le répertoire local de votre dépôt Git (`/home/leo/debian-scripts` sur votre VM, si vous utilisez VS Code via SSH).
3.  **Poussez-le sur GitHub** avec les commandes :

```bash
git add README.md
git commit -m "Ajout du fichier README.md de documentation pour le script MASTER V3"
git push origin master
