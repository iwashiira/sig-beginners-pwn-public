FROM --platform=linux/amd64 ubuntu:18.04

RUN apt update && apt install -y \
  build-essential \
  gdb \
  python \
  python-pip \
  libssl-dev \
  libffi-dev \
  neovim \
  vim \
  curl \
  wget \
  pkg-config \
  git \
  && apt clean \
  && rm -rf /var/lib/apt/lists/*

ARG USERNAME=pwner
ARG GROUPNAME=pwner
ARG UID=1000
ARG GID=1000
ARG PASSWORD=pwner
RUN groupadd -g $GID $GROUPNAME && \
    useradd -m -s /bin/bash -u $UID -g $GID -G sudo $USERNAME && \
    echo $USERNAME:$PASSWORD | chpasswd && \
    echo "$USERNAME   ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers
USER $USERNAME
WORKDIR /home/$USERNAME/
RUN mkdir -p ./pwn/Tools

WORKDIR /home/$USERNAME
COPY .gdbinit ./.gdbinit
COPY ./Programs ./pwn/Programs

RUN python -m pip install pwntools pathlib2

WORKDIR /home/$USERNAME/pwn/Tools
RUN git clone https://github.com/longld/peda.git
RUN git clone https://github.com/scwuaptx/Pwngdb.git
RUN git clone https://github.com/radareorg/radare2 \
  && cd radare2 \
  && ./sys/install.sh

CMD ["/bin/bash"]
