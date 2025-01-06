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

# Demander l'URL du site à télécharger
read -p "Entrez l'URL du site à télécharger : " site_url

# Vérifier si l'URL est valide
if [[ ! "$site_url" =~ ^https?:// ]]; then
    echo "L'URL doit commencer par http:// ou https://."
    exit 1
fi

# Demander si l'utilisateur souhaite utiliser les options par défaut
read -p "Voulez-vous accepter toutes les options par défaut (y/n) ? " default_all

# Initialisation des options
destination_dir="./site_download"
recursive_option="--mirror"
convert_links="--convert-links"
adjust_extension="--adjust-extension"
page_requisites="--page-requisites"
no_parent="--no-parent"
domain_option=""

if [[ $default_all == "n" ]]; then
    # Demander le répertoire cible
    read -p "Entrez le chemin du répertoire de destination (par défaut : ./site_download) : " user_dir
    if [[ -n "$user_dir" ]]; then
        destination_dir="$user_dir"
    fi
    mkdir -p "$destination_dir"

    # Demander s'il faut limiter le téléchargement au domaine spécifié
    read -p "Voulez-vous limiter le téléchargement au domaine spécifié (y/n) ? " limit_domain
    if [[ $limit_domain == "y" ]]; then
        domain_option="--domains=$(echo $site_url | awk -F[/:] '{print $4}')"
    fi
fi

# Construire la commande wget
wget_command="wget $recursive_option $convert_links $adjust_extension $page_requisites $no_parent $domain_option --directory-prefix=\"$destination_dir\" \"$site_url\""

# Exécuter la commande wget
echo "Exécution de la commande : $wget_command"
eval $wget_command

# Vérifier si le téléchargement a réussi
if [[ $? -eq 0 ]]; then
    echo "Le site a été téléchargé avec succès dans le dossier : $destination_dir"
else
    echo "Une erreur est survenue lors du téléchargement."
fi

