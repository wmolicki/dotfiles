plugins=(
    git
    zsh-autosuggestions
)

export PATH="$HOME/bin:/opt/homebrew/opt/python@3.10/bin:/Users/wm/go/bin:$PATH"

alias python=python3
alias cdr='cd $(git rev-parse --show-toplevel)'
alias grep='grep -n --color'

source <(kubectl completion zsh)
