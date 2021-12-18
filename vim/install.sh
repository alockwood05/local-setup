#!/bin/bash

########################################
# Config for tweaking
LOG_PREFIX="Local-Setup vim/install.sh"
VIMRC="$HOME/.vimrc"
VIMRC_BKP="$HOME/.vimrc.bkp"
FONTS_REPO="git@github.com:powerline/fonts.git"
FONTS_PATH="fonts"
FONTS_SH="./fonts/install.sh"


########################################
# prep

# https://stackoverflow.com/questions/3524978/logging-functions-in-bash-and-stdout
exec 3>&1
log ()
{
    echo "[$LOG_PREFIX] $1" 1>&3
}

# current directory set
parent_path=$( cd "$(dirname "${BASH_SOURCE[0]}")" ; pwd -P )
cd "$parent_path"

########################################
# vim config setup
touch -a $VIMRC
if [[ ! -L $VIMRC ]]; then
  # remove old backup if exists, don't throw
  [[ ! -e $VIMRC_BKP ]] || rm $VIMRC_BKP && log "Removed pre-existing backup $VIMRC_BKP"
  mv $VIMRC $VIMRC_BKP && log "Created backup: $VIMRC => $VIMRC_BKP"

  # Symlink
  ln -s $(pwd)/.vimrc $VIMRC && log "Simlinked ~/.vimrc -> $VIMRC"
else
  log "[$VIMRC] Symlink exists. `rm $VIMRC`"
fi

######################################
# install required fonts
if [[ ! -d "fonts" ]]; then
  git clone $FONTS_REPO $FONTS_DIRNAME && $FONTS_SH && log "Powerline fonts installed" || log "Powerline fonts failed "
else
  log "FONTS `$FONTS_PATH` folder exists, skipping"
fi

#######################################
#install Plugins
vim +'PlugInstall --sync' +qa

######################################
log "Done!"
