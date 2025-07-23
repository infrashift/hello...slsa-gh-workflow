package main

# Deny if the USER instruction is completely missing.
deny[msg] {
    # Make the command check case-insensitive.
    user_cmds := [c | c := input[_]; lower(c.cmd) == "user"]
    count(user_cmds) == 0
    msg = "Containerfile must specify a non-root user with the USER instruction."
}

# Deny if the final USER instruction is 'root' or '0'.
deny[msg] {
    # Make the command check case-insensitive here as well.
    user_cmds := [c | c := input[_]; lower(c.cmd) == "user"]
    count(user_cmds) > 0 # Only run if a USER command exists.
    
    # Get the last USER command in the file.
    last_user_cmd := user_cmds[count(user_cmds) - 1]
    user := lower(last_user_cmd.value[0])
    
    # Check if user is a member of the set {"root", "0"}.
    {"root", "0"}[user]
    
    msg = sprintf("Containerfile's final USER instruction cannot be '%s'. Specify a non-root user.", [last_user_cmd.value[0]])
}
