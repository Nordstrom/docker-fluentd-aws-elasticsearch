# Fluentd-aws-elasticsearch

Fluentd-aws-elasticsearch collects container logs and journal logs and sends it to an aws elasticsearch endpoint. It also adds the kubernetes_metadata_filter plugin will enables collection of kubernetes metadata for container logs.

In order to enable above logs collection, mount the following paths as volumes:
    - /var/log 
    - /var/lib/docker/containers
    - /etc/kubernetes/ssl (or path where certificates for Kubernetes API server authentication are stored)