# Use a minimal but functional base image like Alpine
FROM alpine:latest

# Good practice: Create a non-root user and group
RUN addgroup -S nonroot && adduser -S nonroot -G nonroot

# Switch to the non-root user. This is what testinfra will check.
USER nonroot

# Define the default command
CMD ["echo", "Hello from a secure, non-root Alpine container!"]FROM redhat/ubi9:latest
