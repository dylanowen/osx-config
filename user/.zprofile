# . ~/code/osx-config/user/.zprofile

export CODE_HOME="${HOME}/code"

# Generic Aliases
alias watch='watch'
alias ls='ls -G'
alias profile='subl ~/.zprofile'
alias layout='hyperlayout'
alias publickey='key=$(cat ~/.ssh/id_rsa.pub) ; echo \`\`\`$key\`\`\` | pbcopy'
alias rr='rustrover'
alias retry='while [ $? -ne 0 ]; do eval $(history -p !!); done'

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

# Folder Aliases
alias code='cd "${CODE_HOME}"'

# Added by Toolbox App
export PATH="$PATH:/Users/dylan.owen/Library/Application Support/JetBrains/Toolbox/scripts"