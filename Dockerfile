FROM ubuntu:latest

# update
RUN apt-get -y update && apt-get -y upgrade

###install anaconda3
RUN apt-get install -y wget
WORKDIR /opt
# download anaconda package
# archive -> https://repo.continuum.io/archive/
RUN wget https://repo.continuum.io/archive/Anaconda3-2019.10-Linux-x86_64.sh \
    && /bin/bash /opt/Anaconda3-2019.10-Linux-x86_64.sh -b -p /opt/anaconda3 \
    && rm -f Anaconda3-2019.10-Linux-x86_64.sh
ENV PATH /opt/anaconda3/bin:$PATH

# update and add packages
RUN pip install --upgrade pip
RUN pip install --upgrade scipy
RUN pip install lightgbm xgboost tensorflow keras

WORKDIR /
RUN mkdir /work
RUN apt-get install -y tree
# jupyterlab advanced settings editor
RUN install -D /dev/null /root/.jupyter/lab/user-settings/@jupyterlab/apputils-extension/themes.jupyterlab-settings \
    && echo '{"theme": "JupyterLab Dark"}' > /root/.jupyter/lab/user-settings/@jupyterlab/apputils-extension/themes.jupyterlab-settings \
    && install -D /dev/null /root/.jupyter/lab/user-settings/@jupyterlab/notebook-extension/tracker.jupyterlab-settings \
    && echo '{"codeCellConfig": {"lineNumbers": true}}' > /root/.jupyter/lab/user-settings/@jupyterlab/notebook-extension/tracker.jupyterlab-settings \
    && install -D /dev/null /root/.jupyter/lab/user-settings/@jupyterlab/terminal-extension/plugin.jupyterlab-settings \
    && echo '{"fontFamily": "Monaco"}' > /root/.jupyter/lab/user-settings/@jupyterlab/terminal-extension/plugin.jupyterlab-settings
# default login shell
RUN rm /bin/sh && ln -s /bin/bash /bin/sh

# run jupyterlab
ENTRYPOINT ["jupyter", "lab","--ip=0.0.0.0","--allow-root", "--LabApp.token=''"]