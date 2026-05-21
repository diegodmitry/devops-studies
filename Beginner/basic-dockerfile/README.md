# Basic Dockerfile

This project demonstrates how to create a basic **Dockerfile** to build a Docker image that prints a greeting message to the console.

[Basic Dockerfile Project](https://roadmap.sh/projects/basic-dockerfile)

## Objective

Learn how to:

- Create a basic `Dockerfile`
- Use a lightweight base image
- Build a Docker image
- Run a Docker container
- Print a message to the console before the container exits
- Optionally customize the greeting using an environment variable

---

## Technologies Used

- 🐳 Docker
- 🐧 Alpine Linux

---

## Project Requirements

- The Dockerfile must be named `Dockerfile`
- The Dockerfile must be in the root directory of the project
- The base image must be `alpine:latest`
- The container should print `Hello, Captain!` to the console before exiting

---

## Project Structure

```bash
basic-dockerfile/
├── Dockerfile
└── README.md
```

---

## Dockerfile

Create a file named `Dockerfile` in the root directory of the project:

```dockerfile
FROM alpine:latest

ENV NAME=Captain

CMD echo "Hello, $NAME!"
```

Alternative `CMD` syntax:

```dockerfile
FROM alpine:latest

ENV NAME=Captain

CMD ["/bin/sh", "-c", "echo Hello, $NAME!"]
```

---

## How It Works

### `FROM alpine:latest`

Uses the latest version of Alpine Linux as the base image.

Alpine is a lightweight Linux distribution commonly used to create small Docker images.

### `ENV NAME=Captain`

Creates an environment variable called `NAME` with the default value `Captain`.

### `CMD echo "Hello, $NAME!"`

Runs the command when the container starts.

By default, it prints:

```bash
Hello, Captain!
```

After printing the message, the container exits automatically.

---

## Build the Docker Image

Run the following command in the root directory of the project:

```bash
docker build -t basic-dockerfile .
```

---

## Run the Docker Container

```bash
docker run basic-dockerfile
```

Expected output:

```bash
Hello, Captain!
```

---

## Optional: Customize the Name

You can override the default `NAME` environment variable when running the container:

```bash
docker run -e NAME=Lemon basic-dockerfile
```

Expected output:

```bash
Hello, Lemon!
```

---

## Minimal Version

If you want to follow only the basic requirement, the Dockerfile can also be written like this:

```dockerfile
FROM alpine:latest

CMD echo "Hello, Captain!"
```

---

## Outcome

By the end of this project:

- You created a Dockerfile from scratch
- You used `alpine:latest` as the base image
- You built a Docker image using `docker build`
- You ran a Docker container using `docker run`
- You printed a message to the console before the container exited
- You optionally customized the greeting using an environment variable

---

## Credits

Project inspired by the [roadmap.sh](https://roadmap.sh/) DevOps learning path.