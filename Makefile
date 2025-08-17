UNAME := $(shell uname)

update:
	sudo nix flake update

switch:
ifeq ($(UNAME), Darwin)
	sudo darwin-rebuild switch --flake .#
else
	sudo nixos-rebuild switch --flake .#homelab
endif
