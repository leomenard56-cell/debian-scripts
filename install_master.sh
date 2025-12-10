#!/bin/bash

# ==========================================================
# Script d'Installation MASTER : Configuration et Webmin
# Ce script doit être exécuté en tant que root.
# ==========================================================

# ----------------- 0. VÉRIFICATION ----------------------
if [ "$(id -u)" != "0" ]; then
   echo "ERREUR : Ce script doit être exécuté en tant que root. Veuillez utiliser 'su -' ou 'sudo'." 1>&2
   exit 1
fi

echo "--- Démarrage de l'installation MASTER ---"

# ----------------- 1. CONFIGURATION RÉSEAU STATIQUE ----------------------
# Basé sur votre configuration : IP 192.168.1.50, Gateway 1.254, DNS 8.8.8.8
echo "--- 1. Configuration de l'interface ens33 en IP Statique (192.168.1.50) ---"
cat > /etc/network/interfaces << EOF
# /etc/network/interfaces - Configuration automatique par script MASTER

source /etc/network/interfaces.d/*

# The loopback network interface
auto lo
iface lo inet loopback

# The primary network interface (ens33)
auto ens33
iface ens33 inet static
    address 192.168.1.50/24
    gateway 192.168.1.254
    dns-nameservers 192.168.1.254 8.8.8.8
EOF

echo "--- Redémarrage des services réseau (pour appliquer la configuration) ---"
systemctl restart networking
sleep 5 # Attendre que le réseau se stabilise

# S'assurer que les DNS sont pris en compte immédiatement
echo "nameserver 192.168.1.254" > /etc/resolv.conf
echo "nameserver 8.8.8.8" >> /etc/resolv.conf

# ----------------- 2. MISE À JOUR DU SYSTÈME ----------------------
echo "--- 2. Mise à jour de la liste des paquets et upgrade complet ---"
apt update
apt upgrade -y

# ----------------- 3. INSTALLATION WEBMIN ----------------------
echo "--- 3. Ajout du dépôt Webmin et Installation ---"
# Téléchargement et exécution du script de configuration du dépôt Webmin
curl -o /tmp/webmin-setup-repo.sh https://raw.githubusercontent.com/webmin/webmin/master/webmin-setup-repo.sh

# Exécution pour ajouter la clé et le dépôt
sh /tmp/webmin-setup-repo.sh

# Nouvelle mise à jour pour inclure le dépôt Webmin
apt update

# Installation de Webmin
apt install -y webmin

# ----------------- 4. NETTOYAGE ET FIN ----------------------
echo "--- 4. Nettoyage ---"
rm /tmp/webmin-setup-repo.sh
echo "=========================================================="
echo "✅ INSTALLATION MASTER TERMINEE !"
echo "Le réseau est configuré en IP Statique : 192.168.1.50"
echo "Webmin est accessible : https://192.168.1.50:10000"
echo "=========================================================="
