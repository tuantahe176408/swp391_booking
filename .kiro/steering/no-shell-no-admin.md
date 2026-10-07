# Environment Constraints

## Machine limitations

- **No admin rights**: The developer's machine does not have administrator privileges. Do NOT suggest or run commands that require elevation (e.g., installing software system-wide, modifying system PATH, writing to Program Files, running as Administrator).
- **No PowerShell execution**: PowerShell commands cannot be executed in this environment. Do NOT attempt to run PowerShell, CMD, or bash commands via the terminal tool. Other shell-based verification (e.g., reading files, searching code) is done through dedicated IDE tools instead.

## What this means in practice

- Do NOT use `execute_pwsh` or any terminal tool to run commands.
- Build/compile verification is done manually by the developer in NetBeans — do not run `ant`, `mvn`, or similar build tools.
- Do not run `git` commands on behalf of the developer unless explicitly asked.
- Do not install dependencies, run scripts, or execute anything in a shell.
- When a task would normally end with "run `ant clean build` to verify", instead state: "Build and verify manually in NetBeans."
- Focus on correctness of source code edits; trust the developer to compile and test.
- File reading, searching, and editing use dedicated tools (`read_file`, `grep_search`, `str_replace`, etc.) — not shell commands.
