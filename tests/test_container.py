import pytest
import docker

# This is a pytest fixture. It runs once per session, starts the container,
# passes the container object to the tests, and then stops/removes it after.
@pytest.fixture(scope="session")
def container():
    """Starts a container from the test image and cleans it up afterward."""
    client = docker.from_env()
    # Run the container in detached mode
    container_obj = client.containers.run("pr-scan-image:latest", detach=True)
    # Yield control to the tests
    yield container_obj
    # Teardown: stop and remove the container
    print("\nCleaning up container...")
    container_obj.stop()
    container_obj.remove()

# Test that the container is not running as the root user.
def test_non_root_user(container):
    """Verify the container's current user UID is not 0."""
    exit_code, output = container.exec_run("id -u")
    assert exit_code == 0
    # The output from exec_run is bytes, so we decode it and strip whitespace.
    user_id = output.decode('utf-8').strip()
    assert user_id != "0"

# Test that unnecessary, privileged commands like 'sudo' are not installed.
def test_sudo_not_installed(container):
    """Verify that 'sudo' is not present in the container's PATH."""
    # 'which' exits with a non-zero code if the command is not found.
    exit_code, output = container.exec_run("which sudo")
    assert exit_code != 0

# Test that there are no unexpected listening network ports.
def test_no_listening_ports(container):
    """Verify that there are no listening TCP sockets."""
    # 'netstat -tln' lists listening TCP sockets.
    # The 'busybox' version in Alpine doesn't error on an empty result.
    exit_code, output = container.exec_run("netstat -tln")
    assert exit_code == 0
    # The output header is present, but no other lines should contain "LISTEN".
    # We count lines containing "LISTEN" and assert that it's 0.
    listen_count = output.decode('utf-8').upper().count("LISTEN")
    assert listen_count == 0
