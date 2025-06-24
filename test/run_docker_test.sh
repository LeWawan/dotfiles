#!/usr/bin/env bash
set -euo pipefail

# Répertoire du script à exécuter
SCRIPTS_DIR="../bin/core/deps-scripts/"

# Nom du script à exécuter, passé en argument
SCRIPT_NAME="${1:-}"

if [[ -z "$SCRIPT_NAME" ]]; then
  echo "❌ Utilisation : $0 nom_du_script.sh"
  echo "📂 Les scripts doivent être dans : $SCRIPTS_DIR"
  exit 1
fi

if [[ ! -f "$SCRIPTS_DIR/$SCRIPT_NAME" ]]; then
  echo "❌ Le script $SCRIPT_NAME n'existe pas dans $SCRIPTS_DIR"
  exit 1
fi

# Nom de l'image Docker
IMAGE_NAME="neovim-deps-tester"

# Construire l'image Docker si elle n'existe pas
if [[ -z "$(docker images -q $IMAGE_NAME)" ]]; then
  echo "📦 Construction de l'image Docker $IMAGE_NAME..."
  docker build -t $IMAGE_NAME .
fi

# Lancer le conteneur avec montage du dossier scripts
echo "🚀 Test du script : $SCRIPT_NAME"

docker run --rm -it \
  -v "$(realpath $SCRIPTS_DIR)":/home/tester/scripts \
  $IMAGE_NAME \
  bash -c "cd /home/tester/scripts && chmod +x $SCRIPT_NAME && ./$SCRIPT_NAME"
