#!/bin/bash

# Télécharge ou met à jour wget
echo "Installation/mise à jour de wget..."
brew install wget

# Demande l'adresse à télécharger
read -p "Entrez l'adresse à télécharger: " url

# Demande le répertoire de destination
read -p "Entrez le chemin du répertoire de destination (laissez vide pour utiliser le répertoire actuel): " destination
destination_option=""
if [ -n "$destination" ]; then
  destination_option="--directory-prefix=$destination"
fi

# Demande si le téléchargement doit être récursif
read -p "Téléchargement récursif (y/n)?: " recursive
if [[ $recursive == "y" || $recursive == "Y" ]]; then
  recursive="--recursive"
else
  recursive=""
fi

# Demande si éviter de télécharger les fichiers déjà présents
read -p "Éviter de télécharger les fichiers déjà présents (y/n)?: " noClobber
if [[ $noClobber == "y" || $noClobber == "Y" ]]; then
  noClobber="--no-clobber"
else
  noClobber=""
fi

# Options wget
wget_options="--page-requisites --html-extension --convert-links --restrict-file-names=windows"

# Limite les téléchargements aux domaines spécifiés
read -p "Limite les téléchargements aux domaines spécifiés (entrez le domaine): " domain
if [[ -n "$domain" ]]; then
  wget_options="$wget_options --domains $domain"
fi

# Navigue uniquement dans les sous-répertoires, pas les répertoires parent
wget_options="$wget_options --no-parent"

# Exécute la commande wget
wget_command="wget $destination_option $recursive $noClobber $wget_options $url"
echo "Exécution de la commande :"
echo $wget_command
eval $wget_command

echo "Téléchargement terminé."
