# Use the official Node.js base image
FROM nginx

# Set the working directory in the container
WORKDIR /app

# Copy the current directory contents into the container at /app
COPY . /app

# Install the required dependencies
RUN npm install

# Set the command to run your application
CMD ["npm", "start"]
