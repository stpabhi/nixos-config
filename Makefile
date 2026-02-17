UNAME := $(shell uname)
RUN_AS_USER ?= $(if $(SUDO_USER),$(SUDO_USER),$(shell id -un))

update:
	nix flake update

switch:
ifeq ($(UNAME), Darwin)
	nix build --impure ".#darwinConfigurations.mac-mini.system"
	sudo -H env USER=$(RUN_AS_USER) LOGNAME=$(RUN_AS_USER) ./result/sw/bin/darwin-rebuild switch --impure --flake .#mac-mini
else
	sudo nixos-rebuild switch --impure --specialisation gnome --flake .#homelab
endif
