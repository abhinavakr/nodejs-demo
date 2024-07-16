# Use the official Nginx image from Docker Hub
FROM nginx:alpine

# Copy custom configuration file from the current directory
COPY default.conf /etc/nodejs-demo/conf.d/

# Copy website files from the current directory
COPY index.html /usr/share/nodejs-demo/html/
