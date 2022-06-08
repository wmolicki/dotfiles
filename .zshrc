plugins=(
    git
    zsh-autosuggestions
)


alias python=python3
alias cdr='cd $(git rev-parse --show-toplevel)'
alias grep='grep -n --color'

source <(kubectl completion zsh)

export PATH="$HOME/bin:$HOME/go/bin:$HOME/opt/nvim-linux64/bin"
