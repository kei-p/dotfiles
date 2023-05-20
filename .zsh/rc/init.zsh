if [[ "${+commands[asdf]}" == 1 ]]
then
  source $(brew --prefix asdf)/libexec/asdf.sh
fi

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
