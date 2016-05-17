# Fluentd-aws-elasticsearch

Fluentd-aws-elasticsearch collects container logs and journal logs and sends it to an aws elasticsearch endpoint. It adds the kubernetes_metadata_filter plugin that enables collection of kubernetes metadata for container logs. It also add the fluent-plugin-systemd plugin that reads logs from systemd journal.

In order to enable above logs collection, mount the following paths as volumes:
    - /var/log 
    - /var/lib/docker/containers

Refer the following links for reference:
    - [docker-fluentd-kubernetes] (https://github.com/fabric8io/docker-fluentd-kubernetes)
    - [fluent-plugin-kubernetes_metadata_filter] (https://github.com/fabric8io/fluent-plugin-kubernetes_metadata_filter) 
    - [fluent-plugin-aws-elasticsearch-service] (https://github.com/atomita/fluent-plugin-aws-elasticsearch-service)
    - [fluent-plugin-systemd] (https://github.com/reevoo/fluent-plugin-systemd)
