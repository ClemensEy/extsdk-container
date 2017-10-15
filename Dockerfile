FROM crops/extsdk-container

USER root

RUN apt-get -y install vim 

USER usersetup
ENV LANG=en_US.UTF-8
RUN ssh-keyscan -t rsa gitlab.neubau.io >> ~/.ssh/known_hosts
ENTRYPOINT ["/usr/bin/dumb-init", "--", "/usr/bin/esdk-entry.py"]
