# --------------------------------------------------
# Build Stage - Compile Go application
# --------------------------------------------------
FROM golang:1.22.5 as base

# Set working directory
WORKDIR /app

# Copy go mod and sum files
COPY go.mod .

# Download dependencies
RUN go mod download

# Copy application source
COPY . .

# Build Go binary
RUN go build -o main .

# --------------------------------------------------
# Final Stage - Use Distroless image for security
# --------------------------------------------------
FROM gcr.io/distroless/base

# Copy binary and static files
COPY --from=base /app/main .
COPY --from=base /app/static ./static

# Expose application port
EXPOSE 9090

# Command to run
CMD ["./main"]
