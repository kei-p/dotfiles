mkdir -p ~/git-hooks/hooks

# git completion (third-party / GPL, not committed)
COMPLETIONS_DIR=${HOME}/.zsh/completions
mkdir -p "$COMPLETIONS_DIR"
GIT_COMPLETION_REF=master
curl -fsSL "https://raw.githubusercontent.com/git/git/${GIT_COMPLETION_REF}/contrib/completion/git-completion.bash" -o "$COMPLETIONS_DIR/git-completion.bash"
curl -fsSL "https://raw.githubusercontent.com/git/git/${GIT_COMPLETION_REF}/contrib/completion/git-completion.zsh" -o "$COMPLETIONS_DIR/_git"

