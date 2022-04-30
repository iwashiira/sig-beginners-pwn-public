FROM --platform=linux/amd64 ubuntu:18.04

RUN apt update && apt install -y \
  build-essential \
  gdb \
  python \
  ruby-full \
  python-pip \
  libssl-dev \
  libffi-dev \
  neovim \
  vim \
  curl \
  wget \
  pkg-config \
  git \
  sudo \
  && apt clean \
  && rm -rf /var/lib/apt/lists/*

ARG USERNAME
ARG GROUPNAME
ARG UID
ARG GID
RUN useradd -m -s /bin/bash -u $UID $USERNAME
WORKDIR /home/$USERNAME/
RUN mkdir -p ./pwn/Tools

WORKDIR /home/$USERNAME
COPY .gdbinit ./.gdbinit
COPY ./Programs ./pwn/Programs
RUN chown -R $UID:$GID ./pwn/Programs
RUN chmod 777 ./pwn/Programs

RUN wget wget https://github.com/downloads/0vercl0k/rp/rp-lin-x64 -O /usr/local/bin/rp++
RUN chmod +x /usr/local/bin/rp++
RUN gem install one_gadget
RUN python -m pip install pwntools pathlib2

WORKDIR /home/$USERNAME/pwn/Tools
RUN git clone https://github.com/longld/peda.git
RUN git clone https://github.com/scwuaptx/Pwngdb.git
RUN git clone https://github.com/radareorg/radare2 \
  && cd radare2 \
  && ./sys/install.sh

WORKDIR /home/$USERNAME
CMD ["/bin/bash"]
