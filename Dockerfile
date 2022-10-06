FROM --platform=linux/amd64 ubuntu:18.04

ARG USERNAME
ARG GROUPNAME
ARG UID
ARG GID
RUN useradd -m -s /bin/bash -u $UID $USERNAME
WORKDIR /home/$USERNAME/
RUN mkdir -p ./pwn/Tools

WORKDIR /home/$USERNAME
COPY .bashrc ./.bashrc
COPY .gdbinit ./.gdbinit
COPY ./Programs ./pwn/Programs
RUN chown -R $UID:$GID ./pwn/Programs
RUN chmod 777 ./pwn/Programs

COPY /tmp ./install.sh
RUN chmod +x /tmp/install.sh
RUN bash -c /tmp/install.sh

WORKDIR /home/$USERNAME
CMD ["/bin/bash"]
