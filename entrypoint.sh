#!/bin/bash

# Check if the Wagtail project directory exists
if [ ! -d "/app/$SITE_NAME" ]; then
    echo "Wagtail project not found. Creating new project..."
    
    # Run Wagtail start to create the project
    wagtail start $SITE_NAME

    ## Change into the new project directory $SITE_NAME
    cd /app/$SITE_NAME

    ## Install the required Python packages for the current site
    pip3 install -r requirements.txt

    ## Change the database from sqlite to postgresql
    echo "About to replace sqlite to postgresql"
    python ../replace_sqlite.py ./$SITE_NAME/settings/base.py

    ## echo "About to migrate DB"
    python manage.py migrate
    
    ## Create a superuser (customize this as needed)
    echo "Creating superuser..."
    echo "from django.contrib.auth import get_user_model; User = get_user_model(); User.objects.create_superuser('$SITE_ADMIN_USER', '$SITE_ADMIN_USER', '$SITE_ADMIN_PASSWORD')" | python manage.py shell
fi

## Start the Django development server in the foreground (important!)
cd /app/$SITE_NAME
echo "Starting Django development server..."
python manage.py runserver 0.0.0.0:8000
