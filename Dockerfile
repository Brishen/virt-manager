FROM centos:7 as build-dep
RUN mkdir /prereq
WORKDIR /prereq
RUN yum groups mark convert && yum -y --setopt=group_package_types=mandatory,default,optional groupinstall "Development Tools"
RUN yum install -y libvirt-python gtk3-devel zlib gtksourceview3-devel tree

FROM build-dep as dep-dl
RUN curl https://ftp.gnu.org/pub/gnu/gettext/gettext-0.21.tar.gz -o gettext.tar.gz && tar -xf gettext*.tar.gz
RUN curl https://gitlab.gnome.org/GNOME/pygobject/-/archive/3.38.0/pygobject-3.38.0.tar.gz -o pygobject-3.tar.gz && tar -xf pygobject-3.tar.gz
RUN curl https://releases.pagure.org/libosinfo/libosinfo-1.2.0.tar.gz -o libosinfo.tar.gz && tar -xf libosinfo.tar.gz
RUN curl https://www.python.org/ftp/python/3.9.1/Python-3.9.1.tar.xz -o python.tar.xz && tar -xf python.tar.xz

FROM dep-dl as dep-gettext
WORKDIR /prereq/gettext-0.21
RUN ./configure && make && make install

FROM dep-gettext as dep-libosinfo
WORKDIR /prereq/libosinfo-1.2.0
RUN ./configure && make && make install

FROM dep-libosinfo as dep-python39
WORKDIR /prereq/Python-3.9.1
RUN ./configure && make && make install

FROM dep-python39 as dep-pygobject
WORKDIR /prereq/pygobject-3.38.0
RUN python setup.py install