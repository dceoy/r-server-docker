FROM ubuntu:xenial

RUN set -e \
      && apt-get -y update \
      && apt-get -y upgrade \
      && apt-get -y install libapparmor1 libcurl4-openssl-dev libxml2-dev libssl-dev gdebi-core apt-transport-https

RUN set -e \
      && echo 'deb https://cloud.r-project.org/bin/linux/ubuntu xenial/' >> /etc/apt/sources.list \
      && apt-key adv --keyserver keyserver.ubuntu.com --recv-keys 381BA480 \
      && apt-get -y update \
      && apt-get -y install r-base r-cran-* \
      && apt-get clean

RUN set -e \
      && curl -s https://s3.amazonaws.com/rstudio-server/current.ver \
        | xargs -I {} curl -s http://download2.rstudio.org/rstudio-server-{}-amd64.deb -o rstudio.deb \
      && gdebi -n rstudio.deb \
      && rm rstudio.deb

RUN set -e \
      && useradd -m -d /home/rstudio rstudio \
      && echo rstudio:rstudio \
        | chpasswd

EXPOSE 8787

CMD ["/usr/lib/rstudio-server/bin/rserver", "--server-daemonize=0", "--server-app-armor-enabled=0"]
