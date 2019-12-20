FROM nvidia/cuda:9.2-cudnn7-devel-ubuntu18.04

# Use local devpi server
ENV DEVPI_SERVER=192.168.200.176
ENV PIP_INDEX_URL=http://$DEVPI_SERVER:3141/root/pypi/+simple/
ENV PIP_TRUSTED_HOST=$DEVPI_SERVER
ENV PIP_DEFAULT_TIMEOUT=300

# Use apt repository in Japan and set timezone to JST
RUN perl -p -i.bak -e 's%https?://(?!security)[^ \t]+%http://ftp.jaist.ac.jp/pub/Linux/ubuntu/%g' /etc/apt/sources.list
RUN apt-get update && apt-get install -y tzdata
RUN ln -fs /usr/share/zoneinfo/Asia/Tokyo /etc/localtime && dpkg-reconfigure -f noninteractive tzdata

ENV NVIDIA_VISIBLE_DEVICES=all
ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update -y && \
  apt-get install -y --no-install-recommends \
  python-dev \
  python-wheel \
  python-setuptools \
  wget ca-certificates openssl

RUN wget https://bootstrap.pypa.io/get-pip.py && python get-pip.py

# packages
RUN pip install http://download.pytorch.org/whl/cu92/torch-0.4.1-cp27-cp27mu-linux_x86_64.whl
RUN apt-get install -y graphviz python-tk htop pigz python-psutil git cmake python-backports.functools-lru-cache
RUN apt-get purge -y python-scipy
RUN pip install -U torchvision==0.2.1 matplotlib==2.2.4 graphviz numpy==1.16.0 opencv-python==3.3.0.10 scikit-learn==0.20 tqdm vtk itk nibabel==2.5.1 python-dateutil scipy==1.2.2 pydicom toml easydict pyyaml cffi openpyxl==2.6.4 cython

RUN cd && git clone --depth 1 https://github.com/rsummers11/CADLab.git
RUN cd && git clone --depth 1 https://github.com/viggin/faster-rcnn.pytorch.git
COPY make.sh /root/faster-rcnn.pytorch/lib
RUN cd /root/faster-rcnn.pytorch/lib && sh ./make.sh
RUN cp -r /root/faster-rcnn.pytorch/lib/model/roi_pooling /root/CADLab/LesaNet

COPY LesaNet_epoch_15.pth.tar /root/CADLab/LesaNet/checkpoints

WORKDIR /root/CADLab/LesaNet
