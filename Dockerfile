# First stage: Build the application
FROM node:18-slim AS builder

# Set the working directory inside the container
WORKDIR /usr/src/app

# Copy package.json and package-lock.json files and install dependencies
COPY package.json package-lock.json ./
RUN npm ci

# Copy the rest of the application code and build the app
COPY . .
RUN npm run build

# Second stage: Create the final image
FROM node:18-slim

# Set the working directory inside the container
WORKDIR /usr/src/app

# Copy only the build output and package.json files from the builder stage
COPY --from=builder /usr/src/app/build ./build
COPY package.json package-lock.json ./

# Install only production dependencies
RUN npm ci --only=production && npm cache clean --force

# Install nodemon globally
RUN npm install -g nodemon && npm cache clean --force

# Expose the port the app runs on
EXPOSE 4000

# Define the command to run the application
CMD ["npm", "run", "start:dev"]
