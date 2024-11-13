import sys
import os
import re

def replace_sqlite_with_postgres(settings_file_path):
    # Define the new PostgreSQL DATABASES configuration
    new_databases_config = """
DATABASES = {
    'default': {
        'ENGINE': 'django.db.backends.postgresql',
        'NAME': os.getenv('POSTGRES_DB', 'mydatabase'),
        'USER': os.getenv('POSTGRES_USER', 'myuser'),
        'PASSWORD': os.getenv('POSTGRES_PASSWORD', 'mypassword'),
        'HOST': os.getenv('POSTGRES_HOST', 'localhost'),
        'PORT': os.getenv('POSTGRES_PORT', '5432'),
    }
}
"""

    # Read in the original base.py file
    with open(settings_file_path, "r") as file:
        content = file.read()

    # Use regex to find and replace the DATABASES block
    content = re.sub(
        r"DATABASES\s*=\s*\{.*?\n\}",  # Match DATABASES block (non-greedy to stop at the first closing brace)
        new_databases_config.strip(),  # Replacement with the new PostgreSQL configuration
        content,
        flags=re.DOTALL
    )

    # Write the modified content back to base.py
    with open(settings_file_path, "w") as file:
        file.write(content)

if __name__ == "__main__":
    # Ensure the script is called with the settings file path
    if len(sys.argv) != 2:
        print("Usage: python replace_sqlite.py <path_to_base.py>")
        sys.exit(1)

    settings_file_path = sys.argv[1]

    # Call the function to replace the DATABASES block
    if os.path.exists(settings_file_path):
        replace_sqlite_with_postgres(settings_file_path)
        print(f"Replaced DATABASES block in {settings_file_path}")
    else:
        print(f"File {settings_file_path} not found!")
        sys.exit(1)
