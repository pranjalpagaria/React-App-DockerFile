# Use the official Node.js image as the base image
FROM node:18-alpine AS builder

# Set the working directory inside the container
WORKDIR /app

# Copy package.json and package-lock.json to the working directory
COPY package*.json ./

# Install dependencies, ignoring peer dependency issues
RUN npm install --legacy-peer-deps

# Copy the rest of the application code and build it
COPY . .
RUN npm run build

# Use an Nginx image to serve the build files
FROM nginx:alpine

# Copy the build files to Nginx's default location
COPY --from=builder /app/build /usr/share/nginx/html

# Expose the port that Nginx will run on
EXPOSE 80

# Start Nginx when the container launches
CMD ["nginx", "-g", "daemon off;"]

