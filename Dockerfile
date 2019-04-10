FROM docker.io/bigstepinc/jupyter_bdl:2.4.0-8
ARG PIP_PACKAGES
ENV PIP_PACKAGES=${PIP_PACKAGES:-'seaborn'}
ARG OS_PACKAGES
ENV OS_PACKAGES=${OS_PACKAGES:-'vim'}
ARG NOTEBOOK_INFO
ENV NOTEBOOK_INFO=${NOTEBOOK_INFO:-'0.1.0'}
ARG NOTEBOOK_NAME
ENV NOTEBOOK_NAME=${NOTEBOOK_NAME}
COPY . .
#RUN mv 
RUN pip install $PIP_PACKAGES && \
    apt-get install --no-install-recommends -y $OS_PACKAGES
RUN python ./script.py $NOTEBOOK_NAME
RUN mkdir /root/.docker
RUN mv /context/.docker/config.json /root/.docker/config.json
RUN cd && cat /root/envs/bashEnv >> .bashrc
RUN . /root/.bashrc
ENTRYPOINT ["jupyter", "nbconvert", "--inplace", "--allow-errors", "--execute", "/notebook.ipynb"]
