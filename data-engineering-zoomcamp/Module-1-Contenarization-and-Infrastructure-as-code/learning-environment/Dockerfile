FROM python:3.13-slim

# Installing uv by copying the binary from the official image
COPY --from=ghcr.io/astral-sh/uv:latest /uv /uvx /bin/

# Setting up working directory
WORKDIR /app

ENV PATH="/app/.venv/bin:$PATH"

# Copying dependency files
COPY pyproject.toml uv.lock ./

# Installing dependencies using uv on the system Python
RUN uv sync --no-dev --locked
COPY ingest_data.py ./

ENTRYPOINT ["python", "ingest_data.py"]