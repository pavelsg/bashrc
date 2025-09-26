# — Aliases
alias ll='ls -la'
alias k=kubectl
alias whatismyip="echo $(curl ifconfig.me 2> /dev/null)"

# — Bash completion
if [ -f /etc/bash_completion ]; then
  source /etc/bash_completion
fi
if [ -f "$(brew --prefix)/etc/profile.d/bash_completion.sh" ]; then
  . "$(brew --prefix)/etc/profile.d/bash_completion.sh"
fi
source <(kubectl completion bash)
complete -o default -F __start_kubectl k

# — Prompt colors
RED='\[\e[31m\]'      # red
GREEN='\[\e[32m\]'    # green
YELLOW='\[\e[33m\]'   # yellow
BLUE='\[\e[34m\]'     # blue
RESET='\[\e[0m\]'     # reset

# — Git branch helper
parse_git_branch() {
  local branch
  branch=$(git rev-parse --abbrev-ref HEAD 2>/dev/null)
  if [ -n "$branch" ]; then
    printf " (%s)" "$branch"
  fi
}

# — PS1: user@host cwd (branch) $
export PS1="${GREEN}\u@\h ${BLUE}\w${YELLOW}\$(parse_git_branch) ${RESET}\$ "

if [ -f ~/.jekyllrc ]; then
  source ~/.jekyllrc
fi
