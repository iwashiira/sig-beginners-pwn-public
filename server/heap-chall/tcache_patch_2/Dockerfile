FROM amd64/ubuntu:22.04


RUN apt-get update && \
        apt-get -y upgrade && \
        apt-get install -y \
        xinetd \
        iproute2

RUN groupadd -r user && useradd -r -g user user

#COPY --chown=root:root ./build/libc.so.6 /lib/x86_64-linux-gnu/libc.so.6
COPY --chown=root:user ./build/start.sh /home/user/start.sh
COPY --chown=root:user ./build/flag /home/user/flag
COPY --chown=root:user ./dist/tcache /home/user/tcache
COPY --chown=root:root ./build/ctf.conf /etc/xinetd.d/ctf

WORKDIR /home/user

RUN chmod 444 ./flag && \
        chmod 555 ./tcache && \
        chmod 555 ./start.sh && \
        chmod 444 /etc/xinetd.d/ctf

USER user
EXPOSE 40002

CMD ["xinetd", "-dontfork", "-f","/etc/xinetd.d/ctf"]
