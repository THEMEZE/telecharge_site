#!/bin/bash

url=$1
destination=$2
recursive_flag=$3
no_clobber_flag=$4
domain=$5

echo "Installation/mise à jour de wget..."
brew install wget

destination_option=""
if [ -n "$destination" ]; then
  destination_option="--directory-prefix=$destination"
fi

recursive=""
if [[ $recursive_flag == "y" || $recursive_flag == "Y" ]]; then
  recursive="--recursive"
fi

no_clobber=""
if [[ $no_clobber_flag == "y" || $no_clobber_flag == "Y" ]]; then
  no_clobber="--no-clobber"
fi

wget_options="--page-requisites --html-extension --convert-links --restrict-file-names=windows"
if [[ -n "$domain" ]]; then
  wget_options="$wget_options --domains $domain"
fi
wget_options="$wget_options --no-parent"

wget_command="wget $destination_option $recursive $no_clobber $wget_options $url"
echo "Exécution de la commande :"
echo $wget_command
eval $wget_command

echo "Téléchargement terminé."
