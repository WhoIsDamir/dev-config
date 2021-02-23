#fish settings

function fish_greeting
end

# exports
set -x EDITOR code

# aliases
alias edit="$EDITOR"
alias sf="source ~/.config/fish/config.fish"
alias ef="$EDITOR ~/.config/fish/config.fish"
alias efc="cd ~/.config/fish"
alias vga="lspci -k | grep -A 2 -E '(VGA|3D)'"
alias iip="curl --max-time 10 -w '\n' http://ident.me"
alias speedtest="curl -s https://raw.githubusercontent.com/sivel/speedtest-cli/master/speedtest.py | python -"
alias ..="cd .."
alias ...="cd ../.."
alias q="exit"

# Develop
alias pa="php artisan"
alias lar="cd ~/Work/laravel"
alias cgr="cd ~/Work/codeguru"

alias cwtext="cd ~/Work/codeguru/cwtext"

alias qant="cd ~/Work/qant"
alias qfront="cd ~/Work/qant/q.framework/frontend"
alias qproto="cd ~/Work/qant/q.framework/frontend/protocol"
alias qback="cd ~/Work/qant/q.framework/backend"
alias qlab="cd ~/Work/qant/q.projects/lab.codeguru"
alias qimclog="cd ~/Work/qant/q.projects/logistics.imc"
alias cwt="cd ~/Work/qant/q.projects/cwt"
alias qchal="cd ~/Work/qant/q.projects/challenge"
alias qassistant="cd ~/Work/qant/q.assistant/"
alias qcache="./assistant cache:clear"
alias qimp="./assistant data:synch import"
alias qexp="./assistant data:synch export"
alias qdump="./assistant server:dump --format=html"
alias qbuild="./assistant front:build --dev"
alias qinspect="./assistant orm:inspect"

# systemctl
alias sysre="sudo systemctl restart"
alias sysstatus="sudo systemctl status"
alias sysstart="sudo systemctl start"
alias sysstop="sudo systemctl stop"
alias sysen="sudo systemctl enable"
alias sysdis="sudo systemctl disable"

function sedit
    sudo code $argv --user-data-dir
end

# functions
function unpack -d "extract files from archives"
    # no arguments, write usage
    if test (count $argv) -eq 0
        echo "Usage: extract [-option] [file ...]\n Options:\n -r, --remove    Remove archive after unpacking." >&2
    end

    set remove_file 0
    if test $argv[1] = "-r"; or test $argv[1] = "--remove"
        set remove_file 1
        set --erase argv[1]
    end

    for i in $argv[1..-1]
        if test ! -f $i
            echo "extract: '$i' is not a valid file" >&2
            continue
        end

        set success 0
        set extension (string match -r ".*(\.[^\.]*)\$" $i)[2]
        switch $extension
            case '*.tar.gz' '*.tgz'
                tar xv; or tar zxvf "$i"
            case '*.tar.bz2' '*.tbz' '*.tbz2'
                tar xvjf "$i"
            case '*.tar.xz' '*.txz'
                tar --xz -xvf "$i"; or xzcat "$i" | tar xvf -
            case '*.tar.zma' '*.tlz'
                tar --lzma -xvf "$i"; or lzcat "$i" | tar xvf -
            case '*.tar'
                tar xvf "$i"
            case '*.gz'
                gunzip -k "$i"
            case '*.bz2'
                bunzip2 "$i"
            case '*.xz'
                unxz "$i"
            case '*.lzma'
                unlzma "$i"
            case '*.z'
                uncompress "$i"
            case '*.zip' '*.war' '*.jar' '*.sublime-package' '*.ipsw' '*.xpi' '*.apk' '*.aar' '*.whl'
                set extract_dir (string match -r "(.*)\.[^\.]*\$" $i)[2]
                unzip "$i" -d $extract_dir
            case '*.rar'
                unrar x -ad "$i"
            case '*.7z'
                7za x "$i"
            case '*'
                echo "extract: '$i' cannot be extracted" >&2
                set success 1
        end

        if test $success -eq 0; and test $remove_file -eq 1
            rm $i
        end
    end
end

starship init fish | source