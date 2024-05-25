# Use an official Node.js runtime as a parent image
FROM node:18

# Set the working directory inside the container
WORKDIR /usr/src/app

# Define build arguments
ARG PORT
ARG TESTENV

RUN echo PORT
RUN echo TESTENV

# Copy package.json and package-lock.json files
COPY package.json /usr/src/app/package.json
COPY package-lock.json /usr/src/app/package-lock.json
RUN npm ci

# Copy the rest of the application code
COPY . .

# Expose the port the app runs on
# EXPOSE ${APP_PORT}
EXPOSE 4000

# Define the command to run the application
CMD ["node", "server.js"]
