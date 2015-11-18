DOTFILES_EXCLUDES := .DS_Store .git .gitignore
DOTFILES_TARGET   := $(wildcard .??*)
DOTFILES_DIR      := $(PWD)
DOTFILES_FILES    := $(filter-out $(DOTFILES_EXCLUDES), $(DOTFILES_TARGET))

deploy:
		@$(foreach val, $(DOTFILES_FILES), ln -sfnv $(abspath $(val)) $(HOME)/$(val);)

init:
		@$(foreach val, $(wildcard ./etc/init/*.sh), DOTFILES_DIR=$(DOTFILES_DIR) bash $(val);)

list:
		@$(foreach val, $(DOTFILES_FILES), /bin/ls -dF $(val);)
