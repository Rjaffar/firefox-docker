FROM ubuntu:14.04
MAINTAINER Dennis Schridde <devurandom@gmx.net>
ENV DEBIAN_FRONTEND noninteractive

VOLUME /home

# Allow installation of corefonts
RUN echo ttf-mscorefonts-installer msttcorefonts/accepted-mscorefonts-eula boolean true | debconf-set-selections

# Add multiverse, webupd8 (for freshplayerplugin) and pipelight repositories
RUN apt-get -y install software-properties-common && apt-add-repository multiverse && apt-add-repository ppa:nilarimogard/webupd8 && apt-add-repository ppa:pipelight/stable

# Install system packages and those for HTML5 audio/video, which change only seldomly
RUN apt-get -y update && apt-get -y install --install-recommends dbus-x11 pulseaudio gstreamer1.0-pulseaudio gstreamer1.0-plugins-good ubuntu-restricted-extras libgl1-mesa-glx-lts-vivid libgl1-mesa-dri-lts-vivid libtxc-dxtn-s2tc0 mesa-vdpau-drivers-lts-vivid libvdpau-va-gl1 i965-va-driver vdpau-va-driver

# Install Firefox, Flash, Silverlight
# Don't install Pipelight, as Apt refuses to do so...
RUN apt-get -y update && apt-get -y install --install-recommends firefox=44.0* pepperflashplugin-nonfree freshplayerplugin

# Update Pipelight plugins
#RUN pipelight-plugin --update

# Add non-superuser
RUN groupadd -g 1000 storage && useradd -u 1000 -g storage storage && usermod -aG video storage

USER storage

ENTRYPOINT ["/usr/bin/firefox"]
CMD ["-new-instance"]
