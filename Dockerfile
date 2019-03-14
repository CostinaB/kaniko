FROM docker.io/bigstepinc/jupyter_bdl:2.4.0-7
ARG PIP_PACKAGES
ENV PIP_PACKAGES=${PIP_PACKAGES:-'plotly'}
ARG OS_PACKAGES
ENV OS_PACKAGES=${OS_PACKAGES:-'vim'}
ARG NOTEBOOK_INFO
ENV NOTEBOOK_INFO=${NOTEBOOK_INFO:-'0.1.0'}
RUN pip install $PIP_PACKAGES && \
    apt-get install --no-install-recommends -y $OS_PACKAGES
FROM scratch
COPY --from=0 /bin/sh /bin/sh
ENTRYPOINT ["/bin/sh", "-c" , "echo hello"]
