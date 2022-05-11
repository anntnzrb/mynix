# Makefile --- GNU Makefile

# -----------------------------------------------------------------------------
# variables
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

all:
	@printf '\n-------------------------------------------------------------------------------\n'
	@printf '===> Hosts:\n'
	@printf '-----------\n'
	@printf 'Munich -- desktop PC (main driver)\n'
	@printf 'Solna  -- very underpowered travelling laptop\n'
	@printf 'Zadar  -- main laptop\n'
	@printf '-------------------------------------------------------------------------------\n'
	@printf 'Refer to READMEs for extra detail\n'
	@printf '-------------------------------------------------------------------------------\n'
	@printf '===> Install:\n'
	@printf '-------------\n'
	@printf 'make host/switch\n'

update:
	nix flake update

clean:
	-@rm ./result 2>/dev/null

munich/switch: clean
	$(call build_switch_flake,"munich")

solna/switch: clean
	$(call build_switch_flake,"solna")

zadar/switch: clean
	$(call build_switch_flake,"zadar")

.PHONY: all update clean
