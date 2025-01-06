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

# Vérifier si l'URL est valide
if [[ ! "$site_url" =~ ^https?:// ]]; then
    echo "L'URL doit commencer par http:// ou https://."
    exit 1
fi

# Question initiale - tout accepter par défaut ?
read -p "Voulez-vous accepter toutes les options par défaut (y/n) ? " default_all

# Initialisation des options
destination_dir="."
recursive_option="--recursive"
no_clobber="--no-clobber"
domain_option=""

if [[ $default_all == "n" ]]; then
    # Demander le répertoire cible
    read -p "Voulez-vous télécharger dans le dossier actuel (y/n) ? " current_dir
    if [[ $current_dir == "n" ]]; then
        read -p "Entrez le chemin du répertoire de destination : " destination_dir
        mkdir -p "$destination_dir"
    fi

    # Demander si on télécharge aussi les sous-dossiers
    read -p "Voulez-vous télécharger aussi les sous-dossiers (y/n) ? " recursive_download
    if [[ $recursive_download == "n" ]]; then
        recursive_option=""
    fi

    # Demander si on vérifie les fichiers déjà téléchargés
    read -p "Voulez-vous éviter de retélécharger les fichiers déjà téléchargés (y/n) ? " check_existing
    if [[ $check_existing == "n" ]]; then
        no_clobber=""
    fi

    # Demander s'il faut limiter le téléchargement au domaine spécifié
    read -p "Voulez-vous limiter le téléchargement au domaine spécifié (y/n) ? " limit_domain
    if [[ $limit_domain == "y" ]]; then
        domain_option="--domains=$(echo $site_url | awk -F[/:] '{print $4}')"
    fi
fi

# Exécuter la commande wget
wget_command="wget $recursive_option $no_clobber $domain_option --directory-prefix=\"$destination_dir\" --convert-links --adjust-extension --page-requisites --no-parent $site_url"
echo "Exécution de la commande : $wget_command"
eval $wget_command

# Vérifier si le téléchargement a réussi
if [[ $? -eq 0 ]]; then
    echo "Téléchargement terminé avec succès dans le dossier : $destination_dir"
else
    echo "Une erreur est survenue lors du téléchargement."
fi

