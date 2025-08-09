#!/usr/bin/env bash
# run_image.sh — запуск учебного образа Ubuntu 25.04 и вход в контейнер

set -e

IMAGE_NAME="ubuntu-linux-course:25.04"
CONTAINER_NAME="linux-lab"
WORKDIR="$PWD/workdir"  # локальная папка для обмена файлами

# Создадим папку для монтирования, если её нет
mkdir -p "$WORKDIR"

# Если контейнер уже запущен — подключаемся к нему
if docker ps --format '{{.Names}}' | grep -q "^${CONTAINER_NAME}$"; then
    echo "[INFO] Подключаемся к уже работающему контейнеру $CONTAINER_NAME..."
    exec docker exec -it "$CONTAINER_NAME" zsh
fi

# Если контейнер есть, но не запущен — стартуем его
if docker ps -a --format '{{.Names}}' | grep -q "^${CONTAINER_NAME}$"; then
    echo "[INFO] Запускаем остановленный контейнер $CONTAINER_NAME..."
    docker start -ai "$CONTAINER_NAME"
    exit 0
fi

# Если образа нет — собираем
if ! docker image inspect "$IMAGE_NAME" >/dev/null 2>&1; then
    echo "[WARN] Локальный образ $IMAGE_NAME не найден."
    if [[ -x "./build_image.sh" ]]; then
        echo "[INFO] Запускаем build_image.sh..."
        ./build_image.sh
    else
        echo "[ERROR] Скрипт build_image.sh не найден. Создайте его или поместите в текущую директорию."
        exit 1
    fi
fi

# Запускаем новый контейнер
echo "[INFO] Запуск нового контейнера $CONTAINER_NAME..."
docker run -it \
    --name "$CONTAINER_NAME" \
    -v "$WORKDIR":/home/student/workdir \
    "$IMAGE_NAME"
