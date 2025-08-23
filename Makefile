UNAME := $(shell uname)

update:
	sudo nix flake update

switch:
ifeq ($(UNAME), Darwin)
	nix build --impure ".#darwinConfigurations.mac-mini.system"
	sudo ./result/sw/bin/darwin-rebuild switch --impure --flake .#mac-mini
else
	sudo nixos-rebuild switch --impure --specialisation gnome --flake .#homelab
endif
