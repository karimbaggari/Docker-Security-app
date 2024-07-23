# Build stage
FROM golang:1.20-alpine AS builder
WORKDIR /app
COPY . .
RUN go build -o app .

# Final stage
FROM alpine:3.18
WORKDIR /app

# Create a non-root user
RUN adduser -D nonroot
USER nonroot

# Copy the built application
COPY --from=builder /app/app .

# Set the application to run on a read-only file system
VOLUME [ "/data" ]

# Expose port 8080
EXPOSE 8080

# Drop all capabilities and set CPU limit
ENTRYPOINT [ "sh", "-c", "exec /app/app" ]
