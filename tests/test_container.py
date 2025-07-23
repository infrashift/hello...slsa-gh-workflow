import pytest

# Test that the container is not running as the root user.
def test_non_root_user(host):
    user = host.user()
    assert user.name != "root"
    assert user.uid != 0

# Test that unnecessary, privileged commands like 'sudo' are not installed.
def test_sudo_not_installed(host):
    assert not host.package("sudo").is_installed

# Test that there are no unexpected listening network ports.
def test_no_listening_ports(host):
    listening = host.socket.get_listening_sockets()
    # Fails if any listening sockets are found.
    # Adjust if your container is expected to listen on a port.
    assert not listening
