#!/bin/bash

# ==========================================================
# Script d'installation Webmin sur Debian
# Ce script doit être exécuté en tant que root après le téléchargement.
# ==========================================================

# Vérification si l'utilisateur est root (UID 0)
if [ "$(id -u)" != "0" ]; then
   echo "ERREUR : Ce script doit être exécuté en tant que root. Veuillez utiliser 'su -' puis lancer le script." 1>&2
   exit 1
fi

echo "--- 1. Ajout du dépôt Webmin ---"
# Téléchargement du script officiel de setup du dépôt
curl -o /tmp/webmin-setup-repo.sh https://raw.githubusercontent.com/webmin/webmin/master/webmin-setup-repo.sh

# Exécution pour ajouter la clé et le dépôt
sh /tmp/webmin-setup-repo.sh

echo "--- 2. Mise à jour de la liste des paquets ---"
apt update

echo "--- 3. Installation de Webmin ---"
# Utilisation de -y pour accepter automatiquement l'installation
apt install -y webmin

echo "--- 4. Nettoyage ---"
rm /tmp/webmin-setup-repo.sh

echo "=========================================================="
echo "✅ INSTALLATION WEBMIN TERMINEE !"
echo "Accès : https://192.168.1.50:10000"
echo "=========================================================="
