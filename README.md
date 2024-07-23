# Go Docker App

This project demonstrates how to create a simple Go application, containerize it using Docker, and apply security and resource constraints. The application serves a "Hello, World!" message and is configured with various Docker settings to ensure security and efficient resource management.

## Table of Contents

- [Project Overview](#project-overview)
- [Prerequisites](#prerequisites)
- [Setup Instructions](#setup-instructions)
- [Build and Run the Docker Container](#build-and-run-the-docker-container)
- [Resource Constraints and Security](#resource-constraints-and-security)

## Project Overview

This project includes:
- A simple Go web application that responds with "Hello, World!".
- A Dockerfile for building and running the Go application in a container.
- Configuration to run the container with various security and resource constraints.

## Prerequisites

Before you begin, ensure you have the following installed:
- [Go](https://golang.org/dl/) (version 1.20 or compatible)
- [Docker](https://docs.docker.com/get-docker/) (latest version recommended)
- [Trivy](https://aquasecurity.github.io/trivy/latest/) (for image scanning, optional)

## Setup Instructions

1. **Clone the Repository**



Create the Dockerfile

Create a file named Dockerfile with the following content:

Dockerfile
Copier le code
# Build stage
```sh 
FROM golang:1.20 AS builder
WORKDIR /app
COPY . .
RUN go build -o app .
'''

# Final stage
```sh
FROM debian:slim
WORKDIR /app
'''

# Create a non-root user
```sh
RUN useradd -m nonroot
USER nonroot
'''
# Copy the built application
```sh
COPY --from=builder /app/app .
'''
# Set the application to run on a read-only file system
```sh
VOLUME [ "/data" ]

# Expose port 8080
EXPOSE 8080

# Drop all capabilities and set CPU limit
ENTRYPOINT [ "sh", "-c", "exec /app/app" ]
'''
Build and Run the Docker Container
Build the Docker Image

sh
Copier le code
docker build -t go-docker-app .
Run the Docker Container

sh
Copier le code
'''
docker run -d \
    --name go-docker-app \
    --read-only \
    --cap-drop=ALL \
    --cpu-period=100000 \
    --cpu-quota=50000 \
    -p 8080:8080 \
    go-docker-app
'''
Resource Constraints and Security
The container is configured with the following constraints:

Read-Only Filesystem: The container's filesystem is set to read-only to enhance security.
No Root User: The application runs as a non-root user to minimize security risks.
Dropped Capabilities: All unnecessary Linux capabilities are dropped using --cap-drop=ALL.
CPU Limits: CPU usage is limited to 50% of a single core using --cpu-period and --cpu-quota.
