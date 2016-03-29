FROM nordstrom/baseimage-ubuntu:16.04
MAINTAINER Innovation Platform Team "invcldtm@nordstrom.com"

# Ensure there are enough file descriptors for running Fluentd.
RUN ulimit -n 65536

# Disable prompts from apt.
ENV DEBIAN_FRONTEND noninteractive

# Setup package for installing td-agent. (For more info https://td-toolbelt.herokuapp.com/sh/install-ubuntu-trusty-td-agent2.sh)
ADD https://packages.treasuredata.com/GPG-KEY-td-agent /tmp/apt-key
RUN apt-key add /tmp/apt-key
RUN echo "deb http://packages.treasuredata.com/2/ubuntu/trusty/ trusty contrib" > /etc/apt/sources.list.d/treasure-data.list

# Install prerequisites.
RUN apt-get update && \
    apt-get install -y -q curl make g++ && \
    apt-get clean && \
    apt-get install -y td-agent && \
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# Change the default user and group to root.
# Needed to allow access to /var/log/docker/... files.
RUN sed -i -e "s/USER=td-agent/USER=root/" -e "s/GROUP=td-agent/GROUP=root/" /etc/init.d/td-agent

# Install the fluent-plugin-kubernetes_metadata_filter plug-in.
RUN td-agent-gem install fluent-plugin-kubernetes_metadata_filter

# Install the aws-elasticsearch-service plugin (https://github.com/atomita/fluent-plugin-aws-elasticsearch-service).
RUN /usr/sbin/td-agent-gem install fluent-plugin-aws-elasticsearch-service -v 0.1.4

# Install the systemd plugin (https://github.com/reevoo/fluent-plugin-systemd).
RUN /usr/sbin/td-agent-gem install fluent-plugin-systemd -v 0.0.2

# Copy the Fluentd configuration file.
COPY td-agent.conf /etc/td-agent/td-agent.conf
COPY start-fluentd /start-fluentd

# Run the Fluentd service.
ENTRYPOINT ["/start-fluentd"]
