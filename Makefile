IMAGE_NAME = dolibarr
DOLIBARR_VERSION = 6.0.2
LOCAL_NAME = $(DOCKER_ID_USER)/$(IMAGE_NAME)
REMOTE_NAME = $(LOCAL_NAME):$(DOLIBARR_VERSION)

build:
	docker build --build-arg VERSION=$(DOLIBARR_VERSION) -t $(LOCAL_NAME) .

tag: build
	docker tag $(LOCAL_NAME) $(REMOTE_NAME)

push: tag
	docker push $(REMOTE_NAME)
