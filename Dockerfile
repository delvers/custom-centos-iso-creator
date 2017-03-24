FROM centos:7

RUN mkdir /build
RUN mkdir /scripts
WORKDIR /build
RUN yum update -qy
RUN yum install -qy wget libusal genisoimage

# add build script
ADD scripts/create_iso.sh /scripts/
RUN chmod +x /scripts/create_iso.sh

# add bootloader config
ADD scripts/isolinux.cfg /scripts/

# set default centos mirror
ENV MIRROR_URL="http://centosmirror.netcup.net/centos/7/os/x86_64"

ENTRYPOINT bash /scripts/create_iso.sh
