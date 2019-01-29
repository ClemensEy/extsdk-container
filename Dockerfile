FROM crops/extsdk-container

USER root
ENV TERM xterm-256color
COPY esdk-neubau-entry.py \
     esdk-neubau-launch.py \
     usersetup-neubau.py \
     /usr/bin/
RUN chmod 755 /usr/bin/esdk-neubau-entry.py && \
    chmod 755 /usr/bin/esdk-neubau-launch.py && \
    chmod 755 /usr/bin/usersetup-neubau.py && \
    useradd -ms /bin/bash sdkuser && \
    echo "sdkuser:sdkuser" | chpasswd && \
    adduser sdkuser sudo && \
    adduser usersetup sudo && \
    apt-get install -y vim && \
    apt-get install -y x11-apps
#    ["apt-get", "update"] && \
#RUN ["apt-get", "install", "-y", "zsh"]
#RUN wget https://github.com/robbyrussell/oh-my-zsh/raw/master/tools/install.sh -O - | zsh || true
RUN apt-get update && apt-get install -y openssh-server
RUN mkdir /var/run/sshd
#RUN echo 'root:screencast' | chpasswd
#RUN sed -i 's/PermitRootLogin prohibit-password/PermitRootLogin yes/' /etc/ssh/sshd_config

# SSH login fix. Otherwise user is kicked off after login
RUN sed 's@session\s*required\s*pam_loginuid.so@session optional pam_loginuid.so@g' -i /etc/pam.d/sshd
ENV NOTVISIBLE "in users profile"
RUN echo "export VISIBLE=now" >> /etc/profile

RUN echo "usersetup ALL=NOPASSWD: /usr/sbin/sshd" >> /etc/sudoers
RUN echo "usersetup ALL=NOPASSWD: /etc/init.d/ssh start" >> /etc/sudoers
RUN echo "sdkuser ALL=NOPASSWD: /usr/sbin/sshd" >> /etc/sudoers
RUN echo "sdkuser ALL=NOPASSWD: /etc/init.d/ssh start" >> /etc/sudoers
RUN echo "usersetup ALL = (sdkuser) NOPASSWD:SETENV: /usr/bin/esdk-neubau-launch.py" >> /etc/sudoers
EXPOSE 22


USER sdkuser
#RUN wget https://github.com/robbyrussell/oh-my-zsh/raw/master/tools/install.sh -O - | zsh || true
#WORKDIR /home/sdkuser

USER usersetup
ENV LANG=en_US.UTF-8
#RUN ssh-keyscan -t rsa gitlab.neubau.io >> ~/.ssh/known_hosts
ENTRYPOINT ["/usr/bin/dumb-init", "--", "/usr/bin/esdk-neubau-entry.py"]
