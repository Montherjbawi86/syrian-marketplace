#!/bin/bash
DATE=$(date +%Y%m%d-%H%M%S)
BACKUP_DIR=~/Desktop/marketplace-backups/$DATE
mkdir -p $BACKUP_DIR

# Backup database
pg_dump -U postgres syrian_marketplace_development > $BACKUP_DIR/database.sql

# Backup code (excluding unnecessary files)
rsync -av --exclude='tmp' --exclude='log' --exclude='storage' --exclude='node_modules' \
  /Users/montheralgbawi/Desktop/syrian-marketplace/ $BACKUP_DIR/code/

# Create zip of everything
cd ~/Desktop/marketplace-backups
zip -r syrian-marketplace-$DATE.zip $DATE/

echo "✅ Full backup created: ~/Desktop/marketplace-backups/syrian-marketplace-$DATE.zip"
