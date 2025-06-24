FROM ubuntu:22.04

ENV DEBIAN_FRONTEND=noninteractive

# Crée un user non-root avec sudo
RUN useradd -ms /bin/bash tester && \
    apt-get update && \
    apt-get install -y sudo git curl && \
    echo "tester ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers

USER tester
WORKDIR /home/tester

# Point d'entrée : on laisse le script externe décider quoi faire
CMD ["/bin/bash"]
