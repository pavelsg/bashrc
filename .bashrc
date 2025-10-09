# — Aliases
alias ll='ls -la'
alias k=kubectl
alias whatismyip="echo $(curl ifconfig.me 2> /dev/null)"
alias loadkeys="for key in $(ls ~/.ssh/*.pem); do ssh-add $key; done"
alias activate="source .venv/bin/activate"

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

# Java shortcuts
j8()  { export JAVA_HOME=$(/usr/libexec/java_home -v 1.8); export PATH="$JAVA_HOME/bin:$PATH"; java -version; }
j24() { export JAVA_HOME=$(/usr/libexec/java_home -v 24);  export PATH="$JAVA_HOME/bin:$PATH"; java -version; }

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

# Function to generate a random password
# Usage: genpass <length> [--no-shell-chars]
#   --no-shell-chars: Omits characters problematic in various contexts
#                     (e.g., shell, URL, query strings)
genpass() {
    local length=${1:-16} # Default to 16
    local exclude_shell_chars=0
    local char_set=''

    if [[ "$2" == "--no-shell-chars" ]]; then
        exclude_shell_chars=1
    fi

    # Define the core character sets
    local lower='a-z'
    local upper='A-Z'
    local digit='0-9'

    # Symbols that are generally safe or desired
    local safe_symbols='!*-_=~'

    # Build the full character set
    char_set="${lower}${upper}${digit}"

    if [[ "$exclude_shell_chars" -eq 0 ]]; then
        # Standard mode: Include safe symbols
        char_set="${char_set}${safe_symbols}"
    else
        # No Shell Chars mode: Define all characters to exclude.
        # This list includes original shell problems AND your requested characters.
        # Characters: ^$"`'&;|<>()[]{}#\\/ :@?%+
        # ANSI C Quoting ($'...') handles the difficult characters reliably.
        local problem_chars=$'\'^$"`;&|<>()[]{}#\\/:@?%+'

        # Start with a full set of characters
        local full_char_set="${char_set}${safe_symbols}#\\/ :@?%+"

        # Use tr to filter out the problematic characters
        char_set=$(echo "$full_char_set" | tr -d "$problem_chars")
    fi

    # Generate the password using /dev/urandom
    # tr -dc: delete all characters *except* those specified in the set
    # head -c: take only the first N characters (the desired length)
    cat /dev/urandom | tr -dc "$char_set" | head -c "$length"
    echo # Add a newline after the password
}
