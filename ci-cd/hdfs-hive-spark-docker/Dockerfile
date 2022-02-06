FROM ubuntu:20.04

ARG HADOOP_VERSION=3.3.1
ARG HIVE_VERSION=3.1.2
ARG SPARK_VERSION=3.2.1

# set hadoop & java home path as env
ENV HADOOP_HOME /opt/hadoop
ENV HIVE_HOME /opt/hive
ENV SPARK_HOME /opt/spark
ENV JAVA_HOME /usr/lib/jvm/java-11-openjdk-arm64

# install packages
RUN \
  apt-get update && apt-get install -y \
  openjdk-11-jdk \
  ssh \
  vim \
  rsync \
  netcat

# download hadoop and set JAVA_HOME in hadoop-env, update path
RUN \
  wget https://dlcdn.apache.org/hadoop/common/hadoop-${HADOOP_VERSION}/hadoop-${HADOOP_VERSION}.tar.gz && \
  tar -xzf hadoop-${HADOOP_VERSION}.tar.gz && mv hadoop-${HADOOP_VERSION} ${HADOOP_HOME} && \
  echo "export JAVA_HOME=$JAVA_HOME" >> $HADOOP_HOME/etc/hadoop/hadoop-env.sh && \
  echo "PATH=$PATH:$HADOOP_HOME/bin" >> ~/.bashrc

# copy hadoop configs
ADD configs/*xml $HADOOP_HOME/etc/hadoop/

# download hive and update path
RUN \
  wget https://dlcdn.apache.org/hive/hive-${HIVE_VERSION}/apache-hive-${HIVE_VERSION}-bin.tar.gz && \
  tar -xzf apache-hive-${HIVE_VERSION}-bin.tar.gz && mv apache-hive-${HIVE_VERSION}-bin ${HIVE_HOME} && \
  echo "PATH=$PATH:$HIVE_HOME/bin" >> ~/.bashrc && echo "export HADOOP_HOME=${HADOOP_HOME} >> ${HIVE_HOME}/conf/hive-config.sh"

# create ssh keys
RUN \
  ssh-keygen -t rsa -P '' -f ~/.ssh/id_rsa && \
  cat ~/.ssh/id_rsa.pub >> ~/.ssh/authorized_keys && \
  chmod 0600 ~/.ssh/authorized_keys

# copy ssh config
ADD configs/ssh_config /root/.ssh/config

# download spark
RUN \
  wget https://archive.apache.org/dist/spark/spark-${SPARK_VERSION}/spark-${SPARK_VERSION}-bin-without-hadoop.tgz \
  tar -xz spark-${SPARK_VERSION}-bin-without-hadoop.tgz && mv spark-${SPARK_VERSION}-bin-without-hadoop.tgz ${SPARK_HOME} && \
  echo "PATH=$PATH:$SPARK_HOME/bin" >> ~/.bashrc && echo "export SPARK_DIST_CLASSPATH=$(${HADOOP_HOME}/bin/hadoop classpath) >> ${SPARK_HOME}/conf/spark-env.sh.template" && \
  mv ${SPARK_HOME}/conf/spark-env.sh.template ${SPARK_HOME}/conf/spark-env.sh


# copy script to start hadoop
ADD start-hadoop.sh start-hadoop.sh

# expose various ports
EXPOSE 8031 8030 8032 8088 8033 40661 8040 13562 8042 50070 9000 50010 50075 50020 50090 8080 8081

# start hadoop
CMD bash start-hadoop.sh
