# Use Python base image
# Use an official Python runtime as a parent image
FROM python:3.9-slim

# Set working directory
# Set the working directory in the container
WORKDIR /app

# Install dependencies
# Copy the requirements file into the container at /app
COPY requirements.txt .
RUN pip install -r requirements.txt

# Copy source code
# Install any needed packages specified in requirements.txt
RUN pip install --no-cache-dir -r requirements.txt

# Copy the rest of the application code into the container at /app
COPY . .

# Expose port
EXPOSE 5000

# Run app
# Command to run the app (this will be overridden by docker-compose.test.yml for testing)
CMD ["python", "app.py"]
