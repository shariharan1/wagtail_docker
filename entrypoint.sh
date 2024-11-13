#!/bin/bash

# Check if the Wagtail project directory exists
if [ ! -d "/app/mysite" ]; then
    echo "Wagtail project not found. Creating new project..."
    
    # Run Wagtail start to create the project
    wagtail start mysite

    # Run database migrations
    cd /app/mysite

    echo "About to replace sqlite to postgresql"
    python ../replace_sqlite.py ./mysite/settings/base.py

    echo "About to migrate DB"
    python manage.py migrate
    
    # Create a superuser (customize this as needed)
    echo "Creating superuser..."
    echo "from django.contrib.auth import get_user_model; User = get_user_model(); User.objects.create_superuser('admin', 'admin@example.com', 'password123')" | python manage.py shell
fi

# Start the Django development server in the foreground (important!)
cd /app/mysite
echo "Starting Django development server..."
python manage.py runserver 0.0.0.0:8000