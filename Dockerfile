# Containerize the go application that we have created
# This is the Dockerfile that we will use to build the image
# and run the container


#Base Stage
# Start with a base image
FROM golang:1.21.10 as base

# Set the working directory inside the container
WORKDIR /app

# Copy the go.mod and go.sum files to the working directory(go.mod has all the dependencies )
COPY go.mod ./

# Download all the dependencies
RUN go mod download

# Copy the source code to the working directory
COPY . .

# Build the application(when u build the application it will create a binary file called main that we will use in next stage)
RUN go build -o main .

#######################################################
#Final stage with distroless image
# Reduce the image size using multi-stage builds
# We will use a distroless image(comparetively light weight images than base img used in build) to run the application
FROM gcr.io/distroless/base

# Copy the binary(main) from the previous stage
COPY --from=base /app/main .

# Copy the static files from the previous stage
COPY --from=base /app/static ./static

# Expose the port on which the application will run
EXPOSE 8080

# Command to run the application
CMD ["./main"]  