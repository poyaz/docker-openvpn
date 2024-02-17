BUILD_EXTRA_ARGS ?=
IMAGE_NAME = poyaz/openvpn

.PHONY: build-image
build-image:
	docker build $(BUILD_EXTRA_ARGS) -t $(IMAGE_NAME):$$(cat VERSION | tr -d '\n') ./docker/images/openvpn
	docker build $(BUILD_EXTRA_ARGS) -t $(IMAGE_NAME):latest ./docker/images/openvpn

.PHONY: push-image
push-image:
	docker push $(IMAGE_NAME):$$(cat VERSION | tr -d '\n')
	docker push $(IMAGE_NAME):latest