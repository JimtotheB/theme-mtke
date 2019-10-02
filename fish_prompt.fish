# name: mtke

set _mtke_orange FFA500
set _mtke_purple 8A2BE2


function _mtke_truncate_dir -a path truncate_to -d "Truncate a directory path"
	if test "$truncate_to" -eq 0
		echo -n $path
	else
		set -l folders (string split / $path)

		if test (count $folders) -le "$truncate_to"
			echo -n $path
    else if [ "$path" = "$HOME" ]
        echo -n '~'
		else
			echo -n (string join / $folders[(math 0 - $truncate_to)..-1])
		end
	end
end

function _node_version
    if test -d "$PWD/node_modules"
      if test -n "$NODE_ENV"
    
        set local_node_env $NODE_ENV
      end
  
      set local_node_version (node -v)
      set_color normal
      set_color green
      echo -n ' ⬢:('
      set_color magenta
      echo -n $local_node_env ''
      set_color $_mtke_orange
      echo -n $local_node_version
      set_color green
      echo -n ') '
      set_color normal
  end
end

function _node_package
  if test -f "$PWD/package.json"
		set local_package_version (grep '"version":' package.json | cut -d\" -f4 2> /dev/null)
		set local_package_name (grep '"name":' package.json | cut -d\" -f4 2> /dev/null)
    echo -n " 📦"
    set_color $_mtke_orange
    echo -n ":("
    set_color $_mtke_purple
    echo -n $local_package_name@$local_package_version
    set_color $_mtke_orange
    echo -n ") "
    set_color normal
    
  end
end

function _git_prompt
  if git_is_repo
    set -l untracked (git ls-files --other --exclude-standard| wc -l | string trim -l -r )
    set_color -o brblue
    echo -n ' git:('
    set_color red
    
    echo -n (git_branch_name)
    
    set_color -o blue
    echo -n ') '
    
    if git_is_dirty
     set_color -o yellow
     echo -n '✗ '
    else 
     set_color -o green
     echo -n '✓ '
    end
    
    if [ $untracked -ne 0 ] 
     set_color normal
     set_color red
     echo -n $untracked'? '
    end
    
    if git_is_staged
     set_color normal
     set -l stage (git diff --cached --numstat | wc -l | string trim -l)
     set_color cyan
     echo -n $stage
     echo -n '!'
     
    end
    
    set_color normal
  end
end

function fish_prompt
  set -l exit_code $status
  if test $exit_code -ne 0
      set -g next_prompt_arrows red
      set -g right_exit_value $exit_code "↵"
  else
      set -g next_prompt_arrows green
      set -g right_exit_value "ok"
  end
  
  set_color $next_prompt_arrows
  echo -n '╭─ 🐟 '
  set_color -o cyan
  echo -n (whoami)
  
  # set_color $fish_color_autosuggestion[1]
  echo -n '@'
  set_color cyan
  echo -n (hostname|cut -d . -f 1)
  set_color normal
  
  set_color -o yellow
  echo -n ' '
  _mtke_truncate_dir (pwd) 2
  echo -n ' '
  # echo -n (prompt_pwd)
  
  _node_version
  _node_package
  _git_prompt
  
  # set_color -o cyan
#   echo -n (__fish_git_prompt)
#   set_color -o cyan
  set_color normal
  # set_color $fish_color_autosuggestion[1]
  
  echo ($PWD)
  set_color normal
  set_color $next_prompt_arrows
  echo -n
  echo -n  '╰─➤ '
  
  
  
  
  set_color normal
end

# git_prompt_info () {
#   local ref
#   if [[ "$(command git config --get oh-my-zsh.hide-status 2>/dev/null)" != "1" ]]
#   then
#     ref=$(command git symbolic-ref HEAD 2> /dev/null)  || ref=$(command git rev-parse --short HEAD 2> /dev/null)  || return 0
#     echo "$ZSH_THEME_GIT_PROMPT_PREFIX${ref#refs/heads/}$(parse_git_dirty)$ZSH_THEME_GIT_PROMPT_SUFFIX"
#   fi
# }
