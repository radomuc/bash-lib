# vim: noexpandtab

PRECOMMIT_VERSION="2.20.0"
TFLINT_VERSION="0.41.0"

.PHONY: pre-commit help all

help:
	@echo "usage: make [help|all|pre-commit|install-tools]"
	@echo ""
	@echo "help             show this help"
	@echo "all              perform all tasks"
	@echo "pre-commit       install & setup pre-commit within repository"

all: pre-commit

pre-commit:
	wget -O pre-commit.pyz https://github.com/pre-commit/pre-commit/releases/download/v${PRECOMMIT_VERSION}/pre-commit-${PRECOMMIT_VERSION}.pyz
	python3 pre-commit.pyz install
	python3 pre-commit.pyz install --hook-type commit-msg
	rm pre-commit.pyz
