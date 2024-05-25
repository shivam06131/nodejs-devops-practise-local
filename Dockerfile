# Use an official Node.js runtime as a parent image
FROM node:18

# Set the working directory inside the container
WORKDIR /usr/src/app

# Define build arguments
ARG NODE_ENV
ARG APP_PORT\

# Copy package.json and package-lock.json files
COPY package*.json .

# Install dependencies
RUN npm install

# Copy the rest of the application code
COPY . .

# Expose the port the app runs on
EXPOSE ${APP_PORT}

# Define the command to run the application
CMD ["node", "server.js"]
