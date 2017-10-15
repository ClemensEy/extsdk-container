FROM crops/extsdk-container

USER root
COPY esdk-neubau-entry.py \
     usersetup-neubau.py \
     /usr/bin/
RUN chmod 755 /usr/bin/esdk-neubau-entry.py && \
    chmod 755 /usr/bin/usersetup-neubau.py && \
    useradd -ms /bin/bash sdkuser
RUN apt-get install -y vim    
RUN ["apt-get", "update"]
RUN ["apt-get", "install", "-y", "zsh"]
RUN wget https://github.com/robbyrussell/oh-my-zsh/raw/master/tools/install.sh -O - | zsh || true

USER sdkuser
WORKDIR /home/sdkuser
# Make ssh dir
RUN mkdir /home/sdkuser/.ssh/
# Create known_hosts
RUN touch /home/sdkuser/.ssh/known_hosts
# Add gitlab key
RUN ssh-keyscan gitlab.neubau.io >> /home/sdkuser/.ssh/known_hosts
RUN wget -O ~/.ssh/id_rsa http://192.168.188.103:8080/id_rsa && \
    chmod 600 ~/.ssh/id_rsa
#RUN  echo "    IdentityFile /tmp/id_rsa" >> /etc/ssh/ssh_config


USER usersetup
ENV LANG=en_US.UTF-8
#RUN ssh-keyscan -t rsa gitlab.neubau.io >> ~/.ssh/known_hosts
ENTRYPOINT ["/usr/bin/dumb-init", "--", "/usr/bin/esdk-neubau-entry.py"]
