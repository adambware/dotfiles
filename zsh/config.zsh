HISTFILE=~/.zsh_history
HISTSIZE=10000
SAVEHIST=10000

setopt NO_BG_NICE       # don't nice background tasks
setopt NO_CHECK_JOBS    # don't warn about bg tasks when exiting
setopt NO_HUP           # and don't kill them either
setopt NO_LIST_BEEP     # don't beep on ambiguous completion
setopt LOCAL_OPTIONS    # allow functions to have local options
setopt LOCAL_TRAPS      # allow functions to have local traps
setopt PROMPT_SUBST     # parameter, command, and arithmetic substitutions
setopt CORRECT          # try to correct command spelling
setopt COMPLETE_IN_WORD # cursor stays, do completion from both ends
setopt IGNORE_EOF       # don't exit on EOF
setopt COMPLETE_ALIASES # don't expand aliases _before_ completion has finished

setopt HIST_VERIFY            # don't execute history line directly
setopt SHARE_HISTORY          # share history between sessions
setopt EXTENDED_HISTORY       # add timestamps to history
setopt APPEND_HISTORY         # adds history
setopt INC_APPEND_HISTORY     # adds history incrementally and share it across sessions
setopt HIST_IGNORE_ALL_DUPS   # don't record dupes in history
setopt HIST_REDUCE_BLANKS     # remove extra blanks


#zle -N newtab
#
#bindkey '^[^[[D' backward-word
#bindkey '^[^[[C' forward-word
#bindkey '^[[5D' beginning-of-line
#bindkey '^[[5C' end-of-line
#bindkey '^[[3~' delete-char
#bindkey '^[^N' newtab
#bindkey '^?' backward-delete-char
