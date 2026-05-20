export DOTFILES_DIR=${DOTFILES_DIR:-~/dotfiles)}
export SHELDON_CONFIG_FILE=${DOTFILES_DIR}/config/sheldon/plugins.toml
export ENHANCD_FILTER="fzf --height 40% --reverse:fzy"

eval "$(sheldon source)"

eval "$(mise activate --shims)"
