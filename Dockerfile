FROM debian:buster-slim

ENV DEBIAN_FRONTEND noninteractive

RUN apt-get update && apt-get install --no-install-recommends -y \
    udev \
    git \
    build-essential \
    pps-tools \
    python3-pip \
    python3-dev \
    python3-setuptools \
    python3-wheel \
    libsystemd-dev \
    bc \
    dos2unix \
    socat \
    zip \
    unzip \
    wget \
    gpsd \
    chrony \
    psmisc \
    sudo \
    && apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# RTKLib
RUN wget -qO - https://github.com/tomojitakasu/RTKLIB/archive/v2.4.3-b34.tar.gz | tar -xvz \
    && make -j2 --directory=RTKLIB-2.4.3-b34/app/consapp/str2str/gcc \
    && make -j2 --directory=RTKLIB-2.4.3-b34/app/consapp/str2str/gcc install \
    && make -j2 --directory=RTKLIB-2.4.3-b34/app/consapp/rtkrcv/gcc \
    && make -j2 --directory=RTKLIB-2.4.3-b34/app/consapp/rtkrcv/gcc install \
    && make -j2 --directory=RTKLIB-2.4.3-b34/app/consapp/convbin/gcc \
    && make -j2 --directory=RTKLIB-2.4.3-b34/app/consapp/convbin/gcc install \
    && rm -rf RTKLIB-2.4.3-b34/

WORKDIR /rtkbase
# RTKBase
COPY web_app /rtkbase/web_app

RUN sed -i 's/^pystemd/\#pystemd/' /rtkbase/web_app/requirements.txt
RUN python3 -m pip install -r /rtkbase/web_app/requirements.txt
RUN python3 -m pip install supervisor

COPY docker /rtkbase/docker
COPY receiver_cfg /rtkbase/receiver_cfg
COPY settings.conf.default /rtkbase/settings.conf.default
COPY *.sh /rtkbase/

COPY tools /rtkbase/tools

RUN touch /rtkbase/settings.conf

COPY test_settings.conf /rtkbase/settings.conf

RUN sed -i -e "s/\$(logname)/root/g" /rtkbase/tools/install.sh

# Chrony
RUN grep -q 'set larger delay to allow the GPS' /etc/chrony/chrony.conf || echo '# set larger delay to allow the GPS source to overlap with the other sources and avoid the falseticker status' >> /etc/chrony/chrony.conf && grep -qxF 'refclock SHM 0 refid GNSS precision 1e-1 offset 0 delay 0.2' /etc/chrony/chrony.conf || echo 'refclock SHM 0 refid GNSS precision 1e-1 offset 0 delay 0.2' >> /etc/chrony/chrony.conf
EXPOSE 9090/udp

# GPSD
RUN sed -i 's/^START_DAEMON=.*/START_DAEMON="false"/' /etc/default/gpsd

# Expose Port (Note: if you change it do it as well in surpervisord.conf)
EXPOSE 8083

CMD ["/rtkbase/docker/entrypoint.sh"]

# example : docker run --rm -it --network=host --device=/dev/ttyACM0 -v /run/udev:/run/udev:ro rtkbase:1.0.0

