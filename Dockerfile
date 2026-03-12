# Simple Python base image
FROM python:3.9-slim

# Install basic utilities
RUN apt-get update && apt-get install -y --no-install-recommends \
    curl \
    wget \
    ca-certificates \
    && rm -rf /var/lib/apt/lists/*

# Optional: upgrade pip
RUN pip install --no-cache-dir --upgrade pip

# Set default working directory
WORKDIR /app

# Default python settings
ENV PYTHONUNBUFFERED=1 \
    PYTHONDONTWRITEBYTECODE=1
