#!/usr/bin/env bash
# build_image.sh — скрипт для сборки и запуска учебного образа Ubuntu 25.04 с Dockerfile в текущей директории

set -e

IMAGE_NAME="ubuntu-linux-course:25.04"
CONTAINER_NAME="linux-lab"

# Проверка, есть ли уже контейнер с таким именем
if docker ps -a --format '{{.Names}}' | grep -Eq "^${CONTAINER_NAME}$"; then
    echo "[INFO] Контейнер $CONTAINER_NAME уже существует. Удаляем..."
    docker rm -f "$CONTAINER_NAME"
fi

# Сборка образа
echo "[INFO] Сборка образа $IMAGE_NAME..."
docker build -t "$IMAGE_NAME" .

echo "[INFO] Образ $IMAGE_NAME успешно собран."
