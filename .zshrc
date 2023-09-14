#
# .zshrc
#
# @author Jeff Geerling
#

# Colors.
# unset LSCOLORS
# export CLICOLOR=1
# export CLICOLOR_FORCE=1

# Don't require escaping globbing characters in zsh.
unsetopt nomatch

function parse_git_branch {
    git branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/ (\1)/'
}


function parse_git_branch {
    git branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/ (\1)/'
}

# Nicer prompt.
# : Displays an apple logo (or a similar character depending on the font and terminal you're using).
# %*: Displays the current time in 24-hour format (hh:mm).
# %3~: Displays the current working directory, but only the last three components of the directory path (if the path is very long).
COLOR_DEF=$'%f'
COLOR_TIME=$'%F{green}'
COLOR_DIR=$'%F{yellow}'
COLOR_GIT=$'%F{blue}'
NEW_LINE=$'%{\n%}'
setopt PROMPT_SUBST
export PROMPT='${COLOR_TIME} %* ${COLOR_DIR}%3~${COLOR_GIT}$(parse_git_branch)${COLOR_DEF}${NEW_LINE} $ '


# Enable plugins.
# plugins=(git brew history kubectl history-substring-search)

# Custom $PATH with extra locations.
export PATH=/opt/homebrew/bin:/usr/local/bin:/usr/local/sbin:$HOME/bin:$HOME/go/bin:/usr/local/git/bin:$HOME/.composer/vendor/bin:$PATH

# Bash-style time output.
export TIMEFMT=$'\nreal\t%*E\nuser\t%*U\nsys\t%*S'

# Include alias file (if present) containing aliases for ssh, etc.
if [ -f ~/.aliases ]
then
  source ~/.aliases
fi

# Include secrets file
if [ -f ~/.secrets ]
then
  source ~/.secrets
fi

if [ -f ~/code/kubectl-aliases/.kubectl_aliases ]
then
  source ~/code/kubectl-aliases/.kubectl_aliases
fi

if [ -f /Users/tommy.couzens/code/dotfiles/kubectl_shortcuts.sh ]
then
  source /Users/tommy.couzens/code/dotfiles/kubectl_shortcuts.sh
fi

if [ -f ~/.dot-cli.sh ]
then
  source ~/.dot-cli.sh
fi

# Set architecture-specific brew share path.
arch_name="$(uname -m)"
if [ "${arch_name}" = "x86_64" ]; then
    share_path="/usr/local/share"
elif [ "${arch_name}" = "arm64" ]; then
    share_path="/opt/homebrew/share"
else
    echo "Unknown architecture: ${arch_name}"
fi

# Allow history search via up/down keys.
# source ${share_path}/zsh-history-substring-search/zsh-history-substring-search.zsh
# bindkey "^[[A" history-substring-search-up
# bindkey "^[[B" history-substring-search-down



# Git aliases.
alias gs='git status'
alias gc='git commit'
alias gp='git pull --rebase'
alias gcam='git commit -am'
alias gl='git log --graph --pretty=format:"%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset" --abbrev-commit'

# Completions.
autoload -Uz compinit && compinit
# Case insensitive.
zstyle ':completion:*' matcher-list 'm:{[:lower:][:upper:]}={[:upper:][:lower:]}' 'm:{[:lower:][:upper:]}={[:upper:][:lower:]} l:|=* r:|=*' 'm:{[:lower:][:upper:]}={[:upper:][:lower:]} l:|=* r:|=*' 'm:{[:lower:][:upper:]}={[:upper:][:lower:]} l:|=* r:|=*'

# Git upstream branch syncer.
# Usage: gsync master (checks out master, pull upstream, push origin).
function gsync() {
 if [[ ! "$1" ]] ; then
     echo "You must supply a branch."
     return 0
 fi

 BRANCHES=$(git branch --list $1)
 if [ ! "$BRANCHES" ] ; then
    echo "Branch $1 does not exist."
    return 0
 fi

 git checkout "$1" && \
 git pull upstream "$1" && \
 git push origin "$1"
}

# Tell homebrew to not autoupdate every single time I run it (just once a week).
export HOMEBREW_AUTO_UPDATE_SECS=604800

# Super useful Docker container oneshots.
# Usage: dockrun, or dockrun [centos7|fedora27|debian9|debian8|ubuntu1404|etc.]
dockrun() {
 docker run -it geerlingguy/docker-"${1:-ubuntu1604}"-ansible /bin/bash
}

# Enter a running Docker container.
function denter() {
 if [[ ! "$1" ]] ; then
     echo "You must supply a container ID or name."
     return 0
 fi

 docker exec -it $1 bash
 return 0
}

# Delete a given line number in the known_hosts file.
knownrm() {
 re='^[0-9]+$'
 if ! [[ $1 =~ $re ]] ; then
   echo "error: line number missing" >&2;
 else
   sed -i '' "$1d" ~/.ssh/known_hosts
 fi
}

# Allow Composer to use almost as much RAM as Chrome.
export COMPOSER_MEMORY_LIMIT=-1

# Ask for confirmation when 'prod' is in a command string.
#prod_command_trap () {
#  if [[ $BASH_COMMAND == *prod* ]]
#  then
#    read -p "Are you sure you want to run this command on prod [Y/n]? " -n 1 -r
#    if [[ $REPLY =~ ^[Yy]$ ]]
#    then
#      echo -e "\nRunning command \"$BASH_COMMAND\" \n"
#    else
#      echo -e "\nCommand was not run.\n"
#      return 1
#    fi
#  fi
#}
#shopt -s extdebug
#trap prod_command_trap DEBUG


export MCFLY_RESULTS_SORT=LAST_RUN



export PATH="$PATH:/Library/Frameworks/Python.framework/Versions/3.10/bin"

# export PATH=/opt/homebrew/bin:/opt/homebrew/bin:/usr/local/bin:/usr/local/sbin:/Users/tommy.couzens/bin:/Users/tommy.couzens/go/bin:/usr/local/git/bin:/Users/tommy.couzens/.composer/vendor/bin:/opt/homebrew/bin:/usr/local/bin:/usr/local/sbin:/Users/tommy.couzens/bin:/Users/tommy.couzens/go/bin:/usr/local/git/bin:/Users/tommy.couzens/.composer/vendor/bin:/usr/local/bin:/System/Cryptexes/App/usr/bin:/usr/bin:/bin:/usr/sbin:/sbin:/var/run/com.apple.security.cryptexd/codex.system/bootstrap/usr/local/bin:/var/run/com.apple.security.cryptexd/codex.system/bootstrap/usr/bin:/var/run/com.apple.security.cryptexd/codex.system/bootstrap/usr/appleinternal/bin:/opt/homebrew/bin:/usr/local/sbin:/Users/tommy.couzens/bin:/Users/tommy.couzens/go/bin:/usr/local/git/bin:/Users/tommy.couzens/.composer/vendor/bin
# export PATH=/opt/homebrew/bin:/opt/homebrew/bin:/usr/local/bin:/usr/local/sbin:/Users/tommy.couzens/bin:/Users/tommy.couzens/go/bin:/usr/local/git/bin:/Users/tommy.couzens/.composer/vendor/bin:/usr/local/bin:/System/Cryptexes/App/usr/bin:/usr/bin:/bin:/usr/sbin:/sbin:/var/run/com.apple.security.cryptexd/codex.system/bootstrap/usr/local/bin:/var/run/com.apple.security.cryptexd/codex.system/bootstrap/usr/bin:/var/run/com.apple.security.cryptexd/codex.system/bootstrap/usr/appleinternal/bin