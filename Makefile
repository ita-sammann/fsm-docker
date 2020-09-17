
FHOME  ?= $(shell pwd)

FSM=$(FHOME)/fsm-data
DATA=$(FHOME)/factorio-data
CONFIG=$(DATA)/config
MODS=$(DATA)/mods
SAVES=$(DATA)/saves


.PHONY: dirs
dirs: ## Create empty directories for volumes
	mkdir -p $(FSM) $(CONFIG) $(MODS) $(SAVES)

build:
	docker build -t $(USER)/fsm .

run:
	docker run -d \
	--name fsm \
	-p 8080:8080/tcp \
	-p 34197:34197/udp \
	-v $(FSM):/opt/fsm-data \
	-v $(SAVES):/opt/factorio/saves \
	-v $(MODS):/opt/factorio/mods \
	-v $(CONFIG):/opt/factorio/config \
	$(USER)/fsm
