# Ubuntu 25.04 learning image with all tools from the study plan
# План обучения: утилиты собраны по блокам из вашего файла. См. комментарии к разделам. 
# Образ рассчитан на локальный запуск в Docker, без systemd как PID 1.

FROM ubuntu:25.04

SHELL ["/bin/bash", "-lc"]

ARG DEBIAN_FRONTEND=noninteractive
ENV TZ=Etc/UTC \
    LANG=C.UTF-8 \
    LC_ALL=C.UTF-8

# Базовые обновления и удобства
RUN apt-get update && \
    apt-get dist-upgrade -y && \
    apt-get install -y \
        ca-certificates \
        bash-completion \
        locales \
        less \
        sudo \
        software-properties-common \
        gnupg \
        curl wget \
        git \
        man-db manpages manpages-dev \
        tzdata && \
    locale-gen en_US.UTF-8 ru_RU.UTF-8 && \
    update-ca-certificates

# === Shell comfort pack: Zsh + подсказки/подсветка/автодополнение ===
# Оставляем bash, но по умолчанию используем zsh с плагинами и удобным промптом
RUN apt-get update && apt-get install -y \
        zsh \
        zsh-autosuggestions \
        zsh-syntax-highlighting \
        fzf \
        starship \
        eza \
        fd-find && \
    ln -sf /usr/bin/fdfind /usr/local/bin/fd || true

# === Блоки 1–3: навигация, Bash, переменные окружения ===
RUN apt-get install -y \
        coreutils \
        findutils \
        util-linux \
        tree \
        file \
        nano vim \
        bat \
        grep gawk sed \
        procps \
        ripgrep && \
    ln -sf /usr/bin/batcat /usr/local/bin/bat || true

# === Блок 4–6: права, пользователи/группы, sudo ===
RUN apt-get install -y \
        acl \
        passwd \
        psmisc \
        sudo

# === Блок 7–8: службы/процессы, логи и диагностика ===
RUN apt-get install -y \
        htop \
        atop \
        glances \
        bsdutils \
        kmod \
        rsyslog \
        lnav \
        multitail

# === Блок 9: управление пакетами ===
RUN apt-get install -y \
        apt-utils \
        aptitude

# === Блок 10: сеть ===
RUN apt-get install -y \
        iproute2 \
        net-tools \
        iputils-ping \
        traceroute \
        dnsutils \
        netcat-openbsd \
        mtr-tiny \
        nmap

# === Блок 11: архивация и копирование ===
RUN apt-get install -y \
        tar \
        zip unzip \
        rsync \
        diffutils \
        p7zip-full \
        pv

# === Блок 12: процессы и ресурсы ===
RUN apt-get install -y \
        sysstat \
        linux-tools-common

# === Блок 13: файловые системы и монтирование ===
RUN apt-get install -y \
        e2fsprogs \
        xfsprogs \
        dosfstools \
        parted \
        util-linux

# === Блок 14: контейнеризация (дополнительно) ===
RUN apt-get install -y \
        podman \
        buildah

# === Блок 15: скриптинг и автоматизация ===
RUN apt-get install -y \
        jq \
        yq \
        cron \
        watch

# Создаём учебного пользователя с sudo без пароля
RUN useradd -m -s /usr/bin/zsh -G sudo student && \
    echo "student ALL=(ALL) NOPASSWD:ALL" > /etc/sudoers.d/90-student && \
    chmod 0440 /etc/sudoers.d/90-student

USER student
WORKDIR /home/student

# Настройки Bash: автодополнение и цветное приглашение (имя пользователя зелёным, остальное голубым)
RUN echo 'if [ -f /etc/bash_completion ]; then . /etc/bash_completion; fi' >> ~/.bashrc && \
    echo "alias ll='ls -alF'" >> ~/.bashrc && \
    echo "alias la='ls -A'" >> ~/.bashrc && \
    echo "alias l='ls -CF'" >> ~/.bashrc && \
    echo 'PS1="\\[\\e[0;32m\\]\u\\[\\e[0;36m\\]@\\h \\w \\$ \\[\\e[0m\\]"' >> ~/.bashrc

USER root
RUN apt-get clean && rm -rf /var/lib/apt/lists/*

USER student
CMD ["bash"]
