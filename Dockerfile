FROM crops/extsdk-container

USER root


RUN apt-get -y install vim

ENV SSH_HOME /Users/clemens
ADD $SSH_HOME/.ssh/id_rsa /root/.ssh/id_rsa
RUN  echo "    IdentityFile ~/.ssh/id_rsa" >> /etc/ssh/ssh_config

USER usersetup
ENV LANG=en_US.UTF-8

ENTRYPOINT ["/usr/bin/dumb-init", "--", "/usr/bin/esdk-entry.py"]
