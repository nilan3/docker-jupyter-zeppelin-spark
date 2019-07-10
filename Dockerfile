FROM ubuntu:16.04

ARG MESOS_VERSION=1.6.0
ARG SPARK_VERSION=2.4.3
ARG ZEPPELIN_VERSION=0.8.1

ARG DISTRO=ubuntu
ARG CODENAME=xenial

RUN apt-get update && apt-get install -my wget gnupg && apt-get install -y lsb-core

RUN apt-get update -y && apt-get install software-properties-common -y \
 && add-apt-repository ppa:deadsnakes/ppa -y \
 && apt-get update -y \
 && apt-get install python3.6 -y \
 && apt-get install python3-pip -y \
 && pip3 install --upgrade pip

RUN echo "deb http://repos.mesosphere.com/${DISTRO} ${CODENAME} main" > /etc/apt/sources.list.d/mesosphere.list \
 && apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv E56151BF \
 && apt-get -y update \
 && apt-get install -y openjdk-8-jdk \
 && apt-get install -y ant \
 && apt-get install ca-certificates-java \
 && update-ca-certificates -f \
 && touch /usr/local/bin/systemctl && chmod +x /usr/local/bin/systemctl \
 && apt-get -y install --no-install-recommends "mesos=${MESOS_VERSION}*" wget libcurl3-nss \
 && apt-get -y install libatlas3-base libopenblas-base \
 && update-alternatives --set libblas.so.3 /usr/lib/openblas-base/libblas.so.3 \
 && update-alternatives --set liblapack.so.3 /usr/lib/openblas-base/liblapack.so.3 \
 && ln -sfT /usr/lib/libblas.so.3 /usr/lib/libblas.so \
 && ln -sfT /usr/lib/liblapack.so.3 /usr/lib/liblapack.so \
 && wget https://www-eu.apache.org/dist/spark/spark-${SPARK_VERSION}/spark-${SPARK_VERSION}-bin-hadoop2.7.tgz -O /tmp/spark.tgz \
 && mkdir /spark \
 && tar zxf /tmp/spark.tgz -C /spark --strip-components 1 \
 && ldconfig

ENV JAVA_HOME /usr/lib/jvm/java-8-openjdk-amd64/
ENV PATH=/spark/bin:$PATH

RUN wget https://nodejs.org/dist/v10.16.0/node-v10.16.0-linux-x64.tar.xz -O /tmp/node.tar.xz \
 && mkdir /node \
 && tar -xJvf /tmp/node.tar.xz -C /node --strip-components 1

ENV PATH=/node/bin:$PATH

RUN npm install -g configurable-http-proxy \
 && pip3 install jupyterhub \
 && pip3 install seaborn \
 && pip3 install findspark \
 && pip3 install keras \
 && pip3 install tensorflow \
 && pip3 install sklearn \
 && pip3 install matplotlib \
 && pip3 install pandas \
 && pip3 install requests \
 && pip3 install wrapt \
 && pip3 install image \
 && pip3 install mlflow

RUN wget http://apache.mirror.anlx.net/zeppelin/zeppelin-${ZEPPELIN_VERSION}/zeppelin-${ZEPPELIN_VERSION}-bin-all.tgz -O /tmp/zeppelin.tgz \
 && mkdir /zeppelin \
 && tar zxf /tmp/zeppelin.tgz -C /zeppelin --strip-components 1 \
 && apt-get remove -y wget \
 && apt-get clean -y \
 && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

ENV PATH=/zeppelin/bin:$PATH

ENV SPARK_HOME=/spark
ENV PYTHONPATH=$SPARK_HOME/python:$SPARK_HOME/python/build:$SPARK_HOME/python/lib/py4j-0.10.7-src.zip:$PYTHONPATH
ENV PYSPARK_PYTHON=/usr/bin/python3
ENV HADOOP_USER_NAME=root

RUN mkdir -p /jupyter/notebooks

#CMD "zeppelin.sh"
#CMD "jupyterhub --ip 127.0.0.1 --port 7001 --no-ss"
#ENTRYPOINT ["jupyter", "notebook",  "--allow-root", "--NotebookApp.token=''", "--no-browser", "--notebook-dir='/jupyter/notebooks'"]
