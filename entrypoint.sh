#!/bin/bash

SITE_NAME="mynewssite"

# Check if the Wagtail project directory exists
if [ ! -d "/app/$SITE_NAME" ]; then
    echo "Wagtail project not found. Creating new project..."
    
    # Run Wagtail start to create the project
    # wagtail start $SITE_NAME
    wagtail start --template=https://github.com/torchbox/wagtail-news-template/archive/refs/heads/main.zip $SITE_NAME 

    # Run database migrations
    cd /app/$SITE_NAME

    pip3 install -r requirements.txt

    echo "About to replace sqlite to postgresql"
    python ../replace_sqlite.py ./$SITE_NAME/settings/base.py

    make load-data

    # echo "About to migrate DB"
    # python manage.py migrate
    
    # Create a superuser (customize this as needed)
    # echo "Creating superuser..."
    # echo "from django.contrib.auth import get_user_model; User = get_user_model(); User.objects.create_superuser('admin', 'admin@example.com', 'password123')" | python manage.py shell
fi

# Start the Django development server in the foreground (important!)
cd /app/$SITE_NAME
echo "Starting Django development server..."
#make start 
python manage.py runserver 0.0.0.0:8000
