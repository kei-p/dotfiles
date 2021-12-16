DOTFILES_DIR      := $(PWD)
DOTFILES_FILES    := $(wildcard ./config/.??*)

all: install

list:
		@$(foreach val, $(DOTFILES_FILES), echo `basename $(val)`;)

link:
		@$(foreach val, $(DOTFILES_FILES), ln -sfnv $(abspath $(val)) $(HOME)/`basename $(val)`;)

init:
		@$(foreach val, $(wildcard ./init/*.sh), DOTFILES_DIR=$(DOTFILES_DIR) bash $(val);)

install: link init

update:
		git checkout master && git pull --rebase origin master
