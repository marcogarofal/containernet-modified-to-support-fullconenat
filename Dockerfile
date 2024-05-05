FROM ubuntu:18.04
LABEL maintainer="manuel@peuster.de"

# install required packages
RUN apt-get clean
RUN apt-get update \
    && apt-get install -y  git \
    net-tools \
    aptitude \
    build-essential \
    python3-setuptools \
    python3.8-dev \
    python3-pip \
    software-properties-common \
    ansible \
    curl \
    iptables \
    iputils-ping \
    wget \
    sudo

WORKDIR /home/

# Specifica l'uso di gcc-12 durante la compilazione
#ENV CC=/usr/bin/gcc-12


RUN which gcc
RUN gcc --version

#RUN wget https://www.netfilter.org/projects/libmnl/files/libmnl-1.0.5.tar.bz2 && tar -xvf libmnl-1.0.5.tar.bz2 && ls && sleep 10 && cd libmnl-1.0.5/ && ./configure && sudo make && sudo make install





# Esegui i comandi relativi a questo percorso di lavoro
RUN wget https://www.netfilter.org/projects/libmnl/files/libmnl-1.0.5.tar.bz2
RUN tar -xvf /home/libmnl-1.0.5.tar.bz2 
RUN cd /home/libmnl-1.0.5/
RUN ls /home/libmnl-1.0.5/
RUN sudo chmod u+x /home/libmnl-1.0.5/configure 
RUN cd /home/libmnl-1.0.5/ && ./configure
RUN cd /home/libmnl-1.0.5/ && sudo make 
RUN cd /home/libmnl-1.0.5/ && sudo make install









RUN git clone https://github.com/marcogarofal/iptables-modified-fullconenat.git
RUN wget https://www.netfilter.org/projects/iptables/files/iptables-1.8.7.tar.bz2
RUN tar -xvf /home/iptables-1.8.7.tar.bz2
RUN cp /home/iptables-modified-fullconenat/libipt_FULLCONENAT.c /home/iptables-1.8.7/extensions/



RUN cd /home/iptables-1.8.7/ && ./configure --disable-nftables
RUN cd /home/iptables-1.8.7/ &&  sudo make
RUN cd /home/iptables-1.8.7/ && sudo make install
RUN iptables --version

# install containernet (using its Ansible playbook)
COPY . /containernet
WORKDIR /containernet/ansible
RUN ansible-playbook -i "localhost," -c local --skip-tags "notindocker" install.yml
WORKDIR /containernet
RUN make develop

# Hotfix: https://github.com/pytest-dev/pytest/issues/4770
RUN pip3 install "more-itertools<=5.0.0"

# tell containernet that it runs in a container
ENV CONTAINERNET_NESTED 1

# Important: This entrypoint is required to start the OVS service
ENTRYPOINT ["util/docker/entrypoint.sh"]
CMD ["/bin/bash"]
