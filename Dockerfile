FROM --platform=linux/amd64 ubuntu:18.04

ARG DEBIAN_FRONTEND=noninteractive

ARG USERNAME
ARG GROUPNAME
ARG UID
ARG GID
RUN useradd -m -s /bin/bash -u $UID $USERNAME

WORKDIR /home/$USERNAME
COPY .bashrc ./.bashrc
RUN chown -R $UID:$GID ./.bashrc
COPY .gdbinit ./.gdbinit
RUN chown -R $UID:$GID ./.gdbinit
RUN mkdir -p ./pwn/Tools
COPY ./Programs ./pwn/Programs
RUN chown -R $UID:$GID ./pwn
RUN chown -R $UID:$GID ./pwn/Programs
RUN chown -R $UID:$GID ./pwn/Tools
RUN chmod 777 ./pwn/Programs

RUN apt update && apt install sudo -y

COPY ./install.sh /tmp/install.sh
RUN chown -R $UID:$GID /tmp/install.sh
RUN chmod +x /tmp/install.sh

WORKDIR /tmp
RUN ./install.sh

WORKDIR /home/$USERNAME
CMD ["/bin/bash"]
