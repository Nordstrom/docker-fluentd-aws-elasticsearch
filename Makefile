container_name := fluentd-aws-elasticsearch
container_registry := quay.io/nordstrom
container_release := 1.1

.PHONY: build/image tag/image push/image

build/image:
	docker build \
		--build-arg http_proxy=http://webproxy.nordstrom.net:8181 \
		--build-arg https_proxy=http://webproxy.nordstrom.net:8181 \
		-t $(container_name) .

tag/image: build/image
	docker tag $(container_name) $(container_registry)/$(container_name):$(container_release)

push/image: tag/image
	docker push $(container_registry)/$(container_name):$(container_release)