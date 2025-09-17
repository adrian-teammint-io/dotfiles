oh-my-posh init fish --config ~/.config/oh-my-posh/themes/star.omp.json | source

if status is-interactive
    clear
    # Commands to run in interactive sessions can go here
end

abbr --add ga git add . abbr --add gc git commit
abbr --add gps git push
abbr --add gpl git pull
abbr --add v nvim
abbr --add x exit

abbr --add config_fish nvim /Users/adrian-phan.team-mint.io/.config/fish/config.fish
abbr --add config_ghostty nvim /Users/adrian-phan.team-mint.io/.config/ghostty/config
abbr --add config_yazi nvim /Users/adrian-phan.team-mint.io/.config/yazi/

export EDITOR=nvim

function fish_greeting
    echo " "
    echo "  안녕하세요 Adrian!"
    echo " "
end

# ------------------------------------------------------------

zoxide init fish | source
fzf --fish | source
string match -q "$TERM_PROGRAM" kiro and . (kiro --locate-shell-integration-path fish)

# ------------------------------------------------------------

# Yazi
function y
    set tmp (mktemp -t "yazi-cwd.XXXXXX")
    yazi $argv --cwd-file="$tmp"
    if read -z cwd <"$tmp"; and [ -n "$cwd" ]; and [ "$cwd" != "$PWD" ]
        builtin cd -- "$cwd"
    end
    rm -f -- "$tmp"
end

# Generate password by argon2
function argon2_genpass
    # Check if username is provided
    if test (count $argv) -eq 0
        echo "Usage: argon2_genpass 'username'"
        return 1
    end

    # Generate password and output only the hash
    echo -n $argv[1] | argon2 (openssl rand -base64 16) -id -m 16 -t 3 -p 4 -l 32 -e
end

# Randomize oh-my-posh theme and update line 120 in this file
function omp_random_theme
    set -l themes_dir ~/.config/oh-my-posh/themes
    set -l config_file ~/.config/fish/config.fish

    # Collect all *.omp.json themes, excluding schema.json (quietly)
    set -l themes (command find $themes_dir -type f -name '*.omp.json' 2>/dev/null | string match -v "$themes_dir/schema.json")
    if test (count $themes) -eq 0
        echo "No .omp.json themes found in $themes_dir"
        return 1
    end

    # Pick a random theme
    set -l idx (random 1 (count $themes))
    set -l picked (basename $themes[$idx])

    # Build the new init line
    set -l new_line "oh-my-posh init fish --config ~/.config/oh-my-posh/themes/$picked | source"

    # Overwrite line 1 in-place using ed (robust to slashes)
    printf '%s\n' 1c "$new_line" '.' wq | ed -s $config_file

    oh-my-posh init fish --config ~/.config/oh-my-posh/themes/$picked | source

    echo " "
    echo "✅ Switched to theme: $picked"
    echo " "
end
