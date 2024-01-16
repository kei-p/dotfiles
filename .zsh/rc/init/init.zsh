# direnv
if which direnv > /dev/null
then
  eval "$(direnv hook zsh)"
fi

# git-completion
fpath=(
  ${HOME}/.zsh/completions
  ${fpath}
)
autoload -Uz compinit
compinit

# iterm2 prompt
precmd() {
  echo -ne "\033]0;$(pwd | sed -e "s;$HOME\/;~/;g")\007"
}

export STARSHIP_CONFIG=${DOTFILES_DIR}/config/starship.toml
eval "$(starship init zsh)"

eval "$(mise activate zsh)"
