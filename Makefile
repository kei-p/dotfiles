DOTFILES_DIR      := $(PWD)
DOTFILES_FILES    := $(wildcard ./config/.??*)

all: install

.PHONY: all list link bin init install update

list:
		@$(foreach val, $(DOTFILES_FILES), echo `basename $(val)`;)

link:
		@$(foreach val, $(DOTFILES_FILES), ln -sfnv $(abspath $(val)) $(HOME)/`basename $(val)`;)
		@mkdir -p $(HOME)/.config/zed
		@ln -sfnv $(abspath ./config/zed/settings.json) $(HOME)/.config/zed/settings.json
		@ln -sfnv $(abspath ./config/zed/keymap.json)   $(HOME)/.config/zed/keymap.json

bin:
		@mkdir -p $(HOME)/.local/bin
		@$(foreach val, $(wildcard ./bin/*), ln -sfnv $(abspath $(val)) $(HOME)/.local/bin/`basename $(val)`;)

init:
		@$(foreach val, $(wildcard ./init/*.sh), DOTFILES_DIR=$(DOTFILES_DIR) bash $(val);)

install: link bin init

update:
		git checkout master && git pull --rebase origin master
