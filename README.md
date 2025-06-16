# Fudo API

A Ruby-based API service with authentication and product management.

## Prerequisites

- Docker
- Docker Compose

## Getting Started

1. Clone the repository:
```bash
git clone <repository-url>
cd charlab-entrevista-fudo
```

2. Start the services:
```bash
docker compose up --build
```

This will start:
- Web server (port 9292)
- Redis (port 6379)
- Sidekiq worker

## API Documentation

The API documentation is available in OpenAPI format:
```bash
curl -X GET http://localhost:9292/openapi.yaml
```

## Development

The project uses:
- Ruby 3.1.2
- Rack for the web server
- Redis for background jobs
- Sidekiq for job processing
- JWT for authentication

## License

See the AUTHORS file for details. 