# Stage 1: Builder
FROM python:3.11-slim as builder

# Set environment variables
ENV PYTHONDONTWRITEBYTECODE=1 \
    PYTHONUNBUFFERED=1

# Set work directory
WORKDIR /app

# Install system dependencies if needed (e.g., gcc for C Extensions, but we are keeping it minimal)
RUN apt-get update && \
    apt-get install -y --no-install-recommends gcc python3-dev && \
    rm -rf /var/lib/apt/lists/*

# Install dependencies into a virtualenv or to /install
# (Using virtualenv simplifies copying to the next stage)
RUN python -m venv /opt/venv
ENV PATH="/opt/venv/bin:$PATH"

COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt


# Stage 2: Runtime
FROM python:3.11-slim

# Set environment variables
ENV PYTHONDONTWRITEBYTECODE=1 \
    PYTHONUNBUFFERED=1 \
    PATH="/opt/venv/bin:$PATH"

# Set work directory
WORKDIR /app

# Create a non-root user
RUN useradd -m -u 1000 appuser && \
    chown 1000:1000 /app

# Copy virtualenv from builder stage
COPY --from=builder /opt/venv /opt/venv

# Copy application files (Copying only what's needed is handled by .dockerignore)
# COPY --chown=appuser:appuser . .
COPY . .
RUN chown -R appuser:appuser /app

# Use non-root user
USER appuser

# Expose app port
EXPOSE 8000

# Run the command
CMD ["uvicorn", "main:app", "--host", "0.0.0.0", "--port", "8000"]
