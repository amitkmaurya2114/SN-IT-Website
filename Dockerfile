# Use the official Python image from the Docker Hub
FROM python:3.11-slim

# Set environment variables to prevent Python from writing .pyc files and to enable unbuffered output
ENV PYTHONDONTWRITEBYTECODE=1
ENV PYTHONUNBUFFERED=1

# Set the working directory in the container
WORKDIR /app

# Install system dependencies for mysqlclient and other packages
RUN apt-get update && apt-get install -y \
    default-libmysqlclient-dev \
    gcc \
    && rm -rf /var/lib/apt/lists/*

# Upgrade pip
RUN pip install --upgrade pip

# Copy the application code and requirements file into the container
COPY . /app

# Install the required Python packages
RUN pip install  -r requirements.txt

# Expose the port the app runs on (default Django port is 8000)
EXPOSE 8000

# Ensure the database socket file is accessible
ENV MYSQL_UNIX_PORT=/var/run/mysqld/mysqld.sock

# Command to run the application
CMD ["python3", "manage.py", "runserver", "0.0.0.0:8000"]
