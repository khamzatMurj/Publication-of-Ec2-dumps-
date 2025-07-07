#!/bin/bash

set -e

# Récupérer l'ID unique (hostname dans cet exemple, adaptable)
INSTANCE_ID=$(hostname)

echo "Instance ID détecté : $INSTANCE_ID"

# Configurer rclone
mkdir -p /root/.config/rclone
cat <<EOF > /root/.config/rclone/rclone.conf
[gdrive-service-d]
type = drive
scope = drive
service_account_file = /root/sa.json
root_folder_id = 1Mevb5rac38x4ZxuS3yAhcK2dh0-IHtoS
EOF

echo "Configuration Rclone terminée."

# Créer le dossier distant si nécessaire
rclone mkdir gdrive-service-d:instances/$INSTANCE_ID/data || true

echo "Dossier distant prêt."

# Synchronisation régulière des fichiers locaux vers le Drive
while true; do
    echo "Synchronisation en cours..."
    rclone sync /data gdrive-service-d:instances/$INSTANCE_ID/data
    echo "Synchronisation terminée. Prochaine tentative dans 5 minutes."
    sleep 300
done

