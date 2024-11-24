## Use the Python 3.11 slim image as base
FROM python:3.11-slim

## Set the working directory inside the container
WORKDIR /app

## Install system dependencies
## libpq-dev is added to the image as that is a requirment for psycopg
## the other libs are required for Wagtail/Django 
RUN apt-get update && apt-get install -y \
    build-essential \
    libpq-dev \
    libjpeg62-turbo-dev \
    zlib1g-dev \
    libwebp-dev \
    && rm -rf /var/lib/apt/lists/*

## this file replaces the SQLite references in ./$SITE_NAME/settings/base.py
COPY replace_sqlite.py .

## install the dependencies and create the image with wagtail!
RUN pip install wagtail==6.2.3 "psycopg2>=2.9,<3"

## Expose port 8000 (Django default)
EXPOSE 8000
