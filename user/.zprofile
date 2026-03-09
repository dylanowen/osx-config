# . ~/lab/osx-config/user/.zprofile

export CODE_HOME="${HOME}/code"
export LAB_HOME="${HOME}/lab"
export AI_CODE_HOME="${CODE_HOME}/ai"

# Generic Aliases
alias watch='watch'
alias ls='ls -G'
alias profile='subl ~/.zprofile'
alias layout='hyperlayout'
alias publickey='key=$(cat ~/.ssh/id_rsa.pub) ; echo \`\`\`$key\`\`\` | pbcopy'
alias rr='rustrover'
alias retry='while [ $? -ne 0 ]; do eval $(history -p !!); done'

# Folder Aliases
alias code='cd "${CODE_HOME}"'
alias lab='cd "${LAB_HOME}"'
alias ai='cd "${AI_CODE_HOME}"'

# Port Checking
port() {
   results=$(lsof -Pni :"${1}")
   if [[ ${results} ]]; then
      echo ${results}
   else
      echo "No results, trying sudo"
      sudo lsof -Pni :"$1"
   fi
}

gw() {
  local dir="$PWD"

  while true; do
    if [ -x "$dir/gradlew" ]; then
      (cd "$dir" && ./gradlew "$@")
      return $?
    fi

    # reached filesystem root
    if [ "$dir" = "/" ]; then
      echo "⚠️ gradlew not found" >&2
      return 1
    fi

    dir="$(dirname "$dir")"
  done
}

gitdea() {
  if [ -z "$1" ]; then
    echo "Usage: gitdea <git-url>"
    return 1
  fi

  repo_url="$1"

  # Extract repo name (strip .git if present)
  repo_name=$(basename -s .git "$repo_url")

  git clone "$repo_url" && idea "$repo_name"
}

gitclaude() {
   if [ -z "$1" ]; then
    echo "Usage: gitdea <git-url>"
    return 1
  fi

  repo_url="$1"

  # Extract repo name (strip .git if present)
  repo_name=$(basename -s .git "$repo_url")

  git clone "$repo_url" && cd "$repo_name" && claude
}

# Added by Toolbox App
export PATH="$PATH:/Users/dylan.owen/Library/Application Support/JetBrains/Toolbox/scripts"