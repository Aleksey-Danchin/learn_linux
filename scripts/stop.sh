#!/usr/bin/env bash
# clean_containers.sh — удалить все контейнеры, созданные из образа ubuntu-linux-course:25.04

set -e

IMAGE_NAME="ubuntu-linux-course:25.04"

# Получаем список ID контейнеров этого образа
CONTAINERS=$(docker ps -a --filter "ancestor=$IMAGE_NAME" --format "{{.ID}}")

if [[ -z "$CONTAINERS" ]]; then
    echo "[INFO] Нет контейнеров, созданных из образа $IMAGE_NAME."
    exit 0
fi

echo "[INFO] Удаляем контейнеры образа $IMAGE_NAME..."
docker rm -f $CONTAINERS

echo "[INFO] Готово. Все контейнеры удалены."
