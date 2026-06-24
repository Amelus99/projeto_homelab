#!/bin/bash
cd /home/sam/homelab
git fetch
LOCAL=$(git rev-parse main)
REMOTE=$(git rev-parse origin/main)

if [ "$LOCAL" != "$REMOTE" ]; then
    echo "$(date): Mudança detectada! Atualizando..." >> esteira.log
    git pull
    docker compose up -d --remove-orphans
    echo "$(date): Deploy concluído." >> esteira.log
else
    # Opcional: remover este echo para não encher o log à toa
    echo "$(date): Nenhuma mudança." >> esteira.log
fi
