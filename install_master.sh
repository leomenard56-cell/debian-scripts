#!/bin/bash
# ==========================================================
# Script d'Installation MASTER V3 - TOUT-EN-UN
# Config réseau, Outils de Dev/Admin, Webmin, et Pare-feu UFW
# ==========================================================

# ----------------- 0. VÉRIFICATION ----------------------
if [ "$(id -u)" != "0" ]; then
    echo "ERREUR : Ce script doit être exécuté en tant que root."
    echo "Utilise : su - ou sudo ./script.sh"
    exit 1
fi

clear
echo "--- Démarrage de l'installation MASTER V3 (avec Sécurité) ---"

# ----------------- 1. CONFIGURATION RÉSEAU STATIQUE ----------------------
echo "--- 1. Configuration réseau (IP statique 192.168.1.50) ---"

cat > /etc/network/interfaces << EOF
source /etc/network/interfaces.d/*

auto lo
iface lo inet loopback

auto ens33
iface ens33 inet static
    address 192.168.1.50/24
    gateway 192.168.1.254
    dns-nameservers 192.168.1.254 8.8.8.8
EOF

systemctl restart networking
sleep 5

echo "nameserver 192.168.1.254" > /etc/resolv.conf
echo "nameserver 8.8.8.8" >> /etc/resolv.conf

# ----------------- 2. MISE À JOUR & INSTALLATION DES PAQUETS DE BASE ----------------------
echo "--- 2. Mise à jour et installation des outils de base ---"

apt update && apt upgrade -y

# Consolidation des installations pour la rapidité et la propreté:
apt install -y \
    ssh \
    zip \
    nmap \
    locate \
    ncdu \
    curl \
    git \
    screen \
    dnsutils \
    net-tools \
    sudo \
    lynx \
    bsdgames \
    winbind \
    samba \
    ufw       # Ajout essentiel du Pare-feu

updatedb # Nécessaire après l'installation de 'locate'

# ----------------- 3. INSTALLATION WEBMIN ----------------------
echo "--- 3. Ajout du dépôt Webmin et Installation ---"

# Téléchargement vers /tmp pour la fiabilité
curl -o /tmp/webmin-setup-repo.sh https://raw.githubusercontent.com/webmin/webmin/master/webmin-setup-repo.sh

# Exécution du script de configuration du dépôt
echo "y" | sh /tmp/webmin-setup-repo.sh > /dev/null

apt update
apt install webmin --install-recommends -y

# ----------------- 4. SÉCURITÉ CRITIQUE : CONFIGURATION UFW ----------------------
echo "--- 4. Configuration et Activation du Pare-feu UFW ---"

# Règles par défaut: tout bloquer en entrée, tout autoriser en sortie
ufw default deny incoming
ufw default allow outgoing

# Autorisation des ports essentiels
ufw allow 22/tcp comment 'SSH'
ufw allow 10000/tcp comment 'Webmin'

# Activation du pare-feu
echo "y" | ufw enable
ufw status verbose

# ----------------- 5. NETTOYAGE ET FIN ----------------------
echo "--- 5. Nettoyage et Finalisation ---"
rm /tmp/webmin-setup-repo.sh

echo "=========================================================="
echo "✅ INSTALLATION MASTER V3 TERMINÉE !"
echo "IP      : 192.168.1.50"
echo "Webmin  : https://192.168.1.50:10000"
echo "ATTENTION : Le Pare-feu UFW est ACTIF (Seuls 22 et 10000 sont ouverts)."
echo "=========================================================="

reboot
