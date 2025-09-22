oh-my-posh init fish --config ~/.config/oh-my-posh/themes/sim-web.omp.json | source

if status is-interactive
    clear
    # Commands to run in interactive sessions can go here
end

abbr --add ga git add . abbr --add gc git commit
abbr --add gps git push
abbr --add gpl git pull
abbr --add gco git checkout origin
abbr --add nd npm run dev

abbr --add v nvim
abbr --add x exit

abbr --add config_fish nvim /Users/adrian-phan.team-mint.io/.config/fish/config.fish
abbr --add config_ghostty nvim /Users/adrian-phan.team-mint.io/.config/ghostty/config
abbr --add config_yazi nvim /Users/adrian-phan.team-mint.io/.config/yazi/

export EDITOR=nvim

function fish_greeting
    random choice "안녕하세요 Adrian!" "Hello Adrian!" "Bonjour Adrian!" "Hallo Adrian!" "Ciao Adrian!" "Hola Adrian!" "Olá Adrian!" "Merhaba Adrian!" "こんにちは Adrian!" "你好 Adrian!" "안녕하세요 Adrian!" "Hello Adrian!" "Bonjour Adrian!" "Hallo Adrian!" "Ciao Adrian!" "Hola Adrian!" "Olá Adrian!" "Merhaba Adrian!" "こんにちは Adrian!" "你好 Adrian!"
end

function fish_title
    # `prompt_pwd` shortens the title. This helps prevent tabs from becoming very wide.
    echo $argv[1] (prompt_pwd)
    pwd
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

# Generate commit message with AI
function ai_commit_msg
    set -l output ""
    set -l branch_name (git branch --show-current)

    set output $output "Write me a commit message based on these code changes."
    set output $output ""
    set output $output "Current branch: $branch_name"
    set output $output ""

    # Branch-specific context based on common branch naming patterns
    if string match -q "feat/*" $branch_name
        set output $output "This appears to be a feature branch. Focus on the new functionality being added."
    else if string match -q "fix/*" $branch_name
        set output $output "This appears to be a bug fix branch. Focus on what issue is being resolved."
    else if string match -q "hotfix/*" $branch_name
        set output $output "This appears to be a hotfix branch. Focus on the critical issue being fixed urgently."
    else if string match -q "refactor/*" $branch_name
        set output $output "This appears to be a refactoring branch. Focus on code improvements without changing functionality."
    else if string match -q "chore/*" $branch_name
        set output $output "This appears to be a maintenance branch. Focus on build, tooling, or configuration changes."
    else if string match -q "docs/*" $branch_name
        set output $output "This appears to be a documentation branch. Focus on documentation updates."
    else if string match -q "test/*" $branch_name
        set output $output "This appears to be a testing branch. Focus on test improvements or additions."
    else if string match -q "style/*" $branch_name
        set output $output "This appears to be a styling branch. Focus on UI/UX improvements or code formatting."
    else if string match -q "perf/*" $branch_name
        set output $output "This appears to be a performance branch. Focus on performance improvements."
    else
        set output $output "Consider the branch name '$branch_name' when writing the commit message."
    end

    set output $output ""
    set output $output "Before writing the commit message, review the code changes (and possibly make some changes to the code if needed):"
    set output $output "- No log statements (console.log, console.error, console.warn, console.info, console.debug, etc.)."
    set output $output "- No unnecessary comments."
    set output $output "- No duplicate imports."
    set output $output "- The code should be clean, easy to understand and readable."

    set output $output ""
    set output $output "About the commit message:"
    set output $output "- It should be a conventional concise-short-clear commit message."
    set output $output "- The content should have proper markdown syntax, for example name of component should wrapped in '``'."
    set output $output "- Tailor the message to match the branch type and purpose."
    set output $output "- Write the commit message in ``` ```, do not explain or anything."

    set output $output ""
    set output $output "=== GIT DIFF FOR AI COMMIT MESSAGE ==="

    # Show current branch and status
    set output $output ""
    set output $output "Branch: $branch_name"
    set output $output "Status:"
    set output $output (git status --porcelain)

    # Show staged changes
    set output $output ""
    set output $output "=== STAGED CHANGES ==="
    set output $output (git diff --cached)

    # Show unstaged changes
    set output $output ""
    set output $output "=== UNSTAGED CHANGES ==="
    set output $output (git diff)

    # Show recent commits for context
    set output $output ""
    set output $output "=== RECENT COMMITS (for context) ==="
    set output $output (git log --oneline -5)

    set output $output "=== END GIT DIFF ==="

    # Copy to clipboard
    printf '%s\n' $output | pbcopy

    set remote_url (git remote get-url origin)
    set repo_name (string replace -r '.*[:/](.*?)(\.git)?$' '$1' $remote_url)

    echo " "
    echo "✨ $repo_name § $branch_name's commit message copied to clipboard!"
    echo " "
end

function pull_commit
    git pull origin (git branch --show-current)
    git add .
    git commit
end

function checkout
    git pull origin
    git checkout -b $argv
    npm run dev
end

# Main 'f' command with autocompletion
function f
    switch $argv[1]
        case ai_commit_msg
            ai_commit_msg
        case pull_commit
            pull_commit
        case '*'
            echo "Unknown option: $argv[1]"
            echo "Available options:"
            echo "  ai_commit_msg  - Generate AI commit message"
            echo "  pull_commit    - Pull and commit"
    end
end
