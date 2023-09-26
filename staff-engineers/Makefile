VERSION := 6
OLLAMA_MODEL_VERSION:= 2

.PHONY: build

build:
	@echo staff-engineers-$(VERSION)
	OLLAMA_MODEL_VERSION=$(OLLAMA_MODEL_VERSION) ollama create staff-engineers-$(VERSION) -f ./Modelfile

