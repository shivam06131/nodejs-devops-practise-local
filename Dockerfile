# Build Stage (Install dependencies)
FROM node:18 AS builder
WORKDIR /usr/src/app
COPY package*.json ./
RUN npm ci

# Runner Stage (Final image)
FROM node:18-alpine
WORKDIR /usr/src/app
COPY --from=builder /usr/src/app/node_modules ./node_modules
COPY . .

# Expose port and start command (rest remains the same)
EXPOSE 4000
CMD ["npm", "run" , "start:dev"]
