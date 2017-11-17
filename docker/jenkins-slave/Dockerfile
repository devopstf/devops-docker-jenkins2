FROM devops-docker-jdk:1.8.0_73

# LABELS
LABEL java.version=1.8
LABEL jdk.version=jdk1.8.0_73
LABEL maven.version=3.3.9
LABEL rtc.version=5.0.2

# Generic Environment Arguments

ARG MAVEN_DOWNLOAD=
ARG MAVEN_VERSION=3.3.9
ARG JDK_VERSION=jdk1.8.0_73

# RTC Tools
ARG RTC_DOWNLOAD=
ARG JBE_ZIP=RTC-BuildSystem-Toolkit-Linux-5.0.2.zip
ARG SCMTOOLS_ZIP=RTC-scmTools-Linux64-5.0.2.zip
ARG JBE_CONFIG=jbe.ini
ARG SCMTOOLS_CONFIG=scm.ini
ARG JBE_FOLDER=
ARG SCMTOOLS_FOLDER=
ARG JBE_PATH=
ARG SCMTOOLS_PATH=

# Infra Arguments
ARG ANSIBLE_VERSION=2.2.0
ARG DOCKER_VERSION=1.12.5
ARG NODE_VERSION=6.9.1
ARG OPENSHIFT_VERSION=1.4.1

COPY docker-entrypoint.sh /usr/local/bin/docker-entrypoint.sh

RUN \
# Install Maven
        mkdir -p /usr/share/maven /usr/share/maven/ref && \
        curl -fsSL ${MAVEN_DOWNLOAD}/apache-maven-${MAVEN_VERSION}-bin.tar.gz \
        | tar -xzC /usr/share/maven --strip-components=1 && \
        ln -s /usr/share/maven/bin/mvn /usr/bin/mvn && \
        yum install -y which && \
# Install RTC jbe
        yum install -y glibc.i686 && \
        yum install -y unzip && \
        curl --url ${RTC_DOWNLOAD}/${JBE_ZIP} --output /tmp/${JBE_ZIP} && \
        mkdir -p ${JBE_FOLDER} && \
        unzip /tmp/${JBE_ZIP} -d ${JBE_FOLDER} && \
        rm /tmp/${JBE_ZIP} && \
        sed -i 's/#-vm/-vm/g' ${JBE_PATH}/${JBE_CONFIG} && \
        sed -i 's/#\/TODO\/path\/to\/jre\/bin/\/opt\/'${JDK_VERSION}'\/bin/g' ${JBE_PATH}/${JBE_CONFIG} && \
        sed -i '/\/bin\//a -start' ${JBE_PATH}/${JBE_CONFIG} && \
        sed -i '/start/a plugins/org.eclipse.equinox.launcher_1.1.1.R36x_v20101122_1400.jar' ${JBE_PATH}/${JBE_CONFIG} && \
        sed -i '/supressErrors/a -vmargs' ${JBE_PATH}/${JBE_CONFIG} && \
        sed -i '/vmargs/a -Xmx300m' ${JBE_PATH}/${JBE_CONFIG} && \
        sed -i 's/-Dcom.ibm.team*/#&/g' ${JBE_PATH}/${JBE_CONFIG} && \
# Install RTC scmtools
        curl --url ${RTC_DOWNLOAD}/${SCMTOOLS_ZIP} --output /tmp/${SCMTOOLS_ZIP} && \
        mkdir -p ${SCMTOOLS_FOLDER} && \
        unzip /tmp/${SCMTOOLS_ZIP} -d ${SCMTOOLS_FOLDER} && \
        rm /tmp/${SCMTOOLS_ZIP} && \
        sed -n '1d' ${SCMTOOLS_PATH}/${SCMTOOLS_CONFIG} && \
        sed -i 's/#-vm/-vm/g' ${SCMTOOLS_PATH}/${SCMTOOLS_CONFIG} && \
        sed -i 's/#\/TODO\/path\/to\/jre\/bin/\/opt\/'${JDK_VERSION}'\/bin/g' ${SCMTOOLS_PATH}/${SCMTOOLS_CONFIG} && \
        sed -i 's/-Xshareclasses:*/#&/g' ${SCMTOOLS_PATH}/${SCMTOOLS_CONFIG} && \
        sed -i 's/-Xquickstart*/#&/g' ${SCMTOOLS_PATH}/${SCMTOOLS_CONFIG} && \
        sed -i 's/-Xdump:*/#&/g' ${SCMTOOLS_PATH}/${SCMTOOLS_CONFIG} && \
# Install git
        yum install -y git && \
# DOCKER
        yum install -y docker-${DOCKER_VERSION} && \
# OPENSHIFT
        yum install -y origin-clients-${OPENSHIFT_VERSION} && \
# NODE
        yum install -y nodejs-${NODE_VERSION} && \
# ANSIBLE
        yum install -y openssl ansible-${ANSIBLE_VERSION} \
                python-lxml python-requests python-docker-py && \
# jenkins client
        mkdir -p /data && \
        chmod 755 /data  && \
        chmod +x /usr/local/bin/docker-entrypoint.sh  && \
# Add groups
        groupadd 65534 -g 65534 && \
        groupadd docker -g 2375 && \
        adduser 65534 --uid 65534 -g 65534 --home /home/65534 && \
        yum clean all
ENV PATH "$PATH:  "

WORKDIR /data
USER 65534

ENTRYPOINT ["docker-entrypoint.sh"]
