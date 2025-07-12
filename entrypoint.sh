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

# Créer le dossier logs s'il n'existe pas
mkdir -p /logs

logs() {
    echo "$(date) - $1" | tee -a /logs/logs.txt
}

notify_admin() {
    logs "ERREUR: $1"
}

echo "Configuration Rclone terminée."

# Créer le dossier distant si nécessaire
rclone mkdir gdrive-service-d:instances/$INSTANCE_ID/data || true

echo "Dossier distant prêt."

# Synchronisation régulière des fichiers locaux vers le Drive
while true; do
    echo "Synchronisation en cours..."
    rclone move -P -v /data gdrive-service-d:instances/$INSTANCE_ID/data --delete-empty-src-dirs >> /logs/logs_transfert.txt 2>&1
    echo "Synchronisation terminée. Prochaine tentative dans 30 secondes."
    sleep 30
done
