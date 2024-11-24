#!/bin/bash

SITE_NAME="mynewssite"

# Check if the Wagtail project directory exists
if [ ! -d "/app/$SITE_NAME" ]; then
    echo "Wagtail project not found. Creating new project..."
    
    ## Run Wagtail start to create the project using the wagtail-news-template 
    wagtail start --template=https://github.com/torchbox/wagtail-news-template/archive/refs/heads/main.zip $SITE_NAME 

    ## Change into the new project directory $SITE_NAME
    cd /app/$SITE_NAME

    ## Install the required Python packages for the current site
    pip3 install -r requirements.txt

    ## Change the database from sqlite to postgresql
    echo "About to replace sqlite to postgresql"
    python ../replace_sqlite.py ./$SITE_NAME/settings/base.py

    ## for wagtail-news-template
    make load-data
    
fi

## Start the Django development server in the foreground (important!)
cd /app/$SITE_NAME
echo "Starting Django development server..."

make start 

