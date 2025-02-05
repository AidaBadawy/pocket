# Use the official Go image for building
FROM golang:1.23 as build

# Set the working directory inside the container
WORKDIR /app

# Copy go.mod and go.sum for dependency resolution
COPY go.mod go.sum ./

# Download dependencies
RUN go mod download

# Copy the rest of the application code
COPY . .

# Build the PocketBase binary with the app name pocket-nujud
RUN CGO_ENABLED=0 GOOS=linux GOARCH=amd64 go build -o pocket_nujud main.go

# Use a lightweight image for running the application
FROM alpine:3.18

# Install required CA certificates
RUN apk add --no-cache ca-certificates

# Copy the built binary from the builder stage
COPY --from=build /app/pocket_nujud /pocket_nujud

# Copy the preconfigured database folder
COPY pb_data /pb_data

# Ensure the binary has execute permissions
RUN chmod +x /pocket_nujud

# Expose the default PocketBase port
EXPOSE 8090

# Run the application
CMD ["/pocket_nujud", "serve", "--dir", "/pb_data", "--encryptionEnv", "PB_ENCRYPTION_KEY", "--http", "0.0.0.0:8090"]