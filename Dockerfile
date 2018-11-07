FROM node:latest

RUN echo "deb http://ppa.launchpad.net/webupd8team/java/ubuntu xenial main" | tee /etc/apt/sources.list.d/webupd8team-java.list && \
    echo "deb-src http://ppa.launchpad.net/webupd8team/java/ubuntu xenial main" | tee -a /etc/apt/sources.list.d/webupd8team-java.list && \
    apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys EEA14886 && \
    DEBIAN_FRONTEND=noninteractive apt-get update -q && \
	apt-get install -qy --no-install-recommends sudo

RUN echo debconf shared/accepted-oracle-license-v1-1 select true | sudo debconf-set-selections && \
    echo debconf shared/accepted-oracle-license-v1-1 seen true | sudo debconf-set-selections && \
    apt-get install -qy --no-install-recommends oracle-java8-installer unzip

ENV ANDROID_SDK_FILE sdk-tools-linux-4333796.zip
ENV ANDROID_SDK_URL https://dl.google.com/android/repository/$ANDROID_SDK_FILE

ENV ANDROID_HOME /usr/local/android-sdk-linux
RUN cd /usr/local && \
    mkdir android-sdk-linux && \
    cd android-sdk-linux && \
    wget $ANDROID_SDK_URL && \
    unzip $ANDROID_SDK_FILE && \
    export PATH=$PATH:$ANDROID_HOME/tools:$ANDROID_HOME/platform-tools && \
    chgrp -R users $ANDROID_HOME && \
    chmod -R 0775 $ANDROID_HOME && \
    rm $ANDROID_SDK_FILE

ENV PATH $PATH:$ANDROID_HOME/tools:$ANDROID_HOME/platform-tools:$ANDROID_HOME/build-tools/23.0.1

RUN cd /usr/local/android-sdk-linux && \
    yes | ./tools/bin/sdkmanager --licenses && \
    ./tools/bin/sdkmanager "platform-tools" "platforms;android-26" "build-tools;26.0.3"


RUN npm install -g react-native-cli

EXPOSE 8081

ENV USERNAME dev

RUN adduser --disabled-password --gecos '' $USERNAME && \
    echo $USERNAME:$USERNAME | chpasswd && \
    echo "%sudo ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers && \
    adduser $USERNAME sudo

ENV GRADLE_USER_HOME /home/$USERNAME/app/android/gradle_deps

USER $USERNAME

WORKDIR /home/$USERNAME/app
