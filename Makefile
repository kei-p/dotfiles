DOTFILES_EXCLUDES := .DS_Store .git .gitignore
DOTFILES_TARGET   := $(wildcard .??*)
DOTFILES_DIR      := $(PWD)
DOTFILES_FILES    := $(filter-out $(DOTFILES_EXCLUDES), $(DOTFILES_TARGET))

all: install

list:
		@$(foreach val, $(DOTFILES_FILES), /bin/ls -dF $(val);)

deploy:
		@$(foreach val, $(DOTFILES_FILES), ln -sfnv $(abspath $(val)) $(HOME)/$(val);)

init:
		@$(foreach val, $(wildcard ./etc/init/*.sh), DOTFILES_DIR=$(DOTFILES_DIR) bash $(val);)

install: deploy init

update:
		git checkout master && git pull --rebase origin master
