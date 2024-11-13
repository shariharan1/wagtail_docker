# Use the Python 3.11 slim image as base
FROM python:3.11-slim

# Set the working directory inside the container
WORKDIR /app

# Install system dependencies
RUN apt-get update && apt-get install -y \
    build-essential \
    libpq-dev \
    && rm -rf /var/lib/apt/lists/*

# Install Python dependencies
COPY pre-reqs.txt .
COPY replace_sqlite.py .

RUN pip install --no-cache-dir -r pre-reqs.txt

# Copy the rest of the application files into the container
COPY . .

# Set the entrypoint to the script
ENTRYPOINT ["/bin/bash", "/app/entrypoint.sh"]

# Expose port 8000 (Django default)
EXPOSE 8000

# Default command to run once the container starts
CMD ["bash"]
