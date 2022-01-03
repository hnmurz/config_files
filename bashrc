# This file is sourced by all *interactive* bash shells on startup,
# including some apparently interactive shells such as scp and rcp
# that can't tolerate any output.  So make sure this doesn't display
# anything or bad things will happen !
# Load mtime at bash start-up
export BASHRC_MTIME=$(stat ~/.bashrc_s --format="%Z")
PROMPT_COMMAND="check_and_reload_bashrc"
check_and_reload_bashrc () {
    if [ "$(stat ~/.bashrc_s --format="%Z")" != $BASHRC_MTIME ]; then
        export BASHRC_MTIME="$(stat ~/.bashrc_s --format="%Z")"
        echo "bashrc changed. re-sourcing..." >&2
        . ~/.bashrc
    fi
}

alias vi="vim"
alias cd=cd_func
alias sudo="sudo "
alias ls="ls --color"
alias Grep="grep"
alias ag='\ag --pager="less -XFR"'
alias mod_song="/home/sp00ky/multimedia/downloads/moosic/command.sh"
alias ysrc='cd /localdisk/hmuresan/yocto/source/valimar'
alias mygtags='find . -name "*.c" -or -name "*.h" | gtags -f -;'
alias gtagspython="gtags --gtagslabel pygments"
alias ybld='cd /localdisk/hmuresan/yocto/builds'
alias ybld2='cd /localdata/hmuresan/yocto/builds'
alias less="less -Ni"
alias mybld="cd /localdisk/hmuresan/my_builds/"
alias bb2="bb -b /localdisk/hmuresan/yocto/source/valimar2"
alias edit="emacsclient -n"


# Test for an interactive shell.  There is no need to set anything
# past this point for scp and rcp, and it's important to refrain from
# outputting anything in those cases.
if [[ $- != *i* ]] ; then
	# Shell is non-interactive.  Be done now!
	return
fi

gl () {
	find -name "*.c" -or -name "*.h" | xargs grep -rin $1 | less
}

# This function defines a 'cd' replacement function capable of keeping,
# displaying and accessing history of visited directories, up to 10 entries.
# To use it, uncomment it, source this file and try 'cd --'.
# acd_func 1.0.5, 10-nov-2004
# Petar Marinov, http:/geocities.com/h2428, this is public domain
cd_func ()
{
  local x2 the_new_dir adir index
  local -i cnt

  if [[ $1 ==  "--" ]]; then
    dirs -v
    return 0
  fi

  the_new_dir=$1
  [[ -z $1 ]] && the_new_dir=$HOME

  if [[ ${the_new_dir:0:1} == '-' ]]; then
    #
    # Extract dir N from dirs
    index=${the_new_dir:1}
    [[ -z $index ]] && index=1
    adir=$(dirs +$index)
    [[ -z $adir ]] && return 1
    the_new_dir=$adir
  fi

  #
  # '~' has to be substituted by ${HOME}
  [[ ${the_new_dir:0:1} == '~' ]] && the_new_dir="${HOME}${the_new_dir:1}"

  #
  # Now change to the new dir and add to the top of the stack
  pushd "${the_new_dir}" > /dev/null
  [[ $? -ne 0 ]] && return 1
  the_new_dir=$(pwd)

  #
  # Trim down everything beyond 11th entry
  popd -n +11 2>/dev/null 1>/dev/null

  #
  # Remove any other occurence of this dir, skipping the top of the stack
  for ((cnt=1; cnt <= 10; cnt++)); do
    x2=$(dirs +${cnt} 2>/dev/null)
    [[ $? -ne 0 ]] && return 0
    [[ ${x2:0:1} == '~' ]] && x2="${HOME}${x2:1}"
    if [[ "${x2}" == "${the_new_dir}" ]]; then
      popd -n +$cnt 2>/dev/null 1>/dev/null
      cnt=cnt-1
    fi
  done

  return 0
}

function my_git_delete_mklocal() {
    files=$(git br | grep mklocal | grep -v "\*");for file in $files; do git branch -D $file; done;
}
function my_git_delete_pnval() {
    files=$(git br | grep PNVAL | grep -v "\*");for file in $files; do git branch -D $file; done;
}
function sshlab () {
	if [ -z ${2+x} ]; then
		~/test.exp $1; else
		ssh -p 830 diag@$1; fi
}

function my_scp_file_to_device() {
    scp -P 225 $1 diag@$2:
}

function my_scp_file_from_device() {
    scp -P 225 diag@$1:$2 . 
}

function my_gdb() {
	/localdisk/hmuresan/yocto/source/valimar/meta-evernight/scripts/en-dbg -n --gdb=/bin/cgdb --ip=$1 --pid=$2
}

function my_gdb2() {
	/localdisk/hmuresan/yocto/source/valimar2/meta-evernight/scripts/en-dbg -n --gdb=/bin/cgdb --ip=$1 --pid=$2
}

function my_update_emacs_env() {
    fn=tempfile
    printenv -0 > "$fn" 
    emacsclient -s server -e '(sp00ky-update-env "'"$fn"'")' >/dev/null
}

function my_gtagsbdb_noemacupdate () {
    build_dir=/localdata/hmuresan/yocto/builds/valimar2/cn-container-hal-dnx-docker-x86-64
    if [ -z $1 ]
    then
        build_dir=/localdisk/hmuresan/yocto/builds/valimar/cn-container-hal-dnx-docker-x86-64
    fi

    my_update_gtags.sh $1
}

function my_gtagsbdb () {
    build_dir=/localdata/hmuresan/yocto/builds/valimar2/cn-container-hal-dnx-docker-x86-64
    if [ -z $1 ]
    then
        build_dir=/localdisk/hmuresan/yocto/builds/valimar/cn-container-hal-dnx-docker-x86-64
    fi

    my_update_gtags.sh $1
    export GTAGSLIBPATH=${build_dir}
    my_update_emacs_env
}

function my_gtagsbdbemacs () {
    build_dir=/localdata/hmuresan/yocto/builds/valimar2/cn-container-hal-dnx-docker-x86-64
    if [ -z $1 ]
    then
        build_dir=/localdisk/hmuresan/yocto/builds/valimar/cn-container-hal-dnx-docker-x86-64
    fi

    export GTAGSLIBPATH=${build_dir}
    echo ${GTAGSLIBPATH}
    my_update_emacs_env
}

#export PS1='$(whoami):$(pwd) $ '
#export PS1='\033[32m$(whoami)@$(hostname)\033[36m:$(pwd) \$\033[00m '
export PS1='\[\033[38;5;226m\]$(pwd) \[\033[00m\]\n\$ '

complete -cf sudo
set -o vi
export PATH=$PATH:/home/hmuresan/my_execs/usr/local/bin/:/home/hmuresan/ybin:/home/hmuresan/my_execs/bin:/localdisk/hmuresan/my_execs/bin
export YOCTO_DIR=/localdisk/hmuresan/yocto
export ENDBG_WSDIR=/localdisk/yocto_debugging
export DVTM_EDITOR=vis
#export TERM=xterm-256color

source ~/scripts/git-completion.bash
