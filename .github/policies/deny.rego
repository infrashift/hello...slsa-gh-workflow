package grype.authz

# By default, the decision is to allow (an empty 'deny' set).
default deny = false

# The 'deny' rule will be true if the set of violations is not empty.
deny {
	# 'count(violations) > 0' makes the 'deny' rule true if any violations are found.
	count(violations) > 0
}

# 'violations' is a set of messages describing each High or Critical CVE found.
violations[msg] {
	# Find any match in the input CVE report.
	some match in input.matches

	# Check if the severity is High or Critical.
	is_high_or_critical(match.vulnerability.severity)

	# If the condition is met, create a descriptive error message.
	msg := sprintf("Vulnerability %s has forbidden severity '%s'", [
		match.vulnerability.id,
		match.vulnerability.severity,
	])
}

# Helper function to check severity.
is_high_or_critical(severity) {
	severity == "High"
}
is_high_or_critical(severity) {
	severity == "Critical"
}
