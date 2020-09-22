REGION ?= us-east-1
CLUSTER ?= staging
SERVICE_NAME ?= ${SERVICE_PATH}
IMAGE ?= ${SERVICE_NAME}
DOCKER_REGISTRY ?= 066711790438.dkr.ecr.us-east-1.amazonaws.com
HEAD ?= $(shell git rev-parse HEAD)
BASE_REF ?= ${CI_DEFAULT_BRANCH:-master}

export AWS_PAGER =
RESTART_SERVICE := aws ecs update-service \
	--force-new-deployment \
	--cluster ${CLUSTER} \
	--region ${REGION} \
	--service

ifeq ($(shell uname),Darwin)
	WHICH := which -s
	PIP := pip3
	PIP_PKG := python
	PIP_INSTALL := $(PIP) install --user
	PKG_INSTALL := brew install
	TIME := time
else
	WHICH := which
	PIP := pip
	PIP_PKG := py-pip
	PIP_INSTALL := $(PIP) install
	PKG_INSTALL := apk add --no-cache
	TIME := /usr/bin/time -f '[TIME] %e seconds (%E): %C'
endif

PUSH := $(TIME) docker push
PULL := docker pull

.PHONY: install
install: |
	$(WHICH) curl || $(PKG_INSTALL) curl
	$(WHICH) $(PIP) || $(PKG_INSTALL) ${PIP_PKG}
	$(WHICH) aws  || $(PIP_INSTALL) awscli

.PHONY: docker-login
docker-login: |
	aws ecr get-login-password --region us-east-1 | docker login --username AWS --password-stdin ${DOCKER_REGISTRY}/${IMAGE}

# pull image $FROM from registry
.PHONY: pull-image
pull-image: | docker-login
	$(PULL) ${DOCKER_REGISTRY}/${FROM} || true

# push local image $FROM to registry as $TO
.PHONY: push-image
push-image: | docker-login
	docker tag ${FROM} ${DOCKER_REGISTRY}/${TO}
	$(PUSH) ${DOCKER_REGISTRY}/${TO}

# pull image $FROM from registry and push as $TO
.PHONY: retag-image
retag-image: | pull-image
	docker tag ${DOCKER_REGISTRY}/${FROM} ${DOCKER_REGISTRY}/${TO}
	$(PUSH) ${DOCKER_REGISTRY}/${TO}

# restart ECS service
.PHONY: restart-service
restart-service: |
	echo ${SERVICE_NAME} ${SERVICE_ALIASES} | xargs -n 1 $(RESTART_SERVICE)

#
# Pipeline
#

# calculate latest common ancestor between $BASE_REF and $HEAD
.PHONY: pipeline-get-base
pipeline-get-base: |
	@git cat-file -e ${BEFORE} 2> /dev/null && \
		echo ${BEFORE} || \
		(git fetch -q --unshallow origin ${BASE_REF} > /dev/null 2&>1; git merge-base ${HEAD} origin/${BASE_REF})

.PHONY: pipeline-setup
pipeline-setup: | install

.PHONY: pipeline-ci-%
pipeline-ci-%: |
	$(TIME) $(MAKE) --directory ${SERVICE_PATH} ci-$*

# push build tagged as $HEAD and latest
.PHONY: pipeline-push-build
pipeline-push-build:
pipeline-push-build: |
	FROM=${IMAGE}:latest TO=${IMAGE}:${HEAD} $(MAKE) push-image
	FROM=${IMAGE}:latest TO=${IMAGE}:latest  $(MAKE) push-image

.PHONY: pipeline-deploy
pipeline-deploy: |
	FROM=${IMAGE}:${CLUSTER} TO=${IMAGE}:${CLUSTER}-rollback $(MAKE) retag-image
	FROM=${IMAGE}:${HEAD} 	 TO=${IMAGE}:${CLUSTER} 				 $(MAKE) retag-image restart-service

NAME := docs 
BUILD := docker build
BUILDX := docker buildx
RUN := docker-compose run --rm
TEST := -e CGO_ENABLED=0 -e GOOS=linux -e TEST_MODE=true

clean:
	docker-compose down --volumes --remove-orphans
	rm -rf vendor/

#
# CI Build
#

.PHONY: ci-build
ci-build: | clean
	$(BUILD) -t $(NAME):latest .

.PHONY: build
build: 
	docker buildx build -t api-docs:latest --target=artifact --output type=local,dest=$(PWD)/out .

ci-test: | start-test-environment test-integration

#
# Development
#

run:
	bundle exec middleman build --clean	
