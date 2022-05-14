# Makefile --- GNU Makefile

# -----------------------------------------------------------------------------
# variables
# -----------------------------------------------------------------------------
# -----------------------------------------------------------------------------

BUILD_FLAKE=nixos-rebuild build --flake
SWITCH=nixos-rebuild --use-remote-sudo switch --flake

# -----------------------------------------------------------------------------
# functions
# -----------------------------------------------------------------------------

define hostname_equals
	test `cat /etc/hostname` = ${1}
endef

define build_switch_flake
	$(call hostname_equals,${1})
	${BUILD_FLAKE} .#$1
	${SWITCH}      .#$1
endef

# -----------------------------------------------------------------------------
# targets
# -----------------------------------------------------------------------------

all:
	@printf '\n=============================================================================\n'
	@printf '*** Hosts: ***\n'
	@printf '* Refer to READMEs for extra details on hosts\n'
	@printf '* Install ==> $$ make host/switch (i.e dublin/switch)\n'
	@printf '-----------------------------------------------------\n'
	@printf 'Munich -- desktop PC (main driver)\n'
	@printf 'Solna  -- very underpowered travelling laptop\n'
	@printf 'Zadar  -- main laptop\n'
	@printf '-------------------------------------------------------------------------------\n'
	@printf '===> Update:\n'
	@printf '------------\n'
	@printf '$$ make update\n'
	@printf '-------------------------------------------------------------------------------\n'
	@printf '===> Clean:\n'
	@printf '* Deletes all non-current generations & garbage collects\n'
	@printf '--------------------------------------------------------\n'
	@printf '$$ make clean\n'
	@printf '-------------------------------------------------------------------------------\n'
	@printf '===> Optimise:\n'
	@printf '* Optimises the nix-store\n'
	@printf '-------------------------\n'
	@printf '$$ make optimise\n'
	@printf '===============================================================================\n'

update:
	nix flake update

clean:
	nix-env --delete-generations old
	nix-store --gc

optimise:
	nix-store --optimise

clean-repo:
	-@rm ./result 2>/dev/null

munich/switch: clean-repo
	$(call build_switch_flake,"munich")

solna/switch: clean-repo
	$(call build_switch_flake,"solna")

zadar/switch: clean-repo
	$(call build_switch_flake,"zadar")

.PHONY: all update clean optimise clean-repo
