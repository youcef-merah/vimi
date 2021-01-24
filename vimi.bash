#!/bin/bash

###############################################################################
################################### Set colors ################################
GREEN="\e[32m"
RED="\e[31m"
BLUE="\e[36m"
RESET="\e[39m"

function green {
  echo -e $GREEN$@$RESET
}

function blue {
  echo -e $BLUE$@$RESET
}

function red {
  echo -e $RED$@$RESET
}

function print_error {
  echo -e "[$(red Error)]: $@"
}

function print_info {
  echo -e "[$(blue Info)]: $@"
}

###############################################################################
############################ Variable definitions #############################
VIMRC=~/.vimrc
VIMDIR=~/.vim
BUNDLEDIR=$VIMDIR/bundle
AUTOLOADDIR=$VIMDIR/autoload

CODINGRULES_DIR="settings/clang-format"
CODINGRULES="default"
CODINGRULES_EXT="clang-format"


SETTINGS_DIR="settings/vimrc"
GENERAL_SETTINGS_FILE="$SETTINGS_DIR/general.vimrc"
PATHOGEN_SETTINGS_FILE="$SETTINGS_DIR/pathogen.vimrc"
SHORTCUTS_SETTINGS_FILE="$SETTINGS_DIR/shortcuts.vimrc"
COLORSCHEME_SETTINGS_FILE="$SETTINGS_DIR/colorscheme.vimrc"
CODINGRULES_SETTINGS_FILE="$SETTINGS_DIR/codingrules.vimrc"

PATHOGEN_CONFIG_REMOTEFILE=https://raw.githubusercontent.com/tpope/vim-pathogen/master/autoload/pathogen.vim

SETTINGS_TARGETFILE="$VIMDIR/settings.vimrc"

PLUGINS_FILE=plugins.txt
PLUGINS= #the string of plugins to download


###############################################################################
################# Import coding rules from clang file  ########################
function import_codingrules()
{
awk -F: -v q="'" -vORS="" 'BEGIN{ print "{ "}
{ if ($2 ~ /[0-9]+/)
	{ gsub(/ /,""); print q$1q " : "  $2", "; }
else
	{ gsub(/ /,""); print q$1q " : "  q$2q", " ; }
}
END{ printf " }" }' $CODINGRULES_DIR/$1.$CODINGRULES_EXT
}

###############################################################################
############################# Plugins recovering  #############################
function recover_plugins_from {

  while IFS= read -r line
  do
    PLUGINS="$PLUGINS $line"
  done < $1
}

###############################################################################
############################# Pathogen install ################################
function setup_pathogen() {

  mkdir -p $BUNDLEDIR
  mkdir -p $AUTOLOADDIR

  if [ ! -f "$AUTOLOADDIR/pathogen.vim" ]; then
    curl --silent -fLo $AUTOLOADDIR/pathogen.vim --create-dirs $PATHOGEN_CONFIG_REMOTEFILE
    if [ $? -ne 0 ]; then
      print_error "in curl.\
	Please download $PATHOGEN_CONFIG_REMOTEFILE in $AUTOLOADDIR"
	      return 1
	    else
	      print_info "pathogen.vim has been copied to $AUTOLOADDIR"
    fi
  fi

  return 0
}

###############################################################################
############################# Plugin install ##################################
function install_plugins() {

  while (( "$#" )); do
    PLUGIN_REPO=$1
    PLUGIN=${PLUGIN_REPO##*/}
    if [ ! -d "$BUNDLEDIR/$PLUGIN" ]; then
      print_info "Downloading $PLUGIN.."
      git clone --quiet $PLUGIN_REPO $BUNDLEDIR/$PLUGIN &> /dev/null && \
	print_info $(green done) || \
	print_error "Failed to download $PLUGIN_REPO"
    fi
    shift
  done
}

###############################################################################
########### Save imported coding rules in local settinsg  #####################
function load_codingrules()
{
  echo '"CodingRules: === START' > $CODINGRULES_SETTINGS_FILE
  echo "let g:clang_format#style_options = $(import_codingrules $1)" >> $CODINGRULES_SETTINGS_FILE
  echo '"=== END' >> $CODINGRULES_SETTINGS_FILE
}

###############################################################################
############################## Vimrc update ###################################
function update_vimrc() {
  touch $VIMRC
  if ! grep -q "so $SETTINGS_TARGETFILE" $VIMRC; then
    echo "so $SETTINGS_TARGETFILE" >> $VIMRC
  fi

  #build settings vimrc file from scratch
  cat $PATHOGEN_SETTINGS_FILE > $SETTINGS_TARGETFILE
  echo "" >> $SETTINGS_TARGETFILE
  cat $GENERAL_SETTINGS_FILE >> $SETTINGS_TARGETFILE
  echo "" >> $SETTINGS_TARGETFILE
  cat $CODINGRULES_SETTINGS_FILE >> $SETTINGS_TARGETFILE
  echo "" >> $SETTINGS_TARGETFILE
  cat $COLORSCHEME_SETTINGS_FILE >> $SETTINGS_TARGETFILE
  echo "" >> $SETTINGS_TARGETFILE
  cat $SHORTCUTS_SETTINGS_FILE >> $SETTINGS_TARGETFILE
}


###############################################################################
################################# MAIN ########################################
###############################################################################
recover_plugins_from $PLUGINS_FILE
setup_pathogen
if [ $? -eq 0 ]; then
  print_info "Pathogen is installed."
  install_plugins $PLUGINS
  load_codingrules $CODINGRULES
  print_info "$CODINGRULES coding rules imported"
  update_vimrc
  print_info $(green "Success.")
fi
