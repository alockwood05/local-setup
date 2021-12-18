#!/bin/sh

ZSHRC="$HOME/.zshrc"
LOG_PREFIX="Local-Setup zsh/install"
ZSHRC="$HOME/.zshrc"
ZSHRC_BKP="$HOME/.zshrc.bkp"

#logging fn that doesn't interupt any output, thought it was cool and made sense
# https://stackoverflow.com/questions/3524978/logging-functions-in-bash-and-stdout
exec 3>&1
log ()
{
    echo "[$LOG_PREFIX] $1" 1>&3
}

#set the cwd for the commands
parent_path=$( cd "$(dirname "${BASH_SOURCE[0]}")" ; pwd -P )
cd "$parent_path"

#install ohmyzzsh
sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" && log "OH MY ZSH installed" || log "OH MY ZSH not installed/reinstalled"

#backup and symlink
touch -a $ZSHRC
if [[ ! -L $ZSHRC ]]; then
  # remove old backup if exists
  [[ ! -e $ZSMRC_BKP ]] || rm $ZSHRC_BKP && log "Removed pre-existing backup $ZSHRC_BKP"
  mv $ZSHRC $ZSHRC_BKP && log "Created backup: $ZSHRC => $ZSHRC_BKP"

  # Symlink
  ln -s $(pwd)/.zshrc $ZSHRC && log "Simlinked ~/.zshrc -> $ZSHRC"
fi

log "Done!"
