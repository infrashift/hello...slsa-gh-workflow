# Use a minimal but functional base image like Alpine
FROM alpine:latest

# Good practice: Create a non-root user and group
RUN addgroup -S nonroot && adduser -S nonroot -G nonroot

# Switch to the non-root user.
USER nonroot

# Use a long-running command to keep the container alive for testing.
CMD ["tail", "-f", "/dev/null"]
