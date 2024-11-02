#!/bin/bash

# Vérifier si wget est installé
if ! command -v wget &> /dev/null; then
    echo "wget n'est pas installé. Installation via Homebrew..."

    # Vérifier si Homebrew est installé
    if ! command -v brew &> /dev/null; then
        echo "Homebrew n'est pas installé. Veuillez installer Homebrew pour continuer : https://brew.sh/"
        exit 1
    fi

    # Installer wget avec Homebrew
    brew install wget

    if [[ $? -ne 0 ]]; then
        echo "Erreur lors de l'installation de wget."
        exit 1
    fi

    echo "wget installé avec succès."
else
    echo "wget est déjà installé."
fi

# Demander l'URL du site
read -p "Entrez l'URL du site à télécharger : " site_url

# Question initiale - tout accepter par défaut ?
read -p "Voulez-vous accepter toutes les options par défaut (y/n) ? " default_all

# Si l'utilisateur choisit "oui", on active tout par défaut
if [[ $default_all == "y" ]]; then
    # Télécharger dans le dossier actuel
    destination_dir="."
    echo "Téléchargement dans le dossier actuel."

    # Activer le téléchargement récursif
    recursive_option="--recursive"
    echo "Téléchargement récursif activé."

    # Ne pas retélécharger les fichiers déjà présents
    no_clobber="--no-clobber"
    echo "Éviter de retélécharger les fichiers déjà téléchargés."

    # Ne pas limiter le téléchargement au domaine spécifié (on télécharge tout)
    domain_option=""
    echo "Aucune limite de domaine. Tous les liens seront téléchargés."

# Si l'utilisateur choisit "non", on pose les questions une par une
else
    # Demander le répertoire cible
    read -p "Voulez-vous télécharger dans le dossier actuel (y/n) ? " current_dir
    if [[ $current_dir == "n" ]]; then
        read -p "Entrez le chemin du répertoire de destination : " destination_dir
        mkdir -p "$destination_dir"
    else
        destination_dir="."
    fi

    # Demander si on télécharge aussi les sous-dossiers
    read -p "Voulez-vous télécharger aussi les sous-dossiers (y/n) ? " recursive_download
    if [[ $recursive_download == "y" ]]; then
        recursive_option="--recursive"
    else
        recursive_option=""
    fi

    # Demander si on vérifie les fichiers déjà téléchargés
    read -p "Voulez-vous éviter de retélécharger les fichiers déjà téléchargés (y/n) ? " check_existing
    if [[ $check_existing == "y" ]]; then
        no_clobber="--no-clobber"
    else
        no_clobber=""
    fi

    # Demander s'il faut limiter le téléchargement au domaine spécifié
    read -p "Voulez-vous limiter le téléchargement au domaine spécifié (y/n) ? " limit_domain
    if [[ $limit_domain == "y" ]]; then
        domain_option="--domains=$(echo $site_url | awk -F[/:] '{print $4}')"
    else
        domain_option=""
    fi
fi

# Exécuter la commande wget
wget_command="wget $recursive_option $no_clobber $domain_option --directory-prefix=$destination_dir $site_url"
echo "Exécution de la commande : $wget_command"
eval $wget_command

echo "Téléchargement terminé."
