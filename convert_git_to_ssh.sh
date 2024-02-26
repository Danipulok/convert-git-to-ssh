#!/bin/bash

# Configuration variables
DEPTH=3                     # depth to search repositories for
BASE_DIR="."                # base directory
ENABLE_SSH_CONVERSION=false # true/false

# Log function
log() {
    echo "[LOG] $1"
}

# Convert HTTPS to SSH for a git directory
convert_git_to_ssh() {
    local dir="$1"
    pushd "$dir" > /dev/null || return 1
    if git remote -v | grep -q '^origin.*https://'; then
        local https_url=$(git remote get-url origin)
        local ssh_url=$(convert_url_to_ssh "$https_url")

        if [[ "$ENABLE_SSH_CONVERSION" == "true" ]]; then
            git remote set-url origin "$ssh_url"
        fi

        log "Converted to SSH in: $dir: $ssh_url"
    else
        log "No HTTPS remote found in: $dir"
    fi
    popd > /dev/null
}

# Recursively find and convert git directories
find_and_convert_git() {
    local current_depth="$1"
    local dir="$2"
    if [[ $current_depth -le 0 ]]; then
        return
    fi
    if [[ -d "$dir/.git" ]]; then
        convert_git_to_ssh "$dir"
    fi
    for subdir in "$dir"/*/; do
        if [[ -d "$subdir" ]]; then
            find_and_convert_git $((current_depth - 1)) "$subdir"
        fi
    done
}

# Convert HTTPS URL to SSH URL
convert_url_to_ssh() {
    local https_url="$1"

    # Return original if not an HTTPS URL
    if ! [[ "$https_url" =~ ^https:// ]]; then
        echo "Not an HTTPS URL, returning original: $https_url" >&2
        echo "$https_url"
        return
    fi

    # Extract server and project path, removing any username from the URL
    # This pattern matches the server and the project path from the URL
    if ! [[ "$https_url" =~ ^https://([^/]+)/(.+)$ ]]; then
        echo "Failed to parse URL: $https_url" >&2
        echo "$https_url"
    fi

    local server="${BASH_REMATCH[1]}"
    local project="${BASH_REMATCH[2]}"

    # Remove optional username from server
    server=$(echo "$server" | sed -E 's/[^@]*@(.*)/\1/')

    # Ensure project ends with .git
    if ! [[ "$project" =~ \.git$ ]]; then
        project="${project}.git"
    fi

    local ssh_url="git@$server:$project"
    echo "$ssh_url"
}


# Test function for URL conversion
test_convert_url() {
    local test_url="$1"
    local expected="$2"
    local result=$(convert_url_to_ssh "$test_url")
    if [[ "$result" == "$expected" ]]; then
        echo "PASS: $test_url -> $result"
    else
        echo "FAIL: $test_url -> $result (Expected: $expected)"
    fi
}

# Running tests with various URL formats.
run_tests() {
    log "Running tests..."
    
    # GitHub URLs
    test_convert_url "https://github.com/exampleuser/project.git" "git@github.com:exampleuser/project.git"  # simple url
    test_convert_url "https://user@github.com/project.git" "git@github.com:project.git"  # url with user
    test_convert_url "https://user@github.com/project" "git@github.com:project.git"  # test adding .git
    
    # GitLab URLs
    test_convert_url "https://gitlab.com/exampleuser/project.git" "git@gitlab.com:exampleuser/project.git"  # simple url
    test_convert_url "https://user@gitlab.com/project.git" "git@gitlab.com:project.git"  # url with user
    test_convert_url "https://user@gitlab.com/project" "git@gitlab.com:project.git"  # test adding .git
    
    # Bitbucket URLs
    test_convert_url "https://bitbucket.org/exampleuser/project.git" "git@bitbucket.org:exampleuser/project.git"  # simple url
    test_convert_url "https://user@bitbucket.org/project.git" "git@bitbucket.org:project.git"  # url with user
    test_convert_url "https://user@bitbucket.org/project" "git@bitbucket.org:project.git"  # test adding .git
}

# Main function to encapsulate the script's logic
main() {
    echo "Running tests..."
    run_tests

    log "Starting script..."
    find_and_convert_git "$DEPTH" "$BASE_DIR" || { log "An error occurred. Exiting."; exit 1; }
}

# Execute the main function
main