FROM crops/extsdk-container

USER root

RUN apt-get -y install vim && \
    ssh-keyscan -t rsa gitlab.neubau.io >> ~/.ssh/known_hosts
USER usersetup
ENV LANG=en_US.UTF-8

ENTRYPOINT ["/usr/bin/dumb-init", "--", "/usr/bin/esdk-entry.py"]
