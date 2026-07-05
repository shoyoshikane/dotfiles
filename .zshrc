eval "$(starship init zsh)"
eval "$(zoxide init zsh)"

if command -v fzf >/dev/null 2>&1; then
  source "$(brew --prefix fzf)/shell/key-bindings.zsh"
  source "$(brew --prefix fzf)/shell/completion.zsh"
fi

fpath=("$HOME/.config/zsh/rc/functions/aws" $fpath)
autoload -Uz set-aws-profile

alias awsp='set-aws-profile'
alias ll='ls -la'
