FROM --platform=linux/amd64 ubuntu:22.04

ENV DEBIAN_FRONTEND=noninteractive

ARG USERNAME
ARG GROUPNAME
ARG UID
ARG GID
RUN apt update && apt install sudo tzdata -y
RUN useradd -m -s /bin/bash -G sudo -u $UID $USERNAME
RUN echo "%$USERNAME ALL=(ALL:ALL) NOPASSWD:ALL" >> /etc/sudoers

USER $USERNAME

WORKDIR /home/$USERNAME
COPY .bashrc ./.bashrc
RUN sudo chown -R $UID:$GID ./.bashrc
COPY .gdbinit ./.gdbinit
COPY .gdbinit /root/.gdbinit
COPY manage_aslr.sh /usr/local/bin/aslr
RUN sudo chmod +x /usr/local/bin/aslr
RUN sudo chown -R $UID:$GID ./.gdbinit
RUN mkdir -p ./pwn/Tools
COPY ./Programs ./pwn/Programs
RUN sudo chmod 777 ./pwn/Programs

COPY ./install.sh /tmp/install.sh
RUN sudo chmod +x /tmp/install.sh

WORKDIR /tmp
RUN ./install.sh

WORKDIR /home/$USERNAME
CMD ["/bin/bash"]
