#!/bin/bash

# Meant to automatically reload the bash profile in your currently open shells
# whenever it got changed

# Change that to "$HOME/.bashrc" or whatever is relevant for you
_ARP_WATCH_PATH="$HOME/.bash_profile"

# GNU or BSD stat?
stat -c %Y /dev/null > /dev/null 2>&1 && _ARP_STAT_COMMAND='stat -c %Y' || _ARP_STAT_COMMAND='stat -f %m'

_ARP_reload_profile_if_needed()
{
    local LAST_PROFILE_CHANGE
    LAST_PROFILE_CHANGE=$($_ARP_STAT_COMMAND "$_ARP_WATCH_PATH")
    if [ "$_ARP_LAST_PROFILE_RELOAD" ]; then
        # nothing to do, except if the profile was changed since last time we reloaded it
        [ $LAST_PROFILE_CHANGE -gt "$_ARP_LAST_PROFILE_RELOAD" ] || return 0
        . $_ARP_WATCH_PATH
        _ARP_LAST_PROFILE_RELOAD=$LAST_PROFILE_CHANGE
    else
        # $_ARP_LAST_PROFILE_RELOAD not defined yet, must be the first time we run this
        # function, the shell must be brand new, nothing no do
        _ARP_LAST_PROFILE_RELOAD=$LAST_PROFILE_CHANGE
    fi
    return 0
}

export PROMPT_COMMAND="_ARP_reload_profile_if_needed;$PROMPT_COMMAND"
