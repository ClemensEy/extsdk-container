FROM crops/extsdk-container

USER root
ENV TERM xterm-256color
COPY esdk-neubau-entry.py \
     usersetup-neubau.py \
     /usr/bin/
RUN chmod 755 /usr/bin/esdk-neubau-entry.py && \
    chmod 755 /usr/bin/usersetup-neubau.py && \
    useradd -ms /bin/bash sdkuser && \
    apt-get install -y vim && \
    apt-get install -y x11-apps
#    ["apt-get", "update"] && \
RUN ["apt-get", "install", "-y", "zsh"]
#RUN wget https://github.com/robbyrussell/oh-my-zsh/raw/master/tools/install.sh -O - | zsh || true

USER sdkuser
RUN wget https://github.com/robbyrussell/oh-my-zsh/raw/master/tools/install.sh -O - | zsh || true
#WORKDIR /home/sdkuser

USER usersetup
ENV LANG=en_US.UTF-8
#RUN ssh-keyscan -t rsa gitlab.neubau.io >> ~/.ssh/known_hosts
ENTRYPOINT ["/usr/bin/dumb-init", "--", "/usr/bin/esdk-neubau-entry.py"]
