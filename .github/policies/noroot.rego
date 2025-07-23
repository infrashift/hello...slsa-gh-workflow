package main

# Deny if the USER instruction is completely missing.
deny[msg] {
    # Get a list of all commands that are 'user'.
    user_cmds := [c | c := input[_]; c.cmd == "user"]
    count(user_cmds) == 0
    msg = "Containerfile must specify a non-root user with the USER instruction."
}

# Deny if the final USER instruction is 'root' or '0'.
deny[msg] {
    user_cmds := [c | c := input[_]; c.cmd == "user"]
    count(user_cmds) > 0 # Only run if a USER command exists.
    
    # Get the last USER command in the file.
    last_user_cmd := user_cmds[count(user_cmds) - 1]
    user := lower(last_user_cmd.value[0])
    
    # Check if the user is root or uid 0.
    user == "root" or user == "0"
    msg = sprintf("Containerfile's final USER instruction cannot be '%s'. Specify a non-root user.", [last_user_cmd.value[0]])
}
