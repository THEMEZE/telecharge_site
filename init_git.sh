#!/bin/bash

# Configurer le nom de la branche par défaut pour tous les nouveaux dépôts (facultatif)
git config --global init.defaultBranch main

# Naviguer vers le répertoire créé par le script
#cd /chemin/vers/le/repertoire/quantum-mechanics-thesis || { echo "Directory not found"; exit 1; }

# Initialiser un dépôt Git local (si ce n'est pas déjà fait)
if [ ! -d ".git" ]; then
    git init
fi

# Ajouter le dépôt GitHub comme remote, ignorer si déjà ajouté
git remote get-url origin &>/dev/null || git remote add origin git@github.com:THEMEZE/telecharge_site.git

# Récupérer les changements du dépôt distant (pour éviter les conflits)
git pull origin main --allow-unrelated-histories

# Si la branche main n'existe pas encore, créer la branche main et se positionner dessus
if ! git rev-parse --verify main; then
    git checkout -b main
else
    git checkout main
fi

# Ajouter tous les fichiers au dépôt local
git add .

# Faire un commit initial
git commit -m "Initial commit with project structure"

# Pousser les fichiers vers GitHub
git push -u origin main
