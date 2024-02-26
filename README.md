# Git HTTPS to SSH Converter 🔄

Transform your git repositories from HTTPS to SSH effortlessly! This handy Bash script automates the conversion, enhancing your development workflow with added security and efficiency. 🚀

## Features

- **Recursive Search** 🔍: Seamlessly locates and switches all git repositories within a specified directory to SSH.
- **Depth Control** 🎚️: Fine-tune the search depth to optimize processing.
- **SSH Conversion Toggle** 🔑: Empower yourself to convert repositories to SSH as per your preference.
- **Verbose Logging** 📝: Detailed logs provide insights into the conversion process, aiding in tracking and troubleshooting.

## Configuration Variables

- `DEPTH`: Controls how deep the script searches for git repositories. Default is `3`, striking a perfect balance in search depth. 🔍
- `BASE_DIR`: The starting point of the search. It's set to the current directory (`"."`) by default, but feel free to change it as needed. 📂
- `ENABLE_SSH_CONVERSION`: Toggle this to `true` to activate SSH conversion, or keep it `false` for a dry run. A great feature for testing outcomes before full commitment. 🚥

## How to Use

1. **Get the Script**: Clone or download this script onto your local system for a quick start.
    Example:
    ```bash
    wget https://raw.githubusercontent.com/YourUsername/convert-git-to-ssh/master/convert_git_to_ssh.sh -O convert_git_to_ssh.sh
    ```
    Or, if you prefer `curl`:
    ```bash
    curl -o convert_git_to_ssh.sh https://raw.githubusercontent.com/YourUsername/convert-git-to-ssh/master/convert_git_to_ssh.sh
    ```

2. **Set It Up**: Before running, tailor the script to your needs by adjusting the `DEPTH`, `BASE_DIR`, and `ENABLE_SSH_CONVERSION` variables directly in the script.

3. **Launch**: Execute the script with:
    ```bash
    chmod +x convert_git_to_ssh.sh && ./convert_git_to_ssh.sh
    ```
    This command ensures the script is executable and then runs it, kickstarting the conversion process.

## Detailed Functionality

- `log`: Logs messages, keeping you informed every step of the way.
- `convert_git_to_ssh`: Targets a single git directory for HTTPS to SSH conversion.
- `find_and_convert_git`: Dives into directories up to the specified depth, converting eligible git repos.
- `convert_url_to_ssh`: Morphs an HTTPS URL into its SSH equivalent effortlessly.
- `test_convert_url`: Validates the URL conversion logic against a series of test scenarios.
- `run_tests`: Runs predefined tests to guarantee the URL conversion's reliability.
- `main`: Initiates the script, conducting tests before embarking on the SSH conversion journey.

## Join the Effort

Got ideas for enhancement? Spot a bug? Jump in on the action! Fork the repo, make your changes, and hit us with a pull request. Your contributions make a difference! 🤝

## License

Dive in and explore! This script is shared under the MIT license, allowing for free use, modification, and distribution. 📜

---

Here's to more secure and efficient coding! 💻✨
