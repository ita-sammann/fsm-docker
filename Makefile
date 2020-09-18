
FHOME  ?= $(shell pwd)

FSM=$(FHOME)/fsm-data
DATA=$(FHOME)/factorio-data
CONFIG=$(DATA)/config
MODS=$(DATA)/mods
SAVES=$(DATA)/saves

.PHONY: all
all: dirs build run

.PHONY: dirs
dirs: ## Create empty directories for volumes
	mkdir -p $(FSM) $(CONFIG) $(MODS) $(SAVES)


.PHONY: build
build:
	docker build -t $(USER)/fsm .


.PHONY: run
run:
	docker run -d --rm \
	--name fsm \
	-p 8080:80/tcp \
	-p 34197:34197/udp \
	-v $(FSM):/opt/fsm-data \
	-v $(SAVES):/opt/factorio/saves \
	-v $(MODS):/opt/factorio/mods \
	-v $(CONFIG):/opt/factorio/config \
	$(USER)/fsm
